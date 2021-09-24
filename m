Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C176417E37
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 01:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236992AbhIXXcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 19:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbhIXXcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 19:32:41 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECB9C061571
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 16:31:07 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id c21so2291530wrb.13
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 16:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GqZeA34g+PTtS9vxOWyDlA/b9i9OPS+4sVJlXqOJs9A=;
        b=C6ThtuoBmix6FYu83kbezzPSbfwJ28lbagMxmRVlfziBKJn1iYK0NQNSitYWfv7mlC
         lGHL46fFshZgrbpNOFt3w2dl1kIAxO8uSXZmAGUUPIDlQCg+cKLyd2RHfl3EjHQr5l/+
         FG2iqtc5epcU9ymLFf/mvoCGMwdg0esMPUQZTX9dFXSQv0jtfGe/TnOiuQffN5Z04DkM
         7N5PD5iacdunFYG4QPp122xsb0+bBmdAcGb3yqWMlYozMrXj/wx7Revb9hOeE5lVKZPb
         o8Czla5JiXvF+eLOqypYAVuUT+T8h6WrMB7KKfcz4bHiGMOlHHUT/lnFykRdqNG/OfHA
         n0OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GqZeA34g+PTtS9vxOWyDlA/b9i9OPS+4sVJlXqOJs9A=;
        b=x/lsiNKBX5UNkRA33t+wok3THFZgMOE9dBAYVDbwSVkg+6aMkL00LU5lKAuYlPT/I0
         FufdmBBNzXsVPvnePaMNOUrTxX3QUVca+ptuB3PnW+8l2pGqWT0/CkFBy3oi3XyDM+dU
         TG7mgpBa7V2OfmIzROPSJoK9s+bregqhCiUFqEC4E81hzVoP5dzs2ZwMZSYTJbCdTFlt
         LKMjG7iKeenc0v4v9qT+9QnrlVtq3H+CfbGCmdQtgDsdf3n2mJN1epk2FzjEMZNXDlvB
         jJ0scIEUbBmd4+HVzNPz2FR4HOfolr9cvP3KVF5jI9POr0fbzsAtiTtc62cPG3WNCRSi
         FTGg==
X-Gm-Message-State: AOAM532atuF8C+cETITcPlrTTF0kGBs45mhQpQ/ViPS/wkloNEoHckTm
        sOhKxaC83SWldZJGxua4J4Qj7tgHFcf+iPsE2/hm6Q==
X-Google-Smtp-Source: ABdhPJx8LIDoeKjlWKDfbaescxUb80+TVMp7FQQ2uFsOVoxrNgE4yc9Uy35zw5qUCRZ7CvR9zxAMTPbHGnzU1cux7pc=
X-Received: by 2002:a7b:cd0d:: with SMTP id f13mr4431413wmj.183.1632526265933;
 Fri, 24 Sep 2021 16:31:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210923211706.2553282-1-luke.w.hsiao@gmail.com> <20210924132005.264e4e2d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210924132005.264e4e2d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Fri, 24 Sep 2021 16:30:28 -0700
Message-ID: <CAK6E8=dH8JYrKcO8tAUbzy6nT=w0eqjAZCnNwWg8qKUMqcwHbQ@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: tracking packets with CE marks in BW rate sample
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Luke Hsiao <luke.w.hsiao@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Luke Hsiao <lukehsiao@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 24, 2021 at 1:20 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 23 Sep 2021 21:17:07 +0000 Luke Hsiao wrote:
> > From: Yuchung Cheng <ycheng@google.com>
> >
> > In order to track CE marks per rate sample (one round trip), TCP needs a
> > per-skb header field to record the tp->delivered_ce count when the skb
> > was sent. To make space, we replace the "last_in_flight" field which is
> > used exclusively for NV congestion control. The stat needed by NV can be
> > alternatively approximated by existing stats tcp_sock delivered and
> > mss_cache.
> >
> > This patch counts the number of packets delivered which have CE marks in
> > the rate sample, using similar approach of delivery accounting.
>
> Is this expected to be used from BPF CC? I don't see a user..
Great question. Yes the commit message could be more clear that this
intends for both ebpf-CC or other third party module that use ECN. For
example bbr2 uses it heavily (bbr2 upstream WIP). This feature is
useful for congestion control research which many use ECN as core
signals now.

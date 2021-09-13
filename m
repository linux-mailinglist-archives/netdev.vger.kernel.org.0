Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67EE40990E
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 18:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237621AbhIMQ3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 12:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhIMQ3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 12:29:18 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E29C061574
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 09:28:03 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id g11so8609515qtk.5
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 09:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lCEFVZk5i5JKojQwLeOtjBnnKOvBoEkkMn4Juu4EKEk=;
        b=M5KDl4gzEd95nvJA0nz4dmxaCbyWEAZFPM4PSrzlSNWI+qFaYnwQE20CKYIj4oyJRC
         c8gbfivlGaZhDXENieazTRfZpY7l4q7eNYW4ftQw0IcsIpXkOH84/XXelH3czQLEMxNQ
         Y9bqxoo2bDjfVcQg/HLoDTiJeC9V4pTFNkfDwD872sGyrHznFUG6yfHLOOc+1PEV1Y1L
         nBTC8SUjvO3dIXwQp2m9YDyT/4Tjh/wCUWcc4+bKvWFlPAjit67NQDBiGKqMCRs/yPak
         DbEflIiqJdQXaDF/tUZdPXb93LpaNnZs1lFME0O8UeS7XylR3PNvk6C/V3hyYc26Rzsk
         89nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lCEFVZk5i5JKojQwLeOtjBnnKOvBoEkkMn4Juu4EKEk=;
        b=WaU5qN5cLQApAq1rqIOhtYItIN2EZjPqPuah3df1OccJ5r/MgvGV2DN9QOk62NzwfL
         uzA8QNmgBaSb9m7vdL/n7seJR0g5Lj3Gba3oa6avYdpLZZolteKYxIjAP3Ps3nsmP3WI
         NdD6XtVXwG/tVEPSg9xo3jIuM6jIMZo4Sei0+TyAWPaGyc0jsDR933pFR3T6Nbq0LM5f
         gEX71GvrX0LHoNxNw070Z6/w7f7OMZKw12l5vvfla2pF/rQfmn0C/h2yPXvdHNGPtblx
         n2Sywlravdg3XZrycUd9JuchesGrtUgTCvWL7ldJkQNLqC2eFfAYzNAA3Wbtg9H0FmZo
         FHhQ==
X-Gm-Message-State: AOAM5328EV4LWCxdyLAzmaX/9HaM+2IYHLNpGsYLjZUmsk+PQKpUQ77o
        9LtE89IzraKE8rAgIzStUyMRIUzG4LwmocInmse+Sg==
X-Google-Smtp-Source: ABdhPJzZZ0BjQzr1R2g+TerY7EjW8i4Dvz0evwcM8qCknWmSmozyjmKRwZgKqrAe3k3VU/fjzePx9fTbo0RDV1zMaWE=
X-Received: by 2002:a05:622a:1911:: with SMTP id w17mr440126qtc.228.1631550481906;
 Mon, 13 Sep 2021 09:28:01 -0700 (PDT)
MIME-Version: 1.0
References: <1630314010-15792-1-git-send-email-zhenggy@chinatelecom.cn>
 <CANn89iLMDQqVmhq38OhD3X1D93qzAye0AsQpZYdCi=fsLEuNsg@mail.gmail.com> <CAK6E8=fDRvd_qezt+Nxiru+aYH=aLFhSuYFQsZMHmzsKS2WWZg@mail.gmail.com>
In-Reply-To: <CAK6E8=fDRvd_qezt+Nxiru+aYH=aLFhSuYFQsZMHmzsKS2WWZg@mail.gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Mon, 13 Sep 2021 12:27:43 -0400
Message-ID: <CADVnQymAseByviwpgikUyZqOmvqvEVsRXiD-aHVFCnoPn4TrMQ@mail.gmail.com>
Subject: Re: [PATCH v3] tcp: fix tp->undo_retrans accounting in tcp_sacktag_one()
To:     Yuchung Cheng <ycheng@google.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        zhenggy <zhenggy@chinatelecom.cn>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, qitiepeng@chinatelecom.cn,
        wujianguo@chinatelecom.cn, liyonglong@chinatelecom.cn
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 12:11 PM Yuchung Cheng <ycheng@google.com> wrote:
>
> On Mon, Sep 13, 2021 at 8:49 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Mon, Sep 13, 2021 at 3:51 AM zhenggy <zhenggy@chinatelecom.cn> wrote:
> > >
> > > Commit 10d3be569243 ("tcp-tso: do not split TSO packets at retransmit
> > > time") may directly retrans a multiple segments TSO/GSO packet without
> > > split, Since this commit, we can no longer assume that a retransmitted
> > > packet is a single segment.
> > >
> > > This patch fixes the tp->undo_retrans accounting in tcp_sacktag_one()
> > > that use the actual segments(pcount) of the retransmitted packet.
> > >
> > > Before that commit (10d3be569243), the assumption underlying the
> > > tp->undo_retrans-- seems correct.
> > >
> > > Fixes: 10d3be569243 ("tcp-tso: do not split TSO packets at retransmit time")
> > >
> >
> > nit: We normally do not add an empty line between Fixes: tag and others.
> >
> > Reviewed-by: Eric Dumazet <edumazet@google.com>
> Acked-by: Yuchung Cheng <ycheng@google.com>
>
> This is a nice fix that would increase the effectiveness of TCP undo
> in high-speed networks.

Yes, thanks for the fix!

Acked-by: Neal Cardwell <ncardwell@google.com>

neal

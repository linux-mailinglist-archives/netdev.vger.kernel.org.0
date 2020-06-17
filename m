Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55C351FD308
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 19:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgFQRAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 13:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbgFQRAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 13:00:35 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF51C06174E;
        Wed, 17 Jun 2020 10:00:34 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id g2so1776787lfb.0;
        Wed, 17 Jun 2020 10:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hpv46MVpGznrve282OD9AABsHhzo5kEAV9FAN+EOhcs=;
        b=dqowQoYCthVBCfN1XzIxZwyErGKsnyQ4nKyajEz+2/DiD/Z4+UwfdCTFrvlcLUIw75
         U4hoveujBWbVmE7hHRETZGM1RKHZ/6T5o3jd4AJA0Pnd+yX0MW7HIN6LxEmOHVvMTK98
         htqaMy0jnkWrw75PskXf0zfrh5DJcfr/S+mq6i4Jw+wJg/vp8DcFyFP1ZLMzkz05L/NJ
         nPyCh9yRZ3PPb8mRHr8D18Ot/bzCYMib6XTq0bHOtjjbAzeybQ6AlAVzcuv0cvkXeUHf
         JqRFHHz35OkZvA1laatubHdByWuE58jukuntB/8YZ8pdOCdhCmDg0CwNSGYcDUZnj2/2
         Mi4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hpv46MVpGznrve282OD9AABsHhzo5kEAV9FAN+EOhcs=;
        b=cD8GTe0JvC/hBFeRpKKki6TRGx+rC7mNMp/BizgqzoE3T43Yh8rqyFHLgy7p7vV+qG
         DRt264P9kKqIsFg2ip4BoCQeNSlrW+vY0NVg8KrERnyZyQ9A+BdrT6s97m6IagNpQ7mw
         ssBmRoEPJd+rHeZzIE3H9P7g9xvLCzbaO7RKk0iGSBvn0gzxjBYHB5kJ+z9ieQvbX1VF
         788bJ4yjiMIGpeWTgKFTKVaNyb7dRmNg7u+xEFBlFxRhOjBFGJjQhaMEiXXlTG0KBH5W
         m9u94nRAp4jLytS7w90uwVSOid3+uzd3rV2GJdiQ/neRh5H+58L2H0TeCxcCy9mmuzVU
         booA==
X-Gm-Message-State: AOAM531uP4Tc4jZaKLM/FTrQGG4oxZEksKf42EFs4xpXKSqj52ya9RFt
        AYHTvCRzLbbvDZosCzU8mcCFNW0L7QapOoSBy2Q=
X-Google-Smtp-Source: ABdhPJxBrxK8hJxAKQ/K0aWdXmzkAQe1jOG752+Sk3C0mPTClOB07WUXlYlcr9jT5AkKBKkKQHeM98mDyxwxypV/dGo=
X-Received: by 2002:a19:815:: with SMTP id 21mr1678328lfi.119.1592413229398;
 Wed, 17 Jun 2020 10:00:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200616103518.2963410-1-liuhangbin@gmail.com>
 <20200616171233.1579d079@carbon> <5ee9b212af6a1_1d4a2af9b18625c434@john-XPS-13-9370.notmuch>
In-Reply-To: <5ee9b212af6a1_1d4a2af9b18625c434@john-XPS-13-9370.notmuch>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 17 Jun 2020 10:00:17 -0700
Message-ID: <CAADnVQ+0vFcvWt5E0VfjhMc-DEwZFjkv7h=BU9TBzKCkoAnMJg@mail.gmail.com>
Subject: Re: [PATCH bpf] xdp: handle frame_sz in xdp_convert_zc_to_xdp_frame()
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 11:03 PM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> Jesper Dangaard Brouer wrote:
> > On Tue, 16 Jun 2020 18:35:18 +0800
> > Hangbin Liu <liuhangbin@gmail.com> wrote:
> >
> > > In commit 34cc0b338a61 we only handled the frame_sz in convert_to_xdp_frame().
> > > This patch will also handle frame_sz in xdp_convert_zc_to_xdp_frame().
> > >
> > > Fixes: 34cc0b338a61 ("xdp: Xdp_frame add member frame_sz and handle in convert_to_xdp_frame")
> > > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> >
> > Thanks for spotting and fixing this! :-)
> >
> > Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> >
>
> Acked-by: John Fastabend <john.fastabend@gmail.com>

Applied. Thanks

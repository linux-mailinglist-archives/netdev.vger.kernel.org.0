Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6135414048
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 06:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbhIVEFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 00:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbhIVEFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 00:05:16 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC1B1C061574;
        Tue, 21 Sep 2021 21:03:46 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id s16so1624280pfk.0;
        Tue, 21 Sep 2021 21:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3EAX5x2paiUePsUWAPEUUmMCJozumvmbUt4cnBaQ4XU=;
        b=Rk9cx67V5kuhZ80gd5BegeY1K5IlGGUsG7P6cSYN7i0VaO/qXvs385+7Kc2LlDhbVJ
         2jHj7ebtGqbmJ/fNrWXdPn+22GiOpJS/QY6GEdZ/D2gbWCWmn25Utz8x6F6VzIeLnrJT
         e6EF0CYnI5H2MbH50Ex7n9D2+HhmomjcE0kX+rg/f9za7mf6987QpjhVwFRFwsuCbCuK
         b9uvu8Chn/4zBe30CJW3ZMK76jfT+PoiOJHo8jg+l+E2qDbEGX/kl0dO3XtVF9Q78S3/
         oeHyeatbQfGXY3t1NpKBaAic68hT2WEGRjEZbPVOODepMLaUSUEryU8TvvKJ2UXetoDh
         U2uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3EAX5x2paiUePsUWAPEUUmMCJozumvmbUt4cnBaQ4XU=;
        b=75SGUnz6vIPZrVkUkvsHfzM1JpOEsC95kBB2a0te57Y2x19xibK6FR3yPqv/M+wyeI
         Ti4KxbNyG23y/W53AcvSSjGsgyFnOMwIRmjszp9eP7+OoLH8XgiAU9v07qDwHdVpmMFv
         m4x1uG6DEFJenv1UgRg8el8ZLDPgPmE2bprMsPviGOwR6MQadtJa93zXp3jLSnILKN+9
         fQ0swNo4cjzP3F57/Tkxq2IBxz4St+rkJdJJ9imHMEplQVvIi8EpUC/JdSIFrixHmC/K
         TgVTgXqg1JKMe+JLZAueOmNgfRalarCsbPbVojjn1WdUs49kY7hWX4XdoldBA67JelBs
         5CMg==
X-Gm-Message-State: AOAM532leELO4VAGeTc5aW1CHXR/mVNcelbGq2gBTw6hRFptOTOnkM5p
        d7FiHAoP1wBTCWweOgQH6tejKgXRoVJ53Zb+NPI=
X-Google-Smtp-Source: ABdhPJw982+L2fNHEPQ8GplewO8OGfdWsW5Ka4MSd28P5pfEh5aBNbfkIZb2zyjfEHirQr3EB5rWank90umbmD/S55s=
X-Received: by 2002:a65:4008:: with SMTP id f8mr30578034pgp.310.1632283426301;
 Tue, 21 Sep 2021 21:03:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210913231108.19762-1-xiyou.wangcong@gmail.com>
 <CAADnVQJFbCmzoFM8GGHyLWULSmX75=67Tu0EnTOOoVfH4gE+HA@mail.gmail.com> <CAM_iQpX2prCpPDmO1U0A_wyJi_LS4wmd9MQiFKiqQT8NfGNNnw@mail.gmail.com>
In-Reply-To: <CAM_iQpX2prCpPDmO1U0A_wyJi_LS4wmd9MQiFKiqQT8NfGNNnw@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 21 Sep 2021 21:03:35 -0700
Message-ID: <CAADnVQJJHLuaymMEdDowharvyJr+6ta2Tg9XAR3aM+4=ysu+bg@mail.gmail.com>
Subject: Re: [RFC Patch net-next v2] net_sched: introduce eBPF based Qdisc
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 21, 2021 at 8:59 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Fri, Sep 17, 2021 at 11:18 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Mon, Sep 13, 2021 at 6:27 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > ---
> > > v2: Rebase on latest net-next
> > >     Make the code more complete (but still incomplete)
> >
> > What is the point of v2 when feedback on the first RFC was ignored?
>
> They are not ignored for two reasons:
>
> 1) I responded to those reasonable ones in the original thread. Clearly
> you missed them.

Multiple people in the v1 thread made it clear that the approach
presented in v1 is not generic enough. v2 made no attempt to
address these concerns.

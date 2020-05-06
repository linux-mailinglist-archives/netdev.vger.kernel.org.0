Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7541C79AB
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 20:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730476AbgEFSt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 14:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730112AbgEFStZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 14:49:25 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F0DC061A0F
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 11:49:24 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id z17so2248661oto.4
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 11:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DVPpSzSk9AOKCSii01Cyt4pisQUerWRcja2SR2dR4w8=;
        b=Owmhrq8Q3Lz5eoHbLDgumLMztPFDNJIk4NVbOTwcGBbsxbGsiT87ZZHLzlQOtzQ+wg
         tfBLNw9b9cnlOJScJaEhuXMnnwp8Ua8YsMY5GsaXn+Rs2qxAYD2ygTR6vE3841fVserK
         6IF9fiypmb9W/0atRnooW2QfbjI77RbK1ggy9v5q+XrJDGh0wbsP0j6GVVibv3jnO3Q5
         Ld3SXuTGKOyAPmi0khPaB9KgxupMHTqCcBHSy26Dax/nY001MYz1ojAV3nzicqLxHGBO
         mgteiVWrY3fSOHhEo1aQGuiSAfSoIFyrAXt3bjOzpule3QeN5SH38XsSR17EzFbTDE6v
         N+Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DVPpSzSk9AOKCSii01Cyt4pisQUerWRcja2SR2dR4w8=;
        b=gxq5WFgiw6BPOffeF2gk3wNers7qAfWaSJUvVqpS0zWACxc8gbnMH5dCiKcrMk78mX
         +ZSQmGIpjxdOiUBdfg4ZXw+7bmhqGQsZJ5+KJIyaTVzDLG1Fzwxtm/Yv0uRUIVnMv1nc
         vyjNxhdkz0bxo+FyBvnru7yM65KNL93av63ZKTMrLw6og6FhYmcrWG6sa5JtwraImaS7
         klRBDh5V5Ar3DmFstssRulyZCHmkOYBQ3WEWZHJb08IPdBlbXol1DNFgDkD5fZiMg+zK
         FIRwrdyfrmPhrksU+WpyvOKLyFKnQSzV8aYqcFIrVn7+6qPPJsXQ3ATLgYY0llm2COOO
         ejHw==
X-Gm-Message-State: AGi0PuYVsGxVdXWclhui31HBcBIkhSyvJhH1nTRnMWNnl2eSm0mopkyY
        4kQ+/X8SRgLYsZKPTH/cpPBw/AWHS24Zd+lIq3w=
X-Google-Smtp-Source: APiQypLnH7Sh8IERiYJr75hmt3eYU2m5UcMpGty3KnsDxeshp6XifAUXHRMPPnVa5Smma6EFFULTY5WCHTdNxPqv/Qc=
X-Received: by 2002:a9d:4a1:: with SMTP id 30mr7090626otm.319.1588790963645;
 Wed, 06 May 2020 11:49:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200505215819.1997-1-xiyou.wangcong@gmail.com>
 <2833.1588718397@famine> <CAM_iQpUiKS-dcC11uyb_jK+Uwu+AgGDQw_ytZKP8QxmkcmH4Xw@mail.gmail.com>
In-Reply-To: <CAM_iQpUiKS-dcC11uyb_jK+Uwu+AgGDQw_ytZKP8QxmkcmH4Xw@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 6 May 2020 11:49:12 -0700
Message-ID: <CAM_iQpUA_wcmo+d0jcb=G4WiQimJ3FcBiyx2H1fjQm9Xv8gSGg@mail.gmail.com>
Subject: Re: [Patch net] net: fix a potential recursive NETDEV_FEAT_CHANGE
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzbot <syzbot+e73ceacfd8560cc8a3ca@syzkaller.appspotmail.com>,
        syzbot+c2fb6f9ddcea95ba49b5@syzkaller.appspotmail.com,
        Jarod Wilson <jarod@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 6, 2020 at 11:46 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Tue, May 5, 2020 at 3:42 PM Jay Vosburgh <jay.vosburgh@canonical.com> wrote:
> >
> > Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > >syzbot managed to trigger a recursive NETDEV_FEAT_CHANGE event
> > >between bonding master and slave. I managed to find a reproducer
> > >for this:
> > >
> > >  ip li set bond0 up
> > >  ifenslave bond0 eth0
> > >  brctl addbr br0
> > >  ethtool -K eth0 lro off
> > >  brctl addif br0 bond0
> > >  ip li set br0 up
> >
> >         Presumably this is tied to the LRO feature being special in
> > netdev_sync_lower_features (via NETIF_F_UPPER_DISABLES), but why doesn't
> > LRO become disabled and stop the recursion once the test
> >
> >                 if (!(features & feature) && (lower->features & feature)) {
> >
> >         no longer evalutes to true (in theory)?
>
> Good point!
>
> Actually the LRO feature fails to disable:
>
> [   62.559537] netdevice: bond0: failed to disable 0x0000000000008000 on eth0!
> ...
> [   78.312003] netdevice: eth0: failed to disable LRO!
>
> It seems we should only skip netdev_update_features() for such case,
> like below. Note __netdev_update_features() intentionally returns -1
> for this failure, so I am afraid we just have to live with it.

Oops, I meant netdev_features_change() of course.

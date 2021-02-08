Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA63D313E79
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 20:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235974AbhBHTHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 14:07:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56006 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235858AbhBHTFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 14:05:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612811036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iubsdQyZmS7XuDNFEDT0FSf3h1hb0DtOamZ9SZHA6wY=;
        b=A+2OsWY7LiMfvSQ5wglgMtVX1+9kcbNN7gsQdtYodP1CiP9Ip70EyBQmYqVsgsErvr92wo
        XYs7kWhD8A37Sm7B5IsDgYNtgTMjQ5Ngx0vBLQiTuIZe5D+lHFzomamLg1qNucIEoJWADm
        gvLnuRWoEwO1H4lCvyWcLY4w+m6fTdU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468-bkhd1WQsM4SBV0HxWnoE9Q-1; Mon, 08 Feb 2021 14:03:54 -0500
X-MC-Unique: bkhd1WQsM4SBV0HxWnoE9Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD6CF36492;
        Mon,  8 Feb 2021 19:03:53 +0000 (UTC)
Received: from horizon.localdomain (ovpn-113-37.rdu2.redhat.com [10.10.113.37])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 761C360C04;
        Mon,  8 Feb 2021 19:03:53 +0000 (UTC)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 43CDDC00A2; Mon,  8 Feb 2021 16:03:51 -0300 (-03)
Date:   Mon, 8 Feb 2021 16:03:51 -0300
From:   Marcelo Ricardo Leitner <mleitner@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>, wenxu <wenxu@ucloud.cn>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH net v4] net/sched: cls_flower: Reject invalid ct_state
 flags rules
Message-ID: <20210208190351.GF2953@horizon.localdomain>
References: <1612674803-7912-1-git-send-email-wenxu@ucloud.cn>
 <CAM_iQpXojFaYogRu76=jGr6cp74YcUyR_ZovRnSmKp9KaugBOw@mail.gmail.com>
 <20210208104759.77c247c6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208104759.77c247c6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 10:47:59AM -0800, Jakub Kicinski wrote:
> On Mon, 8 Feb 2021 10:41:35 -0800 Cong Wang wrote:
> > On Sat, Feb 6, 2021 at 9:26 PM <wenxu@ucloud.cn> wrote:
> > > +       if (state && !(state & TCA_FLOWER_KEY_CT_FLAGS_TRACKED)) {
> > > +               NL_SET_ERR_MSG_ATTR(extack, tb,
> > > +                                   "ct_state no trk, no other flag are set");

This one was imported from OvS but it's not accurate.
Should be more like: no trk, so no other flag can be set
or something like that.

Seems it doesn't need to explicitly mention "ct_state" in the msg,
btw. I can't check it right now but all other uses of
NL_SET_ERR_MSG_ATTR are not doing it, at least in cls_flower.c.

> > > +               return -EINVAL;
> > > +       }
> > > +
> > > +       if (state & TCA_FLOWER_KEY_CT_FLAGS_NEW &&
> > > +           state & TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED) {
> > > +               NL_SET_ERR_MSG_ATTR(extack, tb,
> > > +                                   "ct_state new and est are exclusive");  
> > 
> > Please spell out the full words, "trk" and "est" are not good abbreviations.
> 
> It does match user space naming in OvS as well as iproute2:

I also think it makes sense as is.

> 
>         { "trk", TCA_FLOWER_KEY_CT_FLAGS_TRACKED },
>         { "new", TCA_FLOWER_KEY_CT_FLAGS_NEW },
>         { "est", TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED },
>         { "inv", TCA_FLOWER_KEY_CT_FLAGS_INVALID },
>         { "rpl", TCA_FLOWER_KEY_CT_FLAGS_REPLY },
> 
> IDK about netfilter itself.
> 


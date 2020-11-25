Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1688C2C352D
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 01:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgKYACM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 19:02:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:46976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727070AbgKYACM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 19:02:12 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10BF22145D;
        Wed, 25 Nov 2020 00:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606262531;
        bh=QvFvOpzNbVkTVaMl/BVjSM2x46W/RWWsxeEl70LOhck=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fgp8vDn8/WdjXeZRjR9NUfgcYUDE/CAxlniPbqcUfxnO4RKH0Hc/mQ1w8PvCwTaB7
         Fk5xbz4Y3QRvzrQh1edMl4XCSnRrkMmIV7XUHjHwvJqHef605pyXLqWSxtHkKgkra/
         hCM6blgMEMeG7+t5nxitEqNCiSAEIejDvmVXVLhI=
Date:   Tue, 24 Nov 2020 16:02:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     wenxu <wenxu@ucloud.cn>
Cc:     marcelo.leitner@gmail.com, vladbu@nvidia.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 3/3] net/sched: sch_frag: add generic packet
 fragment support.
Message-ID: <20201124160210.3648b823@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <e25b0a93-0fb1-60cf-9451-c82920c45076@ucloud.cn>
References: <1605829116-10056-1-git-send-email-wenxu@ucloud.cn>
        <1605829116-10056-4-git-send-email-wenxu@ucloud.cn>
        <20201124112430.64143482@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <e25b0a93-0fb1-60cf-9451-c82920c45076@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Nov 2020 07:10:43 +0800 wenxu wrote:
> =E5=9C=A8 2020/11/25 3:24, Jakub Kicinski =E5=86=99=E9=81=93:
> > On Fri, 20 Nov 2020 07:38:36 +0800 wenxu@ucloud.cn wrote: =20
> >> +int tcf_dev_queue_xmit(struct sk_buff *skb, int (*xmit)(struct sk_buf=
f *skb))
> >> +{
> >> +	xmit_hook_func *xmit_hook;
> >> +
> >> +	xmit_hook =3D rcu_dereference(tcf_xmit_hook);
> >> +	if (xmit_hook)
> >> +		return xmit_hook(skb, xmit);
> >> +	else
> >> +		return xmit(skb);
> >> +}
> >> +EXPORT_SYMBOL_GPL(tcf_dev_queue_xmit); =20
> > I'm concerned about the performance impact of these indirect calls.
> >
> > Did you check what code compiler will generate? What the impact with
> > retpolines enabled is going to be?
> >
> > Now that sch_frag is no longer a module this could be simplified.
> >
> > First of all - xmit_hook can only be sch_frag_xmit_hook, so please use
> > that directly.=20
> >
> > 	if (READ_ONCE(tcf_xmit_hook_count))=20
> > 		sch_frag_xmit_hook(...
> > 	else
> > 		dev_queue_xmit(...
> >
> > The abstraction is costly and not necessary right now IMO.
> >
> > Then probably the counter should be:
> >
> > 	u32 __read_mostly tcf_xmit_hook_count;
> >
> > To avoid byte loads and having it be places in an unlucky cache line. =
=20
> Maybe a static key replace=C2=A0 tcf_xmit_hook_count is more simplified=
=EF=BC=9F
>=20
> DEFINE_STATIC_KEY_FALSE(tcf_xmit_hook_in_use);

I wasn't sure if static key would work with the module (mirred being a
module) but thinking about it again, if tcf_dev_queue_xmit() is not an
static inline but a normal function, it should work. Sounds good!

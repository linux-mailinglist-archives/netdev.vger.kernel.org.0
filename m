Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA902B9AD6
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 19:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbgKSSoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 13:44:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:57328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728591AbgKSSoP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 13:44:15 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B75822255;
        Thu, 19 Nov 2020 18:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605811455;
        bh=hAtWZOOEggXYNF07rt3mds1WRGCi/8ckKjjaTTdIQSs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hAfN8+Rauv+Jr6l1g1tt/CdH3KcPjw3o9SdCBpf9ZgShvX+ikhp7YE02zMaXoPi06
         FCq4oygpaB2gsMQgukoBUFqMMHvv5eC29CUGR4xOts/zuAu1daIIJuyMwbOaipmMCm
         aIvEFTlQoLaAiAfGP00E0pN0WBXhMw4AHGpqfE6g=
Date:   Thu, 19 Nov 2020 10:44:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dmytro Shytyi <dmytro@shytyi.net>
Cc:     "yoshfuji" <yoshfuji@linux-ipv6.org>,
        "kuznet" <kuznet@ms2.inr.ac.ru>,
        "liuhangbin" <liuhangbin@gmail.com>, "davem" <davem@davemloft.net>,
        "netdev" <netdev@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next V6] net: Variable SLAAC: SLAAC with prefixes of
 arbitrary length in PIO
Message-ID: <20201119104413.75ca9888@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <175e0b9826b.c3bb0aae425910.5834444036489233360@shytyi.net>
References: <175b3433a4c.aea7c06513321.4158329434310691736@shytyi.net>
        <202011110944.7zNVZmvB-lkp@intel.com>
        <175bd218cf4.103c639bc117278.4209371191555514829@shytyi.net>
        <175bf515624.c67e02e8130655.7824060160954233592@shytyi.net>
        <175c31c6260.10eef97f6180313.755036504412557273@shytyi.net>
        <20201117124348.132862b1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <175e0b9826b.c3bb0aae425910.5834444036489233360@shytyi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020 14:37:35 +0100 Dmytro Shytyi wrote:
> +struct inet6_ifaddr *ipv6_cmp_rcvd_prsnt_prfxs(struct inet6_ifaddr *ifp,
> +					       struct inet6_dev *in6_dev,
> +					       struct net *net,
> +					       const struct prefix_info *pinfo)
> +{
> +	struct inet6_ifaddr *result_base =3D NULL;
> +	struct inet6_ifaddr *result =3D NULL;
> +	struct in6_addr curr_net_prfx;
> +	struct in6_addr net_prfx;
> +	bool prfxs_equal;
> +
> +	result_base =3D result;
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(ifp, &in6_dev->addr_list, if_list) {
> +		if (!net_eq(dev_net(ifp->idev->dev), net))
> +			continue;
> +		ipv6_addr_prefix_copy(&net_prfx, &pinfo->prefix, pinfo->prefix_len);
> +		ipv6_addr_prefix_copy(&curr_net_prfx, &ifp->addr, pinfo->prefix_len);
> +		prfxs_equal =3D
> +			ipv6_prefix_equal(&net_prfx, &curr_net_prfx, pinfo->prefix_len);
> +		if (prfxs_equal && pinfo->prefix_len =3D=3D ifp->prefix_len) {
> +			result =3D ifp;
> +			in6_ifa_hold(ifp);
> +			break;
> +		}
> +	}
> +	rcu_read_unlock();
> +	if (result_base !=3D result)
> +		ifp =3D result;
> +	else
> +		ifp =3D NULL;
> +
> +	return ifp;
> +}

Thanks for adding the helper! Looks like it needs a touch up:

net/ipv6/addrconf.c:2579:22: warning: no previous prototype for =E2=80=98ip=
v6_cmp_rcvd_prsnt_prfxs=E2=80=99 [-Wmissing-prototypes]
 2579 | struct inet6_ifaddr *ipv6_cmp_rcvd_prsnt_prfxs(struct inet6_ifaddr =
*ifp,
      |                      ^~~~~~~~~~~~~~~~~~~~~~~~~
net/ipv6/addrconf.c:2579:21: warning: symbol 'ipv6_cmp_rcvd_prsnt_prfxs' wa=
s not declared. Should it be static?

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF3645EFD4B
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 20:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235952AbiI2Soe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 14:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235902AbiI2SoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 14:44:09 -0400
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 48C7D1D929A
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 11:43:44 -0700 (PDT)
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id A76921023F;
        Thu, 29 Sep 2022 21:43:41 +0300 (EEST)
Received: from ink.ssi.bg (unknown [193.238.174.40])
        by mg.ssi.bg (Proxmox) with ESMTP id 41C88102D4;
        Thu, 29 Sep 2022 21:43:40 +0300 (EEST)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id E87063C0325;
        Thu, 29 Sep 2022 21:43:39 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.16.1) with ESMTP id 28TIhcIs136951;
        Thu, 29 Sep 2022 21:43:39 +0300
Date:   Thu, 29 Sep 2022 21:43:38 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net] ip: fix triggering of 'icmp redirect'
In-Reply-To: <aaddae1d-ad4e-425c-b88a-0830d839a3ce@6wind.com>
Message-ID: <28c0db52-cfc9-d528-da5c-2ff01b482b77@ssi.bg>
References: <20220829100121.3821-1-nicolas.dichtel@6wind.com> <6c8a44ba-c2d5-cdf-c5c7-5baf97cba38@ssi.bg> <aaddae1d-ad4e-425c-b88a-0830d839a3ce@6wind.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811672-223533272-1664477019=:42780"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811672-223533272-1664477019=:42780
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT


	Hello,

On Thu, 29 Sep 2022, Nicolas Dichtel wrote:

> Le 27/09/2022 à 14:56, Julian Anastasov a écrit :
> > 
> > nhc_gw	nhc_scope		rt_gw4		fib_scope (route)
> > ---------------------------------------------------------------------------
> > 0	RT_SCOPE_NOWHERE	Host		RT_SCOPE_HOST (local)
> > 0	RT_SCOPE_HOST		LAN_TARGET	RT_SCOPE_LINK (link)
> > LOCAL1	RT_SCOPE_HOST		LAN_TARGET	RT_SCOPE_LINK (link)
> > REM_GW1	RT_SCOPE_LINK		Universe	RT_SCOPE_UNIVERSE (indirect)
> > 
> > 	For the code above: we do not check res->scope,
> > we are interested what is the nhc_gw's scope (LINK/HOST/NOWHERE).
> > It means, reverse route points back to same device and sender is not
> > reached via gateway REM_GW1.

	In short, to send redirects, sender should be
reachable via link route (with nhc_scope = RT_SCOPE_HOST).

> iproute2 reject a gw which is not directly connected, am I wrong?

	ip tool can not do it. It only provides route's scope
specified by user and the GW's scope is determined by 
fib_check_nh_v4_gw() as route's scope + 1 but at least RT_SCOPE_LINK:

                /* It is not necessary, but requires a bit of thinking */
                if (fl4.flowi4_scope < RT_SCOPE_LINK)
                        fl4.flowi4_scope = RT_SCOPE_LINK;

	The other allowed value for nhc_scope when rt_gw4 is not 0 is
RT_SCOPE_HOST (GW is a local IP, useful when autoselecting source
address from same subnet). It is set by fib_check_nh_v4_gw() when
res.type = RTN_LOCAL.

> > 	By changing it to nhc_scope >= RT_SCOPE_LINK, ret always
> > will be 1 because nhc_scope is not set below RT_SCOPE_LINK (253).
> > Note that RT_SCOPE_HOST is 254.
> Do you have a setup which shows the problem?

	No, just by analyze. RT_SCOPE_LINK indicates sender
is reached via GW.

> After reverting the two commits (747c14307214 and eb55dc09b5dd) and putting the
> below patch, the initial problem is fixed. But it's not clear what is broken
> with the current code. Before sending these patches formally, it would be nice
> to be able to add a selftest to demonstrate what is wrong.

	What is broken? I guess, __fib_validate_source always
returns 1 causing redirects.

	As for nh_create_ipv4(), may be using scope=0 as
arg to fib_check_nh() should work. Now I can not find example
for corner case where this can fail.

> @@ -2534,7 +2534,7 @@ static int nh_create_ipv4(struct net *net, struct nexthop *nh,
>  	if (!err) {
>  		nh->nh_flags = fib_nh->fib_nh_flags;
>  		fib_info_update_nhc_saddr(net, &fib_nh->nh_common,
> -					  fib_nh->fib_nh_scope);
> +					  !fib_nh->fib_nh_scope ? 0 : fib_nh->fib_nh_scope - 1);

	And this fix is needed to not expose scope host
saddr (127.0.0.1) when nexthop is without GW and to
not expose scope link saddr when nexthop is with GW (for
traffic via scope global routes).

>  	} else {
>  		fib_nh_release(net, fib_nh);
>  	}

Regards

--
Julian Anastasov <ja@ssi.bg>
---1463811672-223533272-1664477019=:42780--


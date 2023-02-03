Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2A34689447
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 10:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbjBCJqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 04:46:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbjBCJqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 04:46:15 -0500
X-Greylist: delayed 462 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 03 Feb 2023 01:46:02 PST
Received: from dvalin.narfation.org (dvalin.narfation.org [213.160.73.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F759A829
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 01:46:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1675417096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wIbm+ky4JhJJx9adjLm/JS7p8oau1jmqkNdtBhx/1og=;
        b=RyV0pIRW5IGaHV3JSgOc2pW0zCg/zevuWS1glLXZjxDlMLMHzrfdoqDUt4CcOWfYzM8Vam
        0aRnhzKPLYDZt61eCaSEqasvCL5uUJk0FR0fbmgqO/qMYCMhPHOoe0oNwj2DtAKHHTA4um
        XkifqrFb8fWqe1h85USEo2Z/iVR+PBE=
From:   Sven Eckelmann <sven@narfation.org>
To:     b.a.t.m.a.n@lists.open-mesh.org, Jiri Pirko <jiri@resnulli.us>
Cc:     Linus =?ISO-8859-1?Q?L=FCssing?= <linus.luessing@c0d3.blue>,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH 1/5] batman-adv: Start new development cycle
Date:   Fri, 03 Feb 2023 10:38:07 +0100
Message-ID: <8520325.EvYhyI6sBW@ripper>
In-Reply-To: <Y9zF/kEDF7hAAlsB@nanopsycho>
References: <20230127102133.700173-1-sw@simonwunderlich.de> <Y9wEdn1MJBOjgE5h@sellars>
 <Y9zF/kEDF7hAAlsB@nanopsycho>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4755678.kQq0lBPeGt";
 micalg="pgp-sha512"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart4755678.kQq0lBPeGt
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Sven Eckelmann <sven@narfation.org>
To: b.a.t.m.a.n@lists.open-mesh.org, Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH 1/5] batman-adv: Start new development cycle
Date: Fri, 03 Feb 2023 10:38:07 +0100
Message-ID: <8520325.EvYhyI6sBW@ripper>
In-Reply-To: <Y9zF/kEDF7hAAlsB@nanopsycho>
MIME-Version: 1.0

On Friday, 3 February 2023 09:29:50 CET Jiri Pirko wrote:
[...]
> Why kernel version is not enough for you? My point is, why to maintain
> internal driver version alongside with the kernel version?
[...]
> >Also note that we can't do a simple kernel version to year
> >notation mapping in userspace in batctl. OpenWrt uses the most
> >recent Linux LTS release. But might feature a backport of a more
> >recent batman-adv which is newer than the one this stable kernel
> >would provide. Or people also often use Debian stable but compile
> >and use the latest batman-adv version with it.
> 
> Yeah, for out of tree driver, have whatever.

A while back, my personal opinion changed after there were various Linux 
developers/maintainers were trying to either remove it or wondering about this 
bump. The idea which I've proposed was to:

* still ship the "backports" like out-of-tree tarball with a module version - 
  but directly in its "compat" code
* continue to use in projects (which for whatever reason cannot use the in-
  kernel implementation) a version which represents their upstream backports 
  tarball + their (patch) revision: Something like "2022.0-openwrt-7"
* for the in-kernel module, just return either 

  - remove the version information completely from the kernel module 
    MODULE_VERSION + drop BATADV_ATTR_VERSION + modifying batctl to fetch that 
    from uname(). But of course, that would break old batctl versions [1]
  - or by setting BATADV_SOURCE_VERSION to UTS_RELEASE (+suffix?) or 
    UTS_VERSION


But this wasn't well received when mentioning it to Simon+Linus (but I could 
misremember the persons involved here).

Kind regards,
	Sven

[1] https://lore.kernel.org/r/20201205085604.1e3fcaee@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com
--nextPart4755678.kQq0lBPeGt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAmPc1f8ACgkQXYcKB8Em
e0YJEg/+IsrzHhNRdrlwtYcrox6niuIZH4TosdhIe9tRwjypwP4GGM+IFOxlWA4n
TnNiryOeZhMwUfmqr+ntzIaWFxK9xzOfND1xNQRyBU9l1slWOctPg+1oh+7oGq86
fBEprCqn61Wu90fSM1LuTxiDTRsw2xFGeasOmwqJ3/u8IeGAa05WusuuaIs3hlf6
hUH+ih1gS1HLvuHEyIaFq1wRmJoMxB6Obg6v4ZAJshj3TnDnVGkFVYybI6/04ZAq
545/4VLmOww8mV8Gn763QkQ5gak1E25KhUrYO8neP7SFB1UXOx6GFPpwceiS8+WK
I50n7weW3V/y+svyMvdJF/HMpY9smGanGBfoWvCpl04j/38L2wdUng3B9aNwOnFL
EJJa+5guEN3P6gQshKmRda5fn2LW8oNEgcpZepEFFiAnRKSc0RdEXU62IicFsI1a
GHXB588tbk23NA2fD0lVjyHDrLjLH8xLdnUP7wAizr0u4tINDVQphrHvGnF0Lx5K
BlNOqcm3xHLX0fMzjrykIP69q2rwoyNOE9nJjfPgjBwGulgaMX05XXbXPmTYaosN
1n3yrWjfl4jXXA0aoE2OXHF4xm16D/0z+sAeqBef3xu5/BlZF7fPYf9ph/YuvYh3
A8EZB8Yu36GkF4cUO51unMyrSk1zQ/nVsl6U5SLgJdsKq6yPU8A=
=xU8d
-----END PGP SIGNATURE-----

--nextPart4755678.kQq0lBPeGt--




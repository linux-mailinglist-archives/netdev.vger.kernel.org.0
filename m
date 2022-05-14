Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D72FE5270A0
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 12:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbiENKV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 06:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbiENKV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 06:21:26 -0400
Received: from dvalin.narfation.org (dvalin.narfation.org [213.160.73.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2A32C101
        for <netdev@vger.kernel.org>; Sat, 14 May 2022 03:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1652523679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1qYOvynL+5sTqjSmhPCidw3mtZFTa6T3CLaHzQSVFZk=;
        b=S6FV7EyHzgSpDnKkPkC6q+MPkTqmHaiu5WlxA1ofSd7eaQH+xeOmKx2coW/QoojAxNASBM
        z8C81VwjYQgjSqCnFHklskXijiV0w8yM3EkV6QFChgrw43DisPCL8lT/0DgX4X5X3b7Oj9
        m+M5P9hSu5ws9WrmssaT4jArSYI1oDk=
From:   Sven Eckelmann <sven@narfation.org>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org
Subject: Re: [PATCH net 11/12] batman-adv: fix iflink detection in batadv_is_on_batman_iface
Date:   Sat, 14 May 2022 12:21:16 +0200
Message-ID: <1754593.qx6Pg7X6uG@sven-desktop>
In-Reply-To: <afa206858a88910691bdb917d0956cea3f32f667.1600770261.git.sd@queasysnail.net>
References: <cover.1600770261.git.sd@queasysnail.net> <afa206858a88910691bdb917d0956cea3f32f667.1600770261.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart41320831.pHRkKXBtVs"; micalg="pgp-sha512"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart41320831.pHRkKXBtVs
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Sven Eckelmann <sven@narfation.org>
To: Sabrina Dubroca <sd@queasysnail.net>
Cc: Marek Lindner <mareklindner@neomailbox.ch>, Simon Wunderlich <sw@simonwunderlich.de>, Antonio Quartulli <a@unstable.cc>, b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org
Subject: Re: [PATCH net 11/12] batman-adv: fix iflink detection in batadv_is_on_batman_iface
Date: Sat, 14 May 2022 12:21:16 +0200
Message-ID: <1754593.qx6Pg7X6uG@sven-desktop>
In-Reply-To: <afa206858a88910691bdb917d0956cea3f32f667.1600770261.git.sd@queasysnail.net>
References: <cover.1600770261.git.sd@queasysnail.net> <afa206858a88910691bdb917d0956cea3f32f667.1600770261.git.sd@queasysnail.net>

On Thursday, 1 October 2020 09:59:35 CEST Sabrina Dubroca wrote:
> device has the same ifindex as its link. Let's use the presence of a
> ndo_get_iflink operation, rather than the value it returns, to detect
> a device without a link.

There wasn't any activity in this patchset since a while, it doesn't apply
anymore and the assumptions made here doesn't seem to be reflect the current
situation in the kernel. See commit 6c1f41afc1db ("batman-adv: Don't expect
inter-netns unique iflink indices"):

> But only checking for dev->netdev_ops->ndo_get_iflink is also not an option
> because ipoib_get_iflink implements it even when it sometimes returns an
> iflink != ifindex and sometimes iflink == ifindex. The caller must
> therefore make sure itself to check both netns and iflink + ifindex for
> equality. Only when they are equal, a "physical" interface was detected
> which should stop the traversal. On the other hand, vxcan_get_iflink can
> also return 0 in case there was currently no valid peer. In this case, it
> is still necessary to stop.

It would would be nice when the situation would be better but the proposed 
patches don't solve it. So I will mark the two patches as "Rejected" (from 
"Changes requested") in batadv's patchwork. It is not meant as sign of
disapproval of someone working in this area to improve the situation - I just
don't want to wait for the v2 [1] anymore.

Kind regards,
	Sven

[1] https://lore.kernel.org/all/20201002090703.GD3565727@bistromath.localdomain/
--nextPart41320831.pHRkKXBtVs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAmJ/gpwACgkQXYcKB8Em
e0b8bg//cTQcj0L6HvTbt3v4eZIOw1E9xQVtfh3w7zKEagsEIyz8fPapiqG4uHOd
aZukT6tVDAyxT6ce+1sm07hVcBfMEeMf+a6BrobdVJ6cvKXt31O+juUEiAl8qex1
8begZbq/5tTZmKkgiHUbvZeW8lBDwrlvvSwYLXTwqbjJoIKVfvFucOSHnYD/N7Ho
XN9wfHcZng5Q/XFGuu6Ki5cvX1j/ygzW1MH6bHzat7+RCDxt3ri7CuFAHQ6cnf33
bZPoFStCjgJLZ+5VZcTPNVHe6bZv1uwGxniSyaPi4T3HNoIWnGsPUndY7us/jBtl
LLyObHy9Tli2ARjL599L2e/fTayDKwro/DTGYSpuXTvz9FgIG4wZiwoSQK2TVx2I
sAPfkspDbB3MPG+Os0XBfDrB3plZeFZgFyLYYDf9DmCQxm1XKLUm8sZa6G7s3Wjf
xlBqB4JwLjXxltnbTsHyUgu4PewMCIrJglau/uL3/03WDMO+eGhtVa4ZsISdP3rM
rnibmZ46GS7c4Nr5gNC00ecjr/36dTn6sc//ZBbbFEm+FZVXixJ6P1Zzcg4rqdKV
xv6a3z8hLUtvh9Gxxt8jwH4XSWtufTe+RG5mu+QDEy5prxCUWoAReJRQsO1hGJG1
y/ZQMvW3aXzyCA27wyCgsbLACX0W3tD7O7ponxGV3o7XfI0wssU=
=97Bw
-----END PGP SIGNATURE-----

--nextPart41320831.pHRkKXBtVs--




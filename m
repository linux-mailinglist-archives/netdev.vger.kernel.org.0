Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F60226F5D7
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 08:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbgIRGWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 02:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbgIRGWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 02:22:52 -0400
Received: from dvalin.narfation.org (dvalin.narfation.org [IPv6:2a00:17d8:100::8b1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96418C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 23:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1600410166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J7DOruZAPYo1Ziyj0KQ/CLpIQiG4PiroPi3tQfV9R4A=;
        b=up203ko1vwx17X+A1tHjX6Esz3Zx2KzqkgJ07D3TCdHXaTpQaCWPv6NsuUt3xnoCN0DQuA
        ZE2FsRz/z/Y6qcAtlu8AiZk/zzxQGaFlG9uPY8bM7PQB9eMsWgSNACFwwc/t5lxS0NK7gr
        I+BbgaLv1Kag4Y2coGLVSpgB/ucQl1k=
From:   Sven Eckelmann <sven@narfation.org>
To:     Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc:     yuanxzhang@fudan.edu.cn, kjlu@umn.edu,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>
Subject: Re: [PATCH] batman-adv: Fix orig node refcnt leak when creating neigh node
Date:   Fri, 18 Sep 2020 08:22:43 +0200
Message-ID: <3173635.NQHa8YD4nL@ripper>
In-Reply-To: <1600398200-8198-1-git-send-email-xiyuyang19@fudan.edu.cn>
References: <1600398200-8198-1-git-send-email-xiyuyang19@fudan.edu.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3372165.47aDjYEo1S"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart3372165.47aDjYEo1S
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Friday, 18 September 2020 05:03:19 CEST Xiyu Yang wrote:
> batadv_neigh_node_create() is used to create a neigh node object, whose
> fields will be initialized with the specific object. When a new
> reference of the specific object is created during the initialization,
> its refcount should be increased.
> 
> However, when "neigh_node" object initializes its orig_node field with
> the "orig_node" object, the function forgets to hold the refcount of the
> "orig_node", causing a potential refcount leak and use-after-free issue
> for the reason that the object can be freed in other places.
> 
> Fix this issue by increasing the refcount of orig_node object during the
> initialization and adding corresponding batadv_orig_node_put() in
> batadv_neigh_node_release().


I will most likely not add this patch because I have concerns that this would 
need an active garbage collector to fix the reference counter loop.

Please check batadv_neigh_node::orig_node (whose reference counter you've just 
incremented) and batadv_orig_node::neigh_list (with batadv_neigh_node). And at 
the same time the batadv_neigh_node_release and batadv_orig_node_release. So 
the originator will only free the reference (and thus potentially call 
batadv_neigh_node_release) when its own reference counter is zero. But it 
cannot become zero because the neigh_node is holding a reference to this 
originator.

Kind regards,
	Sven

--nextPart3372165.47aDjYEo1S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAl9kUjMACgkQXYcKB8Em
e0Z1hw/9Hhq8F/9JHS0zWSv7J58oJSa2gi0ONWuLkTN6XX2g0qY/w9Kn1vbPTIK1
VCI2bDDDTbZxk51mxJO0kpE6Q5r8wrFrV+ESoQE/ccFDy6OxtUxCveL6jsfwXIWw
zgQY44iumPlxrjnc0uOCR+7vbAFXjz2u9EekF/gv4etbDTvp0ZNt0QM4hAvDXsBH
q3RHY6ywuwUu7nRlXPNcmGWNrCpUrindQiRUB4vZXoLckjRgD3MerFjSnd1kp32B
Wd3WPqb+nggqNX8eCX4GGsLXk+wsstIDhtG/aLwNpJWd2kAkfq2zeWQ0GltzdUQk
Z17hIPOGEqKCgGmC7akHunAo9M3TFkglnO1NgYL36j6RcRgQV6VLClovP6Qk8Iin
kPyrUWXOH9slZnIH+enp1vggkepKmI8kMG+5OVVNXfMoRMbVSyboiKuyI5+Tig3A
8U+9Z6H29fhNv7E7BSCRg+VfEZXInjBcKuwSD6bZ4IE8RA3HFh0ZcOIjBiWUekUm
tP890PFNb2mTJzOHZ8cFbyxuJ64o2R8pEQvVNdw8y2oth01QEzVVsaAL0QFQG8g/
rtBKpZqog0kC+PIysIaFhGupjrZzb/+hvHpamo1JDcdGzZ5Ve8U0bmJPOc4CfeRA
r8RZz31EgGebqlbdGPvWPhZAY3NcMVq0LBS78WCDUNOiPc589Co=
=5J+s
-----END PGP SIGNATURE-----

--nextPart3372165.47aDjYEo1S--




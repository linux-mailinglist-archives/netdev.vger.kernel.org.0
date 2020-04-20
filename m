Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF781B0138
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 07:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbgDTFxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 01:53:40 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:52296 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgDTFxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 01:53:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1587362014;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8v1nt9LlaYNIMct5NGUuujlOt/0rExt6hQKkny68o/c=;
        b=zk/XmDTXnWfXW9BZ9mbWPCgmPhlL7TY46W6ldofYU6lxb4p8Q5PIXxj19Yd0EGq+vCN+BU
        qh6aGHqyGJmBkx4dRrp1XYhYuVXBEn7NtEMnCG3BKPeDMD4VG45z/llKx20JaljUBcmNzl
        4iJe7BcUWarvfNEUzUmpE9+uVVe6uCw=
From:   Sven Eckelmann <sven@narfation.org>
To:     Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc:     Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yuanxzhang@fudan.edu.cn,
        kjlu@umn.edu, Xin Tan <tanxin.ctf@gmail.com>
Subject: Re: [PATCH] batman-adv: Fix refcnt leak in batadv_v_ogm_process
Date:   Mon, 20 Apr 2020 07:53:31 +0200
Message-ID: <6844758.PSh0Y5hloC@bentobox>
In-Reply-To: <1587361040-83099-1-git-send-email-xiyuyang19@fudan.edu.cn>
References: <1587361040-83099-1-git-send-email-xiyuyang19@fudan.edu.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3626795.PeB5Tdf7to"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart3626795.PeB5Tdf7to
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Monday, 20 April 2020 07:37:20 CEST Xiyu Yang wrote:
> batadv_v_ogm_process() invokes batadv_hardif_neigh_get(), which returns
> a reference of the neighbor object to "hardif_neigh" with increased
> refcount.
> 
> When batadv_v_ogm_process() returns, "hardif_neigh" becomes invalid, so
> the refcount should be decreased to keep refcount balanced.
> 
> The reference counting issue happens in one exception handling paths of
> batadv_v_ogm_process(). When batadv_v_ogm_orig_get() fails to get the
> orig node and returns NULL, the refcnt increased by
> batadv_hardif_neigh_get() is not decreased, causing a refcnt leak.
> 
> Fix this issue by jumping to "out" label when batadv_v_ogm_orig_get()
> fails to get the orig node.
> 
> Fixes: 9323158ef9f4 ("batman-adv: OGMv2 - implement originators logic")
> Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
> Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
> ---
>  net/batman-adv/bat_v_ogm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied [1]

Thanks,
	Sven

[1] https://git.open-mesh.org/linux-merge.git/commit/afba933d9875cdf31c973a1ecf05de7129a142c4
--nextPart3626795.PeB5Tdf7to
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAl6dONsACgkQXYcKB8Em
e0b6aA/9EgeHxmgaw9nEaGwVPQxs/aDz3TGXDZAVPhtj4/dd/uXxbvJ9USAG8veI
XgBtMWRDj7jQP41+1CGYaPePAid6tZ4/hE0mEFg5d7+1gnf2rFCZ8CN0ox9GhGN2
pccBnmMuJpHWIyxABUjCwbtYFw+fTbGAIV1Hm1y610JgXGmszcjfcqtY6LNaw3b0
A8azcTlyZiAPJ+tCzUYb33hrxeNb9yqgaZSHMDXOpzcg/L8iR9xvgpgYRZi5DBj6
E2EDpPWknflOfd4lX3FVrHzql7V2URKnDUBhhMc76Nea5qVLFqn8vKgW2IdbYwt+
zTjGSqmwsme0pOEAI8xJkXGbwC3X4LhssidHHLRQb3vUu5UU+ShrEhGw+ack9IeE
QUr9nGgpX3Yf6bu7jmEnIFZHG47A2l+KHbyxWpVsN9vnRMWKfvD82cqjfbglS5Xp
y3V3RrREXN5hlKQ5jpn9vnJmlI0XmoWBiXjVkZHO2S2XPhXxf0FcwYCtCoGQGDa7
qYc3adPv/pAf09g4rB1DYsB7/BXPjuz1JMf9zpdrGoJ/E+2z5xKRYbhiZX95TFSk
n2ay85irBwRODSC4tgIzqJdH0udGUKxWAOo26dLOmZRTC1DUN+6IxfdGetGg7Y58
9aZWNtXkhaeAtZyIU4VT191pyWf13nuL5luP3EPST1n/T5/nQCc=
=oZeN
-----END PGP SIGNATURE-----

--nextPart3626795.PeB5Tdf7to--




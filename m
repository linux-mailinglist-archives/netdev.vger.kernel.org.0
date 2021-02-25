Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E1C324B8D
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 08:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235278AbhBYHwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 02:52:38 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7285 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235106AbhBYHwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 02:52:36 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6037571c0000>; Wed, 24 Feb 2021 23:51:56 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 25 Feb
 2021 07:51:55 +0000
Received: from dev-r630-03.mtbc.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 25 Feb 2021 07:51:54 +0000
From:   Chris Mi <cmi@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <kuba@kernel.org>, <idosch@nvidia.com>, <jiri@nvidia.com>,
        Chris Mi <cmi@nvidia.com>, Yotam Gigi <yotam.gi@gmail.com>
Subject: [PATCH net] net: psample: Fix netlink skb length with tunnel info
Date:   Thu, 25 Feb 2021 15:51:45 +0800
Message-ID: <20210225075145.184314-1-cmi@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614239516; bh=52u0rhslFWz2tzkaU4C8WuTazW8xn9tBt7LU9uwwvyg=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type;
        b=ccGDUC9GmHyERNwmthTWFF5seO16L55Roz7aUrQqBAwGyeCr00bzPqvuJI66xk7qB
         Ca4hDbJHOgIGjOs4/c8/5jSQNeCqUfOodKEv3W0kqdweWas5a2M+XDruwnVjTzjm2D
         BOGqaLUW5LzA0BNPdfcD0FppC6fi7tgOc/NcXO+XK9n0Ksr873+GY+B7osI58SrMaO
         /Zy43Uia5+SaNzd9Jdvu4dAF7bIUH/S+XLA4vc1/iLSNm0DNw5y7zVrv1bm6AJThkf
         F1c4vAKgzftKtKiRxrXUp0lKoHECU9jelK1l1+ROuYKsNI4k7/ky/QQ/3RMVU5JNjr
         sEYn5f0a5khtw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the psample netlink skb is allocated with a size that does
not account for the nested 'PSAMPLE_ATTR_TUNNEL' attribute and the
padding required for the 64-bit attribute 'PSAMPLE_TUNNEL_KEY_ATTR_ID'.
This can result in failure to add attributes to the netlink skb due
to insufficient tail room. The following error message is printed to
the kernel log: "Could not create psample log message".

Fix this by adjusting the allocation size to take into account the
nested attribute and the padding.

Fixes: d8bed686ab96 ("net: psample: Add tunnel support")
CC: Yotam Gigi <yotam.gi@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Chris Mi <cmi@nvidia.com>
---
 net/psample/psample.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/psample/psample.c b/net/psample/psample.c
index 33e238c965bd..482c07f2766b 100644
--- a/net/psample/psample.c
+++ b/net/psample/psample.c
@@ -309,10 +309,10 @@ static int psample_tunnel_meta_len(struct ip_tunnel_i=
nfo *tun_info)
 	unsigned short tun_proto =3D ip_tunnel_info_af(tun_info);
 	const struct ip_tunnel_key *tun_key =3D &tun_info->key;
 	int tun_opts_len =3D tun_info->options_len;
-	int sum =3D 0;
+	int sum =3D nla_total_size(0);	/* PSAMPLE_ATTR_TUNNEL */
=20
 	if (tun_key->tun_flags & TUNNEL_KEY)
-		sum +=3D nla_total_size(sizeof(u64));
+		sum +=3D nla_total_size_64bit(sizeof(u64));
=20
 	if (tun_info->mode & IP_TUNNEL_INFO_BRIDGE)
 		sum +=3D nla_total_size(0);
--=20
2.26.2


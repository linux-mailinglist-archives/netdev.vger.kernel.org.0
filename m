Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598BB25A3FD
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 05:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgIBDWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 23:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbgIBDWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 23:22:39 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC27C061245
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 20:22:38 -0700 (PDT)
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 471B984487;
        Wed,  2 Sep 2020 15:22:35 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1599016955;
        bh=Qsnp+Uwy/PPWqKBD20EdDvSCjEBEWSRlM/tVJS9qc1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=ugTzqlrKE3yf9DY3ACtN9QxxjokVvy6oWjyM2z8jbazIvOMbMoiMsd2MK7v5zUIYn
         aIeA4z7yV6Ewli38tbRd7n5nBw0OKR/FKyBrbvDUujpiJexObOPoqv3whOAfsFLyKD
         pLTFaX2TQNmdGC5UHocsCwe4a7EscuW3edRwdetBpkB4V/VQNf8gncrS6CYqw1xOh0
         6fzLfofOdmguezlJHUsJNt7K2CcoXuDFt1k+jLp9rS2ioRJiSzVK84YEjz9uwwGivQ
         og13D3IOqAKi+VHFvMhdnlHy892LBj+krx4G2aG0NMSAKd6YD/6noC26OQsV1b3o15
         /pVDIRbQ+rXRA==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f4f0ffb0002>; Wed, 02 Sep 2020 15:22:35 +1200
Received: from pauld-dl.ws.atlnz.lc (pauld-dl.ws.atlnz.lc [10.33.23.16])
        by smtp (Postfix) with ESMTP id C81C013EEBA;
        Wed,  2 Sep 2020 15:22:34 +1200 (NZST)
Received: by pauld-dl.ws.atlnz.lc (Postfix, from userid 1684)
        id 1BB051E05CC; Wed,  2 Sep 2020 15:22:35 +1200 (NZST)
From:   Paul Davey <paul.davey@alliedtelesis.co.nz>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Davey <paul.davey@alliedtelesis.co.nz>
Subject: [PATCH net-next 2/2] ipmr: Use full VIF ID in netlink cache reports
Date:   Wed,  2 Sep 2020 15:22:22 +1200
Message-Id: <20200902032222.25109-3-paul.davey@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200902032222.25109-1-paul.davey@alliedtelesis.co.nz>
References: <20200902032222.25109-1-paul.davey@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Insert the full 16 bit VIF ID into ipmr Netlink cache reports.

If using more than 255 multicast interfaces it is necessary to have
access to a VIF ID for cache reports that is wider than 8 bits, the
VIF ID present in the igmpmsg reports sent to mroute_sk are only 8
bits wide in the igmpmsg header.  The VIF_ID attribute has 32 bits of
space however so can store the full VIF ID.

Signed-off-by: Paul Davey <paul.davey@alliedtelesis.co.nz>
---
 net/ipv4/ipmr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 19b2f586319b..26cd4ec450f4 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -104,7 +104,7 @@ static int ipmr_cache_report(struct mr_table *mrt,
 			     struct sk_buff *pkt, vifi_t vifi, int assert);
 static void mroute_netlink_event(struct mr_table *mrt, struct mfc_cache =
*mfc,
 				 int cmd);
-static void igmpmsg_netlink_event(struct mr_table *mrt, struct sk_buff *=
pkt);
+static void igmpmsg_netlink_event(struct mr_table *mrt, struct sk_buff *=
pkt, vifi_t vifi);
 static void mroute_clean_tables(struct mr_table *mrt, int flags);
 static void ipmr_expire_process(struct timer_list *t);
=20
@@ -1072,7 +1072,7 @@ static int ipmr_cache_report(struct mr_table *mrt,
 		return -EINVAL;
 	}
=20
-	igmpmsg_netlink_event(mrt, skb);
+	igmpmsg_netlink_event(mrt, skb, vifi);
=20
 	/* Deliver to mrouted */
 	ret =3D sock_queue_rcv_skb(mroute_sk, skb);
@@ -2404,7 +2404,7 @@ static size_t igmpmsg_netlink_msgsize(size_t payloa=
dlen)
 	return len;
 }
=20
-static void igmpmsg_netlink_event(struct mr_table *mrt, struct sk_buff *=
pkt)
+static void igmpmsg_netlink_event(struct mr_table *mrt, struct sk_buff *=
pkt, vifi_t vifi)
 {
 	struct net *net =3D read_pnet(&mrt->net);
 	struct nlmsghdr *nlh;
@@ -2428,7 +2428,7 @@ static void igmpmsg_netlink_event(struct mr_table *=
mrt, struct sk_buff *pkt)
 	rtgenm =3D nlmsg_data(nlh);
 	rtgenm->rtgen_family =3D RTNL_FAMILY_IPMR;
 	if (nla_put_u8(skb, IPMRA_CREPORT_MSGTYPE, msg->im_msgtype) ||
-	    nla_put_u32(skb, IPMRA_CREPORT_VIF_ID, msg->im_vif) ||
+	    nla_put_u32(skb, IPMRA_CREPORT_VIF_ID, vifi) ||
 	    nla_put_in_addr(skb, IPMRA_CREPORT_SRC_ADDR,
 			    msg->im_src.s_addr) ||
 	    nla_put_in_addr(skb, IPMRA_CREPORT_DST_ADDR,
--=20
2.28.0


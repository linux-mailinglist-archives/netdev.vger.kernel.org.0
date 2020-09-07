Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB5C2606CE
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 00:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbgIGWEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 18:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728104AbgIGWEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 18:04:20 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7D1C061756
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 15:04:19 -0700 (PDT)
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id DBF1A84487;
        Tue,  8 Sep 2020 10:04:14 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1599516254;
        bh=7JNB/ELAvKPdDOSBGNHPPqtpnOjczRJOS+hfHYsRwmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=DJz1EeaEyq9ne4h7WBSgn4dvh6B4K9N9mozgld+pnJFExoMHenZNO0lz6TSr8+71h
         3Lngoamx7HLmX6dAIxb5V+ErlFdJTpsJrii19W+GmerlfY5Rpr51MPkPtZ+HMW9+tg
         Kh+JxCxMS+8+1x+Hr0sBaFAeJy6lnJwBiS20DpyYKHE6WKdsWl9MTMIoBpjXREiQBL
         v1GhXCaC0PXhZxfhEQJvDKb0HbMyjulT+fR0GYdEA2RNWJbAevd7upcetDaK42xoXB
         KHeZP9d2lAaxDdz6D8oG8otkPjEPFv6JqWQ3nEHE8WsiK33I/qGQssh95SVIATD1vj
         nC6vAr0xhSxGg==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f56ae5e0003>; Tue, 08 Sep 2020 10:04:14 +1200
Received: from pauld-dl.ws.atlnz.lc (pauld-dl.ws.atlnz.lc [10.33.23.16])
        by smtp (Postfix) with ESMTP id CD77913EF9B;
        Tue,  8 Sep 2020 10:04:13 +1200 (NZST)
Received: by pauld-dl.ws.atlnz.lc (Postfix, from userid 1684)
        id 82EF91E0978; Tue,  8 Sep 2020 10:04:14 +1200 (NZST)
From:   Paul Davey <paul.davey@alliedtelesis.co.nz>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Davey <paul.davey@alliedtelesis.co.nz>
Subject: [PATCH net-next v2 3/3] ipmr: Use full VIF ID in netlink cache reports
Date:   Tue,  8 Sep 2020 10:04:08 +1200
Message-Id: <20200907220408.32385-4-paul.davey@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200907220408.32385-1-paul.davey@alliedtelesis.co.nz>
References: <20200907220408.32385-1-paul.davey@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Insert the full 16 bit VIF ID into ipmr Netlink cache reports.

The VIF_ID attribute has 32 bits of space so can store the full VIF ID
extracted from the high and low byte fields in the igmpmsg.

Signed-off-by: Paul Davey <paul.davey@alliedtelesis.co.nz>
---
 net/ipv4/ipmr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 4809318f591b..939792a38814 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -2432,7 +2432,7 @@ static void igmpmsg_netlink_event(struct mr_table *=
mrt, struct sk_buff *pkt)
 	rtgenm =3D nlmsg_data(nlh);
 	rtgenm->rtgen_family =3D RTNL_FAMILY_IPMR;
 	if (nla_put_u8(skb, IPMRA_CREPORT_MSGTYPE, msg->im_msgtype) ||
-	    nla_put_u32(skb, IPMRA_CREPORT_VIF_ID, msg->im_vif) ||
+	    nla_put_u32(skb, IPMRA_CREPORT_VIF_ID, msg->im_vif | (msg->im_vif_h=
i << 8)) ||
 	    nla_put_in_addr(skb, IPMRA_CREPORT_SRC_ADDR,
 			    msg->im_src.s_addr) ||
 	    nla_put_in_addr(skb, IPMRA_CREPORT_DST_ADDR,
--=20
2.28.0


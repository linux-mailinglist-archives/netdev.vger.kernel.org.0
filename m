Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 815D93D4F50
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 19:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbhGYRLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 13:11:15 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:16860 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229545AbhGYRLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 13:11:15 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16PHpQwn003121;
        Sun, 25 Jul 2021 17:51:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2021-07-09; bh=nV21xZup6BtFrcJ1Ko2nw+MYygfJSztbbPpLqwYpt/8=;
 b=Tc1yqffAQQ9kV5p+Jo2D3ymJG31bX0K2Ay0m3bhB+R7T59iZKkTjxTVzccbP2alvw/rh
 5SlIsjvWhKC+rSrXdsRQUAd2Gklk9t8EApro+MzgU91Kuy+6rCdN9vFfHNvhC1cVN6BZ
 pZKbTEDGmBFZGE4fN2TXYsWCRLYRT/yJuaLvS5hZ4anPveAPxjZQ96WvmK4eUsReHTv1
 Ef6qdWumETNx/xuuK7wnD8LXvEWhaiaWqKZ3aTU+Y9DMKGxzmTIzapO2JYsbzQi0y4wu
 PMXMls15LDs9zcfTr7okMxU2StKNWY8moUkKaV3AhqJUgAS1hgUdRBO8KzxOalNheKA0 rw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=nV21xZup6BtFrcJ1Ko2nw+MYygfJSztbbPpLqwYpt/8=;
 b=hltvANxMJhwdY3wMyMMlkiUl6lofzy41ZVi+IuYVIK61T4EoFuLn3IwkRnY4z4p+dWVU
 LAKSMgPoYdQqU6jfKJJITgqCK9Yyl6ZG7sn4IfBvKcOCdeqZb5M7aUP0pDEVZZYB8vI2
 pG+1K1WMwg5H6SkFoHLvPvuvJ0U5ThSIerPyoUM1jw3gyE48XuzKsDc98fSI1T1Phey+
 jhowZA4w1dd820O1gZf3rpCeluZW/yMo4Cjj0OrDtORZJjiPU3Bjmg0l5T7IuVAjlsJQ
 PN0NEnF/hgVJdh5pPmfEZSzVVpZqQHARSaNmWOdnSNLiSrAjZT5/2wrCW62Pp93esSJp BA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a18nfr5h6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 25 Jul 2021 17:51:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16PHodrw178904;
        Sun, 25 Jul 2021 17:51:13 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 3a0vmrhdau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 25 Jul 2021 17:51:13 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 16PHpDqf185221;
        Sun, 25 Jul 2021 17:51:13 GMT
Received: from manjaro.in.oracle.com (dhcp-10-191-232-135.vpn.oracle.com [10.191.232.135])
        by userp3020.oracle.com with ESMTP id 3a0vmrhd6m-1;
        Sun, 25 Jul 2021 17:51:13 +0000
From:   Harshvardhan Jha <harshvardhan.jha@oracle.com>
To:     ericvh@gmail.com
Cc:     lucho@ionkov.net, asmadeus@codewreck.org, davem@davemloft.net,
        kuba@kernel.org, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harshvardhan Jha <harshvardhan.jha@oracle.com>
Subject: [PATCH] 9p/xen: Fix end of loop tests for list_for_each_entry
Date:   Sun, 25 Jul 2021 23:21:03 +0530
Message-Id: <20210725175103.56731-1-harshvardhan.jha@oracle.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: NI4P3Z8C6NtXY8yKBG6bkZ9y6tr52wJg
X-Proofpoint-ORIG-GUID: NI4P3Z8C6NtXY8yKBG6bkZ9y6tr52wJg
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The list_for_each_entry() iterator, "priv" in this code, can never be
NULL so the warning would never be printed.

Signed-off-by: Harshvardhan Jha <harshvardhan.jha@oracle.com>
---
From static analysis.  Not tested.
---
 net/9p/trans_xen.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index f4fea28e05da..3ec1a51a6944 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -138,7 +138,7 @@ static bool p9_xen_write_todo(struct xen_9pfs_dataring *ring, RING_IDX size)
 
 static int p9_xen_request(struct p9_client *client, struct p9_req_t *p9_req)
 {
-	struct xen_9pfs_front_priv *priv = NULL;
+	struct xen_9pfs_front_priv *priv;
 	RING_IDX cons, prod, masked_cons, masked_prod;
 	unsigned long flags;
 	u32 size = p9_req->tc.size;
@@ -151,7 +151,7 @@ static int p9_xen_request(struct p9_client *client, struct p9_req_t *p9_req)
 			break;
 	}
 	read_unlock(&xen_9pfs_lock);
-	if (!priv || priv->client != client)
+	if (list_entry_is_head(priv, &xen_9pfs_devs, list))
 		return -EINVAL;
 
 	num = p9_req->tc.tag % priv->num_rings;
-- 
2.32.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 811F73D6AC8
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 02:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234214AbhGZX1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 19:27:32 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:2520 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233843AbhGZX1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 19:27:31 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R02dJB009873;
        Tue, 27 Jul 2021 00:07:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2021-07-09;
 bh=b5DkrcWqLQZxmjE/yC8G9x3pPclYWR6dZfCV7/oGyt8=;
 b=s5c132hjkTEwVgSeE/NT+XC9P97cgwaqsCqZnWdWPPfcADDL/8FGLkNHhESFFI7wg4Dn
 KSFZ1yBDvDcNmq+YQ7LhdnzUggFnXnKhiAH2oa8YLi3V7UVE0AkffsIcYSaDekGOHiK9
 zSmNVfxA6LLuLJLtOw4mbz0UAbkoT+duHgmQLq9UHQFi3FT3MHde1FYDUecnJSzD2irQ
 iAGodV5khyEWANQAQAG6tFXAVw05cqNzpe8gnn74mzi1zRLSJLLhoMUBIjJu92Q8nPva
 ITxUmUBJ6zxGzPq0V7lMLlN3VRYdOs76bD4Ahv/zQ990ov2+1QTQCuk2LENPKEK9QrAg aQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=b5DkrcWqLQZxmjE/yC8G9x3pPclYWR6dZfCV7/oGyt8=;
 b=WkFj0xU+wutVZkxgNN2htqD8ldSJqTlc4ioyYN8HEjZpK9zw5KHit13BA9vfsuJ2MUmx
 aYBx81qpVNqoeXUncObWCm7zvV3VPHSlO1t63fFhm5/UH83jMkHAYgllAcBjEvQrUu/D
 KbfVTchu9WPitIc8Dezg7laM4Kss/ZBdvncYZ2QDQV5JeR8YQew4mk0CtiSInK44o+b7
 ReE2mHBokz7mFT2my3uZaXQKGqxXA4HD2+X8JdbwJCoAQoT8RKxtF2rXQy08sF/40FWJ
 V1j4FBHGfC11ZwQ9imnIqmmA33tFO2crxJ0CToAbFBy6OR4Vq+n6HEQbxXfr/JWBEdf8 NQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a234n0e90-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Jul 2021 00:07:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R07bCA031100;
        Tue, 27 Jul 2021 00:07:38 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3a2349c9r9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Jul 2021 00:07:38 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 16R07bIr031075;
        Tue, 27 Jul 2021 00:07:37 GMT
Received: from manjaro.in.oracle.com (dhcp-10-191-222-3.vpn.oracle.com [10.191.222.3])
        by aserp3030.oracle.com with ESMTP id 3a2349c9hn-1;
        Tue, 27 Jul 2021 00:07:24 +0000
From:   Harshvardhan Jha <harshvardhan.jha@oracle.com>
To:     ericvh@gmail.com
Cc:     lucho@ionkov.net, asmadeus@codewreck.org, davem@davemloft.net,
        kuba@kernel.org, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harshvardhan Jha <harshvardhan.jha@oracle.com>
Subject: [PATCH] 9p/xen: Fix end of loop tests for list_for_each_entry
Date:   Tue, 27 Jul 2021 05:37:10 +0530
Message-Id: <20210727000709.225032-1-harshvardhan.jha@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <alpine.DEB.2.21.2107261654130.10122@sstabellini-ThinkPad-T480s>
References: <alpine.DEB.2.21.2107261654130.10122@sstabellini-ThinkPad-T480s>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: clMVn-w0eemomDdiBljtF4wnrzKtlAdl
X-Proofpoint-GUID: clMVn-w0eemomDdiBljtF4wnrzKtlAdl
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch addresses the following problems:
 - priv can never be NULL, so this part of the check is useless
 - if the loop ran through the whole list, priv->client is invalid and
it is more appropriate and sufficient to check for the end of
list_for_each_entry loop condition.

Signed-off-by: Harshvardhan Jha <harshvardhan.jha@oracle.com>
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


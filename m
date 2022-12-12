Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A48E649F74
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 14:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbiLLNJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 08:09:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232174AbiLLNJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 08:09:02 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39FC21276B;
        Mon, 12 Dec 2022 05:09:00 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BC98JdN023527;
        Mon, 12 Dec 2022 13:08:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2022-7-12; bh=dxskmic1Yr1+fUcs56ZWXNvxVz9bJt1msmiC1km1d2I=;
 b=Y9n3VwiQoek16COca9Z+xE4V8FWJX8daNOYz4pjVgqQQ9qcBJ2xsMeJYoUCSZCTZjKHU
 tYoNKUmjwvBCQyiW7opAqPCp8gKhnYttjrXcVvwLRt8LZEM0ehjNnJfBdzJeeUtI0vzn
 hw+0B7FOGATOi1YmVHf/4PVVrf1EGvMmDoFSmdMfx/AwzDxXQUfs35zkseoUrw6XPo+c
 omtjBfW8V6Pf9zeIMwcb2kVNy6qSOCu0E1PRQm7ru47JAm5ErxFqg5XL9QM//hGOxgmB
 DgtVZrNs76gTyIUwZPhT7E6lNnMAmiOkR9BoCNmO/hjnjIJ+GrdBBJiWtsoI1dTon6t/ Lg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mcj092n3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Dec 2022 13:08:40 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BCBvkII034709;
        Mon, 12 Dec 2022 13:08:40 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mcgj40sj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Dec 2022 13:08:40 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BCD8dRO038889;
        Mon, 12 Dec 2022 13:08:39 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3mcgj40shq-1;
        Mon, 12 Dec 2022 13:08:39 +0000
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     harshit.m.mogalapalli@oracle.com, harshit.m.mogalapalli@gmail.com,
        error27@gmail.com, darren.kenny@oracle.com,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Brian Gix <brian.gix@intel.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Bluetooth: Fix a buffer overflow in mgmt_mesh_add()
Date:   Mon, 12 Dec 2022 05:08:28 -0800
Message-Id: <20221212130828.988528-1-harshit.m.mogalapalli@oracle.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-12_02,2022-12-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212120122
X-Proofpoint-ORIG-GUID: e01joMMkITDIIWfYrGbDlKhSpFsgVQH1
X-Proofpoint-GUID: e01joMMkITDIIWfYrGbDlKhSpFsgVQH1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Smatch Warning:
net/bluetooth/mgmt_util.c:375 mgmt_mesh_add() error: __memcpy()
'mesh_tx->param' too small (48 vs 50)

Analysis:

'mesh_tx->param' is array of size 48. This is the destination.
u8 param[sizeof(struct mgmt_cp_mesh_send) + 29]; // 19 + 29 = 48.

But in the caller 'mesh_send' we reject only when len > 50.
len > (MGMT_MESH_SEND_SIZE + 31) // 19 + 31 = 50.

Fixes: b338d91703fa ("Bluetooth: Implement support for Mesh")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
---
This is based on static analysis, I am unsure if we should put
an upper bound to len(48) instead.

This limit on length changed between v4 and v5 patches of Commit:
("Bluetooth: Implement support for Mesh") in function mesh_send()

v4: https://lore.kernel.org/all/20220511155412.740249-2-brian.gix@intel.com/
v5: https://lore.kernel.org/all/20220720194511.320773-2-brian.gix@intel.com/
---
 net/bluetooth/mgmt_util.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/mgmt_util.h b/net/bluetooth/mgmt_util.h
index 6a8b7e84293d..bdf978605d5a 100644
--- a/net/bluetooth/mgmt_util.h
+++ b/net/bluetooth/mgmt_util.h
@@ -27,7 +27,7 @@ struct mgmt_mesh_tx {
 	struct sock *sk;
 	u8 handle;
 	u8 instance;
-	u8 param[sizeof(struct mgmt_cp_mesh_send) + 29];
+	u8 param[sizeof(struct mgmt_cp_mesh_send) + 31];
 };
 
 struct mgmt_pending_cmd {
-- 
2.38.1


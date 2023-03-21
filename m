Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E9B6C3518
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 16:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbjCUPH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 11:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbjCUPH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 11:07:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBF26509BD
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 08:07:41 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32LEfKpa003883;
        Tue, 21 Mar 2023 15:07:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=ffF23+WiHLiUqptO9gsH1+0QQJSdSLaPNPLpini8e6M=;
 b=nPBi2DTUsMDHgE8ME1jEYLsRKVYmoO2ZtSVKxwMtObyuwkbzH8tqVt69IE/LNRCoBrwH
 tl/F9pr7Y9/UzLhxFNIs56AgoY7SOwKcHfq01kNa8VLIbAI4/wbi7Yv0JsgC8/YwxAnZ
 7WzIIiSPzoHRWVTjK4fPAD32K4is/swBKGfIrAQLXFUnTHX699PYcLp5JgphnUmyHE1B
 PiBbNN+4ypdTVt6DKFQNPjO7PQL4UNuJGhKTiui6VmUdMK/prz93rAuX0xkssIFPIFjM
 lWVKVOI9yj5H2z+S/Vsm1z6Jb6nqg3wgMk7M2N3R3vOYGG/YDnjVzfyMXOEAT+txxzA+ xQ== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pfbpmdtsm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Mar 2023 15:07:32 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32LEZrVN020656;
        Tue, 21 Mar 2023 15:07:31 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([9.208.129.114])
        by ppma01dal.us.ibm.com (PPS) with ESMTPS id 3pd4x7fwh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Mar 2023 15:07:31 +0000
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
        by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32LF7Tx829033050
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 15:07:29 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7FF535805B;
        Tue, 21 Mar 2023 15:07:29 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9342058055;
        Tue, 21 Mar 2023 15:07:28 +0000 (GMT)
Received: from li-8d37cfcc-31b9-11b2-a85c-83226d7135c9.ibm.com.com (unknown [9.77.147.181])
        by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 21 Mar 2023 15:07:28 +0000 (GMT)
From:   Nick Child <nnac123@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Nick Child <nnac123@linux.ibm.com>,
        Piotr Raczynski <piotr.raczynski@intel.com>
Subject: [PATCH net-next v2 1/2] net: Catch invalid index in XPS mapping
Date:   Tue, 21 Mar 2023 10:07:24 -0500
Message-Id: <20230321150725.127229-1-nnac123@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7k9PJvKSEJFfkGLgauQvsGGjonLmdkkM
X-Proofpoint-GUID: 7k9PJvKSEJFfkGLgauQvsGGjonLmdkkM
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-21_11,2023-03-21_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 phishscore=0 priorityscore=1501 mlxlogscore=999 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303210118
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When setting the XPS value of a TX queue, warn the user once if the
index of the queue is greater than the number of allocated TX queues.

Previously, this scenario went uncaught. In the best case, it resulted
in unnecessary allocations. In the worst case, it resulted in
out-of-bounds memory references through calls to `netdev_get_tx_queue(
dev, index)`. Therefore, it is important to inform the user but not
worth returning an error and risk downing the netdevice.

Signed-off-by: Nick Child <nnac123@linux.ibm.com>
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
---
Changes since v1 (respond to Jakubs review):
 - send to net-next instead of net
 - use WARN_ON_ONCE instead of a conditonal returning error

v1 - https://lore.kernel.org/netdev/20230320215229.53b7dfa7@kernel.org/

 net/core/dev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index c7853192563d..c278beee6792 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2535,6 +2535,8 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 	struct xps_map *map, *new_map;
 	unsigned int nr_ids;
 
+	WARN_ON_ONCE(index >= dev->num_tx_queues);
+
 	if (dev->num_tc) {
 		/* Do not allow XPS on subordinate device directly */
 		num_tc = dev->num_tc;
-- 
2.31.1


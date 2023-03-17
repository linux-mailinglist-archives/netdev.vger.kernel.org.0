Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2046BF095
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 19:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjCQSUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 14:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjCQSUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 14:20:37 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69B201BAFC
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 11:20:33 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32HHf8U5019637
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 18:20:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=veOpOzwVOSKbRDZpIVWnbUrPbiZWlBQTMfo1QXhNoI4=;
 b=PtZDe8QN2NnWEeTUHw44fCAxXPlfSDA+v8p69OwuKk5g5cnXz6PA1HXh4+cd1rQ5TTvh
 DSnR1M1HqBPG4F6Q7Ish4wNa4gywOgHRZ/XqSuCOPxxdRfvevjxlWPoY7P08PniVxMjp
 hZIO+iYbV1HHr7TIPfyX140I/42yoO2bDxPWTvpb+u6yCAqa6Yuuqby3lTPSbNm+53Se
 8gg81pnzq1AGgBklFq8Lg5o6eCJeef6gA8BVNg2DLnRdYfR3gQi1xmZvDsDrlzPkCF47
 mg9JMO3IWKP6Btgv6yRLmuYuI03AKAMan9gjy9shT2nEFhXF3a130tay4EU2f/beuNqY tQ== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pcvhjh354-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 18:20:33 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32HHwQIQ026747
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 18:19:46 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([9.208.130.99])
        by ppma03dal.us.ibm.com (PPS) with ESMTPS id 3pbsa04csy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 18:19:45 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32HIJi0230474988
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Mar 2023 18:19:44 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7646B58061;
        Fri, 17 Mar 2023 18:19:44 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A66F58058;
        Fri, 17 Mar 2023 18:19:44 +0000 (GMT)
Received: from li-8d37cfcc-31b9-11b2-a85c-83226d7135c9.ibm.com.com (unknown [9.65.227.169])
        by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 17 Mar 2023 18:19:43 +0000 (GMT)
From:   Nick Child <nnac123@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Nick Child <nnac123@linux.ibm.com>
Subject: [PATCH net 1/2] net: Catch invalid index in XPS mapping
Date:   Fri, 17 Mar 2023 13:19:40 -0500
Message-Id: <20230317181941.86151-1-nnac123@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: G70ZMymDmvSwzpBPE14XJSQZhWfF2Dg8
X-Proofpoint-ORIG-GUID: G70ZMymDmvSwzpBPE14XJSQZhWfF2Dg8
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-17_14,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 mlxlogscore=997 adultscore=0 mlxscore=0 impostorscore=0 lowpriorityscore=0
 clxscore=1015 malwarescore=0 priorityscore=1501 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303170122
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When setting the XPS value of a TX queue, add a conditional to ensure
that the index of the queue is less than the number of allocated TX
queues.

Previously, this scenario went uncaught. In the best case, it resulted
in unnecessary allocations. In the worst case, it resulted in
out-of-bounds memory references through calls to `netdev_get_tx_queue(
dev, index)`.

Fixes: 537c00de1c9b ("net: Add functions netif_reset_xps_queue and netif_set_xps_queue")
Signed-off-by: Nick Child <nnac123@linux.ibm.com>
---
This is a result of my own foolish mistake of giving an invalid
index to __netif_set_xps_queue [1]. While the function adds the queue to
the cpu's XPS queue map, the queue is never used due to a conditional
in __get_xps_queue_idx. But there is a risk of random memory reading
and writing that should be prevented.

1. https://lore.kernel.org/netdev/20230224183659.2a7bfeea@kernel.org/

 net/core/dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index c7853192563d..cd3878043846 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2535,6 +2535,9 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 	struct xps_map *map, *new_map;
 	unsigned int nr_ids;
 
+	if (index >= dev->num_tx_queues)
+		return -EINVAL;
+
 	if (dev->num_tc) {
 		/* Do not allow XPS on subordinate device directly */
 		num_tc = dev->num_tc;
-- 
2.31.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED4A5624D08
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 22:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbiKJVcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 16:32:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiKJVcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 16:32:41 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B8281D6
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 13:32:40 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAKp58R002037
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 21:32:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=FsZbjoj5zZQH6qrJn7pjbNxke3nccAPgOQxZiCRS8Mc=;
 b=BWmugPJ+cgyi/eSnYcCJLCjpiTd+k91Uuu5HhHmblo6ahww2t9MJ3lNfDMXpJK2hrsom
 QDu1PZVzukjQwb4ecDAX6FOk54UYDmBrrPGQGlB1BegroXuWKL+3nrvL/3OOE2dHygj3
 Z04NfnzxUq8/YTdSoWqPSsz9KuyBpZuLO1GqlNgLiYrcsnhVPobd3IV8kBnKRcBQo64h
 YtP0IusFdl5WDikMtx2HUYn7lLQFa/AgmxB1d8/jVD3zQs3W+BR4vNOO5xk1eyhZ91tq
 mmfS/o2aCrNuYPP8e5OEGxvTppJfoR6CNUZAuHXxXuB8WpN96e701MiLngp5+7zu7tsZ yw== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ks8pw8u61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 21:32:39 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AALMoa4005667
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 21:32:38 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma04wdc.us.ibm.com with ESMTP id 3kngpu6v6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 21:32:38 +0000
Received: from smtpav02.dal12v.mail.ibm.com ([9.208.128.128])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AALWf6R4522702
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 21:32:41 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D882D5805F;
        Thu, 10 Nov 2022 21:32:36 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1968E5805C;
        Thu, 10 Nov 2022 21:32:36 +0000 (GMT)
Received: from li-8d37cfcc-31b9-11b2-a85c-83226d7135c9.ibm.com (unknown [9.160.178.220])
        by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 10 Nov 2022 21:32:35 +0000 (GMT)
From:   Nick Child <nnac123@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     bjking1@linux.ibm.com, haren@linux.ibm.com, ricklind@us.ibm.com,
        mmc@linux.ibm.com, Nick Child <nnac123@linux.ibm.com>
Subject: [PATCH net-next 0/3] ibmvnic: Introduce affinity hint support
Date:   Thu, 10 Nov 2022 15:32:15 -0600
Message-Id: <20221110213218.28662-1-nnac123@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: pNVtAQw30RLRDDbDD7eeHCPQ-p6_Mmee
X-Proofpoint-GUID: pNVtAQw30RLRDDbDD7eeHCPQ-p6_Mmee
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=698 bulkscore=0 adultscore=0 phishscore=0
 spamscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2211100144
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

This is a patchset to do 3 things to improve ibmvnic performance:
    1. Assign affinity hints to ibmvnic queue irq's
    2. Update affinity hints on cpu hotplug events
    3. Introduce transmit packet steering (XPS)

NOTE: If irqbalance is running, you need to stop it from overriding 
  our affinity hints. To do this you can do one of:
   - systemctl stop irqbalance
   - ban the ibmvnic module irqs
      - you must have the latest irqbalance v9.2, the banmod argument was broken before this
      - in /etc/sysconfig/irqbalance -> IRQBALANCE_ARGS="--banmod=ibmvnic"
      - systemctl restart irqbalance

Nick Child (3):
  ibmvnic: Assign IRQ affinity hints to device queues
  ibmvnic: Add hotpluggable CPU callbacks to reassign affinity hints
  ibmvnic: Update XPS assignments during affinity binding

 drivers/net/ethernet/ibm/ibmvnic.c | 239 ++++++++++++++++++++++++++++-
 drivers/net/ethernet/ibm/ibmvnic.h |   5 +
 include/linux/cpuhotplug.h         |   1 +
 3 files changed, 244 insertions(+), 1 deletion(-)

-- 
2.31.1


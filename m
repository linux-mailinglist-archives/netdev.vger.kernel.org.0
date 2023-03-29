Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6819D6CF217
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 20:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjC2S0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 14:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjC2S0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 14:26:13 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04EA4697;
        Wed, 29 Mar 2023 11:26:12 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32TETw44017461;
        Wed, 29 Mar 2023 18:25:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=JLjZZTYyJYJMe3QiAlLr02+MhgbjP8RiniXG97TsRPo=;
 b=dhnDsOKVm4u3ThU4RDqUkja2KckYbG8iZW49yIdP1H+aMjbDiOSr8WNTn5UIevoP3wsO
 fT/NGW9yT9Neadid61p+LaYGKTY//tammszh4lJLztsC4T9bqOeXrv6Gwg5OFqsV+EIl
 iO7alpkeepM5E9M25+3YUj+thoFwsmB9hvD9hSujwNEeiHtnplQZUPZPIf3klfa+lxuW
 rmhl17yYCDzHhlWMKFwbnN7YBo/80c/G1O/fXSkZXlJY9bHKBG67tSAkBwX5td+2PMEX
 EqOph1JrijbkunnE1xcuSY0y3PI0abnmclTc6SpO2/WAN0Q0XGSGxnsfzbCe5+0PSUAH rg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pmq538pam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Mar 2023 18:25:48 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32THSmid010814;
        Wed, 29 Mar 2023 18:25:47 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3phqder9nn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Mar 2023 18:25:47 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32TIPQe3004473;
        Wed, 29 Mar 2023 18:25:47 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3phqder9hg-2;
        Wed, 29 Mar 2023 18:25:46 +0000
From:   Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        zbr@ioremap.net, brauner@kernel.org, johannes@sipsolutions.net,
        ecree.xilinx@gmail.com, leon@kernel.org, keescook@chromium.org,
        socketcan@hartkopp.net, petrm@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        anjali.k.kulkarni@oracle.com
Subject: [PATCH v3 1/7] netlink: Reverse the patch which removed filtering
Date:   Wed, 29 Mar 2023 11:25:37 -0700
Message-Id: <20230329182543.1161480-2-anjali.k.kulkarni@oracle.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230329182543.1161480-1-anjali.k.kulkarni@oracle.com>
References: <20230329182543.1161480-1-anjali.k.kulkarni@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-29_12,2023-03-28_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303290141
X-Proofpoint-GUID: Pr4T7Glmq1QnlkJl9lNh77I8LlCg81PZ
X-Proofpoint-ORIG-GUID: Pr4T7Glmq1QnlkJl9lNh77I8LlCg81PZ
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To use filtering at the connector & cn_proc layers, we need to enable
filtering in the netlink layer. This reverses the patch which removed
netlink filtering.

Signed-off-by: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
---
 include/linux/netlink.h  |  5 +++++
 net/netlink/af_netlink.c | 25 +++++++++++++++++++++++--
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index c43ac7690eca..866bbc5a4c8d 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -206,6 +206,11 @@ bool netlink_strict_get_check(struct sk_buff *skb);
 int netlink_unicast(struct sock *ssk, struct sk_buff *skb, __u32 portid, int nonblock);
 int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, __u32 portid,
 		      __u32 group, gfp_t allocation);
+int netlink_broadcast_filtered(struct sock *ssk, struct sk_buff *skb,
+			       __u32 portid, __u32 group, gfp_t allocation,
+			       int (*filter)(struct sock *dsk,
+					     struct sk_buff *skb, void *data),
+			       void *filter_data);
 int netlink_set_err(struct sock *ssk, __u32 portid, __u32 group, int code);
 int netlink_register_notifier(struct notifier_block *nb);
 int netlink_unregister_notifier(struct notifier_block *nb);
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index c64277659753..003c7e6ec9be 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1432,6 +1432,8 @@ struct netlink_broadcast_data {
 	int delivered;
 	gfp_t allocation;
 	struct sk_buff *skb, *skb2;
+	int (*tx_filter)(struct sock *dsk, struct sk_buff *skb, void *data);
+	void *tx_data;
 };
 
 static void do_one_broadcast(struct sock *sk,
@@ -1485,6 +1487,11 @@ static void do_one_broadcast(struct sock *sk,
 			p->delivery_failure = 1;
 		goto out;
 	}
+	if (p->tx_filter && p->tx_filter(sk, p->skb2, p->tx_data)) {
+		kfree_skb(p->skb2);
+		p->skb2 = NULL;
+		goto out;
+	}
 	if (sk_filter(sk, p->skb2)) {
 		kfree_skb(p->skb2);
 		p->skb2 = NULL;
@@ -1507,8 +1514,12 @@ static void do_one_broadcast(struct sock *sk,
 	sock_put(sk);
 }
 
-int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, u32 portid,
-		      u32 group, gfp_t allocation)
+int netlink_broadcast_filtered(struct sock *ssk, struct sk_buff *skb,
+			       u32 portid,
+			       u32 group, gfp_t allocation,
+			       int (*filter)(struct sock *dsk,
+					     struct sk_buff *skb, void *data),
+			       void *filter_data)
 {
 	struct net *net = sock_net(ssk);
 	struct netlink_broadcast_data info;
@@ -1527,6 +1538,8 @@ int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, u32 portid,
 	info.allocation = allocation;
 	info.skb = skb;
 	info.skb2 = NULL;
+	info.tx_filter = filter;
+	info.tx_data = filter_data;
 
 	/* While we sleep in clone, do not allow to change socket list */
 
@@ -1552,6 +1565,14 @@ int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, u32 portid,
 	}
 	return -ESRCH;
 }
+EXPORT_SYMBOL(netlink_broadcast_filtered);
+
+int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, u32 portid,
+		      u32 group, gfp_t allocation)
+{
+	return netlink_broadcast_filtered(ssk, skb, portid, group, allocation,
+					  NULL, NULL);
+}
 EXPORT_SYMBOL(netlink_broadcast);
 
 struct netlink_set_err_data {
-- 
2.40.0


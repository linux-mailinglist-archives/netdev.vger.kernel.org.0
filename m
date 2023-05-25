Return-Path: <netdev+bounces-5409-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 58B167112FC
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 20:00:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CBA481C20DE5
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 18:00:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EFC1200AE;
	Thu, 25 May 2023 18:00:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1947C101DA
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 18:00:48 +0000 (UTC)
X-Greylist: delayed 4300 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 25 May 2023 11:00:47 PDT
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [IPv6:2620:100:9001:583::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3267997
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 11:00:46 -0700 (PDT)
Received: from pps.filterd (m0050095.ppops.net [127.0.0.1])
	by m0050095.ppops.net-00190b01. (8.17.1.19/8.17.1.19) with ESMTP id 34PGlbfa007643;
	Thu, 25 May 2023 17:48:50 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=jan2016.eng;
 bh=3EoGXKaXYz2V0ugxhKu28wHo16VMn9s73c2XD3UTdOs=;
 b=JLmZdUUFroeKXjlO4k7Py0swQXaw9zNoKnDTVujSTZ4irDrW6jsfJzjyRv4FtvnsiCWX
 0GzPa3lgEIUAFwam9Sl5UPl7G/3KDS93m3QFTYFCN4OIUDEA7HNEZogjw5DKSZwQb3D9
 btTreAu63DzQQ6cx4CkPjP88im3S2ZQj92tIcLVomwCBGQ6/mAO4/ygwy/oMFrX5wlxU
 xuywV/1hAP7fFWkvqmmHBC1M9Ypps2GfEps10+oZY5oP1bU0X6l/vh5tWUNFqxUc15fF
 3TjuBfekgers01K9tmFWa1YMYxyBk1anGZ9PW+IYWx8Y7eX9ogNm1u4eZ+s07Lb+Wp8/ +g== 
Received: from prod-mail-ppoint5 (prod-mail-ppoint5.akamai.com [184.51.33.60] (may be forged))
	by m0050095.ppops.net-00190b01. (PPS) with ESMTPS id 3qpnr9rvms-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 May 2023 17:48:50 +0100
Received: from pps.filterd (prod-mail-ppoint5.akamai.com [127.0.0.1])
	by prod-mail-ppoint5.akamai.com (8.17.1.19/8.17.1.19) with ESMTP id 34PFXeKi015047;
	Thu, 25 May 2023 09:48:49 -0700
Received: from email.msg.corp.akamai.com ([172.27.91.24])
	by prod-mail-ppoint5.akamai.com (PPS) with ESMTPS id 3qpv694pyj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 May 2023 09:48:48 -0700
Received: from bos-lhv018.bos01.corp.akamai.com (172.28.222.198) by
 usma1ex-dag4mb5.msg.corp.akamai.com (172.27.91.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 25 May 2023 12:48:48 -0400
From: Max Tottenham <mtottenh@akamai.com>
To: <netdev@vger.kernel.org>
CC: Jamal Hadi Salim <jhs@mojatatu.com>, Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Amir Vadai <amir@vadai.me>,
        Josh Hunt
	<johunt@akamai.com>, Max Tottenham <mtottenh@akamai.com>
Subject: [PATCH] net/sched: act_pedit: Parse L3 Header for L4 offset
Date: Thu, 25 May 2023 12:47:41 -0400
Message-ID: <20230525164741.4188115-1-mtottenh@akamai.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.28.222.198]
X-ClientProxiedBy: usma1ex-dag4mb8.msg.corp.akamai.com (172.27.91.27) To
 usma1ex-dag4mb5.msg.corp.akamai.com (172.27.91.24)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-25_09,2023-05-25_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305250140
X-Proofpoint-GUID: sx-KI2GsDBr_3hUrsC3LiUlTWiruNY0m
X-Proofpoint-ORIG-GUID: sx-KI2GsDBr_3hUrsC3LiUlTWiruNY0m
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-25_09,2023-05-25_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 mlxlogscore=999 clxscore=1011 spamscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305250139
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Instead of relying on skb->transport_header being set correctly, opt
instead to parse the L3 header length out of the L3 headers for both
IPv4/IPv6 when the Extended Layer Op for tcp/udp is used. This fixes a
bug if GRO is disabled, when GRO is disabled skb->transport_header is
set by __netif_receive_skb_core() to point to the L3 header, it's later
fixed by the upper protocol layers, but act_pedit will receive the SKB
before the fixups are completed. The existing behavior causes the
following to edit the L3 header if GRO is disabled instead of the UDP
header:

    tc filter add dev eth0 ingress protocol ip flower ip_proto udp \
 dst_ip 192.168.1.3 action pedit ex munge udp set dport 18053

Also re-introduce a rate-limited warning if we were unable to extract
the header offset when using the 'ex' interface.

Fixes: 71d0ed7079df ("net/act_pedit: Support using offset relative to
the conventional network headers")
Signed-off-by: Max Tottenham <mtottenh@akamai.com>
Reviewed-by: Josh Hunt <johunt@akamai.com>
---
 net/sched/act_pedit.c | 47 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 42 insertions(+), 5 deletions(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index fc945c7e4123..6362aa51e00b 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -13,7 +13,10 @@
 #include <linux/rtnetlink.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
 #include <linux/slab.h>
+#include <net/ipv6.h>
 #include <net/netlink.h>
 #include <net/pkt_sched.h>
 #include <linux/tc_act/tc_pedit.h>
@@ -327,28 +330,58 @@ static bool offset_valid(struct sk_buff *skb, int offset)
 	return true;
 }
 
-static void pedit_skb_hdr_offset(struct sk_buff *skb,
+static int pedit_l4_skb_offset(struct sk_buff *skb, int *hoffset, const int header_type)
+{
+	int noff = skb_network_offset(skb);
+	struct iphdr *iph = NULL;
+	int ret = -EINVAL;
+
+	switch (skb->protocol) {
+	case htons(ETH_P_IP):
+		if (!pskb_may_pull(skb, sizeof(*iph) + noff))
+			goto out;
+		iph = ip_hdr(skb);
+		*hoffset = noff + iph->ihl * 4;
+		ret = 0;
+		break;
+	case htons(ETH_P_IPV6):
+		*hoffset = 0;
+		ret = ipv6_find_hdr(skb, hoffset, header_type, NULL, NULL) == header_type ? 0 : -EINVAL;
+		break;
+	}
+out:
+	return ret;
+}
+
+static int pedit_skb_hdr_offset(struct sk_buff *skb,
 				 enum pedit_header_type htype, int *hoffset)
 {
+	int ret = -EINVAL;
 	/* 'htype' is validated in the netlink parsing */
 	switch (htype) {
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_ETH:
-		if (skb_mac_header_was_set(skb))
+		if (skb_mac_header_was_set(skb)) {
 			*hoffset = skb_mac_offset(skb);
+			ret = 0;
+		}
 		break;
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_NETWORK:
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_IP4:
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_IP6:
 		*hoffset = skb_network_offset(skb);
+		ret = 0;
 		break;
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_TCP:
+		ret = pedit_l4_skb_offset(skb, hoffset, IPPROTO_TCP);
+		break;
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_UDP:
-		if (skb_transport_header_was_set(skb))
-			*hoffset = skb_transport_offset(skb);
+		ret = pedit_l4_skb_offset(skb, hoffset, IPPROTO_UDP);
 		break;
 	default:
+		ret = -EINVAL;
 		break;
 	}
+	return ret;
 }
 
 TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
@@ -392,7 +425,11 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
 			tkey_ex++;
 		}
 
-		pedit_skb_hdr_offset(skb, htype, &hoffset);
+		rc = pedit_skb_hdr_offset(skb, htype, &hoffset);
+		if (rc) {
+			pr_info_ratelimited("tc action pedit unable to extract header offset for header type (0x%x)\n", htype);
+			goto bad;
+		}
 
 		if (tkey->offmask) {
 			u8 *d, _d;
-- 
2.25.1



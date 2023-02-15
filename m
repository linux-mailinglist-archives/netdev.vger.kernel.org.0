Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B420F69774B
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 08:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjBOHVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 02:21:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjBOHVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 02:21:04 -0500
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C6E25B88
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 23:21:03 -0800 (PST)
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31F3NEFP001092;
        Wed, 15 Feb 2023 07:20:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id; s=qcppdkim1;
 bh=51du7OHnY6bOvbs76c/kdRXC7XxK6p27T++tv/HEDtE=;
 b=ZK/tsdCJbcYqXZEl4cBztixnhhhdDuCj13ImenBTh76/ozgmVo8oVsEChZCQxkTl8ibO
 HZg01ANsoYReYlhFVeNFC2wA/RgkV8fLrlWtCm1ecIw0TKadDXmjrcsxF2T+6qi0u+9o
 E7Nsbu3uXMa3TNFRtQcTeyL+gNiQxRnjWqawFM8W40bp4VXKYcbwLEG1XH9ysbTxQCAv
 50n7gViwhhF5JADUWYcIwLYl1LYG1Td1duy2DLC7OmWUUQpisuq5ASGvCXAKePkzF9YO
 LURkfa5hNtYf2JoOFpeyV2yoRZ+Q8sLrAQHSaU2zgyuVEhIjMcJH2kCg+TkTU8OjIJy1 5A== 
Received: from aptaippmta02.qualcomm.com (tpe-colo-wan-fw-bordernet.qualcomm.com [103.229.16.4])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3nr26u3q6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Feb 2023 07:20:51 +0000
Received: from pps.filterd (APTAIPPMTA02.qualcomm.com [127.0.0.1])
        by APTAIPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 31F7KnpV025843;
        Wed, 15 Feb 2023 07:20:49 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by APTAIPPMTA02.qualcomm.com (PPS) with ESMTPS id 3np43m9wpu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 15 Feb 2023 07:20:49 +0000
Received: from APTAIPPMTA02.qualcomm.com (APTAIPPMTA02.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31F7KnCp025822;
        Wed, 15 Feb 2023 07:20:49 GMT
Received: from maow2-gv.ap.qualcomm.com (maow2-gv.qualcomm.com [10.232.193.133])
        by APTAIPPMTA02.qualcomm.com (PPS) with ESMTP id 31F7KnIG025819;
        Wed, 15 Feb 2023 07:20:49 +0000
Received: by maow2-gv.ap.qualcomm.com (Postfix, from userid 399080)
        id CAF8F21000DA; Wed, 15 Feb 2023 15:20:47 +0800 (CST)
From:   Kassey Li <quic_yingangl@quicinc.com>
To:     davem@davemloft.net, edumazet@google.com
Cc:     Kassey Li <quic_yingangl@quicinc.com>, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH] net: disable irq in napi_poll
Date:   Wed, 15 Feb 2023 15:20:46 +0800
Message-Id: <20230215072046.4000-1-quic_yingangl@quicinc.com>
X-Mailer: git-send-email 2.17.1
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: NRaMp-lZsGXpeCtNpbIV1j9gIH-MDuqu
X-Proofpoint-ORIG-GUID: NRaMp-lZsGXpeCtNpbIV1j9gIH-MDuqu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-15_03,2023-02-14_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxscore=0 spamscore=0 impostorscore=0 malwarescore=0
 mlxlogscore=324 clxscore=1011 lowpriorityscore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302150066
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is list_del action in napi_poll, fix race condition by
disable irq.

similar report:
https://syzkaller.appspot.com/bug?id=309955e7f02812d7bfb828c22b517349d9f068
bc

list_del corruption. next->prev should be ffffff88ea0bd4c0, but was
ffffff8a787099c0
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:56!

pstate: 62400005 (nZCv daif +PAN -UAO +TCO -DIT -SSBS BTYPE=--)
pc : __list_del_entry_valid+0xa8/0xac
lr : __list_del_entry_valid+0xa8/0xac
sp : ffffffc0081bbce0
x29: ffffffc0081bbce0 x28: 0000000000000018 x27: 0000000000000059
x26: ffffffef130c6040 x25: ffffffc0081bbcf0 x24: ffffffc0081bbd00
x23: 000000010003d37f x22: 000000000000012c x21: ffffffef130c9000
x20: ffffff8a786cf9c0 x19: ffffff88ea0bd4c0 x18: ffffffc00816d030
x17: ffffffffffffffff x16: 0000000000000004 x15: 0000000000000004
x14: ffffffef131bae30 x13: 0000000000002b84 x12: 0000000000000003
x11: 0000000100002b84 x10: c000000100002b84 x9 : 1f2ede939758e700
x8 : 1f2ede939758e700 x7 : 205b5d3330383232 x6 : 302e33303331205b
x5 : ffffffef13750358 x4 : ffffffc0081bb9df x3 : 0000000000000000
x2 : ffffff8a786be9c8 x1 : 0000000000000000 x0 : 000000000000007c

Call trace:
__list_del_entry_valid+0xa8/0xac
net_rx_action+0xfc/0x3a0
_stext+0x174/0x5f4
run_ksoftirqd+0x34/0x74
smpboot_thread_fn+0x1d8/0x464
kthread+0x168/0x1dc
ret_from_fork+0x10/0x20
Code: d4210000 f000cbc0 91161000 97de537a (d4210000)
---[ end trace 8b3858d55ee59b7c ]---
Kernel panic - not syncing: Oops - BUG: Fatal exception in interrupt

Signed-off-by: Kassey Li <quic_yingangl@quicinc.com>
---
 net/core/dev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index b76fb37b381e..0c677a563232 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6660,7 +6660,9 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
 		}
 
 		n = list_first_entry(&list, struct napi_struct, poll_list);
+		local_irq_disable();
 		budget -= napi_poll(n, &repoll);
+		local_irq_enable();
 
 		/* If softirq window is exhausted then punt.
 		 * Allow this to run for 2 jiffies since which will allow
-- 
2.17.1


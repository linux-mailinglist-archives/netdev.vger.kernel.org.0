Return-Path: <netdev+bounces-869-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B25446FB1DD
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 15:43:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 30D79280D7E
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 13:43:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11F3D15B7;
	Mon,  8 May 2023 13:43:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0750515B5
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 13:43:08 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1298EE5F;
	Mon,  8 May 2023 06:43:07 -0700 (PDT)
Received: from kwepemi500026.china.huawei.com (unknown [172.30.72.56])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QFMrT3sfHzsRGW;
	Mon,  8 May 2023 21:41:13 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 kwepemi500026.china.huawei.com (7.221.188.247) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 8 May 2023 21:43:03 +0800
From: Dong Chenchen <dongchenchen2@huawei.com>
To: <edumazet@google.com>, <kuba@kernel.org>, <davem@davemloft.net>,
	<pabeni@redhat.com>
CC: <jbenc@redhat.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <yuehaibing@huawei.com>,
	<weiyongjun1@huawei.com>, Dong Chenchen <dongchenchen2@huawei.com>
Subject: [PATCH -next] net: nsh: Use correct mac_offset to unwind gso skb in nsh_gso_segment()
Date: Mon, 8 May 2023 21:42:58 +0800
Message-ID: <20230508134258.496465-1-dongchenchen2@huawei.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500026.china.huawei.com (7.221.188.247)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

As the call trace shows, skb_panic was caused by wrong skb->mac_header
in nsh_gso_segment():

invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 3 PID: 2737 Comm: syz Not tainted 6.3.0-next-20230505 #1
RIP: 0010:skb_panic+0xda/0xe0
call Trace:
 skb_push+0x91/0xa0
 nsh_gso_segment+0x4f3/0x570
 skb_mac_gso_segment+0x19e/0x270
 __skb_gso_segment+0x1e8/0x3c0
 validate_xmit_skb+0x452/0x890
 validate_xmit_skb_list+0x99/0xd0
 sch_direct_xmit+0x294/0x7c0
 __dev_queue_xmit+0x16f0/0x1d70
 packet_xmit+0x185/0x210
 packet_snd+0xc15/0x1170
 packet_sendmsg+0x7b/0xa0
 sock_sendmsg+0x14f/0x160

The root cause is:
nsh_gso_segment() use skb->network_header - nhoff to reset mac_header
in skb_gso_error_unwind() if inner-layer protocol gso fails.
However, skb->network_header may be reset by inner-layer protocol
gso function e.g. mpls_gso_segment. skb->mac_header reset by the
inaccurate network_header will be larger than skb headroom.

nsh_gso_segment
    nhoff = skb->network_header - skb->mac_header;
    __skb_pull(skb,nsh_len)
    skb_mac_gso_segment
        mpls_gso_segment
            skb_reset_network_header(skb);//skb->network_header+=nsh_len
            return -EINVAL;
    skb_gso_error_unwind
        skb_push(skb, nsh_len);
        skb->mac_header = skb->network_header - nhoff;
        // skb->mac_header > skb->headroom, cause skb_push panic

Use correct mac_offset to restore mac_header to fix it.

Fixes: c411ed854584 ("nsh: add GSO support")
Signed-off-by: Dong Chenchen <dongchenchen2@huawei.com>
---
 net/nsh/nsh.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/nsh/nsh.c b/net/nsh/nsh.c
index e9ca007718b7..17433b115058 100644
--- a/net/nsh/nsh.c
+++ b/net/nsh/nsh.c
@@ -78,6 +78,7 @@ static struct sk_buff *nsh_gso_segment(struct sk_buff *skb,
 {
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
 	unsigned int nsh_len, mac_len;
+	u16 mac_offset;
 	__be16 proto;
 	int nhoff;
 
@@ -103,13 +104,13 @@ static struct sk_buff *nsh_gso_segment(struct sk_buff *skb,
 	skb_reset_mac_header(skb);
 	skb->mac_len = proto == htons(ETH_P_TEB) ? ETH_HLEN : 0;
 	skb->protocol = proto;
+	mac_offset = skb->network_header - nhoff;
 
 	features &= NETIF_F_SG;
 	segs = skb_mac_gso_segment(skb, features);
 	if (IS_ERR_OR_NULL(segs)) {
 		skb_gso_error_unwind(skb, htons(ETH_P_NSH), nsh_len,
-				     skb->network_header - nhoff,
-				     mac_len);
+				     mac_offset, mac_len);
 		goto out;
 	}
 
-- 
2.25.1



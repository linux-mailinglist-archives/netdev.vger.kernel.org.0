Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3EC7606822
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 20:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiJTSWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 14:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiJTSWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 14:22:45 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF2B91E8B99
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 11:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666290164; x=1697826164;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7DH5Tc7N5vz5OSJxVbnZKGHjBfWMwLYi6ILT8dLaLBs=;
  b=b15DlkjRNZ3Eh/OLoFmdkvzVJu5Qmjxu+r41OyB8uYTfuqQkOu9EKhf4
   yGCCA/KwkP6es+iWEceHpBcIRNszNGlIoy/YCY6s2LUArQuErnjzmc7d7
   O2WoDIjRlmvcYU2aQ+V7MpVCE0nR41B9CCLeyDz68aSfv8pEHCeT7b1n1
   mosdeOxFQJlve0lwmXETDR+R2wco0N5qZ1t0Jljn7Q3QnTQyeK0Lkg7KK
   JvALQLM1nr0JaoAiyEFs/JFat0IrKHt5FSnAW7RLu9UFOwWXG2y4rKIe7
   SCnFSjkmd5Itbkz/GVTqjhEe0lhO/2y8NBC+391CShOYXCBUHq3bAUKZv
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,199,1661788800"; 
   d="scan'208";a="326465855"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Oct 2022 02:22:44 +0800
IronPort-SDR: Iv811/5MEm5L1bkSV3n4vt3MjXsg4COowbcVXv6Xq6B3++hMf8sUHFSZ9PQhJJaNwLsdTXZSTm
 VCqmTHrSSIUo1pptSFKYZ9pK3mnZBzOwsnZ74I4NcdhI1E2lF+F4mti6he89g/Ncq7SFCjzE+m
 hba5Gq7hPK9Zy20o2a0lU/P/VfsrylWqkUe39MUfgjlT5x3231DeRJyesg1p8gG67IlFeyEPYB
 TfS1643YBZL/lm4pRdzkbrcYp8+T/KRs3MjEhlzgnlmbcsWbsURCM/Ws3koNqqj0pQ2ruSSLOd
 amnbHPWHq8FR6vGpi8WlDJl9
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Oct 2022 10:36:33 -0700
IronPort-SDR: 7dBU/QEyrb5bp8Y7cG++CfsWL81a7TVeh/t0zxOlK5WCticwqGrH5B9EVOshFS1KMskzXmPb3L
 6KOFfsTr8muz/3ntg3rI4IJGAg5n8lgTJOORsPCnTWJbPA/CbtB/b1p209IE8FsVmcHTsfaD7t
 m97XEf8cUXJiMvLe3/uQwY6zESu5Bb8bdsy/aKARpvUFQVxHx+3v6VkSgsCMOw1oe7MKnyXuJs
 +3YKsKO3VEG5cSFHUgOLSq25BtB99ksAAh73AQh+Q4wG3075WdwbSYKK8S70b98OqhIDfZzC+T
 N7Y=
WDCIronportException: Internal
Received: from ros-3.k2.wdc.com ([10.203.225.83])
  by uls-op-cesaip02.wdc.com with ESMTP; 20 Oct 2022 11:22:43 -0700
From:   Kamaljit Singh <kamaljit.singh1@wdc.com>
To:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, Niklas.Cassel@wdc.com,
        Damien.LeMoal@wdc.com, kamaljit.singh1@wdc.com
Subject: [PATCH v1 2/2] tcp: Ignore OOO handling for TCP ACKs
Date:   Thu, 20 Oct 2022 11:22:42 -0700
Message-Id: <20221020182242.503107-3-kamaljit.singh1@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221020182242.503107-1-kamaljit.singh1@wdc.com>
References: <20221020182242.503107-1-kamaljit.singh1@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Even with the TCP window fix to tcp_acceptable_seq(), occasional
out-of-order host ACKs were still seen under heavy write workloads thus
Impacting performance.  By removing the OoO optionality for ACKs in
__tcp_transmit_skb() that issue seems to be fixed as well.

Signed-off-by: Kamaljit Singh <kamaljit.singh1@wdc.com>
---
 net/ipv4/tcp_output.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 322e061edb72..1cd77493f32c 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1307,7 +1307,10 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 	 * TODO: Ideally, in-flight pure ACK packets should not matter here.
 	 * One way to get this would be to set skb->truesize = 2 on them.
 	 */
-	skb->ooo_okay = sk_wmem_alloc_get(sk) < SKB_TRUESIZE(1);
+	if (likely(tcb->tcp_flags & TCPHDR_ACK))
+		skb->ooo_okay = 0;
+	else
+		skb->ooo_okay = sk_wmem_alloc_get(sk) < SKB_TRUESIZE(1);
 
 	/* If we had to use memory reserve to allocate this skb,
 	 * this might cause drops if packet is looped back :
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 337EE5FBB56
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 21:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbiJKT0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 15:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiJKT0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 15:26:05 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6947B2BC;
        Tue, 11 Oct 2022 12:26:04 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id f14so9600705qvo.3;
        Tue, 11 Oct 2022 12:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ovfDb0BSQYq91c2Wqb7eBFVQ1m3gfRM6gHGy1GyZAPY=;
        b=hHW8/kryxnVvjlm0s1FB1QkWJOxWHTFYpMnK7pmH4wAN3UFBSZS9FU9XmD4e+OQG6g
         KbOAiRkXwVDXi59mY4XEjMV3sc4dvBd4rGSz+1qyZyFpgQ+R8QbESAtsunYWHHS55gcb
         bVwpu7SDtgEBR5Odt4vpAOCrYtQtXgOerekDOblF4Sxvfe8mTQKiSoxGFmMhRrm3fitS
         lBhaIgVmkZdGumGxxtlKkIzpaJ7ycs+S+MEigCrw5hKB70pdzcT7y5gGAnBMt9VdbA+2
         q0iJdhic8zdMNSDUo6PcbIJpdgwgpQYyPvzXlXTdFxZ/jG2hZM7xXhfDTTZgyZgKflmM
         gMgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ovfDb0BSQYq91c2Wqb7eBFVQ1m3gfRM6gHGy1GyZAPY=;
        b=hmp+daYnIeSJY9vd+7zxIoYKCBBdXXekk715xUewbklvP3PF+kt9+tw5e4ZtJ2WkNV
         JWxxkKQWeoDpm6Mq4yg2pvcR1QEVQ7lu5tszjpIP0ZTo93uqYQxcJnICxes54YMUImhQ
         wtDniixu7hwv99wVAqE7RvrvKow0eq3HELjw2RnF5h4qZrFpYjJO1ArP5HKNcNRtKcXk
         r0+h1iFmyYnJn6Mjz6SrVgACC0bpCwxtKMiS/K45W87iDp+93EcHdfezGltpE36aMGaa
         EwGehO1ofQe6mn+UhOerULsryWQzMyfhCsoQ5l1QxwA4DhqGrY0JE9SRG3oJR2guFmFu
         en9w==
X-Gm-Message-State: ACrzQf2fHrsZ+u9Og6gvZb4OAVSNwtXTnpd3BpkgZ5nnxUXoY+0cHB4D
        Bzf9GkFiLKO4Wd2HCTeQoQt/uhYgorZZqQ==
X-Google-Smtp-Source: AMsMyM52jEEQp+CBpRMBYgSSzr1Zj3F2MrcxK+wc/LAJrcYemx1m3hnd9ijcFDRZPyis6lRkzVg3Uw==
X-Received: by 2002:a0c:cd13:0:b0:4b3:beaa:83b with SMTP id b19-20020a0ccd13000000b004b3beaa083bmr17478297qvm.129.1665516363188;
        Tue, 11 Oct 2022 12:26:03 -0700 (PDT)
Received: from localhost (cpec09435e3ea83-cmc09435e3ea81.cpe.net.cable.rogers.com. [99.235.148.253])
        by smtp.gmail.com with UTF8SMTPSA id fd6-20020a05622a4d0600b00342f8984348sm10686415qtb.87.2022.10.11.12.26.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Oct 2022 12:26:02 -0700 (PDT)
From:   Cezar Bulinaru <cbulinaru@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     cbulinaru@gmail.com
Subject: [PATCH] net: hyperv: bugcheck trigered by memcpy in rndis_filter
Date:   Tue, 11 Oct 2022 15:25:45 -0400
Message-Id: <20221011192545.11236-1-cbulinaru@gmail.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A bugcheck is trigered when the response message len exceeds
the size of rndis_message. Inside the rndis_request structure
these fields are however followed by a RNDIS_EXT_LEN padding
so it is safe to use unsafe_memcpy.

memcpy: detected field-spanning write (size 168) of single field "(void *)&request->response_msg + (sizeof(struct rndis_message) - sizeof(union rndis_message_container)) + sizeof(*req_id)" at drivers/net/hyperv/rndis_filter.c:338 (size 40)
RSP: 0018:ffffc90000144de0 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff8881766b4000 RCX: 0000000000000000
RDX: 0000000000000102 RSI: 0000000000009ffb RDI: 00000000ffffffff
RBP: ffffc90000144e38 R08: 0000000000000000 R09: 00000000ffffdfff
R10: ffffc90000144c48 R11: ffffffff82f56ac8 R12: ffff8881766b403c
R13: 00000000000000a8 R14: ffff888100b75000 R15: ffff888179301d00
FS:  0000000000000000(0000) GS:ffff8884d6280000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055f8b024c418 CR3: 0000000176548001 CR4: 00000000003706e0
Call Trace:
 <IRQ>
 ? _raw_spin_unlock_irqrestore+0x27/0x50
 netvsc_poll+0x556/0x940 [hv_netvsc]
 __napi_poll+0x2e/0x170
 net_rx_action+0x299/0x2f0
 __do_softirq+0xed/0x2ef
 __irq_exit_rcu+0x9f/0x110
 irq_exit_rcu+0xe/0x20
 sysvec_hyperv_callback+0xb0/0xd0
 </IRQ>
 <TASK>
 asm_sysvec_hyperv_callback+0x1b/0x20
RIP: 0010:native_safe_halt+0xb/0x10

Signed-off-by: Cezar Bulinaru <cbulinaru@gmail.com>
---
 drivers/net/hyperv/rndis_filter.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 11f767a20444..eea777ec2541 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -20,6 +20,7 @@
 #include <linux/vmalloc.h>
 #include <linux/rtnetlink.h>
 #include <linux/ucs2_string.h>
+#include <linux/string.h>
 
 #include "hyperv_net.h"
 #include "netvsc_trace.h"
@@ -335,9 +336,10 @@ static void rndis_filter_receive_response(struct net_device *ndev,
 		if (resp->msg_len <=
 		    sizeof(struct rndis_message) + RNDIS_EXT_LEN) {
 			memcpy(&request->response_msg, resp, RNDIS_HEADER_SIZE + sizeof(*req_id));
-			memcpy((void *)&request->response_msg + RNDIS_HEADER_SIZE + sizeof(*req_id),
+			unsafe_memcpy((void *)&request->response_msg + RNDIS_HEADER_SIZE + sizeof(*req_id),
 			       data + RNDIS_HEADER_SIZE + sizeof(*req_id),
-			       resp->msg_len - RNDIS_HEADER_SIZE - sizeof(*req_id));
+			       resp->msg_len - RNDIS_HEADER_SIZE - sizeof(*req_id),
+			       "request->response_msg is followed by a padding of RNDIS_EXT_LEN inside rndis_request");
 			if (request->request_msg.ndis_msg_type ==
 			    RNDIS_MSG_QUERY && request->request_msg.msg.
 			    query_req.oid == RNDIS_OID_GEN_MEDIA_CONNECT_STATUS)
-- 
2.37.1


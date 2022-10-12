Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6715FBEE7
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 03:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbiJLBkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 21:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiJLBkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 21:40:12 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE4189833;
        Tue, 11 Oct 2022 18:40:11 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id f8so2253243qkg.3;
        Tue, 11 Oct 2022 18:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6hVTqqYPj6ENgPeQnODDyt+swinMg+j5ooL61E5+ju8=;
        b=ojSVRhEk2uQJFJXLvhVskSGz05hl+HUMnrC2VPHfOOC6BnFZIQQ54/PKX0eC2X0YQD
         CHgKq6Pqz8GE3ji+8TIWP8Ft5KvLhz8sca2y6MIwvjEzLiPChs7CEQA5GsIbzzCwI4rx
         +02Ot8VeWH22CVIsHiUTkhX3E2THG6g/G6D8jLhQZuHO7AuWeg7kSn3HNUv5e2pv4Ym0
         ++7mI2JzmWP7Uk6WsscerqFobtnvavbwghhaFuDzsbnGuNNsHbCTjv480sBjjuM45F8M
         8VTTUKlTgFZx/4ElPJD8c7HY8E2ZFwFvQxIYLb6XQMDjaG/9WmKpsV+OXNEp/F60m8w4
         T0pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6hVTqqYPj6ENgPeQnODDyt+swinMg+j5ooL61E5+ju8=;
        b=E79t7laniX15g8FvCMXzTXBvep1q+tSGr8Xuv+KN/HIxbhL9S8dV9BfDYDljqtZj6P
         CILRXywLdGeVWMBn/BbLvnYKD6OOpA9ie7CiZKJTB7LpdScQtedYVhmYUacuz0KMPPYW
         yJxdgh7h5GFWXfvyaj9VU/rCnihEY3g5HAMraDTJ3yWo50uvnvj17MO0WKAeMazk+jEq
         BWDPjnUODoa9U1WbBeAQ2qwkSh01RELJkTPi1LVT5nOv/zImPzaMiRpKAx9YQqdtLulj
         +4stBtS6YcZM4RqvGJvb3qfIAXDnub4CMk2mdqxAGyaMElxkWMZFZls5XlONlKgLRZMQ
         lVug==
X-Gm-Message-State: ACrzQf3DkJPs2fGHjf2w+nHkAMX456BLR4EgU1E3pgxTCixXjd8wQdXi
        ZShmgsllCGov2W7Oy24I/vo=
X-Google-Smtp-Source: AMsMyM7QCzGCS6NlJN54xVPLq8gobHgIjog8Awq1yPl9LYXoMfwydhSmMizL2wcgsJq6T+9cq0efJg==
X-Received: by 2002:a05:620a:450e:b0:6ce:499f:ca8a with SMTP id t14-20020a05620a450e00b006ce499fca8amr18812633qkp.5.1665538810248;
        Tue, 11 Oct 2022 18:40:10 -0700 (PDT)
Received: from localhost (cpec09435e3ea83-cmc09435e3ea81.cpe.net.cable.rogers.com. [99.235.148.253])
        by smtp.gmail.com with UTF8SMTPSA id u10-20020a05620a430a00b006ce7cd81359sm14275704qko.110.2022.10.11.18.40.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Oct 2022 18:40:09 -0700 (PDT)
From:   Cezar Bulinaru <cbulinaru@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     cbulinaru@gmail.com
Subject: [PATCH v2] hv_netvsc: Fix a warning triggered by memcpy in rndis_filter
Date:   Tue, 11 Oct 2022 21:39:22 -0400
Message-Id: <20221012013922.32374-1-cbulinaru@gmail.com>
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

A warning is triggered when the response message len exceeds
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


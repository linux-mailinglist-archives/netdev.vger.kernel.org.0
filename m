Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0E65FE71E
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 04:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiJNCpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 22:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbiJNCpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 22:45:32 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B73EA6B2;
        Thu, 13 Oct 2022 19:45:30 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id i9so2503181qvu.1;
        Thu, 13 Oct 2022 19:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ABXjfWD1HfWlaDYb98DlEmp68ByH83Ag8aVCNesB2RU=;
        b=fDB3O+A0/U7VFtxQ7fcT9BWnA2CNSNNIQGLTKpJ7/Mvb3vngwyrZA41MP9Mm21YWFN
         Z/LTpYS3av06ScI+lVdHUDOTJvxVChU4TOj1QcZMBwkXmXPdnZQ/kyzCpWhaF9ktW3pi
         rAiiXjcwetMoYC07eA3TUHOeZ9q/anhlMSkvd2fXQWQ6ZJmU5Dm+h2A9HNwNAPN0vPs+
         gANdeQxdQjKbYFoXGuHYik8ZWGPtgLZPWzRcQsuLWvsgMm+4KB6B0oogL/+p60b0ys7R
         vy1Lppk2dN6dey4pjv5ya/PijKUVM8Kx5rhy5pVCp9l+ypm2SnXJzgcUBqOSb0efGw5D
         jrbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ABXjfWD1HfWlaDYb98DlEmp68ByH83Ag8aVCNesB2RU=;
        b=DeyNwGVorxF81gfGU8wEj+BAahgB1L8dR+XuwV41+dVJQeTLaqeeh8wuz+/WE6mO6V
         kNfXUkN1jXdd/2DfhvFusxkpfMueQEDtfhRzMxDBCLFt1CHDdTBlRGTSj1/PxOD6d5ln
         1SHvNXdsbAweBG083oOZmnXSURy4EjNoMP3JiZ+Tg/TAyufFNIXGkmHVrVYgc6n7fFoF
         QhzZkv7TuuSrHwWZfAklzLQgmuROp9NrwQPHNWSEEpkqf7eTwh9YNuQ66Vn1loolhAD9
         sTAPFNJaNICWpieJmgKIwhC2xCwR9gMF3In6wWXzJTJi5n7Gm47tnV/RK8Y+xk4NpCLo
         W2oQ==
X-Gm-Message-State: ACrzQf01DF6OmdLDDN9NMJmY2rEoFjxsGhWxhT5OnbphrvRZVnXqwB9n
        4jH842YuZ0ibJVZvSg4V/jM=
X-Google-Smtp-Source: AMsMyM4bPEkCE1NupQQdsfOrgzlVIGzOikSw3o/J9/g7Mpm/vMGUL5r5T1CANbugamSgKvrijncE1w==
X-Received: by 2002:a05:6214:1c85:b0:4af:9303:6d4b with SMTP id ib5-20020a0562141c8500b004af93036d4bmr2579679qvb.125.1665715529933;
        Thu, 13 Oct 2022 19:45:29 -0700 (PDT)
Received: from localhost (cpec09435e3ea83-cmc09435e3ea81.cpe.net.cable.rogers.com. [99.235.148.253])
        by smtp.gmail.com with UTF8SMTPSA id d9-20020ac85349000000b00343057845f7sm1146178qto.20.2022.10.13.19.45.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Oct 2022 19:45:28 -0700 (PDT)
From:   Cezar Bulinaru <cbulinaru@gmail.com>
To:     pabeni@redhat.com, kys@microsoft.com, haiyangz@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     cbulinaru@gmail.com, Michael Kelley <mikelley@microsoft.com>
Subject: [PATCH v3] net: hv_netvsc: Fix a warning triggered by memcpy in rndis_filter
Date:   Thu, 13 Oct 2022 22:45:03 -0400
Message-Id: <20221014024503.4533-1-cbulinaru@gmail.com>
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

Fixes: A warning triggered when the response message len exceeds
the size of rndis_message. Inside the rndis_request structure
these fields are however followed by a RNDIS_EXT_LEN padding
so it is safe to use unsafe_memcpy.

Reviewed-by: Michael Kelley <mikelley@microsoft.com>
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


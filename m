Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92BDA65FB1A
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 06:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbjAFFwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 00:52:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231734AbjAFFvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 00:51:17 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D436953B
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 21:50:55 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id d3so677949plr.10
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 21:50:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=yonsei-ac-kr.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=t+qdYTHGNX1gZGvBPLPYRf16zOkIZFw6KuEhvxQN70w=;
        b=voIz5z2EkkNAcV8sybCQtGdPUu8WWforAaJECQPsCHI6W4gVbbJW+QlmNB81mDNqnN
         leKZ3UD5wdUt4jPxCbpze35ZelKauQ/znuz54e3O3azqxiHoAcj5+Yi1/7/rT3P8kRhi
         +fBKYsWy2mfEJQcSqtP7ycGoroKV2B8To5AvYRc3HW4KPRtTc3LPfySMyuqV9MwpZSaw
         A6NrS6N2SyplHHpDe12sGfThlTaamcRvLYGlNZno3MDvF0Op0SA6NXUGHoXvVF5olAhM
         sqMuMWOITZf/BkjiUbhWRLzStG8iABSiCtHJ2YG/a2drEdtC/ZxmPDfoJc6JW34p4lvS
         9qqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t+qdYTHGNX1gZGvBPLPYRf16zOkIZFw6KuEhvxQN70w=;
        b=lJ+RLNGr/yJpOyD7g6KnH20MU3/Il56lbZsQ17QaqcfiuS34TtyxMtJwqpsQ1Z/QyY
         F6psutxJQt3/iYj1b4UH/G5FLHZ1SvSWMGjqMPqE3CGLFT0z2IBX4pwdqC/PkbvdvpOt
         65oOEpqISgc/5zLcuE7PLbuFIaKcyuot229u7jxNns/HRqp5z1JD4nD0B/XiZ3MewLVI
         TzesIcSreaPV4Ca2a6oBI02ZvmnSIHVih+RUC/G2HbVQLrdOmovLqEOlUJVsnOgk3GRC
         +JwnQcUSVfqkWHeXRi4P0yqJpYagDQEpVREWUIOhYvCz+T0psTswBNi7uCRr3BEWUQYU
         XHGQ==
X-Gm-Message-State: AFqh2kqebOHYxJMjnFv6vg3hVIfws4BzRWcymrpDrHS8LA+4BsUMP6ss
        U7UDvZsDBvH00as2RxYVsUMT
X-Google-Smtp-Source: AMrXdXtrk7FupWApyTj2C2OBWhTpiRNQ8KQWzUpN4Hop+PjnQlWNA3v8vV+O4vKrHFLWjU/0bvJjXw==
X-Received: by 2002:a17:90a:4ca2:b0:21d:5e73:d562 with SMTP id k31-20020a17090a4ca200b0021d5e73d562mr57398360pjh.27.1672984255361;
        Thu, 05 Jan 2023 21:50:55 -0800 (PST)
Received: from localhost.localdomain ([165.132.118.55])
        by smtp.gmail.com with ESMTPSA id e3-20020a17090a728300b00226ac24cf95sm2088463pjg.41.2023.01.05.21.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 21:50:54 -0800 (PST)
From:   Jisoo Jang <jisoo.jang@yonsei.ac.kr>
To:     pabeni@redhat.com, krzysztof.kozlowski@linaro.org,
        netdev@vger.kernel.org
Cc:     edumazet@google.com, kuba@kernel.org, dokyungs@yonsei.ac.kr,
        linuxlovemin@yonsei.ac.kr
Subject: [PATCH v2] net: nfc: Fix use-after-free in local_cleanup()
Date:   Fri,  6 Jan 2023 14:50:50 +0900
Message-Id: <20230106055050.873324-1-jisoo.jang@yonsei.ac.kr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

local_cleanup(). When detaching an nfc device, local_cleanup()
called from nfc_llcp_unregister_device() frees local->rx_pending
and cancels local->rx_work. So the socket allocated before
unregister is not set null by nfc_llcp_rx_work().
local_cleanup() called from local_release() frees local->rx_pending
again, which leads to the bug.

Set local->rx_pending to NULL in local_cleanup()

Found by a modified version of syzkaller.

BUG: KASAN: use-after-free in kfree_skb
Call Trace:
 kfree_skb
 local_cleanup
 nfc_llcp_local_put
 llcp_sock_destruct
 __sk_destruct
 sk_destruct
 __sk_free
 sk_free
 llcp_sock_release
 __sock_release
 sock_close
 __fput
 task_work_run
 exit_to_user_mode_prepare
 syscall_exit_to_user_mode
 do_syscall_64
 entry_SYSCALL_64_after_hwframe

Allocate by:
 __alloc_skb
 pn533_recv_response
 __usb_hcd_giveback_urb
 usb_hcd_giveback_urb
 dummy_timer
 call_timer_fn
 run_timer_softirq
 __do_softirq

Freed by:
 kfree_skbmem
 kfree_skb
 local_cleanup
 nfc_llcp_unregister_device
 nfc_unregister_device
 pn53x_unregister_nfc
 pn533_usb_disconnect
 usb_unbind_interface
 device_release_driver_internal
 bus_remove_device
 device_del
 usb_disable_device
 usb_disconnect
 hub_event
 process_one_work
 worker_thread
 kthread
 ret_from_fork


Signed-off-by: Jisoo Jang <jisoo.jang@yonsei.ac.kr>
---
v1->v2: set local->rx_pending to NULL instead move kfree_skb()

 net/nfc/llcp_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/nfc/llcp_core.c b/net/nfc/llcp_core.c
index 3364caabef8b..a27e1842b2a0 100644
--- a/net/nfc/llcp_core.c
+++ b/net/nfc/llcp_core.c
@@ -157,6 +157,7 @@ static void local_cleanup(struct nfc_llcp_local *local)
 	cancel_work_sync(&local->rx_work);
 	cancel_work_sync(&local->timeout_work);
 	kfree_skb(local->rx_pending);
+	local->rx_pending = NULL;
 	del_timer_sync(&local->sdreq_timer);
 	cancel_work_sync(&local->sdreq_timeout_work);
 	nfc_llcp_free_sdp_tlv_list(&local->pending_sdreqs);
-- 
2.25.1


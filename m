Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5A77665C52
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 14:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjAKNTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 08:19:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbjAKNTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 08:19:23 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D82CD1AA05
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 05:19:19 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id v13-20020a17090a6b0d00b00219c3be9830so17116222pjj.4
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 05:19:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=yonsei-ac-kr.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rkcBO/k3WvWV+72qjuR1kNbi+T0F9uj1wQj1g18LQDw=;
        b=pkaQS8YKhNuQ4tiSq1XbjVYPV1nbcy9KiXFp8DeTySPxUcOfZ8JNStcZn1v6DSFsfN
         dWszhury/okSHP43VHI7xsutB8caSzX0eI8Q3lRxPS9HpOawIvTz3B3R+zO4H6w7x8AQ
         z6M5tY4x4H/knukrkqxAHgiyyE/7o7C8lKBbOhdDzWVkC8XYuakqKW4/A2yrg9d+ZGRB
         luXADEPiWdf3m75kZUkrNa6wKJ8dZ+CfMJMvbgmyW3ITdMIDeIYM3OtEVwfF6Rkc5cQL
         LSLVXD16TH+Mpml09oxbzWdAuG4iAiuiFGhgsqK3YdRguodY0zUdBiTgvoz9JoFeYgk+
         +ntg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rkcBO/k3WvWV+72qjuR1kNbi+T0F9uj1wQj1g18LQDw=;
        b=XKHmOerZZtGWyk7YNEKx0SWiheAHPAu+Xq+wRnKF9GEf3DTpiX5mxyPmTVjUSrcpdZ
         ylKLdhgDDOQNgXH/8d8ukFDEOYNqkYsj2mBKFFfDZcazodM6giJeF2+beRIg09F0TuNy
         HDKvkUZLoV3aFQFHtuKjvgCbvz/KIGmK8xmms4+izKw3ZzvkYVJjoTUgb4En78pD3nAQ
         FeTOnejDIt+JfV2jnzrFkekcFem3bjosgfXkPk88gqqamP9bAh8OAuWTFoTn2NuNlp0P
         nILPI1ykGNgGKyp8MXTkBs6RB1ahtCpU7d/B0gu8TF6M9FxZiNnwxBAj78ssxveDR/y+
         +cCA==
X-Gm-Message-State: AFqh2krrHWn/LXZMpLoefETiyDvFrbSIWiq+BITYbTpxmSsIa+kb/Iw6
        tzBT37kqtxyghq61AA7GFp67
X-Google-Smtp-Source: AMrXdXtOKKaIqVtpOO6hdRBv8YjSUkELYLfca96cRbqtBAjypV/rkVvLGnlfhp/jW1GGIZDyCW3yhA==
X-Received: by 2002:a17:903:240b:b0:192:8bee:3e29 with SMTP id e11-20020a170903240b00b001928bee3e29mr63231647plo.2.1673443159392;
        Wed, 11 Jan 2023 05:19:19 -0800 (PST)
Received: from localhost.localdomain ([165.132.118.55])
        by smtp.gmail.com with ESMTPSA id b16-20020a170902d51000b0018b025d9a40sm10092996plg.256.2023.01.11.05.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 05:19:18 -0800 (PST)
From:   Jisoo Jang <jisoo.jang@yonsei.ac.kr>
To:     pabeni@redhat.com, krzysztof.kozlowski@linaro.org,
        netdev@vger.kernel.org
Cc:     edumazet@google.com, kuba@kernel.org, dokyungs@yonsei.ac.kr,
        linuxlovemin@yonsei.ac.kr
Subject: [PATCH v4] net: nfc: Fix use-after-free in local_cleanup()
Date:   Wed, 11 Jan 2023 22:19:14 +0900
Message-Id: <20230111131914.3338838-1-jisoo.jang@yonsei.ac.kr>
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

Fix a use-after-free that occurs in kfree_skb() called from
local_cleanup(). This could happen when killing nfc daemon (e.g. neard)
after detaching an nfc device.
When detaching an nfc device, local_cleanup() called from
nfc_llcp_unregister_device() frees local->rx_pending and decreases
local->ref by kref_put() in nfc_llcp_local_put().
In the terminating process, nfc daemon releases all sockets and it leads
to decreasing local->ref. After the last release of local->ref,
local_cleanup() called from local_release() frees local->rx_pending
again, which leads to the bug.

Setting local->rx_pending to NULL in local_cleanup() could prevent
use-after-free when local_cleanup() is called twice.

Found by a modified version of syzkaller.

BUG: KASAN: use-after-free in kfree_skb()

Call Trace:
dump_stack_lvl (lib/dump_stack.c:106)
print_address_description.constprop.0.cold (mm/kasan/report.c:306)
kasan_check_range (mm/kasan/generic.c:189)
kfree_skb (net/core/skbuff.c:955)
local_cleanup (net/nfc/llcp_core.c:159)
nfc_llcp_local_put.part.0 (net/nfc/llcp_core.c:172)
nfc_llcp_local_put (net/nfc/llcp_core.c:181)
llcp_sock_destruct (net/nfc/llcp_sock.c:959)
__sk_destruct (net/core/sock.c:2133)
sk_destruct (net/core/sock.c:2181)
__sk_free (net/core/sock.c:2192)
sk_free (net/core/sock.c:2203)
llcp_sock_release (net/nfc/llcp_sock.c:646)
__sock_release (net/socket.c:650)
sock_close (net/socket.c:1365)
__fput (fs/file_table.c:306)
task_work_run (kernel/task_work.c:179)
ptrace_notify (kernel/signal.c:2354)
syscall_exit_to_user_mode_prepare (kernel/entry/common.c:278)
syscall_exit_to_user_mode (kernel/entry/common.c:296)
do_syscall_64 (arch/x86/entry/common.c:86)
entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:106)

Allocated by task 4719:
kasan_save_stack (mm/kasan/common.c:45)
__kasan_slab_alloc (mm/kasan/common.c:325)
slab_post_alloc_hook (mm/slab.h:766)
kmem_cache_alloc_node (mm/slub.c:3497)
__alloc_skb (net/core/skbuff.c:552)
pn533_recv_response (drivers/nfc/pn533/usb.c:65)
__usb_hcd_giveback_urb (drivers/usb/core/hcd.c:1671)
usb_giveback_urb_bh (drivers/usb/core/hcd.c:1704)
tasklet_action_common.isra.0 (kernel/softirq.c:797)
__do_softirq (kernel/softirq.c:571)

Freed by task 1901:
kasan_save_stack (mm/kasan/common.c:45)
kasan_set_track (mm/kasan/common.c:52)
kasan_save_free_info (mm/kasan/genericdd.c:518)
__kasan_slab_free (mm/kasan/common.c:236)
kmem_cache_free (mm/slub.c:3809)
kfree_skbmem (net/core/skbuff.c:874)
kfree_skb (net/core/skbuff.c:931)
local_cleanup (net/nfc/llcp_core.c:159)
nfc_llcp_unregister_device (net/nfc/llcp_core.c:1617)
nfc_unregister_device (net/nfc/core.c:1179)
pn53x_unregister_nfc (drivers/nfc/pn533/pn533.c:2846)
pn533_usb_disconnect (drivers/nfc/pn533/usb.c:579)
usb_unbind_interface (drivers/usb/core/driver.c:458)
device_release_driver_internal (drivers/base/dd.c:1279)
bus_remove_device (drivers/base/bus.c:529)
device_del (drivers/base/core.c:3665)
usb_disable_device (drivers/usb/core/message.c:1420)
usb_disconnect (drivers/usb/core.c:2261)
hub_event (drivers/usb/core/hub.c:5833)
process_one_work (arch/x86/include/asm/jump_label.h:27 include/linux/jump_label.h:212 include/trace/events/workqueue.h:108 kernel/workqueue.c:2281)
worker_thread (include/linux/list.h:282 kernel/workqueue.c:2423)
kthread (kernel/kthread.c:319)
ret_from_fork (arch/x86/entry/entry_64.S:301)

Signed-off-by: Jisoo Jang <jisoo.jang@yonsei.ac.kr>
---
v1->v2: set local->rx_pending to NULL instead move kfree_skb()
v2->v3: fix the bug description
v3->v4: fix the bug description

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


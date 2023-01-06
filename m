Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADC465FB72
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 07:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbjAFGdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 01:33:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjAFGdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 01:33:00 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 454EA126
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 22:32:58 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id o21so664060pjw.0
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 22:32:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=yonsei-ac-kr.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fuEVwrUhS9DqW2tM+yf55mIY3uKm2NXsJBTgzHk3rbM=;
        b=LQ7W5RyET22aWk/Anm7mkyZN3Pg9IWdQ0londA6MxE3/JnLtMpzz2Dke8gVemh7kck
         PJKAj+kQliJoN3+UojLCmnMDfWG6jntJCvcZ5qB0h1lOIpM9AHEFPD4NX7yN2xupWCIm
         Yvrb9Ckf0Dqdr4OHtLjfZZ8VpZVhBpZjwu9qQCVPLJHyyhpMW9Hs4QL0MNy2ZHHYUdSN
         ss648tOnbflYGSGF2TRry/7//8/AJYKJ9iPxJ/PdyK1WarYdcboJN8ExZDJhna08Utfh
         yWo+mn+wSf4F0/qG2X91M0jAtZ0aZsBlfqGRxu/4ofRTp5DyQ4WIoNxloSa373w0VBnU
         1LMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fuEVwrUhS9DqW2tM+yf55mIY3uKm2NXsJBTgzHk3rbM=;
        b=yzeoOtbrqaO6X86Ku+ZLRD5MpOVoLNcSS1SN9HaL5JNDlkMPbG4zFpS7mMCr2zUGoC
         80gI/FG6cMXiu5dCSm6NJ0M80pl5s82WBPAVm24qSmqKomOC94l3inCl997uqAkz6FLt
         w4kSgTgLYiIoZUQqhFQbP2+9EfJW0bNMALTTVdmw/FxvmTWLF9192Sbi1MKooXmR5DEE
         wQhYDMEE58ohotgl9WXd/EezfLqoVr4aGoKgBciNeRUrVjpv0igVrsD81RV+s+L+CzwV
         bnPJkpJZ3xM6UkELeLGw+/00QLjwxvCkLL5xkeukT0DvYwIeJHR1GJ2ZHAf+fR/NCd6u
         DRGg==
X-Gm-Message-State: AFqh2krUYCqcneB7H4pepv4wI1epU+kk3+ozKEGu7H56gLf2v+qH4L4B
        eHdQEgOS1ixM/yAhGKDj9OI3
X-Google-Smtp-Source: AMrXdXsWTboYPcalbdu5u70DJVtXa6RN5O2lXQS5hJHBjFImLRcyQ3BYRDpcEcPXzqmVj8hIFTcjiQ==
X-Received: by 2002:a17:902:ce04:b0:189:b4d0:aee with SMTP id k4-20020a170902ce0400b00189b4d00aeemr71782685plg.67.1672986777781;
        Thu, 05 Jan 2023 22:32:57 -0800 (PST)
Received: from localhost.localdomain ([165.132.118.55])
        by smtp.gmail.com with ESMTPSA id iw21-20020a170903045500b00177fb862a87sm166677plb.20.2023.01.05.22.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 22:32:57 -0800 (PST)
From:   Jisoo Jang <jisoo.jang@yonsei.ac.kr>
To:     pabeni@redhat.com, krzysztof.kozlowski@linaro.org,
        netdev@vger.kernel.org
Cc:     edumazet@google.com, kuba@kernel.org, dokyungs@yonsei.ac.kr,
        linuxlovemin@yonsei.ac.kr
Subject: [PATCH v3] net: nfc: Fix use-after-free in local_cleanup()
Date:   Fri,  6 Jan 2023 15:32:53 +0900
Message-Id: <20230106063253.877394-1-jisoo.jang@yonsei.ac.kr>
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
v2->v3: fix the bug description

---
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


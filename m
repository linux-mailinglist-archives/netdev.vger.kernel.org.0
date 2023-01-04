Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3915865D37F
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 13:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233232AbjADM5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 07:57:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjADM5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 07:57:44 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA8CE1007B
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 04:57:42 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id c6so2574779pls.4
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 04:57:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=yonsei-ac-kr.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4nA7JdkDynSfrXRqChmo/xJPtdzs7lWUFIe7MiCyGXQ=;
        b=n8j8RJmIpYukKO8dyHd24phTm6E3zL1GXcWyrsT4xGRq9y+tx8r7tRU/hTyGpMyJav
         uiSO6w/BZg9GiBlx9i6ugGpTcK4Rx8DvemqUdEBCZVduIpyZfpJo5Oza2jmPbstZsBfV
         cXxNK+Jkg+5g9aW1bQzTFnA30TFEFboHAEv8Bbk3aaGBlQBeajkBD8X30RFGtwLPZ/xx
         Fy/+zJVRj7vrHq/6ayCN/DO4OXKlaCPsT+/bulLlOFJKntIZPbL9hUbxanS9k/22My+W
         XrEKm+mdhXL9eVOJnxpR66S7eS6MSGaBlMnTjr0lzrmNYZgLErjErodvidtgMbkKPMlJ
         9Rgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4nA7JdkDynSfrXRqChmo/xJPtdzs7lWUFIe7MiCyGXQ=;
        b=Nuc8ts3jxlrC32cfwCX22wCBp2P1XIWlNli+eydgwVHJoIAAJe0QbR8gSAGRdgFOwm
         1wpT3kxZxv9L/lXVA3Yyjhn8GKHPMnItHyoLR7EbnqlgM6ievQWFi3WsG4uAKphEu8CP
         D6EuaTPEwjMHXK5a0KwQYWFxaihvNjD+cQLXRseMTRzeZjBixvY1RujW3ZElweai0tUD
         e7oLBDDDvqyQUF54lbOoMjiWdWPWoTTLO71DRLboaFPTItObDDlJLyB5ch3cIyvfqfR4
         9i9k7wuxRawIIBXy1l+x5zj2c2FWvVZN+x/2xCaAdRFILslhLAy4FpqdT/yJTGDDz48w
         kubQ==
X-Gm-Message-State: AFqh2kpr/USLlk2NFQdi5MWCxqmdsxS3v4B1ciAjBAJxKtBhfi9hvgWE
        bri3ssW1hGpRV8+3B+PnOxCG
X-Google-Smtp-Source: AMrXdXviA7zPIZWZbcN+c2wTRezg+qzL25X7uEdva57D0yaO6+INO0ljIjnf0Ym1MDR0K2+YS9TCXA==
X-Received: by 2002:a17:902:fe0c:b0:192:5c3e:8939 with SMTP id g12-20020a170902fe0c00b001925c3e8939mr41002679plj.0.1672837062447;
        Wed, 04 Jan 2023 04:57:42 -0800 (PST)
Received: from localhost.localdomain ([165.132.118.55])
        by smtp.gmail.com with ESMTPSA id u7-20020a17090341c700b00189988a1a9esm24230728ple.135.2023.01.04.04.57.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 04:57:42 -0800 (PST)
From:   Jisoo Jang <jisoo.jang@yonsei.ac.kr>
To:     krzysztof.kozlowski@linaro.org, netdev@vger.kernel.org
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        dokyungs@yonsei.ac.kr, linuxlovemin@yonsei.ac.kr
Subject: [PATCH] net: nfc: Fix use-after-free in local_cleanup()
Date:   Wed,  4 Jan 2023 21:57:38 +0900
Message-Id: <20230104125738.418427-1-jisoo.jang@yonsei.ac.kr>
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

Ensure kfree_skb() is called once when unregistering the device.

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
 net/nfc/llcp_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/nfc/llcp_core.c b/net/nfc/llcp_core.c
index 3364caabef8b..cbf2ef0af57b 100644
--- a/net/nfc/llcp_core.c
+++ b/net/nfc/llcp_core.c
@@ -156,7 +156,6 @@ static void local_cleanup(struct nfc_llcp_local *local)
 	cancel_work_sync(&local->tx_work);
 	cancel_work_sync(&local->rx_work);
 	cancel_work_sync(&local->timeout_work);
-	kfree_skb(local->rx_pending);
 	del_timer_sync(&local->sdreq_timer);
 	cancel_work_sync(&local->sdreq_timeout_work);
 	nfc_llcp_free_sdp_tlv_list(&local->pending_sdreqs);
@@ -170,6 +169,7 @@ static void local_release(struct kref *ref)
 
 	list_del(&local->list);
 	local_cleanup(local);
+	kfree_skb(local->rx_pending);
 	kfree(local);
 }
 
-- 
2.25.1


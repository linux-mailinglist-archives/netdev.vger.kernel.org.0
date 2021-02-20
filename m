Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 244983202AE
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 02:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhBTBpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 20:45:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbhBTBpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 20:45:23 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0253C06178A
        for <netdev@vger.kernel.org>; Fri, 19 Feb 2021 17:44:42 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id b5so3832244qka.16
        for <netdev@vger.kernel.org>; Fri, 19 Feb 2021 17:44:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=lkx/1n1XTmEjSnBjwj9YX++Tm4ZPP9ikGerEFgccbPw=;
        b=jmc6S+ECED++E0XuxEv8z17lyPmtHSYNRRS9RvglSCdgNoh6zNpBMfjIg6MGjWW4lW
         qbdIxZ62xIpKUnEI1Fl94n5zszoKigH79rHIbUy9lriOGL/mqGLj0oxORLii8acZI4TP
         oHwKVRR0MEXoon3fpmnbSSgpv5Jo+sXvCkN5wDFAYu4/8dShgdLK5tpiTkubzVWtv9qS
         W38tFFQ4gr8kXWSTr2Rg8g5SZlMp4eA3LY0E4Cw8SC3LW9MYoe+Uit+Iqqe0YVWV4UuD
         d8sExh3ai1EU55MbforNYym9mQ/EUtcSOB6SCerXO6zSH4YbsXixQg0clB/STEO+lRvV
         nFFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lkx/1n1XTmEjSnBjwj9YX++Tm4ZPP9ikGerEFgccbPw=;
        b=mBRaqenQLKLBb6JLr5qxGhT8sS6VA1su4wQXTHYC8noydrBAXiHK3tix3OxXkumvXH
         8FjZ9Fn9TUty7tGt1CMP/R/sJCGM9M01jT44MPfDDYch52EQgT9afcnVmhS8HY+8vHdb
         ffMDHNVJfM6gAbwBQUzPY9djnK7a5Fuq/1YViQqQ/6uss3B9B3F4OGZH+LfAFqdUnJu1
         jccBE7HesRi3UT6APpZFUtZHZex3GEV0tOVC8MnfE6i9q60rznJtEIWRCF1QsZa17b+g
         BEQSg5NoFBhL401hUT0wANIRBwByTn6vS2c4PSRJmIlqai/7/QpDmBrfF0iqYICbIUQd
         2utg==
X-Gm-Message-State: AOAM531CyWzT/bZYHxBMGt0ygmVLan7a9zmuZt0ArHX8MypCWeakDyfC
        0Wibq9RDBG2SEssx9brwgOWddAmTAsc=
X-Google-Smtp-Source: ABdhPJyAvTGsGRJ18wIEyOkIPrf0vVCIGlPwIwPrL7MDexokI/IaTm5y7GXiVq3hHSh9IELNEjwh5PS0nY0=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:9433:f9ff:6bb7:ac32])
 (user=weiwan job=sendgmr) by 2002:ad4:55c5:: with SMTP id bt5mr11686543qvb.58.1613785482012;
 Fri, 19 Feb 2021 17:44:42 -0800 (PST)
Date:   Fri, 19 Feb 2021 17:44:36 -0800
In-Reply-To: <20210220014436.3556492-1-weiwan@google.com>
Message-Id: <20210220014436.3556492-3-weiwan@google.com>
Mime-Version: 1.0
References: <20210220014436.3556492-1-weiwan@google.com>
X-Mailer: git-send-email 2.30.0.617.g56c4b15f3c-goog
Subject: [PATCH net v2 2/2] virtio-net: suppress bad irq warning for tx napi
From:   Wei Wang <weiwan@google.com>
To:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Willem de Bruijn <willemb@google.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the implementation of napi-tx in virtio driver, we clean tx
descriptors from rx napi handler, for the purpose of reducing tx
complete interrupts. But this could introduce a race where tx complete
interrupt has been raised, but the handler found there is no work to do
because we have done the work in the previous rx interrupt handler.
This could lead to the following warning msg:
[ 3588.010778] irq 38: nobody cared (try booting with the
"irqpoll" option)
[ 3588.017938] CPU: 4 PID: 0 Comm: swapper/4 Not tainted
5.3.0-19-generic #20~18.04.2-Ubuntu
[ 3588.017940] Call Trace:
[ 3588.017942]  <IRQ>
[ 3588.017951]  dump_stack+0x63/0x85
[ 3588.017953]  __report_bad_irq+0x35/0xc0
[ 3588.017955]  note_interrupt+0x24b/0x2a0
[ 3588.017956]  handle_irq_event_percpu+0x54/0x80
[ 3588.017957]  handle_irq_event+0x3b/0x60
[ 3588.017958]  handle_edge_irq+0x83/0x1a0
[ 3588.017961]  handle_irq+0x20/0x30
[ 3588.017964]  do_IRQ+0x50/0xe0
[ 3588.017966]  common_interrupt+0xf/0xf
[ 3588.017966]  </IRQ>
[ 3588.017989] handlers:
[ 3588.020374] [<000000001b9f1da8>] vring_interrupt
[ 3588.025099] Disabling IRQ #38

This patch sets no_interrupt_check in tx vring_virtqueue, when napi-tx
is enabled, to suppress the warning in such case.

Fixes: 7b0411ef4aa6 ("virtio-net: clean tx descriptors from rx napi")
Reported-by: Rick Jones <jonesrick@google.com>
Signed-off-by: Wei Wang <weiwan@google.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 drivers/net/virtio_net.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 508408fbe78f..18b14739d63e 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1303,13 +1303,22 @@ static void virtnet_napi_tx_enable(struct virtnet_info *vi,
 		return;
 	}
 
+	/* With napi_tx enabled, free_old_xmit_skbs() could be called from
+	 * rx napi handler. Set no_interrupt_check to suppress bad irq warning
+	 * for IRQ_NONE case from tx complete interrupt handler.
+	 */
+	virtqueue_set_no_interrupt_check(vq, true);
+
 	return virtnet_napi_enable(vq, napi);
 }
 
-static void virtnet_napi_tx_disable(struct napi_struct *napi)
+static void virtnet_napi_tx_disable(struct virtqueue *vq,
+				    struct napi_struct *napi)
 {
-	if (napi->weight)
+	if (napi->weight) {
 		napi_disable(napi);
+		virtqueue_set_no_interrupt_check(vq, false);
+	}
 }
 
 static void refill_work(struct work_struct *work)
@@ -1835,7 +1844,7 @@ static int virtnet_close(struct net_device *dev)
 	for (i = 0; i < vi->max_queue_pairs; i++) {
 		xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
 		napi_disable(&vi->rq[i].napi);
-		virtnet_napi_tx_disable(&vi->sq[i].napi);
+		virtnet_napi_tx_disable(vi->sq[i].vq, &vi->sq[i].napi);
 	}
 
 	return 0;
@@ -2315,7 +2324,7 @@ static void virtnet_freeze_down(struct virtio_device *vdev)
 	if (netif_running(vi->dev)) {
 		for (i = 0; i < vi->max_queue_pairs; i++) {
 			napi_disable(&vi->rq[i].napi);
-			virtnet_napi_tx_disable(&vi->sq[i].napi);
+			virtnet_napi_tx_disable(vi->sq[i].vq, &vi->sq[i].napi);
 		}
 	}
 }
@@ -2440,7 +2449,7 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	if (netif_running(dev)) {
 		for (i = 0; i < vi->max_queue_pairs; i++) {
 			napi_disable(&vi->rq[i].napi);
-			virtnet_napi_tx_disable(&vi->sq[i].napi);
+			virtnet_napi_tx_disable(vi->sq[i].vq, &vi->sq[i].napi);
 		}
 	}
 
-- 
2.30.0.617.g56c4b15f3c-goog


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C20265FC8
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 14:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbgIKMsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 08:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgIKMn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 08:43:56 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864A7C061756
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 05:43:53 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id n3so2606365pjq.1
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 05:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ITiFeh3Q8Nr8XtNfDb5ORJd8PPTafM3yzfr3WnDZkm4=;
        b=OmOyab9eJvaeiyNLyKKebKce+jWgg1yxLoSjd20jJdvOiC7BkMSWaUV2uFIarGCStw
         w3hivDmW44jbZGyX38myoXjNP9aX3j1rRlCKHSSKTCZHJrQcrLzBkQj89e6CZzO9fQ7k
         I+vDWF7zx5tPYt9FmVQZRw1WdHS3SKySnwxxXuiW4BbdeavFdHN1wPUsN9/dA6nOSFkq
         MTVWQrf4cIBUqfpjX5sgv2KboBrZJwpDq3+rjDNjGRh/9AghK90BD+GAY8ybbT3KQ9nP
         kvizt8I2Kx5iUDgogh1o9egRQ6nIpLrXvNtvMUagPO/bztV/EYDQz6LTx9KS0FUjGn+G
         bSOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ITiFeh3Q8Nr8XtNfDb5ORJd8PPTafM3yzfr3WnDZkm4=;
        b=UK6E8ECqFKcNVVLvd4EUYs+2rUEqW19H67uEBEd9h4IN54zhH2zhzshGKXucT0yFFu
         UqdrZaJCGbk15gsC2SWoJqhrEzaYg7OmIc32Yfti5yb7iDcFV4tMvYFgSxjcs85d49oe
         tkaMAe1/GKjSnOmbPbq1svrZmSwC3HQOAx5ISAwMOMLEz69DCDT1TcUpUs117tB2dxTf
         24Dr/FKjOLxfD31x/1xcZ+atii8rEXjvxQfiXNdmEP6WrQ12AKGlo9ggAPdUE2XIVYkU
         ffZkWypEnRM8o8nOGlBDoF0Y8D5R1TnkaGltB0My3UXsvVRYhyX/BTmtSIY5gcQZmLkn
         pceg==
X-Gm-Message-State: AOAM5300Poa+lZRH6fkGMjX6g2sB+KRGdaaQ3JRPENEh5ZMe6GqshbRv
        cNhOc9JZcjw6Xmb48zzL8BA=
X-Google-Smtp-Source: ABdhPJzgXXvWn70QZ3vs64tZxg1XYPGFr143EnnER02R1Y+3pYHggZZzRxPYjhodRmJO40AZuAjc4w==
X-Received: by 2002:a17:90a:d3c2:: with SMTP id d2mr2100789pjw.112.1599828233077;
        Fri, 11 Sep 2020 05:43:53 -0700 (PDT)
Received: from VM.ger.corp.intel.com ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id 82sm1917540pgd.6.2020.09.11.05.43.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Sep 2020 05:43:52 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     A.Zema@falconvsystems.com
Subject: [PATCH bpf v4] xsk: do not discard packet when NETDEV_TX_BUSY
Date:   Fri, 11 Sep 2020 14:43:41 +0200
Message-Id: <1599828221-19364-1-git-send-email-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

In the skb Tx path, transmission of a packet is performed with
dev_direct_xmit(). When NETDEV_TX_BUSY is set in the drivers, it
signifies that it was not possible to send the packet right now,
please try later. Unfortunately, the xsk transmit code discarded the
packet and returned EBUSY to the application. Fix this unnecessary
packet loss, by not discarding the packet in the Tx ring and return
EAGAIN. As EAGAIN is returned to the application, it can then retry
the send operation later and the packet will then likely be sent as
the driver will then likely have space/resources to send the packet.

In summary, EAGAIN tells the application that the packet was not
discarded from the Tx ring and that it needs to call send()
again. EBUSY, on the other hand, signifies that the packet was not
sent and discarded from the Tx ring. The application needs to put the
packet on the Tx ring again if it wants it to be sent.

Fixes: 35fcde7f8deb ("xsk: support for Tx")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Reported-by: Arkadiusz Zema <A.Zema@falconvsystems.com>
Suggested-by: Arkadiusz Zema <A.Zema@falconvsystems.com>
Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
---
v3->v4:
* Free the skb without triggering the drop trace when NETDEV_TX_BUSY
* Call consume_skb instead of kfree_skb when the packet has been
  sent successfully for correct tracing
* Use sock_wfree as destructor when NETDEV_TX_BUSY
v1->v3:
* Hinder dev_direct_xmit() from freeing and completing the packet to
  user space by manipulating the skb->users count as suggested by
  Daniel Borkmann.
---
 net/xdp/xsk.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index c323162..d32e39d 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -377,15 +377,30 @@ static int xsk_generic_xmit(struct sock *sk)
 		skb_shinfo(skb)->destructor_arg = (void *)(long)desc.addr;
 		skb->destructor = xsk_destruct_skb;
 
+		/* Hinder dev_direct_xmit from freeing the packet and
+		 * therefore completing it in the destructor
+		 */
+		refcount_inc(&skb->users);
 		err = dev_direct_xmit(skb, xs->queue_id);
+		if  (err == NETDEV_TX_BUSY) {
+			/* Tell user-space to retry the send */
+			skb->destructor = sock_wfree;
+			/* Free skb without triggering the perf drop trace */
+			__kfree_skb(skb);
+			err = -EAGAIN;
+			goto out;
+		}
+
 		xskq_cons_release(xs->tx);
 		/* Ignore NET_XMIT_CN as packet might have been sent */
-		if (err == NET_XMIT_DROP || err == NETDEV_TX_BUSY) {
+		if (err == NET_XMIT_DROP) {
 			/* SKB completed but not sent */
+			kfree_skb(skb);
 			err = -EBUSY;
 			goto out;
 		}
 
+		consume_skb(skb);
 		sent_frame = true;
 	}
 
-- 
2.7.4


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D538E26C81E
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 20:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbgIPSla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 14:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728007AbgIPS2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 14:28:48 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6163DC0698FE
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 05:00:44 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id w7so3851621pfi.4
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 05:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=1le4DTARMbrHPXyWfwyAoP+2vFGgktTmW78DRFKnSHo=;
        b=CMwrMbz04vxhPGAqkFa9abs0apbcNU5KZTsxtPIfjt8HRnd0wtHHUNao2tStxzX1ms
         5afHTch+h+r3FNkBQ1XfOaRgfoIJoF7ISXccXTDmuFOzsy2Cd8b5IIFkgpr923ggUnsv
         R3lU4g/Pq0tSoflwsUTUnqJCdVkmsz5LvxfTvmVzViqfpAYKsexRVKRHTjDYuOQsLhOc
         tiCTsSagfipMi8btbRYHeZ+/a5bc/LHPbBefiiAwfA76MU8cnBwqVIiBT0jOtXosB/wj
         rbHEfqp0j0EWvUr1qW9o6Eftt3IoBALwWx0ApwPX6BUKpgD90gjahHsrHlRt6pYSjxFi
         9bWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1le4DTARMbrHPXyWfwyAoP+2vFGgktTmW78DRFKnSHo=;
        b=uDHZodri8MjQKRmSqVAERPaIbuKI8TuKlXZMXmAQic8YP/rAM4hZsxn3QYO1mEoTue
         kTWxR6JsXK+GLbOmrscyZWdAA3rdM0gFgsYj6sYXxaate0Fykf68ueTqSSWPXFe3fWaS
         BzYFytSnjO9SIHwtaWA0SwKStsHrARjvgwzDsobVFftWkOY4rM5zBdtNX0n0wWxu45Vi
         OexBtQugnWXwB2OX4dKOvKisE2L4XQ6ftonXh9Tg/nE77TYNNICuPhtW/HbqHB9ip7Nl
         kaFwL6PlfT5Z54zIweRQs+Qw+XhgAE+lGcFGX2FWWLqUfnOcGRZTePDTyQZAdjuGr2sv
         JR6Q==
X-Gm-Message-State: AOAM533oV2Zm/FFZq0H+ePPAVJvP4I/BC/Ax4SkCxB/sBS8ex79cYw5A
        hbZ8LC+6GFKhcArnUtRag+E=
X-Google-Smtp-Source: ABdhPJw6t/xbcAIHzz3K9sIwJH7Il/dA50sA9Xo0VHzuJFqOIQ1me6qla5fzNfr2bSArbHeOakOq0g==
X-Received: by 2002:a62:3706:0:b029:142:2501:39e5 with SMTP id e6-20020a6237060000b0290142250139e5mr6416602pfa.52.1600257638289;
        Wed, 16 Sep 2020 05:00:38 -0700 (PDT)
Received: from VM.ger.corp.intel.com ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id q190sm18141145pfq.99.2020.09.16.05.00.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Sep 2020 05:00:37 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     A.Zema@falconvsystems.com
Subject: [PATCH bpf v5] xsk: do not discard packet when NETDEV_TX_BUSY
Date:   Wed, 16 Sep 2020 14:00:25 +0200
Message-Id: <1600257625-2353-1-git-send-email-magnus.karlsson@gmail.com>
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
v4->v5:
* Replaced __kfree_skb() with consume_skb()
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
index c323162..6c5e09e 100644
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
+			consume_skb(skb);
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


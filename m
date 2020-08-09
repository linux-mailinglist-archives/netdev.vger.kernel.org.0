Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD1D823FC32
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 04:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgHICgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 22:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbgHICgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Aug 2020 22:36:20 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E6AC061756;
        Sat,  8 Aug 2020 19:36:20 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id j21so3044344pgi.9;
        Sat, 08 Aug 2020 19:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kub7wUC7iBpeOQedwXMHPG2fSSd6JGXHHrf1fpHFbPE=;
        b=t7tPPT0uU7FlYa5L++Ikfzy6rXwiljuECk4lu27SHPAazvDNgSpuEhfFcZmx93l1AH
         4FXV9lW+dfDAsIT2irs4JEaXxK5+3SEpW94sI3r5vATWanaXb+QxPhujqw21y2fOjc8A
         rcF4sU0WgHaJeTdFZr3QnBI0Ib/YIiwWPQmwVUpHpBGOnupStR9XSZUz8KuKSWb7QBj1
         ySmX1yVqxYQpcpdm4w676QrfjnI4WURyuCRNcPjyRzuYZoUsIFrg8BJvnG/Wp4hFUbX3
         d+87ReIhWqwn2GaEwpDHlszH3AcIy1PcTIa9PJsrm9XNE0bi2rQSI4/JxSfGF9fGEMnn
         4Krw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kub7wUC7iBpeOQedwXMHPG2fSSd6JGXHHrf1fpHFbPE=;
        b=WWr0VdZhq3e/18bmLCewcS/RHHhdaoXmkM2Tps5jnZS3/tidJyI/OSE3CbnlUtSMnI
         54VU2ZSO3pilOB6RIEHrLw+7mCEt0OUODANOa8eEOGCSD8IauHHerMJCryEQimg0cCfU
         xBvqrh79NylDHOaKjWtBUlzqU1VH5UcoiMIkZ4xdYyBFbfj9QFfossFsSKwWrVyJbrGD
         9cRhBXteEAlR36f8GV85aH635yb7wKbbTDMCmDud1SxXkWM4FWLt6qIrj6XZ4B3kRG2b
         KfF3zbf9/Gv1PkYeuycGfUVRvo0cw5U4xsKsqJyKyXSVh9lZH0tEfIPoSy6GluPJ3rKC
         EpzQ==
X-Gm-Message-State: AOAM533w5MtdYxQBXofqdXxwMlf1RIkazgOp3VMn52/tEKrEVQlvXKrL
        RONv1ZOdFP/kwQFd5QtVw98=
X-Google-Smtp-Source: ABdhPJzBKl/FpkmB9RNIJz9i97dyxxK2mcalwmGHXp0o63E43rV9CYCkzDT49Htdm+uZqq+Iz0Jg7Q==
X-Received: by 2002:a63:cd56:: with SMTP id a22mr16634662pgj.259.1596940579278;
        Sat, 08 Aug 2020 19:36:19 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8880:9ae0:8cf2:183:7fb5:ce6a])
        by smtp.gmail.com with ESMTPSA id gn13sm15280089pjb.17.2020.08.08.19.36.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2020 19:36:18 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-x25@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH net] drivers/net/wan/x25_asy: Added needed_headroom and a skb->len check
Date:   Sat,  8 Aug 2020 19:35:48 -0700
Message-Id: <20200809023548.684217-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. Added a skb->len check

This driver expects upper layers to include a pseudo header of 1 byte
when passing down a skb for transmission. This driver will read this
1-byte header. This patch added a skb->len check before reading the
header to make sure the header exists.

2. Added needed_headroom

When this driver transmits data,
  first this driver will remove a pseudo header of 1 byte,
  then the lapb module will prepend the LAPB header of 2 or 3 bytes.
So the value of needed_headroom in this driver should be 3 - 1.

Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/x25_asy.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wan/x25_asy.c b/drivers/net/wan/x25_asy.c
index 84640a0c13f3..de7984463595 100644
--- a/drivers/net/wan/x25_asy.c
+++ b/drivers/net/wan/x25_asy.c
@@ -307,6 +307,14 @@ static netdev_tx_t x25_asy_xmit(struct sk_buff *skb,
 		return NETDEV_TX_OK;
 	}
 
+	/* There should be a pseudo header of 1 byte added by upper layers.
+	 * Check to make sure it is there before reading it.
+	 */
+	if (skb->len < 1) {
+		kfree_skb(skb);
+		return NETDEV_TX_OK;
+	}
+
 	switch (skb->data[0]) {
 	case X25_IFACE_DATA:
 		break;
@@ -752,6 +760,12 @@ static void x25_asy_setup(struct net_device *dev)
 	dev->type		= ARPHRD_X25;
 	dev->tx_queue_len	= 10;
 
+	/* When transmitting data:
+	 * first this driver removes a pseudo header of 1 byte,
+	 * then the lapb module prepends an LAPB header of at most 3 bytes.
+	 */
+	dev->needed_headroom	= 3 - 1;
+
 	/* New-style flags. */
 	dev->flags		= IFF_NOARP;
 }
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7D22F2151
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 23:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732615AbfKFWEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 17:04:12 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52553 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbfKFWEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 17:04:11 -0500
Received: by mail-wm1-f66.google.com with SMTP id c17so5854212wmk.2;
        Wed, 06 Nov 2019 14:04:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6r8I0SCpSbo6ngTh6F9dpz6iIrvn5396OXePTnNw2U8=;
        b=h9fFXGfhomwsrDhIOPlDTH9/XZNGxhz0qH64mPq2HdxKiW+ySowOe8rBfq/r3/Rcb1
         Ep6ozet54YeOvC9w4iZxIgXZIQVl3yNw/LSMRDaPpW/nLocNKuRCSL2+hLMWvAHPkwHJ
         BGih7Jj9wc2zeknUzfCLNwBI0jfMnzbomsz2MrLY53Idlye719FyMGPZchdeIxJCQQcp
         uHnWr/s2NTDxuif8+uqR++6vBEFK6kIq6Khbh3RhnmbMk6NnQXwvr0jf9M4msqza8cuk
         5ByxgtrHj5Dovio4lWjryoIrXCQSHxT9jSTp20o3FAZQ7ti/jX9vr98SKhmke9oFYXV6
         Mdmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6r8I0SCpSbo6ngTh6F9dpz6iIrvn5396OXePTnNw2U8=;
        b=hhs32uvq4AZeTiL4irV2cjtwEK9nQjDUOIFFnIBJlIdu3Ts0MXh2xBjpFkLjRjWtfd
         7GK+Hixagh0rqM0Ls3IXI3KugMj9XfO+xEZYNdXKF3eo+nrBHTzQtVfnLd/HSPFwGEf9
         K8U5TFTbBi+0U8J7kNqwThjjcXb5VeKw0uf6Rn9r+Fq19SG9Y6dcpdIeEWUKQ7x6TWc/
         4pHO9O1kofjioeP2Pzr+ZZhhwLNK4GAL1mjhYoQvvowuqEGGxQ7DlyM3M+WGurtYObgw
         HLAu5s36w7t/HJQpiWPaYh8BwU69wZJdCeq5dOuADmRP46oNdEULxJaFlv5MxtHTpB/J
         EEUw==
X-Gm-Message-State: APjAAAWbCFvdSAHimBTPAPYji2CM2p3h/u6dZActAzpeLYTtUteMFToq
        2qWYulOY2ZccBh/sFQXHW1A=
X-Google-Smtp-Source: APXvYqwqZSYx00vA5vA5YuZhAaxFTgiX+RTj4W8pTe+SVTWIv7moEx0LZFAY7DH06jt1HBx1FrPN7Q==
X-Received: by 2002:a05:600c:295:: with SMTP id 21mr4400198wmk.43.1573077847737;
        Wed, 06 Nov 2019 14:04:07 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a00-1028-9192-7022-5e51-4fff-feaa-03a7.ipv6.broadband.iol.cz. [2a00:1028:9192:7022:5e51:4fff:feaa:3a7])
        by smtp.gmail.com with ESMTPSA id b3sm3958842wma.13.2019.11.06.14.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 14:04:07 -0800 (PST)
From:   Jaroslav Beran <jara.beran@gmail.com>
To:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jaroslav Beran <jara.beran@gmail.com>
Subject: [PATCH] can: return error from can_send() in BUS-OFF state
Date:   Wed,  6 Nov 2019 23:03:02 +0100
Message-Id: <20191106220302.27698-1-jara.beran@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a CAN node reaches BUS-OFF state, its netdev state
is set to __LINK_STATE_NOCARRIER and qdisc ->enqueue() starts
dropping frames and returning NET_XMIT_CN that is turned to 0
by net_xmit_errno(). So can_send() returns success to a sender
even if his frame is lost.

As this behavior is inappropriate for a node in BUS-OFF state,
this patch adds a check for no-carrier condition and returns
-ENETUNREACH in such case.

Signed-off-by: Jaroslav Beran <jara.beran@gmail.com>
---
 net/can/af_can.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/can/af_can.c b/net/can/af_can.c
index 5518a7d9eed9..68c56241733b 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -189,6 +189,7 @@ static int can_create(struct net *net, struct socket *sock, int protocol,
  * Return:
  *  0 on success
  *  -ENETDOWN when the selected interface is down
+ *  -ENETUNREACH when the node is in BUS-OFF state
  *  -ENOBUFS on full driver queue (see net_xmit_errno())
  *  -ENOMEM when local loopback failed at calling skb_clone()
  *  -EPERM when trying to send on a non-CAN interface
@@ -233,6 +234,11 @@ int can_send(struct sk_buff *skb, int loop)
 		goto inval_skb;
 	}
 
+	if (unlikely(!netif_carrier_ok(skb->dev))) {
+		err = -ENETUNREACH;
+		goto inval_skb;
+	}
+
 	skb->ip_summed = CHECKSUM_UNNECESSARY;
 
 	skb_reset_mac_header(skb);
-- 
2.23.0


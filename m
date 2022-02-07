Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79F1C4AB886
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 11:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358319AbiBGKNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 05:13:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244822AbiBGKIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 05:08:04 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F56C043188;
        Mon,  7 Feb 2022 02:08:03 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id o2so338270lfd.1;
        Mon, 07 Feb 2022 02:08:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=5ZYkPwg18yvgYmxef6AHb9YRCv03BOZBd8uaes0yfmU=;
        b=BImELJqolH8kWQxr9XGv4T5MGYJ1xxUA9DFudLwNIJp/qFidf+f+k0qqn2rvcKldrS
         dsJBlpE3U7TU5ERAm9ZLuAaiB+2Zt5l3FmFdpTUF+RrO6kj4uyoMu3AIj889D72f6lgd
         78Aoo6eeRYZTWfmpsIUU96YRFb00rHhtvwmMk21z5s7RRD5BpGhuhKe/Nm+UHQsl0Swo
         q/tJNPLf3GQaKWeneh2a8BHH/bwZGyeOvWn1Z+IOULCtPsW4I9fnsei/4qRgid8p0mf9
         2KlViLmsHZC5Y4z3tPJykwJWxgP7YBlMD9yribUP7tCj4hwq6tNv3MNQGxzbjSGlmfBX
         U3qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=5ZYkPwg18yvgYmxef6AHb9YRCv03BOZBd8uaes0yfmU=;
        b=6rvtJNIra8OsflPuxPMaFp5cEth0ThAmv+vGVlvlLRGKMO5KywnbtLrYOmqai+V5JB
         o/P4mu6h3lWQrhrQ+Cs7uRhpI4u5nio89XO3qV9znpai82d3+3N7rPHYXDhFJIt6gnCH
         9nRhoXERYlURsjYEa+VWucN8eSTW9O7iuNmiZN8P/zXWsjG4eq4svBOwKMZCF+x2+YTW
         lvktE56N77y6CjfgN6rKB8nZcEnLsZDTXF+fR17ozXdQQjaxB6n0BylXLP3qCsR5EtVF
         3qyP3xhRqdvoEPCtOcswfpms6S0zT7B6l7wRvcIA4Hi1xYOIokyApzMz3sqQAfbQGv/c
         NsNQ==
X-Gm-Message-State: AOAM5317LEQDFQI3S9zjTnAlxFktMCX6l2Rr44ZMZ8bi5v9Pz588pPZd
        lKW8Z5uMAnevKXasJJwwSaORjko3WWqN/2DOMXXaCVBf
X-Google-Smtp-Source: ABdhPJzsUrKR8lnToa/dHKe+tICvmhMzOl6mok7Lb4Lbwj0Qa6EnKIiBBtXDKSGm5cijBHo/AdALIA==
X-Received: by 2002:ac2:5201:: with SMTP id a1mr7540563lfl.146.1644228481827;
        Mon, 07 Feb 2022 02:08:01 -0800 (PST)
Received: from wse-c0127.beijerelectronics.com ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id k12sm1546034ljh.45.2022.02.07.02.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 02:08:01 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/4] net: bridge: dsa: Add support for offloading of locked port flag
Date:   Mon,  7 Feb 2022 11:07:40 +0100
Message-Id: <20220207100742.15087-3-schultz.hans+netdev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220207100742.15087-1-schultz.hans+netdev@gmail.com>
References: <20220207100742.15087-1-schultz.hans+netdev@gmail.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Various switchcores support setting ports in locked mode, so that
clients behind locked ports cannot send traffic through the port
unless a fdb entry is added with the clients MAC address.

Among the switchcores that support this feature is the Marvell
mv88e6xxx family.

Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
---
 net/bridge/br_switchdev.c | 2 +-
 net/dsa/port.c            | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index f8fbaaa7c501..bf549fc22556 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -72,7 +72,7 @@ bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
 
 /* Flags that can be offloaded to hardware */
 #define BR_PORT_FLAGS_HW_OFFLOAD (BR_LEARNING | BR_FLOOD | \
-				  BR_MCAST_FLOOD | BR_BCAST_FLOOD)
+				  BR_MCAST_FLOOD | BR_BCAST_FLOOD | BR_PORT_LOCKED)
 
 int br_switchdev_set_port_flag(struct net_bridge_port *p,
 			       unsigned long flags,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index bd78192e0e47..01ed22ed74a1 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -176,7 +176,7 @@ static int dsa_port_inherit_brport_flags(struct dsa_port *dp,
 					 struct netlink_ext_ack *extack)
 {
 	const unsigned long mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
-				   BR_BCAST_FLOOD;
+				   BR_BCAST_FLOOD | BR_PORT_LOCKED;
 	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
 	int flag, err;
 
@@ -200,7 +200,7 @@ static void dsa_port_clear_brport_flags(struct dsa_port *dp)
 {
 	const unsigned long val = BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD;
 	const unsigned long mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
-				   BR_BCAST_FLOOD;
+				   BR_BCAST_FLOOD | BR_PORT_LOCKED;
 	int flag, err;
 
 	for_each_set_bit(flag, &mask, 32) {
-- 
2.30.2


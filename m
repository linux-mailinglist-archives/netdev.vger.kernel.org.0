Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3186AE0A5
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 14:33:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjCGNdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 08:33:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbjCGNd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 08:33:28 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3337A241D3
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 05:33:26 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id m6so17080316lfq.5
        for <netdev@vger.kernel.org>; Tue, 07 Mar 2023 05:33:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678196004;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6i3TQ7dgfshYjVByUVnvqz197G1zfKW2kbPj/QF4oFw=;
        b=JrvN5qYfPRqTHJgUv10lLMyNqUQFutOU59fh6DcjCJfkr4eGqlYheWN+CjmOGwdXjy
         5uEvAHonWi//IV0gTn0YNQWUMYkv57h62Q1B/bYq4iH/pbEziLGwYXnraD9uVh+lBA9G
         WpM7fDoTDzn2fVyBqxtMXgiu8xfuMQ79GSwbEdNT6OSbk465jJImRM4Ha/4xgc0cV7vV
         /YOlsSiTRbRN5t3LJXEFWe0B2KUWA6UuYPf4OTZUyVHJBW+I5atFdTnTRnXMuRXW7xg7
         jgbG1jBRZygrnAwb7EkSFzTtvCeaEdprOE4BSNBHbFNAoU1YzNmGfoXYDe3JDyQh7Ogq
         BzBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678196004;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6i3TQ7dgfshYjVByUVnvqz197G1zfKW2kbPj/QF4oFw=;
        b=Besl39Mw6LNbsbpj0jEpYY/5Dd9XevnbLnn27fbpeHj2Hd6k1wafrutlGSQk7pxSFR
         5lP2X/F7CfJKlfXcy9mqS3Bon1Oqc75ooGlMG8vrna5mtDO5Y5730N70LGeZrAQaTaTF
         9Q2pWZm7A2WyyKwThE8EZeSeH8lKNdRd7K6nllo2KwKHzzUfpbSQZqtQa2b31wdrGHhC
         /3oK4/l5ii34jjRFRC+SMBXh8uMI9AFgU30LoXaTgcaCeAlQYc2lZklfEGPoU0MZv3R7
         Pm3pQHgG2qeJ2GL/Bn1q62Trh21OitKtUhoSbsWKTNAJPh83WKms7ji6AeQ0TcboctlF
         tMmQ==
X-Gm-Message-State: AO0yUKUJO7jNzl30Yyu/7DVoCBLgM29TYk5tce1equ2N+3N+yd/dIiX8
        Fg1+9ALT2EzNJLmRbgW1AbND4PuLml+fTg==
X-Google-Smtp-Source: AK7set8d/WVr0drDGR9yIxhcnsiSQZ9lw4jd5d/MmIkuE7rABPTUdC/G7REjtXpu7ZR6sfMzIs5W6Q==
X-Received: by 2002:ac2:532b:0:b0:4dd:af74:fe1a with SMTP id f11-20020ac2532b000000b004ddaf74fe1amr3868102lfh.48.1678196003905;
        Tue, 07 Mar 2023 05:33:23 -0800 (PST)
Received: from oss-build.. (3peqmh0.ip.hatteland.com. [46.250.209.192])
        by smtp.gmail.com with ESMTPSA id d6-20020ac241c6000000b004d575f56227sm2029652lfi.114.2023.03.07.05.33.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 05:33:23 -0800 (PST)
From:   Kristian Overskeid <koverskeid@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Kristian Overskeid <koverskeid@gmail.com>
Subject: [PATCH] net: hsr: Don't log netdev_err message on unknown prp dst node
Date:   Tue,  7 Mar 2023 14:32:29 +0100
Message-Id: <20230307133229.127442-1-koverskeid@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If no frames has been exchanged with a node for HSR_NODE_FORGET_TIME, the
node will be deleted from the node_db list. If a frame is sent to the node
after it is deleted, a netdev_err message for each slave interface is
produced. This should not happen with dan nodes because of supervision
frames, but can happen often with san nodes, which clutters the kernel
log. Since the hsr protocol does not support sans, this is only relevant
for the prp protocol.

Signed-off-by: Kristian Overskeid <koverskeid@gmail.com>
---
 net/hsr/hsr_framereg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index 00db74d96583..865eda39d601 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -415,7 +415,7 @@ void hsr_addr_subst_dest(struct hsr_node *node_src, struct sk_buff *skb,
 	node_dst = find_node_by_addr_A(&port->hsr->node_db,
 				       eth_hdr(skb)->h_dest);
 	if (!node_dst) {
-		if (net_ratelimit())
+		if (net_ratelimit() && port->hsr->prot_version != PRP_V1)
 			netdev_err(skb->dev, "%s: Unknown node\n", __func__);
 		return;
 	}
-- 
2.34.1


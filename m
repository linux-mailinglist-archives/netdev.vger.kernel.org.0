Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B233FF445
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 21:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347430AbhIBTgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 15:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347433AbhIBTf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 15:35:56 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7BCC061757
        for <netdev@vger.kernel.org>; Thu,  2 Sep 2021 12:34:57 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id b64so3466693qkg.0
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 12:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vghWG+qLTaUQ2l/MOXdk8sDVyc/61qq/UYDpzlS8Ga0=;
        b=IMctVrLkSRbmT2GU9vxs9SRcbN98SgqoU+3oxhwXx3d3afT3ETE1bBYhkI2sQx3EaJ
         4zN5NNJGsaJtet/4VKKwa4Kf01Ow5Tt/8FPDyX9ddl9NneA+nza9K9HL6201uLENaKow
         8UOp5YMj2xD4iXn3taYw8zhPNoOEvcnfs99KeRs9nvZIoC3lzg7kuW3IUW0w/gxKx81v
         ei+uYZxZ8vSYGG90mxG/wOH39jyoCmtkP9tnRXjb6QYYB7MYck0MQzicodU0hMsXyz16
         29bs8lag/eNHteFOa5ZDGqMy8E1ixaI/eDWtBBzeH9TsQMbmHrpfiFPg9RUMvnMSiQxX
         tU3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vghWG+qLTaUQ2l/MOXdk8sDVyc/61qq/UYDpzlS8Ga0=;
        b=gw+eqnq9Bct7TsYGrlqilNYIsdK2Y9onEuM2kRc3akvowBRdbygYnVz0m+Q9xPggvY
         MdbChL+YaQCU2bpSokxP1jG7iY1h3C0Q/qPo0A743o/U3QjbRqJE/vSRewzTGZTbG41U
         bYsBbC3/0xytwZiAn+XFXvgbTt6uM8nbQBh/0MyuerEKqqB/oWGqOefZUKQAeL8FW1f5
         f30w4Qn8YsF8OAdJt3JCXjkhQUa2FGciOEQMo4hSEUHRk3JXHyPfc/3b3GFU02yoXVFM
         Q/EJDZCJ0eXgnGmRV/D0vUMReF6MioKpO7jNikudozMp3AS1L/J6qV1Y4ML0GKJqMDdI
         7mwA==
X-Gm-Message-State: AOAM530bR8hh/qhAyuvF0A7g2RtKXrYpB+HTQLVRqLLGiE8uyRLaN9Hg
        9HG/hzWH6FnIr9sU7qJMGPsQQQ/ewNJHXw==
X-Google-Smtp-Source: ABdhPJx8q4cuMR7ko2Vr7h0FktFqu1q+7PO6wpehKkUvCgFBVq9wDpyFXYpBYcMQNiOiwdtsPv9UWA==
X-Received: by 2002:a37:809:: with SMTP id 9mr4774349qki.318.1630611297096;
        Thu, 02 Sep 2021 12:34:57 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:77a8:7a00:56f4:e83e])
        by smtp.gmail.com with ESMTPSA id w18sm1595877qto.91.2021.09.02.12.34.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 12:34:56 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@idosch.org,
        chouhan.shreyansh630@gmail.com,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net] ip6_gre: validate csum_start only if CHECKSUM_PARTIAL
Date:   Thu,  2 Sep 2021 15:34:46 -0400
Message-Id: <20210902193447.94039-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Only test integrity of csum_start if field is defined.

With checksum offload and GRE tunnel checksum, gre_build_header will
cheaply build the GRE checksum using local checksum offload. This
depends on inner packet csum offload, and thus that csum_start points
behind GRE. But validate this condition only with checksum offload.

Link: https://lore.kernel.org/netdev/YS+h%2FtqCJJiQei+W@shredder/
Fixes: 9cf448c200ba ("ip6_gre: add validation for csum_start")
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 net/ipv6/ip6_gre.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 7baf41d160f5..c456bc7f7cdc 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -629,8 +629,11 @@ static int gre_rcv(struct sk_buff *skb)
 
 static int gre_handle_offloads(struct sk_buff *skb, bool csum)
 {
-	if (csum && skb_checksum_start(skb) < skb->data)
+	/* Local checksum offload requires csum offload of the inner packet */
+	if (csum && skb->ip_summed == CHECKSUM_PARTIAL &&
+	    skb_checksum_start(skb) < skb->data)
 		return -EINVAL;
+
 	return iptunnel_handle_offloads(skb,
 					csum ? SKB_GSO_GRE_CSUM : SKB_GSO_GRE);
 }
-- 
2.33.0.153.gba50c8fa24-goog


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C28EA473E81
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 09:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhLNImf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 03:42:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbhLNImf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 03:42:35 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D66D9C061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 00:42:34 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id j11so16784094pgs.2
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 00:42:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XVOeWQRsdYmUh30n/ucj3rVGIzZy2+3T+U3omvK8s/8=;
        b=dapRKMPXdyRIEjeiel1ELCPss4bqpF0DzCgUoTo4VhMqn1su4PXhxtaBdw2Pm19kV2
         UmncskXVn0ddc8clNR7RSKmQxzotY9/rUJriunayoOtfJCzne5QApGRtyTTl3yz2mkjN
         EEasN80AtdP7v5gMfKYwLo3fjeQYLr/efJWNKQf9rA8SElUbyIOmNAT/sXjJlEc69aJl
         RQ0EjRJIsZwIkU1VVaWb1eGFvzZ9V+EqClYDe+e/H8HBl/jy1dLOqwPykc/fMWUBpE4s
         7fFQmCjJA/3Qc1fnS7+WUFamy+tBCkeuk3f/5oNXyRX0pH+zFm3ojko9NetI2HnP+dxZ
         IpmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XVOeWQRsdYmUh30n/ucj3rVGIzZy2+3T+U3omvK8s/8=;
        b=dHQwwPB7iTHMgV2Lr82ZYMTPQGJPjI03gQl2Ce1NKkG/tZumoYNsRq9p0u4/KgFYLD
         6BSoDji4tXKPUvdu5iiqHJbXRQZEntNmlgFHxeMK2v50lf05JEQjYAshttKpHxcz86td
         Um3EHZoUpWtMuNWmgEIO3ujdoxofjd7xh0Q8bHgNgoWyc+69NJ4QBvjw9ISMpSTNPIjC
         BVyXv+Jz/FZ4Py0dcF38hhW21Atg+s3AXHupz+Nti5MI48uzbcbviZeAZhnmX2LwYeVI
         A9eiSchrTcMo27QVEYq3Ng7X5nbZyusw8EUFkh5x/u3BRnERM7Z03CEeYzGCHZLD1dqF
         f9yA==
X-Gm-Message-State: AOAM530k+I9CGjvr8BKEIMy7uwMHYO0OTv1CLqeH2ExvtlNGkyvawxvv
        Vdg9c6TxzxFNClAhL6HApMY=
X-Google-Smtp-Source: ABdhPJy1E+AXSHcHvCYURjmzRAyaHQ8vvTtVCL09P/5a4N+UVIVhV3HyNpIFZNRJ9ztzyhTaS2z4YQ==
X-Received: by 2002:a63:f30e:: with SMTP id l14mr2706259pgh.519.1639471354369;
        Tue, 14 Dec 2021 00:42:34 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5cbb:7251:72ab:eb48])
        by smtp.gmail.com with ESMTPSA id oa17sm1670672pjb.37.2021.12.14.00.42.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 00:42:33 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] ethtool: use ethnl_parse_header_dev_put()
Date:   Tue, 14 Dec 2021 00:42:30 -0800
Message-Id: <20211214084230.3618708-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

It seems I missed that most ethnl_parse_header_dev_get() callers
declare an on-stack struct ethnl_req_info, and that they simply call
dev_put(req_info.dev) when about to return.

Add ethnl_parse_header_dev_put() helper to properly untrack
reference taken by ethnl_parse_header_dev_get().

Fixes: e4b8954074f6 ("netlink: add net device refcount tracker to struct ethnl_req_info")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ethtool/cabletest.c | 4 ++--
 net/ethtool/channels.c  | 2 +-
 net/ethtool/coalesce.c  | 2 +-
 net/ethtool/debug.c     | 2 +-
 net/ethtool/eee.c       | 2 +-
 net/ethtool/features.c  | 2 +-
 net/ethtool/fec.c       | 2 +-
 net/ethtool/linkinfo.c  | 2 +-
 net/ethtool/linkmodes.c | 2 +-
 net/ethtool/module.c    | 2 +-
 net/ethtool/netlink.h   | 5 +++++
 net/ethtool/pause.c     | 2 +-
 net/ethtool/privflags.c | 2 +-
 net/ethtool/rings.c     | 2 +-
 net/ethtool/tunnels.c   | 6 +++---
 net/ethtool/wol.c       | 2 +-
 16 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/net/ethtool/cabletest.c b/net/ethtool/cabletest.c
index 63560bbb7d1f0b4a4ca76b2986e896d922bd7745..920aac02fe390edcc512ca1beaafd874a2fdb937 100644
--- a/net/ethtool/cabletest.c
+++ b/net/ethtool/cabletest.c
@@ -96,7 +96,7 @@ int ethnl_act_cable_test(struct sk_buff *skb, struct genl_info *info)
 out_rtnl:
 	rtnl_unlock();
 out_dev_put:
-	dev_put(dev);
+	ethnl_parse_header_dev_put(&req_info);
 	return ret;
 }
 
@@ -353,7 +353,7 @@ int ethnl_act_cable_test_tdr(struct sk_buff *skb, struct genl_info *info)
 out_rtnl:
 	rtnl_unlock();
 out_dev_put:
-	dev_put(dev);
+	ethnl_parse_header_dev_put(&req_info);
 	return ret;
 }
  
diff --git a/net/ethtool/channels.c b/net/ethtool/channels.c
index 6a070dc8e4b0dba90656d92f742320200c6bdfe3..403158862011588ded7a448b13e39702551b2df4 100644
--- a/net/ethtool/channels.c
+++ b/net/ethtool/channels.c
@@ -219,6 +219,6 @@ int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info)
 out_rtnl:
 	rtnl_unlock();
 out_dev:
-	dev_put(dev);
+	ethnl_parse_header_dev_put(&req_info);
 	return ret;
 }
diff --git a/net/ethtool/coalesce.c b/net/ethtool/coalesce.c
index 46776ea42a92e1daf2982f06287b2227d9b045f7..487bdf345541ad1966702e600335a015edd9feda 100644
--- a/net/ethtool/coalesce.c
+++ b/net/ethtool/coalesce.c
@@ -336,6 +336,6 @@ int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info)
 out_rtnl:
 	rtnl_unlock();
 out_dev:
-	dev_put(dev);
+	ethnl_parse_header_dev_put(&req_info);
 	return ret;
 }
diff --git a/net/ethtool/debug.c b/net/ethtool/debug.c
index f99912d7957ead331a772dbdd70a64f0e374b7ae..d73888c7d19ca71eb384cf89aa2ffc786c6a3f30 100644
--- a/net/ethtool/debug.c
+++ b/net/ethtool/debug.c
@@ -123,6 +123,6 @@ int ethnl_set_debug(struct sk_buff *skb, struct genl_info *info)
 out_rtnl:
 	rtnl_unlock();
 out_dev:
-	dev_put(dev);
+	ethnl_parse_header_dev_put(&req_info);
 	return ret;
 }
diff --git a/net/ethtool/eee.c b/net/ethtool/eee.c
index e10bfcc0785317f3b19e2ee2d0513c60a495151b..45c42b2d5f1785c4ff3492b6d78e0c826c583ba9 100644
--- a/net/ethtool/eee.c
+++ b/net/ethtool/eee.c
@@ -185,6 +185,6 @@ int ethnl_set_eee(struct sk_buff *skb, struct genl_info *info)
 out_rtnl:
 	rtnl_unlock();
 out_dev:
-	dev_put(dev);
+	ethnl_parse_header_dev_put(&req_info);
 	return ret;
 }
diff --git a/net/ethtool/features.c b/net/ethtool/features.c
index 2e7331b23996aa7b09b2eb5d4d34b9b407c98b74..55d449a2d3fcb35d0b3952a8184f3079e3403cde 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -283,6 +283,6 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 
 out_rtnl:
 	rtnl_unlock();
-	dev_put(dev);
+	ethnl_parse_header_dev_put(&req_info);
 	return ret;
 }
diff --git a/net/ethtool/fec.c b/net/ethtool/fec.c
index 8738dafd5417227724cba9e36dd3dff4dd44d636..9f5a134e2e01361bfb9edf44f982f821f0fdefb1 100644
--- a/net/ethtool/fec.c
+++ b/net/ethtool/fec.c
@@ -305,6 +305,6 @@ int ethnl_set_fec(struct sk_buff *skb, struct genl_info *info)
 out_rtnl:
 	rtnl_unlock();
 out_dev:
-	dev_put(dev);
+	ethnl_parse_header_dev_put(&req_info);
 	return ret;
 }
diff --git a/net/ethtool/linkinfo.c b/net/ethtool/linkinfo.c
index b91839870efc990119a51fc5ff63e62f35643491..efa0f7f488366c14bd44a03f8568f28fad017fed 100644
--- a/net/ethtool/linkinfo.c
+++ b/net/ethtool/linkinfo.c
@@ -149,6 +149,6 @@ int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info)
 out_rtnl:
 	rtnl_unlock();
 out_dev:
-	dev_put(dev);
+	ethnl_parse_header_dev_put(&req_info);
 	return ret;
 }
diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index f9eda596f301408ce145d2cb996023dd37b1a0f6..99b29b4fe9472f5e2de1c10ecd33d8248cd1687c 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -358,6 +358,6 @@ int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info)
 out_rtnl:
 	rtnl_unlock();
 out_dev:
-	dev_put(dev);
+	ethnl_parse_header_dev_put(&req_info);
 	return ret;
 }
diff --git a/net/ethtool/module.c b/net/ethtool/module.c
index bc2cef11bbdad6649948289c47bc4fe0b6c4579b..898ed436b9e41db688a70e65e47b18ae1176d275 100644
--- a/net/ethtool/module.c
+++ b/net/ethtool/module.c
@@ -175,6 +175,6 @@ int ethnl_set_module(struct sk_buff *skb, struct genl_info *info)
 	ethnl_ops_complete(dev);
 out_rtnl:
 	rtnl_unlock();
-	dev_put(dev);
+	ethnl_parse_header_dev_put(&req_info);
 	return ret;
 }
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index a779bbb0c524f00e7a798bc8448bebbd43b65488..75856db299e9d3d2d1ba041ee8c9c32abe37ca53 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -235,6 +235,11 @@ struct ethnl_req_info {
 	u32			flags;
 };
 
+static inline void ethnl_parse_header_dev_put(struct ethnl_req_info *req_info)
+{
+	dev_put_track(req_info->dev, &req_info->dev_tracker);
+}
+
 /**
  * struct ethnl_reply_data - base type of reply data for GET requests
  * @dev:       device for current reply message; in single shot requests it is
diff --git a/net/ethtool/pause.c b/net/ethtool/pause.c
index ee1e5806bc93a4bf60fe18bf15ee9b01af190b62..a8c113d244db9c4e13f089ddb40e3d390f620148 100644
--- a/net/ethtool/pause.c
+++ b/net/ethtool/pause.c
@@ -181,6 +181,6 @@ int ethnl_set_pause(struct sk_buff *skb, struct genl_info *info)
 out_rtnl:
 	rtnl_unlock();
 out_dev:
-	dev_put(dev);
+	ethnl_parse_header_dev_put(&req_info);
 	return ret;
 }
diff --git a/net/ethtool/privflags.c b/net/ethtool/privflags.c
index fc9f3be23a19d82236bd001024237fb191d0e53c..4c7bfa81e4abf4c0478a9eae9892418113c87f09 100644
--- a/net/ethtool/privflags.c
+++ b/net/ethtool/privflags.c
@@ -196,6 +196,6 @@ int ethnl_set_privflags(struct sk_buff *skb, struct genl_info *info)
 out_rtnl:
 	rtnl_unlock();
 out_dev:
-	dev_put(dev);
+	ethnl_parse_header_dev_put(&req_info);
 	return ret;
 }
diff --git a/net/ethtool/rings.c b/net/ethtool/rings.c
index 450b8866373d17d9318ca7802f946d36e646fc1e..c1d5f5e0fdc98e58de88e77d3c783be15022dc43 100644
--- a/net/ethtool/rings.c
+++ b/net/ethtool/rings.c
@@ -196,6 +196,6 @@ int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info)
 out_rtnl:
 	rtnl_unlock();
 out_dev:
-	dev_put(dev);
+	ethnl_parse_header_dev_put(&req_info);
 	return ret;
 }
diff --git a/net/ethtool/tunnels.c b/net/ethtool/tunnels.c
index e7f2ee0d2471977a57761a89f0a1764a7dce82b1..efde3353668734d7d0457d721f8ecd7a4e0bc551 100644
--- a/net/ethtool/tunnels.c
+++ b/net/ethtool/tunnels.c
@@ -195,7 +195,7 @@ int ethnl_tunnel_info_doit(struct sk_buff *skb, struct genl_info *info)
 	if (ret)
 		goto err_free_msg;
 	rtnl_unlock();
-	dev_put(req_info.dev);
+	ethnl_parse_header_dev_put(&req_info);
 	genlmsg_end(rskb, reply_payload);
 
 	return genlmsg_reply(rskb, info);
@@ -204,7 +204,7 @@ int ethnl_tunnel_info_doit(struct sk_buff *skb, struct genl_info *info)
 	nlmsg_free(rskb);
 err_unlock_rtnl:
 	rtnl_unlock();
-	dev_put(req_info.dev);
+	ethnl_parse_header_dev_put(&req_info);
 	return ret;
 }
 
@@ -230,7 +230,7 @@ int ethnl_tunnel_info_start(struct netlink_callback *cb)
 					 sock_net(cb->skb->sk), cb->extack,
 					 false);
 	if (ctx->req_info.dev) {
-		dev_put(ctx->req_info.dev);
+		ethnl_parse_header_dev_put(&ctx->req_info);
 		ctx->req_info.dev = NULL;
 	}
 
diff --git a/net/ethtool/wol.c b/net/ethtool/wol.c
index ada7df2331d20d088a75ffcc1c210aff69c99791..88f435e76481d780f531c0e1eda5d29c4ae25a10 100644
--- a/net/ethtool/wol.c
+++ b/net/ethtool/wol.c
@@ -165,6 +165,6 @@ int ethnl_set_wol(struct sk_buff *skb, struct genl_info *info)
 out_rtnl:
 	rtnl_unlock();
 out_dev:
-	dev_put(dev);
+	ethnl_parse_header_dev_put(&req_info);
 	return ret;
 }
-- 
2.34.1.173.g76aa8bc2d0-goog


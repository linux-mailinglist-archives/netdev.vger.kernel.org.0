Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C15946AFD8
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 02:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234593AbhLGBfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 20:35:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351715AbhLGBes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 20:34:48 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D26AC061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 17:31:18 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 71so12195797pgb.4
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 17:31:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2XuSUkbm1fTCzBJbnFIXzPvhUfQc2Hy2zzqnqNr8xYg=;
        b=D3qbzsFYA+ioCO1wJxv3VT/xDvJXEiCzI8xV1n3iouOU+33YTdXEtkohjQj9vzcNnV
         RvyvdJIl5AP233E5KICLp7KCRu6FBvvj++BMB7m6VHkw1dqnOTfFIptHRt2WGWjQy3fD
         WpPldDBV/NlblBChPpvH4Yqy036yTtpBThDlQFmyeGhuNaUs0fRpt9OkaUaiz/dst0Dj
         //qehCr5O36wNrSmPUshemxOmjFTU3g5BEOh12QfIMJD2gE3bWG8uiseH4zsLmWsX8AG
         ita305QK252XPTR/vq2+zctnaxnUiLIV7YpUMqYpOR5/Yh6TERrR/TFsHBNOqciDSO4l
         KfLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2XuSUkbm1fTCzBJbnFIXzPvhUfQc2Hy2zzqnqNr8xYg=;
        b=WA4pPldwU7UzUDLV8g7MCu/6YUBQF8mfQry0TCpyRgDcdCTIYFhhzAvSPWB3TDfvdm
         629xZy/BwPWQUT+SovhJwuGCSmN08wI/aue9g2uZ/LQH3Jjn8lL7bL1Ummar48aXtxiJ
         ivUS11o/1L1tBdhbZQTQq8a2fkacnjqbv8NRnuUjg4ye/u706JZ9dsM7CC/XOIpbv0tD
         tsCbDFmJ25e4gYHnRpIPUB3IhbdPTOqiRoqp3hi8su3PuTBhfCcFYI9ZzLroY0Qy496H
         z3O0Daa4KlNkLTTHTk4qkjrAc2P2PV14DPw7xci+MZo7wx/o0fH09TMuHwU8tpfXqZLR
         7TAw==
X-Gm-Message-State: AOAM531AarAdfj6HyjqMnU9PgM796jhVfpWMnDX/tKi+c6/NsZdNqlRB
        GRCwedCwRY9E0uUOZH3h/Jc=
X-Google-Smtp-Source: ABdhPJxcGN7VJlPnZ94e57ZYk6vwEiY9R5QmwWmcdtpZW4iLQAHwdqJL52EuUcfuzr19oP+K6edCvQ==
X-Received: by 2002:a63:88c3:: with SMTP id l186mr21310642pgd.377.1638840677876;
        Mon, 06 Dec 2021 17:31:17 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:518c:39bf:c3e8:ffe2])
        by smtp.gmail.com with ESMTPSA id u6sm13342907pfg.157.2021.12.06.17.31.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 17:31:17 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 11/13] netlink: add net device refcount tracker to struct ethnl_req_info
Date:   Mon,  6 Dec 2021 17:30:37 -0800
Message-Id: <20211207013039.1868645-12-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211207013039.1868645-1-eric.dumazet@gmail.com>
References: <20211207013039.1868645-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ethtool/netlink.c | 8 +++++---
 net/ethtool/netlink.h | 2 ++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 38b44c0291b11af2c6d59c532c0c4ad4bba2ce27..eaa50af074be563cdac9d700cdb0f9d32a54252c 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -141,6 +141,7 @@ int ethnl_parse_header_dev_get(struct ethnl_req_info *req_info,
 	}
 
 	req_info->dev = dev;
+	netdev_tracker_alloc(dev, &req_info->dev_tracker, GFP_KERNEL);
 	req_info->flags = flags;
 	return 0;
 }
@@ -399,7 +400,7 @@ static int ethnl_default_doit(struct sk_buff *skb, struct genl_info *info)
 		ops->cleanup_data(reply_data);
 
 	genlmsg_end(rskb, reply_payload);
-	dev_put(req_info->dev);
+	dev_put_track(req_info->dev, &req_info->dev_tracker);
 	kfree(reply_data);
 	kfree(req_info);
 	return genlmsg_reply(rskb, info);
@@ -411,7 +412,7 @@ static int ethnl_default_doit(struct sk_buff *skb, struct genl_info *info)
 	if (ops->cleanup_data)
 		ops->cleanup_data(reply_data);
 err_dev:
-	dev_put(req_info->dev);
+	dev_put_track(req_info->dev, &req_info->dev_tracker);
 	kfree(reply_data);
 	kfree(req_info);
 	return ret;
@@ -547,7 +548,7 @@ static int ethnl_default_start(struct netlink_callback *cb)
 		 * same parser as for non-dump (doit) requests is used, it
 		 * would take reference to the device if it finds one
 		 */
-		dev_put(req_info->dev);
+		dev_put_track(req_info->dev, &req_info->dev_tracker);
 		req_info->dev = NULL;
 	}
 	if (ret < 0)
@@ -624,6 +625,7 @@ static void ethnl_default_notify(struct net_device *dev, unsigned int cmd,
 	}
 
 	req_info->dev = dev;
+	netdev_tracker_alloc(dev, &req_info->dev_tracker, GFP_KERNEL);
 	req_info->flags |= ETHTOOL_FLAG_COMPACT_BITSETS;
 
 	ethnl_init_reply_data(reply_data, ops, dev);
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 490598e5eedd9a614bf64ced6be482523cad12cf..a779bbb0c524f00e7a798bc8448bebbd43b65488 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -222,6 +222,7 @@ static inline unsigned int ethnl_reply_header_size(void)
 /**
  * struct ethnl_req_info - base type of request information for GET requests
  * @dev:   network device the request is for (may be null)
+ * @dev_tracker: refcount tracker for @dev reference
  * @flags: request flags common for all request types
  *
  * This is a common base for request specific structures holding data from
@@ -230,6 +231,7 @@ static inline unsigned int ethnl_reply_header_size(void)
  */
 struct ethnl_req_info {
 	struct net_device	*dev;
+	netdevice_tracker	dev_tracker;
 	u32			flags;
 };
 
-- 
2.34.1.400.ga245620fadb-goog


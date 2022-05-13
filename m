Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 033AF526961
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 20:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382704AbiEMSeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 14:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231376AbiEMSeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 14:34:18 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214175EBF8
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:34:17 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id h24so2940881pgh.12
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ion9gc3HVl5RE+BhwskjRAqRZTjxiT67SesVihd0fpQ=;
        b=S9AaNAagGV8vT5Og5VPsbG8OuFQXnoZ1QsQI5KvOXhTbM3FTDWq/Jp4LEo15tX3XLY
         mD0uVK6KINLkaRM4pcXLjYEauZykHNNyG1iuqsGtN4t83kAAys2SjjiX+Bs+ZOOBrQLN
         sp4dSdHoFZ4HxJZYzp7bhUN+WVR+YhVJ9jo5d6b8oqoWxvzg+uVKG3Bi4Zx9do2KXOVq
         df/duYBPjvWG5BuLGpnnGP4cxx0aQyiUj7+lnEy4lYG0aFP20n9yGuC3rx6vZe8ZdEwr
         aAmzUUc4t7C4HnH31ulgQoSkOOKU9aWHFVhEtAq/peLlPcO5dmacS7vXSgr8ooGUrJAn
         HheA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ion9gc3HVl5RE+BhwskjRAqRZTjxiT67SesVihd0fpQ=;
        b=JPTuSURDjBvamuM7EgR4jfRxYGYf7ZXGyC0Kd87xku4eNFoL8+f5CCqBNj41Q0N6hi
         2V479aLZdt6fmVTgHeIP4NhPqxbUTuXboPeWQiURn+a3WUtrpcQnhVOCt8L78RyelLe1
         VaPPhlrtkqfug0YnD4g40DwBpZP2PNAgE1cDxuH/Kfm/QX+7Obx8V53SVx1XHlxsjUV5
         5+xvMalmN1Kegc3B9FzhyQdv9uHyc/I6JixCYvsGmCyo879SisPk4tiA/jeRsPJvNmfD
         +/KXm5bMFPxbeklgB0eASp/FT4TDGUxuLMeKGRi65lZGnRs5wYHRseRGa8g3/nydTghQ
         yXGQ==
X-Gm-Message-State: AOAM530PYx988sjdfUd3FZOK0A6HE1EK8GKySfOxOHHt0U0hA6MtpsBv
        mMLEVpsAFLhwgQjjFLm3H8c=
X-Google-Smtp-Source: ABdhPJxp8G6PAYwtkWD3XEgDd7nzExEwz9V7At5tefVf/c6+qsZrGDvUJxilfNi9jgUVETXAYACIGw==
X-Received: by 2002:a05:6a00:cd4:b0:510:49f7:12a4 with SMTP id b20-20020a056a000cd400b0051049f712a4mr5889428pfv.59.1652466856653;
        Fri, 13 May 2022 11:34:16 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c436:3fa3:479f:a7a])
        by smtp.gmail.com with ESMTPSA id q13-20020aa7842d000000b0050dc76281cesm2053566pfn.168.2022.05.13.11.34.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 11:34:16 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v7 net-next 01/13] net: add IFLA_TSO_{MAX_SIZE|SEGS} attributes
Date:   Fri, 13 May 2022 11:33:56 -0700
Message-Id: <20220513183408.686447-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
In-Reply-To: <20220513183408.686447-1-eric.dumazet@gmail.com>
References: <20220513183408.686447-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
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

From: Eric Dumazet <edumazet@google.com>

New netlink attributes IFLA_TSO_MAX_SIZE and IFLA_TSO_MAX_SEGS
are used to report to user-space the device TSO limits.

ip -d link sh dev eth1
...
   tso_max_size 65536 tso_max_segs 65535

Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Alexander Duyck <alexanderduyck@fb.com>
---
 include/uapi/linux/if_link.h       | 2 ++
 net/core/rtnetlink.c               | 6 ++++++
 tools/include/uapi/linux/if_link.h | 2 ++
 3 files changed, 10 insertions(+)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index d1e600816b82c2e73c3e0684c66ddf9841a75b04..5f58dcfe2787f308bb2aa5777cca0816dd32bbb9 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -368,6 +368,8 @@ enum {
 	IFLA_PARENT_DEV_NAME,
 	IFLA_PARENT_DEV_BUS_NAME,
 	IFLA_GRO_MAX_SIZE,
+	IFLA_TSO_MAX_SIZE,
+	IFLA_TSO_MAX_SEGS,
 
 	__IFLA_MAX
 };
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index bdc8913261027e33d6292201ea1cd32d3d36670b..f35cc21298acd0891f1e7cd46e6317f5d8e71b24 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1064,6 +1064,8 @@ static noinline size_t if_nlmsg_size(const struct net_device *dev,
 	       + nla_total_size(4) /* IFLA_GSO_MAX_SEGS */
 	       + nla_total_size(4) /* IFLA_GSO_MAX_SIZE */
 	       + nla_total_size(4) /* IFLA_GRO_MAX_SIZE */
+	       + nla_total_size(4) /* IFLA_TSO_MAX_SIZE */
+	       + nla_total_size(4) /* IFLA_TSO_MAX_SEGS */
 	       + nla_total_size(1) /* IFLA_OPERSTATE */
 	       + nla_total_size(1) /* IFLA_LINKMODE */
 	       + nla_total_size(4) /* IFLA_CARRIER_CHANGES */
@@ -1769,6 +1771,8 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	    nla_put_u32(skb, IFLA_GSO_MAX_SEGS, dev->gso_max_segs) ||
 	    nla_put_u32(skb, IFLA_GSO_MAX_SIZE, dev->gso_max_size) ||
 	    nla_put_u32(skb, IFLA_GRO_MAX_SIZE, dev->gro_max_size) ||
+	    nla_put_u32(skb, IFLA_TSO_MAX_SIZE, dev->tso_max_size) ||
+	    nla_put_u32(skb, IFLA_TSO_MAX_SEGS, dev->tso_max_segs) ||
 #ifdef CONFIG_RPS
 	    nla_put_u32(skb, IFLA_NUM_RX_QUEUES, dev->num_rx_queues) ||
 #endif
@@ -1922,6 +1926,8 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_NEW_IFINDEX]	= NLA_POLICY_MIN(NLA_S32, 1),
 	[IFLA_PARENT_DEV_NAME]	= { .type = NLA_NUL_STRING },
 	[IFLA_GRO_MAX_SIZE]	= { .type = NLA_U32 },
+	[IFLA_TSO_MAX_SIZE]	= { .type = NLA_REJECT },
+	[IFLA_TSO_MAX_SEGS]	= { .type = NLA_REJECT },
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index e1ba2d51b717b7ac7f06e94ac9791cf4c8a5ab6f..b339bf2196ca160ed3040615ae624b9a028562fb 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -348,6 +348,8 @@ enum {
 	IFLA_PARENT_DEV_NAME,
 	IFLA_PARENT_DEV_BUS_NAME,
 	IFLA_GRO_MAX_SIZE,
+	IFLA_TSO_MAX_SIZE,
+	IFLA_TSO_MAX_SEGS,
 
 	__IFLA_MAX
 };
-- 
2.36.0.550.gb090851708-goog


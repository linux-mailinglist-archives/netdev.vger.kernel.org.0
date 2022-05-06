Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB0051DC2B
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 17:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442928AbiEFPf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 11:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389935AbiEFPfM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 11:35:12 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5824F6EB33
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 08:31:01 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id y41so1716809pfw.12
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 08:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0KByvAI5wxmwml/sN2uj4dXiTldcv8jjd6Op43vG4IA=;
        b=gQDypQHtGeKSJvagm83TuAtm+wvSmdcRwIACkAvhFfZI2XhmS1c4SC7K3YfuW9zYpm
         ZAsNEx78fHMSHZYOtN/EOqPWw6XtmX79dFzNcGcTHcbN0oaNu+KOEPbcubdbajFpLOQ5
         RZOlNQnS+IV9H4ynX0MilDW371vPYrSJgV/WUqEBe9t55AxzervJPW1RwmCLjUOkaFB/
         XRfi/TvZK0yJ3FMUkNj532r469GTEAi4j/1v416IbdbxbAFbsPsduoIEGL5epTQLd9Kf
         af9qxPYOkH9JrKknggTEJeUmHEcNUwt0hYpCAQtPfUvL7OAtYx2sB7UtgXFP42riHVRh
         NLSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0KByvAI5wxmwml/sN2uj4dXiTldcv8jjd6Op43vG4IA=;
        b=zzAsAWj2OhgUTw21UGL8fMONEw9OqKKmQsm5uDsNcpEiBSaNE6VlekCQyy2EDru41T
         6y2xEMVYg1z9qY4J+WNwMxLQeBOzGIZFd2aJHmCNe6Pp1arClxTrQc8hffqeuGZL4UXV
         Wuy4nqVeV4NFXXaM9RKHeljrdA3xed2M4HrHpe8JJlMaFBLmccDsAr2OvDn0G9LBBCsz
         LdGokqOPW54EgUu/1EXwLDLrJJqp3Rbwpu4AbvDxAkbdxhRrR0TOOh19RXxcl2KmvgZV
         +q8tz80Xn56T5SPsPMQZVK71rwszeq0a4mk80e0NeITwH+VB3wrcvGyYQi2Fpkyn2Waa
         Omvw==
X-Gm-Message-State: AOAM5306bRkxyHPb0tqMpPpTw3qQCZ8uZtVQ4rnpYIWR+9bryOay0V9P
        P9BMCnNHHcZq7obFUxPg/UA=
X-Google-Smtp-Source: ABdhPJwltwIZDoRmWEG8YSmgILq4BsIsdYs/vzma8+s6M6lQjLp3kJQiAfJ3ctdz4x8EnzjbUk6i/w==
X-Received: by 2002:a63:af42:0:b0:39d:942c:504b with SMTP id s2-20020a63af42000000b0039d942c504bmr3289825pgo.453.1651851060659;
        Fri, 06 May 2022 08:31:00 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:709e:d3d8:321b:df52])
        by smtp.gmail.com with ESMTPSA id w4-20020a170902d70400b0015e8d4eb1bfsm1918612ply.9.2022.05.06.08.30.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 08:31:00 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v4 net-next 01/12] net: add IFLA_TSO_{MAX_SIZE|SEGS} attributes
Date:   Fri,  6 May 2022 08:30:37 -0700
Message-Id: <20220506153048.3695721-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220506153048.3695721-1-eric.dumazet@gmail.com>
References: <20220506153048.3695721-1-eric.dumazet@gmail.com>
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
index e6d4b9272995b7a9b9f83b8868845222f4785edf..512ed661204e0c66c8dcfaddc3001500d10f63ab 100644
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
2.36.0.512.ge40c2bad7a-goog


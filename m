Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27EA752077F
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 00:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbiEIWZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 18:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbiEIWZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 18:25:51 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0066215BAD2
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 15:21:56 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id x88so2780415pjj.1
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 15:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tdl6SC0FKuuPP7oyiUxcpCdn5VF/Qbf7FvEoiChEks0=;
        b=akKd4gmENyhMtJZnN+WZ2glV6bbOz//pT6xWY74JvW9nI9fa/2cwcgU/HFkUbQfb4u
         7GwS/UM1J8KIjhaJLQv1sxvrdRCb0FCVOxXaat2QRQESgk6bVaaqQwqmxnyP+2V9BZmc
         uvUxJJBMqDT7jKpanjbv/pur8RigtKtviSZyfG78c7HhqnSA7DHSH/V1VG05oRKzdGnW
         Pe3YIF/OHzQzpCqUIXO3inxl/A011vZ/hZHYZWc9ZexLf20ZdYY4M/VMWoe06chKMOyc
         zUEwH64BvKKaTHOhe1zL140/r12pJmoi8cdhY/53hB5yCqfvuO6i4mUSNIdrfHq1IGdn
         yS7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tdl6SC0FKuuPP7oyiUxcpCdn5VF/Qbf7FvEoiChEks0=;
        b=k3Ny9exYkOAdHAxxuKUz5RqX3KA7lPhcE0A9TwQYekoL3htoTYaXiv9hN9BXGow4B3
         8OGFf/Af8aToxwMJCe441l4ly0RTJ6WC76hJPOd0hmp1v1n57/dgt1IKAP23JbrC3A0E
         PAWrPtSGbzV2c5CkigMh2sVKBWxGmqgIvWZErEUSJBVQNUnoYwwgDWNgHxuW3tElTapy
         7F93gx8o9Pb2JeZFjgLtKfBlQmFmBH1mm6NEhsV8rAhMHPPFqH+8FpgtueT7ya8Mtb7U
         ZmkBd38wC4Za+fTOceVPCsG2N/S0Fwvk46bvc3hYvTpiZx8WlNtMXf4pdgerG97pIK7Z
         3iCg==
X-Gm-Message-State: AOAM533vfUiznCuvdmLjwjPaegaRfb3hC2WFs4OkK11YJwsC8Bi9XV1O
        t7zrua20YgWcxjK1i4iSpW8=
X-Google-Smtp-Source: ABdhPJwqJU/c5kZ1Yp/QrloO6waG/2Fk4HMCJHmQ4LtKyZ8ZD6q5OeeUZc/d/TqxjJ5sOjF0FFHkvg==
X-Received: by 2002:a17:90a:e646:b0:1dd:258b:51ef with SMTP id ep6-20020a17090ae64600b001dd258b51efmr4405793pjb.122.1652134916520;
        Mon, 09 May 2022 15:21:56 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5d30:4e79:203f:a909])
        by smtp.gmail.com with ESMTPSA id v11-20020a170902f0cb00b0015e8d4eb1efsm395823pla.57.2022.05.09.15.21.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 15:21:55 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v5 net-next 01/13] net: add IFLA_TSO_{MAX_SIZE|SEGS} attributes
Date:   Mon,  9 May 2022 15:21:37 -0700
Message-Id: <20220509222149.1763877-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220509222149.1763877-1-eric.dumazet@gmail.com>
References: <20220509222149.1763877-1-eric.dumazet@gmail.com>
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
index 6aff02df9ba51c99e8f1dd8e1c1da393c92b8ebf..21b117b710bf2154f11b6511de7d578d0eafb65e 100644
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


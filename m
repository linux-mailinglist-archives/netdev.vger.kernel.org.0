Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7B534FB637
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 10:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343921AbiDKInd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 04:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343917AbiDKInb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 04:43:31 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5733EAA5
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 01:41:17 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id r18so3516008ljp.0
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 01:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=wVQ0HARhc+FxCf/O5hQemDc31KPNUzAFgjRud4EVmj0=;
        b=IiYlIzzw6xSpVMIsEs9TF4kFV5ijoit+JbuIYRGVRHxl40fbt6p6r5Trxu6a5OYBWy
         a+6Phbq3A0pk0VkfqfpE4xJ943Z3EGR7sjRuAxznHf1wdsRFaVJ+gCAb/SCDtsxK0ERt
         aUgZ1sIjquH45Y0I5NONMMRHNSIuikRZN6GcOezI/K1BsYGwVffvhxQCDJdq5PZ0KRMz
         9B2TANhwKr5y1Fh5kD7s8VhKVoXD1fOQYIdXbcVycBAZd9Az29dhTeDdyx7jk5jIHuFj
         Vf1Mq00iKP2sWsmh4W2mPJut+jKflmjfhkthOMEoaBAi+wzu7kJGpNi53sQXT1qbSQ4k
         IBCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=wVQ0HARhc+FxCf/O5hQemDc31KPNUzAFgjRud4EVmj0=;
        b=2PnUMbz/l85ltCinHN06lFpYZYcM7TAXjphXNm/I4LBuvjwuZMgsk+1m0ca/Ointop
         bS/bE45THnmP+YDA9V8j8BPn3H6a/CnihFybgHipF83F0QXn8sLMIbgK0wQz+5KBoaPJ
         4FExVBzXvES2h2Yf6xmgQ+W0CmFVhQkJLInOaFDIsem5b94puBtIvS1rGdka91dQiRWi
         iD7Rslg6W/ArYqDQ1Z3/+d0djkbjFPieyMIsPS3g2xR39Ern0B055PX+7C+kWbIBHgXj
         tTZW639hPBXsSWcnmTsePktjL4r5MYFv+T7O+jH5q9q6NlcGMsAQJDc3owrz51Cj7v+L
         Tw/A==
X-Gm-Message-State: AOAM532uQ0kg8o5dWRRhvlh8IeILmf8crwql/f+PEIObfChIvcqWRhRg
        VsUkIdOLsP87ZYPwS6mNWig=
X-Google-Smtp-Source: ABdhPJxM9YmQOWvSk+ddKlvNVI1IhjkzfoUxCeNXbLrRJnzRjCTfLe7xe5IKjjeB7JJdnlvTnIWyKg==
X-Received: by 2002:a2e:91d7:0:b0:24b:6981:15a6 with SMTP id u23-20020a2e91d7000000b0024b698115a6mr271533ljg.141.1649666476040;
        Mon, 11 Apr 2022 01:41:16 -0700 (PDT)
Received: from wbg.labs.westermo.se (h-158-174-22-128.NA.cust.bahnhof.se. [158.174.22.128])
        by smtp.gmail.com with ESMTPSA id x24-20020a056512047800b0046b9dafd55bsm549080lfd.164.2022.04.11.01.41.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 01:41:15 -0700 (PDT)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Nikolay Aleksandrov <razor@blackwall.org>,
        Roopa Prabhu <roopa@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org,
        "David S . Miller" <davem@davemloft.net>,
        Joachim Wiberg <troglobit@gmail.com>
Subject: [PATCH v2 net-next 1/2] net: bridge: add support for host l2 mdb entries
Date:   Mon, 11 Apr 2022 10:40:53 +0200
Message-Id: <20220411084054.298807-2-troglobit@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220411084054.298807-1-troglobit@gmail.com>
References: <20220223172407.175865-1-troglobit@gmail.com>
 <20220411084054.298807-1-troglobit@gmail.com>
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

This patch expands on the earlier work on layer-2 mdb entries by adding
support for host entries.  Due to the fact that host joined entries do
not have any flag field, we infer the permanent flag when reporting the
entries to userspace, which otherwise would be listed as 'temp'.

Before patch:

    ~# bridge mdb add dev br0 port br0 grp 01:00:00:c0:ff:ee permanent
    Error: bridge: Flags are not allowed for host groups.
    ~# bridge mdb add dev br0 port br0 grp 01:00:00:c0:ff:ee
    Error: bridge: Only permanent L2 entries allowed.

After patch:

    ~# bridge mdb add dev br0 port br0 grp 01:00:00:c0:ff:ee permanent
    ~# bridge mdb show
    dev br0 port br0 grp 01:00:00:c0:ff:ee permanent vid 1

Signed-off-by: Joachim Wiberg <troglobit@gmail.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 net/bridge/br_mdb.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 4556d913955b..fdcc641fc89a 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -251,14 +251,16 @@ static int __mdb_fill_info(struct sk_buff *skb,
 	__mdb_entry_fill_flags(&e, flags);
 	e.ifindex = ifindex;
 	e.vid = mp->addr.vid;
-	if (mp->addr.proto == htons(ETH_P_IP))
+	if (mp->addr.proto == htons(ETH_P_IP)) {
 		e.addr.u.ip4 = mp->addr.dst.ip4;
 #if IS_ENABLED(CONFIG_IPV6)
-	else if (mp->addr.proto == htons(ETH_P_IPV6))
+	} else if (mp->addr.proto == htons(ETH_P_IPV6)) {
 		e.addr.u.ip6 = mp->addr.dst.ip6;
 #endif
-	else
+	} else {
 		ether_addr_copy(e.addr.u.mac_addr, mp->addr.dst.mac_addr);
+		e.state = MDB_PG_FLAGS_PERMANENT;
+	}
 	e.addr.proto = mp->addr.proto;
 	nest_ent = nla_nest_start_noflag(skb,
 					 MDBA_MDB_ENTRY_INFO);
@@ -873,8 +875,8 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 		return -EINVAL;
 
 	/* host join errors which can happen before creating the group */
-	if (!port) {
-		/* don't allow any flags for host-joined groups */
+	if (!port && !br_group_is_l2(&group)) {
+		/* don't allow any flags for host-joined IP groups */
 		if (entry->state) {
 			NL_SET_ERR_MSG_MOD(extack, "Flags are not allowed for host groups");
 			return -EINVAL;
-- 
2.25.1


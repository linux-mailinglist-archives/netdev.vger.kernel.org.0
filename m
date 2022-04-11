Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6000F4FC36F
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 19:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348910AbiDKRcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 13:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348928AbiDKRcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 13:32:17 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD9A02E9FD
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 10:30:00 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id bh17so32319662ejb.8
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 10:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RIR/ZHl5ZiFHgx6+6/Rsb1UvqXAuRfjaxLhenAF2JJI=;
        b=lpBHWyld2PQijqIzQlkNniBq/I0nMhLWr2VIsEI0rkRZH1/1whYuvxToynpfR7JTr5
         3Xgl4SqVJO1JjsR1wAcpuCjm70v+RkS/Hg7T1jUdGNFz3itNqosbMCgH69NppQtGNUgC
         76yH6xcKdP1HtO2P/Ej+k3uq/Z4kGHVszJONO/OSs/aYeRXWE53tUUS0R/11uO5yNBpe
         Yc2oYqneWejwOmgK5lsYaGiFEb/8aX4Noc4sK5Mb6liMatA9CeKrQQGn4Jdf22pJkHC/
         W0DkiN/F4VlOr2bd4c0pcZ53pJ6Oc61NvB32f/yLut7P2SwK7pqK+Fn0C5u5HMolx/jJ
         iukA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RIR/ZHl5ZiFHgx6+6/Rsb1UvqXAuRfjaxLhenAF2JJI=;
        b=LlxMywQ7SQZo33WOD9iIz6wjohff3D5/tsGNY19h76glrM/bESyGCR9omoVjCcz1Qk
         Bw42l5ZQLzvYmkAt9akyMYbPozC9MlF9OgTroqBOlPi8qtGm14NQnbtF1peqCYa7FVTU
         94Bc+7AgXdPLbCcAmFh1bFqGwSUxMsYsNlVAW6BGfFerJsCByancoqzyzwcKt5qgFMA3
         UsU4MxIduuwpeZa16UUgKvBgQeGDqkbS9d8x/6+fCiRWvs6td5XozP9FTyA3ob8fII4V
         e9bfmCygDjqx47ZRdnlntOO1hCA/cpRQCAdxI6iVTK3v9qNfDA676kZW5pt8gmsTV8vp
         217A==
X-Gm-Message-State: AOAM533JRRDNs8Cch7G/4ouYnY1CIP2uCTQuU/Sb85RrpDphrpSea1Ox
        5N3dBA+54vuOMxEVr0zW4/ZGOTLf52LuLpgn
X-Google-Smtp-Source: ABdhPJzjiQfYrrqu8a4iy9n5tirV+dTQgnN0Pytlq+0lx9yxVIqKtYbtUj7/GJRaUPWTHrfjX2q/zQ==
X-Received: by 2002:a17:906:7304:b0:6e0:6918:ef6f with SMTP id di4-20020a170906730400b006e06918ef6fmr30501107ejc.370.1649698198740;
        Mon, 11 Apr 2022 10:29:58 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id u6-20020a17090626c600b006e74ef7f092sm10325084ejc.176.2022.04.11.10.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 10:29:58 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, idosch@idosch.org, kuba@kernel.org,
        davem@davemloft.net, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net-next v2 2/8] net: add ndo_fdb_flush op
Date:   Mon, 11 Apr 2022 20:29:28 +0300
Message-Id: <20220411172934.1813604-3-razor@blackwall.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411172934.1813604-1-razor@blackwall.org>
References: <20220411172934.1813604-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new netdev op called ndo_fdb_flush, it will be later used for
driver-specific flush implementation dispatched from rtnetlink. The first
user will be the bridge.

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 include/linux/netdevice.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 28ea4f8269d4..16d67e40053c 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1265,6 +1265,12 @@ struct netdev_net_notifier {
  *		       int *idx)
  *	Used to add FDB entries to dump requests. Implementers should add
  *	entries to skb and update idx with the number of entries.
+ * int (*ndo_fdb_flush)(struct ndmsg *ndm, struct nlattr *tb[],
+ *			struct net_device *dev,
+ *			u16 vid,
+ *			struct netlink_ext_ack *extack);
+ *	Used to flush FDB entries. Filter attributes can be specified to delete
+ *	only matching FDB entries if implementers support it.
  *
  * int (*ndo_bridge_setlink)(struct net_device *dev, struct nlmsghdr *nlh,
  *			     u16 flags, struct netlink_ext_ack *extack)
@@ -1515,6 +1521,11 @@ struct net_device_ops {
 						struct net_device *dev,
 						struct net_device *filter_dev,
 						int *idx);
+	int			(*ndo_fdb_flush)(struct ndmsg *ndm,
+						 struct nlattr *tb[],
+						 struct net_device *dev,
+						 u16 vid,
+						 struct netlink_ext_ack *extack);
 	int			(*ndo_fdb_get)(struct sk_buff *skb,
 					       struct nlattr *tb[],
 					       struct net_device *dev,
-- 
2.35.1


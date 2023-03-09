Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10F636B1FE8
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 10:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjCIJYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 04:24:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbjCIJYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 04:24:24 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 945FFCF99C
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 01:24:17 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id s22so1416673lfi.9
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 01:24:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678353855;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AcT19OGeCXcddBBv+J56CnwZ9qcDY3TnNTEK+oHPc5I=;
        b=VofMylTYg2ZR/KmV1vN4m0ZdpC3Vw1B7GIeuWKpfKZi4ve58voVtUEYtVg76NKvbnO
         waA/0knO67WJOtfM/Zzvir4luFEL9+GLSbpJsog+9hDkEvHon1aSDsrCpBX0RBqvAtbq
         7yhedQrZiF2bEMAsLbnoLZCYUESYISzitKTYiqRLnqFwt4JKJRg2JrDr4EO57MUvMkmc
         2+iB4pLS91QZMI+39wSntsEvYIova7bD7Jc/jH75sXs8xL4wiEWs5v1DDWXPOT8Rgiig
         icD8uYuZjT9NZIkZiHH2kJyjwP2Q6XoNVTZuKHJOM2SINXQ+L7c5Ex6+y8IwB4HUTdFl
         vhtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678353855;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AcT19OGeCXcddBBv+J56CnwZ9qcDY3TnNTEK+oHPc5I=;
        b=hv7mrBE87PPurZj73J5TJrFHfhGTZuQIwa9xuAZuOgBeMZjMbjP1ZmZZ0bia8aCT3d
         R8QFuuiez1XqZEgX77CnZgjs0JbyTazRnfO3Zm4l5GG6hYLz72cIw7SJT8K5fJh9hcBd
         QXTJZRUza4rEP7WorM+7CMafF+PfzWEIp91DN0UrEZYG5Z85/X/wj23rSw6DN7jWQN+E
         IdWVIY4tC6cOZizrN1o4c1JlnMCRF89D1WWLyFfCj7NS4E+2XMcdvl+uITeWufVbz2yz
         x8+eZA4hPB3kXI168fzhl9MEXmQHMbW54a5Si8sI4k4O5sRp3YeLh0ZYchOpLOvQ1WIG
         M5dQ==
X-Gm-Message-State: AO0yUKVIZXVJ/fjqHvUjqV107ijDW+qaH3OJfsI8mxyHAvvkW5F26HUI
        4xx0LhUQkcN1aDZMyERjGVzYlE5ysn2pnw==
X-Google-Smtp-Source: AK7set8EtUQdKWT+Yu3ad1NpG5Eghk0/JCpxoPllzloXdqR0C52hA5QtVlOJjVbFRBclsUP0K0Ck1Q==
X-Received: by 2002:ac2:5a4c:0:b0:4dc:7ff4:83f9 with SMTP id r12-20020ac25a4c000000b004dc7ff483f9mr6160282lfn.16.1678353855417;
        Thu, 09 Mar 2023 01:24:15 -0800 (PST)
Received: from oss-build.. (3peqmh0.ip.hatteland.com. [46.250.209.192])
        by smtp.gmail.com with ESMTPSA id g12-20020a19ee0c000000b004db45ae3aa8sm2599824lfb.50.2023.03.09.01.24.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 01:24:14 -0800 (PST)
From:   Kristian Overskeid <koverskeid@gmail.com>
To:     netdev@vger.kernel.org
Cc:     m-karicheri2@ti.com, bigeasy@linutronix.de, yuehaibing@huawei.com,
        arvid.brodin@alten.se, Kristian Overskeid <koverskeid@gmail.com>
Subject: [PATCH v2] net: hsr: Don't log netdev_err message on unknown prp dst node
Date:   Thu,  9 Mar 2023 10:23:02 +0100
Message-Id: <20230309092302.179586-1-koverskeid@gmail.com>
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
 V1 -> V2: Addressed review comments
 
 net/hsr/hsr_framereg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index 00db74d96583..b77f1189d19d 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -415,7 +415,7 @@ void hsr_addr_subst_dest(struct hsr_node *node_src, struct sk_buff *skb,
 	node_dst = find_node_by_addr_A(&port->hsr->node_db,
 				       eth_hdr(skb)->h_dest);
 	if (!node_dst) {
-		if (net_ratelimit())
+		if (port->hsr->prot_version != PRP_V1 && net_ratelimit())
 			netdev_err(skb->dev, "%s: Unknown node\n", __func__);
 		return;
 	}
-- 
2.34.1


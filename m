Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 689DD4D40E1
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 06:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239647AbiCJFsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 00:48:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238058AbiCJFsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 00:48:16 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711C8F957C
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 21:47:16 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id g19so4206119pfc.9
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 21:47:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zmMmAv7X/GTOQMp14Z492/H8MoM1ZZZ0aZt3DTBRw6M=;
        b=E9I5eo+3RT0CJNCXM9CAdllkH0tAi6tyLnbvxTs23YsV4DPhWjDMgCxZEK+42THR+l
         ZAM3wnw0NxTaZsn4sXXBIKwkVWMsv5mxArv8mWig004vQMHcGGQtQH8V+ejqYet0iUt+
         0ZvW0uJiQJrRjuutenQN4uu1ndkBk1ELOqb6B+NOuBLFRZJjY8m+fLZsI3CBgdJPbp08
         7dJ0EipajhJstmlIHf4ZJ5uwxYMKMbQeD/VoZZFMio4chZPpCHjyKkaYm/e0hduFeGVj
         sQc90cdHI827uhvcNCqQsSAFUy95QuhQlRNEHSTxCHCYacbaXqD6U20sRjnE+WlXrZbf
         FPbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zmMmAv7X/GTOQMp14Z492/H8MoM1ZZZ0aZt3DTBRw6M=;
        b=K3/Je1BA9P3XhajRsPj6p/4PsxXSGNoUl2ph6HGvMsxi2aH3UtFNqg/c0e41Db6kxS
         fML6ilLkFhWr3FcjTYzJ6qmxr4qPuQex5jnByxQETJ38qXPPvBIhvFwLyXGDVVPhoaeP
         BEUPJWuzxEJl3VU+2Bfk5DQoSLvVXbtSkh1JYjZFRL0MGu7XliT9IQqI1pqo3l0qM1zt
         WH4N2gliTlpEUTI+qn8EUXfvqSizAyc0c9LFUymNz/+bsFkCdE7IbNST0RGeja7SORWc
         qHuWHunHXednRAEu9ee8V6jVxSsfyICv65fN1CBVWGKHbm/KkAX2ZvmUQZ02/KX89sSW
         iVBQ==
X-Gm-Message-State: AOAM530KePZIAAh6X4zWL5OitqLmy2HeLcfMqcpjk103R/P3QJMwQTaa
        Rq2q29YnWktZFRP7l5tfPMQ=
X-Google-Smtp-Source: ABdhPJwMWQbzt0m3NdWwmkiES1J/WrNeje5u6KGzd/X4PO/12aP+hlO4Pt2cJ7O2PSnE1uEo9HuFbQ==
X-Received: by 2002:a63:82c3:0:b0:37c:7976:4dc2 with SMTP id w186-20020a6382c3000000b0037c79764dc2mr2738663pgd.477.1646891235958;
        Wed, 09 Mar 2022 21:47:15 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c6c7:6f77:9634:183c])
        by smtp.gmail.com with ESMTPSA id 16-20020a056a00073000b004dfe2217090sm5270779pfm.200.2022.03.09.21.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 21:47:15 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v4 net-next 04/14] ipv6: add struct hop_jumbo_hdr definition
Date:   Wed,  9 Mar 2022 21:46:53 -0800
Message-Id: <20220310054703.849899-5-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
In-Reply-To: <20220310054703.849899-1-eric.dumazet@gmail.com>
References: <20220310054703.849899-1-eric.dumazet@gmail.com>
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

Following patches will need to add and remove local IPv6 jumbogram
options to enable BIG TCP.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/ipv6.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 213612f1680c7c39f4c07f0c05b4e6cf34a7878e..63d019953c47ea03d3b723a58c25e83c249489a9 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -151,6 +151,17 @@ struct frag_hdr {
 	__be32	identification;
 };
 
+/*
+ * Jumbo payload option, as described in RFC 2675 2.
+ */
+struct hop_jumbo_hdr {
+	u8	nexthdr;
+	u8	hdrlen;
+	u8	tlv_type;	/* IPV6_TLV_JUMBO, 0xC2 */
+	u8	tlv_len;	/* 4 */
+	__be32	jumbo_payload_len;
+};
+
 #define	IP6_MF		0x0001
 #define	IP6_OFFSET	0xFFF8
 
-- 
2.35.1.616.g0bdcbb4464-goog


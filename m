Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15E0F520782
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 00:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbiEIW0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 18:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231534AbiEIW0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 18:26:02 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC60516D4BC
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 15:22:03 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id i24so13397368pfa.7
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 15:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Kdkb9iJD2Cf92mUwdfbtRZPbJe3zJ/RvlmfMXNxr0ow=;
        b=kRTHvGCboQYngHsdQP6mQCJbg/UjmXU3+TwS3gaqB9Wx+k2J9lVYZ/acWt/C+mlIov
         hfzVNruxNoyFknJsgsVEaiym7I/sgeGetUv7xdRunlpKs2hfEvNoXWU7sHdbEVb9vkYV
         parZ3equy+XH6izho38hqX1O8QA96GT/dkOFe7pBItOhj+txXHHcPndM08mFPNy2yOAT
         XjVoK/V8yqOKDxPZdZ60vhN5Be4GwBX+yYQyCSAgZJS/us05UYAJGg0Xqbq3lz2wcOg3
         dGBS+nouzR6QXBXGoelSXq+e+MvcfdGOgcjH7lG5zbZG7zwhAOfUSBZGb06JOGYU752c
         kKWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Kdkb9iJD2Cf92mUwdfbtRZPbJe3zJ/RvlmfMXNxr0ow=;
        b=L1HdQ/hCfLkpQhFqvZXS//x2k3X9vPHhhjuI4ZJHpZi04bQuXT0ZruAqdii11SjuY2
         cJHzv+QX8vMg+XVZcUrjc5hLlLd+kHHFwwSBw7YlK8TKLk8zNZE+2bcEHZ/GD48w5s9X
         C37ED7DyRrDPqAwQHetIvjCT32qVSLw1MB0vMxBeK9N9V1CXyOgUY/Yv7Zu3Th+y6hXn
         vbU0uq0bTXkDEAsRhWb+3qCBkcG73cW6wofhPfKc/Ree53+ILLCS/FjH6b01ZsmTP1SE
         oByE02gVfs+LZYlMALCFBsdN6oVyp6xYVmVj9VAjtKc+yKqYc63n98mQj75aNj/wO40g
         tWsA==
X-Gm-Message-State: AOAM531B6uMPWZ+BxpiuxISxwMPBweecl6BzNkqIZbd+uRoZmpgvUN9v
        ib1WDc3c+6IxM7zdsI/eY4I=
X-Google-Smtp-Source: ABdhPJz9CjwulDNrdVyzhUGkjeHsw4yI0syQcCHAWlqvp9X2f6imGnGANZcufTq4Y3MfQYx9jiCJMg==
X-Received: by 2002:a62:cec4:0:b0:50d:9030:722c with SMTP id y187-20020a62cec4000000b0050d9030722cmr17740329pfg.41.1652134923283;
        Mon, 09 May 2022 15:22:03 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5d30:4e79:203f:a909])
        by smtp.gmail.com with ESMTPSA id v11-20020a170902f0cb00b0015e8d4eb1efsm395823pla.57.2022.05.09.15.22.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 15:22:02 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v5 net-next 05/13] ipv6: add struct hop_jumbo_hdr definition
Date:   Mon,  9 May 2022 15:21:41 -0700
Message-Id: <20220509222149.1763877-6-eric.dumazet@gmail.com>
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
2.36.0.512.ge40c2bad7a-goog


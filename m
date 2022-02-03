Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1764A7D8C
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 02:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348889AbiBCBwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 20:52:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348887AbiBCBv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 20:51:58 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F9FC06173E
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 17:51:58 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id o64so1052524pjo.2
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 17:51:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r/IHVe/4R9v1EiC6cO7H0ylsMmHAyBBTO/HRoWM1qoA=;
        b=jy3KOfbBAhLOGDlvvuiukYQhZ1L4ly64fFo4eK9j/oosW1p6pQYyK+XVZ3ZBhj3wYb
         ltpAK5habFxPnHxP6JdFRIuy+6Ob6g51+hq/M5TwZkIKq7QhrdtzPIz1xikEymutwgwq
         lAOWoeIHW2j2R42JtyCGVDH33gxpZTUB/ouqOzVCPb/l8QC3qenBDP+0HjKaCdPPKCWn
         M0Z2c3F5XWF7yrrJuTWqGSWjsmdONb8IjBSTuWg5kJnsZRenTpPdP0+I2eKfLzo0dT7Z
         l+VVhLFKc+8grenSCEFtBrEv/7B1mYN9mwVc1PAT9xh/J7AipvqpI5WaJUTB9XvryBJJ
         8keg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r/IHVe/4R9v1EiC6cO7H0ylsMmHAyBBTO/HRoWM1qoA=;
        b=n0B4j8nneBw4SdU5NMRuUi0fD35K3o4E+BMRQOewjGZjo+ZTBOdz1sRQI9LwLpJaik
         Yv7/jDfT7kw9b7aRJH7wY/GIHCEhuZvU1YsoHTFYR9rpPrYRfX55QqtrsTd0bp9ihDGT
         y5tLRovWg8B6XpMeBXKNG1EgYQwEfwWHjunN4l+bWETPSDcq0hVGNRwwAHZTpEA3TEJj
         dM8ID7SACiW+KT81n+dHn4916eL/wq1AzwQY/nnrYHDHvrgkPEfyo6JUQmtEKefqaHXI
         e5zgNGTOyivcNndv1y2zudUJ9r7TCEFTuGabS5s1U74s5DE2pTR8z6/+HHclMEcVk6RJ
         69Fw==
X-Gm-Message-State: AOAM533b0yyHCzwdj3ed6QFPCm4QjROdDtEd0gr07thYlrYZAwRpvpvz
        2zO5NNMJigZTNFPhoHeyQ1KEDvc6fSI=
X-Google-Smtp-Source: ABdhPJzaSyA7nIjDU9RKrsuzt9olmi/RLtYEqElw10kw4PLxSJJ/krfFTBJzAb+k4+9xu1nbZgr1SA==
X-Received: by 2002:a17:90b:3ec4:: with SMTP id rm4mr6944140pjb.102.1643853118136;
        Wed, 02 Feb 2022 17:51:58 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:697a:fa00:b793:ed3a])
        by smtp.gmail.com with ESMTPSA id qe16sm509611pjb.22.2022.02.02.17.51.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 17:51:57 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 04/15] ipv6: add struct hop_jumbo_hdr definition
Date:   Wed,  2 Feb 2022 17:51:29 -0800
Message-Id: <20220203015140.3022854-5-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
In-Reply-To: <20220203015140.3022854-1-eric.dumazet@gmail.com>
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 082f30256f59fad18b78746b6650aee840932eba..ea2a4351b654f8bc96503aae2b9adcd478e1f8b2 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -151,6 +151,17 @@ struct frag_hdr {
 	__be32	identification;
 };
 
+/*
+ * Jumbo payload option, as described in RFC 2676 2.
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
2.35.0.rc2.247.g8bbb082509-goog


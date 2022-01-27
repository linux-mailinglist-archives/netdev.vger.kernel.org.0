Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A79F749D6DB
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 01:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234029AbiA0Ag7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 19:36:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234079AbiA0Ags (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 19:36:48 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55620C06175B;
        Wed, 26 Jan 2022 16:36:48 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id k25so2186986ejp.5;
        Wed, 26 Jan 2022 16:36:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qenSIoAXZ6o9VOjrqRc2EOQyMOxrV68LqnhSggaVs6I=;
        b=Czo+ENsmCpOPbGSPPdD9nN2KoWZnqE/IAEJ7gbZVSsPS6NR/v3zqkGBqNe/V9WVlVE
         RfhQF5Tz/kzZpADsL4/V8tOAnHeFscEsasnOJLnP6C5Xxkg8KkcFjYrqIsXzx/7O2kee
         uV+Jx5SNcqw77Utc0qio9q8HsG8hJVmKxXsYXacZ1lMfhhbYTlbDgG3O9dw2p4EWkERw
         Zkj79vBK1iV/VCpWXojsHFBaWXnWZybQ/XBRxwBQUGWbL0Au/n05Ars+BdAU0dFQmwGv
         Nk2PYphgsZlxUUpxDfNBSyYQfOd3CX73hw37DLIIOcW+W72J+zy3MYYo85sNOZN6EUC0
         d6MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qenSIoAXZ6o9VOjrqRc2EOQyMOxrV68LqnhSggaVs6I=;
        b=qVBeqhJs758JjEoQjputXIBSla9U2UnKHeN4Snx/bsyacSTjCnJGjVy79S2aH2BBp6
         E6laoUta2GHl/FxvAyCKCvD8eQF3u8+scDKdiAVHcs0VYdXB8UbWP/aSGxtbyeHfIGdO
         quQzeMt0CKNSTh4GqfqGvWwWQBu40uprBHbm7+qWrsMHWPEJBnjk7+SZQLu8GrD6JAlS
         QEMu3hO0cQcP+5QPpVX8ButBlj0PqRogbc9PXczzQNHPQdt8o5dfWcfxVKyjFQ4W1YOc
         o8l5QHb4j90E9MdgijKE+M7P7JCBidU3AxLWOyklTkAY/ac4IYMTda+bbSoZMTKPs02V
         wAxw==
X-Gm-Message-State: AOAM5304KLHI/jmR+6BF4o1jVirMQUuuR+noFg/41KwiA2QZk09UdP1i
        jj0Pm1pELqXoew/4q5a7M5KdfICpDwk=
X-Google-Smtp-Source: ABdhPJyB36Kzr0C+6YwvLEkXBnQfdKBZ0Ds1xbfLzopBJQQw5iRj0AVgVxxERXvaRauDU2VTDIx8fQ==
X-Received: by 2002:a17:907:6089:: with SMTP id ht9mr998920ejc.612.1643243806756;
        Wed, 26 Jan 2022 16:36:46 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.234.222])
        by smtp.gmail.com with ESMTPSA id op27sm8039235ejb.103.2022.01.26.16.36.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 16:36:46 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v2 10/10] ipv6: partially inline ipv6_fixup_options
Date:   Thu, 27 Jan 2022 00:36:31 +0000
Message-Id: <5c6bda8c6f78228fd58586a4160edcc374011a26.1643243773.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1643243772.git.asml.silence@gmail.com>
References: <cover.1643243772.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Inline a part of ipv6_fixup_options() to avoid extra overhead on
function call if opt is NULL.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/net/ipv6.h | 12 ++++++++++--
 net/ipv6/exthdrs.c |  8 ++++----
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 5e0b56d66724..082f30256f59 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -437,8 +437,16 @@ struct ipv6_txoptions *ipv6_renew_options(struct sock *sk,
 					  struct ipv6_txoptions *opt,
 					  int newtype,
 					  struct ipv6_opt_hdr *newopt);
-struct ipv6_txoptions *ipv6_fixup_options(struct ipv6_txoptions *opt_space,
-					  struct ipv6_txoptions *opt);
+struct ipv6_txoptions *__ipv6_fixup_options(struct ipv6_txoptions *opt_space,
+					    struct ipv6_txoptions *opt);
+
+static inline struct ipv6_txoptions *
+ipv6_fixup_options(struct ipv6_txoptions *opt_space, struct ipv6_txoptions *opt)
+{
+	if (!opt)
+		return NULL;
+	return __ipv6_fixup_options(opt_space, opt);
+}
 
 bool ipv6_opt_accepted(const struct sock *sk, const struct sk_buff *skb,
 		       const struct inet6_skb_parm *opt);
diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 77e34aec7e82..658d5eabaf7e 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -1344,14 +1344,14 @@ ipv6_renew_options(struct sock *sk, struct ipv6_txoptions *opt,
 	return opt2;
 }
 
-struct ipv6_txoptions *ipv6_fixup_options(struct ipv6_txoptions *opt_space,
-					  struct ipv6_txoptions *opt)
+struct ipv6_txoptions *__ipv6_fixup_options(struct ipv6_txoptions *opt_space,
+					    struct ipv6_txoptions *opt)
 {
 	/*
 	 * ignore the dest before srcrt unless srcrt is being included.
 	 * --yoshfuji
 	 */
-	if (opt && opt->dst0opt && !opt->srcrt) {
+	if (opt->dst0opt && !opt->srcrt) {
 		if (opt_space != opt) {
 			memcpy(opt_space, opt, sizeof(*opt_space));
 			opt = opt_space;
@@ -1362,7 +1362,7 @@ struct ipv6_txoptions *ipv6_fixup_options(struct ipv6_txoptions *opt_space,
 
 	return opt;
 }
-EXPORT_SYMBOL_GPL(ipv6_fixup_options);
+EXPORT_SYMBOL_GPL(__ipv6_fixup_options);
 
 /**
  * fl6_update_dst - update flowi destination address with info given
-- 
2.34.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7174931303
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 18:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfEaQuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 12:50:11 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46357 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfEaQuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 12:50:10 -0400
Received: by mail-pg1-f195.google.com with SMTP id v9so4335552pgr.13
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 09:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oFcvdmtXVUaKqxe4PEx9Avhamk6baJlnrhRipIuUu34=;
        b=r/H+l9vWKTcXhjkPYtB9+uvQHt3rfYh+MKUmTglSSC82c0HMtUssv4Yjplje4yxAWN
         YyL+e5ogUKFuqB4qaDrhsQ1ojul/kBskU3zQapDBCxX8cv6IlwB6KwXJJIC6oIjKLXT1
         XtmCFy0j4PbR6Kw2Gv9YE2vVBqJyBeZn3hNpjpB1Ygacgljh55reJqa82/5WMrZmL+sI
         tZCmz1FmKVzA8HibqU3B2Ic108So4hC6sBSAgoDj1OiLC+18w19951RbkTNIKz7NbCQW
         ZRZW8UoumTuR5SQqWMEPpWUSgVIokJJ7LGfnaHPdounSDtbrAI8GZVkttkmPrQsM9bwl
         cGHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=oFcvdmtXVUaKqxe4PEx9Avhamk6baJlnrhRipIuUu34=;
        b=lwK8fcc5FwvKZdkgqMnSG78L2KEgzFZb037z6uJAiZoIcGgDjwCdfWxXccqk09cQfT
         tKQ4WP/jW9KerchI3N9ssCo4QVaM3xnAE4Qd0r6RHZZ+QEu6+wOgoTE53eJo95x0wcNA
         lnuPWtJjtx+ZyrOnpFQqMMcazxsqGwgf6ANJLSk8wnGw1XFGMYBwFQxLQy8AkWITw7Gg
         nWFHQehGUrF+AJaXakApu34Hh8NpBtMdxjs2opjM7iTP3InIrCCZGTXgk5fbdlWdzHL2
         NQ2jEMwsitJGi9TIsue7Y1w3FDmP5s4CZ4cep2QyHtrJKr/0zwkMctivGUuSvxbeFDSr
         hc/g==
X-Gm-Message-State: APjAAAUVRCzVxtxjQUDxVt2/YPZxVHuKQz8HMbQCIPj3RDgXqwpPHVms
        Nj/ewV4ofdr3Wf/1yvXE93qGYg==
X-Google-Smtp-Source: APXvYqxujAre+G/8vddu9j55ms23Wp6DOo0YLth4UDRQtRcYUO3lYmuRYrmEHNSa9KJw8yivpeCRaw==
X-Received: by 2002:aa7:9e51:: with SMTP id z17mr11595030pfq.212.1559321409659;
        Fri, 31 May 2019 09:50:09 -0700 (PDT)
Received: from localhost.localdomain (c-73-223-249-119.hsd1.ca.comcast.net. [73.223.249.119])
        by smtp.gmail.com with ESMTPSA id e66sm8696835pfe.50.2019.05.31.09.50.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 31 May 2019 09:50:09 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
X-Google-Original-From: Tom Herbert <tom@quantonium.net>
To:     davem@davemloft.net, netdev@vger.kernel.org, dlebrun@google.com,
        ahabdels.dev@gmail.com
Cc:     Tom Herbert <tom@quantonium.net>
Subject: [RFC PATCH 4/6] ah6: Create function __zero_out_mutable_opts
Date:   Fri, 31 May 2019 09:48:38 -0700
Message-Id: <1559321320-9444-5-git-send-email-tom@quantonium.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559321320-9444-1-git-send-email-tom@quantonium.net>
References: <1559321320-9444-1-git-send-email-tom@quantonium.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an adaptation of zero_out_mutable_opts that takes three
additional arguments: offset of the TLVs, a mask to locate the
mutable bit in the TLV type, and the type value for single byte
padding.

zero_out_mutable_opts calls the new function and sets the arguments
appropriate to Hop-by-Hop and Destination Options. The function will
be used to support zeroing out mutable SRH TLVs' data with the
appropriate arguments for SRH TLVs.

Signed-off-by: Tom Herbert <tom@quantonium.net>
---
 net/ipv6/ah6.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/net/ipv6/ah6.c b/net/ipv6/ah6.c
index 68b9e92..1e80157 100644
--- a/net/ipv6/ah6.c
+++ b/net/ipv6/ah6.c
@@ -102,32 +102,28 @@ static inline struct scatterlist *ah_req_sg(struct crypto_ahash *ahash,
 			     __alignof__(struct scatterlist));
 }
 
-static bool zero_out_mutable_opts(struct ipv6_opt_hdr *opthdr)
+static bool __zero_out_mutable_opts(struct ipv6_opt_hdr *opthdr, int off,
+				    unsigned char mut_bit, unsigned char pad1)
 {
 	u8 *opt = (u8 *)opthdr;
 	int len = ipv6_optlen(opthdr);
-	int off = 0;
 	int optlen = 0;
 
-	off += 2;
-	len -= 2;
+	len -= off;
 
 	while (len > 0) {
-
-		switch (opt[off]) {
-
-		case IPV6_TLV_PAD1:
+		if (opt[off] == pad1) {
 			optlen = 1;
-			break;
-		default:
+		} else {
 			if (len < 2)
 				goto bad;
-			optlen = opt[off+1]+2;
+
+			optlen = opt[off + 1] + 2;
 			if (len < optlen)
 				goto bad;
-			if (opt[off] & 0x20)
-				memset(&opt[off+2], 0, opt[off+1]);
-			break;
+
+			if (opt[off] & mut_bit)
+				memset(&opt[off + 2], 0, opt[off + 1]);
 		}
 
 		off += optlen;
@@ -140,6 +136,11 @@ static bool zero_out_mutable_opts(struct ipv6_opt_hdr *opthdr)
 	return false;
 }
 
+static bool zero_out_mutable_opts(struct ipv6_opt_hdr *opthdr)
+{
+	return __zero_out_mutable_opts(opthdr, 2, 0x20, IPV6_TLV_PAD1);
+}
+
 #if IS_ENABLED(CONFIG_IPV6_MIP6)
 /**
  *	ipv6_rearrange_destopt - rearrange IPv6 destination options header
-- 
2.7.4


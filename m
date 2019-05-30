Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B10930455
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 23:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbfE3V4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 17:56:50 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:41267 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726308AbfE3V4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 17:56:50 -0400
Received: by mail-io1-f65.google.com with SMTP id w25so6424488ioc.8
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 14:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oFcvdmtXVUaKqxe4PEx9Avhamk6baJlnrhRipIuUu34=;
        b=GqemEd2XsjJXpZ9LmtmIt+Xz1l1boPt6A61umaLS+V6miXXvuOWmNpESHFbgqkCS1Q
         dgdu+gi+717O32JphpJJcvijlUZzef87Ciga1tYymUfl4FWG7Ctt/Jt/ZLAwuqwCbb7f
         v8oQ3+crqP0e4BF2fkCsH+8A+XGHRZfUECuHz2oVe3/6OV9KfkWOy3MYsE4FX3VYv4ax
         28owo9Ok5mxymNxybcIFB0UQCROKQsNluIGhKhtkte1I0Naldit0Gc3Xq5dfJWPcsHAr
         0OQOYqO2M8DBFKSUpw8fcGEMotWFx8NqeKkFv1ZpRR2VIvv4WqOSxKTlrQDKHzG70fzk
         fITg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=oFcvdmtXVUaKqxe4PEx9Avhamk6baJlnrhRipIuUu34=;
        b=fh93Zb+rwTDie8vLJOHTTXk7xW0fmvCQNmJ0BwzuR2qTdpajOXlF3SSl39vEyQARBv
         WTeCetqX1TSi9Lu7H8JAOrkfx8muXsP7vulMrEEIGMzWIuTxw1qQVs0MExtR6HVD3D5n
         +W2maDwGWPDtu2/QPDj58T6BpjYXVsBy8tF+anrx+7iI7Rn1/VPKMr1DAzvepyovDyky
         W0yarh6z/EBd9gjdcHt673JWh5gjN5bGzpahSsZO7oAjHvanJLsLvxySMakLq9Tsafni
         rBoW+Gt/0FcXKMj0LS/bSZqFS9qoR53ZZZXqG9hOFBbajg/v9vEyYXv5gSYdKXhhrlWS
         Xw/g==
X-Gm-Message-State: APjAAAVfo+KYHgEvmZ1BANMXSTueWD8skMQUqRK8zO39XCzUdXF93AFY
        /FUaBC2dXX3tPxIJp+MaP+cQLA==
X-Google-Smtp-Source: APXvYqwq9CdT/9kJv0rw1kiMmECIP47zuMD1csAiMhiHe/9lFSAQPu4oNrcI+2w+R0ODwiQfdugV0g==
X-Received: by 2002:a6b:6505:: with SMTP id z5mr4234812iob.295.1559253056983;
        Thu, 30 May 2019 14:50:56 -0700 (PDT)
Received: from localhost.localdomain (107-0-94-194-ip-static.hfc.comcastbusiness.net. [107.0.94.194])
        by smtp.gmail.com with ESMTPSA id j125sm1662391itb.27.2019.05.30.14.50.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 30 May 2019 14:50:56 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
X-Google-Original-From: Tom Herbert <tom@quantonium.net>
To:     davem@davemloft.net, netdev@vger.kernel.org, dlebrun@google.com
Cc:     Tom Herbert <tom@quantonium.net>
Subject: [PATCH net-next 4/6] ah6: Create function __zero_out_mutable_opts
Date:   Thu, 30 May 2019 14:50:19 -0700
Message-Id: <1559253021-16772-5-git-send-email-tom@quantonium.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559253021-16772-1-git-send-email-tom@quantonium.net>
References: <1559253021-16772-1-git-send-email-tom@quantonium.net>
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


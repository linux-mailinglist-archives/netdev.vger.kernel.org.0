Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD4FB3045B
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 23:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbfE3V5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 17:57:47 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:53423 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbfE3V5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 17:57:46 -0400
Received: by mail-it1-f196.google.com with SMTP id m141so12534073ita.3
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 14:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vpCDadP+lypEq2qDT0dWFaVIhZacvzoPNWNfggfQPmk=;
        b=AcNZX+litCgbTXxyROXLE8Q0M200PUHDskmUC5ipc/3Ww8jfoeDr43yKxK3fhm33cZ
         rgtPgJORztElSzowZtAqtgSLQEGU8C4GuQhsZ/xNY08fL+48A9HHxVdWIumuqUyWTdW/
         UW7FGVat4spV0Xu4sI2Z/mso7QUCI04CsqZeTN8AVg/OtWBb+F4CJgkbqxR2DYexqdWK
         4moJe5moJEUoIc6ZeG0S+U8Fz8ACcPIqFaPQh7dqW2O1ASRk0/HOl8iMEfZvYKfgkMbu
         m22jpjaxF8h9zlv8Jrn4FvPf9nQC54V6DngsrFT+x7vQCo+a5YObh15nOrPaT6dmcZHn
         ioyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vpCDadP+lypEq2qDT0dWFaVIhZacvzoPNWNfggfQPmk=;
        b=SNuOVxIICnFsdknYUu6J3w1HSgWpy9rJNHs1q6LovggoaM9k1GS6rSFj7APKGlzfvz
         nXvCZOE6syM/S5/azjvFtH3BQD2V25mRdaHOKkokpPM49nD40Bn5GZ1Xx35x3gB7eN9d
         Hrf2upRgMQGEthEWBD1gA8a6CHeMEFykAEwg2N2fqiigvG9MebJhvjDa+QVdkqgNGgNK
         T5FXQlBAgZ4GTqGeggO5xzGLvDmwu2PLee/e1DUDjkh406zS/C7Z+9EbTeVM+HcXzNG8
         m/HzOifMP8TArgzLSafwjgmv5FnZLCXHJ75j6wsnDLnths1enBjhmAFQrv1bEOiUN713
         1aYA==
X-Gm-Message-State: APjAAAVKXW1VOMEZYyWPmDeoQs0Ylq5crUpUxW5N6K/UL2MDOg5HppP5
        cooxy5KlAi2B+wr1xJyCyj+2jg==
X-Google-Smtp-Source: APXvYqxhM8NUpRH+0JVIhp6qG+bDUg0sN4x2pW/k/AcPx2wPRHY0XlvTzCGo5uDdUHkENs0fDGSFxw==
X-Received: by 2002:a05:660c:8a:: with SMTP id t10mr4624497itj.152.1559253059553;
        Thu, 30 May 2019 14:50:59 -0700 (PDT)
Received: from localhost.localdomain (107-0-94-194-ip-static.hfc.comcastbusiness.net. [107.0.94.194])
        by smtp.gmail.com with ESMTPSA id j125sm1662391itb.27.2019.05.30.14.50.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 30 May 2019 14:50:59 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
X-Google-Original-From: Tom Herbert <tom@quantonium.net>
To:     davem@davemloft.net, netdev@vger.kernel.org, dlebrun@google.com
Cc:     Tom Herbert <tom@quantonium.net>
Subject: [PATCH net-next 5/6] ah6: Be explicit about which routing types are processed.
Date:   Thu, 30 May 2019 14:50:20 -0700
Message-Id: <1559253021-16772-6-git-send-email-tom@quantonium.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559253021-16772-1-git-send-email-tom@quantonium.net>
References: <1559253021-16772-1-git-send-email-tom@quantonium.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current code assumes that all routing headers can be processed
as type 0 when rearranging the routing header for AH verification.
Change this to be explicit. Type 0 and type 2 are supported and are
processed the same way with regards to AH.

Also check if rearranging routing header fails. Update reference
in comment to more current RFC.

Signed-off-by: Tom Herbert <tom@quantonium.net>
---
 net/ipv6/ah6.c | 37 +++++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/net/ipv6/ah6.c b/net/ipv6/ah6.c
index 1e80157..032491c 100644
--- a/net/ipv6/ah6.c
+++ b/net/ipv6/ah6.c
@@ -145,7 +145,7 @@ static bool zero_out_mutable_opts(struct ipv6_opt_hdr *opthdr)
 /**
  *	ipv6_rearrange_destopt - rearrange IPv6 destination options header
  *	@iph: IPv6 header
- *	@destopt: destionation options header
+ *	@destopt: destination options header
  */
 static void ipv6_rearrange_destopt(struct ipv6hdr *iph, struct ipv6_opt_hdr *destopt)
 {
@@ -204,15 +204,16 @@ static void ipv6_rearrange_destopt(struct ipv6hdr *iph, struct ipv6_opt_hdr *des
 #endif
 
 /**
- *	ipv6_rearrange_rthdr - rearrange IPv6 routing header
+ *	ipv6_rearrange_type0_rthdr - rearrange type 0 IPv6 routing header
  *	@iph: IPv6 header
  *	@rthdr: routing header
  *
  *	Rearrange the destination address in @iph and the addresses in @rthdr
  *	so that they appear in the order they will at the final destination.
- *	See Appendix A2 of RFC 2402 for details.
+ *	See Appendix A2 of RFC 4302 for details.
  */
-static void ipv6_rearrange_rthdr(struct ipv6hdr *iph, struct ipv6_rt_hdr *rthdr)
+static bool ipv6_rearrange_type0_rthdr(struct ipv6hdr *iph,
+				       struct ipv6_rt_hdr *rthdr)
 {
 	int segments, segments_left;
 	struct in6_addr *addrs;
@@ -220,15 +221,13 @@ static void ipv6_rearrange_rthdr(struct ipv6hdr *iph, struct ipv6_rt_hdr *rthdr)
 
 	segments_left = rthdr->segments_left;
 	if (segments_left == 0)
-		return;
+		return true;
 	rthdr->segments_left = 0;
 
 	/* The value of rthdr->hdrlen has been verified either by the system
 	 * call if it is locally generated, or by ipv6_rthdr_rcv() for incoming
 	 * packets.  So we can assume that it is even and that segments is
 	 * greater than or equal to segments_left.
-	 *
-	 * For the same reason we can assume that this option is of type 0.
 	 */
 	segments = rthdr->hdrlen >> 1;
 
@@ -240,6 +239,24 @@ static void ipv6_rearrange_rthdr(struct ipv6hdr *iph, struct ipv6_rt_hdr *rthdr)
 
 	addrs[0] = iph->daddr;
 	iph->daddr = final_addr;
+
+	return true;
+}
+
+static bool ipv6_rearrange_rthdr(struct ipv6hdr *iph, struct ipv6_rt_hdr *rthdr)
+{
+	switch (rthdr->type) {
+	case IPV6_SRCRT_TYPE_2:
+		/* Simplified format of type 0 so same processing */
+		/* fallthrough */
+	case IPV6_SRCRT_TYPE_0: /* Deprecated */
+		return ipv6_rearrange_type0_rthdr(iph, rthdr);
+	default:
+		/* Bad or unidentified routing header, we don't know how
+		 * to fix this header for security purposes. Return failure.
+		 */
+		return false;
+	}
 }
 
 static int ipv6_clear_mutable_options(struct ipv6hdr *iph, int len, int dir)
@@ -271,7 +288,11 @@ static int ipv6_clear_mutable_options(struct ipv6hdr *iph, int len, int dir)
 			break;
 
 		case NEXTHDR_ROUTING:
-			ipv6_rearrange_rthdr(iph, exthdr.rth);
+			if (!ipv6_rearrange_rthdr(iph, exthdr.rth)) {
+				net_dbg_ratelimited("bad routing header\n");
+				return -EINVAL;
+			}
+
 			break;
 
 		default:
-- 
2.7.4


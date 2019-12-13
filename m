Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF9811EBD0
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 21:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729034AbfLMUZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 15:25:00 -0500
Received: from dvalin.narfation.org ([213.160.73.56]:34592 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728837AbfLMUY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 15:24:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1576268697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=MYisEgNmixbBG8GV93IJ5fHA4QLRtQhIbSwGx79EwSU=;
        b=mpPqvK3FqrZxvCZgsBdgZau4KU7rfy3YBtRzVTPegMSMU0+aSxKetB746nL4cDgnq00lGF
        auCAmpqBiisVxf0LDmj+8gcqAOYWNN8babdEZguZ0YO93Bequu92HmPKRaghCmXA2NEij4
        7w7nEHMJVbeQL9CXLsHmmLzi/Tk2DrQ=
From:   Sven Eckelmann <sven@narfation.org>
To:     netdev@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 1/2] ipv6: Annotate bitwise IPv6 dsfield pointer cast
Date:   Fri, 13 Dec 2019 21:24:27 +0100
Message-Id: <20191213202428.13869-1-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sparse commit 6002ded74587 ("add a flag to warn on casts to/from
bitwise pointers") introduced a check for non-direct casts from/to
restricted datatypes (when -Wbitwise-pointer is enabled).

This triggered a warning in ipv6_get_dsfield() because sparse doesn't know
that the buffer already points to some data in the correct bitwise integer
format. This was already fixed in ipv6_change_dsfield() by the __force
attribute and can be fixed here the same way.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 include/net/dsfield.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/dsfield.h b/include/net/dsfield.h
index 1a245ee10c95..a59a57ffc546 100644
--- a/include/net/dsfield.h
+++ b/include/net/dsfield.h
@@ -21,7 +21,7 @@ static inline __u8 ipv4_get_dsfield(const struct iphdr *iph)
 
 static inline __u8 ipv6_get_dsfield(const struct ipv6hdr *ipv6h)
 {
-	return ntohs(*(const __be16 *)ipv6h) >> 4;
+	return ntohs(*(__force const __be16 *)ipv6h) >> 4;
 }
 
 
-- 
2.20.1


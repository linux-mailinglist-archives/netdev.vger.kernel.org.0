Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69977449B5
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 19:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbfFMR3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 13:29:08 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:39497 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbfFMR3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 13:29:07 -0400
Received: by mail-qk1-f194.google.com with SMTP id i125so13288411qkd.6;
        Thu, 13 Jun 2019 10:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :content-transfer-encoding:user-agent;
        bh=+HhoAIOFBzZF13yTI/CQ3NdpHv8MGgGEKfl3+bPeWz0=;
        b=NL9CsUG9/kgj3/SNK7q02oUYioIhuzBov6pOfX/aaZ6pU+6sMwRN4AtRlnNzhHaiuC
         8x0HPVXnavDQUk0kLOpHF+/ydIxXgaY5Wwt7gaLvfCavBjfbzLW9anycfZJxMASpU2ko
         /KrqqTHnekwV+2xD+EACGPyF27FCGt21hMflIazX/USHzc+XExaCMVREekqc8NmBNN5O
         d976rqt0WX3JlMMlyqTzOQpZ1SNr4nH1R+sKZ16DGY3pszsKM9/HOLa5TGq5fBYGun9D
         9pPoPOjwvjn4ZGpNikIpaKaoMFECPFQN58t3KR6gsq6K13widwW0znUOTWl8R4Sy18TO
         roCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding:user-agent;
        bh=+HhoAIOFBzZF13yTI/CQ3NdpHv8MGgGEKfl3+bPeWz0=;
        b=Wku1yvJNLEDAeJcu0q+3PoGp913Bhy2rjCj9PYgFtfpLF3/iKRFUoBmbU5/ofUu0uI
         kt3r+7QQG2QiApsGSHKKL2BY+sBGUW7SSyHQupJddvo2I2SQ0LJSH1ghaY3ZbZmwqfq4
         DtdTYIl80GaqWlyGAm4jvVw9lb5uAjE0rHFXaFOAwZfjwcKBv+0WvH62PMCgXPjT9bta
         rW9QqwekVP/C94AYfbW5hiK9CVCX9nxC2QLvCtfSbasC14yIOkP6n+TC5DBnUW4jCjog
         huZDjeZJY+nI8tD6RkvMKgHiw3KG5nhPE74xC72HPS6IgjYTm/Rl4jGtRrYOHjZxVJdj
         K2OA==
X-Gm-Message-State: APjAAAVg5y9Wsemf5mwbzewntejPsbp7K4Ejg6CYebgLAe+8tn9HIfEZ
        k6KVm5CZ60h+95d9GXudCeFqejxcmr4=
X-Google-Smtp-Source: APXvYqzH4zrPPHYCqCJe+XI9RwZBI0wEFhqyMCm7QAeyMqzZzU3HPaAy/HUwQnuyPuG1ZpUFVSAKDA==
X-Received: by 2002:a37:ea0c:: with SMTP id t12mr3203598qkj.117.1560446946381;
        Thu, 13 Jun 2019 10:29:06 -0700 (PDT)
Received: from debie ([2804:431:f704:c7eb:af:a4f9:dcbb:96b3])
        by smtp.gmail.com with ESMTPSA id d141sm131721qke.3.2019.06.13.10.29.04
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 13 Jun 2019 10:29:05 -0700 (PDT)
Date:   Thu, 13 Jun 2019 14:28:41 -0300
From:   Charles <18oliveira.charles@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rodrigosiqueiramelo@gmail.com
Subject: [PATCH] net: ipva: fix uninitialized variable warning
Message-ID: <20190613172841.s4ig3p53wpd2z3nb@debie>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid following compiler warning on uninitialized variable

net/ipv4/fib_semantics.c: In function ‘fib_check_nh_v4_gw’:
net/ipv4/fib_semantics.c:1023:12: warning: ‘err’ may be used
uninitialized in this function [-Wmaybe-uninitialized]
   if (!tbl || err) {

Signed-off-by: Charles Oliveira <18oliveira.charles@gmail.com>
---
 net/ipv4/fib_semantics.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index b80410673915..ae47e046695c 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -964,7 +964,7 @@ static int fib_check_nh_v4_gw(struct net *net, struct fib_nh *nh, u32 table,
 {
 	struct net_device *dev;
 	struct fib_result res;
-	int err;
+	int err = -EINVAL;
 
 	if (nh->fib_nh_flags & RTNH_F_ONLINK) {
 		unsigned int addr_type;
-- 
2.11.0


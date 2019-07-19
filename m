Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D80F6E0FC
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 08:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbfGSGaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 02:30:11 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46467 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbfGSGaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 02:30:11 -0400
Received: by mail-pf1-f193.google.com with SMTP id c73so13707986pfb.13
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 23:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4qP18y5koAJicPGSDB55dMZlPCoixIAncf60hF+tGLU=;
        b=WChxYgvZEF94PXaeF3aNcCpGcj2/xixtypvXNRt/1O3D+ZEBsVI42g/z5NSF2Fv7ty
         It0VvY9BVI7HJLuB2qEq4a9NxO7BQexfY3wAp5JOHnqQHgmKORss7TxMPAZYcENwlJW2
         KBAdnQ25mdTSyjErfuwM5+4ZZxif2SBBGtC24JlXO9artIimCpXNBVJ/zLscY5nEDNgr
         1Wc4Khr1qzSBSlLYuIoO4TFhg5XHmK6fVrnVqmfmw1IgmSmkyrjHR9ahurR8jy10qqGD
         FL7zKglAWLGPZEAAif+XDZE2Esx7l66pDVAKmF41xujA4x3uLnXWj9d92ejDyGAnzN1e
         2A4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4qP18y5koAJicPGSDB55dMZlPCoixIAncf60hF+tGLU=;
        b=imRWq5kLC+/+5/oJLzx+Fi8u1n+1ui1hXZyortb8G7/ZINkoTWZZ7niILe1qTyBYSh
         wX8FLRzOl/w7BtW1fSw9iNAhO1ocewQUevAk0eMRqNHWoiuWgrmSXod5DCPLrEdeuVhW
         vV9yf7yQ4nbG4P3fQNwCsFEkt6D6WMMMoF5O8+H0qdIW8T/3aEee61XwuzgNxyw04MU8
         VpVQAgNnbOX8wL9iFfbsbOS0xcUJJopvfQVXW/UKAgnuK9TXMhh62rV0FLvYUpRGbYKq
         EwT4K16t01cZVqKzkiujzkAOlLOpi5GG6VEsa7T0P1OlarVyxH1X1UvZpU5I4IAohLs1
         ZXjQ==
X-Gm-Message-State: APjAAAWMDdCee3jz4+mEQEmjBNVrt7vBvPOH9xE04GCK+BPVuj9/RFMh
        nbIWJ3aa6m6mxAU5pWj3usM=
X-Google-Smtp-Source: APXvYqzCdDefMU2SCK6eSyNPYZdZXNVOxGXSanBY+irYG9+JzHb4pU4NoL5J4B3cXrbccaxOQ6LkDA==
X-Received: by 2002:a17:90a:9a95:: with SMTP id e21mr54449882pjp.98.1563517810151;
        Thu, 18 Jul 2019 23:30:10 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:0:1000:1601:d7a4:903f:6d6b:ec10])
        by smtp.gmail.com with ESMTPSA id d2sm26211177pgo.0.2019.07.18.23.30.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 18 Jul 2019 23:30:09 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Lorenzo Colitti <lorenzo@google.com>,
        Remin Nguyen Van <reminv@google.com>,
        "Alexey I . Froloff" <raorn@raorn.name>
Subject: [PATCH] net-ipv6-ndisc: add support for RFC7710 RA Captive Portal Identifier
Date:   Thu, 18 Jul 2019 23:30:03 -0700
Message-Id: <20190719063003.10684-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

This is trivial since we already have support for the entirely
identical (from the kernel's point of view) RDNSS and DNSSL that
also contain opaque data that needs to be passed down to userspace.

As specified in RFC7710, Captive Portal option contains a URL.
8-bit identifier of the option type as assigned by the IANA is 37.
This option should also be treated as userland.

Hence, treat ND option 37 as userland (Captive Portal support)

See:
  https://tools.ietf.org/html/rfc7710
  https://www.iana.org/assignments/icmpv6-parameters/icmpv6-parameters.xhtml

Fixes: e35f30c131a56
Signed-off-by: Maciej Żenczykowski <maze@google.com>
Cc: Lorenzo Colitti <lorenzo@google.com>
Cc: Remin Nguyen Van <reminv@google.com>
Cc: Alexey I. Froloff <raorn@raorn.name>
---
 include/net/ndisc.h | 1 +
 net/ipv6/ndisc.c    | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/net/ndisc.h b/include/net/ndisc.h
index 366150053043..b2f715ca0567 100644
--- a/include/net/ndisc.h
+++ b/include/net/ndisc.h
@@ -40,6 +40,7 @@ enum {
 	ND_OPT_RDNSS = 25,		/* RFC5006 */
 	ND_OPT_DNSSL = 31,		/* RFC6106 */
 	ND_OPT_6CO = 34,		/* RFC6775 */
+	ND_OPT_CAPTIVE_PORTAL = 37,	/* RFC7710 */
 	__ND_OPT_MAX
 };
 
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 083cc1c94cd3..53caf59c591e 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -196,6 +196,7 @@ static inline int ndisc_is_useropt(const struct net_device *dev,
 {
 	return opt->nd_opt_type == ND_OPT_RDNSS ||
 		opt->nd_opt_type == ND_OPT_DNSSL ||
+		opt->nd_opt_type == ND_OPT_CAPTIVE_PORTAL ||
 		ndisc_ops_is_useropt(dev, opt->nd_opt_type);
 }
 
-- 
2.22.0.657.g960e92d24f-goog


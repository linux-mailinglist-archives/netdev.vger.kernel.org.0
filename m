Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9032AC48
	for <lists+netdev@lfdr.de>; Sun, 26 May 2019 23:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbfEZVPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 17:15:31 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45627 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbfEZVPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 May 2019 17:15:31 -0400
Received: by mail-pf1-f193.google.com with SMTP id s11so8337766pfm.12
        for <netdev@vger.kernel.org>; Sun, 26 May 2019 14:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=K6kQzPw/tletp7365l+A+H67m8/LsP9/IKsjsZOW2W4=;
        b=YYOiPb8Zoq6hmYkDvyrF9lsAFo61K1tZBR6vmi/Gps3LakdgqSvrmFUPcMd7WsZml7
         pXcOFaiBtHTwDjpf6o5SyNFEdfhOfvT0vycxWbZgTgBcIIT8L4mHjWwh/3fbNtoYK0sC
         RSrBJYnx/ANmXHcGtnljBFvHoi0+mRsTZM5HNQQSmx2f2Um7qQfHrpgAmH0/5H1jvjsg
         SJUvdsAwPG4jfSl1Tphl+Nv0qmxIzC23hVpy6UoUIOpmQPm8tQmn3AyEVdGrk1XSSC47
         v2hLFVDTyGFZhsVeNGKAk3Mxv4qtEz5/7PlWf/RP2M6bygvFsjh3j8oJqFUEcZJmg7vg
         fVmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=K6kQzPw/tletp7365l+A+H67m8/LsP9/IKsjsZOW2W4=;
        b=BozQrvJIapUESIRS3mmJ8V/In9NLRYI05TNumeqK3+rAryhWtV1HJKGXuMP2ELHKHo
         GrW3UvvoCfmKr9a2egxWLca6Y0u6GAK4R0NuwGiOSE8y1c//OTiFehmEKulhV85wK8HC
         YXxS8waXa93wuNBMoDlv3K9OKi27bKpA7u16nV4iaRN86a4UfTY4kUYzVWHnVw8VFpeE
         4Kmm1upwLsC7STazhj2jdNiiDGaRjsqxE9tyGLIJA5oMW7y9UTOHawoOExf0nqB1uqcb
         bMY1zeb93k8CMIMhJv/nXMHCKOED9WLp8IGPeowBo2RBtifTLuKMIzDQvr7RzGXa5EgT
         epKA==
X-Gm-Message-State: APjAAAVfMfMhQO7GlxX1aiLes3mK0u2xvMbkDDDfYKq/qDElerTmyMbc
        dAxMb3+5MiXJ0/jQkIGGFuJK0A==
X-Google-Smtp-Source: APXvYqxmq2/T2wlGzXNQno8hRDnt5cb35CdpS7KvNKdC+UFiPx1tDd+/t74jcmlufh9sqsPhpRFUXQ==
X-Received: by 2002:a63:c509:: with SMTP id f9mr122711596pgd.143.1558905330360;
        Sun, 26 May 2019 14:15:30 -0700 (PDT)
Received: from localhost.localdomain (c-73-223-249-119.hsd1.ca.comcast.net. [73.223.249.119])
        by smtp.gmail.com with ESMTPSA id f40sm13325325pjg.9.2019.05.26.14.15.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 26 May 2019 14:15:29 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
X-Google-Original-From: Tom Herbert <tom@quantonium.net>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Tom Herbert <tom@quantonium.net>
Subject: [PATCH net-next 1/4] ipv6: Resolve comment that EH processing order is being violated
Date:   Sun, 26 May 2019 14:15:03 -0700
Message-Id: <1558905306-2968-2-git-send-email-tom@quantonium.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558905306-2968-1-git-send-email-tom@quantonium.net>
References: <1558905306-2968-1-git-send-email-tom@quantonium.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ipv6_skip_exthdr is preambled with a comment indicating that the
function necessarily violates the extension header processing order
requirements of RFC2460 in order to fulfill requirements of ICMPv6
processing. This patch revises the comment to indicate that the
function is conformant with RFC8200 (which obsoletes RFC2460) on
the basis that later headers are only being parsed and not actually
processed.

Signed-off-by: Tom Herbert <tom@quantonium.net>
---
 net/ipv6/exthdrs_core.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/net/ipv6/exthdrs_core.c b/net/ipv6/exthdrs_core.c
index 11a43ee..aa025e5 100644
--- a/net/ipv6/exthdrs_core.c
+++ b/net/ipv6/exthdrs_core.c
@@ -27,22 +27,13 @@ EXPORT_SYMBOL(ipv6_ext_hdr);
 /*
  * Skip any extension headers. This is used by the ICMP module.
  *
- * Note that strictly speaking this conflicts with RFC 2460 4.0:
- * ...The contents and semantics of each extension header determine whether
- * or not to proceed to the next header.  Therefore, extension headers must
- * be processed strictly in the order they appear in the packet; a
- * receiver must not, for example, scan through a packet looking for a
- * particular kind of extension header and process that header prior to
- * processing all preceding ones.
- *
- * We do exactly this. This is a protocol bug. We can't decide after a
- * seeing an unknown discard-with-error flavour TLV option if it's a
- * ICMP error message or not (errors should never be send in reply to
- * ICMP error messages).
- *
- * But I see no other way to do this. This might need to be reexamined
- * when Linux implements ESP (and maybe AUTH) headers.
- * --AK
+ * Note that Section 4, RFC8200 specifies "extension headers must be processed
+ * strictly in the order they appear in the packet". This function does skip
+ * over extension headers, however it is only for the purpose of extracting
+ * information about deeper header layers in the packet. Specified protocol
+ * processing is not being doing for scanned headers, hence extension headers
+ * are only being parsed but not processed out of order. Therefore, this
+ * function is conformant with RFC8200.
  *
  * This function parses (probably truncated) exthdr set "hdr".
  * "nexthdrp" initially points to some place,
-- 
2.7.4


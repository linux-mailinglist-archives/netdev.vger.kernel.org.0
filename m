Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A3B1AA351
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 15:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503911AbgDONHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 09:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2506035AbgDONHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 09:07:14 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35A1C061A0C
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 06:07:13 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id fb4so749755qvb.7
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 06:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9S9paPCrXQHsHuQCHecjyKf5i+MDkrTmn5MJCAipxJQ=;
        b=o/ZNcnmZW+ScqxZoAkhxcphNmhEnVXmRcHf3LS9LLLNz697MTK5Y0QzkYdd5nBPf/f
         btQam4uizu0qeTs27NpFkc16QP+xCh8YZVSJ09qSwyx8wxXT/waFzJhwq9QsekVExxsH
         mA8ZXG5Q2rtdjeNYpuD64DMi4nzk2QxUmp7wYjc5ve6fM+trtRzrXttuc27GVtCZOWOm
         m2FZ1+h3cwEPQp90ItQaFVXTm49Hhu7eLbbEwPYnZweARvapzFqtJvvHlwhHXaH4njrw
         PJmAOheltJ6h6WlbK6TmdmSYxk0NZiJZQB9BZgWyVEhrCzmFrDCjKfThnumbyAyN1TOA
         5AWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9S9paPCrXQHsHuQCHecjyKf5i+MDkrTmn5MJCAipxJQ=;
        b=h7+469LOsB2/nJA/Nh07FrWsuYbVAKqEMNzUT0HbnFgRFgR2f3MaYIy1ws9Lv/K3Ph
         vXLZ7ocUVROHX0ne/ZF58KpRtXwOeVzkHARfhkY6QXLigvGuAxJF0lyOFeVDE5qaxEBD
         tv/5nYFxZ+zCdZNCkv3yVWZrbHdf1fbaWfe69RBwznPmXlmNPJnlSSzpM4XNVah64tpN
         wsUfCwuJXAeakE9jSAyl9EvWF2bQdWBrTBdNRRh0YbZPWyAbdhqts+8fRi+0FaFsBnan
         +mUpQFTU+JYOKrjJJFGOU2QT3uifiNT3AdGk19LMAUHn4+twnCo4ngx3L7oKoEWg8764
         Pn+w==
X-Gm-Message-State: AGi0Puajr+guaMbJ3QBCJcBTciQqaP+vbtLx/lXeCuoHmuV0fPOEhm80
        nLuHCttEm7bt6g9qzpNM0ZU=
X-Google-Smtp-Source: APiQypJGmRkZIhTtzjl1/2obmD9YuF6+7qjVLIpKhZAUISYZYG8cl8SKady3xDvFkj8WbXnyZqlB0A==
X-Received: by 2002:a0c:b905:: with SMTP id u5mr4802682qvf.125.1586956033006;
        Wed, 15 Apr 2020 06:07:13 -0700 (PDT)
Received: from localhost.localdomain ([45.72.161.207])
        by smtp.gmail.com with ESMTPSA id n190sm12382321qkb.93.2020.04.15.06.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2020 06:07:12 -0700 (PDT)
From:   Alexander Aring <alex.aring@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        mcr@sandelman.ca, stefan@datenfreihafen.org,
        netdev@vger.kernel.org, Alexander Aring <alex.aring@gmail.com>
Subject: [PATCH net] ipv6: rpl: fix full address compression
Date:   Wed, 15 Apr 2020 09:06:53 -0400
Message-Id: <20200415130653.6791-1-alex.aring@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch makes it impossible that cmpri or cmpre values are set to the
value 16 which is not possible, because these are 4 bit values. We
currently run in an overflow when assigning the value 16 to it.

According to the standard a value of 16 can be interpreted as a full
elided address which isn't possible to set as compression value. A reason
why this cannot be set is that the current ipv6 header destination address
should never show up inside the segments of the rpl header. In this case we
run in a overflow and the address will have no compression at all. Means
cmpri or compre is set to 0.

As we handle cmpri and cmpre sometimes as unsigned char or 4 bit value
inside the rpl header the current behaviour ends in an invalid header
format. This patch simple use the best compression method if we ever run
into the case that the destination address is showed up inside the rpl
segments. We avoid the overflow handling and the rpl header is still valid,
even when we have the destination address inside the rpl segments.

Signed-off-by: Alexander Aring <alex.aring@gmail.com>
---
 net/ipv6/rpl.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/rpl.c b/net/ipv6/rpl.c
index d38b476fc7f2..307f336b5353 100644
--- a/net/ipv6/rpl.c
+++ b/net/ipv6/rpl.c
@@ -8,6 +8,7 @@
 #include <net/rpl.h>
 
 #define IPV6_PFXTAIL_LEN(x) (sizeof(struct in6_addr) - (x))
+#define IPV6_RPL_BEST_ADDR_COMPRESSION 15
 
 static void ipv6_rpl_addr_decompress(struct in6_addr *dst,
 				     const struct in6_addr *daddr,
@@ -73,7 +74,7 @@ static unsigned char ipv6_rpl_srh_calc_cmpri(const struct ipv6_rpl_sr_hdr *inhdr
 		}
 	}
 
-	return plen;
+	return IPV6_RPL_BEST_ADDR_COMPRESSION;
 }
 
 static unsigned char ipv6_rpl_srh_calc_cmpre(const struct in6_addr *daddr,
@@ -83,10 +84,10 @@ static unsigned char ipv6_rpl_srh_calc_cmpre(const struct in6_addr *daddr,
 
 	for (plen = 0; plen < sizeof(*daddr); plen++) {
 		if (daddr->s6_addr[plen] != last_segment->s6_addr[plen])
-			break;
+			return plen;
 	}
 
-	return plen;
+	return IPV6_RPL_BEST_ADDR_COMPRESSION;
 }
 
 void ipv6_rpl_srh_compress(struct ipv6_rpl_sr_hdr *outhdr,
-- 
2.20.1


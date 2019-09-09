Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61490AE122
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 00:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389180AbfIIWhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 18:37:31 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46814 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726940AbfIIWha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 18:37:30 -0400
Received: by mail-pl1-f196.google.com with SMTP id t1so7352393plq.13
        for <netdev@vger.kernel.org>; Mon, 09 Sep 2019 15:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=d0LILC2633SYh9WSYFBaNtUUAlCaSBgRoHMGDUTrk2s=;
        b=HdygJsEl2rvlxaz3ulE9FkJhGUH1T73kyvxeoCtNvb5Bp8GPQh2glEX9i6MyZADG5S
         tF4O7zfckACxKhh28jtpYCl5P17T4qL6Kvc07qY3QJ5rBzVhtWZIDAR8GBNNrRU71hsp
         AVuNbqDIJ+3lh3PGlGZJjZnzxWPh4ePEVMzwIHndLYvepjnomY0IS+wWhb+JqOIfuDHX
         f+XatZfMr7TgTpw8MRYqAqAT8A+dLv2GXwyHtheekkgsf+9nhsO92xSwA7jKzbRsixnJ
         Zw+twdHfWkhB6NqZMh7OthLnSRw65O8MizDRdlr7/oU2fhHU0dlb9YqLNd5LKln5/S4+
         /t4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=d0LILC2633SYh9WSYFBaNtUUAlCaSBgRoHMGDUTrk2s=;
        b=Kzke+CC2qQ21rc5EZG65LHNkkdW7ss7pDuY4Gb509oRRQWzJU8UULNMtRfTOLbw3HI
         JoWN2McCARyF3VkwujT8Lidi49dSQRjYW/AFar7qx+ND11o/GH6daG4i5//I5NDTBwz+
         IJw0wWB9bt9R2nzpW5BP28U7o82KgQCXsQ+LAPYPOEgmADpamQv25fHts9D4GAlqnBTg
         sE1N+mglw/5Jd91WOKwuNlexkl72OuTmCuYL/7/F5y09e9yXLMmJh6xYcSPysTaBPekv
         M82wSShInnrw+rAyWSnUSk+HDElHfsXEGe6Rt32UIzp/T/o53oHCJzBmvmJ9sw6Dgm+m
         ogog==
X-Gm-Message-State: APjAAAU6LRhpRQZudqDD8+ao7WADuSdgl3Ufvhpn+aSlbKmoTPIhcxH8
        exIS6GrCLGMbNxtAWJ6gP+0YBAcjaOGAyw==
X-Google-Smtp-Source: APXvYqzo3UNQWd8D1mS+WhlMlKX2SUKVoD8lvqjv2sGgHzLqvFD50g/CGSYCZlMn8ZP0O8xCAqVgMw==
X-Received: by 2002:a17:902:166:: with SMTP id 93mr27601987plb.320.1568068650005;
        Mon, 09 Sep 2019 15:37:30 -0700 (PDT)
Received: from dancer.lab.teklibre.com ([2603:3024:1536:86f0:eea8:6bff:fefe:9a2])
        by smtp.gmail.com with ESMTPSA id q204sm16186732pfq.176.2019.09.09.15.37.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 09 Sep 2019 15:37:29 -0700 (PDT)
From:   Dave Taht <dave.taht@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Dave Taht <dave.taht@gmail.com>
Subject: [RFC PATCH net-next 2/2] Reduce localhost to 127.0.0.0/16
Date:   Mon,  9 Sep 2019 15:37:19 -0700
Message-Id: <1568068639-6511-3-git-send-email-dave.taht@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1568068639-6511-1-git-send-email-dave.taht@gmail.com>
References: <1568068639-6511-1-git-send-email-dave.taht@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 127 concept of "localhost" was  basically a straight port over from
original ARPANET behavior. At the time it was envisioned that
many services would exist in the mainframe that would need to be
individually addressable, and long predated alternative approaches
such as tipc, etc.

This reduces 127.0.0.0/8 to a /16, and opens up 127.1.0.0 and above
for use as real, unicast addresses either on the wire or internal
to containers, virtual machines, vpns, etc.

The only major uses of 127 to date have been (of
course) 127.0.0.1 and 127.0.1.1 (for dns), and various adhoc uses
for things like anti-spam daemons.

Linux also has a non-standard treatment of the entire 127 address
space - anything sent to any address there "just works". This patch
preserves that behavior for 127.0.0.0/16 only.

Other uses, such as ntp's 127.127 "handle" for it, doesn't actually
touch the stack.  We've seen 127.x used for chassis access and a few
other explicit uses in the field, but very little.

There is some small hope that we can preserve the original intent of
"localhost" in an age of stacked vms and containers, where instead of
using rfc1918 nat at each level, we can route, instead.


---
 include/linux/in.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/in.h b/include/linux/in.h
index 8665842a3589..6e4f37e5bf51 100644
--- a/include/linux/in.h
+++ b/include/linux/in.h
@@ -37,7 +37,9 @@ static inline int proto_ports_offset(int proto)
 
 static inline bool ipv4_is_loopback(__be32 addr)
 {
-	return (addr & htonl(0xff000000)) == htonl(0x7f000000);
+	if((addr & htonl(0xff000000)) == htonl(0x7f000000))
+		return( addr & htonl(0x00ff0000)) == 0;
+	return 0;
 }
 
 static inline bool ipv4_is_multicast(__be32 addr)
-- 
2.17.1


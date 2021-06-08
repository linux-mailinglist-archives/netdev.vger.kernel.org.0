Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74B0B39FAD3
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 17:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbhFHPga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 11:36:30 -0400
Received: from mail-lf1-f42.google.com ([209.85.167.42]:39841 "EHLO
        mail-lf1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232887AbhFHPga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 11:36:30 -0400
Received: by mail-lf1-f42.google.com with SMTP id p17so31964346lfc.6
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 08:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iP2f67S4SfR4Vp3wAXoqgs6iuDezCtUMH1C+HCeozgs=;
        b=INChxCdEoBf9zGWPXrJvtWXVNviSm/3xxzA/Bj7WHtIs7Q00w9kURqZmO90yLEku0Z
         VjNa/BH7fflKbE8IoyBmEmOgqWFTKltDJqExY5XbHWtQeRu7eMh0UFj1VKbVayQ6YW5f
         u/2JP+9yEmuUaJM/nZ+jVjQzZtWu4fhhdtUjRscEjPOkpr/4FMweiHWheyV+BU2wwCaq
         vi4oJYZwUgVwVmpRErjtuWxjkHVZWXEPBGiNFhL2hfCRFO56JuRdVaqxVVX6re4ZGgXa
         st6M+8iM/cV7tLX01TWjKlbSzM1zenYSd6OgjxGydvZJP+JSXcox7shujctiWM7bnuwj
         ds1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iP2f67S4SfR4Vp3wAXoqgs6iuDezCtUMH1C+HCeozgs=;
        b=JjV/AeRqZC0mnRWZXBJFf56Tak0/F2oR6epFBL13mcQLHZF/m9oIpmCxP97XHT2xY5
         x2dwtfHvQj41aBT//UY1q3YtI9/fdmYdjl5stBigRT9+sPrVUCfr9XwCFQEdArAnawqP
         s+VKSG8eFQmLRFDIk9vmRhDm78xCRrUJUjB0jtiXAifPU9RXMThLYOyllRophCZyo7ni
         z9V0B5qSjH8opxbrVQucVg/bchCNNzrFA8jK+2bESsnKoWa8Q5WvvjtIvrsVoa43QqtK
         GjfvQbnboyiiV0Cw2v2xn7VQo3T46pyImeQcWWZ703nGhBNLgP3W8xolSsnriFa4TB61
         7lcg==
X-Gm-Message-State: AOAM533HRJJeX2l46XIP6OKryeIfUqwai+wnggucx8yNR3nFzj2XQod3
        YneHbkb+aFLKpW11zFuyWBM4zThCCQUI5IjV
X-Google-Smtp-Source: ABdhPJwQiMXF/7LETnyP+KekTKeBBuy7iRzWSs3CvFUENVKYgslXn3pfBwZ0Miw80MfDnXkxA9g8FQ==
X-Received: by 2002:a05:6512:3da8:: with SMTP id k40mr5268516lfv.233.1623166404148;
        Tue, 08 Jun 2021 08:33:24 -0700 (PDT)
Received: from dau-work-pc.sunlink.ru ([87.244.6.228])
        by smtp.googlemail.com with ESMTPSA id h4sm10483ljk.4.2021.06.08.08.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 08:33:23 -0700 (PDT)
From:   Anton Danilov <littlesmilingcloud@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org,
        Anton Danilov <littlesmilingcloud@gmail.com>
Subject: [RFC 3/3] [RFC iproute2-next] tc: f_u32: fix the pretty print of ipv4 filters
Date:   Tue,  8 Jun 2021 18:33:09 +0300
Message-Id: <20210608153309.4019-3-littlesmilingcloud@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210608153309.4019-1-littlesmilingcloud@gmail.com>
References: <20210608153309.4019-1-littlesmilingcloud@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

~$: tc f add dev dummy0 parent 1: protocol ip prio 10 \
    u32 match ip ihl 10 0xf match ip dsfield 0x0a 0xff flowid 1:1

Before patch:

~$ sudo tc -p -s f ls dev dummy0
filter parent 1: protocol ip pref 10 u32 chain 0
filter parent 1: protocol ip pref 10 u32 chain 0 fh 801: ht divisor 1
filter parent 1: protocol ip pref 10 u32 chain 0 fh 801::801 order 2049 key ht 801 bkt 0 flowid 1:1 not_in_hw  (rule hit 0 success 0) (success 0 )

After patch:
~$ sudo tc -p -s f ls dev dummy0
filter parent 1: protocol ip pref 10 u32 chain 0
filter parent 1: protocol ip pref 10 u32 chain 0 fh 801: ht divisor 1
filter parent 1: protocol ip pref 10 u32 chain 0 fh 801::801 order 2049 key ht 801 bkt 0 flowid 1:1 not_in_hw  (rule hit 0 success 0)
  match ip ihl 10 0xf
  match ip dsfield 0xa 0xff (success 0 )

Signed-off-by: Anton Danilov <littlesmilingcloud@gmail.com>
---
 tc/f_u32.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/tc/f_u32.c b/tc/f_u32.c
index d7beb586..e60c787a 100644
--- a/tc/f_u32.c
+++ b/tc/f_u32.c
@@ -827,20 +827,25 @@ static int print_ipv4(FILE *f, const struct tc_u32_key *key)
 	if (key == NULL)
 		return 0;
 
+	int ret = 0;
+
 	switch (key->off) {
 	case 0:
-		switch (ntohl(key->mask)) {
-		case 0x0f000000:
-			return fprintf(f, "\n  match IP ihl %u",
-				ntohl(key->val) >> 24);
-		case 0x00ff0000:
-			return fprintf(f, "\n  match IP dsfield %#x",
-				ntohl(key->val) >> 16);
+		if (ntohl(key->mask) & 0x0f000000) {
+			ret = fprintf(f, "\n  match ip ihl %u %#x",
+				(ntohl(key->val) & 0x0f000000) >> 24,
+				(ntohl(key->mask) & 0x0f000000) >> 24);
+		}
+		if (ntohl(key->mask) & 0x00ff0000) {
+			ret += fprintf(f, "\n  match ip dsfield %#x %#x",
+				(ntohl(key->val) & 0x00ff0000) >> 16,
+				(ntohl(key->mask) & 0x00ff0000) >> 16);
 		}
+		return ret;
 		break;
 	case 8:
 		if (ntohl(key->mask) == 0x00ff0000) {
-			return fprintf(f, "\n  match IP protocol %d",
+			return fprintf(f, "\n  match ip protocol %d",
 				ntohl(key->val) >> 16);
 		}
 		break;
@@ -850,7 +855,7 @@ static int print_ipv4(FILE *f, const struct tc_u32_key *key)
 
 			if (bits >= 0) {
 				return fprintf(f, "\n  %s %s/%d",
-					key->off == 12 ? "match IP src" : "match IP dst",
+					key->off == 12 ? "match ip src" : "match ip dst",
 					inet_ntop(AF_INET, &key->val,
 						  abuf, sizeof(abuf)),
 					bits);
-- 
2.20.1


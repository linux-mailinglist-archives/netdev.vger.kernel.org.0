Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC0739FA2F
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 17:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbhFHPVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 11:21:03 -0400
Received: from mail-lf1-f46.google.com ([209.85.167.46]:46894 "EHLO
        mail-lf1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbhFHPVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 11:21:02 -0400
Received: by mail-lf1-f46.google.com with SMTP id m21so16943884lfg.13
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 08:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iP2f67S4SfR4Vp3wAXoqgs6iuDezCtUMH1C+HCeozgs=;
        b=Ysrja/K3sr2v9vNJBzA7mpsTcdfLlIn9AtjutLbyYshsI8aPFKW4BAFEMS4UazSSC1
         Gw/wAlmB1psgxJkKZkSobr7dd4t9wT7yj+5NnRaJGwKnmOrO2pEKhFjRNT76UoNAXyKz
         7eS6NiRdhXjPpAg/IlN3pCuf3PRC0r3Zd4Zyz41T7LdF7G3Ies60TO2EO78R+CSswANl
         QfTJafkzUExv0gL7GiFJl3BkdSg8Tk7p+DqoW0MyxurHV4h7PZUv/sBZ4VaJbpyAOmli
         qlRK9ro3t5fgozLogtLoqTi8G1LTIaqgK2UCc8x2Waotp/Y3KEgii9rZsqj0h+x4OHCA
         0A/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iP2f67S4SfR4Vp3wAXoqgs6iuDezCtUMH1C+HCeozgs=;
        b=ffCK9Q0nEiY3RFJnx4frSbEJcKDD4HNDg5b34Z9JVZJLf/XshhzYJD6kVnvlzynztF
         zrD7k9bEWS5bcSt9ZerT61ATMqvywE7ycb5KtK6BBHLJP4x/1K6Y3Wv36m4YyDPieAub
         zWRYLOqjquqkL9TFwl0rUZgIeKvQmwr5Qcss15CGryAziqsYUUtd78uYLFtPLjQs+8WH
         tdI6kkFtgN/jw+/kBmNVQYLwOsgotFUI+Knj0F1GveYlVsndbRYN6M+3tDB3xrImHqB7
         nhMRE7ibUrIKAjCV25Rd7Zu6hCMWpbZLvtk6ZaFo81KKCvcbl5RznOMpjI4ZyWMxIlfn
         gNcg==
X-Gm-Message-State: AOAM533MH5au1BfEG5AJ8mZWaWrI48o7UROaw2GgiC6LEzSeTlj8j2Cr
        oavlkuF8DYO+rZRSNAwfDZU=
X-Google-Smtp-Source: ABdhPJwSoGxreGH64CtnK+nF+Lx+WgBFBJVhVDyxwSmRY1eb/VX3JNTYnq0kwjrtDoYxyGi+/FzrPQ==
X-Received: by 2002:ac2:5f6f:: with SMTP id c15mr16251915lfc.584.1623165477903;
        Tue, 08 Jun 2021 08:17:57 -0700 (PDT)
Received: from dau-work-pc.sunlink.ru ([87.244.6.228])
        by smtp.googlemail.com with ESMTPSA id x10sm2367ljj.126.2021.06.08.08.17.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 08:17:57 -0700 (PDT)
From:   Anton Danilov <littlesmilingcloud@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org,
        Anton Danilov <littlesmilingcloud@gmail.com>
Subject: [PATCH] [RFC iproute2-next] tc: f_u32: fix the pretty print of ipv4 filters
Date:   Tue,  8 Jun 2021 18:17:38 +0300
Message-Id: <20210608151739.3220-2-littlesmilingcloud@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210608151739.3220-1-littlesmilingcloud@gmail.com>
References: <20210608151739.3220-1-littlesmilingcloud@gmail.com>
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


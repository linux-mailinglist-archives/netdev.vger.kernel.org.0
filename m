Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 655AB6550DB
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 14:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236199AbiLWNVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 08:21:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236308AbiLWNVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 08:21:33 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3378E44974;
        Fri, 23 Dec 2022 05:21:17 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id n3so3323620pfq.10;
        Fri, 23 Dec 2022 05:21:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=z4AG8ZZAFogjfwzHjl2Zwy13JMVfLYspm2kIeKu5RAM=;
        b=YFvxBo3CIvOFONwM24N+B4GChp/tDyPFsL9gpPxWQix4dzBvi7JiaJYk6u1kOCubBy
         1dmQR+wRvyGHw1Ra/dy9OVLrJwAqadhsvXGuRYx3HI0c+DAQo+CcCdwZNXd+uSjAS958
         iUJqgq1583TEV6MV7c5/9RWIv0jqnX+tJBtr8dLSXWycq1ovxaXDIK5LSfmNIQXC7XP2
         Yxn8a5PlPe73PpOcCVc0M5xW/Zk6jhWuYtgRp0QCxwTFakjnv8As7cTnjS4KrWLEbFxy
         bhTtbb08wev5HXLTmsWKcSRy5OQYwXBlrBiWJ56APDOJ6RcwDgDHBo4U5CVyPrEJNvW/
         LUvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z4AG8ZZAFogjfwzHjl2Zwy13JMVfLYspm2kIeKu5RAM=;
        b=3eeAxKecZGUtVFen9e1aNi79uzk0k4z+FxZlicShCIKiJ7zb0Uq6YUxx5yBD1H2K7H
         zg2m6eBC2fNwAlfDqOf0zTk0JQco3AleId82HUBYKUNC01aq5WwRX2KbydE2FOcDzp5V
         HwtSKaFXCUJruycsPsRdeL69BC7Hwb8knqIC4EVRuBEEYZKg2eeCUkG3c42kjuNsPqUP
         0TqKdLpuVDyjx6+3YJTJEhe3RogENkqMcGFrvDKhYIJeb3zrr2SNUQIbqmRdAAfYSpYl
         twyMxPWWH1+fi8nWpJ2OCXEnwPvvGAYf7m0CG3PlFTjEO1jXUYpBTghuo6lHNeNi+y9U
         7neA==
X-Gm-Message-State: AFqh2kqjo37HE9wRRNPBpT+R33DHUTgsE3tpQembjwKxDSCioJu0foTj
        PGuTyCVKsbVqoOemU5CKVpE=
X-Google-Smtp-Source: AMrXdXt2Wvde7aBgxHP+dorQ0fEfjwbBLHIHJCPhl9hvJkUZfepmEk4xGUhmoX+5uVJpDihztQAL4A==
X-Received: by 2002:a05:6a00:1ca4:b0:566:900d:51f2 with SMTP id y36-20020a056a001ca400b00566900d51f2mr10010111pfw.33.1671801676599;
        Fri, 23 Dec 2022 05:21:16 -0800 (PST)
Received: from localhost.localdomain ([110.147.198.134])
        by smtp.gmail.com with ESMTPSA id l66-20020a622545000000b00571bdf45888sm2492153pfl.154.2022.12.23.05.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Dec 2022 05:21:16 -0800 (PST)
From:   Jamie Bainbridge <jamie.bainbridge@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Jamie Bainbridge <jamie.bainbridge@gmail.com>,
        Abhishek Rawal <rawal.abhishek92@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next] icmp: Add counters for rate limits
Date:   Sat, 24 Dec 2022 00:21:01 +1100
Message-Id: <12d652c903f1d67434b683606cf3f5f0f9df861a.1671801634.git.jamie.bainbridge@gmail.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are multiple ICMP rate limiting mechanisms:

* Global limits: net.ipv4.icmp_msgs_burst/icmp_msgs_per_sec
* v4 per-host limits: net.ipv4.icmp_ratelimit/ratemask
* v6 per-host limits: net.ipv6.icmp_ratelimit/ratemask

However, when ICMP output is limited, there is no way to tell
which limit has been hit or even if the limits are responsible
for the lack of ICMP output.

Add counters for each of the cases above. As we are within
local_bh_disable(), use the __INC stats variant.

Example output:

 # nstat -sz "*RateLimit*"
 IcmpOutRateLimitGlobal          134                0.0
 IcmpOutRateLimitHost            770                0.0
 Icmp6OutRateLimitHost           84                 0.0

Signed-off-by: Jamie Bainbridge <jamie.bainbridge@gmail.com>
Suggested-by: Abhishek Rawal <rawal.abhishek92@gmail.com>
---
 include/uapi/linux/snmp.h | 3 +++
 net/ipv4/icmp.c           | 3 +++
 net/ipv4/proc.c           | 8 +++++---
 net/ipv6/icmp.c           | 4 ++++
 net/ipv6/proc.c           | 1 +
 5 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
index 6600cb0164c2beb6f140beaa0bd4ea44e9443b0c..26f33a4c253d75c6661f6606aef9d8fd61baa476 100644
--- a/include/uapi/linux/snmp.h
+++ b/include/uapi/linux/snmp.h
@@ -95,6 +95,8 @@ enum
 	ICMP_MIB_OUTADDRMASKS,			/* OutAddrMasks */
 	ICMP_MIB_OUTADDRMASKREPS,		/* OutAddrMaskReps */
 	ICMP_MIB_CSUMERRORS,			/* InCsumErrors */
+	ICMP_MIB_RATELIMITGLOBAL,		/* OutRateLimitGlobal */
+	ICMP_MIB_RATELIMITHOST,			/* OutRateLimitHost */
 	__ICMP_MIB_MAX
 };
 
@@ -112,6 +114,7 @@ enum
 	ICMP6_MIB_OUTMSGS,			/* OutMsgs */
 	ICMP6_MIB_OUTERRORS,			/* OutErrors */
 	ICMP6_MIB_CSUMERRORS,			/* InCsumErrors */
+	ICMP6_MIB_RATELIMITHOST,		/* OutRateLimitHost */
 	__ICMP6_MIB_MAX
 };
 
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 46aa2d65e40ab63dc2d343997d13c85fd6a51b7a..8cebb476b3ab1833b4efe073efc57dbdfeffd21d 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -296,6 +296,7 @@ static bool icmpv4_global_allow(struct net *net, int type, int code)
 	if (icmp_global_allow())
 		return true;
 
+	__ICMP_INC_STATS(net, ICMP_MIB_RATELIMITGLOBAL);
 	return false;
 }
 
@@ -325,6 +326,8 @@ static bool icmpv4_xrlim_allow(struct net *net, struct rtable *rt,
 	if (peer)
 		inet_putpeer(peer);
 out:
+	if (!rc)
+		__ICMP_INC_STATS(net, ICMP_MIB_RATELIMITHOST);
 	return rc;
 }
 
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index f88daace9de3e1e747c67710f55a198758243482..eaf1d3113b62f7dc93fdc7b7c4041140ac63bf69 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -353,7 +353,7 @@ static void icmp_put(struct seq_file *seq)
 	seq_puts(seq, "\nIcmp: InMsgs InErrors InCsumErrors");
 	for (i = 0; icmpmibmap[i].name; i++)
 		seq_printf(seq, " In%s", icmpmibmap[i].name);
-	seq_puts(seq, " OutMsgs OutErrors");
+	seq_puts(seq, " OutMsgs OutErrors OutRateLimitGlobal OutRateLimitHost");
 	for (i = 0; icmpmibmap[i].name; i++)
 		seq_printf(seq, " Out%s", icmpmibmap[i].name);
 	seq_printf(seq, "\nIcmp: %lu %lu %lu",
@@ -363,9 +363,11 @@ static void icmp_put(struct seq_file *seq)
 	for (i = 0; icmpmibmap[i].name; i++)
 		seq_printf(seq, " %lu",
 			   atomic_long_read(ptr + icmpmibmap[i].index));
-	seq_printf(seq, " %lu %lu",
+	seq_printf(seq, " %lu %lu %lu %lu",
 		snmp_fold_field(net->mib.icmp_statistics, ICMP_MIB_OUTMSGS),
-		snmp_fold_field(net->mib.icmp_statistics, ICMP_MIB_OUTERRORS));
+		snmp_fold_field(net->mib.icmp_statistics, ICMP_MIB_OUTERRORS),
+		snmp_fold_field(net->mib.icmp_statistics, ICMP_MIB_RATELIMITGLOBAL),
+		snmp_fold_field(net->mib.icmp_statistics, ICMP_MIB_RATELIMITHOST));
 	for (i = 0; icmpmibmap[i].name; i++)
 		seq_printf(seq, " %lu",
 			   atomic_long_read(ptr + (icmpmibmap[i].index | 0x100)));
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 9d92d51c475779f7af72b1c4ea35d4d482874db0..79c769c0d1138de1a73363a58362804657ae83c0 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -183,6 +183,7 @@ static bool icmpv6_global_allow(struct net *net, int type)
 	if (icmp_global_allow())
 		return true;
 
+	__ICMP_INC_STATS(net, ICMP_MIB_RATELIMITGLOBAL);
 	return false;
 }
 
@@ -224,6 +225,9 @@ static bool icmpv6_xrlim_allow(struct sock *sk, u8 type,
 		if (peer)
 			inet_putpeer(peer);
 	}
+	if (!res)
+		__ICMP6_INC_STATS(net, ip6_dst_idev(dst),
+				  ICMP6_MIB_RATELIMITHOST);
 	dst_release(dst);
 	return res;
 }
diff --git a/net/ipv6/proc.c b/net/ipv6/proc.c
index d6306aa46bb1eb768ab77aae6a494640ed462157..e20b3705c2d2accedad4aac75064c33f733a80be 100644
--- a/net/ipv6/proc.c
+++ b/net/ipv6/proc.c
@@ -94,6 +94,7 @@ static const struct snmp_mib snmp6_icmp6_list[] = {
 	SNMP_MIB_ITEM("Icmp6OutMsgs", ICMP6_MIB_OUTMSGS),
 	SNMP_MIB_ITEM("Icmp6OutErrors", ICMP6_MIB_OUTERRORS),
 	SNMP_MIB_ITEM("Icmp6InCsumErrors", ICMP6_MIB_CSUMERRORS),
+	SNMP_MIB_ITEM("Icmp6OutRateLimitHost", ICMP6_MIB_RATELIMITHOST),
 	SNMP_MIB_SENTINEL
 };
 
-- 
2.39.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0C79648CF4
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 04:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbiLJDqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 22:46:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiLJDqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 22:46:52 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBE43D395
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 19:46:50 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id b13-20020a17090a5a0d00b0021906102d05so6912065pjd.5
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 19:46:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0ZSfuU7EhwdpEo7Vdw0IN30EmAmZ3Y0RrDJK8vPSb3Q=;
        b=ag0BvpFAU/82NFuHZ4yAclHMMPmp/UCMuJ0BmJ9SgQHbAvE00wyOq3FEWccFasGy3x
         zufLDZfsQ0Mr9dyvl43gsuBDaqEG7l88OW3wL6J6sOvBqWWzywC1ZXmU05UGm4VCsdFy
         Ra7NwRMQbxpnsfwjMcVlqsT9vR1vewsNNiM/gqZGGrykPvVqIdtH9I9goi0Fq5VogaL3
         Gq5QvZhHWcUqP66wD8yTBEbUS/czwMs+1Gq/ezhW7tAxPAKWAr29AU13AwIHsBFAx84R
         PvNgr4H8sqjYwO6IaX7pQYswsQXDnhU56o4aN2SQyQskAifFjtVk2kMu/hsRxMQiDBHm
         CQLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0ZSfuU7EhwdpEo7Vdw0IN30EmAmZ3Y0RrDJK8vPSb3Q=;
        b=kpERckf3DT2W8bo1iy7EVz/ulcNsNmvOPtvN240Dr4zk7aDWNrSE9fvItitTSSSyWZ
         N+ZxO0ayPA93cIGLSVSKV/Yc57yhwonFsflEdPQvfZ2TXeJ5KQJqnfGkRE6Z/JSs4PJQ
         1Wp9KZ7pwuetr36Phe/V0e608LlRB/jhtDfYqPJ6p+h3xE5+6MO5/dQ0VKS42npqmF7U
         B1sbkaI64iWPdQujpqjG8xzLctgYXDZ/Z+QqM+MDRqr6yh7sSSJ7a//6brrWDkBmnKK4
         uReW7vzg3tNH2zAQg4qUhQ99jeq+nRuU6NqDpI5C0sVh5L0pq1dv9oVMIOIyNgHs3W2B
         b1OA==
X-Gm-Message-State: ANoB5pkbEQDprC68FgtUtYgZen5qwoz11dE83a/Aqya7rvCTEswf2UYQ
        xpCL2rA66eQ6SZxk7JRvk7yn7gBUhtlrmUOtlpI=
X-Google-Smtp-Source: AA0mqf6AtMz7tOJFWFl9wkMhcQIySDjJfGQZeWIIbnQ8LDXNZFEV7ecw/JR/Of2BltXn8bPdZ2b+rA==
X-Received: by 2002:a05:6a20:d394:b0:ad:52c5:e606 with SMTP id iq20-20020a056a20d39400b000ad52c5e606mr110733pzb.32.1670644010240;
        Fri, 09 Dec 2022 19:46:50 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id w13-20020a63fb4d000000b0046f7e1ca434sm1611717pgj.0.2022.12.09.19.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 19:46:49 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH] iplink: support JSON in MPLS output
Date:   Fri,  9 Dec 2022 19:46:48 -0800
Message-Id: <20221210034648.90592-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MPLS statistics did not support oneline or JSON
in current code.

Fixes: 837552b445f5 ("iplink: add support for afstats subcommand")
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 ip/iplink.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/ip/iplink.c b/ip/iplink.c
index adb9524c3b93..b8a5284febfb 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -1570,7 +1570,7 @@ void print_mpls_link_stats(FILE *fp, const struct mpls_link_stats *stats,
 		print_num(fp, cols[2], stats->rx_errors);
 		print_num(fp, cols[3], stats->rx_dropped);
 		print_num(fp, cols[4], stats->rx_noroute);
-		fprintf(fp, "\n");
+		print_nl();
 
 		fprintf(fp, "%sTX: %*s %*s %*s %*s%s", indent,
 			cols[0] - 4, "bytes", cols[1], "packets",
@@ -1594,9 +1594,11 @@ static void print_mpls_stats(FILE *fp, struct rtattr *attr)
 		return;
 
 	stats = RTA_DATA(mrtb[MPLS_STATS_LINK]);
-	fprintf(fp, "    mpls:\n");
+	print_string(PRINT_FP, NULL, "    mpls:", NULL);
+	print_nl();
 	print_mpls_link_stats(fp, stats, "        ");
-	fprintf(fp, "\n");
+	print_string(PRINT_FP, NULL, "%s", "\n");
+	fflush(fp);
 }
 
 static void print_af_stats_attr(FILE *fp, int ifindex, struct rtattr *attr)
@@ -1612,8 +1614,12 @@ static void print_af_stats_attr(FILE *fp, int ifindex, struct rtattr *attr)
 			continue;
 
 		if (!if_printed) {
-			fprintf(fp, "%u: %s\n", ifindex,
-				ll_index_to_name(ifindex));
+			print_uint(PRINT_ANY, "ifindex",
+				   "%u:", ifindex);
+			print_color_string(PRINT_ANY, COLOR_IFNAME, 
+					   "ifname", "%s",
+					   ll_index_to_name(ifindex));
+			print_nl();
 			if_printed = true;
 		}
 
@@ -1696,6 +1702,8 @@ static int iplink_afstats(int argc, char **argv)
 		}
 	}
 
+	new_json_obj(json);
+
 	if (rtnl_statsdump_req_filter(&rth, AF_UNSPEC, filt_mask,
 				      NULL, NULL) < 0) {
 		perror("Cannont send dump request");
@@ -1707,6 +1715,7 @@ static int iplink_afstats(int argc, char **argv)
 		return 1;
 	}
 
+	delete_json_obj();
 	return 0;
 }
 
-- 
2.35.1


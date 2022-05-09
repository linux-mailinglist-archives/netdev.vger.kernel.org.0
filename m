Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7DC520521
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 21:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240549AbiEITWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 15:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240546AbiEITWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 15:22:13 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F03522A8AC
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 12:18:18 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id cq17-20020a17090af99100b001dc0386cd8fso208787pjb.5
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 12:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UnwV/4KMtfeusiLdTzsmlqy79kGJH4S3huuAkwFdLm8=;
        b=TA2cCMeZJqdV8qrtm3taXJN/OBA1hHSzlq0znmaDiPxlG05PAj9SYNwnndpdePdZPI
         fZH3ix/1bJTsBtB271sznzUHtoSi6Z28aNQC8F9z7bxZoCssA2aySGOcrVQZX1Wj4EGV
         GWqmNrB+z16eWM9PovrawITmMKVer3NAMnn2eELfcUGCaR7MBTHc5cvaEcuH04nr3JMw
         l5pnbkrF1X9L2XhvzJUpUUzwK6qYnB+29GooeaIBfxOaFISDkEueoxWUCvseUsKAWUBp
         LHkTj10iygWx/uDBrQ8r9B4Ne/ZSROeEiYuGFy0l0eTDwlMd5A0f5m4yhS8P9Zz6E81z
         Hrbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UnwV/4KMtfeusiLdTzsmlqy79kGJH4S3huuAkwFdLm8=;
        b=Il4al5oyXRI4UvBTYOuaDX4LjmMzBClrpxjA7De3ooDYmDyPqe6zAcNiqhLvBgHs07
         m4U1Idz/AMcImrh+P+OSjR7RsSxuHS3TBpFYojxub72KAOmB/u0i8OH42wiNwqSvW+D3
         A9JDB6sTOCof/iXDh+XbNQ2Y+fCai2ImhSSj26AR3M8D36T/d1AWsgOvwOgFyOpO4UQQ
         lY+jAPNs7s6Qcv7v2v6JuBXMXP/fGh6yRojEIaBMJmlk0wQvwVVempuY8A4si+BISfMe
         XEm0/L0SrhXaaT07Hh24kORJlNJ4IsQj3o0kXt+6C9XyJlXM49K05QXRjzP4oOhX9FjB
         4M8Q==
X-Gm-Message-State: AOAM531rC/wej4CGvJwQvqnHgqMMbNFZgC8EbmzgnyJh2QxBgtr3CWyg
        G9zMfxan4DCA2O82FWofS8M1cGZeyJ0=
X-Google-Smtp-Source: ABdhPJx9Wun6SiLREFd/DmN49u1MPjT5Qm6M+Mg8cUPcBGUoya7QgUBi4MIwon+vWkjIsQO06nwpRQ==
X-Received: by 2002:a17:903:248:b0:155:e660:b774 with SMTP id j8-20020a170903024800b00155e660b774mr17891414plh.174.1652123897595;
        Mon, 09 May 2022 12:18:17 -0700 (PDT)
Received: from jeffreyji1.c.googlers.com.com (180.145.227.35.bc.googleusercontent.com. [35.227.145.180])
        by smtp.gmail.com with ESMTPSA id 137-20020a62158f000000b0050dc76281b2sm9344416pfv.140.2022.05.09.12.18.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 12:18:16 -0700 (PDT)
From:   Jeffrey Ji <jeffreyjilinux@gmail.com>
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Brian Vazquez <brianvv@google.com>, netdev@vger.kernel.org,
        Jeffrey Ji <jeffreyji@google.com>
Subject: [PATCH net-next] show rx_otherhost_dropped stat in ip link show
Date:   Mon,  9 May 2022 19:18:10 +0000
Message-Id: <20220509191810.2157940-1-jeffreyjilinux@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeffrey Ji <jeffreyji@google.com>

This stat was added in commit 794c24e9921f ("net-core: rx_otherhost_dropped to core_stats")

Tested: sent packet with wrong MAC address from 1
network namespace to another, verified that counter showed "1" in
`ip -s -s link sh` and `ip -s -s -j link sh`

Signed-off-by: Jeffrey Ji <jeffreyji@google.com>
---
 include/uapi/linux/if_link.h |  2 ++
 ip/ipaddress.c               | 15 +++++++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 22e21e57afc9..50477985bfea 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -243,6 +243,8 @@ struct rtnl_link_stats64 {
 	__u64	rx_compressed;
 	__u64	tx_compressed;
 	__u64	rx_nohandler;
+
+	__u64	rx_otherhost_dropped;
 };
 
 /* Subset of link stats useful for in-HW collection. Meaning of the fields is as
diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index a80996efdc28..9d6af56e2a72 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -692,6 +692,7 @@ static void __print_link_stats(FILE *fp, struct rtattr *tb[])
 		strlen("heartbt"),
 		strlen("overrun"),
 		strlen("compressed"),
+		strlen("otherhost_dropped"),
 	};
 	int ret;
 
@@ -713,6 +714,10 @@ static void __print_link_stats(FILE *fp, struct rtattr *tb[])
 		if (s->rx_compressed)
 			print_u64(PRINT_JSON,
 				   "compressed", NULL, s->rx_compressed);
+		if (s->rx_otherhost_dropped)
+			print_u64(PRINT_JSON,
+				   "otherhost_dropped",
+				   NULL, s->rx_otherhost_dropped);
 
 		/* RX error stats */
 		if (show_stats > 1) {
@@ -795,11 +800,15 @@ static void __print_link_stats(FILE *fp, struct rtattr *tb[])
 				     rta_getattr_u32(carrier_changes) : 0);
 
 		/* RX stats */
-		fprintf(fp, "    RX: %*s %*s %*s %*s %*s %*s %*s%s",
+		fprintf(fp, "    RX: %*s %*s %*s %*s %*s %*s %*s%*s%s",
 			cols[0] - 4, "bytes", cols[1], "packets",
 			cols[2], "errors", cols[3], "dropped",
 			cols[4], "missed", cols[5], "mcast",
-			cols[6], s->rx_compressed ? "compressed" : "", _SL_);
+			s->rx_compressed ? cols[6] : 0,
+			s->rx_compressed ? "compressed " : "",
+			s->rx_otherhost_dropped ? cols[7] : 0,
+			s->rx_otherhost_dropped ? "otherhost_dropped" : "",
+			_SL_);
 
 		fprintf(fp, "    ");
 		print_num(fp, cols[0], s->rx_bytes);
@@ -810,6 +819,8 @@ static void __print_link_stats(FILE *fp, struct rtattr *tb[])
 		print_num(fp, cols[5], s->multicast);
 		if (s->rx_compressed)
 			print_num(fp, cols[6], s->rx_compressed);
+		if (s->rx_otherhost_dropped)
+			print_num(fp, cols[7], s->rx_otherhost_dropped);
 
 		/* RX error stats */
 		if (show_stats > 1) {
-- 
2.36.0.512.ge40c2bad7a-goog


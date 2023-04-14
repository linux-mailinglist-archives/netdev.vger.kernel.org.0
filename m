Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA876E2ABF
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 21:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbjDNTsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 15:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjDNTsq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 15:48:46 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10C949F7
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 12:48:45 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id q2so24253428pll.7
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 12:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1681501725; x=1684093725;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uoWUY9ip/LaJa7X42u1pNj9lNdrtUK8ewcgVfkjbBnA=;
        b=aPSXyoK+BiPc5iWeaJ9ZN60eJSKN7Qd+BEsL+Svp7aAWTE1kQ6l7BQxKjoFcLsA52M
         q35h2IdMw2jLRtSTMhxfEy3Gl4D3D5B6xtEvMdamdOf+zMxW3o2hd0pEip/ooGbC15hn
         M9eXsXJc96/4YomC/5oHpXKtILGxiR89AlS0ncqkDUBCfTOPcFV0E4bydnMnDUAeo4up
         T1h1zKEnLSV6dFrxQgS2c6gPQgPF9FImepJObNIEG9Yx/F50nbxuYDYPH9wq2pdMDcRU
         1cf6O1uW/Tcr4IxCiUW9/Sk2HbGz1UNgaQ63x5JcIO9U9dUiZKkXKTqZXVZvrXVQKsZz
         Tuqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681501725; x=1684093725;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uoWUY9ip/LaJa7X42u1pNj9lNdrtUK8ewcgVfkjbBnA=;
        b=OaW1vYaiIR/gHrBw+KF4UGZSliNiCOS2F7BqeD1YSkJNFZzLjc3zvNldzMlc345A+1
         27ZDX0VazKj6tbNrPcQt3Dd8HT+hE9p/5wfdGIo8gXMVJVPTQkWNPX6hiqHu7tN9Q8bE
         AWJDKQBUiA56m+NwIjeyNdXSX8azHvJUuKMrlbTADfiKWPsFt860qigEecWE1ingbcQt
         CQRbvAQ2GmUH5NKH7aBIBkHVUidWNfLrnnEQl7oVpLnww6Qxrepv5ebAFt1SrhJrOz1g
         o0E6ZsWw/fHNPnXEX6qOWM1vllfp3CrLPjr8SKItDI9fm1HOoG0NGMTW69lQC5XJE+P3
         xI+g==
X-Gm-Message-State: AAQBX9e9hU3mYq4iF6TdHxUqxBg0yb6Vok0dZuChddraTB90GIBPvWK5
        4GOXa8dFIfYPlQjd6VSkZd2AlihO1cvZr0D7c1kZ6g==
X-Google-Smtp-Source: AKy350bnRK7zotqMFtRvb1PQ8mSN3LOxCOnjhZlMAjac717RnQ4ei+bv3KlFpnybvBnyDeTABB3Xig==
X-Received: by 2002:a05:6a20:a814:b0:ea:fa7f:f879 with SMTP id cb20-20020a056a20a81400b000eafa7ff879mr6994862pzb.42.1681501724840;
        Fri, 14 Apr 2023 12:48:44 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id p24-20020aa78618000000b00625616f59a1sm287130pfn.73.2023.04.14.12.48.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 12:48:44 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Lars Ekman <uablrek@gmail.com>
Subject: [PATCH] iproute_lwtunnel: fix JSON output
Date:   Fri, 14 Apr 2023 12:48:41 -0700
Message-Id: <20230414194841.31030-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The same tag "dst" was being used for both the route destination
and the encap destination. This made it hard for JSON parsers.
Change to put the per-encap information under a nested JSON
object (similar to ip link type info).

Original output
[ {
        "dst": "192.168.11.0/24",
        "encap": "ip6",
        "id": 0,
        "src": "::",
        "dst": "fd00::c0a8:2dd",
        "hoplimit": 0,
        "tc": 0,
        "protocol": "5",
        "scope": "link",
        "flags": [ ]
    } ]

Revised output
[ {
        "dst": "192.168.11.0/24",
        "encap": {
            "encap_type": "ip6",
            "id": 0,
            "src": "::",
            "dst": "fd00::c0a8:2dd",
            "hoplimit": 0,
            "tc": 0
        },
        "protocol": "5",
        "scope": "link",
        "flags": [ ]
    } ]

Reported-by: Lars Ekman <uablrek@gmail.com>
Fixes: 663c3cb23103 ("iproute: implement JSON and color output")
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 ip/iproute_lwtunnel.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/ip/iproute_lwtunnel.c b/ip/iproute_lwtunnel.c
index 8b7f3742b71e..9fcbdeac3e77 100644
--- a/ip/iproute_lwtunnel.c
+++ b/ip/iproute_lwtunnel.c
@@ -840,8 +840,9 @@ void lwt_print_encap(FILE *fp, struct rtattr *encap_type,
 		return;
 
 	et = rta_getattr_u16(encap_type);
-
-	print_string(PRINT_ANY, "encap", " encap %s ", format_encap_type(et));
+	open_json_object("encap");
+	print_string(PRINT_ANY, "encap_type", " encap %s ",
+		     format_encap_type(et));
 
 	switch (et) {
 	case LWTUNNEL_ENCAP_MPLS:
@@ -875,6 +876,7 @@ void lwt_print_encap(FILE *fp, struct rtattr *encap_type,
 		print_encap_xfrm(fp, encap);
 		break;
 	}
+	close_json_object();
 }
 
 static struct ipv6_sr_hdr *parse_srh(char *segbuf, int hmac, bool encap)
-- 
2.39.2


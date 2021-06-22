Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 131213B10CD
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 01:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbhFVXzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 19:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbhFVXzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 19:55:46 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D02C061574
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 16:53:28 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id c16so509522ljh.0
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 16:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XOwr23QmAajHck4frMVJzuIE0aca5Rr8oMRmUsPrSJs=;
        b=A5RHsgrxn5jU2y4uWxNgutrUk+baLeJ6JBP7RT5oGMySNoB2fXbh7V8+pKYH45Ra9P
         8wt1aBbk6fUyALWuZCzprsgxPKPxkPWyDgfl6Zr4aeeQe7qbHtsnBzPCr14e3nc+SwgU
         Rthciuw4PzUGUZTDOzfelnmtFpf8lUT0NkRvMdngf9R9spDcQKEW12AJsWtRalZI+9vI
         ByKt8QomuK6+z1LHTHngBfAYkRRUGR7PkesObI7+FHC6AYdarDGUVlN9yf6MmCSrJB5+
         6caIOIMw7Gsdl8qJ6ceYAghsKiPCOTLFHc0e99mhiYaQe1B3x2Dsd0o/4orLsQEgy8lz
         u7jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XOwr23QmAajHck4frMVJzuIE0aca5Rr8oMRmUsPrSJs=;
        b=OlIU5tUXJf+qZQ/plyAZ2fATCQnomGy9XFGfI3rw9CV1bVrgZPs/A8Ll0QRpew8phO
         cih4/nmAP9cZ8lC7TZjY1Kx/cmSEYWNZ5mybNhIGlV1Cav5tezv0vz2tuagzsBgxA7M1
         Zyq4r/SWeSnzTel3VFbyiXXaRLUqkouhs6wMBQkA9N9Umtw6LH87ln+2v2ciziEtLNLZ
         D83LhmqpbjPci/mTmYUcvsWcLVFkbZPSkrB6nokFEqXosSISbWKdEHb1pWcS2hQPWpmY
         UbEZ+L50bPxA4wyGWNURXf+6RboB2eZ0lHZmzObH1nwljm+6BPZfmKeptG7ruwgNa2p6
         c2Dw==
X-Gm-Message-State: AOAM531MncBMoGCc1hBYNFs0TadQO53H4wbDUuaK4LKb0JzKDbxJ0vpb
        3RnpKreeVtKEYjbeQQiYq2E=
X-Google-Smtp-Source: ABdhPJxpG54nTL5WX7G8URcFQHUwAYwQ/whFH0/CSmxoxtIzs0Gm38Qjn+iZOZ3glggxH2rBOpAyAw==
X-Received: by 2002:a2e:a369:: with SMTP id i9mr4599481ljn.231.1624406007150;
        Tue, 22 Jun 2021 16:53:27 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id y23sm1680092lfg.173.2021.06.22.16.53.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 16:53:26 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH iproute2-next v2 1/2] iplink: add support for parent device
Date:   Wed, 23 Jun 2021 02:52:55 +0300
Message-Id: <20210622235256.25499-2-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210622235256.25499-1-ryazanov.s.a@gmail.com>
References: <20210622235256.25499-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for specifying a parent device (struct device) by its name
during the link creation and printing parent name in the links list.
This option will be used to create WWAN links and possibly by other
device classes that do not have a "natural parent netdev".

Add the parent device bus name printing for links list info
completeness. But do not add a corresponding command line argument, as
we do not have a use case for this attribute.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
Changes since v1:
* shorten the 'parentdevbus' parameter to 'parentbus', as Parav
  suggested and Loic recalled

Changes since RFC:
* add a parent device bus attribute support
* shorten the 'parentdev-name' parameter to just 'parentdev'

 ip/ipaddress.c | 14 ++++++++++++++
 ip/iplink.c    |  6 +++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 06ca7273..85534aaf 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -1242,6 +1242,20 @@ int print_linkinfo(struct nlmsghdr *n, void *arg)
 						   RTA_PAYLOAD(tb[IFLA_PHYS_SWITCH_ID]),
 						   b1, sizeof(b1)));
 		}
+
+		if (tb[IFLA_PARENT_DEV_BUS_NAME]) {
+			print_string(PRINT_ANY,
+				     "parentbus",
+				     "parentbus %s ",
+				     rta_getattr_str(tb[IFLA_PARENT_DEV_BUS_NAME]));
+		}
+
+		if (tb[IFLA_PARENT_DEV_NAME]) {
+			print_string(PRINT_ANY,
+				     "parentdev",
+				     "parentdev %s ",
+				     rta_getattr_str(tb[IFLA_PARENT_DEV_NAME]));
+		}
 	}
 
 	if ((do_link || show_details) && tb[IFLA_IFALIAS]) {
diff --git a/ip/iplink.c b/ip/iplink.c
index faafd7e8..33b7be30 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -63,7 +63,7 @@ void iplink_usage(void)
 {
 	if (iplink_have_newlink()) {
 		fprintf(stderr,
-			"Usage: ip link add [link DEV] [ name ] NAME\n"
+			"Usage: ip link add [link DEV | parentdev NAME] [ name ] NAME\n"
 			"		    [ txqueuelen PACKETS ]\n"
 			"		    [ address LLADDR ]\n"
 			"		    [ broadcast LLADDR ]\n"
@@ -938,6 +938,10 @@ int iplink_parse(int argc, char **argv, struct iplink_req *req, char **type)
 				       *argv);
 			addattr32(&req->n, sizeof(*req),
 				  IFLA_GSO_MAX_SEGS, max_segs);
+		} else if (strcmp(*argv, "parentdev") == 0) {
+			NEXT_ARG();
+			addattr_l(&req->n, sizeof(*req), IFLA_PARENT_DEV_NAME,
+				  *argv, strlen(*argv) + 1);
 		} else {
 			if (matches(*argv, "help") == 0)
 				usage();
-- 
2.26.3


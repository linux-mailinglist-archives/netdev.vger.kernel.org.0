Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6E04399954
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 06:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbhFCEvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 00:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhFCEvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 00:51:53 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651D8C06175F;
        Wed,  2 Jun 2021 21:50:09 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id p17so6087977lfc.6;
        Wed, 02 Jun 2021 21:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fTdsf02HyDf/I+gguBoc3k+gpG0A/WMGol4iK1ZVOZc=;
        b=DLfK+DCaDJmEF4dYS5CQKPrECP6jb1y+ZiBEhRRuerKfnChFMTjpVj24fSQcGDjRjR
         uUeRleW0o+ZNI1GizFu5PKmdxWaqSFSgzwmtXDhXEg1pDV3BZJ/bXLmApFIVDhRDLte5
         iMzJxNmJvxD+6DWwO25vNP+3Kg539DIP749NpajYAcsSbe4iU16Tj95Ap/wbneRahW68
         Q5jkm/We+lkPKCehHWeXMr1BmB7V/fgC5UxBkmy/2GQ6GlP2arGXRMHjKwxr0P1NAO+i
         Put0R5ox5lFtIpLYvkY4lN0OlyakvwykLCUqothg0pcOCeVUnBDH64rp/BvZ+uwIEIlv
         /JcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fTdsf02HyDf/I+gguBoc3k+gpG0A/WMGol4iK1ZVOZc=;
        b=b9cTwqZEjJ3m0Sc8IVwcEyTQOD/7RtNrfSfkDNT4NFD4Z+c7voRGYCJvZjxG0Hn6Ao
         keAO5MvoqjUDdXEXZIfanc54ILY7i2BtbnvCGx+VYZfhugUWLOs7xSoVsMqES4GFNDJM
         kNbFlrFX/wrS7I9fuLk0Dg97gT0FQ+REEDPKG6QdBM4kmmb+8muEpC5OLVxzfLuYzQyY
         Wo7IdOARrQ/0hzSsdDN4+9HgBd2dOej4e1VBTSI2wcD5FSu+u0TPdD7BM2da77IPp/4q
         DwHBwlktNTbcwx1+WTjFXLVWWoIk9soy5Wwuh1lQ7XGkolVBYsL1wcDHI25s//6Gd6MH
         3i1Q==
X-Gm-Message-State: AOAM533UcVzkiEuO6j/NFQB6qMITsbh4rszBqZl9VmE/c7KOtTgg9aI8
        OWOZ5k037H5VNvjER+mKSFA=
X-Google-Smtp-Source: ABdhPJyg23KAcM5+N2uW9j16dVyl5nYDhlMNtIg5cotw10Lw+W6ozJ21KaN+DHANOCgmAODg4JQ60Q==
X-Received: by 2002:a19:4086:: with SMTP id n128mr25173479lfa.464.1622695807834;
        Wed, 02 Jun 2021 21:50:07 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id z2sm191328lfe.229.2021.06.02.21.50.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 21:50:07 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>
Cc:     M Chetan Kumar <m.chetan.kumar@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [RFC 5/6 iproute2] iplink: add support for parent device
Date:   Thu,  3 Jun 2021 07:49:53 +0300
Message-Id: <20210603044954.8091-6-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210603044954.8091-1-ryazanov.s.a@gmail.com>
References: <20210603044954.8091-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for specifying a parent device (struct device) by its name
during the link creation and printing parent name in the links list.
This option will be used to create WWAN links and possibly by other
device classes that do not have a "natural parent netdev".

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
 ip/ipaddress.c | 7 +++++++
 ip/iplink.c    | 6 +++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index cfb24f5c..98f25a5b 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -1176,6 +1176,13 @@ int print_linkinfo(struct nlmsghdr *n, void *arg)
 						   RTA_PAYLOAD(tb[IFLA_PHYS_SWITCH_ID]),
 						   b1, sizeof(b1)));
 		}
+
+		if (tb[IFLA_PARENT_DEV_NAME]) {
+			print_string(PRINT_ANY,
+				     "parentdev_name",
+				     "parentdev-name %s ",
+				     rta_getattr_str(tb[IFLA_PARENT_DEV_NAME]));
+		}
 	}
 
 	if ((do_link || show_details) && tb[IFLA_IFALIAS]) {
diff --git a/ip/iplink.c b/ip/iplink.c
index faafd7e8..190ce7d9 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -63,7 +63,7 @@ void iplink_usage(void)
 {
 	if (iplink_have_newlink()) {
 		fprintf(stderr,
-			"Usage: ip link add [link DEV] [ name ] NAME\n"
+			"Usage: ip link add [link DEV | parentdev-name NAME] [ name ] NAME\n"
 			"		    [ txqueuelen PACKETS ]\n"
 			"		    [ address LLADDR ]\n"
 			"		    [ broadcast LLADDR ]\n"
@@ -938,6 +938,10 @@ int iplink_parse(int argc, char **argv, struct iplink_req *req, char **type)
 				       *argv);
 			addattr32(&req->n, sizeof(*req),
 				  IFLA_GSO_MAX_SEGS, max_segs);
+		} else if (strcmp(*argv, "parentdev-name") == 0) {
+			NEXT_ARG();
+			addattr_l(&req->n, sizeof(*req), IFLA_PARENT_DEV_NAME,
+				  *argv, strlen(*argv) + 1);
 		} else {
 			if (matches(*argv, "help") == 0)
 				usage();
-- 
2.26.3


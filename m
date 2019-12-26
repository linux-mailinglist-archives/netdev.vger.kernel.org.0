Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2C612AD1C
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 15:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbfLZOoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 09:44:34 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44785 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbfLZOoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 09:44:34 -0500
Received: by mail-wr1-f67.google.com with SMTP id q10so23798970wrm.11
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 06:44:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CJYgwGjUYVSZ5AlUbKF2+X+s/KC8qWwYXSgTlzJImi0=;
        b=Sj+Ytbkx0I655tuHw8YNoGxKLQlXpS3KC1ZZfhDWkDfigdmZe9/4AlNrBSbk72psaM
         Qs+zWIIfd+emYgsD6nxUwFnF5lifcC+oh5fC56ld7a8bvl+Iqf69ab5KQ+0pB4I+XJTr
         trlP8LmGhyCcQoQI2Xuop/J43gQQSLVULGELg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CJYgwGjUYVSZ5AlUbKF2+X+s/KC8qWwYXSgTlzJImi0=;
        b=Z/teWU6bJ0lt8AW5EfmaLV2Wjg62Hd0uCp3jpVJrioFXeud+a1rQI/xWCxY5amf84l
         Ip+OfmbUpQGPZGDIOyHMC+SdFknMEmYHyR0dlmzgzv5Mc3230jMB+/JyWs540JsFQb8K
         0rYwMZNa+b/bw6N73Fe4K3sYviZ2rD9nd/NVTU2bc87Ur1L4/zQrLvAVGtHBmMCwGX63
         hCsb0CXewHCUHt1LnI5gccjECkwqw8Ug2uXtPR4OwJNGGCkRCRAFBmQnnw6xwUtGI4Sn
         KHM4u7QzrZ2XECX8OofeoVkQB54tPiBmxdRbzQ4LshqgOqVXB02WcH+8MgKOEdBLO7J5
         kJ7Q==
X-Gm-Message-State: APjAAAV9TNu+odjEk1jmSbcLeIRrd+aGylfcQQvJlMRg9AxIDgSFG/Zi
        KGSo6u08AaH/I37Avsl+kj9e8EipB1L1
X-Google-Smtp-Source: APXvYqzXDQbz6oc4tcurP/N+o9Fl+Oc4qKI7AwUl5Edb4pivA4zaMbZmjdXbiFF9+eXEAksBApJiWw==
X-Received: by 2002:adf:f789:: with SMTP id q9mr46970671wrp.103.1577371471638;
        Thu, 26 Dec 2019 06:44:31 -0800 (PST)
Received: from localhost.localdomain (82-64-1-127.subs.proxad.net. [82.64.1.127])
        by smtp.googlemail.com with ESMTPSA id r62sm8911106wma.32.2019.12.26.06.44.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 26 Dec 2019 06:44:30 -0800 (PST)
From:   Julien Fortin <julien@cumulusnetworks.com>
X-Google-Original-From: Julien Fortin
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, dsahern@gmail.com,
        Julien Fortin <julien@cumulusnetworks.com>
Subject: [PATCH iproute2-next] ip: ipneigh: json: print ndm_flags as boolean attributes
Date:   Thu, 26 Dec 2019 15:44:15 +0100
Message-Id: <20191226144415.50682-1-julien@cumulusnetworks.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julien Fortin <julien@cumulusnetworks.com>

Today the following attributes are printed as json "null" attributes
NTF_ROUTER
NTF_PROXY
NTF_EXT_LEARNED
NTF_OFFLOADED

$ ip -j neigh show
[
  {
    "dst": "10.0.2.2",
    "dev": "enp0s3",
    "lladdr": "52:54:00:12:35:02",
    "router": null,
    "proxy": null,
    "extern_learn": null,
    "offload": null,
    "state": [
      "REACHABLE"
    ]
  }
]

The goal of this patch is to replace those null attributes with booleans

$ ip -j neigh show
[
  {
    "dst": "10.0.2.2",
    "dev": "enp0s3",
    "lladdr": "52:54:00:12:35:02",
    "router": true,
    "proxy": true,
    "extern_learn": true,
    "offload": true,
    "state": [
      "REACHABLE"
    ]
  }
]

Signed-off-by: Julien Fortin <julien@cumulusnetworks.com>
---
 ip/ipneigh.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/ip/ipneigh.c b/ip/ipneigh.c
index 678b4034..b1f212f4 100644
--- a/ip/ipneigh.c
+++ b/ip/ipneigh.c
@@ -380,16 +380,16 @@ int print_neigh(struct nlmsghdr *n, void *arg)
 	}
 
 	if (r->ndm_flags & NTF_ROUTER)
-		print_null(PRINT_ANY, "router", " %s", "router");
+		print_bool(PRINT_ANY, "router", " router", true);
 
 	if (r->ndm_flags & NTF_PROXY)
-		print_null(PRINT_ANY, "proxy", " %s", "proxy");
+		print_bool(PRINT_ANY, "proxy", " proxy", true);
 
 	if (r->ndm_flags & NTF_EXT_LEARNED)
-		print_null(PRINT_ANY, "extern_learn", " %s ", "extern_learn");
+		print_bool(PRINT_ANY, "extern_learn", " extern_learn ", true);
 
 	if (r->ndm_flags & NTF_OFFLOADED)
-		print_null(PRINT_ANY, "offload", " %s", "offload");
+		print_bool(PRINT_ANY, "offload", " offload", true);
 
 	if (show_stats) {
 		if (tb[NDA_CACHEINFO])
-- 
2.23.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B913AFA31
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 02:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbhFVAef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 20:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbhFVAec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 20:34:32 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5286BC061756
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 17:32:16 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id f13so526350ljp.10
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 17:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BA9HGIuc8Qj6/+qoR09OFbEmyF+uxHI8WojZtzgQ3fQ=;
        b=j6N2riJsV/Jg2O/faRQLc9WhNhoacbI0y7DEXrZ0DkuwsD4ZKW2gAiPzrTbV8OMVTw
         X22CDHVGMJWoZZEmkEDCRfdpVuzKgF0cuKOVgUmzgwX+xVFnfLpZfH2Gv5o7DM7NpZl8
         ckB3nrPhgCRhqCLm7kSqLSUoS/TP8VbLle701CeSWM9a0ywV6HWMfa5DviC46DZqL7lc
         QgFB9Ze03qRqqVYqnAqSnnzq6+cCslQL230UsIKufsDoHKjzO1vaF2PWPuUDmyklDqnU
         xyhbuyaEZwPsIvVp4tLUEFAAw27qw/oOEsVVqp2/27TPIUgv15XQlP8FXoJwg+edA+F0
         Jj7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BA9HGIuc8Qj6/+qoR09OFbEmyF+uxHI8WojZtzgQ3fQ=;
        b=XzZdp1FS+u3fl8duwcGqQNjKVQoP3hA2ENZc95ylsDkfMHVT0+PNmEDyFS1Jsq4sCH
         vc5C99tFYp+GucNidMEVjiFCeqknUZ12dowa+k6V6+AfMoxuD17qIW2bX4aPj7S5do+x
         XTMKv/g/+Ll1X6CWs1mcPkJrWjE45+W62InVgf45jSsOTxoXMGrrbOQKNsVg5PRKhWV5
         +BCZkbZn8cxGB73T6s4xTt/1dSoFbwG0MFlttf3my1DmozOunmWdgJLjkdVKyqCrYc8K
         +2gdN2VOAtIDYt+p1I0l9/9kSijL8C5LWAuiF4mN8qEBB1IGl7zUheWu4CmilhG4s67S
         xG3w==
X-Gm-Message-State: AOAM532mcLVzTZ/xiYVR6xMLzYgO136CCQi44+Ny4wcNjW/K5q4hFMaV
        HUlusL+jgowvkaqtEi6Ixdo=
X-Google-Smtp-Source: ABdhPJxHEdGF53SD0pH1caTnWVj3CNSAkzzqzd3+8J7QqXJN6/aIKQAkfGpgmbKCiim0FpTXFRhnGA==
X-Received: by 2002:a2e:8946:: with SMTP id b6mr698540ljk.99.1624321934710;
        Mon, 21 Jun 2021 17:32:14 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id br36sm404767lfb.296.2021.06.21.17.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 17:32:14 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH iproute2-next 1/2] iplink: add support for parent device
Date:   Tue, 22 Jun 2021 03:32:09 +0300
Message-Id: <20210622003210.22765-2-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210622003210.22765-1-ryazanov.s.a@gmail.com>
References: <20210622003210.22765-1-ryazanov.s.a@gmail.com>
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
 ip/ipaddress.c | 14 ++++++++++++++
 ip/iplink.c    |  6 +++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 06ca7273..7dc38ff1 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -1242,6 +1242,20 @@ int print_linkinfo(struct nlmsghdr *n, void *arg)
 						   RTA_PAYLOAD(tb[IFLA_PHYS_SWITCH_ID]),
 						   b1, sizeof(b1)));
 		}
+
+		if (tb[IFLA_PARENT_DEV_BUS_NAME]) {
+			print_string(PRINT_ANY,
+				     "parentdevbus",
+				     "parentdevbus %s ",
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


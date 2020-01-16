Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5235E13DF59
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 16:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgAPP5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 10:57:11 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36588 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbgAPP5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 10:57:10 -0500
Received: by mail-pf1-f195.google.com with SMTP id x184so10416003pfb.3
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 07:57:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ouL8lzRN8GhOcp6GmpVw/Tc2buDOfntWdiQXXejBEEw=;
        b=gXwGoteq0lCFQE3MxpDi1yz4WHIIB2ZMQFp4Sgn1WWdXe52GcscUbyeQLifEpX8mo2
         dnTosS4KgiaTjudhsSWVKuwV03JMXDQg/I7qOMuM87kDtxkcMB5vlmKrSw9g2MDwaiap
         ALHfAjvu2AadCi1dd0+P75V8blwRj2I+60tbf0mXwViidUM1YotThW0jxHHEjmA1jSsn
         na5xj3CN5sySqX5NqVMgWADKs4kbcd23MhCZ0fvqUBTYDaVXlQfjeglbTbJvBfO5cUz3
         9N01tciYxZn9ttlCC0+cqCbhlotVhvpLfGIvtsNMq8pennrVlDO0VKGnDia33N9tY0or
         /AIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ouL8lzRN8GhOcp6GmpVw/Tc2buDOfntWdiQXXejBEEw=;
        b=nB9ElhWoYUR96lw4cA+YYEO/pSuUEM5V8LWVc7UiX/uQYX8Y0VhNqEHXTbMaDVy6GB
         7T2Z7RlitNL5E82kFafVv5jnSgw7opzSj2SkXAwqHm0mAyZZ68p5HnCxLMaivkTWA32m
         6TN7Ry6R35Ddw3KuIHioG934N/3ZAWn6tTtqttCSMdqHs9IYknGp/SWmw6z0mw1X8yQx
         Ze/gs8ummqd+hvmdG5shJkbzw6xqv0XhFHRXTBZq2zJ1VmT8finPFoaL+DlS40ByL10P
         xJZ7OQxIqkiEFmq2B6m/S6BhV6ozZx5JMePUPSTl8mb8S03o7aw0pqcyBIDdOxzbarbD
         eHJw==
X-Gm-Message-State: APjAAAXM3UkKWL3AqWjyA0l02Va0nZ5U/E4JsNcOgWmB7k//h5no83QY
        0WrkpI4rGBwoGIEAieSlcqAb0a6h
X-Google-Smtp-Source: APXvYqxcWbHYY5Xy1MQK1OYFgsQRrfBIssRzomLJLPXNgYPI7cXHPsfxapdzVwsp2sX6TY1DhNKqGQ==
X-Received: by 2002:a63:dd58:: with SMTP id g24mr38976774pgj.102.1579190229496;
        Thu, 16 Jan 2020 07:57:09 -0800 (PST)
Received: from localhost.localdomain ([103.89.235.106])
        by smtp.gmail.com with ESMTPSA id d2sm4189994pjv.18.2020.01.16.07.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 07:57:08 -0800 (PST)
From:   Leslie Monis <lesliemonis@gmail.com>
To:     Linux NetDev <netdev@vger.kernel.org>
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH] tc: parse attributes with NLA_F_NESTED flag
Date:   Thu, 16 Jan 2020 21:27:01 +0530
Message-Id: <20200116155701.6636-1-lesliemonis@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel now requires all new nested attributes to set the
NLA_F_NESTED flag. Enable tc {qdisc,class,filter} to parse
attributes that have the NLA_F_NESTED flag set.

Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
---
 tc/tc_class.c  | 6 +++---
 tc/tc_filter.c | 2 +-
 tc/tc_qdisc.c  | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tc/tc_class.c b/tc/tc_class.c
index c7e3cfdf..39bea971 100644
--- a/tc/tc_class.c
+++ b/tc/tc_class.c
@@ -246,8 +246,8 @@ static void graph_cls_show(FILE *fp, char *buf, struct hlist_head *root_list,
 			 "+---(%s)", cls_id_str);
 		strcat(buf, str);
 
-		parse_rtattr(tb, TCA_MAX, (struct rtattr *)cls->data,
-				cls->data_len);
+		parse_rtattr_flags(tb, TCA_MAX, (struct rtattr *)cls->data,
+				   cls->data_len, NLA_F_NESTED);
 
 		if (tb[TCA_KIND] == NULL) {
 			strcat(buf, " [unknown qdisc kind] ");
@@ -327,7 +327,7 @@ int print_class(struct nlmsghdr *n, void *arg)
 	if (filter_classid && t->tcm_handle != filter_classid)
 		return 0;
 
-	parse_rtattr(tb, TCA_MAX, TCA_RTA(t), len);
+	parse_rtattr_flags(tb, TCA_MAX, TCA_RTA(t), len, NLA_F_NESTED);
 
 	if (tb[TCA_KIND] == NULL) {
 		fprintf(stderr, "print_class: NULL kind\n");
diff --git a/tc/tc_filter.c b/tc/tc_filter.c
index dcddca77..c591a19f 100644
--- a/tc/tc_filter.c
+++ b/tc/tc_filter.c
@@ -267,7 +267,7 @@ int print_filter(struct nlmsghdr *n, void *arg)
 		return -1;
 	}
 
-	parse_rtattr(tb, TCA_MAX, TCA_RTA(t), len);
+	parse_rtattr_flags(tb, TCA_MAX, TCA_RTA(t), len, NLA_F_NESTED);
 
 	if (tb[TCA_KIND] == NULL && (n->nlmsg_type == RTM_NEWTFILTER ||
 				     n->nlmsg_type == RTM_GETTFILTER ||
diff --git a/tc/tc_qdisc.c b/tc/tc_qdisc.c
index 75a14672..181fe2f0 100644
--- a/tc/tc_qdisc.c
+++ b/tc/tc_qdisc.c
@@ -235,7 +235,7 @@ int print_qdisc(struct nlmsghdr *n, void *arg)
 	if (filter_ifindex && filter_ifindex != t->tcm_ifindex)
 		return 0;
 
-	parse_rtattr(tb, TCA_MAX, TCA_RTA(t), len);
+	parse_rtattr_flags(tb, TCA_MAX, TCA_RTA(t), len, NLA_F_NESTED);
 
 	if (tb[TCA_KIND] == NULL) {
 		fprintf(stderr, "print_qdisc: NULL kind\n");
@@ -461,7 +461,7 @@ static int tc_qdisc_block_exists_cb(struct nlmsghdr *n, void *arg)
 	if (len < 0)
 		return -1;
 
-	parse_rtattr(tb, TCA_MAX, TCA_RTA(t), len);
+	parse_rtattr_flags(tb, TCA_MAX, TCA_RTA(t), len, NLA_F_NESTED);
 
 	if (tb[TCA_KIND] == NULL)
 		return -1;
-- 
2.17.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD60423479
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 01:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237028AbhJEXa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 19:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236873AbhJEXa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 19:30:57 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF161C061749
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 16:29:06 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id j5-20020a170902c3c500b0013ebfb7f87cso434023plj.0
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 16:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=GwSHAgEnNcPVmt5R4/DzR39GbxNy7TwCC7f2tVXtjOA=;
        b=kD7PhOy6ETrZpDIPC3z3v9p27XuXHw7uQ/gLLq0o7dotZj3CWEthBZpc4o4aB3mu25
         URNr0huVCiDg8XgA9RG603hyRhzF7wUoACIiP04ofMtYU8NlW+kWBqtQCHHBZ8/+9xSd
         nzSH57vayJo+XDyBtaAF0l9EKQ2KR1kMzX9LD+/PretiCEa3glfd8JJV1HGw31tf7ICq
         sG4BGJ0G/oCXda+rlT6KSgmJl8Vhsui+hWWzFq6i+DGfXny2fySaIihL4uTN2XY7WhYa
         WIfDDHG6Wlj0MeyYKMPpmozN8QTXvMUkHsxUsr13kkQxUGkrNqn8/UXQy9l3znOI3AxJ
         XJUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GwSHAgEnNcPVmt5R4/DzR39GbxNy7TwCC7f2tVXtjOA=;
        b=vvq+LiOaNGqKqohgaxjnsIqqTmRmMZCFbguI7ejyn+okJZm4G1oaQhkfZImOA0rRqM
         4DrJppRUftSUa1oEvKrLpLuUalgXXD4fsRXfmwqssAxFbmFCK+HviQa4JRzzA8bUHsoj
         BUo6YkXt8dbwDjnZyrqloMmi1DRXdRsagBizoV0/jLvmLqk8W93hdaJvM7jp62kg+Kd0
         s7ZuxfDJdGnH4ia7y3vOlLSrFY+qEwp4zshUeWzgJaVNMVn9IhNdP4a6xNNV+G3q8Ns/
         ir+DoMFC+82X68wUK14OV4z1sMHtYGROdAroPg9QFDDRRP6hkcoZHyyyctrziOCSJUVb
         EouQ==
X-Gm-Message-State: AOAM533fgyprTQPJb1n3OkGSHyYBsfbIjiyG8+gMDN2axxt6GH8zp/Qx
        ysEb08CAHTxpCp8ulML6p71n6QVjknddbehdzlX2apP6+10V0s2IpS6hjh0ewIoJapTBfZ/En5U
        N7N52HvWC6Q+nb2lzWcBPHKI+qfrQ4l9hnZ1pYUocPc1gsOtWLkn2VPTymJuzYHxVQTs=
X-Google-Smtp-Source: ABdhPJwz8G7rOz3cELxyvpsKX1Pwww5CYH8Ct+RX7l/LvHrL0YijID8IMFQT6GR35wrz482bxCSRB8VafdhbEw==
X-Received: from jeroendb.sea.corp.google.com ([2620:15c:100:202:6a19:24ee:a05:add5])
 (user=jeroendb job=sendgmr) by 2002:aa7:9047:0:b0:44b:e142:8b0d with SMTP id
 n7-20020aa79047000000b0044be1428b0dmr18664635pfo.45.1633476546101; Tue, 05
 Oct 2021 16:29:06 -0700 (PDT)
Date:   Tue,  5 Oct 2021 16:28:23 -0700
In-Reply-To: <20211005232823.1285684-1-jeroendb@google.com>
Message-Id: <20211005232823.1285684-3-jeroendb@google.com>
Mime-Version: 1.0
References: <20211005232823.1285684-1-jeroendb@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH net 3/3] gve: Properly handle errors in gve_assign_qpl
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Catherine Sullivan <csully@google.com>,
        Jeroen de Borst <jeroendb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Catherine Sullivan <csully@google.com>

Ignored errors would result in crash.

Fixes: ede3fcf5ec67f ("gve: Add support for raw addressing to the rx path")

Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: Jeroen de Borst <jeroendb@google.com>
---
 drivers/net/ethernet/google/gve/gve_rx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index bb8261368250..94941d4e4744 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -104,8 +104,14 @@ static int gve_prefill_rx_pages(struct gve_rx_ring *rx)
 	if (!rx->data.page_info)
 		return -ENOMEM;
 
-	if (!rx->data.raw_addressing)
+	if (!rx->data.raw_addressing) {
 		rx->data.qpl = gve_assign_rx_qpl(priv);
+		if (!rx->data.qpl) {
+			kvfree(rx->data.page_info);
+			rx->data.page_info = NULL;
+			return -ENOMEM;
+		}
+	}
 	for (i = 0; i < slots; i++) {
 		if (!rx->data.raw_addressing) {
 			struct page *page = rx->data.qpl->pages[i];
-- 
2.33.0.800.g4c38ced690-goog


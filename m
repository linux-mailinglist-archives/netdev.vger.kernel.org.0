Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 880AF1B93EA
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 22:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgDZUZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 16:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726375AbgDZUZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 16:25:11 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32ADAC061A10
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 13:25:11 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id t16so6101652plo.7
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 13:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FSQ/OXSBy4O7NEVG24htaQyaXEGfdhXxBs93cQNLCxM=;
        b=gK2L4zm2Y5PPEfsP6DXXgeVDUdPxJCe0taDTLfs/kaQrw66XjNueSKa100Z0csbio0
         xo5xeg/Z4oierhsfNEMJBoJ8jfl4oY8ixs/QgMAuI7/QsT0HImEh+CYbpUwQ04hrB0eC
         gS0ml2RV3+kU9bXkBs7tSChVxK7EIsTSkOSow=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FSQ/OXSBy4O7NEVG24htaQyaXEGfdhXxBs93cQNLCxM=;
        b=DMchalZno/knoNX8bwj6QMpZo9fyFDyKgjBQ9SNRBWqzxoBYrpBJhG8Vq+GJCdnU+T
         +rbjVmXlrwkUyrBFd6AED9J+wIPn3oH3V7ZjuaqVVxWa5mKi013Kr6zcnQbz2f0zMdBT
         rBl63OaZydoB5aDrs5o1F97mgzIHxm2KkTv2iiWhz3w5tO9V45fDTPgeUoIFL78dsB8o
         BUIPWWT8pZra6l8lV4XF47IS0j6Gn5EZPcxI5kVP5aqx9d2YL4H4nzHlNzABqKAy0g6a
         GAPfwXANB2DaKxz4fZ3fQDWGYmc9zlsSnlLWJFI0siSHBiia5ndGGmP/p/RRhqNCKCCZ
         Be9w==
X-Gm-Message-State: AGi0PuaGzL0hOXG9482NboeDaS8pGcDQVtkAxPxUtNVQyEbY7AE4lmMp
        fA+k1ZUxssTOu/JK4bThNvWyUw==
X-Google-Smtp-Source: APiQypL4x/5J6AhowC0S6BmuXjiXWTf1X9aeV+IGUKnao2ay3XWEB/wETXRHs55zqyd4q5E2gxTB9w==
X-Received: by 2002:a17:902:164:: with SMTP id 91mr9933233plb.207.1587932710743;
        Sun, 26 Apr 2020 13:25:10 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a136sm10862103pfa.99.2020.04.26.13.25.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Apr 2020 13:25:10 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 4/5] bnxt_en: Return error when allocating zero size context memory.
Date:   Sun, 26 Apr 2020 16:24:41 -0400
Message-Id: <1587932682-1212-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1587932682-1212-1-git-send-email-michael.chan@broadcom.com>
References: <1587932682-1212-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bnxt_alloc_ctx_pg_tbls() should return error when the memory size of the
context memory to set up is zero.  By returning success (0), the caller
may proceed normally and may crash later when it tries to set up the
memory.

Fixes: 08fe9d181606 ("bnxt_en: Add Level 2 context memory paging support.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index d8db08e..070c42d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6642,7 +6642,7 @@ static int bnxt_alloc_ctx_pg_tbls(struct bnxt *bp,
 	int rc;
 
 	if (!mem_size)
-		return 0;
+		return -EINVAL;
 
 	ctx_pg->nr_pages = DIV_ROUND_UP(mem_size, BNXT_PAGE_SIZE);
 	if (ctx_pg->nr_pages > MAX_CTX_TOTAL_PAGES) {
-- 
2.5.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E40693420E5
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 16:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbhCSPZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 11:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbhCSPY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 11:24:28 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C53DC061763
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 08:24:27 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id z136so6490872iof.10
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 08:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lrZt1rPIG/1PTEGAYJ/63IjjGn/k/PqO4YrjyvU7aqg=;
        b=Ej5GA0ijTsiI6X+7rlIVpylEJdpykUhABDdvsKDbgOw+DM+5hQrqqZEaSVFy4Kk9SA
         dt9u/sK2vep4GTNtlnPnQ7kyWHiVN9EWZgg+TiTqXIAS0fo08rgc5q/YpkLnVFAa7Hl6
         8Z8Yttc8zCM1Fj4rl8SLBTSGFJO/ic0YlbyVC2r2hP49/rrs6QdT8tS/kAAYyj+6bIeg
         84aUhfBhGA6+CD4032GroxTq4hBqeDb0IoH//nKxU//Lz6plF+w4vGKFtQVuvNi1/QNb
         7nE4NZzkm2sPznufUfzDEnz0Mf6FmfcGyjvbL42RqLuzLkphj6vQdrEjm3+qtowMraRC
         oDdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lrZt1rPIG/1PTEGAYJ/63IjjGn/k/PqO4YrjyvU7aqg=;
        b=PRNZ4Rqc1BHbNQrLnNNOcH6D+EkpJ2WSSs7XqyxIdCR0TzZNeJllSvY+uGSWAFCi2t
         g8I59hL2p0uB8MP1VX3H76OPFb7wdEUSzXWi3yY4mXgLxNUNSRe3FejejpMBohT9Vpt2
         PH3gJzdwxxLwnylk1Jsr8AQ+DHv35krEeF4i+mQwlEA4VeKl78RBBuckTVTUuGPTH9OZ
         b7pRMpFxjwrZdAmrJ0OX5MnUFu7KpJ8HJDgzywsfCwHTRVAnRcOJG1dd/ZQYa6XQWWRH
         0tMN9k+WKupWtXlOlH4bNjkHziYml/WYlYyuHDmz2+uYW/LPqPf45bDxiobMJ5srezto
         VlMg==
X-Gm-Message-State: AOAM531QaDcZEvIOPN7hnkSWQo8ndA1GuJwGIer+9oiOECsRbITnlW9b
        nTfoCXZ26tQfDIcpRdgYqJ9zWw==
X-Google-Smtp-Source: ABdhPJyfZrZary7DYBBuewsmlJYPz1V2u0Ag5r9FrvQ4AyI8Gm0i3RBvVUJdxFfYahMwm4YbOasm9A==
X-Received: by 2002:a05:6602:2110:: with SMTP id x16mr3307225iox.16.1616167467078;
        Fri, 19 Mar 2021 08:24:27 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id b5sm2686887ioq.7.2021.03.19.08.24.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 08:24:26 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/5] net: ipa: fix canary count for SC7180 UC_INFO region
Date:   Fri, 19 Mar 2021 10:24:19 -0500
Message-Id: <20210319152422.1803714-3-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210319152422.1803714-1-elder@linaro.org>
References: <20210319152422.1803714-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There should be no canary values written before the beginning of the
UC_INFO memory region.  This was correct for SDM845, but somehow was
committed with the wrong value for SC7180.

This bug seems to cause no harm, so we'll just correct it without
back-porting.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_data-sc7180.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_data-sc7180.c b/drivers/net/ipa/ipa_data-sc7180.c
index 01681be402262..434869508a215 100644
--- a/drivers/net/ipa/ipa_data-sc7180.c
+++ b/drivers/net/ipa/ipa_data-sc7180.c
@@ -206,7 +206,7 @@ static const struct ipa_mem ipa_mem_local_data[] = {
 	[IPA_MEM_UC_INFO] = {
 		.offset		= 0x0080,
 		.size		= 0x0200,
-		.canary_count	= 2,
+		.canary_count	= 0,
 	},
 	[IPA_MEM_V4_FILTER_HASHED] = {
 		.offset		= 0x0288,
-- 
2.27.0


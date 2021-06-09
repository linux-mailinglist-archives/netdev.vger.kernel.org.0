Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 014263A2029
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 00:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhFIWhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 18:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbhFIWhO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 18:37:14 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9D9C0613A3
        for <netdev@vger.kernel.org>; Wed,  9 Jun 2021 15:35:15 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id h16so15316365ila.6
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 15:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k9I2jKXj/F7lg6Lryp5lxiDkbNlYBHbGPJE5o0sX/HI=;
        b=enyRBi6hcgdDlfUrxsoRQ7fYxmpcaF1aVHd9PlEk89kZdw7Dro52PXd7Ha1xrFUKlr
         L2jA6OBEN8Z4R8eBNhbmua/4Djzc6w0RcyHAHiq3zinm5NWqwiGXJxf43FN/vnaZjuVQ
         lESOzLEdqfr4P2FgHrCimB0tR0AiqPPcirAEwjw7FnKMxB8o/6+F1l9iRppAqZ9x2Hl2
         nn89r9RDpPKWCQ2BbRk1yl2o2+0rDhc2MbPdfeFk8qM6vwIZ3tu5uQb8CxOzYdtsDAgw
         ZQKC9bV/FYf6mG45NEtOyLXjtAX5IGJ2O7seMa9bzwmkAr9GlUqhlFRwusD+cXrIpDUw
         M3rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k9I2jKXj/F7lg6Lryp5lxiDkbNlYBHbGPJE5o0sX/HI=;
        b=CKVcW51JtT9V4E2C7+b8aAkz7GMRR3Yp1+MdMVSnd4JOkIT0KGOZMD7WMAz6OMDsmF
         CgGqmNrvVDW5ui4npBS1wsnVpgT68H3s+zAPgqeykSyrCz7Uu+whm7yA84X/dMOIfFJY
         biAGeg4GnYmshTqFDpYMSq4KTIISoZJC1I3z7pJcv6rZq2lNfJOGHOQ3equFOesj0Fzp
         kLATJijgeShxHZlc91QHKNn7aytcJmjLHJS5WTEsUIODQI39LN0ZE6GLownaO989lWr0
         xV71LTxdMlyaup3YmivOOMaaeW5xz2MDPjsDN0h20UF280Bg0veRNqJem6xS9AcctsNV
         S3/w==
X-Gm-Message-State: AOAM531KjD+kOqjeVTCyNWalkm7pOI3pBwSrM8kH9PXLx73DwqAcKHbj
        UoIe7rIdtaZ3leeexLeSp59rjw==
X-Google-Smtp-Source: ABdhPJxsF1mp8mwpf+caOdEy2hp22SazxSHJ4OyW2gnf9oVWruEdOg3zNHVfcBsOn85t/cmqrolQqw==
X-Received: by 2002:a05:6e02:1a03:: with SMTP id s3mr1457518ild.220.1623278115302;
        Wed, 09 Jun 2021 15:35:15 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id c19sm750165ili.62.2021.06.09.15.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 15:35:15 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 09/11] net: ipa: validate memory regions based on version
Date:   Wed,  9 Jun 2021 17:35:01 -0500
Message-Id: <20210609223503.2649114-10-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210609223503.2649114-1-elder@linaro.org>
References: <20210609223503.2649114-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce ipa_mem_id_valid(), and use it to check defined memory
regions to ensure they are valid for a given version of IPA.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_mem.c | 61 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index 29c626c46abfd..e5ca6a2ac626a 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -99,6 +99,61 @@ int ipa_mem_setup(struct ipa *ipa)
 	return 0;
 }
 
+/* Is the given memory region ID is valid for the current IPA version? */
+static bool ipa_mem_id_valid(struct ipa *ipa, enum ipa_mem_id mem_id)
+{
+	enum ipa_version version = ipa->version;
+
+	switch (mem_id) {
+	case IPA_MEM_UC_SHARED:
+	case IPA_MEM_UC_INFO:
+	case IPA_MEM_V4_FILTER_HASHED:
+	case IPA_MEM_V4_FILTER:
+	case IPA_MEM_V6_FILTER_HASHED:
+	case IPA_MEM_V6_FILTER:
+	case IPA_MEM_V4_ROUTE_HASHED:
+	case IPA_MEM_V4_ROUTE:
+	case IPA_MEM_V6_ROUTE_HASHED:
+	case IPA_MEM_V6_ROUTE:
+	case IPA_MEM_MODEM_HEADER:
+	case IPA_MEM_AP_HEADER:
+	case IPA_MEM_MODEM_PROC_CTX:
+	case IPA_MEM_AP_PROC_CTX:
+	case IPA_MEM_MODEM:
+	case IPA_MEM_UC_EVENT_RING:
+	case IPA_MEM_PDN_CONFIG:
+	case IPA_MEM_STATS_QUOTA_MODEM:
+	case IPA_MEM_STATS_QUOTA_AP:
+	case IPA_MEM_END_MARKER:	/* pseudo region */
+		break;
+
+	case IPA_MEM_STATS_TETHERING:
+	case IPA_MEM_STATS_DROP:
+		if (version < IPA_VERSION_4_0)
+			return false;
+		break;
+
+	case IPA_MEM_STATS_V4_FILTER:
+	case IPA_MEM_STATS_V6_FILTER:
+	case IPA_MEM_STATS_V4_ROUTE:
+	case IPA_MEM_STATS_V6_ROUTE:
+		if (version < IPA_VERSION_4_0 || version > IPA_VERSION_4_2)
+			return false;
+		break;
+
+	case IPA_MEM_NAT_TABLE:
+	case IPA_MEM_STATS_FILTER_ROUTE:
+		if (version < IPA_VERSION_4_5)
+			return false;
+		break;
+
+	default:
+		return false;
+	}
+
+	return true;
+}
+
 /* Must the given memory region be present in the configuration? */
 static bool ipa_mem_id_required(struct ipa *ipa, enum ipa_mem_id mem_id)
 {
@@ -135,6 +190,12 @@ static bool ipa_mem_valid_one(struct ipa *ipa, const struct ipa_mem *mem)
 	enum ipa_mem_id mem_id = mem->id;
 	u16 size_multiple;
 
+	/* Make sure the memory region is valid for this version of IPA */
+	if (!ipa_mem_id_valid(ipa, mem_id)) {
+		dev_err(dev, "region id %u not valid\n", mem_id);
+		return false;
+	}
+
 	/* Other than modem memory, sizes must be a multiple of 8 */
 	size_multiple = mem_id == IPA_MEM_MODEM ? 4 : 8;
 	if (mem->size % size_multiple)
-- 
2.27.0


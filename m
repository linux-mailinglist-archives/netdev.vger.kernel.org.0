Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2F0E3A33FA
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 21:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbhFJT0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 15:26:37 -0400
Received: from mail-io1-f49.google.com ([209.85.166.49]:37409 "EHLO
        mail-io1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbhFJT03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 15:26:29 -0400
Received: by mail-io1-f49.google.com with SMTP id q7so28310844iob.4
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 12:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Mxka3eMJUwTPeteIeRjKaea94F4dngtVdMYl3o+TuPI=;
        b=gXDCAZA6EDXnxIxX1gXSGr4VHMFWQmpb3pzB1qvSa0gYFQos/sSIYeFJ+57pgiznd5
         W1LU6MWZ68XGgo4F1eGLLzm9o2niSYATbQoIfo52ysjA1qGoQtFZqPhKj5DgpOC77ZzQ
         GC77okvraxmQUSK9F5b8AEbZjGoPrVfUhDEyiPGe0R13DfTUbX2xupEuPqu+mSSDifF/
         87YmnySBH0XrMFckc5oJt+Imv/N3nXEeB3yNBhVSt4Aj+OJFCrN2Cv7tH+tUgYb5zBd/
         nxIfOqoysr7C3pZxLslgMvtYkJ/dICF73WqrTW2FnTrZY4O1QCzkaolZepoNUE/9t+U3
         3dnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Mxka3eMJUwTPeteIeRjKaea94F4dngtVdMYl3o+TuPI=;
        b=ea0jmFEL2SsUkGa6EzCT/o+rOPuecJY85C20RKr7zRMtgVvmoR6A4o+x1pSa2TLzHw
         ZydzOhqqTnWHyVb1JKiR7gBDYWed3yhnXqqkvZB73/EYp7nq13IniR2uVg0VmIcBG8Je
         xiIn4yveARFP7crqTTdYIRxoa2PtxbrHvPXtx+m/PQpMe5eM9R8mi/tVPZ2TQno4Md/f
         9G5DN3vvMkN+UXRcV4+VKelPdNQg0fEfPz3kcgoJIwjdR7NyiwP6+x7tH+eE+Ayklftq
         N/lUeY3WGZ46+sYSZiggeUt121ZUMtE6XSY0rj8+rPsm8BedJkjvgCsZ31UnepqFfFsN
         ViqA==
X-Gm-Message-State: AOAM531xkxPPvW83iC/esocGgQH6nanU/bH9XH8YtUZM3c1lFuhMchky
        5+y71JvHQUZjuwRPN7QdAv6eXw==
X-Google-Smtp-Source: ABdhPJy+UB+gleBiI09+8wE1pa81ukzMVKZNLEwSUbMxEBovWNRGgk1I2ngcC/D9EbDZjWEAu3xVUg==
X-Received: by 2002:a02:a318:: with SMTP id q24mr200868jai.100.1623353000832;
        Thu, 10 Jun 2021 12:23:20 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id w21sm2028684iol.52.2021.06.10.12.23.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 12:23:20 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 8/8] net: ipa: don't index mem data array by ID
Date:   Thu, 10 Jun 2021 14:23:08 -0500
Message-Id: <20210610192308.2739540-9-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210610192308.2739540-1-elder@linaro.org>
References: <20210610192308.2739540-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Finally the code handles the IPA memory region array in the
configuration data without assuming it is indexed by region ID.
Get rid of the array index designators where these arrays are
initialized.  As a result, there's no more need to define an
explicitly undefined memory region ID, so get rid of that.

Change ipa_mem_find() so it no longer assumes the ipa->mem[] array
is indexed by memory region ID.  Instead, have it search the array
for the entry having the requested memory ID, and return the address
of the descriptor if found.  Otherwise return NULL.

Stop allowing memory regions to be defined with zero size and zero
canary value.  Check for this condition in ipa_mem_valid_one().
As a result, it is not necessary to check for this case in
ipa_mem_config().

Finally, there is no need for IPA_MEM_UNDEFINED to be defined any
more, so get rid of it.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_data-v3.5.1.c | 30 ++++++++++----------
 drivers/net/ipa/ipa_data-v4.11.c  | 44 ++++++++++++++---------------
 drivers/net/ipa/ipa_data-v4.2.c   | 36 ++++++++++++------------
 drivers/net/ipa/ipa_data-v4.5.c   | 46 +++++++++++++++----------------
 drivers/net/ipa/ipa_data-v4.9.c   | 46 +++++++++++++++----------------
 drivers/net/ipa/ipa_mem.c         | 38 +++++++++++--------------
 drivers/net/ipa/ipa_mem.h         |  1 -
 7 files changed, 117 insertions(+), 124 deletions(-)

diff --git a/drivers/net/ipa/ipa_data-v3.5.1.c b/drivers/net/ipa/ipa_data-v3.5.1.c
index 945d45b72b247..af536ef8c1209 100644
--- a/drivers/net/ipa/ipa_data-v3.5.1.c
+++ b/drivers/net/ipa/ipa_data-v3.5.1.c
@@ -271,91 +271,91 @@ static const struct ipa_resource_data ipa_resource_data = {
 
 /* IPA-resident memory region data for an SoC having IPA v3.5.1 */
 static const struct ipa_mem ipa_mem_local_data[] = {
-	[IPA_MEM_UC_SHARED] = {
+	{
 		.id		= IPA_MEM_UC_SHARED,
 		.offset		= 0x0000,
 		.size		= 0x0080,
 		.canary_count	= 0,
 	},
-	[IPA_MEM_UC_INFO] = {
+	{
 		.id		= IPA_MEM_UC_INFO,
 		.offset		= 0x0080,
 		.size		= 0x0200,
 		.canary_count	= 0,
 	},
-	[IPA_MEM_V4_FILTER_HASHED] = {
+	{
 		.id		= IPA_MEM_V4_FILTER_HASHED,
 		.offset		= 0x0288,
 		.size		= 0x0078,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_V4_FILTER] = {
+	{
 		.id		= IPA_MEM_V4_FILTER,
 		.offset		= 0x0308,
 		.size		= 0x0078,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_V6_FILTER_HASHED] = {
+	{
 		.id		= IPA_MEM_V6_FILTER_HASHED,
 		.offset		= 0x0388,
 		.size		= 0x0078,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_V6_FILTER] = {
+	{
 		.id		= IPA_MEM_V6_FILTER,
 		.offset		= 0x0408,
 		.size		= 0x0078,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_V4_ROUTE_HASHED] = {
+	{
 		.id		= IPA_MEM_V4_ROUTE_HASHED,
 		.offset		= 0x0488,
 		.size		= 0x0078,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_V4_ROUTE] = {
+	{
 		.id		= IPA_MEM_V4_ROUTE,
 		.offset		= 0x0508,
 		.size		= 0x0078,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_V6_ROUTE_HASHED] = {
+	{
 		.id		= IPA_MEM_V6_ROUTE_HASHED,
 		.offset		= 0x0588,
 		.size		= 0x0078,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_V6_ROUTE] = {
+	{
 		.id		= IPA_MEM_V6_ROUTE,
 		.offset		= 0x0608,
 		.size		= 0x0078,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_MODEM_HEADER] = {
+	{
 		.id		= IPA_MEM_MODEM_HEADER,
 		.offset		= 0x0688,
 		.size		= 0x0140,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_MODEM_PROC_CTX] = {
+	{
 		.id		= IPA_MEM_MODEM_PROC_CTX,
 		.offset		= 0x07d0,
 		.size		= 0x0200,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_AP_PROC_CTX] = {
+	{
 		.id		= IPA_MEM_AP_PROC_CTX,
 		.offset		= 0x09d0,
 		.size		= 0x0200,
 		.canary_count	= 0,
 	},
-	[IPA_MEM_MODEM] = {
+	{
 		.id		= IPA_MEM_MODEM,
 		.offset		= 0x0bd8,
 		.size		= 0x1024,
 		.canary_count	= 0,
 	},
-	[IPA_MEM_UC_EVENT_RING] = {
+	{
 		.id		= IPA_MEM_UC_EVENT_RING,
 		.offset		= 0x1c00,
 		.size		= 0x0400,
diff --git a/drivers/net/ipa/ipa_data-v4.11.c b/drivers/net/ipa/ipa_data-v4.11.c
index 2ff3fcf4e21fa..9353efbd504fb 100644
--- a/drivers/net/ipa/ipa_data-v4.11.c
+++ b/drivers/net/ipa/ipa_data-v4.11.c
@@ -220,133 +220,133 @@ static const struct ipa_resource_data ipa_resource_data = {
 
 /* IPA-resident memory region data for an SoC having IPA v4.11 */
 static const struct ipa_mem ipa_mem_local_data[] = {
-	[IPA_MEM_UC_SHARED] = {
+	{
 		.id		= IPA_MEM_UC_SHARED,
 		.offset		= 0x0000,
 		.size		= 0x0080,
 		.canary_count	= 0,
 	},
-	[IPA_MEM_UC_INFO] = {
+	{
 		.id		= IPA_MEM_UC_INFO,
 		.offset		= 0x0080,
 		.size		= 0x0200,
 		.canary_count	= 0,
 	},
-	[IPA_MEM_V4_FILTER_HASHED] = {
+	{
 		.id		= IPA_MEM_V4_FILTER_HASHED,
 		.offset		= 0x0288,
 		.size		= 0x0078,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_V4_FILTER] = {
+	{
 		.id		= IPA_MEM_V4_FILTER,
 		.offset		= 0x0308,
 		.size		= 0x0078,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_V6_FILTER_HASHED] = {
+	{
 		.id		= IPA_MEM_V6_FILTER_HASHED,
 		.offset		= 0x0388,
 		.size		= 0x0078,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_V6_FILTER] = {
+	{
 		.id		= IPA_MEM_V6_FILTER,
 		.offset		= 0x0408,
 		.size		= 0x0078,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_V4_ROUTE_HASHED] = {
+	{
 		.id		= IPA_MEM_V4_ROUTE_HASHED,
 		.offset		= 0x0488,
 		.size		= 0x0078,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_V4_ROUTE] = {
+	{
 		.id		= IPA_MEM_V4_ROUTE,
 		.offset		= 0x0508,
 		.size		= 0x0078,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_V6_ROUTE_HASHED] = {
+	{
 		.id		= IPA_MEM_V6_ROUTE_HASHED,
 		.offset		= 0x0588,
 		.size		= 0x0078,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_V6_ROUTE] = {
+	{
 		.id		= IPA_MEM_V6_ROUTE,
 		.offset		= 0x0608,
 		.size		= 0x0078,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_MODEM_HEADER] = {
+	{
 		.id		= IPA_MEM_MODEM_HEADER,
 		.offset		= 0x0688,
 		.size		= 0x0240,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_AP_HEADER] = {
+	{
 		.id		= IPA_MEM_AP_HEADER,
 		.offset		= 0x08c8,
 		.size		= 0x0200,
 		.canary_count	= 0,
 	},
-	[IPA_MEM_MODEM_PROC_CTX] = {
+	{
 		.id		= IPA_MEM_MODEM_PROC_CTX,
 		.offset		= 0x0ad0,
 		.size		= 0x0200,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_AP_PROC_CTX] = {
+	{
 		.id		= IPA_MEM_AP_PROC_CTX,
 		.offset		= 0x0cd0,
 		.size		= 0x0200,
 		.canary_count	= 0,
 	},
-	[IPA_MEM_NAT_TABLE] = {
+	{
 		.id		= IPA_MEM_NAT_TABLE,
 		.offset		= 0x0ee0,
 		.size		= 0x0d00,
 		.canary_count	= 4,
 	},
-	[IPA_MEM_PDN_CONFIG] = {
+	{
 		.id		= IPA_MEM_PDN_CONFIG,
 		.offset		= 0x1be8,
 		.size		= 0x0050,
 		.canary_count	= 0,
 	},
-	[IPA_MEM_STATS_QUOTA_MODEM] = {
+	{
 		.id		= IPA_MEM_STATS_QUOTA_MODEM,
 		.offset		= 0x1c40,
 		.size		= 0x0030,
 		.canary_count	= 4,
 	},
-	[IPA_MEM_STATS_QUOTA_AP] = {
+	{
 		.id		= IPA_MEM_STATS_QUOTA_AP,
 		.offset		= 0x1c70,
 		.size		= 0x0048,
 		.canary_count	= 0,
 	},
-	[IPA_MEM_STATS_TETHERING] = {
+	{
 		.id		= IPA_MEM_STATS_TETHERING,
 		.offset		= 0x1cb8,
 		.size		= 0x0238,
 		.canary_count	= 0,
 	},
-	[IPA_MEM_STATS_DROP] = {
+	{
 		.id		= IPA_MEM_STATS_DROP,
 		.offset		= 0x1ef0,
 		.size		= 0x0020,
 		.canary_count	= 0,
 	},
-	[IPA_MEM_MODEM] = {
+	{
 		.id		= IPA_MEM_MODEM,
 		.offset		= 0x1f18,
 		.size		= 0x100c,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_END_MARKER] = {
+	{
 		.id		= IPA_MEM_END_MARKER,
 		.offset		= 0x3000,
 		.size		= 0x0000,
diff --git a/drivers/net/ipa/ipa_data-v4.2.c b/drivers/net/ipa/ipa_data-v4.2.c
index f06eb07a7895d..3b09b7baa95f4 100644
--- a/drivers/net/ipa/ipa_data-v4.2.c
+++ b/drivers/net/ipa/ipa_data-v4.2.c
@@ -219,109 +219,109 @@ static const struct ipa_resource_data ipa_resource_data = {
 
 /* IPA-resident memory region data for an SoC having IPA v4.2 */
 static const struct ipa_mem ipa_mem_local_data[] = {
-	[IPA_MEM_UC_SHARED] = {
+	{
 		.id		= IPA_MEM_UC_SHARED,
 		.offset		= 0x0000,
 		.size		= 0x0080,
 		.canary_count	= 0,
 	},
-	[IPA_MEM_UC_INFO] = {
+	{
 		.id		= IPA_MEM_UC_INFO,
 		.offset		= 0x0080,
 		.size		= 0x0200,
 		.canary_count	= 0,
 	},
-	[IPA_MEM_V4_FILTER_HASHED] = {
+	{
 		.id		= IPA_MEM_V4_FILTER_HASHED,
 		.offset		= 0x0288,
 		.size		= 0,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_V4_FILTER] = {
+	{
 		.id		= IPA_MEM_V4_FILTER,
 		.offset		= 0x0290,
 		.size		= 0x0078,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_V6_FILTER_HASHED] = {
+	{
 		.id		= IPA_MEM_V6_FILTER_HASHED,
 		.offset		= 0x0310,
 		.size		= 0,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_V6_FILTER] = {
+	{
 		.id		= IPA_MEM_V6_FILTER,
 		.offset		= 0x0318,
 		.size		= 0x0078,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_V4_ROUTE_HASHED] = {
+	{
 		.id		= IPA_MEM_V4_ROUTE_HASHED,
 		.offset		= 0x0398,
 		.size		= 0,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_V4_ROUTE] = {
+	{
 		.id		= IPA_MEM_V4_ROUTE,
 		.offset		= 0x03a0,
 		.size		= 0x0078,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_V6_ROUTE_HASHED] = {
+	{
 		.id		= IPA_MEM_V6_ROUTE_HASHED,
 		.offset		= 0x0420,
 		.size		= 0,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_V6_ROUTE] = {
+	{
 		.id		= IPA_MEM_V6_ROUTE,
 		.offset		= 0x0428,
 		.size		= 0x0078,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_MODEM_HEADER] = {
+	{
 		.id		= IPA_MEM_MODEM_HEADER,
 		.offset		= 0x04a8,
 		.size		= 0x0140,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_MODEM_PROC_CTX] = {
+	{
 		.id		= IPA_MEM_MODEM_PROC_CTX,
 		.offset		= 0x05f0,
 		.size		= 0x0200,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_AP_PROC_CTX] = {
+	{
 		.id		= IPA_MEM_AP_PROC_CTX,
 		.offset		= 0x07f0,
 		.size		= 0x0200,
 		.canary_count	= 0,
 	},
-	[IPA_MEM_PDN_CONFIG] = {
+	{
 		.id		= IPA_MEM_PDN_CONFIG,
 		.offset		= 0x09f8,
 		.size		= 0x0050,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_STATS_QUOTA_MODEM] = {
+	{
 		.id		= IPA_MEM_STATS_QUOTA_MODEM,
 		.offset		= 0x0a50,
 		.size		= 0x0060,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_STATS_TETHERING] = {
+	{
 		.id		= IPA_MEM_STATS_TETHERING,
 		.offset		= 0x0ab0,
 		.size		= 0x0140,
 		.canary_count	= 0,
 	},
-	[IPA_MEM_MODEM] = {
+	{
 		.id		= IPA_MEM_MODEM,
 		.offset		= 0x0bf0,
 		.size		= 0x140c,
 		.canary_count	= 0,
 	},
-	[IPA_MEM_END_MARKER] = {
+	{
 		.id		= IPA_MEM_END_MARKER,
 		.offset		= 0x2000,
 		.size		= 0,
diff --git a/drivers/net/ipa/ipa_data-v4.5.c b/drivers/net/ipa/ipa_data-v4.5.c
index 1c8a9099639ab..a99b6478fa3a5 100644
--- a/drivers/net/ipa/ipa_data-v4.5.c
+++ b/drivers/net/ipa/ipa_data-v4.5.c
@@ -265,139 +265,139 @@ static const struct ipa_resource_data ipa_resource_data = {
 
 /* IPA-resident memory region data for an SoC having IPA v4.5 */
 static const struct ipa_mem ipa_mem_local_data[] = {
-	[IPA_MEM_UC_SHARED] = {
+	{
 		.id		= IPA_MEM_UC_SHARED,
 		.offset		= 0x0000,
 		.size		= 0x0080,
 		.canary_count	= 0,
 	},
-	[IPA_MEM_UC_INFO] = {
+	{
 		.id		= IPA_MEM_UC_INFO,
 		.offset		= 0x0080,
 		.size		= 0x0200,
 		.canary_count	= 0,
 	},
-	[IPA_MEM_V4_FILTER_HASHED] = {
+	{
 		.id		= IPA_MEM_V4_FILTER_HASHED,
 		.offset		= 0x0288,
 		.size		= 0x0078,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_V4_FILTER] = {
+	{
 		.id		= IPA_MEM_V4_FILTER,
 		.offset		= 0x0308,
 		.size		= 0x0078,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_V6_FILTER_HASHED] = {
+	{
 		.id		= IPA_MEM_V6_FILTER_HASHED,
 		.offset		= 0x0388,
 		.size		= 0x0078,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_V6_FILTER] = {
+	{
 		.id		= IPA_MEM_V6_FILTER,
 		.offset		= 0x0408,
 		.size		= 0x0078,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_V4_ROUTE_HASHED] = {
+	{
 		.id		= IPA_MEM_V4_ROUTE_HASHED,
 		.offset		= 0x0488,
 		.size		= 0x0078,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_V4_ROUTE] = {
+	{
 		.id		= IPA_MEM_V4_ROUTE,
 		.offset		= 0x0508,
 		.size		= 0x0078,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_V6_ROUTE_HASHED] = {
+	{
 		.id		= IPA_MEM_V6_ROUTE_HASHED,
 		.offset		= 0x0588,
 		.size		= 0x0078,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_V6_ROUTE] = {
+	{
 		.id		= IPA_MEM_V6_ROUTE,
 		.offset		= 0x0608,
 		.size		= 0x0078,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_MODEM_HEADER] = {
+	{
 		.id		= IPA_MEM_MODEM_HEADER,
 		.offset		= 0x0688,
 		.size		= 0x0240,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_AP_HEADER] = {
+	{
 		.id		= IPA_MEM_AP_HEADER,
 		.offset		= 0x08c8,
 		.size		= 0x0200,
 		.canary_count	= 0,
 	},
-	[IPA_MEM_MODEM_PROC_CTX] = {
+	{
 		.id		= IPA_MEM_MODEM_PROC_CTX,
 		.offset		= 0x0ad0,
 		.size		= 0x0b20,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_AP_PROC_CTX] = {
+	{
 		.id		= IPA_MEM_AP_PROC_CTX,
 		.offset		= 0x15f0,
 		.size		= 0x0200,
 		.canary_count	= 0,
 	},
-	[IPA_MEM_NAT_TABLE] = {
+	{
 		.id		= IPA_MEM_NAT_TABLE,
 		.offset		= 0x1800,
 		.size		= 0x0d00,
 		.canary_count	= 4,
 	},
-	[IPA_MEM_STATS_QUOTA_MODEM] = {
+	{
 		.id		= IPA_MEM_STATS_QUOTA_MODEM,
 		.offset		= 0x2510,
 		.size		= 0x0030,
 		.canary_count	= 4,
 	},
-	[IPA_MEM_STATS_QUOTA_AP] = {
+	{
 		.id		= IPA_MEM_STATS_QUOTA_AP,
 		.offset		= 0x2540,
 		.size		= 0x0048,
 		.canary_count	= 0,
 	},
-	[IPA_MEM_STATS_TETHERING] = {
+	{
 		.id		= IPA_MEM_STATS_TETHERING,
 		.offset		= 0x2588,
 		.size		= 0x0238,
 		.canary_count	= 0,
 	},
-	[IPA_MEM_STATS_FILTER_ROUTE] = {
+	{
 		.id		= IPA_MEM_STATS_FILTER_ROUTE,
 		.offset		= 0x27c0,
 		.size		= 0x0800,
 		.canary_count	= 0,
 	},
-	[IPA_MEM_STATS_DROP] = {
+	{
 		.id		= IPA_MEM_STATS_DROP,
 		.offset		= 0x2fc0,
 		.size		= 0x0020,
 		.canary_count	= 0,
 	},
-	[IPA_MEM_MODEM] = {
+	{
 		.id		= IPA_MEM_MODEM,
 		.offset		= 0x2fe8,
 		.size		= 0x0800,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_UC_EVENT_RING] = {
+	{
 		.id		= IPA_MEM_UC_EVENT_RING,
 		.offset		= 0x3800,
 		.size		= 0x1000,
 		.canary_count	= 1,
 	},
-	[IPA_MEM_PDN_CONFIG] = {
+	{
 		.id		= IPA_MEM_PDN_CONFIG,
 		.offset		= 0x4800,
 		.size		= 0x0050,
diff --git a/drivers/net/ipa/ipa_data-v4.9.c b/drivers/net/ipa/ipa_data-v4.9.c
index f77169709eb2a..798d43e1eb133 100644
--- a/drivers/net/ipa/ipa_data-v4.9.c
+++ b/drivers/net/ipa/ipa_data-v4.9.c
@@ -263,139 +263,139 @@ static const struct ipa_resource_data ipa_resource_data = {
 
 /* IPA-resident memory region data for an SoC having IPA v4.9 */
 static const struct ipa_mem ipa_mem_local_data[] = {
-	[IPA_MEM_UC_SHARED] = {
+	{
 		.id		= IPA_MEM_UC_SHARED,
 		.offset		= 0x0000,
 		.size		= 0x0080,
 		.canary_count	= 0,
 	},
-	[IPA_MEM_UC_INFO] = {
+	{
 		.id		= IPA_MEM_UC_INFO,
 		.offset		= 0x0080,
 		.size		= 0x0200,
 		.canary_count	= 0,
 	},
-	[IPA_MEM_V4_FILTER_HASHED] = {
+	{
 		.id		= IPA_MEM_V4_FILTER_HASHED,
 		.offset		= 0x0288,
 		.size		= 0x0078,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_V4_FILTER] = {
+	{
 		.id		= IPA_MEM_V4_FILTER,
 		.offset		= 0x0308,
 		.size		= 0x0078,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_V6_FILTER_HASHED] = {
+	{
 		.id		= IPA_MEM_V6_FILTER_HASHED,
 		.offset		= 0x0388,
 		.size		= 0x0078,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_V6_FILTER] = {
+	{
 		.id		= IPA_MEM_V6_FILTER,
 		.offset		= 0x0408,
 		.size		= 0x0078,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_V4_ROUTE_HASHED] = {
+	{
 		.id		= IPA_MEM_V4_ROUTE_HASHED,
 		.offset		= 0x0488,
 		.size		= 0x0078,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_V4_ROUTE] = {
+	{
 		.id		= IPA_MEM_V4_ROUTE,
 		.offset		= 0x0508,
 		.size		= 0x0078,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_V6_ROUTE_HASHED] = {
+	{
 		.id		= IPA_MEM_V6_ROUTE_HASHED,
 		.offset		= 0x0588,
 		.size		= 0x0078,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_V6_ROUTE] = {
+	{
 		.id		= IPA_MEM_V6_ROUTE,
 		.offset		= 0x0608,
 		.size		= 0x0078,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_MODEM_HEADER] = {
+	{
 		.id		= IPA_MEM_MODEM_HEADER,
 		.offset		= 0x0688,
 		.size		= 0x0240,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_AP_HEADER] = {
+	{
 		.id		= IPA_MEM_AP_HEADER,
 		.offset		= 0x08c8,
 		.size		= 0x0200,
 		.canary_count	= 0,
 	},
-	[IPA_MEM_MODEM_PROC_CTX] = {
+	{
 		.id		= IPA_MEM_MODEM_PROC_CTX,
 		.offset		= 0x0ad0,
 		.size		= 0x0b20,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_AP_PROC_CTX] = {
+	{
 		.id		= IPA_MEM_AP_PROC_CTX,
 		.offset		= 0x15f0,
 		.size		= 0x0200,
 		.canary_count	= 0,
 	},
-	[IPA_MEM_NAT_TABLE] = {
+	{
 		.id		= IPA_MEM_NAT_TABLE,
 		.offset		= 0x1800,
 		.size		= 0x0d00,
 		.canary_count	= 4,
 	},
-	[IPA_MEM_STATS_QUOTA_MODEM] = {
+	{
 		.id		= IPA_MEM_STATS_QUOTA_MODEM,
 		.offset		= 0x2510,
 		.size		= 0x0030,
 		.canary_count	= 4,
 	},
-	[IPA_MEM_STATS_QUOTA_AP] = {
+	{
 		.id		= IPA_MEM_STATS_QUOTA_AP,
 		.offset		= 0x2540,
 		.size		= 0x0048,
 		.canary_count	= 0,
 	},
-	[IPA_MEM_STATS_TETHERING] = {
+	{
 		.id		= IPA_MEM_STATS_TETHERING,
 		.offset		= 0x2588,
 		.size		= 0x0238,
 		.canary_count	= 0,
 	},
-	[IPA_MEM_STATS_FILTER_ROUTE] = {
+	{
 		.id		= IPA_MEM_STATS_FILTER_ROUTE,
 		.offset		= 0x27c0,
 		.size		= 0x0800,
 		.canary_count	= 0,
 	},
-	[IPA_MEM_STATS_DROP] = {
+	{
 		.id		= IPA_MEM_STATS_DROP,
 		.offset		= 0x2fc0,
 		.size		= 0x0020,
 		.canary_count	= 0,
 	},
-	[IPA_MEM_MODEM] = {
+	{
 		.id		= IPA_MEM_MODEM,
 		.offset		= 0x2fe8,
 		.size		= 0x0800,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_UC_EVENT_RING] = {
+	{
 		.id		= IPA_MEM_UC_EVENT_RING,
 		.offset		= 0x3800,
 		.size		= 0x1000,
 		.canary_count	= 1,
 	},
-	[IPA_MEM_PDN_CONFIG] = {
+	{
 		.id		= IPA_MEM_PDN_CONFIG,
 		.offset		= 0x4800,
 		.size		= 0x0050,
diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index 633895fc67b66..4337b0920d3d7 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -28,8 +28,14 @@
 
 const struct ipa_mem *ipa_mem_find(struct ipa *ipa, enum ipa_mem_id mem_id)
 {
-	if (mem_id < IPA_MEM_COUNT)
-		return &ipa->mem[mem_id];
+	u32 i;
+
+	for (i = 0; i < ipa->mem_count; i++) {
+		const struct ipa_mem *mem = &ipa->mem[i];
+
+		if (mem->id == mem_id)
+			return mem;
+	}
 
 	return NULL;
 }
@@ -209,6 +215,11 @@ static bool ipa_mem_valid_one(struct ipa *ipa, const struct ipa_mem *mem)
 		return false;
 	}
 
+	if (!mem->size && !mem->canary_count) {
+		dev_err(dev, "empty memory region %u\n", mem_id);
+		return false;
+	}
+
 	/* Other than modem memory, sizes must be a multiple of 8 */
 	size_multiple = mem_id == IPA_MEM_MODEM ? 4 : 8;
 	if (mem->size % size_multiple)
@@ -244,25 +255,14 @@ static bool ipa_mem_valid(struct ipa *ipa, const struct ipa_mem_data *mem_data)
 	for (i = 0; i < mem_data->local_count; i++) {
 		const struct ipa_mem *mem = &mem_data->local[i];
 
-		if (mem->id == IPA_MEM_UNDEFINED)
-			continue;
-
 		if (__test_and_set_bit(mem->id, regions)) {
 			dev_err(dev, "duplicate memory region %u\n", mem->id);
 			return false;
 		}
 
 		/* Defined regions have non-zero size and/or canary count */
-		if (mem->size || mem->canary_count) {
-			if (ipa_mem_valid_one(ipa, mem))
-				continue;
+		if (!ipa_mem_valid_one(ipa, mem))
 			return false;
-		}
-
-		/* It's harmless, but warn if an offset is provided */
-		if (mem->offset)
-			dev_warn(dev, "empty region %u has non-zero offset\n",
-				 mem->id);
 	}
 
 	/* Now see if any required regions are not defined */
@@ -349,20 +349,14 @@ int ipa_mem_config(struct ipa *ipa)
 	 * space prior to the region's base address if indicated.
 	 */
 	for (i = 0; i < ipa->mem_count; i++) {
-		u16 canary_count;
+		u16 canary_count = ipa->mem[i].canary_count;
 		__le32 *canary;
 
-		/* Skip over undefined regions */
-		mem = &ipa->mem[i];
-		if (!mem->offset && !mem->size)
-			continue;
-
-		canary_count = mem->canary_count;
 		if (!canary_count)
 			continue;
 
 		/* Write canary values in the space before the region */
-		canary = ipa->mem_virt + ipa->mem_offset + mem->offset;
+		canary = ipa->mem_virt + ipa->mem_offset + ipa->mem[i].offset;
 		do
 			*--canary = IPA_MEM_CANARY_VAL;
 		while (--canary_count);
diff --git a/drivers/net/ipa/ipa_mem.h b/drivers/net/ipa/ipa_mem.h
index 712b2881be0c2..570bfdd99bffb 100644
--- a/drivers/net/ipa/ipa_mem.h
+++ b/drivers/net/ipa/ipa_mem.h
@@ -43,7 +43,6 @@ struct ipa_mem_data;
 
 /* IPA-resident memory region ids */
 enum ipa_mem_id {
-	IPA_MEM_UNDEFINED = 0,		/* undefined region */
 	IPA_MEM_UC_SHARED,		/* 0 canaries */
 	IPA_MEM_UC_INFO,		/* 0 canaries */
 	IPA_MEM_V4_FILTER_HASHED,	/* 2 canaries */
-- 
2.27.0


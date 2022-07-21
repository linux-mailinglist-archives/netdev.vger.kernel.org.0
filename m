Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1007257CCBF
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 15:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiGUNzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 09:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiGUNze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 09:55:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4D39ABE3D
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 06:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658411732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=LvPQRsYw5zpTJYf7jh/0JiSUMdGmQLf2KMb1+AuvPVQ=;
        b=V6NAWFdPNwocYi4UiW3YuEywD7bjIkZzhIkFzIYwoSQF99TmUgtaC3enjmc4BrCJCrf8O2
        y7LzhWDqbtgef0abqh52l0jFqDUFZDkDs6wWtIsI3KW/twzQoZYMpIboGLQfTuHrppcmwB
        qvFnCiadPKtArT61w9D6r6fwwaAEipM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-396-AYCSQABiNeiuhFq2bYykXg-1; Thu, 21 Jul 2022 09:55:28 -0400
X-MC-Unique: AYCSQABiNeiuhFq2bYykXg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E018A1C03362;
        Thu, 21 Jul 2022 13:55:27 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.194.129])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2B61C492C3B;
        Thu, 21 Jul 2022 13:55:27 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Alex Elder <elder@kernel.org>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: ipa: fix build
Date:   Thu, 21 Jul 2022 15:55:14 +0200
Message-Id: <7105112c38cfe0642a2d9e1779bf784a7aa63d16.1658411666.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit 2c7b9b936bdc ("net: ipa: move configuration data files
into a subdirectory"), build of the ipa driver fails with the
following error:

drivers/net/ipa/data/ipa_data-v3.1.c:9:10: fatal error: gsi.h: No such file or directory

After the mentioned commit, all the file included by the configuration
are in the parent directory. Fix the issue updating the include path.

Fixes: 2c7b9b936bdc ("net: ipa: move configuration data files into a subdirectory")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
Note: I could not use CFLAGS_* here, due to the relevant compilation
unit name including a slash. Any better option more than welcome!
---
 drivers/net/ipa/data/ipa_data-v3.1.c   | 8 ++++----
 drivers/net/ipa/data/ipa_data-v3.5.1.c | 8 ++++----
 drivers/net/ipa/data/ipa_data-v4.11.c  | 8 ++++----
 drivers/net/ipa/data/ipa_data-v4.2.c   | 8 ++++----
 drivers/net/ipa/data/ipa_data-v4.5.c   | 8 ++++----
 drivers/net/ipa/data/ipa_data-v4.9.c   | 8 ++++----
 6 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ipa/data/ipa_data-v3.1.c b/drivers/net/ipa/data/ipa_data-v3.1.c
index 00f4e506e6e5..1c1895aea811 100644
--- a/drivers/net/ipa/data/ipa_data-v3.1.c
+++ b/drivers/net/ipa/data/ipa_data-v3.1.c
@@ -6,10 +6,10 @@
 
 #include <linux/log2.h>
 
-#include "gsi.h"
-#include "ipa_data.h"
-#include "ipa_endpoint.h"
-#include "ipa_mem.h"
+#include "../gsi.h"
+#include "../ipa_data.h"
+#include "../ipa_endpoint.h"
+#include "../ipa_mem.h"
 
 /** enum ipa_resource_type - IPA resource types for an SoC having IPA v3.1 */
 enum ipa_resource_type {
diff --git a/drivers/net/ipa/data/ipa_data-v3.5.1.c b/drivers/net/ipa/data/ipa_data-v3.5.1.c
index b7e32e87733e..58b708d2fc75 100644
--- a/drivers/net/ipa/data/ipa_data-v3.5.1.c
+++ b/drivers/net/ipa/data/ipa_data-v3.5.1.c
@@ -6,10 +6,10 @@
 
 #include <linux/log2.h>
 
-#include "gsi.h"
-#include "ipa_data.h"
-#include "ipa_endpoint.h"
-#include "ipa_mem.h"
+#include "../gsi.h"
+#include "../ipa_data.h"
+#include "../ipa_endpoint.h"
+#include "../ipa_mem.h"
 
 /** enum ipa_resource_type - IPA resource types for an SoC having IPA v3.5.1 */
 enum ipa_resource_type {
diff --git a/drivers/net/ipa/data/ipa_data-v4.11.c b/drivers/net/ipa/data/ipa_data-v4.11.c
index 1be823e5c5c2..a204e439c23d 100644
--- a/drivers/net/ipa/data/ipa_data-v4.11.c
+++ b/drivers/net/ipa/data/ipa_data-v4.11.c
@@ -4,10 +4,10 @@
 
 #include <linux/log2.h>
 
-#include "gsi.h"
-#include "ipa_data.h"
-#include "ipa_endpoint.h"
-#include "ipa_mem.h"
+#include "../gsi.h"
+#include "../ipa_data.h"
+#include "../ipa_endpoint.h"
+#include "../ipa_mem.h"
 
 /** enum ipa_resource_type - IPA resource types for an SoC having IPA v4.11 */
 enum ipa_resource_type {
diff --git a/drivers/net/ipa/data/ipa_data-v4.2.c b/drivers/net/ipa/data/ipa_data-v4.2.c
index 683f1f91042f..04f574fe006f 100644
--- a/drivers/net/ipa/data/ipa_data-v4.2.c
+++ b/drivers/net/ipa/data/ipa_data-v4.2.c
@@ -4,10 +4,10 @@
 
 #include <linux/log2.h>
 
-#include "gsi.h"
-#include "ipa_data.h"
-#include "ipa_endpoint.h"
-#include "ipa_mem.h"
+#include "../gsi.h"
+#include "../ipa_data.h"
+#include "../ipa_endpoint.h"
+#include "../ipa_mem.h"
 
 /** enum ipa_resource_type - IPA resource types for an SoC having IPA v4.2 */
 enum ipa_resource_type {
diff --git a/drivers/net/ipa/data/ipa_data-v4.5.c b/drivers/net/ipa/data/ipa_data-v4.5.c
index 79398f286a9c..684239e71f46 100644
--- a/drivers/net/ipa/data/ipa_data-v4.5.c
+++ b/drivers/net/ipa/data/ipa_data-v4.5.c
@@ -4,10 +4,10 @@
 
 #include <linux/log2.h>
 
-#include "gsi.h"
-#include "ipa_data.h"
-#include "ipa_endpoint.h"
-#include "ipa_mem.h"
+#include "../gsi.h"
+#include "../ipa_data.h"
+#include "../ipa_endpoint.h"
+#include "../ipa_mem.h"
 
 /** enum ipa_resource_type - IPA resource types for an SoC having IPA v4.5 */
 enum ipa_resource_type {
diff --git a/drivers/net/ipa/data/ipa_data-v4.9.c b/drivers/net/ipa/data/ipa_data-v4.9.c
index 4b96efd05cf2..2333e15f9533 100644
--- a/drivers/net/ipa/data/ipa_data-v4.9.c
+++ b/drivers/net/ipa/data/ipa_data-v4.9.c
@@ -4,10 +4,10 @@
 
 #include <linux/log2.h>
 
-#include "gsi.h"
-#include "ipa_data.h"
-#include "ipa_endpoint.h"
-#include "ipa_mem.h"
+#include "../gsi.h"
+#include "../ipa_data.h"
+#include "../ipa_endpoint.h"
+#include "../ipa_mem.h"
 
 /** enum ipa_resource_type - IPA resource types for an SoC having IPA v4.9 */
 enum ipa_resource_type {
-- 
2.35.3


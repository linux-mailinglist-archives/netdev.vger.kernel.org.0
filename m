Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45A5B67F4AC
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 05:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbjA1Ec3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 23:32:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbjA1EcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 23:32:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C117C306
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 20:32:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B08AB8221F
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 04:32:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 126F2C433A0;
        Sat, 28 Jan 2023 04:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674880340;
        bh=KggMQEsmSl8PR2yfZlThOc/TNq4x7jnDsNjBWH9GRbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qNmwnKzS64/nKrJUIN1vAyUT4o8OkvBNoCJAjBOa/gstK/FgT06dp1qdNaAgXROFH
         EYtgKuOnDPTN1X3+u5mEgI49N3hktRix8o2EFkaFSnLL/cN10Ez9QBbmxxVuAfm3zU
         JztkaruZ5mClwefmgDJz+7mPxEywtBEcNazJ8ZJrszeOPlhJBIsLx3CoxR9m+R+/9l
         tvT7N4EOI0dQ7p9zOybDpPoUq7V0h+PztCAIRuSd1ICxRlzODFp9hzzYwZtdmt2ObL
         /wo4/VFVvfOvi4iA16LRfCW+/y1SShqjUG/HQdfDTQ7tIGz1PKP8SfE/dtU7TCwEUS
         5TX1k1X4coiwA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 02/13] tools: ynl: move the cli and netlink code around
Date:   Fri, 27 Jan 2023 20:32:06 -0800
Message-Id: <20230128043217.1572362-3-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230128043217.1572362-1-kuba@kernel.org>
References: <20230128043217.1572362-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the CLI code out of samples/ and the library part
of it into tools/net/ynl/lib/. This way we can start
sharing some code with the code gen.

Initially I thought that code gen is too C-specific to
share anything but basic stuff like calculating values
for enums can easily be shared.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/{samples => }/cli.py    | 2 +-
 tools/net/ynl/lib/__init__.py         | 5 +++++
 tools/net/ynl/{samples => lib}/ynl.py | 0
 3 files changed, 6 insertions(+), 1 deletion(-)
 rename tools/net/ynl/{samples => }/cli.py (97%)
 create mode 100644 tools/net/ynl/lib/__init__.py
 rename tools/net/ynl/{samples => lib}/ynl.py (100%)

diff --git a/tools/net/ynl/samples/cli.py b/tools/net/ynl/cli.py
similarity index 97%
rename from tools/net/ynl/samples/cli.py
rename to tools/net/ynl/cli.py
index b27159c70710..5c4eb5a68514 100755
--- a/tools/net/ynl/samples/cli.py
+++ b/tools/net/ynl/cli.py
@@ -6,7 +6,7 @@ import json
 import pprint
 import time
 
-from ynl import YnlFamily
+from lib import YnlFamily
 
 
 def main():
diff --git a/tools/net/ynl/lib/__init__.py b/tools/net/ynl/lib/__init__.py
new file mode 100644
index 000000000000..0a6102758ebe
--- /dev/null
+++ b/tools/net/ynl/lib/__init__.py
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: BSD-3-Clause
+
+from .ynl import YnlFamily
+
+__all__ = ["YnlFamily"]
diff --git a/tools/net/ynl/samples/ynl.py b/tools/net/ynl/lib/ynl.py
similarity index 100%
rename from tools/net/ynl/samples/ynl.py
rename to tools/net/ynl/lib/ynl.py
-- 
2.39.1


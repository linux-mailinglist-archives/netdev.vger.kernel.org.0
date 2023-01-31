Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32FF468221D
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 03:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbjAaCeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 21:34:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbjAaCeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 21:34:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6795D2E0D1;
        Mon, 30 Jan 2023 18:34:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAE0B6137C;
        Tue, 31 Jan 2023 02:34:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0520C433A7;
        Tue, 31 Jan 2023 02:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675132440;
        bh=KggMQEsmSl8PR2yfZlThOc/TNq4x7jnDsNjBWH9GRbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pH4dqKDxuJme6bfamp0WzAFDwp3axD8/IJ20aTs/gkWkbAmPfdeApOu61jl/cuqtH
         MpCScbIE1gcsgh1U+9eD3GDIOtqyuVaegvTaFp+8YZLH0PDAakq/1b0HQ1I8XTljgP
         kanlJdEwPHTUH6VqftjHIxlht59acSLZuspu+ODx4JAc3/5NEO/T7H5wKWFC4bjxt0
         mDsd2crxFrJ9stBE7gpP1Yfzpn/uAnYG1Op5t37OxFXT8QKI/yrwSJO/tz50ge52Dn
         1lrBsizJNFrnQYCKoJppqNFMfMO6oz8cYXDH1DsVJUJMcFfsc8SwBaSFS30AeD8mC5
         OYIVuYI/X+RMw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        sdf@google.com, linux-doc@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 02/14] tools: ynl: move the cli and netlink code around
Date:   Mon, 30 Jan 2023 18:33:42 -0800
Message-Id: <20230131023354.1732677-3-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230131023354.1732677-1-kuba@kernel.org>
References: <20230131023354.1732677-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC05A67C145
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 01:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbjAZACu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 19:02:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbjAZACn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 19:02:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 085AF402FE
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 16:02:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC0B6B81C67
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 00:02:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA5EC433EF;
        Thu, 26 Jan 2023 00:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674691359;
        bh=W8fqANM21H3nax8iR+7JpxxPP9sOLJ3YSwgODEs8uHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nq5zwemxJaajjSv8voln4iGeSD7lJ2wKHK7Z0qf2relEzpNk9qj9A3584qk0muACe
         w7DQtM4S4AzAYsn5owOCS3CKQ/W/VFnYE7Oc650cXlYljBd7oS+B8oe2nWQM10wLpS
         FqqP+CSwlkaaTD9StuzLPAeIy9sA4ezA7Rts9JnxAOHGz7zEizIFp3821BVLHyHl1t
         d2QbJnZU8oTJfTqGN/vEaMDhxK61o356XudY/IE3SDDFpTmoU+/MKLXn5DYz2cxKQG
         giyBYkpTtI1Ft518WFp3YIEsUVVV219EFYQzUn1crHwhDkIm4E1wNUjFvtZnYCZ2nP
         +H3NofKvnyz0w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 3/3] tools: ynl: store ops in ordered dict to avoid random ordering
Date:   Wed, 25 Jan 2023 16:02:35 -0800
Message-Id: <20230126000235.1085551-4-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230126000235.1085551-1-kuba@kernel.org>
References: <20230126000235.1085551-1-kuba@kernel.org>
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

When rendering code we should walk the ops in the order in which
they are declared in the spec. This is both more intuitive and
prevents code from jumping around when hashing in the dict changes.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 9297cfacbe06..1aa872e582ab 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -1,6 +1,7 @@
 #!/usr/bin/env python
 
 import argparse
+import collections
 import jsonschema
 import os
 import yaml
@@ -793,7 +794,7 @@ import yaml
         # list of all operations
         self.msg_list = []
         # dict of operations which have their own message type (have attributes)
-        self.ops = dict()
+        self.ops = collections.OrderedDict()
         self.attr_sets = dict()
         self.attr_sets_list = []
 
-- 
2.39.1


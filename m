Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 974046BC0A0
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 00:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231859AbjCOXEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 19:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbjCOXE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 19:04:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0257E78C8F
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 16:04:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8263561EA3
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 23:04:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AADC2C4339B;
        Wed, 15 Mar 2023 23:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678921466;
        bh=sBclUKbdcTpb/BGQ8O/ijWcijkCaHJyf6mR+BThkSws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UgHqhwPcuWxH/obFumKw9lUEnPDxApC719mH96ME3a4lv22olZfeSE2Lt748kaf6y
         dRCjjm5O+4eP6w9um05JFeJYKssFfo19GQGWRdZgq9/6lE6wvo0zLdYyZjm7xSyHwD
         YgJqUDp883bMnXJeJP89rs8jp9jnuZPsFVjJz6RpbBNmyH0hUz1CJzt2VVeMH1sp87
         lh9hLkOmFtmbaYNrcAnBr8t2Bupm477A9cUUTT7c5CPUaLzi3RDvdMyc1BHbEi4Klq
         6/rgosQ9DzI0SgLXrkQN5OgPqpExQEl4eex2BeuWWXRniXV8WJO8GWwwSdzvkMqHWC
         7nMqLfMSwezjw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        chuck.lever@oracle.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 1/3] tools: ynl: make definitions optional again
Date:   Wed, 15 Mar 2023 16:03:49 -0700
Message-Id: <20230315230351.478320-2-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230315230351.478320-1-kuba@kernel.org>
References: <20230315230351.478320-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

definitions are optional, commit in question breaks cli for ethtool.

Fixes: 6517a60b0307 ("tools: ynl: move the enum classes to shared code")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/lib/nlspec.py | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/net/ynl/lib/nlspec.py b/tools/net/ynl/lib/nlspec.py
index 960a356e8225..e01a72d06638 100644
--- a/tools/net/ynl/lib/nlspec.py
+++ b/tools/net/ynl/lib/nlspec.py
@@ -387,7 +387,8 @@ jsonschema = None
     def resolve(self):
         self.resolve_up(super())
 
-        for elem in self.yaml['definitions']:
+        definitions = self.yaml.get('definitions', [])
+        for elem in definitions:
             if elem['type'] == 'enum' or elem['type'] == 'flags':
                 self.consts[elem['name']] = self.new_enum(elem)
             else:
-- 
2.39.2


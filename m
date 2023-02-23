Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C81806A0F7D
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 19:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbjBWScA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 13:32:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjBWSb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 13:31:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD9E58495
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 10:31:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5242761762
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 18:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD19C433A0;
        Thu, 23 Feb 2023 18:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677177113;
        bh=bPyS647x4nRw0NqASmyZUpKXuSNgaAi01q32fDS80bE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ke4rFTaBxmYSpvCNNuKSy9iUrT2pKU+DNamu/6PCszgljtWY9ymjQS7jkNt3j2hRE
         cMfVKx4FscOpmTx90L1j226Yh2ZvuUKFXa3OmRxWMIYmROpwGmBZiRDAm/T9nO97Fy
         yO9fAawcPhaMhyXAqIPN376xzpdxTzlP6q31rW4pzXXfVaLe8zdkvw1lrSSTY9u+oH
         gFXUKzWn/WrP9h/CdJvOe2+shAQsuLlWo0t/+u15ybGv6djiyAqBexWuSXOd7FP70S
         wvHsQvACV0PSp9D1z2rmNVUUcccXjrhzv92GpY+5CcogJDs22SQ8UzzCegOf7qEVdx
         twYRuDUTbL1wQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>
Subject: [PATCH net 2/3] tools: ynl-gen: re-raise the exception instead of printing
Date:   Thu, 23 Feb 2023 10:31:40 -0800
Message-Id: <20230223183141.1422857-3-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223183141.1422857-1-kuba@kernel.org>
References: <20230223183141.1422857-1-kuba@kernel.org>
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

traceback.print_exception() seems tricky to call, we're missing
some argument, so re-raise instead.

Reported-by: Chuck Lever III <chuck.lever@oracle.com>
Fixes: 3aacf8281336 ("tools: ynl: add an object hierarchy to represent parsed spec")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/lib/nlspec.py | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/net/ynl/lib/nlspec.py b/tools/net/ynl/lib/nlspec.py
index e204679ad8b7..71da568e2c28 100644
--- a/tools/net/ynl/lib/nlspec.py
+++ b/tools/net/ynl/lib/nlspec.py
@@ -3,7 +3,6 @@
 import collections
 import importlib
 import os
-import traceback
 import yaml
 
 
@@ -234,8 +233,7 @@ jsonschema = None
                 resolved.append(elem)
 
             if len(resolved) == 0:
-                traceback.print_exception(last_exception)
-                raise Exception("Could not resolve any spec element, infinite loop?")
+                raise last_exception
 
     def new_attr_set(self, elem):
         return SpecAttrSet(self, elem)
-- 
2.39.2


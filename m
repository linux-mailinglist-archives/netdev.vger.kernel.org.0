Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5BA36DAEFB
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 16:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbjDGO4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 10:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbjDGO4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 10:56:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2332A5D6
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 07:56:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AD83611A9
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 14:56:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A88C433EF;
        Fri,  7 Apr 2023 14:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680879378;
        bh=eauetmVyDWiUcuxNb78MEKe8CAqDiWII0zsGFNkKSew=;
        h=From:To:Cc:Subject:Date:From;
        b=lX84kodTDekTOQhsHeN4IkxDtuZ/dh+Cpo7K8KX91WCBHYhxjjMDbM0L5nGdWqnY7
         UwdVH8XWTl6CKjfX4l3/a1tFpcrXWJoLrnwAd4nLJGR4oR3TXupl39xyxX685t1Okx
         2odP3jOd9xoDDYhpvAhsnyh4m3zB9uXx6Qm+J5H4vBZAIyaTbPyPYCgWOPLBOV6zTc
         NwnzdtEgMVZ/GsWpBqTe9zGAq31RF3z6h4+fmw3C6SodR5W2/y+Yht0mYWOPFywM4N
         utN2SfpLNascKeG60fRdkgFV6236U6J4tb1KahB3dz+bIzwK4h3Ncrcdrabg7QVXjs
         HGuj1UGNv4Xaw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        kory.maincent@bootlin.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] tools: ynl: throw a more meaningful exception if family not supported
Date:   Fri,  7 Apr 2023 07:56:09 -0700
Message-Id: <20230407145609.297525-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cli.py currently throws a pure KeyError if kernel doesn't support
a netlink family. Users who did not write ynl (hah) may waste
their time investigating what's wrong with the Python code.
Improve the error message:

Traceback (most recent call last):
  File "/home/kicinski/devel/linux/tools/net/ynl/lib/ynl.py", line 362, in __init__
    self.family = GenlFamily(self.yaml['name'])
                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/home/kicinski/devel/linux/tools/net/ynl/lib/ynl.py", line 331, in __init__
    self.genl_family = genl_family_name_to_id[family_name]
                       ~~~~~~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^
KeyError: 'netdev'

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/home/kicinski/devel/linux/./tools/net/ynl/cli.py", line 52, in <module>
    main()
  File "/home/kicinski/devel/linux/./tools/net/ynl/cli.py", line 31, in main
    ynl = YnlFamily(args.spec, args.schema)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/home/kicinski/devel/linux/tools/net/ynl/lib/ynl.py", line 364, in __init__
    raise Exception(f"Family '{self.yaml['name']}' not supported by the kernel")
Exception: Family 'netdev' not supported by the kernel

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/lib/ynl.py | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index 7690e0b0cb3f..aa77bcae4807 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -358,7 +358,10 @@ genl_family_name_to_id = None
             bound_f = functools.partial(self._op, op_name)
             setattr(self, op.ident_name, bound_f)
 
-        self.family = GenlFamily(self.yaml['name'])
+        try:
+            self.family = GenlFamily(self.yaml['name'])
+        except KeyError:
+            raise Exception(f"Family '{self.yaml['name']}' not supported by the kernel")
 
     def ntf_subscribe(self, mcast_name):
         if mcast_name not in self.family.genl_family['mcast']:
-- 
2.39.2


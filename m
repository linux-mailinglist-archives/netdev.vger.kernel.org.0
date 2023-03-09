Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1DDE6B2416
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 13:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbjCIM0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 07:26:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbjCIM0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 07:26:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A04EABBD;
        Thu,  9 Mar 2023 04:26:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23F7361B46;
        Thu,  9 Mar 2023 12:26:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33DE8C433EF;
        Thu,  9 Mar 2023 12:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678364765;
        bh=krlDJEH5bDGwMvURXs2bbNQodRC1kqOtI6C6fqAeVd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ooeRLJU/8Y0hyR/ssKv2lrOyMZCtSgbL7eRR8JpQ3uNxwLhdPj8lzmCg/5xT4vpQp
         +7HfT0q1vvtPNh23tJDcyPNAX6oROkYUoLqlnQ1r7CJl1b6lgr80HFpLkkkwfWjr0S
         KfRVlGvEpQktoUJDC5Ms3CLZV+/ExD63xDyss2/9z9dBSxumDY+ld5Fp5Phg/q89Hj
         v1uaOjL7kk7I6K8E5G0XYXqOOvyEFtIeo8CqMtTHsKApAvLDhiygwrFLb73TeaAoY+
         U4WphKJbSCB258y5NFXxmaofhvcSKNBF/YGRSrwveuinqjf2u2+RRiXsUyNNSv0zVm
         2gltXRDk1oNNQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        saeedm@nvidia.com, leon@kernel.org, shayagr@amazon.com,
        akiyano@amazon.com, darinzon@amazon.com, sgoutham@marvell.com,
        lorenzo.bianconi@redhat.com, toke@redhat.com, teknoraver@meta.com,
        ttoukan.linux@gmail.com
Subject: [PATCH net v2 2/8] tools: ynl: fix get_mask utility routine
Date:   Thu,  9 Mar 2023 13:25:26 +0100
Message-Id: <31613fd1f414d8d4d0b82e7dd1d60c6d087bd0d5.1678364613.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1678364612.git.lorenzo@kernel.org>
References: <cover.1678364612.git.lorenzo@kernel.org>
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

Fix get_mask utility routine in order to take into account possible gaps
in the elements list.

Fixes: be5bea1cc0bf ("net: add basic C code generators for Netlink")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 tools/net/ynl/lib/nlspec.py | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/net/ynl/lib/nlspec.py b/tools/net/ynl/lib/nlspec.py
index a34d088f6743..960a356e8225 100644
--- a/tools/net/ynl/lib/nlspec.py
+++ b/tools/net/ynl/lib/nlspec.py
@@ -138,10 +138,8 @@ class SpecEnumSet(SpecElement):
 
     def get_mask(self):
         mask = 0
-        idx = self.yaml.get('value-start', 0)
-        for _ in self.entries.values():
-            mask |= 1 << idx
-            idx += 1
+        for e in self.entries.values():
+            mask += e.user_value()
         return mask
 
 
-- 
2.39.2


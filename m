Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B24D86D8AA0
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 00:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233015AbjDEWcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 18:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232548AbjDEWcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 18:32:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC131FC9
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 15:32:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC1A363E95
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 22:32:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE743C433D2;
        Wed,  5 Apr 2023 22:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680733923;
        bh=iY5GTKKZQNIIsQJR+tSuXfCuH5I6rADAXQFRCgjW6p4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p7yrSIvwuXnlH4FTTj/rvPAbunuYuhQWSf+awlMp/U5a4yi/ncPutsZkHJzGOPUEr
         p6kV4cZAlhpYbidQf5qcdYtBrYjZPkFyOny4uVc7fVil53z5J/69sR7pnKPn9saVFi
         gMnRb/wp6A5b+Y1Xci3WVrLfC7ic5rlwRhKWFsvsfEnOtrxH+lEpGr2WEKh2Nyp5cs
         ZRTA8GOlckPkcCpFwX/B7QOrgcua+QwID0uRoLqHNGVsODj8zTuJhgt7wAs9H6ys8+
         1NfNzrfsbvKtywAYPm5uUqb+IeHK6qXdsuTK9OYxqY8wV1AB8SBQV+WXNZInabTOVv
         +C4tMrQxUcyNg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        herbert@gondor.apana.org.au, alexander.duyck@gmail.com,
        hkallweit1@gmail.com, andrew@lunn.ch, willemb@google.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 2/7] docs: net: move the probe and open/close sections of driver.rst up
Date:   Wed,  5 Apr 2023 15:31:29 -0700
Message-Id: <20230405223134.94665-3-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230405223134.94665-1-kuba@kernel.org>
References: <20230405223134.94665-1-kuba@kernel.org>
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

Somehow it feels more right to start from the probe then open,
then tx... Much like the lifetime of the driver itself.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/driver.rst | 54 ++++++++++++++---------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/Documentation/networking/driver.rst b/Documentation/networking/driver.rst
index 3040a74d421c..bfbd66871bb3 100644
--- a/Documentation/networking/driver.rst
+++ b/Documentation/networking/driver.rst
@@ -4,6 +4,33 @@
 Softnet Driver Issues
 =====================
 
+Probing guidelines
+==================
+
+Address validation
+------------------
+
+Any hardware layer address you obtain for your device should
+be verified.  For example, for ethernet check it with
+linux/etherdevice.h:is_valid_ether_addr()
+
+Close/stop guidelines
+=====================
+
+Quiescence
+----------
+
+After the ndo_stop routine has been called, the hardware must
+not receive or transmit any data.  All in flight packets must
+be aborted. If necessary, poll or wait for completion of
+any reset commands.
+
+Auto-close
+----------
+
+The ndo_stop routine will be called by unregister_netdevice
+if device is still UP.
+
 Transmit path guidelines
 ========================
 
@@ -89,30 +116,3 @@ to be freed up.
 If you return NETDEV_TX_BUSY from the ndo_start_xmit method, you
 must not keep any reference to that SKB and you must not attempt
 to free it up.
-
-Probing guidelines
-==================
-
-Address validation
-------------------
-
-Any hardware layer address you obtain for your device should
-be verified.  For example, for ethernet check it with
-linux/etherdevice.h:is_valid_ether_addr()
-
-Close/stop guidelines
-=====================
-
-Quiescence
-----------
-
-After the ndo_stop routine has been called, the hardware must
-not receive or transmit any data.  All in flight packets must
-be aborted. If necessary, poll or wait for completion of
-any reset commands.
-
-Auto-close
-----------
-
-The ndo_stop routine will be called by unregister_netdevice
-if device is still UP.
-- 
2.39.2


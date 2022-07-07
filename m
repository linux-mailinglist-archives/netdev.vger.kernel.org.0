Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD91569C63
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 10:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbiGGIDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 04:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234713AbiGGICx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 04:02:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F9833A1B
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 01:02:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25600B81BA2
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 08:02:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A7BC3411E;
        Thu,  7 Jul 2022 08:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657180968;
        bh=mkTwEUkN8EwEpQjbJG+R6E161G0v9MVtk5qzw8dNY1M=;
        h=From:To:Cc:Subject:Date:From;
        b=awRtEdnBORIluyJ3CPM+VhTD3NvufI0XZT2H9+6+rUZeR3Du4KEX416pkp5SjbVQz
         NsBccXWvCWSDNGaJF673BaPPaE4yd5Bo1uN2SMdqfbNO/y9ob+/0TLeH6ISGrwIvNM
         G4xq0SbZAq4DL9O+kqt9aRsN/lgFCLQSBzs4Hj/HxkDrzyGWnguoaI0Ji2kxTTZ59n
         NiX7QJST+RSX1vVmId3909YAELeOhJzyInvqDEAfnBd8EQLUKN0ckA26hZSIPn1PUB
         9tlj8Mczh7nD0wUYyD+LYB2VioeW+MJ5CjCGLBfI8yf94FMpTETEtU1shJY/ix6pOL
         R5gnpT31HVluw==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v2] Documentation: add a description for net.core.high_order_alloc_disable
Date:   Thu,  7 Jul 2022 10:02:45 +0200
Message-Id: <20220707080245.180525-1-atenart@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A description is missing for the net.core.high_order_alloc_disable
option in admin-guide/sysctl/net.rst ; add it. The above sysctl option
was introduced by commit ce27ec60648d ("net: add high_order_alloc_disable
sysctl/static key").

Thanks to Eric for running again the benchmark cited in the above
commit, showing this knob is now mostly of historical importance.

Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---

Since v1:
  - Reworked the documentation to mention this knob is now mostly of
    historical importance after Eric ran again the benchmark cited in
    the above commit.

 Documentation/admin-guide/sysctl/net.rst | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index fcd650bdbc7e..805f2281e000 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -391,6 +391,18 @@ GRO has decided not to coalesce, it is placed on a per-NAPI list. This
 list is then passed to the stack when the number of segments reaches the
 gro_normal_batch limit.
 
+high_order_alloc_disable
+------------------------
+
+By default the allocator for page frags tries to use high order pages (order-3
+on x86). While the default behavior gives good results in most cases, some users
+might have hit a contention in page allocations/freeing. This was especially
+true on older kernels (< 5.14) when high-order pages were not stored on per-cpu
+lists. This allows to opt-in for order-0 allocation instead but is now mostly of
+historical importance.
+
+Default: 0
+
 2. /proc/sys/net/unix - Parameters for Unix domain sockets
 ----------------------------------------------------------
 
-- 
2.36.1


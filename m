Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46A054EB98B
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 06:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242558AbiC3E1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 00:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242524AbiC3E1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 00:27:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12053DF6A;
        Tue, 29 Mar 2022 21:25:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D32761515;
        Wed, 30 Mar 2022 04:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BECFC340EE;
        Wed, 30 Mar 2022 04:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648614317;
        bh=K61ZB8eL6+rIPGneJi8e6vZ8cd5Fs9s7rksmt7GGVNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aAYswTubeEK+kZkY2wp9k+iqcR2Q/2P/C6oP4A6gw2ptcWg3Hknv2zNiS2dh/Imkq
         f9thuehkd9RFPKeb6U6XSryVwInkluDLy67SZ5+vTKOP+dEcAKjIuPcdLlFVrAcuh8
         KtoRd2wFbNgbb30DJOzpVlTrCnuCenDq7U64CrRL2n/lT/MvzLaH1iPrENxPDFd5cE
         nfHC1D6RblzAf3EvUQDsB9kLQj4KFpfQluYP11Z36F5vXPJ10NQ/7+cbcq4IoYODHO
         WT3iOJ1rpOewbcU8JDzVKxM95zuxW8KkrLYYbsVAGNi9lwEEUaBvxAhCWDBR8NRcMX
         m387O7qrLs4uQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v3 10/14] docs: netdev: make the testing requirement more stringent
Date:   Tue, 29 Mar 2022 21:25:01 -0700
Message-Id: <20220330042505.2902770-11-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330042505.2902770-1-kuba@kernel.org>
References: <20220330042505.2902770-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These days we often ask for selftests so let's update our
testing requirements.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/networking/netdev-FAQ.rst | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
index f8b89dc81cab..1388f78cfbc5 100644
--- a/Documentation/networking/netdev-FAQ.rst
+++ b/Documentation/networking/netdev-FAQ.rst
@@ -196,11 +196,15 @@ as possible alternative mechanisms.
 
 What level of testing is expected before I submit my change?
 ------------------------------------------------------------
-If your changes are against ``net-next``, the expectation is that you
-have tested by layering your changes on top of ``net-next``.  Ideally
-you will have done run-time testing specific to your change, but at a
-minimum, your changes should survive an ``allyesconfig`` and an
-``allmodconfig`` build without new warnings or failures.
+At the very minimum your changes must survive an ``allyesconfig`` and an
+``allmodconfig`` build with ``W=1`` set without new warnings or failures.
+
+Ideally you will have done run-time testing specific to your change,
+and the patch series contains a set of kernel selftest for
+``tools/testing/selftests/net`` or using the KUnit framework.
+
+You are expected to test your changes on top of the relevant networking
+tree (``net`` or ``net-next``) and not e.g. a stable tree or ``linux-next``.
 
 How do I post corresponding changes to user space components?
 -------------------------------------------------------------
-- 
2.34.1


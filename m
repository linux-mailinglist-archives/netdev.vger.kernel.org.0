Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2383657E63A
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 20:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbiGVSG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 14:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiGVSG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 14:06:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A72182982B;
        Fri, 22 Jul 2022 11:06:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F3DD622DD;
        Fri, 22 Jul 2022 18:06:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B5BC341C6;
        Fri, 22 Jul 2022 18:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658513215;
        bh=3qZhPsUCW3M6g5lJLc7ImRXOgn38VadClP54lmWyOT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JuFwFfn9pqNmL8ZL2uqciYqtG/jn1u7UEEmugHMuVu/0TMAa5xlenJdUsv+VEWKOQ
         +N2WOzi1iE1L5ahl4Ra5yKq5pm2hCN8rXiccyhOMYUg+Sl6pBe+tCqunMLTgSDLnPV
         IHV57IT+iDXAs64697timJzgTU4sSfsckuxAhdPJNFQUlT9sC4FcMCmFJ9HpVujz2G
         qYgNCnh8Cv51hs3W6hsBH72L6bOEo/Lk1ougo5dLiHPifT/zEdagYDYZaxrSud3InO
         E2qG/+AUVI5icg1Qmoy5IZvx+D42suamaWBBFOKEki+CB0DLZwkO3K6R+yEvpqmQXk
         P8CL59mqJ2TTQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 3669D5C005A; Fri, 22 Jul 2022 11:06:55 -0700 (PDT)
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc:     corbet@lwn.net, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, kernel-team@fb.com,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH bpf 2/2] bpf: Update bpf_design_QA.rst to clarify that attaching to functions is not ABI
Date:   Fri, 22 Jul 2022 11:06:41 -0700
Message-Id: <20220722180641.2902585-2-paulmck@kernel.org>
X-Mailer: git-send-email 2.31.1.189.g2e36527f23
In-Reply-To: <20220722180641.2902585-1-paulmck@kernel.org>
References: <20220722180641.2902585-1-paulmck@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch updates bpf_design_QA.rst to clarify that the ability to
attach a BPF program to a given function in the kernel does not make
that function become part of the Linux kernel's ABI.

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
---
 Documentation/bpf/bpf_design_QA.rst | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/bpf/bpf_design_QA.rst b/Documentation/bpf/bpf_design_QA.rst
index 2ed9128cfbec8..46337a60255e9 100644
--- a/Documentation/bpf/bpf_design_QA.rst
+++ b/Documentation/bpf/bpf_design_QA.rst
@@ -279,3 +279,15 @@ cc (congestion-control) implementations.  If any of these kernel
 functions has changed, both the in-tree and out-of-tree kernel tcp cc
 implementations have to be changed.  The same goes for the bpf
 programs and they have to be adjusted accordingly.
+
+Q: Attaching to kernel functions is an ABI?
+-------------------------------------------
+Q: BPF programs can be attached to many kernel functions.  Do these
+kernel functions become part of the ABI?
+
+A: NO.
+
+The kernel function prototypes will change, and BPF programs attaching to
+them will need to change.  The BPF compile-once-run-everywhere (CO-RE)
+should be used in order to make it easier to adapt your BPF programs to
+different versions of the kernel.
-- 
2.31.1.189.g2e36527f23


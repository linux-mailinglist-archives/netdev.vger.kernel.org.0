Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA9F58812B
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 19:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbiHBRjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 13:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiHBRjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 13:39:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7ED4B0D8;
        Tue,  2 Aug 2022 10:39:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B610561237;
        Tue,  2 Aug 2022 17:39:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F530C433D7;
        Tue,  2 Aug 2022 17:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659461955;
        bh=FoyrG1ZSgKJnTOrE1VYOwsrWEx1RrK04H5tFHcdUZVQ=;
        h=From:To:Cc:Subject:Date:From;
        b=TUu4iDrz3DrUo8FNNO8C4m/cOmNQjCSLfHHDce2HS8xmXDvyJ0cnuqkYwXmfQUWS/
         tZSBxAwGWPvOGIZzqYajSRjmwILqxtCfegWY0V7JwkNLxrwpw3xmDQdQujnfZnal7e
         Vo7y8JaxgvRQ/J74Jgku27zQtrGL0nVQvlZNpIpPuei8U5dC4gjy7b62OIDCJ+q9lJ
         TcaAsO6hEmNDHgZ/RKpsmX/FQTOU66UJfNkZdsQa1mmtALo+6ccDhPUwwbJGa//jnt
         cCl+moQlsJe187WTXds2JG9vBJeN75DmFjP1fmCepjDcQ4B0/TtxeyYZZcP/zj7548
         PEJedS7AJdWyg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id B52515C0155; Tue,  2 Aug 2022 10:39:14 -0700 (PDT)
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc:     corbet@lwn.net, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, kernel-team@fb.com,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH v3 bpf 2/3] bpf: Update bpf_design_QA.rst to clarify that attaching to functions is not ABI
Date:   Tue,  2 Aug 2022 10:39:12 -0700
Message-Id: <20220802173913.4170192-2-paulmck@kernel.org>
X-Mailer: git-send-email 2.31.1.189.g2e36527f23
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch updates bpf_design_QA.rst to clarify that the ability to
attach a BPF program to an arbitrary function in the kernel does not
make that function become part of the Linux kernel's ABI.

[ paulmck: Apply Daniel Borkmann feedback. ]

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
---
 Documentation/bpf/bpf_design_QA.rst | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/bpf/bpf_design_QA.rst b/Documentation/bpf/bpf_design_QA.rst
index 2ed9128cfbec8..a06ae8a828e3d 100644
--- a/Documentation/bpf/bpf_design_QA.rst
+++ b/Documentation/bpf/bpf_design_QA.rst
@@ -279,3 +279,15 @@ cc (congestion-control) implementations.  If any of these kernel
 functions has changed, both the in-tree and out-of-tree kernel tcp cc
 implementations have to be changed.  The same goes for the bpf
 programs and they have to be adjusted accordingly.
+
+Q: Attaching to arbitrary kernel functions is an ABI?
+-----------------------------------------------------
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


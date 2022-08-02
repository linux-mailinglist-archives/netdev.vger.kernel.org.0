Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3529C588131
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 19:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232882AbiHBRjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 13:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232109AbiHBRjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 13:39:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3FD64B0F4;
        Tue,  2 Aug 2022 10:39:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C55BB81FE5;
        Tue,  2 Aug 2022 17:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 123B2C433B5;
        Tue,  2 Aug 2022 17:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659461955;
        bh=D+x8CqdaXbsmhEFhqyxFXaNoVxZF5fkQARi2WHcJmQM=;
        h=From:To:Cc:Subject:Date:From;
        b=CaQZluMzk/FwdJj1MolEVOBu/Rep66UaOgD3Casl7Xx0IdzE4yO9ln/B1NjI9AIME
         R9Napl9UmEvg0AdIQeQdsf7m28/sUSpx+uztV6hUD+oYQYoEPes43yPzbyd5Y6CDQc
         0peYZG7TyoRfudw+MKGLgs8mfW+x0AA9OFOCwvCpRAAwTswZ4Rp4CTWONaV8mgRk/z
         ckLQ+bhCf2LWKV6LUpQOzSYYIGUP/H2Hb6+lHygbVyNpgyB6/2hqX3rNdPcaDSGzB8
         nkGuHZjux34Sl75F++zlGRZR13FEEixVWN9suSvMUvitY/Vj2JKg2hpm+Tia9zzEAm
         qikbvp073D8Aw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id B33F05C0369; Tue,  2 Aug 2022 10:39:14 -0700 (PDT)
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc:     corbet@lwn.net, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, kernel-team@fb.com,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH v3 bpf 1/3] bpf: Update bpf_design_QA.rst to clarify that kprobes is not ABI
Date:   Tue,  2 Aug 2022 10:39:11 -0700
Message-Id: <20220802173913.4170192-1-paulmck@kernel.org>
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
attach a BPF program to a given point in the kernel code via kprobes
does not make that attachment point be part of the Linux kernel's ABI.

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
---
 Documentation/bpf/bpf_design_QA.rst | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/bpf/bpf_design_QA.rst b/Documentation/bpf/bpf_design_QA.rst
index 437de2a7a5de7..2ed9128cfbec8 100644
--- a/Documentation/bpf/bpf_design_QA.rst
+++ b/Documentation/bpf/bpf_design_QA.rst
@@ -214,6 +214,12 @@ A: NO. Tracepoints are tied to internal implementation details hence they are
 subject to change and can break with newer kernels. BPF programs need to change
 accordingly when this happens.
 
+Q: Are places where kprobes can attach part of the stable ABI?
+--------------------------------------------------------------
+A: NO. The places to which kprobes can attach are internal implementation
+details, which means that they are subject to change and can break with
+newer kernels. BPF programs need to change accordingly when this happens.
+
 Q: How much stack space a BPF program uses?
 -------------------------------------------
 A: Currently all program types are limited to 512 bytes of stack
-- 
2.31.1.189.g2e36527f23


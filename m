Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0436E4EF447
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 17:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348233AbiDAOx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350009AbiDAOrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:47:05 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB6E2A03C3;
        Fri,  1 Apr 2022 07:36:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7A52ACE258A;
        Fri,  1 Apr 2022 14:36:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3946EC2BBE4;
        Fri,  1 Apr 2022 14:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823810;
        bh=36BEvjQhgTtwogplVLYvptZj3ZgbM6dbvLzk2LibxkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=by23TCql5jWwrlYUnOBdtsxzgJdbm/sJtIw4vSR7DZC7jdGs3deFobzNHVE4BkD6Y
         DtyeiD8TwDCqYqgTW87WvtOPQ4jjJ+p/MbBJ6S6YrmVx6J1BENU9GDvfiXd4pg67Ik
         jWmAehGZimDCUuMnyWV6NLtkbDD7tzJUj2Bd0Cm3Ch3L+Pi+rDDvA/L+kyFA/cgGm7
         oSuWTO527xLR2OQ2UqXMUfQnHcYHWTiIPY26EDR1Wnm0dqvc2BN5Y659kBMuPSR7ir
         axHpHFWLr6f48uFVaPwRJmvhf+3cQpaNjmdIrQhP4ykTzvSPu/OQlHYagBJvAjEQua
         WvF2wEUcNSX+A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        kernel test robot <lkp@intel.com>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Sasha Levin <sashal@kernel.org>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, akpm@linux-foundation.org,
        catalin.marinas@arm.com, anshuman.khandual@arm.com,
        npiggin@gmail.com, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 086/109] powerpc/64e: Tie PPC_BOOK3E_64 to PPC_FSL_BOOK3E
Date:   Fri,  1 Apr 2022 10:32:33 -0400
Message-Id: <20220401143256.1950537-86-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143256.1950537-1-sashal@kernel.org>
References: <20220401143256.1950537-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 1a76e520ee1831a81dabf8a9a58c6453f700026e ]

Since the IBM A2 CPU support was removed, see commit
fb5a515704d7 ("powerpc: Remove platforms/wsp and associated pieces"),
the only 64-bit Book3E CPUs we support are Freescale (NXP) ones.

However our Kconfig still allows configurating a kernel that has 64-bit
Book3E support, but no Freescale CPU support enabled. Such a kernel
would never boot, it doesn't know about any CPUs.

It also causes build errors, as reported by lkp, because
PPC_BARRIER_NOSPEC is not enabled in such a configuration:

  powerpc64-linux-ld: arch/powerpc/net/bpf_jit_comp64.o:(.toc+0x0):
  undefined reference to `powerpc_security_features'

To fix this, force PPC_FSL_BOOK3E to be selected whenever we are
building a 64-bit Book3E kernel.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Suggested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220304061222.2478720-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/Kconfig.cputype | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index a208997ade88..87a95cbff2f3 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -111,6 +111,7 @@ config PPC_BOOK3S_64
 
 config PPC_BOOK3E_64
 	bool "Embedded processors"
+	select PPC_FSL_BOOK3E
 	select PPC_FPU # Make it a choice ?
 	select PPC_SMP_MUXED_IPI
 	select PPC_DOORBELL
@@ -287,7 +288,7 @@ config FSL_BOOKE
 config PPC_FSL_BOOK3E
 	bool
 	select ARCH_SUPPORTS_HUGETLBFS if PHYS_64BIT || PPC64
-	select FSL_EMB_PERFMON
+	imply FSL_EMB_PERFMON
 	select PPC_SMP_MUXED_IPI
 	select PPC_DOORBELL
 	default y if FSL_BOOKE
-- 
2.34.1


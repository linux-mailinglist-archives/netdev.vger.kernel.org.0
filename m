Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADA1344A41
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbhCVQDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:03:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231684AbhCVQDV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 12:03:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5EBC61992;
        Mon, 22 Mar 2021 16:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616429000;
        bh=3vH1tW/3dz/29rKeu66QIybhctPu7u2aaTt+yHw+ixQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VRbsfgY+z8kWvWs+txugnu/XzSTF1os4UBObTbMaVvuShG2tPdw5ChRNTsdoitI1c
         Os5gXEmTV19Hh0dH4sglqm/fSEpSE1o+cdD5mtmVZ292EJ017mpHo8q2zl1C63RDvy
         9IP52tHZwWSskub+gnvqqJxnuA90avLg12n2yst/hTpywQNyH7pGS5SlpLOCg1l1zv
         SC2S1tGwIlfSqI7YXPTsk7il0mAFtLumFo7AO2H+payHYwT3xe1jEFpNJbjQ5KEMrV
         fL6MEJv6J7008Lwon/8167XZUtB/IGdDaiFW7a3KldjWew3Xisi5j0MtsrpiR6liOq
         jy3MXhpKCZK+w==
From:   Arnd Bergmann <arnd@kernel.org>
To:     linux-kernel@vger.kernel.org, Martin Sebor <msebor@gcc.gnu.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Ning Sun <ning.sun@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Simon Kelley <simon@thekelleys.org.uk>,
        James Smart <james.smart@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Anders Larsen <al@alarsen.net>, Tejun Heo <tj@kernel.org>,
        Serge Hallyn <serge@hallyn.com>,
        Imre Deak <imre.deak@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        tboot-devel@lists.sourceforge.net, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, cgroups@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>
Subject: [PATCH 01/11] x86: compressed: avoid gcc-11 -Wstringop-overread warning
Date:   Mon, 22 Mar 2021 17:02:39 +0100
Message-Id: <20210322160253.4032422-2-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210322160253.4032422-1-arnd@kernel.org>
References: <20210322160253.4032422-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

gcc gets confused by the comparison of a pointer to an integer listeral,
with the assumption that this is an offset from a NULL pointer and that
dereferencing it is invalid:

In file included from arch/x86/boot/compressed/misc.c:18:
In function ‘parse_elf’,
    inlined from ‘extract_kernel’ at arch/x86/boot/compressed/misc.c:442:2:
arch/x86/boot/compressed/../string.h:15:23: error: ‘__builtin_memcpy’ reading 64 bytes from a region of size 0 [-Werror=stringop-overread]
   15 | #define memcpy(d,s,l) __builtin_memcpy(d,s,l)
      |                       ^~~~~~~~~~~~~~~~~~~~~~~
arch/x86/boot/compressed/misc.c:283:9: note: in expansion of macro ‘memcpy’
  283 |         memcpy(&ehdr, output, sizeof(ehdr));
      |         ^~~~~~

I could not find any good workaround for this, but as this is only
a warning for a failure during early boot, removing the line entirely
works around the warning.

This should probably get addressed in gcc instead, before 11.1 gets
released.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/x86/boot/compressed/misc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 3a214cc3239f..9ada64e66cb7 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -430,8 +430,6 @@ asmlinkage __visible void *extract_kernel(void *rmode, memptr heap,
 		error("Destination address too large");
 #endif
 #ifndef CONFIG_RELOCATABLE
-	if ((unsigned long)output != LOAD_PHYSICAL_ADDR)
-		error("Destination address does not match LOAD_PHYSICAL_ADDR");
 	if (virt_addr != LOAD_PHYSICAL_ADDR)
 		error("Destination virtual address changed when not relocatable");
 #endif
-- 
2.29.2


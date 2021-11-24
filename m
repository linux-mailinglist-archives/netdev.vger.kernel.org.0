Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E5345B2CD
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 04:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240899AbhKXDxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 22:53:35 -0500
Received: from mail.loongson.cn ([114.242.206.163]:58070 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240892AbhKXDxe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 22:53:34 -0500
Received: from localhost.localdomain (unknown [111.9.175.10])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxeNJ3tp1hx9oAAA--.1299S5;
        Wed, 24 Nov 2021 11:50:23 +0800 (CST)
From:   Huang Pei <huangpei@loongson.cn>
To:     netdev@vger.kernel.org, ambrosehua@gmail.com
Cc:     linux-arch@vger.kernel.org
Subject: [PATCH 3/4] MIPS: use 3-level pgtable for 64KB page size on MIPS_VA_BITS_48
Date:   Wed, 24 Nov 2021 11:50:03 +0800
Message-Id: <20211124035004.7871-4-huangpei@loongson.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211124035004.7871-1-huangpei@loongson.cn>
References: <20211124035004.7871-1-huangpei@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf9DxeNJ3tp1hx9oAAA--.1299S5
X-Coremail-Antispam: 1UD129KBjvdXoWrZFy7JF4DWryrGF15Ar45trb_yoWfCFb_JF
        1UtrWfGr1rGrW8u34aqrWrtF1a93WUWryfCr12gr15u3yS9F13ta1UXa1DZr13Cayq9rWf
        XrWrAry3Cr4ayjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbfAYjsxI4VWkKwAYFVCjjxCrM7AC8VAFwI0_Xr0_Wr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7
        IE14v26r1rM28IrcIa0xkI8VCY1x0267AKxVWUCVW8JwA2ocxC64kIII0Yj41l84x0c7CE
        w4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6x
        kF7I0E14v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE
        c7CjxVAFwI0_Cr1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c
        02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE
        4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc2xSY4AK67AK6r48MxAIw28IcxkI7V
        AKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
        r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUXVWUAwCIc40Y0x0EwIxGrwCI42IY6x
        IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAI
        w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
        0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU5_8n5UUUUU==
X-CM-SenderInfo: xkxd0whshlqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It hangup when booting Loongson 3A1000 with BOTH
CONFIG_PAGE_SIZE_64KB and CONFIG_MIPS_VA_BITS_48, that it turn
out to use 2-level pgtable instead of 3-level. 64KB page size
with 2-level pgtable only cover 42 bits VA, use 3-level pgtable
to cover all 48 bits VA(55 bits)

Fixes: 1e321fa917fb ("MIPS64: Support of at least 48 bits of SEGBITS)
Signed-off-by: Huang Pei <huangpei@loongson.cn>
---
 arch/mips/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index de60ad190057..0215dc1529e9 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -3097,7 +3097,7 @@ config STACKTRACE_SUPPORT
 config PGTABLE_LEVELS
 	int
 	default 4 if PAGE_SIZE_4KB && MIPS_VA_BITS_48
-	default 3 if 64BIT && !PAGE_SIZE_64KB
+	default 3 if 64BIT && (!PAGE_SIZE_64KB || MIPS_VA_BITS_48)
 	default 2
 
 config MIPS_AUTO_PFN_OFFSET
-- 
2.20.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 379836D84F6
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 19:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232795AbjDERaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 13:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232000AbjDERaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 13:30:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D5B5FCC;
        Wed,  5 Apr 2023 10:30:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 744E263D8E;
        Wed,  5 Apr 2023 17:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C881BC433D2;
        Wed,  5 Apr 2023 17:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680715806;
        bh=MTlSWkTVvQnj8bCbTnc5vIL49pqfkTClsa++NdTazCs=;
        h=From:Date:Subject:To:Cc:From;
        b=ra9q1p5bmBMGWpFgB4v4l6pgMweSZ39xkScSBol3GZgeY/cHHHzKh2ngiGKiZuab1
         Q2tiW81XjCEiSpZywmVvCx2jwPIpbpUdGWetARjxtx7IuNk+2vLW/UgKaeOlHx6HaG
         bJmpCr+w0cKAwzpIJPCicRYW64MFIlAmzHjtywCJ9CKKQjZvjVNjoJiwWqFSLQ7cDl
         tzXdjnvs2+3Shtz7WX8kLmFDw3/6tCBkyBzrAUYCvDla9Ny5JCeePSRTr7e62xPpZg
         PNYRoT4Mzwn333ihQj1Ph2GnSXJUQMI/H7rJcaXmdJVi6o0Wmn7JsSFd7DrylGt2kd
         fwasqzz7SlSLQ==
From:   Simon Horman <horms@kernel.org>
Date:   Wed, 05 Apr 2023 19:29:48 +0200
Subject: [PATCH net-next] net: sunhme: move asm includes to below linux
 includes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20230405-sunhme-includes-fix-v1-1-bf17cc5de20d@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAywLWQC/x2NywoCMQxFf2XI2kAdLaK/Ii76SG2gRmmmMjDMv
 xtcnsM93A2UOpPCbdqg05eV32JwPEyQapAnIWdjmN18cmfnUYfUl1lJbWRSLLxi8T7ma8mX4Ap
 YGYMSxh4kVWtltGby08m2/6s7CC0otC7w2PcfiPhXhoQAAAA=
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Sean Anderson <seanga2@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        kernel test robot <lkp@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-m68k@lists.linux-m68k.org
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A recent rearrangement of includes has lead to a problem on m68k
as flagged by the kernel test robot.

Resolve this by moving the block asm includes to below linux includes.
A side effect i that non-Sparc asm includes are now immediately
before Sparc asm includes, which seems nice.

Using sparse v0.6.4 I was able to reproduce this problem as follows
using the config provided by the kernel test robot:

$ wget https://download.01.org/0day-ci/archive/20230404/202304041748.0sQc4K4l-lkp@intel.com/config
$ cp config .config
$ make ARCH=m68k oldconfig
$ make ARCH=m68k C=2 M=drivers/net/ethernet/sun
   CC [M]  drivers/net/ethernet/sun/sunhme.o
 In file included from drivers/net/ethernet/sun/sunhme.c:19:
 ./arch/m68k/include/asm/irq.h:78:11: error: expected ‘;’ before ‘void’
    78 | asmlinkage void do_IRQ(int irq, struct pt_regs *regs);
       |           ^~~~~
       |           ;
 ./arch/m68k/include/asm/irq.h:78:40: warning: ‘struct pt_regs’ declared inside parameter list will not be visible outside of this definition or declaration
    78 | asmlinkage void do_IRQ(int irq, struct pt_regs *regs);
       |                                        ^~~~~~~

Compile tested only.

Fixes: 1ff4f42aef60 ("net: sunhme: Alphabetize includes")
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202304041748.0sQc4K4l-lkp@intel.com/
Signed-off-by: Simon Horman <horms@kernel.org>
---
 drivers/net/ethernet/sun/sunhme.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index ec85aef35bf9..b93613cd1994 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -14,9 +14,6 @@
  *     argument : macaddr=0x00,0x10,0x20,0x30,0x40,0x50
  */
 
-#include <asm/byteorder.h>
-#include <asm/dma.h>
-#include <asm/irq.h>
 #include <linux/bitops.h>
 #include <linux/crc32.h>
 #include <linux/delay.h>
@@ -45,6 +42,10 @@
 #include <linux/types.h>
 #include <linux/uaccess.h>
 
+#include <asm/byteorder.h>
+#include <asm/dma.h>
+#include <asm/irq.h>
+
 #ifdef CONFIG_SPARC
 #include <asm/auxio.h>
 #include <asm/idprom.h>


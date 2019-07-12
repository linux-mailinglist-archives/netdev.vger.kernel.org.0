Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2CED67559
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 21:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbfGLTXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 15:23:53 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:40707 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727226AbfGLTXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 15:23:51 -0400
Received: by mail-qk1-f196.google.com with SMTP id s145so7257620qke.7
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 12:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=nTx5Q1t5rZtAKWvNKqv4EB9nf5UeJFN+8yFT1L6eySw=;
        b=fDcMVGES6+Tam4qkQH1rbV5vSngkrm4Gfv6CSMXyXvOZbujsJS6uf/LdoRmtRqCuKO
         VkAmPvLFIpcjeN89SqK/8+8wZrls3RovYxZbRn2iCT/V+ZdCoQLoA8ySXtWQMxW+ndR0
         6Gblv8mS3osSLqglsrrm5QPPbm80CkqphcATpprJaZbO9aQ95sOGkhB6Wq4RbXcUVwtA
         EuJUgk63IQN8+V67/ceHDhPxQuUR1uZ9NP8pKSXZ8BD3cn3CM1BP4Pk7b8iWsBoKXtaJ
         uaFKEtJnxDUTtHk8ebCIOl7uGx/Rd5FJiLCr3BeECuoL+PBAAS/IA4LxRlqgF/J0LEq4
         VNvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nTx5Q1t5rZtAKWvNKqv4EB9nf5UeJFN+8yFT1L6eySw=;
        b=fcXos+RgML4KD/q1arPOu75lcA+SVMP5AG1aoU0l58m9GenCojksIjSJ2/OeFwG2bE
         UgJhTk4gUIdGXAy8PzWct62LlfR78d3S/FIixQrFnivgYobAzgxwvy/1RcgujCAUuYVK
         GrbLx/ymlhc4FrgqMpQ7LS4nloCl2D21aFJ2M7MH9CvqkcQwWjYe+R9BAq91JHClcDU8
         W1xxeyIUcxzut1DwAUSbF1xJrXznV08djTecnNQ63KtaUNiZ8Cei8eUthuXs3SzrM4UD
         wCpEvhJT0gWcyWZNnccUrPeMZeoWg4E64CiIVORPZOp+FS66yFgXULReMY/V13VmGdVe
         QvVA==
X-Gm-Message-State: APjAAAV4IMwDhMAO+AToJiP267C+jrE6VG1rpn6uqK4Jn7Gc7TLN9QNL
        KiCApjYYgwrcffL6hukL/CNYBA==
X-Google-Smtp-Source: APXvYqxEArSBk4tR0zWDSzipAUCLfBRT1wLTWFgthk8YozROg1saOVewdsZdhpftywRfgMu/S7X0tA==
X-Received: by 2002:ae9:e217:: with SMTP id c23mr7455726qkc.227.1562959430223;
        Fri, 12 Jul 2019 12:23:50 -0700 (PDT)
Received: from qcai.nay.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id b4sm3589339qtp.77.2019.07.12.12.23.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Jul 2019 12:23:49 -0700 (PDT)
From:   Qian Cai <cai@lca.pw>
To:     davem@davemloft.net
Cc:     sathya.perla@broadcom.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        arnd@arndb.de, dhowells@redhat.com, hpa@zytor.com,
        netdev@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>
Subject: [PATCH] be2net: fix adapter->big_page_size miscaculation
Date:   Fri, 12 Jul 2019 15:23:21 -0400
Message-Id: <1562959401-19815-1-git-send-email-cai@lca.pw>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit d66acc39c7ce ("bitops: Optimise get_order()") introduced a
problem for the be2net driver as "rx_frag_size" could be a module
parameter that can be changed while loading the module. That commit
checks __builtin_constant_p() first in get_order() which cause
"adapter->big_page_size" to be assigned a value based on the
the default "rx_frag_size" value at the compilation time. It also
generate a compilation warning,

In file included from ./arch/powerpc/include/asm/page_64.h:107,
                 from ./arch/powerpc/include/asm/page.h:242,
                 from ./arch/powerpc/include/asm/mmu.h:132,
                 from ./arch/powerpc/include/asm/lppaca.h:47,
                 from ./arch/powerpc/include/asm/paca.h:17,
                 from ./arch/powerpc/include/asm/current.h:13,
                 from ./include/linux/thread_info.h:21,
                 from ./arch/powerpc/include/asm/processor.h:39,
                 from ./include/linux/prefetch.h:15,
                 from drivers/net/ethernet/emulex/benet/be_main.c:14:
drivers/net/ethernet/emulex/benet/be_main.c: In function
'be_rx_cqs_create':
./include/asm-generic/getorder.h:54:9: warning: comparison is always
true due to limited range of data type [-Wtype-limits]
   (((n) < (1UL << PAGE_SHIFT)) ? 0 :  \
         ^
drivers/net/ethernet/emulex/benet/be_main.c:3138:33: note: in expansion
of macro 'get_order'
  adapter->big_page_size = (1 << get_order(rx_frag_size)) * PAGE_SIZE;
                                 ^~~~~~~~~

Fix it by using __get_order() instead which will calculate in runtime.

Fixes: d66acc39c7ce ("bitops: Optimise get_order()")
Signed-off-by: Qian Cai <cai@lca.pw>
---
 drivers/net/ethernet/emulex/benet/be_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 82015c8a5ed7..db13e714df7c 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -3135,7 +3135,7 @@ static int be_rx_cqs_create(struct be_adapter *adapter)
 	if (adapter->num_rx_qs == 0)
 		adapter->num_rx_qs = 1;
 
-	adapter->big_page_size = (1 << get_order(rx_frag_size)) * PAGE_SIZE;
+	adapter->big_page_size = (1 << __get_order(rx_frag_size)) * PAGE_SIZE;
 	for_all_rx_queues(adapter, rxo, i) {
 		rxo->adapter = adapter;
 		cq = &rxo->cq;
-- 
1.8.3.1


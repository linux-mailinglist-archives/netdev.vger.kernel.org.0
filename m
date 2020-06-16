Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5314F1FB90A
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 18:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730949AbgFPQAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 12:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732809AbgFPPws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 11:52:48 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4004EC06174E
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 08:52:47 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id i12so1630550pju.3
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 08:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=bLqkpKmEFdo50WG+lxFzSE/gPYomjAyXGtI7bY1gfcc=;
        b=ihA17bLiTDCpfMxM/wM2fbkUDeO1dPfwLluAAyO4L1Enjjf2SYHM82u5c3n91FCyiz
         bM2hx3iZbJi/VGKITOmDiKP+NTlw+UbEli8ddWq3bfgpvdTDdZa4v3DBvL7EtVBgFSx1
         H/3UcGpuHPIcvjs/0lb0BjmKxRBFo8l8N7hrf6bZBP3mqsGlZ6xmgFOZVaZxhTfA4ebu
         4n9GYwCPpL1E/va3/8f0Dwe/fxl7u4UP2v0dh+pUWgJIxLoUV1mzj+H1k5FrU5cMuKw1
         hW0NojZEeEpCNikcw58HHcF5PNWfH1z2TlTgPHxz7YTFAvzCC7V3OgNpgS8ONtqt2FKf
         1DJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bLqkpKmEFdo50WG+lxFzSE/gPYomjAyXGtI7bY1gfcc=;
        b=Yo6df8ak+OS6tINBiQSB3rcZQp1bJyxpnWuGvnAfNDLuVUj1bspfk4k7gspjkXXBcl
         lDnWRAtk4mnYHpmT8ViYj08QdIKU1/5xQieaPNs/gQ8/N2MstFluFudcWbCRcKHxa3aq
         V6avJqPEgcz/78WkZqUZgYPSWe/EBwvkWhx2XHN9YrES1eYHRRAnR6tXlLi9OG+FSqWA
         CWQwkJWTY4ojZJA8QaEGEoLVXEKdO3ICoG2JrMAODxw/zeBAnruO2wbg5YdjswcZAbBs
         GjBK4wiG0VjImJgjP9JqY4hIWYpCEj6bcWX0A7U/oaQrHcKgwdgTR9QsnQtCSxzPis7F
         iC5Q==
X-Gm-Message-State: AOAM533OWXy7wSsfP3h7h4PIGK24I+/QeazIGZKYtnO6tUUPuX4H50yA
        5pa+A3OUM2c0dChBlNmGvHw=
X-Google-Smtp-Source: ABdhPJy2WlaPpdNyF1/xcr14rYQEcLTufKNAso9Yw0EX9HZYGb9OCn6vluAxC5dBaeNbZNGpWJA7WQ==
X-Received: by 2002:a17:902:7288:: with SMTP id d8mr2736927pll.18.1592322766555;
        Tue, 16 Jun 2020 08:52:46 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id o20sm2872411pjw.19.2020.06.16.08.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 08:52:45 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, fw@strlen.de
Subject: [PATCH net v2] net: core: reduce recursion limit value
Date:   Tue, 16 Jun 2020 15:52:05 +0000
Message-Id: <20200616155205.8276-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the current code, ->ndo_start_xmit() can be executed recursively only
10 times because of stack memory.
But, in the case of the vxlan, 10 recursion limit value results in
a stack overflow.
In the current code, the nested interface is limited by 8 depth.
There is no critical reason that the recursion limitation value should
be 10.
So, it would be good to be the same value with the limitation value of
nesting interface depth.

Test commands:
    ip link add vxlan10 type vxlan vni 10 dstport 4789 srcport 4789 4789
    ip link set vxlan10 up
    ip a a 192.168.10.1/24 dev vxlan10
    ip n a 192.168.10.2 dev vxlan10 lladdr fc:22:33:44:55:66 nud permanent

    for i in {9..0}
    do
        let A=$i+1
	ip link add vxlan$i type vxlan vni $i dstport 4789 srcport 4789 4789
	ip link set vxlan$i up
	ip a a 192.168.$i.1/24 dev vxlan$i
	ip n a 192.168.$i.2 dev vxlan$i lladdr fc:22:33:44:55:66 nud permanent
	bridge fdb add fc:22:33:44:55:66 dev vxlan$A dst 192.168.$i.2 self
    done
    hping3 192.168.10.2 -2 -d 60000

Splat looks like:
[  103.814237][ T1127] =============================================================================
[  103.871955][ T1127] BUG kmalloc-2k (Tainted: G    B            ): Padding overwritten. 0x00000000897a2e4f-0x000
[  103.873187][ T1127] -----------------------------------------------------------------------------
[  103.873187][ T1127]
[  103.874252][ T1127] INFO: Slab 0x000000005cccc724 objects=5 used=5 fp=0x0000000000000000 flags=0x10000000001020
[  103.881323][ T1127] CPU: 3 PID: 1127 Comm: hping3 Tainted: G    B             5.7.0+ #575
[  103.882131][ T1127] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  103.883006][ T1127] Call Trace:
[  103.883324][ T1127]  dump_stack+0x96/0xdb
[  103.883716][ T1127]  slab_err+0xad/0xd0
[  103.884106][ T1127]  ? _raw_spin_unlock+0x1f/0x30
[  103.884620][ T1127]  ? get_partial_node.isra.78+0x140/0x360
[  103.885214][ T1127]  slab_pad_check.part.53+0xf7/0x160
[  103.885769][ T1127]  ? pskb_expand_head+0x110/0xe10
[  103.886316][ T1127]  check_slab+0x97/0xb0
[  103.886763][ T1127]  alloc_debug_processing+0x84/0x1a0
[  103.887308][ T1127]  ___slab_alloc+0x5a5/0x630
[  103.887765][ T1127]  ? pskb_expand_head+0x110/0xe10
[  103.888265][ T1127]  ? lock_downgrade+0x730/0x730
[  103.888762][ T1127]  ? pskb_expand_head+0x110/0xe10
[  103.889244][ T1127]  ? __slab_alloc+0x3e/0x80
[  103.889675][ T1127]  __slab_alloc+0x3e/0x80
[  103.890108][ T1127]  __kmalloc_node_track_caller+0xc7/0x420
[ ... ]

Fixes: 11a766ce915f ("net: Increase xmit RECURSION_LIMIT to 10.")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2:
 - Fix a fix tag.

 include/linux/netdevice.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 6fc613ed8eae..39e28e11863c 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3157,7 +3157,7 @@ static inline int dev_recursion_level(void)
 	return this_cpu_read(softnet_data.xmit.recursion);
 }
 
-#define XMIT_RECURSION_LIMIT	10
+#define XMIT_RECURSION_LIMIT	8
 static inline bool dev_xmit_recursion(void)
 {
 	return unlikely(__this_cpu_read(softnet_data.xmit.recursion) >
-- 
2.17.1


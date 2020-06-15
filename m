Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E45F1F9B3D
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 17:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730867AbgFOPAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 11:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730837AbgFOPAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 11:00:49 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35B6C061A0E
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 08:00:49 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id j4so3660576plk.3
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 08:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=OMfttUy/5IocKcBbx3rNd1AnpbGarBSG88rQT+CJeXA=;
        b=pYx7HVrGviwRqwufu1SnRri0V9QZWirdp1P5t8amxLh4VBj4S/F2Np8+RAXcPL0EpI
         LA+TSYBx2sJCq/JR5QHAHWcMVSIfrUIEhWPeV1v/7rzaD5+3bt0SCfP2OT3UtugHVFln
         +AvaLmvK0dd4o2WznHjweKCUPOfgCB/1FxGpl+nD+8fdvBFJwIWx4QO03buMPNzg5wEH
         nQq7GPtR8l3nAsmQNUvriBnhgxJMYrHKJUNsGFqfG+3VD9muElh6b/xyY59jKJBUZAC0
         DvzjmdTSYfCaEDgLEMsVVT/FI982F3MzO+bvigd53sYjFCQ74dOOUIXcLx1k9uxM2w6L
         AFuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=OMfttUy/5IocKcBbx3rNd1AnpbGarBSG88rQT+CJeXA=;
        b=UDPgQROJbehf1T6FN7MW6FzhrlPqpgaS+FQAY+eS3sa9k5DSAPKJp79lRdnfmbB7wl
         HXy4NgK5vsHnwHGysVm9E+TghhA5+/iKXEjTkkiIYWBLZcrREK/0WasaRthHMJTkK7bC
         W5X7KQBXAWjjQd4haMDAD0cL4Ykt7oResCkyetMGrfhYQf9zVtCcex1I0HrISOKf53vZ
         B8gEAiSzk6gRg+0QlQn4H2VeBxWJ8OtmbKAhxIoDpstSAYEmi2pXMqWE1rGxOJG8Nfbp
         6J2GaY47RohJ/nRdvWXp5gb/cLN2p2o0DqU6+2JSxxwj/kMLOkz4HwsWyukDWXhs8y1V
         kK/Q==
X-Gm-Message-State: AOAM532CbtqOv6H3Xtc4GM0qtOyH1i2zRpOpezhhlt7ypX49YIkbW6Qd
        4VkLL33v/MFg3hHvaZeRRqk=
X-Google-Smtp-Source: ABdhPJz94/v3al6/mq546pAc+jbFpEGdI8DT6MVYG1A9wtKx1j70YcIqbIDMOfThn5ln/a9tvlSWQw==
X-Received: by 2002:a17:90a:224a:: with SMTP id c68mr11666514pje.21.1592233249125;
        Mon, 15 Jun 2020 08:00:49 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id r3sm12341434pjj.21.2020.06.15.08.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 08:00:46 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, fw@strlen.de
Subject: [PATCH net] net: core: reduce recursion limit value
Date:   Mon, 15 Jun 2020 15:00:37 +0000
Message-Id: <20200615150037.21529-1-ap420073@gmail.com>
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

Fixes: 97cdcf37b57e ("net: place xmit recursion in softnet data")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
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


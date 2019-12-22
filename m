Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A19ED128D91
	for <lists+netdev@lfdr.de>; Sun, 22 Dec 2019 12:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbfLVLZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Dec 2019 06:25:36 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:35528 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbfLVLZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Dec 2019 06:25:36 -0500
Received: by mail-pj1-f68.google.com with SMTP id s7so6192023pjc.0
        for <netdev@vger.kernel.org>; Sun, 22 Dec 2019 03:25:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=f85zuiU7heTyCOlzAIJ/zBASRW8Q92ZyTqi3NnxjndY=;
        b=b8yfoJNcXiYriU3cD5n73EquGm0NKvR0NocOQlr2CVQxeBELyVHQuuSok4VeamMaZD
         /vbyAu4d2NlWgACG03OLhhNCJmkfawMhaOyjybnrZ8zI1Uvg+tOaFsirOOPfv+ykkRsv
         seC05D2YUrtG5m7oVGAZd4xDRP+U0XNgmvCITQZA4AcduGXWLi1N6dHa5llLJAxJOAXR
         SaOIQkm6WAsN6SQz2xFEQDZxiHnLNUKLp3T/aCAXtfIjmpTI5tdgFALAudSvT7CdFZFh
         EV0JuENxRoWvIlOqvs6upWXYe3YAyeLCKhI7f+kPdLb5tp1toGVPRvirQM6/DoxPBbdV
         jdSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=f85zuiU7heTyCOlzAIJ/zBASRW8Q92ZyTqi3NnxjndY=;
        b=hKVVdYlC4wVLTiCUXI38Jg4r3jAVMPZtbxG4MFuLZpnY+duBmxZfogBCZVCCVJofjk
         dPtWD5ALnPUNnk7v+h3BrwrELB19ysLkfvTAm6oavz1Eeu2mXEamoGduyYC7dgH+red4
         6whF4uryItq341BQ/dbpbe6eLu8qXnXUofdiTt66aUvswjgih7jZcd35mkcGdqUqWY9P
         /bziqvJOqC7FJ/OsnGzZO66p8+PCUbsjbPV6CQnrLZz+8msh8VHQ0K42+gSsSVFLfAXf
         GNF7WSsVj+w01To54HzWDOqQfxixBbkn1Ofmj7wskcn6rHZxpArMbLaYR8upWT9gAAma
         H8Pg==
X-Gm-Message-State: APjAAAWnKEIjHdq9ShaLUSMFeCf6oHvkXD/8T+pulaLPfhd0LmIOY6fH
        WkWGzA2D2GU7Lx+wWhdsE9s=
X-Google-Smtp-Source: APXvYqx3TtsjUtENybEWmpiFNEzP7uowSG/J22pg5/7YWEAiBSc95xr4djmLvndxU6L2ENGQFR2ctw==
X-Received: by 2002:a17:90a:d78f:: with SMTP id z15mr28065149pju.36.1577013935382;
        Sun, 22 Dec 2019 03:25:35 -0800 (PST)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id j38sm18216824pgj.27.2019.12.22.03.25.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Dec 2019 03:25:34 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, arvid.brodin@alten.se,
        jakub.kicinski@netronome.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 1/6] hsr: avoid debugfs warning message when module is remove
Date:   Sun, 22 Dec 2019 11:25:27 +0000
Message-Id: <20191222112527.2990-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When hsr module is being removed, debugfs_remove() is called to remove
both debugfs directory and file.

When module is being removed, module state is changed to
MODULE_STATE_GOING then exit() is called.
At this moment, module couldn't be held so try_module_get()
will be failed.

debugfs's open() callback tries to hold the module if .owner is existing.
If it fails, warning message is printed.

CPU0				CPU1
delete_module()
    try_stop_module()
    hsr_exit()			open() <-- WARNING
        debugfs_remove()

In order to avoid the warning message, this patch makes hsr module does
not set .owner. Unsetting .owner is safe because these are protected by
inode_lock().

Test commands:
    #SHELL1
    ip link add dummy0 type dummy
    ip link add dummy1 type dummy
    while :
    do
        ip link add hsr0 type hsr slave1 dummy0 slave2 dummy1
	modprobe -rv hsr
    done

    #SHELL2
    while :
    do
        cat /sys/kernel/debug/hsr0/node_table
    done

Splat looks like:
[  101.223783][ T1271] ------------[ cut here ]------------
[  101.230309][ T1271] debugfs file owner did not clean up at exit: node_table
[  101.230380][ T1271] WARNING: CPU: 3 PID: 1271 at fs/debugfs/file.c:309 full_proxy_open+0x10f/0x650
[  101.233153][ T1271] Modules linked in: hsr(-) dummy veth openvswitch nsh nf_conncount nf_nat nf_conntrack nf_d]
[  101.237112][ T1271] CPU: 3 PID: 1271 Comm: cat Tainted: G        W         5.5.0-rc1+ #204
[  101.238270][ T1271] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  101.240379][ T1271] RIP: 0010:full_proxy_open+0x10f/0x650
[  101.241166][ T1271] Code: 48 c1 ea 03 80 3c 02 00 0f 85 c1 04 00 00 49 8b 3c 24 e8 04 86 7e ff 84 c0 75 2d 4c 8
[  101.251985][ T1271] RSP: 0018:ffff8880ca22fa38 EFLAGS: 00010286
[  101.273355][ T1271] RAX: dffffc0000000008 RBX: ffff8880cc6e6200 RCX: 0000000000000000
[  101.274466][ T1271] RDX: 0000000000000000 RSI: 0000000000000006 RDI: ffff8880c4dd5c14
[  101.275581][ T1271] RBP: 0000000000000000 R08: fffffbfff2922f5d R09: 0000000000000000
[  101.276733][ T1271] R10: 0000000000000001 R11: 0000000000000000 R12: ffffffffc0551bc0
[  101.277853][ T1271] R13: ffff8880c4059a48 R14: ffff8880be50a5e0 R15: ffffffff941adaa0
[  101.278956][ T1271] FS:  00007f8871cda540(0000) GS:ffff8880da800000(0000) knlGS:0000000000000000
[  101.280216][ T1271] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  101.282832][ T1271] CR2: 00007f88717cfd10 CR3: 00000000b9440005 CR4: 00000000000606e0
[  101.283974][ T1271] Call Trace:
[  101.285328][ T1271]  do_dentry_open+0x63c/0xf50
[  101.286077][ T1271]  ? open_proxy_open+0x270/0x270
[  101.288271][ T1271]  ? __x64_sys_fchdir+0x180/0x180
[  101.288987][ T1271]  ? inode_permission+0x65/0x390
[  101.289682][ T1271]  path_openat+0x701/0x2810
[  101.290294][ T1271]  ? path_lookupat+0x880/0x880
[  101.290957][ T1271]  ? check_chain_key+0x236/0x5d0
[  101.291676][ T1271]  ? __lock_acquire+0xdfe/0x3de0
[  101.292358][ T1271]  ? sched_clock+0x5/0x10
[  101.292962][ T1271]  ? sched_clock_cpu+0x18/0x170
[  101.293644][ T1271]  ? find_held_lock+0x39/0x1d0
[  101.305616][ T1271]  do_filp_open+0x17a/0x270
[  101.306061][ T1271]  ? may_open_dev+0xc0/0xc0
[ ... ]

Fixes: fc4ecaeebd26 ("net: hsr: add debugfs support for display node list")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/hsr/hsr_debugfs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/hsr/hsr_debugfs.c b/net/hsr/hsr_debugfs.c
index 94447974a3c0..6135706f03d5 100644
--- a/net/hsr/hsr_debugfs.c
+++ b/net/hsr/hsr_debugfs.c
@@ -64,7 +64,6 @@ hsr_node_table_open(struct inode *inode, struct file *filp)
 }
 
 static const struct file_operations hsr_fops = {
-	.owner	= THIS_MODULE,
 	.open	= hsr_node_table_open,
 	.read	= seq_read,
 	.llseek = seq_lseek,
-- 
2.17.1


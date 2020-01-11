Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDA35138279
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 17:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730423AbgAKQhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 11:37:37 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44934 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729957AbgAKQhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 11:37:36 -0500
Received: by mail-pg1-f193.google.com with SMTP id x7so2515449pgl.11
        for <netdev@vger.kernel.org>; Sat, 11 Jan 2020 08:37:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=9RB2MYKfwXEHx4e0SSOiacv8L/wL9ZKWzh/vfX16f5Q=;
        b=bwzbul2RgLRnIJspiUV1K4mlh2ovbMpnT7i7w13uhhTDBfCpiUtQrIdZtrfAZzkTlj
         dKgEMlYpgf/BUmCYdRkaRRKKpLgYqtK3zzkfFqIa8wGT0e4JJgsz63WUhR6uJeVPbjmC
         5LDwMvHW9u2tUxWQ9HwcLSZO5FVR8nl2xSRpz0F/ZftknuAI8UVpbbY4VrAmd2vSfYDn
         T8KjkAJ4vNFHdMK3rLLtBzMnQhFr5BrXXiB+8lEBxTo9MdGlsGCB70Kx71Sjp0X4vQnQ
         ttP+TUSLLK8b1+fc+Tyf/ER5lkNu2MB+ag3Q0GV0BLGH6NCoe7vB2s/5EqqCaM2drfWi
         F82Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9RB2MYKfwXEHx4e0SSOiacv8L/wL9ZKWzh/vfX16f5Q=;
        b=TYefY0AYYcD4Qz/uyrrb4kAeVr6iNWshICjht7Jc8h8JdAjn1rq5Tdvzkpe+Dtx+ge
         MofYg7dxpn7PG1BtmIq4nzQzhopCC/QjSa3GHEFrbGOEui/hBCrNDjVWBHzYOrRZAuwC
         yXTTzijcnddpf0I4AM4BJTkE7eXs0e9eu8rS01ivFaIdLlLPUesk3aN5VI/tu3cMmoUh
         bNlR8jv7rqQ3Qe5xK6ftQ1Db1CIbBKz9oqdVGyac8ZanXyCgr0dRq16D3r14+YeWSoCR
         bsCEhSqnDYKEC2XNvBL2ENCCSGKOlcnxwkwhf49CfGjQKe90g6Gy6Iv2OxYNuTdIci2w
         16Bg==
X-Gm-Message-State: APjAAAVUZjAnuy+naRdP0YNwXBRDlMUjOnSO7cXex84qVs33B/4BPxDt
        WwbnE8Pei/ESvBIMPtMWcT8fEtO7
X-Google-Smtp-Source: APXvYqzFhJ87HcwP0dwbvbGk+ItugoZG1NUCkguQQ6AJyH9I22yozrTr0AxcK8H6G4DkXB9MpL5KOA==
X-Received: by 2002:a63:4664:: with SMTP id v36mr11740040pgk.147.1578760655401;
        Sat, 11 Jan 2020 08:37:35 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id ep12sm7024055pjb.7.2020.01.11.08.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jan 2020 08:37:34 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 3/5] netdevsim: avoid debugfs warning message when module is remove
Date:   Sat, 11 Jan 2020 16:37:23 +0000
Message-Id: <20200111163723.4260-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When module is being removed, it couldn't be held by try_module_get().
debugfs's open function internally tries to hold file_operation->owner
if .owner is set.
If holding owner operation is failed, it prints a warning message.

Test commands:
    #SHELL1
    while :
    do
        modprobe netdevsim
        echo 1 > /sys/bus/netdevsim/new_device
        modprobe -rv netdevsim
    done

    #SHELL2
    while :
    do
        cat /sys/kernel/debug/netdevsim/netdevsim1/ports/0/ipsec
    done

Splat looks like:
[  412.227709][ T1720] debugfs file owner did not clean up at exit: ipsec
[  412.227728][ T1720] WARNING: CPU: 3 PID: 1720 at fs/debugfs/file.c:309 full_proxy_open+0x10f/0x650
[  412.231755][ T1720] Modules linked in: netdevsim(-) veth openvswitch nsh nf_conncount nf_nat nf_conntrack nf_d]
[  412.236495][ T1720] CPU: 3 PID: 1720 Comm: cat Tainted: G    B   W         5.5.0-rc5+ #270
[  412.237468][ T1720] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  412.239480][ T1720] RIP: 0010:full_proxy_open+0x10f/0x650
[  412.240321][ T1720] Code: 48 c1 ea 03 80 3c 02 00 0f 85 c1 04 00 00 49 8b 3c 24 e8 24 fb 78 ff 84 c0 75 2d 4c 8
[  412.247099][ T1720] RSP: 0018:ffff8880c9787a38 EFLAGS: 00010286
[  412.247905][ T1720] RAX: dffffc0000000008 RBX: ffff8880ccb94b80 RCX: ffffffff912c2234
[  412.248961][ T1720] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff93d6dcf4
[  412.252583][ T1720] RBP: 0000000000000000 R08: fffffbfff2722f5d R09: fffffbfff2722f5d
[  412.253677][ T1720] R10: 0000000000000001 R11: fffffbfff2722f5c R12: ffffffffc02a7a80
[  412.258939][ T1720] R13: ffff8880acd07728 R14: ffff8880ae9a9b60 R15: ffffffff931b3b60
[  412.260021][ T1720] FS:  00007f24a0b9c540(0000) GS:ffff8880da800000(0000) knlGS:0000000000000000
[  412.261208][ T1720] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  412.262131][ T1720] CR2: 0000561898255068 CR3: 00000000c6a6c004 CR4: 00000000000606e0
[  412.263201][ T1720] Call Trace:
[  412.263650][ T1720]  do_dentry_open+0x63c/0xf50
[  412.264304][ T1720]  ? open_proxy_open+0x270/0x270
[  412.265015][ T1720]  ? __x64_sys_fchdir+0x180/0x180
[  412.265708][ T1720]  ? inode_permission+0x65/0x390
[  412.266566][ T1720]  path_openat+0x701/0x2810
[  412.267445][ T1720]  ? save_stack+0x69/0x80
[  412.268288][ T1720]  ? path_lookupat+0x880/0x880
[  412.269218][ T1720]  ? getname_flags+0xba/0x500
[  412.270556][ T1720]  ? do_sys_open+0x15d/0x350
[  412.271195][ T1720]  ? do_syscall_64+0x99/0x4f0
[  412.271843][ T1720]  ? entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  412.272676][ T1720]  ? _raw_spin_unlock+0x1f/0x30
[  412.273349][ T1720]  ? deactivate_slab.isra.77+0x62e/0x800
[  412.274149][ T1720]  ? check_object+0xaf/0x260
[  412.274784][ T1720]  ? init_object+0x6b/0x80
[  412.275385][ T1720]  do_filp_open+0x17a/0x270
[ ... ]

In order to avoid the warning message, this patch makes netdevsim module
does not set .owner. Unsetting .owner is safe because these are protected
by inode_lock().

Fixes: 7699353da875 ("netdevsim: add ipsec offload testing")
Fixes: 31d3ad832948 ("netdevsim: add bpf offload support")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/netdevsim/bpf.c   | 13 ++++++++++++-
 drivers/net/netdevsim/ipsec.c |  1 -
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/netdevsim/bpf.c b/drivers/net/netdevsim/bpf.c
index 2b74425822ab..13e17c82d71c 100644
--- a/drivers/net/netdevsim/bpf.c
+++ b/drivers/net/netdevsim/bpf.c
@@ -57,7 +57,18 @@ static int nsim_bpf_string_show(struct seq_file *file, void *data)
 
 	return 0;
 }
-DEFINE_SHOW_ATTRIBUTE(nsim_bpf_string);
+
+static int nsim_debugfs_bpf_string_open(struct inode *inode, struct file *f)
+{
+	return single_open(f, nsim_bpf_string_show, inode->i_private);
+}
+
+static const struct file_operations nsim_bpf_string_fops = {
+	.open = nsim_debugfs_bpf_string_open,
+	.release = single_release,
+	.read = seq_read,
+	.llseek = seq_lseek
+};
 
 static int
 nsim_bpf_verify_insn(struct bpf_verifier_env *env, int insn_idx, int prev_insn)
diff --git a/drivers/net/netdevsim/ipsec.c b/drivers/net/netdevsim/ipsec.c
index e27fc1a4516d..63aff6399d11 100644
--- a/drivers/net/netdevsim/ipsec.c
+++ b/drivers/net/netdevsim/ipsec.c
@@ -60,7 +60,6 @@ static ssize_t nsim_dbg_netdev_ops_read(struct file *filp,
 }
 
 static const struct file_operations ipsec_dbg_fops = {
-	.owner = THIS_MODULE,
 	.open = simple_open,
 	.read = nsim_dbg_netdev_ops_read,
 };
-- 
2.17.1


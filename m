Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7E9212AD0
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 19:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgGBRG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 13:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbgGBRG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 13:06:27 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E4FC08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 10:06:27 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id gc9so6208144pjb.2
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 10:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=LiJMulPW6RHFbDM7IbLG+5ngw6dvlZQmPtaY+SLNCtE=;
        b=LScdODeezQPJ7NdNfkdkvGqO8tlHFtE4t2hL7KqkwlnYyCe/63dfdaI3d3n+K+Mnw4
         lE0OZ0FF1XK+9lh80HEDC8TfHSFVi97RWL4cgegNk03q8Rk4A9QyhyoixVH5N1OJWQ6I
         2MTeQkn0BRupmdN3RbQ8tdCCM/xLgTuckNvb1J+2WV1uQsV6khXz5G+smslEhEEfPliM
         Dr9At6Lsg5UXfoUZUl2SIcMqtnnYgavQPHwKY/G7DRtQ/6MIyrYoxJybowuR1W58XsOa
         C9nomuP0vnE2PhjRgO8CRNJCJZJrGSCtX49uxlLDCw5m2swX/75cD/2muoSbXHItG4V9
         +LMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=LiJMulPW6RHFbDM7IbLG+5ngw6dvlZQmPtaY+SLNCtE=;
        b=XYCOijSLrgMl57f4+ZZCOpoXRidI12KXIlVE/To/j7a55Aam1ZJaBusDwcALOu5Mjr
         6CiBamQe5m5jjNoBpbUg0e78JSN9cUGgAiK96Smxb6Napg9jJMrVrUfgpLe4jHrm/Sm6
         Mv2jEZ0pk0gH2dBXlwZqi2ebvxvYIIMsiqZQRZwiUf1ggBj2YyGvWkBFW2ep/xsdVMVw
         K1+GK98oCJu8sWQOsj3GavoVr0Kxc3g16gQzqdNLGdznvOtbc7KSKIcQc5kVMfU0MDtk
         3qpOhciOPDKI4JOAV8E9emJaccTxW1/CMwCHOvoPHR6/Ufjk7QOhFoy1ByZC6RM7G44R
         i8qw==
X-Gm-Message-State: AOAM530kNhCNRCXiz+G97KjV07dqpFJH7qOrs1GAbHOiKFCm25vxdoc4
        a8CTaEgfxMl56BhuylJeF3/nupJA
X-Google-Smtp-Source: ABdhPJw+GEzOZcMl4klqAf7o886mlE2dT0lyC4YjCh6kpXr5SC6dPYUIRehlQeiPsju46eHJ1jJ9WA==
X-Received: by 2002:a17:90a:f18c:: with SMTP id bv12mr3355365pjb.15.1593709586713;
        Thu, 02 Jul 2020 10:06:26 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id ia13sm8278398pjb.42.2020.07.02.10.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 10:06:25 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net] hsr: fix interface leak in error path of hsr_dev_finalize()
Date:   Thu,  2 Jul 2020 17:06:19 +0000
Message-Id: <20200702170619.10378-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To release hsr(upper) interface, it should release
its own lower interfaces first.
Then, hsr(upper) interface can be released safely.
In the current code of error path of hsr_dev_finalize(), it releases hsr
interface before releasing a lower interface.
So, a warning occurs, which warns about the leak of lower interfaces.
In order to fix this problem, changing the ordering of the error path of
hsr_dev_finalize() is needed.

Test commands:
    ip link add dummy0 type dummy
    ip link add dummy1 type dummy
    ip link add dummy2 type dummy
    ip link add hsr0 type hsr slave1 dummy0 slave2 dummy1
    ip link add hsr1 type hsr slave1 dummy2 slave2 dummy0

Splat looks like:
[  214.923127][    C2] WARNING: CPU: 2 PID: 1093 at net/core/dev.c:8992 rollback_registered_many+0x986/0xcf0
[  214.923129][    C2] Modules linked in: hsr dummy openvswitch nsh nf_conncount nf_nat nf_conntrack nf_defrag_ipx
[  214.923154][    C2] CPU: 2 PID: 1093 Comm: ip Not tainted 5.8.0-rc2+ #623
[  214.923156][    C2] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  214.923157][    C2] RIP: 0010:rollback_registered_many+0x986/0xcf0
[  214.923160][    C2] Code: 41 8b 4e cc 45 31 c0 31 d2 4c 89 ee 48 89 df e8 e0 47 ff ff 85 c0 0f 84 cd fc ff ff 5
[  214.923162][    C2] RSP: 0018:ffff8880c5156f28 EFLAGS: 00010287
[  214.923165][    C2] RAX: ffff8880d1dad458 RBX: ffff8880bd1b9000 RCX: ffffffffb929d243
[  214.923167][    C2] RDX: 1ffffffff77e63f0 RSI: 0000000000000008 RDI: ffffffffbbf31f80
[  214.923168][    C2] RBP: dffffc0000000000 R08: fffffbfff77e63f1 R09: fffffbfff77e63f1
[  214.923170][    C2] R10: ffffffffbbf31f87 R11: 0000000000000001 R12: ffff8880c51570a0
[  214.923172][    C2] R13: ffff8880bd1b90b8 R14: ffff8880c5157048 R15: ffff8880d1dacc40
[  214.923174][    C2] FS:  00007fdd257a20c0(0000) GS:ffff8880da200000(0000) knlGS:0000000000000000
[  214.923175][    C2] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  214.923177][    C2] CR2: 00007ffd78beb038 CR3: 00000000be544005 CR4: 00000000000606e0
[  214.923179][    C2] Call Trace:
[  214.923180][    C2]  ? netif_set_real_num_tx_queues+0x780/0x780
[  214.923182][    C2]  ? dev_validate_mtu+0x140/0x140
[  214.923183][    C2]  ? synchronize_rcu.part.79+0x85/0xd0
[  214.923185][    C2]  ? synchronize_rcu_expedited+0xbb0/0xbb0
[  214.923187][    C2]  rollback_registered+0xc8/0x170
[  214.923188][    C2]  ? rollback_registered_many+0xcf0/0xcf0
[  214.923190][    C2]  unregister_netdevice_queue+0x18b/0x240
[  214.923191][    C2]  hsr_dev_finalize+0x56e/0x6e0 [hsr]
[  214.923192][    C2]  hsr_newlink+0x36b/0x450 [hsr]
[  214.923194][    C2]  ? hsr_dellink+0x70/0x70 [hsr]
[  214.923195][    C2]  ? rtnl_create_link+0x2e4/0xb00
[  214.923197][    C2]  ? __netlink_ns_capable+0xc3/0xf0
[  214.923198][    C2]  __rtnl_newlink+0xbdb/0x1270
[ ... ]

Fixes: e0a4b99773d3 ("hsr: use upper/lower device infrastructure")
Reported-by: syzbot+7f1c020f68dab95aab59@syzkaller.appspotmail.com
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/hsr/hsr_device.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 478852ef98ef..a6f4e9f65b14 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -415,6 +415,7 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 		     unsigned char multicast_spec, u8 protocol_version,
 		     struct netlink_ext_ack *extack)
 {
+	bool unregister = false;
 	struct hsr_priv *hsr;
 	int res;
 
@@ -466,25 +467,27 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 	if (res)
 		goto err_unregister;
 
+	unregister = true;
+
 	res = hsr_add_port(hsr, slave[0], HSR_PT_SLAVE_A, extack);
 	if (res)
-		goto err_add_slaves;
+		goto err_unregister;
 
 	res = hsr_add_port(hsr, slave[1], HSR_PT_SLAVE_B, extack);
 	if (res)
-		goto err_add_slaves;
+		goto err_unregister;
 
 	hsr_debugfs_init(hsr, hsr_dev);
 	mod_timer(&hsr->prune_timer, jiffies + msecs_to_jiffies(PRUNE_PERIOD));
 
 	return 0;
 
-err_add_slaves:
-	unregister_netdevice(hsr_dev);
 err_unregister:
 	hsr_del_ports(hsr);
 err_add_master:
 	hsr_del_self_node(hsr);
 
+	if (unregister)
+		unregister_netdevice(hsr_dev);
 	return res;
 }
-- 
2.17.1


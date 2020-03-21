Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F36F018DE50
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 07:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbgCUGrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 02:47:01 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40522 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727917AbgCUGrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 02:47:01 -0400
Received: by mail-pf1-f194.google.com with SMTP id l184so4484529pfl.7
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 23:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6Pvtlc6wpfElXhu0WwMnNW0nCrudRMlGBkYAutXjBDs=;
        b=LJlS7suhUhMHE3bDSrFnsGqTipM6CRUgh5HSf46eHdWdtxJaUUIR7zIAZq0W22a4SW
         77uIMoNYjyagknamcILc1BAALSGWMfZg+9iCFll0vAP6zzEHoK6HRAvApJCQWodgcIlf
         /BdBIYKZWQRnA/sjhb3srQwcrd9VgzOKYLWFgIk0KkB6Fwbg7sn1ZSLQ6jseMRH4H5G8
         trb0ilUB8+CY3aHImtlRC9n4+HCVygZ51IGsoFovMs+uAx3k6hXKhJ1KPDVYQ1svqKkl
         ZNCyicpLO4domaa8LEZKe2Sd/Jq3VwW695ycfiWe09MoDbuhb+H8b6FxhBfFfZJB+BCd
         7+mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6Pvtlc6wpfElXhu0WwMnNW0nCrudRMlGBkYAutXjBDs=;
        b=S4kykg4JVIS+ISszNj+sCo1BWnrXajFYtuyK+emfcmrXxPevD5aWQ2AnJ+Uh/zGt+k
         uG/J+p+86Ojw+HZLaIymN/pC+/2NCYCjIpqXwbjrM6NF1tlND7Z68bblffdx/Z2VpyNJ
         OlcL9a8DVcPjEUbTd7MwvnUkXc48L66glmyN74gKB5hnKMnaAOCuskhTvvlHqsBVOzR2
         JoeGI4BClX97Cve/Vwv3vmqmL8FBYLPuJrP7v6zWyc5wecQcnracDZvXUL3MkySBn7Rg
         h8TqIcbAETU1OZXR4n5tnTIb+U+DQpwy+NKASGHw2HdpJXpkV8fZU1YdSj1ehH4XK90c
         Nt0A==
X-Gm-Message-State: ANhLgQ3MNwgy2zbV4artXd3fbtl1lItV0DSzevgNShxdsDvzTK6EAwnp
        Db06QYol+Kx30jYMdN/PP5U=
X-Google-Smtp-Source: ADFU+vva1vKO0YmeLYTrY1R68ZOQYb6kdDttbDPPP/UwB/k7DLzGVvasuYqd6F+uJh2k6UMr2v0QVA==
X-Received: by 2002:a63:a47:: with SMTP id z7mr12353397pgk.117.1584773217990;
        Fri, 20 Mar 2020 23:46:57 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id u1sm3430464pfn.214.2020.03.20.23.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 23:46:56 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net] hsr: fix general protection fault in hsr_addr_is_self()
Date:   Sat, 21 Mar 2020 06:46:50 +0000
Message-Id: <20200321064650.32174-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The port->hsr is used in the hsr_handle_frame(), which is a
callback of rx_handler.
hsr master and slaves are initialized in hsr_add_port().
This function initializes several pointers, which includes port->hsr after
registering rx_handler.
So, in the rx_handler routine, un-initialized pointer would be used.
In order to fix this, pointers should be initialized before
registering rx_handler.

Test commands:
    ip netns del left
    ip netns del right
    modprobe -rv veth
    modprobe -rv hsr
    killall ping
    modprobe hsr
    ip netns add left
    ip netns add right
    ip link add veth0 type veth peer name veth1
    ip link add veth2 type veth peer name veth3
    ip link add veth4 type veth peer name veth5
    ip link set veth1 netns left
    ip link set veth3 netns right
    ip link set veth4 netns left
    ip link set veth5 netns right
    ip link set veth0 up
    ip link set veth2 up
    ip link set veth0 address fc:00:00:00:00:01
    ip link set veth2 address fc:00:00:00:00:02
    ip netns exec left ip link set veth1 up
    ip netns exec left ip link set veth4 up
    ip netns exec right ip link set veth3 up
    ip netns exec right ip link set veth5 up
    ip link add hsr0 type hsr slave1 veth0 slave2 veth2
    ip a a 192.168.100.1/24 dev hsr0
    ip link set hsr0 up
    ip netns exec left ip link add hsr1 type hsr slave1 veth1 slave2 veth4
    ip netns exec left ip a a 192.168.100.2/24 dev hsr1
    ip netns exec left ip link set hsr1 up
    ip netns exec left ip n a 192.168.100.1 dev hsr1 lladdr \
	    fc:00:00:00:00:01 nud permanent
    ip netns exec left ip n r 192.168.100.1 dev hsr1 lladdr \
	    fc:00:00:00:00:01 nud permanent
    for i in {1..100}
    do
        ip netns exec left ping 192.168.100.1 &
    done
    ip netns exec left hping3 192.168.100.1 -2 --flood &
    ip netns exec right ip link add hsr2 type hsr slave1 veth3 slave2 veth5
    ip netns exec right ip a a 192.168.100.3/24 dev hsr2
    ip netns exec right ip link set hsr2 up
    ip netns exec right ip n a 192.168.100.1 dev hsr2 lladdr \
	    fc:00:00:00:00:02 nud permanent
    ip netns exec right ip n r 192.168.100.1 dev hsr2 lladdr \
	    fc:00:00:00:00:02 nud permanent
    for i in {1..100}
    do
        ip netns exec right ping 192.168.100.1 &
    done
    ip netns exec right hping3 192.168.100.1 -2 --flood &
    while :
    do
        ip link add hsr0 type hsr slave1 veth0 slave2 veth2
	ip a a 192.168.100.1/24 dev hsr0
	ip link set hsr0 up
	ip link del hsr0
    done

Splat looks like:
[  120.954938][    C0] general protection fault, probably for non-canonical address 0xdffffc0000000006: 0000 [#1]I
[  120.957761][    C0] KASAN: null-ptr-deref in range [0x0000000000000030-0x0000000000000037]
[  120.959064][    C0] CPU: 0 PID: 1511 Comm: hping3 Not tainted 5.6.0-rc5+ #460
[  120.960054][    C0] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  120.962261][    C0] RIP: 0010:hsr_addr_is_self+0x65/0x2a0 [hsr]
[  120.963149][    C0] Code: 44 24 18 70 73 2f c0 48 c1 eb 03 48 8d 04 13 c7 00 f1 f1 f1 f1 c7 40 04 00 f2 f2 f2 4
[  120.966277][    C0] RSP: 0018:ffff8880d9c09af0 EFLAGS: 00010206
[  120.967293][    C0] RAX: 0000000000000006 RBX: 1ffff1101b38135f RCX: 0000000000000000
[  120.968516][    C0] RDX: dffffc0000000000 RSI: ffff8880d17cb208 RDI: 0000000000000000
[  120.969718][    C0] RBP: 0000000000000030 R08: ffffed101b3c0e3c R09: 0000000000000001
[  120.972203][    C0] R10: 0000000000000001 R11: ffffed101b3c0e3b R12: 0000000000000000
[  120.973379][    C0] R13: ffff8880aaf80100 R14: ffff8880aaf800f2 R15: ffff8880aaf80040
[  120.974410][    C0] FS:  00007f58e693f740(0000) GS:ffff8880d9c00000(0000) knlGS:0000000000000000
[  120.979794][    C0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  120.980773][    C0] CR2: 00007ffcb8b38f29 CR3: 00000000afe8e001 CR4: 00000000000606f0
[  120.981945][    C0] Call Trace:
[  120.982411][    C0]  <IRQ>
[  120.982848][    C0]  ? hsr_add_node+0x8c0/0x8c0 [hsr]
[  120.983522][    C0]  ? rcu_read_lock_held+0x90/0xa0
[  120.984159][    C0]  ? rcu_read_lock_sched_held+0xc0/0xc0
[  120.984944][    C0]  hsr_handle_frame+0x1db/0x4e0 [hsr]
[  120.985597][    C0]  ? hsr_nl_nodedown+0x2b0/0x2b0 [hsr]
[  120.986289][    C0]  __netif_receive_skb_core+0x6bf/0x3170
[  120.992513][    C0]  ? check_chain_key+0x236/0x5d0
[  120.993223][    C0]  ? do_xdp_generic+0x1460/0x1460
[  120.993875][    C0]  ? register_lock_class+0x14d0/0x14d0
[  120.994609][    C0]  ? __netif_receive_skb_one_core+0x8d/0x160
[  120.995377][    C0]  __netif_receive_skb_one_core+0x8d/0x160
[  120.996204][    C0]  ? __netif_receive_skb_core+0x3170/0x3170
[ ... ]

Reported-by: syzbot+fcf5dd39282ceb27108d@syzkaller.appspotmail.com
Fixes: c5a759117210 ("net/hsr: Use list_head (and rcu) instead of array for slave devices.")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/hsr/hsr_slave.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/hsr/hsr_slave.c b/net/hsr/hsr_slave.c
index fbfd0db182b7..a9104d42aafb 100644
--- a/net/hsr/hsr_slave.c
+++ b/net/hsr/hsr_slave.c
@@ -145,16 +145,16 @@ int hsr_add_port(struct hsr_priv *hsr, struct net_device *dev,
 	if (!port)
 		return -ENOMEM;
 
+	port->hsr = hsr;
+	port->dev = dev;
+	port->type = type;
+
 	if (type != HSR_PT_MASTER) {
 		res = hsr_portdev_setup(dev, port);
 		if (res)
 			goto fail_dev_setup;
 	}
 
-	port->hsr = hsr;
-	port->dev = dev;
-	port->type = type;
-
 	list_add_tail_rcu(&port->port_list, &hsr->ports);
 	synchronize_rcu();
 
-- 
2.17.1


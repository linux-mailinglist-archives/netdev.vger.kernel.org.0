Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40522FF0EE
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731097AbfKPQIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 11:08:43 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46582 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729833AbfKPQIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 11:08:42 -0500
Received: by mail-wr1-f68.google.com with SMTP id b3so14275181wrs.13
        for <netdev@vger.kernel.org>; Sat, 16 Nov 2019 08:08:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=FYBY2kcMHJiSzhdqEyOuVC5yVxtvqKBPPIAhj3BsMQA=;
        b=vCXPMUqLdAtl0tuU0tVbWjsyuXFnhQ8esONIq+9szzbl6bRh68g7nk70HEpP+skfie
         vsS9a99DBBb2wyH+sXxFE9hwPyb6THAm1V7XM1/zVg8kFh22AFDY13EwOuS0WTf33cRd
         xZ8F/OVczdHQ6LQYwugJaD+YCQCzaFkSl6gUi02OQ+WfsKHVZBL0DGS4vxt0h5y3bCFQ
         fkeMhi74zUPtZu23PMplC6MMARXQJhUFUz1zA37mmA1PhDbR6YjeqFlzicktCPtqKlTs
         4GUqKl2Y/GQM7onPOwaAsj19j+h/58qdDpmCga82DSEUCiun6sesnDAHaz3EOg070XhK
         EcvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FYBY2kcMHJiSzhdqEyOuVC5yVxtvqKBPPIAhj3BsMQA=;
        b=dDuktKgKpYLlXqQLfbuQhoxYVYos+cPF8NWn4b0Y7XCGp2qpmK9S/sPSUwB2mm0xOf
         1uFjGLTpT4w408kNgTJMyaQetvNlnDJtEAXL8p42qnTRXQxMCzacv0vTVoRum66Q87NB
         E81+oaOSjRnTg6DlYKmdZ92ssscjndqsdgXkPy95UL6EcaY6CNFz8mStdW5I6vlmNUAl
         Fz5AGg/kg/Uv7yRZELgSGtVKXG1C1hnKPOBmuWGIkoER1sfvWbjG1A/K7LltQMQoyrXh
         qzO5hJggY81rIcvBIkdEMX2i9/8kGo9krwO4aQiqytpz0i3oSNCdpm4GlKeb725ciXn2
         DGfw==
X-Gm-Message-State: APjAAAXkLCRGdANMzVdAn9IXtDHE8euEh/62BHj1rxSpcTRqtVSP11GA
        NkV0sJd5rraJYettgL2CBqY=
X-Google-Smtp-Source: APXvYqwaC98cPx49BYhAgttdDoHwIKu4Ey0IGQiQjw4VRvpKhmwFfjA5gFyuXSf+zSnnJN2ovxHpKA==
X-Received: by 2002:a5d:4403:: with SMTP id z3mr20240659wrq.44.1573920520422;
        Sat, 16 Nov 2019 08:08:40 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id t134sm14782076wmt.24.2019.11.16.08.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Nov 2019 08:08:39 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net] net: dsa: tag_8021q: Fix dsa_8021q_restore_pvid for an absent pvid
Date:   Sat, 16 Nov 2019 18:08:25 +0200
Message-Id: <20191116160825.29232-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This sequence of operations:
ip link set dev br0 type bridge vlan_filtering 1
bridge vlan del dev swp2 vid 1
ip link set dev br0 type bridge vlan_filtering 1
ip link set dev br0 type bridge vlan_filtering 0

apparently fails with the message:

[   31.305716] sja1105 spi0.1: Reset switch and programmed static config. Reason: VLAN filtering
[   31.322161] sja1105 spi0.1: Couldn't determine PVID attributes (pvid 0)
[   31.328939] sja1105 spi0.1: Failed to setup VLAN tagging for port 1: -2
[   31.335599] ------------[ cut here ]------------
[   31.340215] WARNING: CPU: 1 PID: 194 at net/switchdev/switchdev.c:157 switchdev_port_attr_set_now+0x9c/0xa4
[   31.349981] br0: Commit of attribute (id=6) failed.
[   31.354890] Modules linked in:
[   31.357942] CPU: 1 PID: 194 Comm: ip Not tainted 5.4.0-rc6-01792-gf4f632e07665-dirty #2062
[   31.366167] Hardware name: Freescale LS1021A
[   31.370437] [<c03144dc>] (unwind_backtrace) from [<c030e184>] (show_stack+0x10/0x14)
[   31.378153] [<c030e184>] (show_stack) from [<c11d1c1c>] (dump_stack+0xe0/0x10c)
[   31.385437] [<c11d1c1c>] (dump_stack) from [<c034c730>] (__warn+0xf4/0x10c)
[   31.392373] [<c034c730>] (__warn) from [<c034c7bc>] (warn_slowpath_fmt+0x74/0xb8)
[   31.399827] [<c034c7bc>] (warn_slowpath_fmt) from [<c11ca204>] (switchdev_port_attr_set_now+0x9c/0xa4)
[   31.409097] [<c11ca204>] (switchdev_port_attr_set_now) from [<c117036c>] (__br_vlan_filter_toggle+0x6c/0x118)
[   31.418971] [<c117036c>] (__br_vlan_filter_toggle) from [<c115d010>] (br_changelink+0xf8/0x518)
[   31.427637] [<c115d010>] (br_changelink) from [<c0f8e9ec>] (__rtnl_newlink+0x3f4/0x76c)
[   31.435613] [<c0f8e9ec>] (__rtnl_newlink) from [<c0f8eda8>] (rtnl_newlink+0x44/0x60)
[   31.443329] [<c0f8eda8>] (rtnl_newlink) from [<c0f89f20>] (rtnetlink_rcv_msg+0x2cc/0x51c)
[   31.451477] [<c0f89f20>] (rtnetlink_rcv_msg) from [<c1008df8>] (netlink_rcv_skb+0xb8/0x110)
[   31.459796] [<c1008df8>] (netlink_rcv_skb) from [<c1008648>] (netlink_unicast+0x17c/0x1f8)
[   31.468026] [<c1008648>] (netlink_unicast) from [<c1008980>] (netlink_sendmsg+0x2bc/0x3b4)
[   31.476261] [<c1008980>] (netlink_sendmsg) from [<c0f43858>] (___sys_sendmsg+0x230/0x250)
[   31.484408] [<c0f43858>] (___sys_sendmsg) from [<c0f44c84>] (__sys_sendmsg+0x50/0x8c)
[   31.492209] [<c0f44c84>] (__sys_sendmsg) from [<c0301000>] (ret_fast_syscall+0x0/0x28)
[   31.500090] Exception stack(0xedf47fa8 to 0xedf47ff0)
[   31.505122] 7fa0:                   00000002 b6f2e060 00000003 beabd6a4 00000000 00000000
[   31.513265] 7fc0: 00000002 b6f2e060 5d6e3213 00000128 00000000 00000001 00000006 000619c4
[   31.521405] 7fe0: 00086078 beabd658 0005edbc b6e7ce68

The reason is the implementation of br_get_pvid:

static inline u16 br_get_pvid(const struct net_bridge_vlan_group *vg)
{
	if (!vg)
		return 0;

	smp_rmb();
	return vg->pvid;
}

Since VID 0 is an invalid pvid from the bridge's point of view, let's
add this check in dsa_8021q_restore_pvid to avoid restoring a pvid that
doesn't really exist.

Fixes: 5f33183b7fdf ("net: dsa: tag_8021q: Restore bridge VLANs when enabling vlan_filtering")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 net/dsa/tag_8021q.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 9c1cc2482b68..9e5a883a9f0c 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -106,7 +106,7 @@ static int dsa_8021q_restore_pvid(struct dsa_switch *ds, int port)
 	slave = ds->ports[port].slave;
 
 	err = br_vlan_get_pvid(slave, &pvid);
-	if (err < 0)
+	if (!pvid || err < 0)
 		/* There is no pvid on the bridge for this port, which is
 		 * perfectly valid. Nothing to restore, bye-bye!
 		 */
-- 
2.17.1


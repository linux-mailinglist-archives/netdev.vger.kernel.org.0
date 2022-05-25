Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9161F533A0F
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 11:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbiEYJk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 05:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiEYJkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 05:40:25 -0400
X-Greylist: delayed 570 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 25 May 2022 02:40:22 PDT
Received: from mail-relay.contabo.net (mail-relay.contabo.net [207.180.195.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E415395AF
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 02:40:22 -0700 (PDT)
Received: from pxmg2.contabo.net (localhost.localdomain [127.0.0.1])
        by mail-relay.contabo.net (Proxmox) with ESMTP id 53D37103DA7
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 11:30:50 +0200 (CEST)
Received: from m2731.contaboserver.net (m2731.contabo.net [193.34.145.203])
        by mail-relay.contabo.net (Proxmox) with ESMTPS id 5E57F103C0C
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 11:30:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mkio.de;
        s=default; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:Sender
        :Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CNtuzIYmMLT2jMkWblUIP4wWCf9jRj/1I516xOc/M0A=; b=nMgC9bIWqRrzChihnZV+jvNcHE
        /Qs8qt2unhd7TIxzoYTs7ik1njqXM9e7Iu49GL3sOC7FSskE2w+xzsadX1MlT4nq7k0dGDp47s2Qw
        klmChLYgd9avQdyOLrpWXh+uzQnvVPPIznkfrBIJRf+Gl657tG2VDYfTX5/NO6vAhzdTjqvEdAIQU
        6DFD9q5oj8mM2Bxw/mJbzEgLevGLgta0lm64NII5eRwApFGC3eaki67kr38+5J3U7j47LyOGwz+lC
        NLHW/PslBjKOQSVViVIE+NnWZmCF7nzp+rM4U0V9ujXTwaXZbn3y0n4QDE9uJtGTUVYNWkqnEzVMG
        j595HxkQ==;
Received: from [78.43.218.139] (port=44732 helo=localhost)
        by m2731.contaboserver.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <mk@mkio.de>)
        id 1ntnLr-00G4Fq-4U
        for netdev@vger.kernel.org;
        Wed, 25 May 2022 11:30:48 +0200
Date:   Wed, 25 May 2022 11:30:40 +0200
From:   Markus Klotzbuecher <mk@mkio.de>
To:     netdev@vger.kernel.org
Subject: cpsw_switch: unable to selectively forward multicast
Message-ID: <Yo33QJ1FXGBv2gHZ@e495>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - m2731.contaboserver.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mkio.de
X-Get-Message-Sender-Via: m2731.contaboserver.net: authenticated_id: mk@mkio.de
X-Authenticated-Sender: m2731.contaboserver.net: mk@mkio.de
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

I'm using multiple am335x based devices connected in a daisy chain
using cpsw_new in switch mode:

             /-br0-\          /-br0-\         /-br0-\
            |       |        |       |       |       |
        ---swp0    swp1-----swp0    swp1----swp0    swp1
            |       |        |       |       |       |
             \-----/          \-----/         \-----/
               #1               #2              #3

The bridge is configured as described in cpsw_switchdev.rst
[1]. Regular unicast traffic works fine, however I am unable to get
traffic to multicast groups to be forwarded in both directions via the
switches.

In my understanding, this should just work. Once the application
starts up I see the relevant mdb entries on each device:

     $ bridge mdb show | grep 253
     dev br0 port br0 grp 239.253.253.239 temp
     dev br0 port swp1 grp 239.253.253.239 temp offload
     dev br0 port swp0 grp 239.253.253.239 temp offload

As per ethtool -d output these also appear to be present in the ALE
[2,3].

For a test, I've also tried to directly add this mcast ALE entry in
the driver [4], however this also didn't help.

Enabling `mcast_flood` is not an option as each device also acts as a
PTP boundary clock, hence PTP multicast must _not_ be forwarded (there
are specific ALE entries to forward these to the bridge only).

I'm observing this with a 5.10.103 kernel. We are working on moving
to a more recent version, though not quite there yet. I've gone
through the changes to the cpsw_new driver wrt to current mainline,
but nothing stuck out to me.

Any comments about whether this should work or suggestions of what to
try would be much appreciated.

Thanks,

Markus


[1]: 
    devlink dev param set platform/4a100000.switch name switch_mode value 1 cmode runtime
    ip link add name br0 type bridge
    ip link set dev br0 type bridge ageing_time 1000
    ip link set dev swp0 up
    ip link set dev swp1 up
    ip link set dev swp0 master br0
    ip link set dev swp1 master br0

    bridge vlan add dev br0 vid 1 pvid untagged self
    ip link set dev br0 up

[2]
# ethtool -d swp0
Offset		  	  Values
------                    ------
0x0000: 00 00 00 00 00 00 00 20 07 07 07 07 06 00 00 00
0x0010: 80 01 00 50 00 00 00 c2 04 00 00 00 1b 01 00 10
0x0020: 00 00 00 19 06 00 00 00 80 01 00 50 0e 00 00 c2
0x0030: 06 00 00 00 00 01 00 50 81 01 00 5e 06 00 00 00
0x0040: 00 01 00 50 6b 00 00 5e 06 00 00 00 33 33 00 50
0x0050: 81 01 00 00 06 00 00 00 33 33 00 50 6b 00 00 00
0x0060: 1c 00 00 00 ff ff 00 f0 ff ff ff ff 00 00 00 00
0x0070: e1 f4 00 30 a7 0f e4 1e 04 00 00 00 33 33 00 10
0x0080: 01 00 00 00 04 00 00 00 00 01 00 10 01 00 00 5e
0x0090: 00 00 00 00 e1 f4 00 30 a9 0f e4 1e 00 00 00 00
0x00a0: 00 00 01 20 07 01 07 07 00 00 00 00 e1 f4 01 30
0x00b0: a7 0f e4 1e 00 00 00 00 e1 f4 01 30 a9 0f e4 1e
0x00c0: 04 00 00 00 33 33 00 30 a7 0f e4 ff 04 00 00 00
0x00d0: 33 33 00 30 6a 00 00 00 1c 00 00 00 33 33 00 30
0x00e0: fb 00 00 00 10 00 00 00 33 33 00 30 ad 1a 9d ff
0x00f0: 1c 00 00 00 00 01 00 30 ef fd 7d 5e 08 00 00 00 
0x0100: 33 33 00 30 54 74 38 ff 08 00 00 00 33 33 00 30
0x0110: ae 9b e0 ff 08 00 00 00 33 33 00 30 0b 26 8f ff
0x0120: 08 00 00 00 33 33 00 30 5a 27 36 ff 08 00 00 00
0x0130: 00 01 00 30 fa ff 7f 5e 00 00 00 00 00 00 00 00
0x0140: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0150: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0170: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0180: 04 00 00 00 fa 98 01 f0 ae 9b e0 9b 04 00 00 00
0x0190: 39 dc 01 f0 82 39 bf 6f 04 00 00 00 be b8 01 40
0x01a0: 89 2e 00 f4 04 00 00 00 7b 84 01 40 40 1c 4e eb
0x01b0: 04 00 00 00 a6 dc 01 40 c4 61 6f 32 04 00 00 00
0x01c0: a6 dc 01 40 c4 61 6f 32 04 00 00 00 27 b8 01 70
0x01d0: 0b 06 bf eb 00 00 00 00 00 00 00 00 00 00 00 00

[3] same as [2] dumped with
https://patchwork.ozlabs.org/project/netdev/patch/1406107764-1737-1-git-send-email-mugunthanvnm@ti.com/
applied to latest ethtool:

root@evalboard:~# /data/ethtool -d swp0
cpsw hw version 1.12 (0)
0   : type: vlan , vid = 0, untag_force = 0x7, reg_mcast = 0x7, unreg_mcast = 0x7, member_list = 0x7
1   : type: mcast, addr = 01:80:c2:00:00:00, mcast_state = blf, super, port_mask = 0x1
2   : type: mcast, addr = 01:1b:19:00:00:00, mcast_state = f, no super, port_mask = 0x1
3   : type: mcast, addr = 01:80:c2:00:00:0e, mcast_state = blf, super, port_mask = 0x1
4   : type: mcast, addr = 01:00:5e:00:01:81, mcast_state = blf, super, port_mask = 0x1
5   : type: mcast, addr = 01:00:5e:00:00:6b, mcast_state = blf, super, port_mask = 0x1
6   : type: mcast, addr = 33:33:00:00:01:81, mcast_state = blf, super, port_mask = 0x1
7   : type: mcast, addr = 33:33:00:00:00:6b, mcast_state = blf, super, port_mask = 0x1
8   : type: mcast, vid = 0, addr = ff:ff:ff:ff:ff:ff, mcast_state = f, no super, port_mask = 0x7
9   : type: ucast, vid = 0, addr = f4:e1:1e:e4:0f:a7, ucast_type = persistant, port_num = 0x0
10  : type: mcast, addr = 33:33:00:00:00:01, mcast_state = f, no super, port_mask = 0x1
11  : type: mcast, addr = 01:00:5e:00:00:01, mcast_state = f, no super, port_mask = 0x1
12  : type: ucast, vid = 0, addr = f4:e1:1e:e4:0f:a9, ucast_type = persistant, port_num = 0x0
13  : type: vlan , vid = 1, untag_force = 0x7, reg_mcast = 0x7, unreg_mcast = 0x1, member_list = 0x7
14  : type: ucast, vid = 1, addr = f4:e1:1e:e4:0f:a7, ucast_type = persistant, port_num = 0x0
15  : type: ucast, vid = 1, addr = f4:e1:1e:e4:0f:a9, ucast_type = persistant, port_num = 0x0
16  : type: mcast, vid = 0, addr = 33:33:ff:e4:0f:a7, mcast_state = f, no super, port_mask = 0x1
17  : type: mcast, vid = 0, addr = 33:33:00:00:00:6a, mcast_state = f, no super, port_mask = 0x1
18  : type: mcast, vid = 0, addr = 33:33:00:00:00:fb, mcast_state = f, no super, port_mask = 0x7
19  : type: mcast, vid = 0, addr = 33:33:ff:9d:1a:ad, mcast_state = f, no super, port_mask = 0x4
20  : type: mcast, vid = 0, addr = 01:00:5e:7d:fd:ef, mcast_state = f, no super, port_mask = 0x7

  this ALE entry should (?) cause 239.253.253.239 to be forwarded.

21  : type: mcast, vid = 0, addr = 33:33:ff:38:74:54, mcast_state = f, no super, port_mask = 0x2
22  : type: mcast, vid = 0, addr = 33:33:ff:e0:9b:ae, mcast_state = f, no super, port_mask = 0x2
23  : type: mcast, vid = 0, addr = 33:33:ff:8f:26:0b, mcast_state = f, no super, port_mask = 0x2
24  : type: mcast, vid = 0, addr = 33:33:ff:36:27:5a, mcast_state = f, no super, port_mask = 0x2
32  : type: ucast, vid = 1, addr = 98:fa:9b:e0:9b:ae, ucast_type = touched   , port_num = 0x1
33  : type: ucast, vid = 1, addr = dc:39:6f:bf:39:82, ucast_type = touched   , port_num = 0x1
78  : type: ucast, vid = 1, addr = 1c:ba:8c:9d:1a:ad, ucast_type = touched   , port_num = 0x2
79  : type: ucast, vid = 1, addr = 08:00:17:0b:6b:0f, ucast_type = touched   , port_num = 0x2
85  : type: ucast, vid = 1, addr = b8:be:f4:00:2e:89, ucast_type = untouched , port_num = 0x1
86  : type: ucast, vid = 1, addr = 84:7b:eb:4e:1c:40, ucast_type = untouched , port_num = 0x1

[4]:

diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 7f973f9b91c7..9c39f16c1bef 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -634,6 +634,8 @@ static void cpsw_port_add_switch_def_ale_entries(struct cpsw_priv *priv,
        struct cpsw_common *cpsw = priv->cpsw;
        u32 reg;

+	char entry[ETH_ALEN] = { 0x01, 0x00, 0x5e, 0x7d, 0xfd, 0xef };
+
        cpsw_ale_control_set(cpsw->ale, priv->emac_port,
                             ALE_PORT_DROP_UNKNOWN_VLAN, 0);
        cpsw_ale_control_set(cpsw->ale, priv->emac_port,
@@ -654,6 +656,11 @@ static void cpsw_port_add_switch_def_ale_entries(struct cpsw_priv *priv,
        cpsw_ale_add_mcast(cpsw->ale, priv->ndev->broadcast,
                           port_mask, ALE_VLAN, slave->port_vlan,
                           ALE_MCAST_FWD_2);
+
+	cpsw_ale_add_mcast(cpsw->ale, entry,
+			   port_mask, ALE_SUPER, slave->port_vlan,
+			   ALE_MCAST_BLOCK_LEARN_FWD);
+
        cpsw_ale_add_ucast(cpsw->ale, priv->mac_addr,
                           HOST_PORT_NUM, ALE_VLAN, slave->port_vlan);


-- 
Markus Klotzbuecher


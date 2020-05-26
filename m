Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD7021E21D3
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 14:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731415AbgEZM2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 08:28:11 -0400
Received: from mail-eopbgr130108.outbound.protection.outlook.com ([40.107.13.108]:27904
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726437AbgEZM2L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 08:28:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WYrtLlCcLcEvuM1fd2OpF5enCfiVuLwushvMco6TqHeNVIQSivHMKTM0QofMrhzfkXb94sL8RSBBXD6a8/MMfQUhJO86hR28c75Mwd3Ed+oRIvDHWmINz375Tyl0X1wTexKDnxxpZ8wB3oTpt9fKwt0G8b8uLXYJ9kUgbBKVabTmMU6HW1F96LtgDiQp4JnO6e3hORBLac9+P7zT7nlBIMkl9fPShp3dFiHxqgG5Nn9dUaxoADGiJT33Jq5Dg+3c5ngPuMwJ0yFzcfSOja1BcunZJlIDAdzjQS2sLyLpcsdk+fO/Q4L6G1D0M2DnNLDU/S5q1Y+pr6b6HcYFiJXraQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=asBaxkY48HPwqYMczS6U0a5yZjLj4CRDkTzC4wCxeQM=;
 b=nnWnvOX1MRBbioYXaSiImkrZq5oYCMFQiPdwDj6c93jWbb9WWkE4Zrxa47NLeXM0Ng/QLUM/P2R8vxezx5i7U6BgOb77tjuOGFDeHnyEnn6swPpXD/W/EvwUXP9vP1bfIU5SrInToi9mu0ypXFQRIgSfDbvm/e1wW6rtGa6JK0rxTnwl4vZt5DJE0diT0uocnz4Y23fBUHArX3h732qx8wfh3wBjZJxM3CaVKRWmEStIf+wx8L4KWWDn6JhNmuBRKgfbLcUkEosM/YSPVUThwvza1XO+09+OzPfv0lj/f3g4zM5LnEL2Ocr/6I19ZiPAJDJ77kpBfP+7Z0kORI7wsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=asBaxkY48HPwqYMczS6U0a5yZjLj4CRDkTzC4wCxeQM=;
 b=ld08dpCm7NtaM1yg4hv5UTkkrzMDNWXHPJpF2i8hVRgrAYCdn8WCBybOz0rSbkDaLhD5v2lk5okvMrvm/wUF2uizzPKD97jDWthtlYPWx8u7bLhUQQuyG4qCNd9hQfOSnAQlRTaiOAcMFx/ZbOiKwZzu6tgSfpSNPjvqsEusemI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nokia.com;
Received: from AM0PR07MB3937.eurprd07.prod.outlook.com (2603:10a6:208:4c::20)
 by AM0PR07MB5618.eurprd07.prod.outlook.com (2603:10a6:208:fb::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.8; Tue, 26 May
 2020 12:28:07 +0000
Received: from AM0PR07MB3937.eurprd07.prod.outlook.com
 ([fe80::55f1:90c6:a5ae:2c82]) by AM0PR07MB3937.eurprd07.prod.outlook.com
 ([fe80::55f1:90c6:a5ae:2c82%4]) with mapi id 15.20.3045.012; Tue, 26 May 2020
 12:28:07 +0000
From:   Alexander A Sverdlin <alexander.sverdlin@nokia.com>
To:     netdev@vger.kernel.org
Cc:     Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] macvlan: Skip loopback packets in RX handler
Date:   Tue, 26 May 2020 14:27:51 +0200
Message-Id: <20200526122751.409917-1-alexander.sverdlin@nokia.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HE1PR05CA0319.eurprd05.prod.outlook.com
 (2603:10a6:7:92::14) To AM0PR07MB3937.eurprd07.prod.outlook.com
 (2603:10a6:208:4c::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ulegcpsvhp1.emea.nsn-net.net (131.228.2.0) by HE1PR05CA0319.eurprd05.prod.outlook.com (2603:10a6:7:92::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend Transport; Tue, 26 May 2020 12:28:06 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [131.228.2.0]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dd6d0462-2d93-472f-54aa-08d801703e7f
X-MS-TrafficTypeDiagnostic: AM0PR07MB5618:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR07MB561869894C0431DAA3DE16C288B00@AM0PR07MB5618.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 041517DFAB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /D3k8jj1XKeAJb+64M+b/Wy8Q0zXgYTbXMaulCCC759U2uRRpAVvy7D9fA9qBu/Mkg1iIGYy34BB/HpBwU9VOP5FUnN2LUH3fuQfMdLH2zcAA88rdxqyl2B/u6tpcI2cRgu6xbDguiY1TG70/m3DtTdKpFuoWD7jNWQ0gYAMNNx8uG79vbvP3GX8hpzDwD47I4etB1F8h46oeTmXleJnXyHRIG7xIKQAcRg9zICQjL+bfnFYsNeFOz/T3CYN77mtV3xuSgPsi824hILQuTpajQJZ/Rsin+56rBVTzEC+etZPN56NaVpKKK8syMa/0SHO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR07MB3937.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(366004)(376002)(39860400002)(136003)(2616005)(956004)(6512007)(6506007)(6916009)(86362001)(52116002)(478600001)(36756003)(16526019)(186003)(26005)(1076003)(4326008)(8936002)(66476007)(66946007)(66556008)(6486002)(5660300002)(8676002)(2906002)(6666004)(54906003)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Nx+jxjq41bNskmahzGCQym7978+R+fuZTT0IYDHxa/OFcMU1ht3glx2QQadcnGRV55Qnngwn7AHOYVC/bsNLehSCWcWSmqN/ZuAEn4uEoRRrL1vHLbjPxxvHSxMhNvBZGC/ES9W6m03+RWbn7RJqyo8uHsMc4I0mJJXBiV2w2IZ4nWvIU+MFZI9/pCSHZxm7PHHc1/a6Rxc1QUWUjaOgJGQuw/WLRUQ1CVjynJRPw/GGMAHm8DDOuSReN59Zu8KV7w4VzdEdUKqSy/YIvwv3y21XHTqIZ8Rnc+X9IYLv15w1lFyLuUhARnj1WJh+PGH/9UH/BotogiZ4CeqytRI8dCud+jOgarPRE0IOhmw4GUs9t1TgJKXVw0+/txrEYOEIBStDZ1xEIzpkeYy+pt6t3REJ/wJBPlIUFdywGuU3ZA65u2bugoRHkUgAfsHaVEPrDZFf0VABTnWcKuS0JYO0itwn/vPS1MCWzrwdOQiOaxk=
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd6d0462-2d93-472f-54aa-08d801703e7f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2020 12:28:07.1011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ad75G8VguW47b+ESHiaLyeLxvGhbgb9Tuxnq5B30SCAIVTBDHMMknVMaihFgleyn9yyEaCTEdVkQICr0J/HYdrfyLabaaoaUYZryFAYGbrQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR07MB5618
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@nokia.com>

Ignore loopback-originatig packets soon enough and don't try to process L2
header where it doesn't exist. The very similar br_handle_frame() in bridge
code performs exactly the same check.

This is an example of such ICMPv6 packet:

skb len=96 headroom=40 headlen=96 tailroom=56
mac=(40,0) net=(40,40) trans=80
shinfo(txflags=0 nr_frags=0 gso(size=0 type=0 segs=0))
csum(0xae2e9a2f ip_summed=1 complete_sw=0 valid=0 level=0)
hash(0xc97ebd88 sw=1 l4=1) proto=0x86dd pkttype=5 iif=24
dev name=etha01.212 feat=0x0x0000000040005000
skb headroom: 00000000: 00 7c 86 52 84 88 ff ff 00 00 00 00 00 00 08 00
skb headroom: 00000010: 45 00 00 9e 5d 5c 40 00 40 11 33 33 00 00 00 01
skb headroom: 00000020: 02 40 43 80 00 00 86 dd
skb linear:   00000000: 60 09 88 bd 00 38 3a ff fe 80 00 00 00 00 00 00
skb linear:   00000010: 00 40 43 ff fe 80 00 00 ff 02 00 00 00 00 00 00
skb linear:   00000020: 00 00 00 00 00 00 00 01 86 00 61 00 40 00 00 2d
skb linear:   00000030: 00 00 00 00 00 00 00 00 03 04 40 e0 00 00 01 2c
skb linear:   00000040: 00 00 00 78 00 00 00 00 fd 5f 42 68 23 87 a8 81
skb linear:   00000050: 00 00 00 00 00 00 00 00 01 01 02 40 43 80 00 00
skb tailroom: 00000000: ...
skb tailroom: 00000010: ...
skb tailroom: 00000020: ...
skb tailroom: 00000030: ...

Call Trace, how it happens exactly:
 ...
 macvlan_handle_frame+0x321/0x425 [macvlan]
 ? macvlan_forward_source+0x110/0x110 [macvlan]
 __netif_receive_skb_core+0x545/0xda0
 ? enqueue_task_fair+0xe5/0x8e0
 ? __netif_receive_skb_one_core+0x36/0x70
 __netif_receive_skb_one_core+0x36/0x70
 process_backlog+0x97/0x140
 net_rx_action+0x1eb/0x350
 ? __hrtimer_run_queues+0x136/0x2e0
 __do_softirq+0xe3/0x383
 do_softirq_own_stack+0x2a/0x40
 </IRQ>
 do_softirq.part.4+0x4e/0x50
 netif_rx_ni+0x60/0xd0
 dev_loopback_xmit+0x83/0xf0
 ip6_finish_output2+0x575/0x590 [ipv6]
 ? ip6_cork_release.isra.1+0x64/0x90 [ipv6]
 ? __ip6_make_skb+0x38d/0x680 [ipv6]
 ? ip6_output+0x6c/0x140 [ipv6]
 ip6_output+0x6c/0x140 [ipv6]
 ip6_send_skb+0x1e/0x60 [ipv6]
 rawv6_sendmsg+0xc4b/0xe10 [ipv6]
 ? proc_put_long+0xd0/0xd0
 ? rw_copy_check_uvector+0x4e/0x110
 ? sock_sendmsg+0x36/0x40
 sock_sendmsg+0x36/0x40
 ___sys_sendmsg+0x2b6/0x2d0
 ? proc_dointvec+0x23/0x30
 ? addrconf_sysctl_forward+0x8d/0x250 [ipv6]
 ? dev_forward_change+0x130/0x130 [ipv6]
 ? _raw_spin_unlock+0x12/0x30
 ? proc_sys_call_handler.isra.14+0x9f/0x110
 ? __call_rcu+0x213/0x510
 ? get_max_files+0x10/0x10
 ? trace_hardirqs_on+0x2c/0xe0
 ? __sys_sendmsg+0x63/0xa0
 __sys_sendmsg+0x63/0xa0
 do_syscall_64+0x6c/0x1e0
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
---
 drivers/net/macvlan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index e7289d6..7cea2fa 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -447,6 +447,10 @@ static rx_handler_result_t macvlan_handle_frame(struct sk_buff **pskb)
 	int ret;
 	rx_handler_result_t handle_res;
 
+	/* Packets from dev_loopback_xmit() do not have L2 header, bail out */
+	if (unlikely(skb->pkt_type == PACKET_LOOPBACK))
+		return RX_HANDLER_PASS;
+
 	port = macvlan_port_get_rcu(skb->dev);
 	if (is_multicast_ether_addr(eth->h_dest)) {
 		unsigned int hash;
-- 
2.10.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA8B16C2ACE
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 07:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbjCUGx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 02:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbjCUGx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 02:53:28 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2108.outbound.protection.outlook.com [40.107.94.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1778340DE
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 23:53:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CMmyVdpWMfsx1Un/ZppZvQItR2qEVX5GacWUfdd4v4MfVQ1xtpRP2x+UBCw3ejCXw4jOZTSXBvg18RZ6yU9EFLd6qI18Ao70+KTmELdmC+8c3qIYh0vC4YWg2Tr1RnJ70SaYLW88b4R6T9B7+wVt6t31YvdkQXWw2Oqo5AP3doFzukJbp45ghBr7Z1WvlMaAtCByjIdqbZ2cufpnvUBjeXd/KX7GVBgeteJ8DE0kvMpMSorzwi3M1q01RRm0LF2AyNrLQKksh9d1WyK9XbGcVdBu+a+VSWigxTZAMAJh+SX0ySJOfzAcbLbbYhAMOy+SDRZfXzRkpVbrAuB8QYsIdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UagIGEOgEyuvb4CIJnBydGIqNmYuyhm/+9dlnsFaJZg=;
 b=N78ycFNBHQ2y4WMm5vy+ieWXG6Y8/GShKYhv9w77+yZEzCUispM9EZOF2XaxDkykBRzx5hMioHrlsv1INqPXIlBrNRiRDaiuWNWwM5WrFpB6915X+g33E6z3UbBrafRCn09IqO9MIzNrIGal2pDqwc+34NusOTqgo371MK9613l/1TnWgWUzzxJ5vp794UMupVs1UlLiHa43WUWTiUxZBuYbZs6BJDQaxL5ESowfyxLR1lVeIL5DSoIc1NdZXl1OjhmRGc5cAHKyRD9UoiBYPrEqbg3J5jkW7W4Z2q5IKlvJGN5GKCRUNrBNXOe/H627ZP4n/WJU7gaEA7NgCosJcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UagIGEOgEyuvb4CIJnBydGIqNmYuyhm/+9dlnsFaJZg=;
 b=bwLsqCfeJptmqHPrRqf8c3AQWuoN/ou28QwtvIM040jVLe+R5TOK2jPvqQtj6FyPuFpSj6pshN6cM2Q0l0FGqXKkOLZEtnh4ZoVDnELI1s5UUuktMY9O+kA8KLlrOG7Xc4yn602s6QLBybD54uKe5nKoHtlnP6xMevBVys45N4M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3808.namprd13.prod.outlook.com (2603:10b6:208:1e7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 06:53:22 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 06:53:22 +0000
Date:   Tue, 21 Mar 2023 07:53:16 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] erspan: do not use skb_mac_header() in
 ndo_start_xmit()
Message-ID: <ZBlUXFdZybQ8BJ/k@corigine.com>
References: <20230320163427.8096-1-edumazet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230320163427.8096-1-edumazet@google.com>
X-ClientProxiedBy: AS4P190CA0007.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3808:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d8a0acf-6a05-4207-21b9-08db29d8f5fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s1UTuriPwsuDJc1a4eeoKLYn78aFZPe4aRv/Wdu7oAZg8cUkaywl5DyR0emLWjgmQlJ9mm31LK3c6EZtIfHpxU/ZsVtsiCcN0yC0uhiN/ND8BpXyohRvQ4IpzzzzWup9aST4hWyaTshzlAOMauUnNTx5nVjHCN9Fk4OEtURQelkNPA2rmBwFDthEs2Q553E4qtfp0wuBLcJa2CpqbkGxjXU6oyfnSvVGG26QgOwYZ03okvKp+9L9i2suoxdm75X6XyYR7vZLltfcaX57uc7XgxjsMztFN4inpZxDLCxtzPduzAVHadB6WVhH6VxcNSC23EMj2pQXEsmk190HOXoBJ14yuwLhm8LTkwgkGc+xFQnWmyZS+hH9ZWV+JBuTtHbRdhR0J/OWQxbdGkXWU9DMJAXGlnbytHCDKXfZp6VBrtCzh9C4LUJMtQpfNZk/+XlzoF+qT8U98lVdGSjDJzotdI+D8NKCAuWiItvCus0ZqMXY7BVZydk6vpGSKvTRFMhkGar3MDYeK7TbuFejiSOK8NP4BbbuYkHortQPREiPSkJizXkQxDx3bwS4jGn1Nygn189Pj4CW64xFAhhXQyLxFc6Pqw3gcIOhp3edy6PsDLoWqF/lnJyZfk/KmP8vUWwoxeCLTN2JA7Uu+VS2WXN3elbvwKJDD4M3reoCIVRgVQwYnZh6uGTXsUVtNf+Jo4eb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(39840400004)(136003)(346002)(376002)(451199018)(8936002)(44832011)(5660300002)(86362001)(38100700002)(2906002)(36756003)(4326008)(6486002)(45080400002)(478600001)(83380400001)(6666004)(41300700001)(2616005)(6512007)(186003)(6506007)(54906003)(316002)(8676002)(66556008)(66476007)(66946007)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oei8tgtQlAcvbLLxQYQ0x+tXR5bd+UuCN1TtwPoVlgoSq4o6YPx5QjtsCLfa?=
 =?us-ascii?Q?dxxAPzaYQujuaRSkS38sq+DCStuOClIjQ615zNsjGyg97xNi3QiZh7AH/54s?=
 =?us-ascii?Q?9TwZ6XRPlBl5CoHsYuAt8AZvAbSF9ooG1elAPdc5FLMLeYuZtlEDfpVc+gD1?=
 =?us-ascii?Q?CEWOBcBDYnL72lTily1ikKKIy4mGUCY2v5BIQk2CvxuIAvfsBcBApLvln1go?=
 =?us-ascii?Q?CjNvvr6JAoV8pMnviVY10tNUIahQZPjUDbHwx1JuLrFxZZXN/ywiJnVFn2nH?=
 =?us-ascii?Q?jccxRXpDe4FCp+9uT/heA+DFdBbL26jupQhHBDf2P/cvSip9BQ/mWdlpOHEl?=
 =?us-ascii?Q?seGQW9xunLszMaJ4jLuh80mYe0q+vR0ABC6zCT3ag5ng23wmJaayJn7MwNEv?=
 =?us-ascii?Q?OVfnFUv3Q0kzs/aBUMIBQBZBm4sG3qdKnyHGPmC4OPV4IzNquB9VFaK05UqF?=
 =?us-ascii?Q?07Dge0Y7FwEEJDLhZDs9KyIERgWcCgQ06HWnLC/uDHi3TJyVUUSIVPOdu78z?=
 =?us-ascii?Q?6mylFyQVie3tuRUJszZi0kNdBQKOb0nAlZVo2xcmcXa4QkPx69/CSIUu30OS?=
 =?us-ascii?Q?QEAy4io+oz8aXUjnemGGi54XrZ4uS2rDdcrhvuw5jOc1i0Pq8k3w1Qe1MbzF?=
 =?us-ascii?Q?i7vR1nzVO6PbUFmgcvZ+ooSlyNkViO/C1HSShrLSzimgyDVGX9hNkMJPumHi?=
 =?us-ascii?Q?M7ZtCFpMTotQYur77E1qDoHn9FFrJMb6Vyb3tn96rpsxxUnY+KCxV/mzkb9E?=
 =?us-ascii?Q?V/xcMPGvUAt8/wSeXDWQTl5MWDVJ478lhgEn7oyfoixyb4xBUOgbaJrQgQxA?=
 =?us-ascii?Q?zduSUoEWVUvl9Ox7t5KfLgD8y+ZG8qnbsbCXAOeKjvqG6wVcxJRLm5GaAWM0?=
 =?us-ascii?Q?monKIuRnAPxsrTe98k4kil2+0nooIJa4ITw+FnhGuWL7DpL0VnpW82K0Lw+i?=
 =?us-ascii?Q?qiL4rjP0ttSCfPL14J7NzMjhdn0FN8+ZLCluxoUjc61t683cB18g7jWLOc3U?=
 =?us-ascii?Q?1FeSSJ6pAvT7qG7sua21ZHgSRJKO9vh8STQloeWbeMu9g57V1E96At5E6NBO?=
 =?us-ascii?Q?MB1eWpoZldtXq+Qmcy5BEYuWtlrpJCCuwLaqw7Ii8PWhcWgTiOWM5XCZH9Ss?=
 =?us-ascii?Q?zCoSZR1y3//PYF9mmOcAMX4CmzXfQrrIJ4Hz8dLXpzBiRHbMqqehcmkbeKdq?=
 =?us-ascii?Q?6z7KdlUE6wuqCcR7tVAY1jRVa0/l/GAZykQ6gOvhTdTp6MbesdR/FTY72uHp?=
 =?us-ascii?Q?rwzGAdAfiT7bhj1n8wIwb4ZrhrtaKSotBpjl6KBJloEqkv8Y39OY6Ex7yWPm?=
 =?us-ascii?Q?ktoyrMDCY6PH8qrMSnebc6zbm8tE/IlApNv9Qc0N8ag5UGR/TLEV3VHg4dxF?=
 =?us-ascii?Q?6ucTLMpZPnsz2nuVC0v2Fnp6WOIfCaoncK84pQkJLwDazU/nnjPhG+AZ8Pc3?=
 =?us-ascii?Q?6g4+DuPOCOT35rx0nttv0oCmaq1222lJhDaczxzwQAB18aRNVfk3JsXs93ZX?=
 =?us-ascii?Q?GTF5mo7vbmkfpFxVXi2gTDqY+axZq6aFPZE3i1umJY716WSzzywNli736vYY?=
 =?us-ascii?Q?KHx65vGVjiBOAY/fEKOnIZCH2FlzkFLn9LOG4JL3l4uOMEz51yWlG1htAdtZ?=
 =?us-ascii?Q?rroRc8pMjoimV00SMq1SI4B/Uq3n0CyqI9E98mg4s1Oij/U0aHNyawk4zAev?=
 =?us-ascii?Q?4SgFrw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d8a0acf-6a05-4207-21b9-08db29d8f5fb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 06:53:22.3201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DdMKaee9Fu4Ww+hZG9DHFv+obSS/+kSWG7SDZcmtFfE98TkjRTde4v+cyNkK8isOFV/vyMA3uhrUKmL8qMnUmg0n1Viya7wXgj9SEit9gXE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3808
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 04:34:27PM +0000, Eric Dumazet wrote:
> Drivers should not assume skb_mac_header(skb) == skb->data in their
> ndo_start_xmit().
> 
> Use skb_network_offset() and skb_transport_offset() which
> better describe what is needed in erspan_fb_xmit() and
> ip6erspan_tunnel_xmit()
> 
> syzbot reported:
> WARNING: CPU: 0 PID: 5083 at include/linux/skbuff.h:2873 skb_mac_header include/linux/skbuff.h:2873 [inline]
> WARNING: CPU: 0 PID: 5083 at include/linux/skbuff.h:2873 ip6erspan_tunnel_xmit+0x1d9c/0x2d90 net/ipv6/ip6_gre.c:962
> Modules linked in:
> CPU: 0 PID: 5083 Comm: syz-executor406 Not tainted 6.3.0-rc2-syzkaller-00866-gd4671cb96fa3 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023
> RIP: 0010:skb_mac_header include/linux/skbuff.h:2873 [inline]
> RIP: 0010:ip6erspan_tunnel_xmit+0x1d9c/0x2d90 net/ipv6/ip6_gre.c:962
> Code: 04 02 41 01 de 84 c0 74 08 3c 03 0f 8e 1c 0a 00 00 45 89 b4 24 c8 00 00 00 c6 85 77 fe ff ff 01 e9 33 e7 ff ff e8 b4 27 a1 f8 <0f> 0b e9 b6 e7 ff ff e8 a8 27 a1 f8 49 8d bf f0 0c 00 00 48 b8 00
> RSP: 0018:ffffc90003b2f830 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 000000000000ffff RCX: 0000000000000000
> RDX: ffff888021273a80 RSI: ffffffff88e1bd4c RDI: 0000000000000003
> RBP: ffffc90003b2f9d8 R08: 0000000000000003 R09: 000000000000ffff
> R10: 000000000000ffff R11: 0000000000000000 R12: ffff88802b28da00
> R13: 00000000000000d0 R14: ffff88807e25b6d0 R15: ffff888023408000
> FS: 0000555556a61300(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
> CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055e5b11eb6e8 CR3: 0000000027c1b000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> <TASK>
> __netdev_start_xmit include/linux/netdevice.h:4900 [inline]
> netdev_start_xmit include/linux/netdevice.h:4914 [inline]
> __dev_direct_xmit+0x504/0x730 net/core/dev.c:4300
> dev_direct_xmit include/linux/netdevice.h:3088 [inline]
> packet_xmit+0x20a/0x390 net/packet/af_packet.c:285
> packet_snd net/packet/af_packet.c:3075 [inline]
> packet_sendmsg+0x31a0/0x5150 net/packet/af_packet.c:3107
> sock_sendmsg_nosec net/socket.c:724 [inline]
> sock_sendmsg+0xde/0x190 net/socket.c:747
> __sys_sendto+0x23a/0x340 net/socket.c:2142
> __do_sys_sendto net/socket.c:2154 [inline]
> __se_sys_sendto net/socket.c:2150 [inline]
> __x64_sys_sendto+0xe1/0x1b0 net/socket.c:2150
> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
> entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7f123aaa1039
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffc15d12058 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f123aaa1039
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
> RBP: 0000000000000000 R08: 0000000020000040 R09: 0000000000000014
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007f123aa648c0
> R13: 431bde82d7b634db R14: 0000000000000000 R15: 0000000000000000
> 
> Fixes: 1baf5ebf8954 ("erspan: auto detect truncated packets.")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Hi Eric,

A quick grep seems to indicate there may be similar problems elsewhere.
I didn't check them in any detail and I'm wondering if you might have.

In any case, this looks good.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

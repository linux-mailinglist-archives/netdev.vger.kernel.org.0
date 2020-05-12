Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 244731CF6F8
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 16:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730210AbgELOXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 10:23:51 -0400
Received: from mail-eopbgr80105.outbound.protection.outlook.com ([40.107.8.105]:48718
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727876AbgELOXu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 10:23:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a7vEQWvad7oX57rHBq91OKbZj+hNpDtimDjdiQ/ntQfMQIqnuPQ2IGdGJJhvnZM5vYHRjO9FKfp+g3yMdtoqkV0dmKvrL9LMbbrjnRwD3VghgTQBmoQN5bsYDth1NFltJBUUSn7MwZkuhgHhb2lvjepe4b62o/ZrsGMwW4BGVfk6681EixP4+zyNV6se5ysPRvy9xLEN7aRYxxVCYyMj/Ev2Zqx1P/TpkN9+LCN1ZAOrlu4W4+AVsgpQGnr63inHbouBciN6hZxaYTxTDObznTrRAg/dWcy0OsQCHWbIvUpmGByu37BWGc7x/c/wj5stqoRfpTZfgvmErD7yg3pTyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c2I4ykrsuKppGL2qWQxtWRHxE+l7srJYcuIyspvBLWo=;
 b=lkud0SCF4eqVNdPiyCclDy7fZCMDOH9mHsYUFyCK+EQNUKh7Clazb5p8W3hhU4daHUUOdPmMWGcHPj5gjsGlwGVXdOZipSXY84evERwMcKUipFl9hQRqQ3fuc5K4O0HxaiRGRLFYgMNzRFRInOmgrBJNqFPBOV5ktKEmzH0Cg9NgwNU4/G2brcUU7YQwGH+6TGAfS2dXIKyxZmS7xmFE9uzyscoUnY4kJgGgIA1x8kLThanYJ/YMzk8+NQKez8tF0uZUersi3+t+/ObfTNybVCXsv7bMfb0+ZkyGJzR1ut70hcpoPHcTLe/PR0zHoUQNgqXmdLlYanLQl/JBr1TXug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c2I4ykrsuKppGL2qWQxtWRHxE+l7srJYcuIyspvBLWo=;
 b=rVyoad3Qc/gaJU8vk0CFRJOJ/KanUJs8Pm+npeu42TZS7X3YHSq+TrpEo7Vj4qpPzra30FD3jOT9lVHWfO3gnpkQulbdC5CSnGs2Khs1LLs6ehG2xL6sRicYqFdI0OVg+Z9GOtpy9/PLwK6xn5ExM81pHGghDk4L6dswid+7orU=
Authentication-Results: nokia.com; dkim=none (message not signed)
 header.d=none;nokia.com; dmarc=none action=none header.from=nokia.com;
Received: from AM0PR07MB3937.eurprd07.prod.outlook.com (2603:10a6:208:4c::20)
 by AM0PR07MB5827.eurprd07.prod.outlook.com (2603:10a6:208:110::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.13; Tue, 12 May
 2020 14:23:43 +0000
Received: from AM0PR07MB3937.eurprd07.prod.outlook.com
 ([fe80::6958:35d6:fc84:49db]) by AM0PR07MB3937.eurprd07.prod.outlook.com
 ([fe80::6958:35d6:fc84:49db%7]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 14:23:43 +0000
From:   Alexander Sverdlin <alexander.sverdlin@nokia.com>
Subject: Multicast from underlying MACVLAN interface towards MACVLAN
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Jiri Pirko <jpirko@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nokia.com>
Message-ID: <8e6e5260-9359-eddd-c928-dba487f1319b@nokia.com>
Date:   Tue, 12 May 2020 16:23:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR03CA0021.eurprd03.prod.outlook.com
 (2603:10a6:208:14::34) To AM0PR07MB3937.eurprd07.prod.outlook.com
 (2603:10a6:208:4c::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ulegcpsvhp1.emea.nsn-net.net (131.228.32.166) by AM0PR03CA0021.eurprd03.prod.outlook.com (2603:10a6:208:14::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Tue, 12 May 2020 14:23:42 +0000
X-Originating-IP: [131.228.32.166]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f5a3e575-a392-406a-dc95-08d7f6801315
X-MS-TrafficTypeDiagnostic: AM0PR07MB5827:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR07MB5827D5F2A3AE0997F75F8A8388BE0@AM0PR07MB5827.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cdepB9KbICMa3UFqu59WkeXakTzanROhVTXugUmJa4ShCw3boe41fcd6mxbshJq0mkniiHWGTbfNHZHoTL8A1GgnD/Kv5Sx7pa2tHBCyje6Yq9b3YBXgI3y0N8wkOA75wTsTbkVYSXJJDiCq7ryGtPBGM0auHGCkDaX08UXItDjSUmiUD0d2LmZPkHJJW2p5SvEROyMv9nOFIYJK0GzvY5QdhX9SmjSqyPH4vJmyTijd06ku0921v1D/jlYAYc1TyCCt3F9Ehb+mUCDfzJ44ibIDF+UbjD4xI/h6U6Zoqnp/UyS1POptKyFCVlMv9sq5pV/aVx4WcJpQtOnrdmZ3NO64Q7R9eK8za/SnYfVn31YpO/7BMO7HsxzA+wiCZTgKA3IudwNC2NFGldoGCPdtPQE7dSNv6/+rVPPr19zMLdL+ALnNoVAr19UJrsWtKvhl/c2o89TGtbYazZDpwPMAYEr2+nic0UFc6vkLb7mzpJP0dBRyblKZqG004LUogBOTsQXZTzlpcqi7M4xoyplhaakCQNCI7JZ+zy5MGy4NEUfZ3mz7VkNZcF1sMP3BUmC3kV26NaJoPhVIiDGFaVicMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR07MB3937.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(366004)(39860400002)(346002)(376002)(33430700001)(36756003)(16526019)(107886003)(44832011)(316002)(5660300002)(52116002)(54906003)(8676002)(6506007)(66574014)(33440700001)(8936002)(26005)(186003)(31696002)(4326008)(956004)(6512007)(6916009)(6666004)(2616005)(2906002)(66476007)(86362001)(66946007)(31686004)(66556008)(478600001)(6486002)(43740500002)(505234006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: qAZzVMIBhIwyHgUi2477nE6nbsbaZUn8WU+Ht76GzUykN8B7XMjKg3cBINQi+JiueQNiDySGip5S6AkiG/0CUeJiF502PqwaScB5RMaCPhhbhhmEteTxXr/c4dOds8ONeQibLfx6CD6ZxnHiT/LCkQeBCGIaOM5WUtK7s8yuqLAnssCdZhf2qS5plz1/DaXG2q2+eIuCylbLBnxWuq2wpDsx8mrg420QUqP/GnO0CxkDWHiAW9h98laodOuXVrLd8+zTLr2DV0gSA+z6IzB/EnauN/a1gqXKFBL75vTe+t0rvMMCpbuERH1qZMtrmvzVgFkcRQt/+Gb3pNduUPnto1P8v9w8D6x7fEoRklbEoepSh04f6sJvnGme6sFV3VO1s4QrAf6+RKSIqq+QsG3t4EoyDdd/qlyDDUyF4rX/w1j9769dFie1ymSDcKv75fbRPyGMEE68LT/A9Ym3pG534EARIY3DJeA4E2iXj3t4UYqKg/OmJeq9NfYCweIobNvw
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5a3e575-a392-406a-dc95-08d7f6801315
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 14:23:43.4190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S64bD3KRPXXPTtNrEc5f4e6cAag11fCx8edls9klVk120+nwdeVJloYT2zsPk18A20e6epYOSVGpENNgDYavi+HZetXQCrzGC6zW8JZhD0c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR07MB5827
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Network Core developers!

I've been debugging an issue with Multicast replies from underlying
interface of MACVLAN towards MACVLAN. These SKBs never contain a MAC header
and therefore cannot be properly processed by MACVLAN.

The usecase is following:
eth1 <-- eth1.212 <-- macvlan@eth1.212 (in bridge mode)

As I understand the problem, it actually plays no role, that there is an intermediate VLAN interface.
The problem is, if macvlan@eth1.212 sends Router Solicitation these SKBs are received on eth1.212,
but the corresponding multicast Router Advertisements are not received on macvlan@eth1.212.

I've tracked the problem down to the following incompatibility between MACVLAN code and IP code...

One the one hand, MACVLAN always expects ethernet header:

static rx_handler_result_t macvlan_handle_frame(struct sk_buff **pskb)                                                                                                          
{                                                                                                                                                                               
        struct macvlan_port *port;                                                                                                                                              
        struct sk_buff *skb = *pskb;                                                                                                                                            
        const struct ethhdr *eth = eth_hdr(skb);                                                                                                                                
        ...
                                                                                                                                                                                
        port = macvlan_port_get_rcu(skb->dev);                                                                                                                                  
        if (is_multicast_ether_addr(eth->h_dest)) {                                                                                                                             

One the other hand, IP doesn't populate ethernet header for multicast loopback transmission:

int dev_loopback_xmit(struct net *net, struct sock *sk, struct sk_buff *skb)                                                                                                    
{                                                                                                                                                                               
        skb_reset_mac_header(skb);                                                                                                                                              
        __skb_pull(skb, skb_network_offset(skb));                                                                                                                               
        skb->pkt_type = PACKET_LOOPBACK;                                                                                                                                        
        skb->ip_summed = CHECKSUM_UNNECESSARY;                                                                                                                                  
        WARN_ON(!skb_dst(skb));                                                                                                                                                 
        skb_dst_force(skb);                                                                                                                                                     
        netif_rx_ni(skb);                                                                                                                                                       

Unicast however works fine, because of:

int neigh_connected_output(struct neighbour *neigh, struct sk_buff *skb)                                                                                                        
{                                                                                                                                                                               
        struct net_device *dev = neigh->dev;                                                                                                                                    
        unsigned int seq;                                                                                                                                                       
        int err;                                                                                                                                                                
                                                                                                                                                                                
        do {                                                                                                                                                                    
                __skb_pull(skb, skb_network_offset(skb));                                                                                                                       
                seq = read_seqbegin(&neigh->ha_lock);                                                                                                                           
                err = dev_hard_header(skb, dev, ntohs(skb->protocol),                                                                                                           
                                      neigh->ha, NULL, skb->len);                                                                                                               
        } while (read_seqretry(&neigh->ha_lock, seq));                                                                                                                          
                                                                                                                                                                                
        if (err >= 0)                                                                                                                                                           
                err = dev_queue_xmit(skb);                                                                                                                                      

I've also collected some stack traces and SKB dumps to illustrate the problem
(I've instrumented macvlan_handle_frame() and eth_header() to understand when
the ethernet header has been generated):

macvlan_handle_frame() receives Router Advertisement, but cannot forward
without Ethernet header:

skb len=96 headroom=40 headlen=96 tailroom=56
mac=(40,0) net=(40,40) trans=80
shinfo(txflags=0 nr_frags=0 gso(size=0 type=0 segs=0))
csum(0xae2e9a2f ip_summed=1 complete_sw=0 valid=0 level=0)
hash(0xc97ebd88 sw=1 l4=1) proto=0x86dd pkttype=5 iif=24
dev name=etha01.212 feat=0x0x0000000040005000
skb headroom: 00000000: 00 28 b3 4d 84 88 ff ff b2 72 b9 5e 00 00 00 00
skb headroom: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
skb headroom: 00000020: 08 0f 00 00 00 00 00 00
skb linear:   00000000: 60 09 88 bd 00 38 3a ff fe 80 00 00 00 00 00 00
skb linear:   00000010: 00 40 43 ff fe 80 00 00 ff 02 00 00 00 00 00 00
skb linear:   00000020: 00 00 00 00 00 00 00 01 86 00 61 00 40 00 00 2d
skb linear:   00000030: 00 00 00 00 00 00 00 00 03 04 40 e0 00 00 01 2c
skb linear:   00000040: 00 00 00 78 00 00 00 00 fd 5f 42 68 23 87 a8 81
skb linear:   00000050: 00 00 00 00 00 00 00 00 01 01 02 40 43 80 00 00
skb tailroom: 00000000: 00 f0 01 00 00 00 00 00 a4 73 00 00 00 00 00 00
skb tailroom: 00000010: a4 73 00 00 00 00 00 00 00 10 00 00 00 00 00 00
skb tailroom: 00000020: 01 00 00 00 06 00 00 00 40 66 02 00 00 00 00 00
skb tailroom: 00000030: 40 76 02 00 00 00 00 00

Call Trace:
 <IRQ>
 dump_stack+0x69/0x9b
 macvlan_handle_frame+0x321/0x425 [macvlan]
 ? macvlan_forward_source+0x110/0x110 [macvlan]
 __netif_receive_skb_core+0x545/0xda0
 ? ip6_mc_input+0x103/0x250 [ipv6]
 ? ipv6_rcv+0xe1/0xf0 [ipv6]
 ? __netif_receive_skb_one_core+0x36/0x70
 __netif_receive_skb_one_core+0x36/0x70
 process_backlog+0x97/0x140
 net_rx_action+0x1eb/0x350
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

Later when the same RA is being transmitted neigh_connected_output(), this is the first
time Ethernet header is being generated for this packet, but this is towards "world", not
the internal MACVLAN bridge:

skb len=110 headroom=26 headlen=110 tailroom=56
mac=(-1,-1) net=(40,40) trans=80
shinfo(txflags=0 nr_frags=0 gso(size=0 type=0 segs=0))
csum(0xae2e9a2f ip_summed=0 complete_sw=0 valid=0 level=0)
hash(0xc97ebd88 sw=1 l4=1) proto=0x86dd pkttype=0 iif=0
dev name=etha01.212 feat=0x0x0000000040005000
sk family=10 type=3 proto=58
skb headroom: 00000000: 00 28 b3 4d 84 88 ff ff b2 72 b9 5e 00 00 00 00
skb headroom: 00000010: 00 00 00 00 00 00 00 00 00 00
skb linear:   00000000: 33 33 00 00 00 01 02 40 43 80 00 00 86 dd 60 09
skb linear:   00000010: 88 bd 00 38 3a ff fe 80 00 00 00 00 00 00 00 40
skb linear:   00000020: 43 ff fe 80 00 00 ff 02 00 00 00 00 00 00 00 00
skb linear:   00000030: 00 00 00 00 00 01 86 00 61 00 40 00 00 2d 00 00
skb linear:   00000040: 00 00 00 00 00 00 03 04 40 e0 00 00 01 2c 00 00
skb linear:   00000050: 00 78 00 00 00 00 fd 5f 42 68 23 87 a8 81 00 00
skb linear:   00000060: 00 00 00 00 00 00 01 01 02 40 43 80 00 00
skb tailroom: 00000000: 00 f0 01 00 00 00 00 00 a4 73 00 00 00 00 00 00
skb tailroom: 00000010: a4 73 00 00 00 00 00 00 00 10 00 00 00 00 00 00
skb tailroom: 00000020: 01 00 00 00 06 00 00 00 40 66 02 00 00 00 00 00
skb tailroom: 00000030: 40 76 02 00 00 00 00 00

Call Trace:
 dump_stack+0x69/0x9b
 debug_hdr+0x4c/0x60
 eth_header+0x71/0xe0
 vlan_dev_hard_header+0x58/0x140 [8021q]
 neigh_connected_output+0xa9/0x100
 ip6_finish_output2+0x24a/0x590 [ipv6]
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

I would appreciate any hint, how to approach this problem! I can try to come up with a patch,
but as this is so central thing in the IP protocol, I'd like to hear some opinions first...

-- 
Best regards,
Alexander Sverdlin.

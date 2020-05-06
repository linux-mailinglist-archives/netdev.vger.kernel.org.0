Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF6B1C6E63
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 12:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729187AbgEFK3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 06:29:38 -0400
Received: from mail-db8eur05on2087.outbound.protection.outlook.com ([40.107.20.87]:6019
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728338AbgEFK3h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 06:29:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UZuN8AwzKi04XvMO1jOJwhzEmedSCiPOPne5lpo799KZw93B1P0OaQHBE7HinQgWv5PGHQ1HTLlJCFQ8nLpFfYkO8Qa25n3keVFlymMVonP8aqcT8gCnEMvyYOqO5W/cbnOQlAauE4HpZ/GvLAQrYI/Jco6wiQqcHLomikkGwrk4ALmSMR9tbqeHbTF8FCZqYOiG9nA3iexm0tT6EdmtSraKXtklGAKSGVG82k+ZNLAaxYqdk0grkqseq2D7n9ysJBd+VLMzpUHm3Q/IMyigIi1YGoT72EQhzwf5HeUWw4FoBHeieifFJdbciNazaATkLhGfdAl/8AvLoIIGkdHn1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=unzjZB6SKHxmsMAbHs/9iDMykTq0ZOH0vy+yqshZxAY=;
 b=R6Psk3yCueOCIh/RATh2RSshRVxYLV84ruk7MK3iQAgZfri+fpwGMUT7bnX+9i7zYtjshazgfxdlcb1LvGjjkiQ8wswsTVTJ8aMkfw9O6bccidMRjxHbr1jziqXLpNtpNy1ugPEmFPQqckJlZxwJ0/SDJi6qK1SQcNX/CocvYG/kbd7o/O1yYR5l5O4lTzyRN8CRYT9+FfFivGQY3NETN347+laUUYnKD6mY1dtd79rAXMf61DWrrjTcufmS+onQNcoKn94tINdTVJFPT5y7d4fqx8irGLCSDHx8JhTn31VAjEA/+a1yC8w3MoUa9YBmZf85hnGw8PTxxJg4+2KeAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=unzjZB6SKHxmsMAbHs/9iDMykTq0ZOH0vy+yqshZxAY=;
 b=g7kbJY1KExUP5n8GBtsgMMdSx8QmLGy5B4HCvez1GYdVhLGPUNHfaMKmvAESaxjX2vwyNdjtER4kEx4XtyEgLAssYybHxeua124KCj6aSJ7LNFhpycxn1K8ne16vKG1XLH7lJci7AXIDOhewCFXhIJRDsPpzeWTDmTS64SJNB4M=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB5089.eurprd05.prod.outlook.com (2603:10a6:208:cd::25)
 by AM0PR05MB6291.eurprd05.prod.outlook.com (2603:10a6:208:137::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Wed, 6 May
 2020 10:29:33 +0000
Received: from AM0PR05MB5089.eurprd05.prod.outlook.com
 ([fe80::a8a8:5862:d11d:627e]) by AM0PR05MB5089.eurprd05.prod.outlook.com
 ([fe80::a8a8:5862:d11d:627e%6]) with mapi id 15.20.2979.025; Wed, 6 May 2020
 10:29:33 +0000
Subject: Re: [PATCH v2 1/3] net/mlx5e: Implicitly decap the tunnel packet when
 necessary
To:     xiangxia.m.yue@gmail.com, saeedm@mellanox.com, roid@mellanox.com,
        gerlitz.or@gmail.com
Cc:     netdev@vger.kernel.org
References: <1588731393-6973-1-git-send-email-xiangxia.m.yue@gmail.com>
From:   Paul Blakey <paulb@mellanox.com>
Message-ID: <e4b01443-296b-174f-9fed-09bae6d2a737@mellanox.com>
Date:   Wed, 6 May 2020 13:29:29 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
In-Reply-To: <1588731393-6973-1-git-send-email-xiangxia.m.yue@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM3PR07CA0053.eurprd07.prod.outlook.com
 (2603:10a6:207:4::11) To AM0PR05MB5089.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.50.62] (5.29.240.93) by AM3PR07CA0053.eurprd07.prod.outlook.com (2603:10a6:207:4::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.11 via Frontend Transport; Wed, 6 May 2020 10:29:32 +0000
X-Originating-IP: [5.29.240.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8137db03-7f02-4493-1b00-08d7f1a85e10
X-MS-TrafficTypeDiagnostic: AM0PR05MB6291:|AM0PR05MB6291:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB629100AFC358AEC9D487FF48CFA40@AM0PR05MB6291.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:972;
X-Forefront-PRVS: 03950F25EC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OwrMaVoc0OFi1kJqG2T/Jdpxo7vFh/JXgw0wXbt5gVP/7Y7nLpQuI1kq+eKEoKIqRmmJGoXPLAwoFWHOieqOM2QK95heKGyoww5IIuaoO3FShmi4aETTP3hly9nVoXixT+aAlrlT7X2U6AdJImtp7QV1osHZMwJWB3odDbfrXssDudPukGuYHiIipWdfrWdkkjs/s7SBh+w4dR8RiqsyQlAmDUGULFLhvgSbH61lh4Mik2wBynb/V1FMIYD0umECdlGs9z0A/Dz1xDGYO6L6ktTLScz65eyia8yKRxjvLk+fJU+LOA8kyfGBJmdwcxV+pGlQGWNn55TWHK3JvM8P01rig7CHt8kFNtaRDlVvLcNR4QPdUgJqiF+7i+jqcO77m4F9ZVx5wml20jk9SOwbSSkMkCun1s6MwE09uFaADfcHrG3XSDp37bIYKgKROXyWgheDs1fhJDna4gn/yaj77pcfoKzxobpqqkXhKg9ae061Eqm+HIjC7zHMt08PoCPNfrQv8UtX0cUoZLOBIDw7b5uY2fxStHkYrBF55hG52zqRML7whZbAXRjzbGrQP2GZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5089.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(39860400002)(376002)(136003)(396003)(33430700001)(66946007)(6666004)(66556008)(26005)(66476007)(8936002)(33440700001)(316002)(8676002)(16576012)(36756003)(86362001)(6486002)(2616005)(956004)(4326008)(31686004)(478600001)(16526019)(186003)(52116002)(2906002)(31696002)(53546011)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: PfagOv83AP+algWOMnTHi0GsGp+ewh1rH9tkwwaJ0BnHrj92Cf7t2p2xXWynxW5LnvgAPp8eoM10FfVRwAEHqceC2S7iSR7OCcz4YbRCvtdcghvi4pp9FkNtwj7yoPl2+OdUxOwwbuhHWyabvQAAvJFavlMaLUFj8AiIlT+/fK9YqTtSBHeo87pBL/rTpdhVAtlsJS/dFwMPYhZ5QI9rYXisNiLDzF6kyVr0vIxlMHgm2vR8BVav2FY+uF+uAXmCz8PhYFVvZM0ov+Rp1Rw3g2LCOFMlPq9OGJydR0V17/8CeZbeL0PGcoR2Vg/zWklRJXf2U54dnqLMTQJ0UL7H9/QGTlkfTGT3k9Ma1qsQRYZe3/AWLZQnrMxJ25AnDpQDsjmPX6nkGhDqCe95LZ2Qhx8lwG2EYWjL3ZMXPKuoOjbzR8078jJjoT93o5uw5+6eVQmeJeZJd1jM/RFWUL2kquc3Sii2n1U6I3Ap/3FfkBaZSpFU8Qy5DnCThm6MgsbFtA34fMjp6bncyGwP29ZRDRc15d+q4SjmrFVtkCC6wMr7mNyfa+Vj1fMZoXW7ITZTSIkY+TcebsQs0yAeohGkcmMB+/hfj/40mUBLE2PD6g/L6eFw+6g8nZWwO3lFlUTguCzimlCAsV/xWFfTn8il6XQteO5oTgSNUyQBYL2lNyby4FSq9cdzpiliHa3ilprGq7s8cHpRtgIL8p4+G26Hox8YEKd/BkAOJt3HY25EJH1zGx/c8BvImQs0A0cQFOegrOIccLThdexwP8gw14foovimNdCIT/sKyERLiZYdEzM=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8137db03-7f02-4493-1b00-08d7f1a85e10
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2020 10:29:33.3086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dWQt9/KnFusSK9ImrmUlaT5ZeOJ4u8p53HCt8QJaU9jTYRiKcBWeqlP99RYiZJE5qkoDAmoJE55+lE5yc2ZEoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6291
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/6/2020 5:16 AM, xiangxia.m.yue@gmail.com wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> The commit 0a7fcb78cc21 ("net/mlx5e: Support inner header rewrite with
> goto action"), will decapsulate the tunnel packets if there is a goto
> action in chain 0. But in some case, we don't want do that, for example:
>
> $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 0	\
> 	flower enc_dst_ip 2.2.2.100 enc_dst_port 4789			\
> 	action goto chain 2
> $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 2	\
> 	flower dst_mac 00:11:22:33:44:55 enc_src_ip 2.2.2.200		\
> 	enc_dst_ip 2.2.2.100 enc_dst_port 4789 enc_key_id 100		\
> 	action tunnel_key unset action mirred egress redirect dev enp130s0f0_0
> $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 2	\
> 	flower dst_mac 00:11:22:33:44:66 enc_src_ip 2.2.2.200		\
> 	enc_dst_ip 2.2.2.100 enc_dst_port 4789 enc_key_id 200		\
> 	action tunnel_key unset action mirred egress redirect dev enp130s0f0_1
>
> In this patch, if there is a pedit action in chain, do the decapsulation action.
> if there are pedit and goto actions, do the decapsulation and id mapping action.


We can't do the decap only if there is a pedit action, we must be consistent for
the matches.
Consider the following rules:

tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 0	\
	flower dst_ip 1.1.1.1 enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100	\
	enc_dst_port 4789 enc_key_id 100 dst_mac 00:11:22:33:44:55      \
	action pedit ex munge ip dst set 3.1.1.1		        \
	action goto chain 1

# this will do DECAP + REWRITE (originally inner ip, now outter ip after decap) + GOTO

tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 0	\
	flower dst_ip 1.1.1.2 enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100	\
	enc_dst_port 4789 enc_key_id 100 dst_mac 00:11:22:33:44:55      \
	action goto chain 1
# this will just GOTO

tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 1	  \
	flower src_ip 1.1.1.192 enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100 \
	enc_dst_port 4789 enc_key_id 100 dst_mac 00:11:22:33:44:55        \
	action pedit ex munge ip dst set 3.1.1.192                        \
	action goto chain 1

With your change,  Match src_ip 1.1.1.192 here, should match inner headers or outter headers? 
As we might have come from the decaped path (inner dst_ip 1.1.1.1) or not (inner dst_ip 1.1.1.2), depending on inner dst ip.


Alos, in tc the packet is already decapsulated by the tunnel device before it gets to tc ingress classification,
tunnel key unset just remove the tunnel info metadata so we can't match against it. It doesn't decapsulate it.
This flow:
$ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 2	\
	flower action mirred egress redirect dev enp130s0f0_0

passes decapsulated packets to enp130s0f0_0, without specifying tunnel key unset.
We want to follow this implicit decapsulation.
 


[...]

> 9 test units:
> [1]:
> $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 0	\
> 	flower enc_dst_ip 2.2.2.100 enc_dst_port 4789			\
> 	action goto chain 2
> $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 2	\
> 	flower enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100		\
> 	enc_dst_port 4789 enc_key_id 100 dst_mac 00:11:22:33:44:55	\
> 	action tunnel_key unset \
> 	action mirred egress redirect dev enp130s0f0_0
> [2]:
> $ tc filter add dev $VXLAN protocol ip


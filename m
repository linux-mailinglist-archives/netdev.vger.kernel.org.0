Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 402B4686A95
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 16:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232045AbjBAPp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 10:45:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232476AbjBAPpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 10:45:14 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2093.outbound.protection.outlook.com [40.107.92.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D51F16469E;
        Wed,  1 Feb 2023 07:45:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gQm/OBkKEMqWxC9zObSe8cZfyYZJnT7FhZRFZCy7+J73NfTuRHqNupsSpotzltQbXAFkxEkECgu6fmjL5lwTnL5gHRt99I8n4DNckx7AK9JsCJG+3lie5+V7vJyaBzP5bT4CLMylr50ih2nE7vBSDClbNmEkxS+NSvzUJBlpMsuIAcQR70wUdyv2qPnrKKCOsHoEYcbTa16jci4f9EgeKQ8OIvaL7YBipU809KZ8/JIlnoUVwK0s2nB4I3Pdkujm+c0FefUeKZk3H2231535sZPGA6LWBjtb4GgmrARoO8pHphjlrO/gabYsP/3Qk4g8I8sc8I9wO4ABVWrdfiROtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=liwQimdw3pugrDtNYqamaUZL2lvEJZM47DdzYbHiwkg=;
 b=eWfmpaBi9se0wBhQM/qGDutJpaXRAmKNoRWUYYc84veVXjHLkuhHWFWnqpOpM4BBwDBmOgUZeDiyMx3fXNHIG+Bp5Lu++0vKcc8gTgENDS72hsk8OD+/msMuQ4rYBzzNfi37yukNaCWkd9UGAL338ilAESx2mdUC+GdwIpU1cxQc09tthB8JReYEruzHA+7vLVCkLstclLnsLwwcNnZwbtYnTWFcBEaZS6KFjJSifCwpvyZ2vOSIPrFFHnE03fVkTeCtaxJnnivYJlVQvSOOS+Yj1YKnLLAxDaRINHon4juvyUsjco0hQQjVxMKlYTtrYy5Zkxt11TgeYLSMEvkM3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=liwQimdw3pugrDtNYqamaUZL2lvEJZM47DdzYbHiwkg=;
 b=pmUsPoOjHMKOoEL3y7IBcgQotHmBqcaA4e0hcBynunFwhhSnd3zxqlX6MzKNbqPGBDSii/YJ2bqyLBiVmhxXdh7+xYb2LiQH0SIDJ/9M0Vp65VwDxqjvl4eFpTyljXQCWmAxGQEjVsuRMg66st5ve77Lg/f/AGTKOL4k/m3z+QY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5592.namprd13.prod.outlook.com (2603:10b6:510:12b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Wed, 1 Feb
 2023 15:45:09 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6064.025; Wed, 1 Feb 2023
 15:45:09 +0000
Date:   Wed, 1 Feb 2023 16:45:02 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH] net: openvswitch: fix flow memory leak in
 ovs_flow_cmd_new
Message-ID: <Y9qI/vBRPlDFwkAh@corigine.com>
References: <20230131191939.901288-1-pchelkin@ispras.ru>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131191939.901288-1-pchelkin@ispras.ru>
X-ClientProxiedBy: AM3PR03CA0065.eurprd03.prod.outlook.com
 (2603:10a6:207:5::23) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5592:EE_
X-MS-Office365-Filtering-Correlation-Id: 50961d12-9c4d-4243-e0f7-08db046b4c65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v1gXcB/m94mp2k6fp4eULdURVERrgTI/GBwIE1GbN1LykJVgCZCr66mAyYdiFmLR4cJ6CQfxaXls1WzNmPS9aqs75Pt4lI5o0BL+LryJD3DurRRhHObsF7oBVqcvKIY8LpQgnX2/R9co2PzHvnsO9nwWDVjy7+T8AgcSohjf+Vaj/joLb5A7xR3D9RSeccQQ4Sckqkb8UTdrks4Qe/hsflVo8RoQCRaFlK6o3WLvTkKY/rW9GnFfdPK+mkuqTNxi9fiUViujgOJs3pP1IXrwO3SGwXAi7Hs+Cj3g/NWT8zBogFGn14qVOu6Mp7hDBP7VJGELhN1EH9ge1kN+fpTTW4Aov/5+Pjonnl/gINj2rAkBJQZf/S2XciVcuzgWaso+L2H/NAZLOpTMEs+nC8TtH3arvyofbxKZGfujGovq9zjlVSW7UUvOCglfhukFBPSoDeuwyFSKf3q9S/mc462wZZhn6LqRgGJVOAuvCkPTweW8zNYL/aRylto71PX9omewnFiWBa113X1Huc3wLsvxJ6fjpyAPpqko+z6gtz004Rs48qKO5sNL9zSZyb2aZSUC+h9XKhbtJ6mUkznObU7miZl3VrbUFZapIhHb/rdD05y7lUukiznIAajQ/trfQyXR0YnvX0nMy/XOLvsc7kvlVTPjHQ+pWOpS0ec2O74XgVocyZY8rAeLcqNys2k9o+G5oLoYcN5+QUSwS0BvEDIv4HPor+4Sw3pezcHn9GwGuE09SFDt5TB3PZeJGiCSRX2m
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(396003)(136003)(366004)(39840400004)(451199018)(44832011)(5660300002)(7416002)(8936002)(2906002)(54906003)(6506007)(83380400001)(86362001)(41300700001)(6666004)(6916009)(66476007)(8676002)(36756003)(66946007)(478600001)(4326008)(6512007)(186003)(6486002)(66556008)(2616005)(316002)(38100700002)(505234007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9a68RawcPvHhT/UExUgnB8N/uM32On8yqC18blzOGu52Fi+eta+yEuUf+knk?=
 =?us-ascii?Q?rC8k4lCrctQ4Ku/2IhGGk7pin0cw6huFEvNJXv2tr5b8WjicKQVnr7om05xT?=
 =?us-ascii?Q?893CrhEEg3PGMZ72JlumeLB8uCXAtmAPZMBjoOzNxg/VJokq+MehqK/jNDVy?=
 =?us-ascii?Q?pZifG0xSF2w2t2+bf2CnotMCSbGTozmlwLLoOFjKef3xcvZPIdBc6uO9GLft?=
 =?us-ascii?Q?WCf37P229aQcLC9u4PZJH+gKI5lh30c8JVHwf0N/Xwrfn/33g45GKqH0VRgx?=
 =?us-ascii?Q?v7RJbwhzD4rK8k4KO8TR1TbEaKh0/NMzySM8FFHUbE26gbKVt4/Yb59paZE3?=
 =?us-ascii?Q?y33SoiA3aqgGMk+Pwl97N1HvvfrAyqgjmM8TsmALM9Zuwtkw89lx2Hv0gSOO?=
 =?us-ascii?Q?Yn/DjcI8KyegMQNbgisEBKxWTfmFJ3zEfiGtc92RlMsdu6Z8KWE130U1Adqj?=
 =?us-ascii?Q?zrxgkSnNHQzVwiPwqfMZw2DKs9N69MBpN2+efihhpuZ5Avc/zWMfO39ZGXFf?=
 =?us-ascii?Q?n/uNGNtbfdvHIQ25oRGC9hri7TpvIylNDzgdq+z54nyuMCm4oF4OxttzJBzk?=
 =?us-ascii?Q?hvZ6afjrEHTqdLC7RvME5/pmDlPK2qaFF4UPM5pB9UZO7M4jvUjHzUwDO+3/?=
 =?us-ascii?Q?qwrn2a1FcJVD5z863+c6NRv+Kn/LhuTcTEMV05/gBqsVd3Nxb1v46v6YwQH3?=
 =?us-ascii?Q?J10F1eyifjfshydsHYzOVtHk/xf4yiH46IQ8n8jo0DBsn7lvHSMirIwlBvvC?=
 =?us-ascii?Q?pX3PVMJ4fh3pkzzoZSHkw/NBYcWo55xdq0ccGzbXfGZwqclvThLhWb0Id9Lj?=
 =?us-ascii?Q?7a6gqmSdIrOORUgyeG8l1wr/QL1PTDqMcT2kN85Nf+jvz43kbGZp5ZoUa7SJ?=
 =?us-ascii?Q?ZNsabwU0Hy4xmGGGbUWP+GLwz+IpMNVxblLRnrSWpu3PlExCNsg4dNFnDcCE?=
 =?us-ascii?Q?qIrbjFtkwd5FM0u/jg7s6QnBtaYnkV6aSZ2nD/G+14gxyue/bN+CO+1nhyGk?=
 =?us-ascii?Q?H8/UMH+3lgCSJbttt9MD9unM1Zrc53HxlckZ0bUb9RW8NDoYdODpAvEcS6jR?=
 =?us-ascii?Q?NajxyR0EvlYewDDUWiuaCD5lkrAWfvfMIaLxactvAEuZ0ANRLSscU9jMq6Ro?=
 =?us-ascii?Q?wG66udjA2Nzf/Tx0AqKmdzUDKn/f1x0Z7ev9F4nlfK1wyO+cEgBytbjSLkT+?=
 =?us-ascii?Q?AMoabzdNfhoecAzUymK/ACv7kMpfWHga11NCeSeWjkRaI2dv+iOzt8NtnJmP?=
 =?us-ascii?Q?c+UQlTN7PPnqDkOBomBGueptvb4aGHC550CqEsWbJ51FVmC38OYaM2NzNV6m?=
 =?us-ascii?Q?/3+epTUFwMfChl4XwqxiDxsEvMfB+E6T9MuaPd5sfJH7bRAmDHgvusATTjyb?=
 =?us-ascii?Q?SpwsonOqfkJnbX7lqNPjMCAeGvkU3LbCZNSfSYPc0jymp8KLTt4cA/auhGJz?=
 =?us-ascii?Q?p3BJFjHs+ukX6I/F6UeQA0D/Wl2Cef8mmo52edcTO/uMR3K1efKJfKf26u1G?=
 =?us-ascii?Q?MLh6mW5EBtosFVjVAsfL1lbO3h4mB0PpvEqgaK7GAeFeS1K3YSpHNVy4QLGP?=
 =?us-ascii?Q?uwnBlIdxLasntK8NNzyaXQYbipXl51GGtGBAsGl8PO1Y9+KWL9IzpbKeABDf?=
 =?us-ascii?Q?7Z6SGrcPeG0KXFGINaeIY736H/vSnk5kyJXJpy+N3OrYC2SyeYeQ3Q8kAsJO?=
 =?us-ascii?Q?nbipag=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50961d12-9c4d-4243-e0f7-08db046b4c65
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 15:45:09.6889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6eGBoXwMAjR3CoE7c/FPHvCu28EtjnlqeD5vZ/kYETYg614+C8MJu6Xvf9N+trF2n00R3mOu5hTa7DAkGbMlmrwNDpUOcWNY8Nj6+nQVKq8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5592
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 10:19:39PM +0300, Fedor Pchelkin wrote:
> Syzkaller reports a memory leak of new_flow in ovs_flow_cmd_new() as it is
> not freed when an allocation of a key fails.
> 
> BUG: memory leak
> unreferenced object 0xffff888116668000 (size 632):
>   comm "syz-executor231", pid 1090, jiffies 4294844701 (age 18.871s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<00000000defa3494>] kmem_cache_zalloc include/linux/slab.h:654 [inline]
>     [<00000000defa3494>] ovs_flow_alloc+0x19/0x180 net/openvswitch/flow_table.c:77
>     [<00000000c67d8873>] ovs_flow_cmd_new+0x1de/0xd40 net/openvswitch/datapath.c:957
>     [<0000000010a539a8>] genl_family_rcv_msg_doit+0x22d/0x330 net/netlink/genetlink.c:739
>     [<00000000dff3302d>] genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
>     [<00000000dff3302d>] genl_rcv_msg+0x328/0x590 net/netlink/genetlink.c:800
>     [<000000000286dd87>] netlink_rcv_skb+0x153/0x430 net/netlink/af_netlink.c:2515
>     [<0000000061fed410>] genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
>     [<000000009dc0f111>] netlink_unicast_kernel net/netlink/af_netlink.c:1313 [inline]
>     [<000000009dc0f111>] netlink_unicast+0x545/0x7f0 net/netlink/af_netlink.c:1339
>     [<000000004a5ee816>] netlink_sendmsg+0x8e7/0xde0 net/netlink/af_netlink.c:1934
>     [<00000000482b476f>] sock_sendmsg_nosec net/socket.c:651 [inline]
>     [<00000000482b476f>] sock_sendmsg+0x152/0x190 net/socket.c:671
>     [<00000000698574ba>] ____sys_sendmsg+0x70a/0x870 net/socket.c:2356
>     [<00000000d28d9e11>] ___sys_sendmsg+0xf3/0x170 net/socket.c:2410
>     [<0000000083ba9120>] __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
>     [<00000000c00628f8>] do_syscall_64+0x30/0x40 arch/x86/entry/common.c:46
>     [<000000004abfdcf4>] entry_SYSCALL_64_after_hwframe+0x61/0xc6
> 
> To fix this the patch removes unnecessary err_kfree_key label and adds a
> proper goto statement on the key-allocation-error path.
> 
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
> 
> Fixes: 68bb10101e6b ("openvswitch: Fix flow lookup to use unmasked key")
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  net/openvswitch/datapath.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index a71795355aec..3d4b5d83d306 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -1004,7 +1004,7 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
>  	key = kzalloc(sizeof(*key), GFP_KERNEL);
>  	if (!key) {
>  		error = -ENOMEM;
> -		goto err_kfree_key;
> +		goto err_kfree_flow;
>  	}
>  
>  	ovs_match_init(&match, key, false, &mask);
> @@ -1128,7 +1128,6 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
>  	ovs_nla_free_flow_actions(acts);
>  err_kfree_flow:
>  	ovs_flow_free(new_flow, false);
> -err_kfree_key:
>  	kfree(key);
>  error:
>  	return error;

I see this would work by virtue of kfree(key) doing nothing
of key is NULL, the error case in question. And that otherwise key is
non-NULL if this path is hit.

However, the idiomatic approach to error handling is for the error path
to unwind resource allocations in the reverse order that they were made.
And for goto labels to control how far to unwind.

So I think the following would be more in keeping with the intention of the
code. Even if it is a somewhat more verbose change.

*compile tested only!*

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index a71795355aec..fcee6012293b 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1004,14 +1004,14 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	key = kzalloc(sizeof(*key), GFP_KERNEL);
 	if (!key) {
 		error = -ENOMEM;
-		goto err_kfree_key;
+		goto err_kfree_flow;
 	}
 
 	ovs_match_init(&match, key, false, &mask);
 	error = ovs_nla_get_match(net, &match, a[OVS_FLOW_ATTR_KEY],
 				  a[OVS_FLOW_ATTR_MASK], log);
 	if (error)
-		goto err_kfree_flow;
+		goto err_kfree_key;
 
 	ovs_flow_mask_key(&new_flow->key, key, true, &mask);
 
@@ -1019,14 +1019,14 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	error = ovs_nla_get_identifier(&new_flow->id, a[OVS_FLOW_ATTR_UFID],
 				       key, log);
 	if (error)
-		goto err_kfree_flow;
+		goto err_kfree_key;
 
 	/* Validate actions. */
 	error = ovs_nla_copy_actions(net, a[OVS_FLOW_ATTR_ACTIONS],
 				     &new_flow->key, &acts, log);
 	if (error) {
 		OVS_NLERR(log, "Flow actions may not be safe on all matching packets.");
-		goto err_kfree_flow;
+		goto err_kfree_key;
 	}
 
 	reply = ovs_flow_cmd_alloc_info(acts, &new_flow->id, info, false,
@@ -1126,10 +1126,10 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	kfree_skb(reply);
 err_kfree_acts:
 	ovs_nla_free_flow_actions(acts);
-err_kfree_flow:
-	ovs_flow_free(new_flow, false);
 err_kfree_key:
 	kfree(key);
+err_kfree_flow:
+	ovs_flow_free(new_flow, false);
 error:
 	return error;
 }



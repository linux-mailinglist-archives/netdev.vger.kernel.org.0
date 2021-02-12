Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43D6631A4B8
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 19:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbhBLStg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 13:49:36 -0500
Received: from mail-bn8nam11on2069.outbound.protection.outlook.com ([40.107.236.69]:23009
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229832AbhBLStb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 13:49:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z8kpB+JafVEdVP9ftRFhGz+jkQx1Yjp8rXKepRaQmg6GUgS/v3nvXFdkPvQ+aYZQEqgBZZ+0qmM/5TCE8aC100zsGIg98PcTeCLmtiHPHYJWDXuiwn2eG7zFueKyJKLYtxQ7VF00RBIi1BOUExBgizmjvKtGEJKM0sOEaNZ1rnI9qtKRaOPlunHm4xQvEKeeki6n7Oq34c3lAmj0kne+MY2xf25OZ5zGr9oXknkF8Ba5W/4MGFVtY57+D/vjBc1vigZ6LGTOQ3BymylRjosh5mWiuCoUcQtXL+NK2bc/cURv4IpPRVuxjThXzDlUu0V/tzJO6D1iPNj2q8eZZKN9BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nzHXMaSN4cqsOgYCpt3uUFjXwXdOU6nXvPqfm3jEcXE=;
 b=hkWNnnSgd5s9Bond37ZdUZXNMASzSaQjWFG14dD8R0U0ttGcLkEB+l4DDp4JWs9Vz2AzKIzj26/1UtVIDMZK4S2zihnscNKWtkhFouwI0mLoHSB5LfPUZUoM7iNDhx7+8313JmOCQWey7Ln6/+GEozCMSi0AOQVxjHKVSTg5J7xQIOwC/5Sgp9Dsipa7ZkSCTbGMP0VWyRsDd9XQFOd2ruKNUY55908Ia6+hga27/gHKmI7oPOAzubKtk/K8bxbDGvSoGvYP2TYkZLeBz+Si+vytkn81LqZ04G4uscWjXaxysRb6+2GwglytsXcjfNsA+68sRWHU0EbcJtGJryUBcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nzHXMaSN4cqsOgYCpt3uUFjXwXdOU6nXvPqfm3jEcXE=;
 b=xkDkqK8HfU6HlWBk3U00FxbC0RU3reCgPq7I8DV8wiy3l4rdlReQ0zDV/zlAMI/ZtEwSUbodxVnMxp7cv4Ix3mhpaUN4SO97dJOuIPHklFUWagi1TuZRisEYmDiBqhEkUUixx+72HLjE7gSyod7J8+jQEfIN/lr4suY5riSzKac=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3846.25; Fri, 12 Feb 2021 18:48:38 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70%6]) with mapi id 15.20.3846.034; Fri, 12 Feb 2021
 18:48:38 +0000
Subject: Re: [PATCH 2/4] amd-xgbe: Fix NETDEV WATCHDOG transmit queue timeout
 warning
To:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Sudheesh.Mavila@amd.com
References: <20210212180010.221129-1-Shyam-sundar.S-k@amd.com>
 <20210212180010.221129-3-Shyam-sundar.S-k@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <24d9fb7d-d7af-53d3-60a2-348391c799ef@amd.com>
Date:   Fri, 12 Feb 2021 12:48:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210212180010.221129-3-Shyam-sundar.S-k@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA9PR13CA0105.namprd13.prod.outlook.com
 (2603:10b6:806:24::20) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA9PR13CA0105.namprd13.prod.outlook.com (2603:10b6:806:24::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.11 via Frontend Transport; Fri, 12 Feb 2021 18:48:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8f1ff1fb-0c45-422a-ed95-08d8cf86cef7
X-MS-TrafficTypeDiagnostic: DM6PR12MB4337:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB43372A470C7866D31017C312EC8B9@DM6PR12MB4337.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7vtwCWNEFhrM4K0azv4o2nIwJ3L1G+5Neeh3QUl1CpVxMDrsTuFCu9xA/F85pz9sV/6NRLR4uvPbLJtm67SQr8gz5y3NCjn4bnnoTOkHRIYTT7j7XB71XEHv1JBH5SvFur6fsLyMcHaQ7NvVulw5SFuT4GI90r4S/JPv0clclbWvP1YcUCRvNBNISXRzCT81GJoPb8GF4HtehULeQNfKnOJvzOtzaCsy3aqb4RvUeGZalNkH39dzVujfaBq7WSZnQluGApKafDMPILgM3ZFLdS+Ldoa870dAOU329nFHg+ypbB8VQVxqZp7EOmQqvA0oCQX2hy2uiitG1IEjVsrf/e8LRbrOU7YGO8T/8NZrUQjH7bMLW4wKEjyAB8c38z9X2FErwn9ArxrqE3il/SITx/6TcmSaDctY5uszi1+8ZoBkp19qekYi/W3IUJSkKxjjV786O/54DAnw1aiDscRksSSp1m8wqKQXZ1Nv223q+OIfJBXcNZe8Mk8k5eQ1tfWxp66gxO/ki7KzQAbk6/lEx82d8wR1q8TzaZyqccidLn6l8dH9wS6Am4vFqNalmCBCAiEMi1TBNabKL4dGCOpWyyLCHzhQ/t+jh8DsuF3FW44=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(366004)(346002)(136003)(4326008)(5660300002)(53546011)(8936002)(6506007)(52116002)(6512007)(478600001)(45080400002)(2616005)(956004)(36756003)(186003)(8676002)(83380400001)(6486002)(31686004)(66946007)(66556008)(66476007)(2906002)(316002)(26005)(110136005)(86362001)(31696002)(16526019)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Zmcrc05RM3gxSFNkN2xjZWdUL1BjbWVqbGppeDRoZ0Z4ODFZSStVdUU3Q3pz?=
 =?utf-8?B?ZkUxMWpLQUtkQkJWd1k3ci9RbnJEWmR4ZGp2QW1tcllMdG9CQXRHcTc5ZmYr?=
 =?utf-8?B?ZlgxekNxS2ZsU0dyMjk2UDZQclB6ZVVLUU5UNmlpS2s1SW5YVUZWVzJ3Z3M1?=
 =?utf-8?B?ODkzeVpxcWVqOHJCUFlobWx6RzhTVkpyaktHU2FLUHNUNEVMVzlvMWpiWFY4?=
 =?utf-8?B?QnJhdWhYYlcycVhBTUtuNEdIdGYzYWFqUiszSGRvOFowY1B3YVlBMkxkK1Fr?=
 =?utf-8?B?SzJvRVVjRzVSNmtoWHBsVUFaWWVmN0NlS3A5K0VwOFdhSnBrMDEyUW9peTI2?=
 =?utf-8?B?NkJ5WndxR2crdU1mZnViQ0Q5V2hBamh2Nkc4dWZnWUhlQ3J0UXphdWtCWEYv?=
 =?utf-8?B?cmh4djBsZVVueFJwZHkwMVZmTy9TSXdnRXR4dmFOM1kzL2RPdVUvbXlVNG9i?=
 =?utf-8?B?UUxkMDc2UGM1dk9nZ2JrNE9nRjJmcUdWM3hMSFUrZmM3MmtMek1rWnRwVXJo?=
 =?utf-8?B?Z2h6MVdCTFd2amhTdkVJQlZ1dkE2L2RiV3NDWEQ3UGZ1UVdhSm5tUU81R0U5?=
 =?utf-8?B?UlFEZmNGWnd4dFJqRjVRS2I2bURzWGN4ZFZ4SlAzNW4yR1ZRUytETFNEaEoy?=
 =?utf-8?B?aldCTWc1NTM2aDh1S3M2YVFEb21hQWhNKzFGck84YTJzZ0xXa1RhTWhDYXpQ?=
 =?utf-8?B?MTF2dGxDdkh3dittN1VsRGFOR1BBbWU1bDd0YWFNQlZYLzQxYUtMQW9RME1F?=
 =?utf-8?B?dVJlOERSaFJzTEJuekNjaytFY0doaHJ3czlUcVpKcGtJdGQ3K1YrK1lpc0RK?=
 =?utf-8?B?OGZMMDdldVNwL0dleWlTTTM4VzIwTTZSU1BlY09PQ21tZW5DMVJWbDZRQ3hO?=
 =?utf-8?B?bGF1cDhBSS85VmFQMy9EUndVcmUyYWhKU3hMOHdYa2cxL1hCcW9GaHoxUU96?=
 =?utf-8?B?TzhGV2VGWHR5WTRPeHV3KzBoVCtzV293TkVaanJDeTJyUC9Sc3hVbC9yOTR4?=
 =?utf-8?B?clZzeHJ6Yk02amt6MDF6REZtMFptQXdoeHpvZHRsSVFpd3dQVXc5eGN0MUFL?=
 =?utf-8?B?QkZkaUlyU1dXTjM3dDAyZ3ZqL01OY1prR1dFU1I2RkswcXRxcVdHRjNnSi96?=
 =?utf-8?B?Zm5UNUpYWU1JSW9INTQrYkRrYnY1WG85R3VielVaRDhoK1VhMnhpc1ZaVmt6?=
 =?utf-8?B?emVoZ1ZwdlVNbkJ4SnRpRUZ3ZHR2cTdEUEJwZWxJWGZua1RISGZHZm5FWksz?=
 =?utf-8?B?eWg3N2x5bnh1QXJQWVBXbVVPYmFidmNHelFkTGQ3ZkpxNkF3QThqcW1NTEVl?=
 =?utf-8?B?TTI1b1RzblkyOFhWTGthblNjU0lNRmhtRmMrTy9uUkpkUC9jaFBieG01Zjgy?=
 =?utf-8?B?ZmZoVW5SK2ZYRWVMMHVPWituVzNzSjUvWGVLcng0MzNJSVp6RXpKSHR3UGVm?=
 =?utf-8?B?WDhicm9tWTlrcWpvRWVTVVZVOTNqczQ3NC93N2RQenk5OUNJK2hLdUFJNDJy?=
 =?utf-8?B?OWR0VmcyZkJWVmVITW05NisxbXBnS2dGaUl1ZmMvTDRjcWwzYjh2TEpuTitS?=
 =?utf-8?B?SmVHQnYwcU81czd3NENSZlhkK3JvQW9DbnN3RUloU1pneVFSR3ZsT05EcEJj?=
 =?utf-8?B?bVFZVWFZVGk3ekRGZTVJN09oNFA1aU1taWNHNFNLM3FlSUFTUjdQNVEvVjlV?=
 =?utf-8?B?YW84bW9SOTlBckNYc3ptQzYyZGMvNzVYWnVUcTVXWGNlZjlnTkRiRmN5bHVY?=
 =?utf-8?Q?iVC4C04bmzwIZ1btckAHPj3OdowAKayj4XutaCn?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f1ff1fb-0c45-422a-ed95-08d8cf86cef7
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 18:48:37.9296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eOqGO8/n0/4gKuR1XODzLja4ZyCblq9cVAHFYgX6neYl9BxiBrJb8i5bpmCN05SCIWOfjrhS/RqoSPrqniA5kQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4337
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/12/21 12:00 PM, Shyam Sundar S K wrote:
> Current driver calls the netif_carrier_off() during the later point in
> time to tear down the link which causes the netdev watchdog to timeout.

This is a bit confusing...  how about:

The current driver calls netif_carrier_off() late in the link tear down 
which can result in a netdev watchdog timeout.

> 
> Calling netif_carrier_off() immediately after netif_tx_stop_all_queues()
> would avoids the warning.

s/would//

> 
>   ------------[ cut here ]------------
>   NETDEV WATCHDOG: enp3s0f2 (amd-xgbe): transmit queue 0 timed out
>   WARNING: CPU: 3 PID: 0 at net/sched/sch_generic.c:461 dev_watchdog+0x20d/0x220
>   Modules linked in: amd_xgbe(E)  amd-xgbe 0000:03:00.2 enp3s0f2: Link is Down
>   CPU: 3 PID: 0 Comm: swapper/3 Tainted: G            E
>   Hardware name: AMD Bilby-RV2/Bilby-RV2, BIOS RBB1202A 10/18/2019
>   RIP: 0010:dev_watchdog+0x20d/0x220
>   Code: 00 49 63 4e e0 eb 92 4c 89 e7 c6 05 c6 e2 c1 00 01 e8 e7 ce fc ff 89 d9 48
>   RSP: 0018:ffff90cfc28c3e88 EFLAGS: 00010286
>   RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000006
>   RDX: 0000000000000007 RSI: 0000000000000086 RDI: ffff90cfc28d63c0
>   RBP: ffff90cfb977845c R08: 0000000000000050 R09: 0000000000196018
>   R10: ffff90cfc28c3ef8 R11: 0000000000000000 R12: ffff90cfb9778000
>   R13: 0000000000000003 R14: ffff90cfb9778480 R15: 0000000000000010
>   FS:  0000000000000000(0000) GS:ffff90cfc28c0000(0000) knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 00007f240ff2d9d0 CR3: 00000001e3e0a000 CR4: 00000000003406e0
>   Call Trace:
>    <IRQ>
>    ? pfifo_fast_reset+0x100/0x100
>    call_timer_fn+0x2b/0x130
>    run_timer_softirq+0x3e8/0x440
>    ? enqueue_hrtimer+0x39/0x90
> 
> Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
> Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

Same comment about Co-developed-by: here as previous patch.

With the above comments addressed,

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   drivers/net/ethernet/amd/xgbe/xgbe-drv.c  | 1 +
>   drivers/net/ethernet/amd/xgbe/xgbe-mdio.c | 1 -
>   2 files changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
> index 2709a2db5657..395eb0b52680 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
> @@ -1368,6 +1368,7 @@ static void xgbe_stop(struct xgbe_prv_data *pdata)
>   		return;
>   
>   	netif_tx_stop_all_queues(netdev);
> +	netif_carrier_off(pdata->netdev);
>   
>   	xgbe_stop_timers(pdata);
>   	flush_workqueue(pdata->dev_workqueue);
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
> index 93ef5a30cb8d..19ee4db0156d 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
> @@ -1396,7 +1396,6 @@ static void xgbe_phy_stop(struct xgbe_prv_data *pdata)
>   	pdata->phy_if.phy_impl.stop(pdata);
>   
>   	pdata->phy.link = 0;
> -	netif_carrier_off(pdata->netdev);
>   
>   	xgbe_phy_adjust_link(pdata);
>   }
> 

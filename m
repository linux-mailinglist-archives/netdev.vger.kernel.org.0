Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECFB3D88E4
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 09:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234143AbhG1Heu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 03:34:50 -0400
Received: from mail-bn1nam07on2058.outbound.protection.outlook.com ([40.107.212.58]:49568
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233336AbhG1Hes (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 03:34:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CNwzsUN4YzhPNf6QHhbVkBRNYqy1RAYWIzn8OcQqkh9dUgJMkq76+6tG/p+qzkFqRCs9bqO48N8Nv58eJqZvz4wgHmnP2nRGVjdMRVrtcYkC3dlzzzDSxZig5m32nTn0RQDHXtmyibmmueWVDcUmnooQaJN1stgu4g4jcECM2XIijA28jcfKaaLJ9823mzEEWttHePPGu87a3vCkxBvMhYkvR9sCo15AiZA9eayTNmQw4+RyAYp5grNNhOYgGV92m80ZvNWc2sJcKYK0GdG6a4eTjGMzpvdGeaTpz5GmfBYEKvZ0geU9PSr47ijTufS0JAf/UuMgnk0quJ42S2Vu4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rf70/zbRt9xxrXV1nH4TlIR6ajIhv0KZPHIljiOGFKo=;
 b=gLX97SAmwF8iBKInYEz1e735BMLuhuq2mG1vDFIeO3eAmTj0CS6hsAz9gLrqyOs6Ay+CpU9CEU/z691qTgwWx5BXmWPxKIXYX2OGGXZ+yxAACqvPPVR6N9zZENqV6Ue656r+c8DK3wH52TyI1nOhCv2sbiseu50ONLa0xieYdLHo0Hri6CdR6LyWJBbaB3UolyVIRNiHd0c+6KlFrIwMTryrg0AQeoL4LiWoU7IEBhdf16l9vzXm+VgPyZdlxviyCf2VFFcAt6N9Vb/9Y9+X19OdD7BfFck3tUrey0mjuN4Cam3tEvV+FpUsw+JadwaIJ+6tuTuY9G7ommFCuxVi6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rf70/zbRt9xxrXV1nH4TlIR6ajIhv0KZPHIljiOGFKo=;
 b=nKaZj3JipHhx2Ooy2fp4HO6OmFkV4iKqZWSAS1LTt1/FWLlKLosGgWu8h7MmXd6hXg/eutiCtvnKEx24TGblT9tEHs0kxPMQOTyaesu+h4IeL0g8/VMMX0GGPb1XXSCjD/IgL6LIYk+jYjZfp5dCMiVhjnU2dwcAfv8W5emMYX0/jxzMeiG2yfECQKItUJeK3Cp7m2PwgpkIUVzR16Kg7LhSDt6WwllffWZWa1wFSotJSRwXBxtIMky/NTclwSqh2YhdgW8RZRdscSqlEGhsz2Q6JpQxbJDtgfBBZCmmQwZ4RezviBmYCGKoVxaPfIPYOns9QGL73eVT8YstmJRXyw==
Authentication-Results: openeuler.org; dkim=none (message not signed)
 header.d=none;openeuler.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM6PR12MB5519.namprd12.prod.outlook.com (2603:10b6:5:1b5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26; Wed, 28 Jul
 2021 07:34:44 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287%5]) with mapi id 15.20.4373.019; Wed, 28 Jul 2021
 07:34:44 +0000
Subject: Re: [PATCH net-next] bonding: 3ad: fix the concurrency between
 __bond_release_one() and bond_3ad_state_machine_handler()
To:     Yufeng Mo <moyufeng@huawei.com>, davem@davemloft.net,
        kuba@kernel.org, jay.vosburgh@canonical.com, jiri@resnulli.us
Cc:     netdev@vger.kernel.org, shenjian15@huawei.com,
        lipeng321@huawei.com, yisen.zhuang@huawei.com,
        linyunsheng@huawei.com, zhangjiaran@huawei.com,
        huangguangbin2@huawei.com, chenhao288@hisilicon.com,
        salil.mehta@huawei.com, linuxarm@huawei.com, linuxarm@openeuler.org
References: <1627453192-54463-1-git-send-email-moyufeng@huawei.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <47d9f710-59f7-0ccc-d41b-ee7ee0f69017@nvidia.com>
Date:   Wed, 28 Jul 2021 10:34:35 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <1627453192-54463-1-git-send-email-moyufeng@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0072.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::23) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.208] (213.179.129.39) by ZR0P278CA0072.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:21::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 07:34:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 107cfddf-a6e1-4ea0-c5a8-08d9519a2b21
X-MS-TrafficTypeDiagnostic: DM6PR12MB5519:
X-Microsoft-Antispam-PRVS: <DM6PR12MB55194BC2CD066758CD8A896BDFEA9@DM6PR12MB5519.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5EWih8skP4DeUIpBApwkDKJ3i26jmlTmBNz0m0M5DOKW8nrCXTUlRZf9FS20mwlsie2JX7X7V+MOp1Sg6p1rjDR6FPyZLsKHGxBfyX2rDlpsuIZ6V4foiM4yLLdPaX4VWd5p7vnf3UoPK5ugP4fdaT8Azz37bg4r/WvCuRaGHEFohYcGv9VsgihQvhfZSKE3/Jwbxb4xUz8GvyuQQ12mJVNle0KRv4/wY7K5Jc+q1LHPPjaW5R+Etndv/+bEOi9hIt2pmppapZcazO5SCkNrArhUnXzKZPNMBRTrUckhb8oA37CB/iYFhYxbS8jANOWbAVv1VlcWCQtopx2cc4Q3MzGsTbkzKVfyFZI4cn0vnOszF+Yh57AMjKoRWekAThNbKpcUpEe1D8IfmXb9HdAxBPc2IkKPgeaGGAgyPpQrtG7+Ci8PfsjG5RHO2EXXI92seaFRoc97j0mdjZxowXh/GNEBBaBIgQFNYaNa5SbgtAtk+/wIIV9O/b6jGW/MNDhhDZTq2C8LZIP/Kq692FR6i4DKoH1wa+9SEfwW59n5E063xaxS1tUH4ubMBl+0yJpg8es/QeMIEoj7575iQ4zov8jaAZxXD1zCw/kI7T7fwYniA4C0kfPgVaselzXKHillYsWErncpftd2wQhPk/Ia/AF+iBrkluXVc9Y+LpGTTbB5JLXmZKB0cFwZ1WNRYGhmAQKOBZQTTu9YuAUMtbpq2Z5RCfbas8eL6/4lCLQ9KN6LHcRa2Pklfci7AGf8bijxkTCh1AgEZZXvq9oYEibJU3x8HCXQttGtbB686dH8deevTguFkOAIKngqregh7Wxr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(8936002)(8676002)(6486002)(16576012)(956004)(478600001)(316002)(2906002)(38100700002)(6666004)(66556008)(5660300002)(66476007)(36756003)(2616005)(86362001)(186003)(83380400001)(53546011)(26005)(7416002)(4326008)(31696002)(31686004)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cUtwR1lNaXZYdy9PUmR1RXp4VldYOEZuMmJsUzdYbDJOTEM2YlJ2TWFMa3hZ?=
 =?utf-8?B?MFJRRXlvMzVZM05hUWUwUExNNXBMSXpBUWt1WUUwRGZjTURsZXpFRHZHYVc2?=
 =?utf-8?B?eVNidk1tVEhudldXYThlRTZJYSswc0hpTzRGUGtPVkpPUzdlYmZaMnRoeHVR?=
 =?utf-8?B?Y3pMMm5zNFZOMWs1VXlxMEJtbnpMV1h4bWpFVVpWRUQxS0w2V2RCWnRkTEJ6?=
 =?utf-8?B?dFJhSlZXT2ZKeXJEKzFIK1pSK3VyZ0w4OEQrRDFrZE5XeU1CaDVtVmIxLzNT?=
 =?utf-8?B?bmd5YTJacnRlZ1ZvV0ZsbzIvVk0ySVh4QjcvZXBLd3dQNzZYQWJYUk1WZU5k?=
 =?utf-8?B?eE1lRU9DVHo4M0RrTFJ6cFl2MWpoWEpKMnkvQ3VjdmR0QTZ4ckFkSlVibHpT?=
 =?utf-8?B?TzBvV3BkYllzcmhIQUpycmF4TzZjUjk0c21LNGVNYXlER01WWGRoTG9VYlZZ?=
 =?utf-8?B?cUhMUGpVNVB0K0lHei9TQ05wTElWbCtCTElJeUZpdVZDK3lLdlhmTEEwbm1Y?=
 =?utf-8?B?STdvaUhjZTRNV3d3RnZDdWdldE95U0xDYlNjYlk4c0IrelRhcndCdmx5YUpr?=
 =?utf-8?B?WUw5aFFQZTRJcWdnMVh0SWJLa1dvRkI5V0k2cGVJS0JJMk5WVGJTbW0zQVlT?=
 =?utf-8?B?U1VMS2dMNjNsa2VsbnN6UHd3RUt0YzQ3NEpCRzBIejd1RG1MNi92TzFYTzB2?=
 =?utf-8?B?blhpM1VMcWJzWStrallwQ2t0UEcxSk5PLzFjNC8xeXQ5ZE1PU1dTQUZEWW5D?=
 =?utf-8?B?SXVteEc1RkFSNWgzRVp0WUNiZldPMlZiTk1ncks1QTEvQkdPNUJ6eEQ5eUZK?=
 =?utf-8?B?NCtLd3o5V0FxUWw5UjFCVWdTMUU2amlPWSs0RkdVbXV5dHN6Tm92T1NXNkcr?=
 =?utf-8?B?dXRJdC9lTUxaZVN4MFZ4Zm1HSHhWb3gvQU9KNXZlWkJydytXNDNSM21mTit1?=
 =?utf-8?B?cWtUK0UzQlBLTUFQK095eHcxeDB6aDJyMGVMaWpyekFKaEJucDkyeDBCZ0xZ?=
 =?utf-8?B?dWE3UUxDcnZZbE54Q3QvVjZNMjl2K3Y1T1lrSXJGUmkyVXJRYkh3VC93T2FH?=
 =?utf-8?B?VFFGSDRUTUd2ZkY0SS9heFZSaUxyd1pRMGh4KzI5dFB3RE02aE1MbUtVQzc0?=
 =?utf-8?B?YmFPT1NndEZra2l3QUFlVG5oQjNsOWY3dytEN0kwSmphVXV2RFV6citVQWI4?=
 =?utf-8?B?dEJlTlZhK2NYUUpXUloyelNvdnZHTWlocUQ0OUxUdjFudDBpeUc3aE4yMkM1?=
 =?utf-8?B?T05rTElWbjBYb2xkNERZUU1kZ1JCU1Nza09hWjI3ci9ISzJsTk5qUW5tUHFQ?=
 =?utf-8?B?aURxa1NaVFh5eVJ5Tm44L0FnN1kxZEoxWjY5OWc4bHBFRFhPSEFzcWpBNmJh?=
 =?utf-8?B?am03RENqSHNZTk1HYmlrY0NqRGN1Q1ZteVIwSVVEeVRwMkwreUExQzRMR0xa?=
 =?utf-8?B?d1JMT0JIaWxhVWxIa1U4MnN1RERhNlhGSnFyZHRZdS9uanlEa1llQitzS2FU?=
 =?utf-8?B?OWpDZkx0OWRQb2UzZEh4YUcrU0xQUXZwL3Jtc1pwTzVqOS9CL1BlMFRFall0?=
 =?utf-8?B?bHBSSWNVTTRJOWJuRStKQ0N6YUNWeHpuMHFzcjFWVGorTXgwVmdTSVJSbS9T?=
 =?utf-8?B?K1QyMk9SLzFCNmFoVGhrOGppM01ETVR0dkI1aTlaSUlLR0tscW9HT0hhSGlZ?=
 =?utf-8?B?UndwekpjN0R0V0IwdkpiTFhZd2tIcDdPWVlUQ2VEdVdvbmVlQXZJZFJjZHFU?=
 =?utf-8?Q?uCEnVHWfSf8Bt4hnaUDU4szl/mhVGX8pZ/IhglX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 107cfddf-a6e1-4ea0-c5a8-08d9519a2b21
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 07:34:44.3925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NNeMruL3XL3iQB8UqzUDY+10oXUMGvgQpi8wvNlYJOH/Fg39dQmiX0+kkpv7dyrGnNHByWigTrq0NJ+RuOK0bQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5519
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/07/2021 09:19, Yufeng Mo wrote:
> Some time ago, I reported a calltrace issue
> "did not find a suitable aggregator", please see[1].
> After a period of analysis and reproduction, I find
> that this problem is caused by concurrency.
> 
> Before the problem occurs, the bond structure is like follows:
> 
> bond0 - slaver0(eth0) - agg0.lag_ports -> port0 - port1
>                       \
>                         port0
>       \
>         slaver1(eth1) - agg1.lag_ports -> NULL
>                       \
>                         port1
> 
> If we run 'ifenslave bond0 -d eth1', the process is like below:
> 
> excuting __bond_release_one()
> |
> bond_upper_dev_unlink()[step1]
> |                       |                       |
> |                       |                       bond_3ad_lacpdu_recv()
> |                       |                       ->bond_3ad_rx_indication()
> |                       |                       spin_lock_bh()
> |                       |                       ->ad_rx_machine()
> |                       |                       ->__record_pdu()[step2]
> |                       |                       spin_unlock_bh()
> |                       |                       |
> |                       bond_3ad_state_machine_handler()
> |                       spin_lock_bh()
> |                       ->ad_port_selection_logic()
> |                       ->try to find free aggregator[step3]
> |                       ->try to find suitable aggregator[step4]
> |                       ->did not find a suitable aggregator[step5]
> |                       spin_unlock_bh()
> |                       |
> |                       |
> bond_3ad_unbind_slave() |
> spin_lock_bh()
> spin_unlock_bh()
> 
> step1: already removed slaver1(eth1) from list, but port1 remains
> step2: receive a lacpdu and update port0
> step3: port0 will be removed from agg0.lag_ports. The struct is
>        "agg0.lag_ports -> port1" now, and agg0 is not free. At the
> 	   same time, slaver1/agg1 has been removed from the list by step1.
> 	   So we can't find a free aggregator now.
> step4: can't find suitable aggregator because of step2
> step5: cause a calltrace since port->aggregator is NULL
> 
> To solve this concurrency problem, the range of bond->mode_lock
> is extended from only bond_3ad_unbind_slave() to both
> bond_upper_dev_unlink() and bond_3ad_unbind_slave().
> 
> [1]https://lore.kernel.org/netdev/10374.1611947473@famine/
> 
> Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
> Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
> ---
>  drivers/net/bonding/bond_3ad.c  | 7 +------
>  drivers/net/bonding/bond_main.c | 6 +++++-
>  2 files changed, 6 insertions(+), 7 deletions(-)
> 
[snip]
>  /**
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 0ff7567..deb019e 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -2129,14 +2129,18 @@ static int __bond_release_one(struct net_device *bond_dev,
>  	/* recompute stats just before removing the slave */
>  	bond_get_stats(bond->dev, &bond->bond_stats);
>  
> -	bond_upper_dev_unlink(bond, slave);
>  	/* unregister rx_handler early so bond_handle_frame wouldn't be called
>  	 * for this slave anymore.
>  	 */
>  	netdev_rx_handler_unregister(slave_dev);
>  
> +	/* Sync against bond_3ad_state_machine_handler() */
> +	spin_lock_bh(&bond->mode_lock);
> +	bond_upper_dev_unlink(bond, slave);

this calls netdev_upper_dev_unlink() which calls call_netdevice_notifiers_info() for
NETDEV_PRECHANGEUPPER and NETDEV_CHANGEUPPER, both of which are allowed to sleep so you
cannot hold the mode lock

after netdev_rx_handler_unregister() the bond's recv_probe cannot be executed
so you don't really need to unlink it under mode_lock or move mode_lock at all

>  	if (BOND_MODE(bond) == BOND_MODE_8023AD)
>  		bond_3ad_unbind_slave(slave);
> +	spin_unlock_bh(&bond->mode_lock);
>  
>  	if (bond_mode_can_use_xmit_hash(bond))
>  		bond_update_slave_arr(bond, slave);
> 


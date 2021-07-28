Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40C443D8906
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 09:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234326AbhG1HmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 03:42:24 -0400
Received: from mail-mw2nam12on2077.outbound.protection.outlook.com ([40.107.244.77]:65393
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233277AbhG1HmX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 03:42:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F+ZXMh7A8EVccEROfWW/EOOAANANeQ7O81sfJ+GeZLXj26kCL2S/3Qb0mtQ7lLxtBLCeJROznSuOfgqwLeD226YAiIKCYjWr80ih/8PGF7yg/0WBXIeyf0Ly8hSzjWi0H9WL2XHrr9VvsIeWr3vTaE+Ib+3IzZelgmTI9ehxfvsL/55Z1e89+7J5ylThkow09g4mXQPdYeh0TA009sU6L4vspcCFiTIGsgWAvD/oR3EK64j7q5ePbrsOCzE/+FvFH6Kf8UUkaDtzyD1bwQuM6HRNnTE6FkEdtJdCbjq77cy4ruz/jMm1TKpxgbQPh+lHxXXrXgtw4zSfw+fBAAaVdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gh9+J3nihvYX2zB+JL+F3dDeuwfd1JnJgXGv9UjEzmc=;
 b=T13zhip8ZLrbVhqyAbGEIZVhVTYVUPePr8wl0NfAxTVzqy665FJ/Jngl5pH79TvrPBJ874vLxAFHZWgMQJp5eGt8NN2zcsrOFJQrXRydqIZe6AHO0k8TCviXkLaimmtEjtkEB3PP2DCgsOLQ0I1ML73gPOp1fNo6TbwAxnAEQo8yBlvqqiRAe1EYL1oOg8K1v2x+i9+tI93W80MRW3pX4/atW+4Sard27101BDPRJQyOMz5lNr7isvda1bIMIKfU/b2u1Nx6B5CPHrVz2MX9wBbGmNRRHCASwoIIDI7HV16yNtJQf0F239eniu/t3aL3xYxFmQxhgqGRgw7s/gadyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gh9+J3nihvYX2zB+JL+F3dDeuwfd1JnJgXGv9UjEzmc=;
 b=qRyRslBcepdzwWkflFUYqvDLy0ELotxnY2rR0sBR8E0lbb4dJtuyvBiIQAOeSIWBmu5Ysqizqf2wvVUiDGfphpX2/rQkjy0soeMvGEIV2rjFgItzXidtFQkXaWyxLf3nwuIbN3BJ3ujNFMhjDiI/dkzC9JO2ERbCLmgYdjFyVMh4BfsIZ0zYYZ/cGOvH863aWclYjoszsR44G5MPxP8lDYBIivsdmvmWw4cunOgdAEYs23OLBMo+eWlOvCoeQSG6K0okhsHAAVlIzaTPvYAVz+Jp7L34dNDPvpoJHXxUkOXNEWcknrKXMXSyfaKCRdZzAPt3Zt5oPunfxiRskcON+w==
Authentication-Results: openeuler.org; dkim=none (message not signed)
 header.d=none;openeuler.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM8PR12MB5478.namprd12.prod.outlook.com (2603:10b6:8:29::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26; Wed, 28 Jul
 2021 07:42:20 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287%5]) with mapi id 15.20.4373.019; Wed, 28 Jul 2021
 07:42:20 +0000
Subject: Re: [PATCH net-next] bonding: 3ad: fix the concurrency between
 __bond_release_one() and bond_3ad_state_machine_handler()
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     Yufeng Mo <moyufeng@huawei.com>, davem@davemloft.net,
        kuba@kernel.org, jay.vosburgh@canonical.com, jiri@resnulli.us
Cc:     netdev@vger.kernel.org, shenjian15@huawei.com,
        lipeng321@huawei.com, yisen.zhuang@huawei.com,
        linyunsheng@huawei.com, zhangjiaran@huawei.com,
        huangguangbin2@huawei.com, chenhao288@hisilicon.com,
        salil.mehta@huawei.com, linuxarm@huawei.com, linuxarm@openeuler.org
References: <1627453192-54463-1-git-send-email-moyufeng@huawei.com>
 <47d9f710-59f7-0ccc-d41b-ee7ee0f69017@nvidia.com>
Message-ID: <627397f9-4183-4d29-8e16-e668107e0448@nvidia.com>
Date:   Wed, 28 Jul 2021 10:42:12 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <47d9f710-59f7-0ccc-d41b-ee7ee0f69017@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0056.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::7) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.208] (213.179.129.39) by ZR0P278CA0056.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:21::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 07:42:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7f65754-914c-4edd-654f-08d9519b3b3e
X-MS-TrafficTypeDiagnostic: DM8PR12MB5478:
X-Microsoft-Antispam-PRVS: <DM8PR12MB5478592BB8FCF4AEC8BDAE9CDFEA9@DM8PR12MB5478.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xP8SFhu8FlMZDTzHJ0BohdwGBayvs8crN7HIZYa1wMcL2Y4bfeV9IttFmqtW0L6JgLG5uQwYvVgkuVsbHspZvSAGAnofj3h9423lxBKQ9hp2XCMkl2vT5hMlnjE2+Yb/AA9gytutrks2FVPP78pZHETg6VMs8HNNwUiv6kNRYzQ4HZGTs6+7+mD7d3ySqD0BeOCY7dTY17qwpjDHCSM6GkDQZRlfG+zHYcc/qGmd4W2hW6U9PibPTOiS6fiqXocR+kl+dd3lz6gdZJbYiaoo8V43muoUNGQNJ2BI25LLND9bPttucZPhD23yRZIzkBD2oGtA2Tl2yI2yn/n+QfjXXVXf6rQd1wnmot6vu9LGOF5LWEPU0kDLt5+avHjaj6zqEF47Qmfmo6i6D1syEvuS+BGqPZ4kBUvZFsLiCDN9m3PyTTT50rtJnt3cXtxkotfxJncQTZpkUwqxVbvXq3cGcOdKk6j/k+f8pBRfKzNskzi0uVHTirz0ZqZTim6eWk39NeyZD6np/+E3LEkuK/ps0hFGAU2W/PUclMEhFfHOtuxi/k5GGdwlsvTkHISZMXHgDrhx6rY+MXWEyvytBD/gIL9cSNItIQC2TgN6VQ7vvYEpXWF/eI41ffvCyDfXIzd9yEHIyqVXsZNoT4w/2hSMcVnwh/DiKLp25lmruH0BchpOCdxhC3Mwnu7jmOYPG9JfrnMH7wuhaMEeDv0vFUBd/dPOk2EnkXT2vlaOVHsEAk4OGwiYadT7IqAugUE3BQ7880W2td/oJUUwbI6YZw0CemGpxBlxDXM8Kn3DsAOCY3ZBXbKwHnKCpRjyvSVQpknr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(376002)(366004)(39860400002)(31686004)(6666004)(86362001)(26005)(8936002)(2616005)(478600001)(2906002)(186003)(7416002)(66556008)(956004)(8676002)(53546011)(66946007)(4326008)(66476007)(316002)(16576012)(5660300002)(38100700002)(83380400001)(36756003)(6486002)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Vk5ybWhKMVVtakdRQ0RpNHVOTjRZNU5zZm9acnV5SXcxWXlEQW83bjVFR1Ix?=
 =?utf-8?B?d3pueS92bFllM3dnZjhYT2tEU3VlaTBqZkNMK3ZCenlEd0NZYkYrWkNnQkU3?=
 =?utf-8?B?K0llZkpJTnR1MEtKeEJmUVBqcWNtRHo4RUZ1MGc0aGhFVlBpZzMwQzFQSmhX?=
 =?utf-8?B?ZWNpUlI5dlJsdm1RUHpBcDJ1T1RST1grQlNpWXhXbHlyRHIrMUtwU0xya0tW?=
 =?utf-8?B?TEZEblZjWjN1NVRvRWVGOWd1MFRoNlRrdnRBc2VDWmtxVlFqeTcwdWxDeDZY?=
 =?utf-8?B?VDZxZEhKNzhDc25GU3BweldnZEVNMFlpUFc5UGtGa2lWM3JUTnFlUk9kcEVv?=
 =?utf-8?B?VlRITXV4RUFlMTBBay9tVnRwK0I0dEx4amFvQmtCN29tWXkvQXBaTFNWWk00?=
 =?utf-8?B?b0pxeW82VGt1ZEpBQWdab0NFd1RDc0MzdG5OWE1DcjQzMWM1QXhsTnZjMnA2?=
 =?utf-8?B?b0UrOC9aaXpBZFlVTzdKUGZqWEtTc0VoaUxuRHRrNlNDaldFM205dEFaQk9V?=
 =?utf-8?B?NVAvMjlSMnAvK3BGUG1NaFpTUFBOZWtGSDFBZ3ZKTUtpTFF2Z0FCdFVXa2Iw?=
 =?utf-8?B?SVloRGdKQ0drZUJFTjlsMzdUdmdBNXk2VEg4c2l5U0RPN3pOaGRFZXZ0TlV1?=
 =?utf-8?B?TDRpTERWck10aW4wa0lBQ1V6VFozdDVqd2hnT0ZhVC9ZVWs4NFUvNGg1VzZy?=
 =?utf-8?B?ZDhLZUVJdithZ0RPK2VyaElVRXlrbkJNbU90ZnY2NDFhU2MybElXL0dGY2dH?=
 =?utf-8?B?MzFwcGxvTy9SOFdmbm9JYlNaM3ZibkNOVmlubFlBbkdCSTlQaGVQUC9aei92?=
 =?utf-8?B?Z24rSVhwUzk5L2p4WWFhUkpkS1ZMbXZyZW5yVWhxSmtSSE4vOFFnclhxQ2xo?=
 =?utf-8?B?RjhZME5HcWg5Nkk0Uk9iYS8zZk1WeE1VWDkwQWdUdnVnbHl5OVdjdm9abUhv?=
 =?utf-8?B?YW45V2VmSVRRR29hM2JWN1Z5eHdINDhZSDdDQjZ5d0pkd3orWXhSUlBYLytl?=
 =?utf-8?B?OG1FdUFTN3BLbHgrUzZSYVo4WXFKbFJybllhNmpLN0hDSEtHQytSK2FmMlE1?=
 =?utf-8?B?MVRzN3ZoTkxuN0E2NkFHY2RkWUlmNzR3M3M5TFBFMkhadm5mVVAvWjB0dGVM?=
 =?utf-8?B?dmVuY29sU0dXUUVtcnFEZ1NqcEVGUzhUN1dHeWtZY1N3Vjc4NFBoNVpYcTRQ?=
 =?utf-8?B?S3VMTDhrS1pqeFMyYisxVHpYTm0xS3VjOFhHclJkeGRoaFdoYkNZZ29wZVhS?=
 =?utf-8?B?TUo1ZzcrYzRzbnMvU1BYTFlkN1FPQUlqbjhPT09NbVhXLzU4Z2dSUHRpc1lz?=
 =?utf-8?B?Q3loUklQOXJadHZDRi9oMG81MU5NbG1lQWI4LzVVS1hBYVF5UXB2czJNNDhq?=
 =?utf-8?B?WEV5U3BiRUttWFNhRzlUcGRIR3VmQi8yR0dqbjVyVGR1aFg0NGZwN2VydnBx?=
 =?utf-8?B?UTY4d3lXWUNLN1Zsc3pwOERxNVRwVGF6cjh2dVlqaG11VjdzN0xCQTBPZFhW?=
 =?utf-8?B?T2RKc2tPK1ZyOERMNGFSTnFRencvRmZwRWdoV1dNY3Q0NC8zREY1b29EZWsx?=
 =?utf-8?B?UEdiNkVZMTQ2UkdFVGtwZndaU3E0NVBGL0JzYXIvZm9PQWFqQThlVzE3TFlR?=
 =?utf-8?B?YzBGdCtSVXRySTFkS3BFVDNZNmdxTWJ0UzNveVpSR1U3MG5tSzRVRW9QK1pX?=
 =?utf-8?B?dEtHdlE0VXJKYkdOS2pMK21VeG4vUG9NaGduTjJqYit6YWxWZnpML3VnR0Vh?=
 =?utf-8?Q?FrOMLSIP36fH1qdjqTbXSKjFTi0t+8iFDfuuWBJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7f65754-914c-4edd-654f-08d9519b3b3e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 07:42:20.7243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iUN7EdUdcgNPF0DgOXVEBp8EcRu9jfojFk8orgw/xFjHmPmk7TvRLcavU91J6OdVrFgDEWFW/3mTE9TtCuoX8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5478
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/07/2021 10:34, Nikolay Aleksandrov wrote:
> On 28/07/2021 09:19, Yufeng Mo wrote:
>> Some time ago, I reported a calltrace issue
>> "did not find a suitable aggregator", please see[1].
>> After a period of analysis and reproduction, I find
>> that this problem is caused by concurrency.
>>
>> Before the problem occurs, the bond structure is like follows:
>>
>> bond0 - slaver0(eth0) - agg0.lag_ports -> port0 - port1
>>                       \
>>                         port0
>>       \
>>         slaver1(eth1) - agg1.lag_ports -> NULL
>>                       \
>>                         port1
>>
>> If we run 'ifenslave bond0 -d eth1', the process is like below:
>>
>> excuting __bond_release_one()
>> |
>> bond_upper_dev_unlink()[step1]
>> |                       |                       |
>> |                       |                       bond_3ad_lacpdu_recv()
>> |                       |                       ->bond_3ad_rx_indication()
>> |                       |                       spin_lock_bh()
>> |                       |                       ->ad_rx_machine()
>> |                       |                       ->__record_pdu()[step2]
>> |                       |                       spin_unlock_bh()
>> |                       |                       |
>> |                       bond_3ad_state_machine_handler()
>> |                       spin_lock_bh()
>> |                       ->ad_port_selection_logic()
>> |                       ->try to find free aggregator[step3]
>> |                       ->try to find suitable aggregator[step4]
>> |                       ->did not find a suitable aggregator[step5]
>> |                       spin_unlock_bh()
>> |                       |
>> |                       |
>> bond_3ad_unbind_slave() |
>> spin_lock_bh()
>> spin_unlock_bh()
>>
>> step1: already removed slaver1(eth1) from list, but port1 remains
>> step2: receive a lacpdu and update port0
>> step3: port0 will be removed from agg0.lag_ports. The struct is
>>        "agg0.lag_ports -> port1" now, and agg0 is not free. At the
>> 	   same time, slaver1/agg1 has been removed from the list by step1.
>> 	   So we can't find a free aggregator now.
>> step4: can't find suitable aggregator because of step2
>> step5: cause a calltrace since port->aggregator is NULL
>>
>> To solve this concurrency problem, the range of bond->mode_lock
>> is extended from only bond_3ad_unbind_slave() to both
>> bond_upper_dev_unlink() and bond_3ad_unbind_slave().
>>
>> [1]https://lore.kernel.org/netdev/10374.1611947473@famine/
>>
>> Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
>> Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
>> ---
>>  drivers/net/bonding/bond_3ad.c  | 7 +------
>>  drivers/net/bonding/bond_main.c | 6 +++++-
>>  2 files changed, 6 insertions(+), 7 deletions(-)
>>
> [snip]
> after netdev_rx_handler_unregister() the bond's recv_probe cannot be executed
> so you don't really need to unlink it under mode_lock or move mode_lock at all
^^^^
Forget this part of the comment, I saw later that you don't want to receive
lacpdu on the other port

The notifier sleep problem still exists though.

> 
>>  	if (BOND_MODE(bond) == BOND_MODE_8023AD)
>>  		bond_3ad_unbind_slave(slave);
>> +	spin_unlock_bh(&bond->mode_lock);
>>  
>>  	if (bond_mode_can_use_xmit_hash(bond))
>>  		bond_update_slave_arr(bond, slave);
>>
> 


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56D63DD4D4
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 13:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233453AbhHBLkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 07:40:24 -0400
Received: from mail-co1nam11on2084.outbound.protection.outlook.com ([40.107.220.84]:44193
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233408AbhHBLkX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 07:40:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kmnr41BnYsW0f2c1GUR5cfyG3logug7khGoR0BO7TWnamlqW9sRsiiQ3TC5BzNYovsWwqUXJSYZUxWAlOWWkeF+g48WXqO0HfHakandQTQnm4Pto6U9sChMEstQCA8rEUGhbS4ZREB09Iw0P0pUm9E2qtSpbDrd4rLhdlcitm3W6eyHhRgx0doVVZiM4IrSWIvSqYzdE/37u1C8Q9N+l/oYLElrLxeIV1M+bC9w9yi1WQGEJYQNSa1kCR6A9q3XsROR1Jc2wfvS9hD2PbbMSua/IabhIipZkRBiscpkHyghJkdtH0KA8ZBvyV2at+ko69aBRAnLb3hWP7pgQYCjI9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1o15jN/Zdxp4cCBMGAsqjBQdsQnQ2oQJcN8GzuXt6+g=;
 b=Sgo5/Ia4I6bIJk9QQxu7c9ZAhewre0rQw2BfLoOMnQhWv6H0IqW3v8RhwsiPxZBpj4YBezHYeXla/siCaU3lzYqhWkj7raEz4BuVy+8xuzru4mYVziYtoLzJYfL71yGifF1UelzYhCC9c5Rrfchq77Q25sBeiCwf11wpsl53GjXHbPO3pxoNsty1Ww4b/aDeBaVFwb9UsDBplzY+WaRgmSq0nwCGOOf8hhGsaM0GbHClzd/Au18xlCHJpBytCqvsAM02t9oY1+22qNKhMo25MGI3R2SGWh+7QXj7pwuGIVdgKCG3egsook11KwmaHo+T1Z+vf3k0ilN5LI0OnIWFFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1o15jN/Zdxp4cCBMGAsqjBQdsQnQ2oQJcN8GzuXt6+g=;
 b=LDHiGcvkeVB/pOMRU4SN9DQPLhQa74ZuJYN/Kld6UV8Qe1G9pFKZ7lrRNJlkACsOkN0zHe7NcsCEmnAg3MOKEGSPp5M01oIRclLm/Rb+dMoUtnpIhexTGmRPO7QaQ50OGlGPSSqR3dIRWeNRXuhmXxcFMi35x8wfT7abou9uDCBA1A/F2BhOzU0LB9BGqORQTbyiTbKl1IJ3ZJcDXlRoW5gYr1jaN52D3dJJy2/XPR+/MbwgOydnoXnVtDM8CFxAkuKFNVfrwqpqlHjH10ULs8+koY+fRT8LMMvwqtews1zhNitlncUqpNQVlJPaYVdw0TQwYU8uXR2bRzglhU43Vg==
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5134.namprd12.prod.outlook.com (2603:10b6:5:391::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Mon, 2 Aug
 2021 11:40:13 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287%5]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 11:40:13 +0000
Subject: Re: [PATCH net-next] net: bridge: switchdev: fix incorrect use of FDB
 flags when picking the dst device
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Jiri Pirko <jiri@resnulli.us>, Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        bridge@lists.linux-foundation.org
References: <20210802113633.189831-1-vladimir.oltean@nxp.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <bf8f2ad4-c1d6-9a18-8555-353b526a783e@nvidia.com>
Date:   Mon, 2 Aug 2021 14:40:05 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210802113633.189831-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0022.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::9) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.206] (213.179.129.39) by ZR0P278CA0022.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Mon, 2 Aug 2021 11:40:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 131cd0eb-4149-4c4c-776e-08d955aa4a43
X-MS-TrafficTypeDiagnostic: DM4PR12MB5134:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB51343F28715AF1762DFF2ECADFEF9@DM4PR12MB5134.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yK3wx2WldA8ZreQPKYTwEDOe3kACrbbRKesm3E3cH2PXdYJye+Wy6Inl5ALkm4NvaINqonR5UhZEGMB60kjsKq4nwLdkow9AJsDB08Q3CTCUzgAT+BYLPEd53SMCTb/enSF+UJVnythCzmXAcQN86XFyt+6aKmxNbklCyjkc1vKvHBs/k2InexldlebIaGoqWpL8vPxda9s/IsfodaZeTTApGkrICd035V6iONeLB5DXYmX4uoP0dOvOS1mg5/e7EeBt9demfPNTcddHriMw15cT9HcCWBSECbSIbe7jRpDqS42Qm3rfaO+0ONFzAjVv26XUL9BZVScd8zqxYfhqjLduzwPvIhyrghs3UUD4dcmdTrgRJD3PF2udRCoMpiu+oe38sdM+UuYFsPNrGmzL0Bc9g2psARkhYGJ96OwzY++xw0JCmGv8+W5vLPaiAvdbtD4OzcEuSas0NVe7RAuMrzcb0DEZPTsGnU1blEg3Ck+4nEDxb3COO237tl/4KaamMXMcrEj9Dp/HVJEWQ+MVBO/EY6/9F9caOX4yEewas3MQV9kTpDuuMe3z0QodaGm4TuChgAvoGTsATMJFmBBl4UUEO1wOTUipPBJTH3j6jYCy+UOjd1TOqco7TDo9IjbhG06G293SN+KI6/kfKYFMjiRZ8mVQIm9CqLtKyuFtdJVGKY7yyp91/N6XmAxfuDYJuBPVzmKLbkPFyoynb//PDGZo8Ek4tcIpyRDafKzglJw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(6666004)(36756003)(8936002)(31696002)(4326008)(16576012)(508600001)(316002)(54906003)(110136005)(31686004)(2616005)(956004)(2906002)(26005)(38100700002)(5660300002)(186003)(66556008)(66946007)(83380400001)(53546011)(66476007)(8676002)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WjgvandOMDJ1ZlJxaTNNaFMrbU5RZGY3SGIyUDU4THVWNVhhWlBleW05N1hH?=
 =?utf-8?B?QU1Ga0RzbWVoS1pqaUxCdVlDeXc0NDdLZysvVnFvQkEyTEJPSXBtQzR1OE5U?=
 =?utf-8?B?cTBpQ214WW5DZHA5UDIrcW50R0ZiTHpzYVJ5aWQ0dkgzeGhSbG50M2JNTFR1?=
 =?utf-8?B?QUV1dFZYSGQ3ZWNFdWd2RHoyTjUrdkdzbWl3VUtDOWR6d1AvVm04NUlLUW13?=
 =?utf-8?B?YWxVOTJNN2IrZFhQTHBBWnhlQ2tSVU45d1hSOXUzTURqSU9FUklaZjhIUXN4?=
 =?utf-8?B?bytmSEs5RFNSZDFvbjhJZ2FyU0VuQkR5WG5WWUplSzQrR0VrSHYzWDRrbFBM?=
 =?utf-8?B?WThHdkJQU2FBcWl5Sm5xWXBOZDFON1BvOHhiVEZHSS8zKzVrTE1UWUxIc0M0?=
 =?utf-8?B?RnNyVG9QMEtrMUI0eFBHNytlcmsrTHdjMWpydVpUZFNYTnFNTDlwZnhDdE9w?=
 =?utf-8?B?dFFFR3o0L29HZEx5Wnl3TFgwZVRvQkhyN3NXTmk2RnVkWGF1cURydXhWcitD?=
 =?utf-8?B?eTZZeDRBaTJFdE0vT2F5Tld5Q21haEQ3VE9iZFp2Rk5waTRBNTlNZ2p6M0s3?=
 =?utf-8?B?WDFqTWtVMnJ3UnVrQlg4MkFubmFOYzFrNTdKWDNnb1RVS3FVeGVJaGZiNEdq?=
 =?utf-8?B?U3RWTStVTTcyRGNPNHdFcmk0UkY1VXhybVBIbnIySytNMkM5eVpUNnorL00z?=
 =?utf-8?B?QUhLYmRaZjFtY0JNbnMrMXRmQmZGVHZrRlV5aTNLNEtZM25kSnhONFphUHdH?=
 =?utf-8?B?TWNLTE9aZnpETUxUZllhN1FhZ0dNaFJ1WldYb0hHUGtPTjlOOFc2SXF6a1JT?=
 =?utf-8?B?a1lhM0pnaG0vQW9VUkhQMkUybFVmcmI3aFJTRUFqYk9oYlYrYzZJakZiWUdo?=
 =?utf-8?B?KzlQeFRoY1AvN3pqZVBZdnQ0YjBSQnROaUh6RmNIazFKSUhVamp2WUlPZ1Jv?=
 =?utf-8?B?bEYvMFg5OThPOXhHWllSNW5lMGpvQUcyZkpTWTBaSm1iRkFrMjRsSWd1RzBX?=
 =?utf-8?B?M0I2UmgyTE9OWmUrZFI3QmQ5Z1U2UUZPZVVoeGUvSmhRaE5JS2xUUzRwenRJ?=
 =?utf-8?B?QjFVbWRMR0lpbzBMRi9UWk9kcnNEMFZsVlE2L1JWREwrNXhwNmlXVEJCZkF5?=
 =?utf-8?B?Z0hodUw2dklQSlhEWWkvWmEzTHdGaEl4TG1QZENqSEhmMVZyaWtZV3E5N3ph?=
 =?utf-8?B?V2JkbnAvV1RYM29ZTDV3OTRHS014OU5ibkR4azRZYUwvT1YyWDJleFJiQnVF?=
 =?utf-8?B?cDVMZUMrSHlGTlYvTzd4eTFKUnd3bk40WVJrTDk3Tll3Y0kvMnkrUDRIR2VY?=
 =?utf-8?B?TE9yc0tNSkJ1K012WDNnOVM2MFhpN3gzakwyNjlhaUZidU5FS0FuWGozWlpO?=
 =?utf-8?B?aHNPM0N0dTVaNXZyYUpZb1oxTTY3YkZibWVOZyszRVhRSW9IQloyZ1RLUU8y?=
 =?utf-8?B?T0c0RGlrZ2l1MFd0cml4ZCs3RFdCS3ErTjBrdjZMUmt6TVI4RTllYXp1Vlhz?=
 =?utf-8?B?bTRsaElJM0x2Tk9XdU5LVGlZa3BXdWdXTXJiMVBzd1V4ZEY3SkJtTi9hR0h1?=
 =?utf-8?B?Rk5qUHNveTdGUjRxZmJqbkpmMVl0bkhLZlBZUTZUWWV6TW45YVJGNWVXaGJi?=
 =?utf-8?B?UTVpZzBJK25RMjdHNUxlUnQ0ZDR2K01Rc2hEUGVnYlhESVQvdEpCTWlDMUJl?=
 =?utf-8?B?YkRlQ2k1QTZFNmw0cExCUVJSdy9odzRnZXpOb1NPTkhXaVVDQnBHK0kydk5l?=
 =?utf-8?Q?J+VV6K8fixqvkrdhG/ZRKwqG93ajkplBe5SSpwW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 131cd0eb-4149-4c4c-776e-08d955aa4a43
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2021 11:40:12.9198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YhZ/z9n4R2qInSZw2e6wzsyAD8hTkmSwFugy0LKWyPR/9TMg1azFFQgx6EZk7MDcghrOmkaH3dBvrD7vm9Yqvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5134
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/08/2021 14:36, Vladimir Oltean wrote:
> Nikolay points out that it is incorrect to assume that it is impossible
> to have an fdb entry with fdb->dst == NULL and the BR_FDB_LOCAL bit in
> fdb->flags not set. This is because there are reader-side places that
> test_bit(BR_FDB_LOCAL, &fdb->flags) without the br->hash_lock, and if
> the updating of the FDB entry happens on another CPU, there are no
> memory barriers at writer or reader side which would ensure that the
> reader sees the updates to both fdb->flags and fdb->dst in the same
> order, i.e. the reader will not see an inconsistent FDB entry.
> 
> So we must be prepared to deal with FDB entries where fdb->dst and
> fdb->flags are in a potentially inconsistent state, and that means that
> fdb->dst == NULL should remain a condition to pick the net_device that
> we report to switchdev as being the bridge device, which is what the
> code did prior to the blamed patch.
> 
> Fixes: 52e4bec15546 ("net: bridge: switchdev: treat local FDBs the same as entries towards the bridge")
> Suggested-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/bridge/br_fdb.c       | 2 +-
>  net/bridge/br_switchdev.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
> index 4ff8c67ac88f..af31cebfda94 100644
> --- a/net/bridge/br_fdb.c
> +++ b/net/bridge/br_fdb.c
> @@ -745,7 +745,7 @@ static int br_fdb_replay_one(struct net_bridge *br, struct notifier_block *nb,
>  	item.added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
>  	item.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags);
>  	item.is_local = test_bit(BR_FDB_LOCAL, &fdb->flags);
> -	item.info.dev = item.is_local ? br->dev : p->dev;
> +	item.info.dev = (!p || item.is_local) ? br->dev : p->dev;
>  	item.info.ctx = ctx;
>  
>  	err = nb->notifier_call(nb, action, &item);
> diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
> index 023de0e958f1..36d75fd4a80c 100644
> --- a/net/bridge/br_switchdev.c
> +++ b/net/bridge/br_switchdev.c
> @@ -134,7 +134,7 @@ br_switchdev_fdb_notify(struct net_bridge *br,
>  		.is_local = test_bit(BR_FDB_LOCAL, &fdb->flags),
>  		.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags),
>  	};
> -	struct net_device *dev = info.is_local ? br->dev : dst->dev;
> +	struct net_device *dev = (!dst || info.is_local) ? br->dev : dst->dev;
>  
>  	switch (type) {
>  	case RTM_DELNEIGH:
> 

Thanks,
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>


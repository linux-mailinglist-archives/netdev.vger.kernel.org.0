Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 879F73B9FD5
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 13:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbhGBLey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 07:34:54 -0400
Received: from mail-mw2nam08on2063.outbound.protection.outlook.com ([40.107.101.63]:24161
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231802AbhGBLey (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Jul 2021 07:34:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZVcJ1IQ08R6k/lJ8OHvS/iwuyfp20dBMLwRLebKrTsGpRw9UgMPDP7Z8KsLS6mmop85kEvXKorVbXgJwM+QqWeqHkjzYzgZUokfgkIiQbqO2+AgzWIcSL81Xay89cVofDsIsy/UBCaixOlVR2WCNicFksspa2FSsiD3BgxZY3lQMH1MhsafwWVdJsL+Lg10aZG1qFU4osy/L2Wv1H5JdwVxqjy+OAryAWe3FrPEGul+U11aevJs1evHtKKmktUnagfYSzpS4wFywGtXmmRNe/CGdpFH1FC2Y094lu5istLQH7IrPatvLBn95XTjCUt2ZpQHNvEw51+G8qoo8YvGtow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hHkywHm6uE4FDats5lJRaIbzP4vyWP5tDTBTkMikN1U=;
 b=Q7a405hXI58NGupgRZEW1rE+e0Lq0QYlYpqwCdTWi0NVLnBzCeYhkFvnHNaSNNCc5GhpJFBaOfjb9we6liXsIof89f4hs+Esu6vb48EW0FbUE4moof35mgxFkiKviSBeBQY7C9Gk15WAN6Lp/WBth9A0LXpqKeW9ze1a2T9MxG0dhjOZPb7CFk20xeFAyut+d904U4DdNuQeor8mWV1cslkfcA+hx1A6NO1IRzY+k8a5bR/siYAOsb3jQn0YMWVPHwYVGN05DwJAFT9HapvbnWAP5lQ3fCpKRqLZpQaNRQA03c0NAHzU6KWk/LhE/XPktVEVtyWPeLyhcezBMuJcoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hHkywHm6uE4FDats5lJRaIbzP4vyWP5tDTBTkMikN1U=;
 b=IXO5DIGIyGio7Uqv9tCxEZ4kqwcqpDhcBfS1BByYyymT8TbbxNPMbP1bR4GB6CQLhE5F17d7l/p80p4NT1Pd2fPD1S6AMGDKplhhBYgQ3kYfbqyieueDFa+7pCwVw47mcjzcuQKJrHc+C7y5ciccodRY77m55mLgjNBCMMbV5Ja62fwqvvNYuHCqz6sopwd2mJrDERmSZSejx/zs8L1TYTrpgWjZuZppmFB+oEtQuLbJQlk7WJYv0ZUm1uOixsGib6vWw7bFNtQlK9OW9EGOqJWEF6GB0Y/5dQvz33sSRlK5o4tw4oJUf+/h6VBbB/HON1KEaTCknKka8LLSgS4F+g==
Authentication-Results: proxmox.com; dkim=none (message not signed)
 header.d=none;proxmox.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5271.namprd12.prod.outlook.com (2603:10b6:208:315::9)
 by BL1PR12MB5285.namprd12.prod.outlook.com (2603:10b6:208:31f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.21; Fri, 2 Jul
 2021 11:32:20 +0000
Received: from BL1PR12MB5271.namprd12.prod.outlook.com
 ([fe80::31e3:a65f:b29f:6c25]) by BL1PR12MB5271.namprd12.prod.outlook.com
 ([fe80::31e3:a65f:b29f:6c25%2]) with mapi id 15.20.4287.024; Fri, 2 Jul 2021
 11:32:19 +0000
Subject: Re: [PATCH v2] net: bridge: sync fdb to new unicast-filtering ports
To:     Wolfgang Bumiller <w.bumiller@proxmox.com>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Vlad Yasevich <vyasevic@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Lamprecht <t.lamprecht@proxmox.com>
References: <20210702082605.6034-1-w.bumiller@proxmox.com>
 <113d8503-8670-c0a3-54a6-0b18af64632e@nvidia.com>
 <20210702112919.ccxyp4fyvrjrxkrz@wobu-vie.proxmox.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <fdd49de6-982b-c1e7-5e9b-05ed418fc4a2@nvidia.com>
Date:   Fri, 2 Jul 2021 14:32:13 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210702112919.ccxyp4fyvrjrxkrz@wobu-vie.proxmox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0073.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::6) To BL1PR12MB5271.namprd12.prod.outlook.com
 (2603:10b6:208:315::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.74] (213.179.129.39) by ZR0P278CA0073.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:22::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.23 via Frontend Transport; Fri, 2 Jul 2021 11:32:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ef8ac2a-be8d-4661-476c-08d93d4d0d79
X-MS-TrafficTypeDiagnostic: BL1PR12MB5285:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5285DC830AFC2E9C04CF28D1DF1F9@BL1PR12MB5285.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i7xwqtbOGlNE4H/vdINGDBryone4t7HtuZ73HWZfNyAzMqfLOyrYfrQTgafbmzYA27fozs0rQ8Gjjxv8M8foW+8UMs1bRo5e5rpOYQY/P/03O/p7JBjzbPAduoWIOjAfVvh5P5BD007WWivlTWiCUam+U21wGEUlrTu/hUBIRv7AhzBbQlQyV29sJr74GSEdXH5tJa4853PMAwNxGQN+VF/OB0Pmr6n+4gGBkquRo3wzrtwkILA+2voLjhT1LWuPrWvldBBum5WGjCmYZ2077rITPGzv/mKhH+b4zhR1UiSEx6WHnbWA5lizP5t112Rtch9+zZoSYaEgabviBC7HJSTjFKJTcOcwt5GC4lCw/ZBsqbsumtJyltRI2K0Ms2Kr/ekjljErJ4quLWBE06Mq0EsaCdEhDaBflTw+j5BbTsaMC00Ot/ALYkgpjiFr8DFL0k7sCVg33Wl9HAuAWsv4OpTiHe22kyBGwDiGRttR16tJKNWLCZIaQ499z7CI2tuyBINVTcQjUd2WlXzotk5EWsQaCULUpL+8aemUxvqWf1OS1qV0Z/ZKrRnkI4oVSscMTMJFKqeknQ4UkTuCAxbywLoBz1rElQd3OnzNs13J+Twqhd77qkNd9XvwPmg6xEt5hOfkLFRfWtpnTYpD3niegbtPQvHSV73fYT5kw8QeDRVMBcV02RzBeiif16tklJol1fYBFVv/n24Iskxi1nJe5JAeVnC2GkJg7PYVqaE3aVg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5271.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(39860400002)(136003)(346002)(2906002)(6486002)(36756003)(66476007)(4326008)(66946007)(83380400001)(186003)(478600001)(8676002)(8936002)(16526019)(66556008)(6916009)(26005)(86362001)(38100700002)(31686004)(5660300002)(2616005)(16576012)(54906003)(31696002)(316002)(956004)(6666004)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dXBiUHdQbFBlTS9NUnlFNEk5RkFRZFdEVWdFVnRxL3FvMDVzNG8wOGZwOHRq?=
 =?utf-8?B?YVlmblJMWklkU1F5U2QwMGxBaU9SSUdielVxOVdaWTM0eXh5WWJ4d2VtSXpF?=
 =?utf-8?B?QStkWUlpaGFJTmNtUlVhbUNxcnM0RloxYk5EV09rdGxRSnBRNUxqaER5OHJI?=
 =?utf-8?B?MUcxV29YajlxUHIrdytUWERvNzRnUDVJSk9GcHhTYjJRUWdSbWdNdDFaaGRh?=
 =?utf-8?B?SzBGMnVYb1lPSGs0TW41NVBwVGgxcnlPQnAwQktSbkZhQ3J3RllTVDZMRFdS?=
 =?utf-8?B?UFBOeGxhOXRkUEhkU2x2d1FyZXpJQ1RDemZOT1Rjd3pjN0xKK1NEK2J5dWp5?=
 =?utf-8?B?NnJ3ZnhydnJuYUc0ODNpRHJBZlF4WHNKT2Y0TS9WcGF3MkpBS0E2cUEyRmpx?=
 =?utf-8?B?a1NXem5kcVZQQlBxUkJ0Y0t6RnU4QmNiazJVVFpRaExBNTZmYmhsZVpIUHJa?=
 =?utf-8?B?eVZCZENsZmhQV3pWWkxJSTM0S29nSE5qK0M5UDV0ZmNkTXRHVnpWeWhQNDFq?=
 =?utf-8?B?aHRSeTRuK0xYVlNEQ2ExcHFzQmJmamE4ZnJwTW45b0tOanVpanRlcnkxaXN5?=
 =?utf-8?B?UmZ6Q3NGOGMzMy9CTGEvZlFSNzkxMGhEd0Z4bEVnRXhOY0g3NFBsaEUzYmh0?=
 =?utf-8?B?aU9hd05QZW9DblU2Wm1tb2RhWmxFSGZwNkdEc0NmdVlUYjVBZk9IOXQwa28y?=
 =?utf-8?B?UDZnQ0k1dms1RjlqSWpjOXZSVGIyQ2V3RklOODJHUUE3SjEvdjNRUXBHOVdJ?=
 =?utf-8?B?T0FGeXYzZDRVeFFmSnJiOVBPclFNNFhlRjBpcXJTdHNuYVp6TlhIRDNuQzhv?=
 =?utf-8?B?RlhnY0Ywbm5ocDhvSW5xeTJlYldDRE15dXFZTmIxQ2VvaXN2SU1zMGczQ3FJ?=
 =?utf-8?B?SGJuOWFCTTV4RExlSmNmcm5KRU1YNmlwWHZBMEgybnZua0hFajJla3J4enB3?=
 =?utf-8?B?dDhSYlV2bzBPRlZGMWFlWGh6NnVYWHVHSTBoc050WWRXYzdWcWRPemo5RjFy?=
 =?utf-8?B?NHJLL3c1UGlCN1dwQWoyTWNNWTVOQU13dDNwWXJUMHR4OU82eDdkYXdYdzR0?=
 =?utf-8?B?Mk5hSkxkN05oS3M5OHV5UURaYjFzVm00S0lMMFdvWFlJaGF6WU9oZncxd1lE?=
 =?utf-8?B?QkdET2RNbkdFR0ovUmIyWHc5M29OekY5dC92eklLcGtxQ0ZZZzgwM25IM0dG?=
 =?utf-8?B?ZkFpQ3ZjYlduQk9hQmJ6UDUwaDgrY3FHTEFvSk1qUk9zTGtiTzdVa21KMlVo?=
 =?utf-8?B?eFYrVG4xdUJTcENpaCtIUVZtZXlzNlpKTG9FR043OTUvWXJsRWhiUHQ0cHpq?=
 =?utf-8?B?MjFZb2wvbUw4S254MCtUZHRsZ2FKcTlST1IycHR2M25RekxJODZBenlQZVl6?=
 =?utf-8?B?T2FHcENBaHQyK2NKNmlIcHJhVFRtYm1Tc0Q1aDg3K1YzME15Z21vdlRhOUlU?=
 =?utf-8?B?eFlRWjFvR2VWQmU2OVh1b0IwSG01bVlod3hiYXZzV2oyUTdqak5pQTl2Q09m?=
 =?utf-8?B?d2tleEhuMWM1ajVGNDVIWFhKZk1hdTV2eXBvUFVDMHp2eDNuZGVXcnRjWkxm?=
 =?utf-8?B?V1c4dmE2bytqS2dMS0ZETlExN01FM09zV1kzKzdHakYrSWhKdkt1dG1Ob0tP?=
 =?utf-8?B?bkprNHUyVitMN2VrYm4rYUpEczJ4MllDNXJhdWIvbDdPamdmV1lmZXFPNWho?=
 =?utf-8?B?OTRsNTlocERuZXh5d2picUlIWU5YSm1nT0IyWDljK3J4SFdldDBWM0ZBTGUy?=
 =?utf-8?Q?1xjlEhwOAUifYN3Bjo+qr/ejC0HPrHwniLcAT2h?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ef8ac2a-be8d-4661-476c-08d93d4d0d79
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5271.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2021 11:32:19.8539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7C7/iDNXTT59h3pQYIRjinOzzKIgdITsLCyIo7zaJfhWrD5vsXPrr4KO4gG4SjtIJKsN4jvzN46ktpoS7FbXjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5285
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/07/2021 14:29, Wolfgang Bumiller wrote:
> On Fri, Jul 02, 2021 at 02:16:51PM +0300, Nikolay Aleksandrov wrote:
>> On 02/07/2021 11:26, Wolfgang Bumiller wrote:
>>> Since commit 2796d0c648c9 ("bridge: Automatically manage
>>> port promiscuous mode.")
>>> bridges with `vlan_filtering 1` and only 1 auto-port don't
>>> set IFF_PROMISC for unicast-filtering-capable ports.
>>>
>>> Normally on port changes `br_manage_promisc` is called to
>>> update the promisc flags and unicast filters if necessary,
>>> but it cannot distinguish between *new* ports and ones
>>> losing their promisc flag, and new ports end up not
>>> receiving the MAC address list.
>>>
>>> Fix this by calling `br_fdb_sync_static` in `br_add_if`
>>> after the port promisc flags are updated and the unicast
>>> filter was supposed to have been filled.
>>>
>>> Fixes: 2796d0c648c9 ("bridge: Automatically manage port promiscuous mode.")
>>> Signed-off-by: Wolfgang Bumiller <w.bumiller@proxmox.com>
>>> ---
>>> Changes to v1:
>>>   * Added unsync to error case.
>>>   * Improved error message
>>>   * Added `Fixes` tag to commit message
>>>
>>
>> Hi,
>> One comment below..
>>
>>>  net/bridge/br_if.c | 13 +++++++++++++
>>>  1 file changed, 13 insertions(+)
>>>
>>> diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
>>> index f7d2f472ae24..2fd03a9742c8 100644
>>> --- a/net/bridge/br_if.c
>>> +++ b/net/bridge/br_if.c
>>> @@ -652,6 +652,18 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
>>>  	list_add_rcu(&p->list, &br->port_list);
>>>  
>>>  	nbp_update_port_count(br);
>>> +	if (!br_promisc_port(p) && (p->dev->priv_flags & IFF_UNICAST_FLT)) {
>>> +		/* When updating the port count we also update all ports'
>>> +		 * promiscuous mode.
>>> +		 * A port leaving promiscuous mode normally gets the bridge's
>>> +		 * fdb synced to the unicast filter (if supported), however,
>>> +		 * `br_port_clear_promisc` does not distinguish between
>>> +		 * non-promiscuous ports and *new* ports, so we need to
>>> +		 * sync explicitly here.
>>> +		 */
>>> +		if (br_fdb_sync_static(br, p))
>>> +			netdev_err(dev, "failed to sync bridge static fdb addresses to this port\n");
>>> +	}
>>>  
>>>  	netdev_update_features(br->dev);
>>>  
>>> @@ -701,6 +713,7 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
>>>  	return 0;
>>>  
>>>  err7:
>>> +	br_fdb_unsync_static(br, p);
>>
>> I don't think you should always unsync, but only if they were synced otherwise you
>> might delete an entry that wasn't added by the bridge (e.g. promisc bond dev with mac A ->
>> port mac A and if the bridge has that as static fdb it will delete it on error)
> 
> Right, sorry, I don't know why I missed that.
> Conditional setup => conditional teardown, obviously >.>
> 
>>
>> I've been thinking some more about this and obviously you can check if the sync happened,
>> but you could avoid the error path if you move that sync after the vlan init (nbp_vlan_init())
>> but before the port is STP enabled, that would avoid error handling altogether.
> 
> Yeah, that's true. Although it'll be easier for future changes
> introducing another error case to forget about taking this into account.
> Which way do you prefer?
> 

I don't have a strong preference, up to you really. Both ways are correct. :)


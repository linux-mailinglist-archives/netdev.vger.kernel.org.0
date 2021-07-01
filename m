Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9523B9401
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 17:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233575AbhGAPf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 11:35:59 -0400
Received: from mail-bn1nam07on2043.outbound.protection.outlook.com ([40.107.212.43]:58312
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233335AbhGAPf6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 11:35:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ApWFVbxeQgKUUqbRExXGi2Gd83mjOt/tf1LgPhoK46dOCPPrNgUEZi1OScY8sG7rMtkcXiUnM+qk6ywhvSiK0nQqrvgx9HnYVK/6kHQVr5M3sd2/rfpQ4aHmr9f/WJwdCvD1mQCPV3Q1XGZvikszNMP8AfvGYG23H5sGRVe+yViO5W2LL4BAZwAgK9aye51Skn1gfy/2N+mIvUZtWkAU8nPFEHs1tln8uVIhr7kkXBs0hYODZ82EVWQBlQTX/KWSOR7NATSv1vuRDyXL6FjsvwZC0MFRt/s4DI5MUho2YL3NmuBrH9k0/vnmaPg2iixnhcAfbJqaje0+zB+vudx6TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1dWMUjeCKPdLeFUp+gxh669fnhppbw46JBj0Gn+rjOw=;
 b=WrijCOHhSPpWccHJfUsfwvpEA+ma45+qFOf7ZhtqZ99XBlgG1oVX1kF/6pAY34EAhXj/UlJpcGEF8tnCHs7mgVViGYOZ8yRN/DbZpqDSaRlzgVgliUMkrqNoS7Se2pWKazXP+L9DSgzeAII8U5MRqpMvng+IqnbTbNEaR37YXNSsOpfBDf1hLRaaLqSBcZU7+2vDmzt74Vpw5oD/lH9cG6FmekTlwezCclIE2UaTqq663E+IuyP9k9x6IwiWe9im8XcRou7qz1Te0t+zUcdEvgC+M90z9O0tXlSTb07GMT6prfHza5VKV+OWTRJrjZxk/e7886TsEmPHZeRexRro0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1dWMUjeCKPdLeFUp+gxh669fnhppbw46JBj0Gn+rjOw=;
 b=pYU6m9dj5CtGMCN6fVSobElnaQIxYZIlABMOEV3zgLX68+hx2Ptku0egOIhBpljcY/FsYSs7cqfqbZ7VZSs7cKy0MeZC0hpYVYVcAPkUsa/e1SYT4A9Dz9QXRgeLu6VgfGMnrjToG1Hz9OKW9FoCe246Z/+SjGIs01smMjyBqG2bNHLg+1jGcwPF9W9xubavrq7D26n8alQ6Sv4TVWoacuilzcmalME+pgou9/CPuHY2DajiHyZDVFxV9hOpWMlHk8/LDQJKYk8yp0jX5OeFzKlU54WSjm1SkYijaO5TGcUJF0P27vt3EsoQMd2IQN1mvVv1jHDgTmZzuMfUy0oVVQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5088.namprd12.prod.outlook.com (2603:10b6:5:38b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22; Thu, 1 Jul
 2021 15:33:26 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::601a:2b06:4e64:7fd3]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::601a:2b06:4e64:7fd3%3]) with mapi id 15.20.4264.026; Thu, 1 Jul 2021
 15:33:26 +0000
Subject: Re: [PATCH 1/1] net: bridge: sync fdb to new unicast-filtering ports
To:     Thomas Lamprecht <t.lamprecht@proxmox.com>,
        Wolfgang Bumiller <w.bumiller@proxmox.com>,
        netdev@vger.kernel.org
Cc:     bridge@lists.linux-foundation.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Vlad Yasevich <vyasevic@redhat.com>
References: <20210701122830.2652-1-w.bumiller@proxmox.com>
 <20210701122830.2652-2-w.bumiller@proxmox.com>
 <39385134-e499-2444-aa0d-48b0315e1002@nvidia.com>
 <131fc6eb-7da2-ccac-2da0-b82c19dfef84@proxmox.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <5a470258-a06b-64d0-fca0-f4eafe7e23e2@nvidia.com>
Date:   Thu, 1 Jul 2021 18:33:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <131fc6eb-7da2-ccac-2da0-b82c19dfef84@proxmox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0039.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::8) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.74] (213.179.129.39) by ZR0P278CA0039.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.21 via Frontend Transport; Thu, 1 Jul 2021 15:33:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b49b698-e9cb-42de-809f-08d93ca591ce
X-MS-TrafficTypeDiagnostic: DM4PR12MB5088:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB5088204C31388B4F7F4B8103DF009@DM4PR12MB5088.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9pC/AFQzxtZj/L3fXl8jKvgVNoi1kNUemflqey9HJUXZsNBf8V5M2kaFlYPlO65t8gS/WA0bvkG6VAqkNRaTNp68Cap7y1PKKSdf3yjXqHT3OmRc6lxCYnKjUUamunUX1a7bZBX2eq0e4xjtsUVJYbe5smLQ7PT/OftAwKmeSSjmEBWCaWVjy5usm1gulXOI+AfcVSlFq9nBf8jNmrdnDSHxCo8NWkz3nWqJ6wbZJZe131LdYi/KQ+5QVA3wGrJ83Ho6XqSh7K4BspOfR4QyAxieaR6WCMzD5CrNhW1UoDiP3o4u3N3u7O+X/QX07eR9yt05FVXBhsodkoHd7/QMYi/htUbPlhO++2jJJyGTPe3V2KWQE731ie5bgrgt2K465vHefi8tXOrIMVaphYhpWglOMzrJms580RYjGk3vboO2rN2yz9KIva4SKKUvWLUt8YOWJzhWPSXvABfMbSV4A59vPDIrcGNzvacxrshVNTJjHRi5fVeisOj/6eR7V36uPimfLPhjwOxLjJrTIoXhRX8+le61mJHo6L1jRNbVuGiUasuIfpZ3k6o165iWr9QzkmwsIpi9jQ+0BcXhoEd1f8b5ssJE0RTPokzVb+JGGqcg4O1V8LwZcNNBZNILAsXrznUv9vAjd/DxPcX171o7hLfe+lfohl1NMZD1QPrLqc9fvBsL1u87rDQThmQmisBrfBOia5NfSe2YHUMuIV68AYkDLIwvGNrIP3qzjHAwSTwUT1eByrZGqlOE19g5j55loycr+f8wg6OfGEqIbLVSIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(396003)(39860400002)(376002)(83380400001)(2906002)(316002)(956004)(54906003)(66946007)(16576012)(478600001)(2616005)(110136005)(4326008)(86362001)(31696002)(6666004)(186003)(5660300002)(53546011)(16526019)(26005)(6486002)(8676002)(38100700002)(966005)(66476007)(8936002)(66556008)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S3ZIZXlIb2g0SXFWUmlERmtRYk5idTB4MTR1SEl1UkNMOWo1cnJyT1lSUHVm?=
 =?utf-8?B?TUxSUjVQM1JvN09ZMiswZXJPN1AwY1djMDVDYW0xUXlQb0RIdkRzcTVHMlVk?=
 =?utf-8?B?SWpVLzZrZVBUQUlBUnZ2V3ZTQ2F3a1RuSEg5Nk9sQTZhVWdheE95RlJNZTJS?=
 =?utf-8?B?NE0wQzYvQ0s2MlgxODkxQW1ZbktCN2IvanRSRXU4dUNXSk9McnAzVXFYdm5j?=
 =?utf-8?B?WkkxV1JRRXJyTjlPb1k2RS9nUXYzbmhaRXBRTDlmQVFVNmVUcndCcFR6Z3RX?=
 =?utf-8?B?RldMRnB6TnRsY0ovbHV2NEI3TmdIQjN3QlViTm11cVNlcDkyV2hzdFcxUlhE?=
 =?utf-8?B?aU9pU2dtRTRwUzl5dzBmZlFZeGlSR3djbFAyQjh2UDRiLzFFRlFuMzcxZkty?=
 =?utf-8?B?ZnFMaGxGMkN1OVQrMVo1K1F5amVSY21MRjBhZnNIeTAva281bldSdTNab3ha?=
 =?utf-8?B?UHZqTnI2SERCYnJaTmdhTWd3eVRNUmdkYmZqT1RXZzFFeGwzWGEwWDVjbDZK?=
 =?utf-8?B?cThacmo4N05BOGg3dWZ4WXprTzJ1V0d5TDdEVjh0YUs3bFlEOVVITDZMbWdm?=
 =?utf-8?B?Qlgxa3Fhd3ROMS82N1ZhRDAvU0J4VW5teVhOZW14dDlLcFM0VitYaWR4bW1X?=
 =?utf-8?B?ZlYycUZtMFBsWHFvZ2FvVU5sRGR2Vms1bnlLQmJqd1BobkVoUjBZU1oyWnY4?=
 =?utf-8?B?b0h6KzV2cEI5bTh6VS9zKzVMM24wM1RsWmJVeGdTRU80bVg5ZTNxekwybFBk?=
 =?utf-8?B?Y1Jia3dqeGxoN09aZC9JbFdmdFNsRTd3SGsxeCtiVVNmdHRObnlDYUxad2xG?=
 =?utf-8?B?SmZobjArYXB0MjdmQWdiWWhmeDI3VDZhSzdycE0rd1BUbTRKb2xhVlRFRjBH?=
 =?utf-8?B?bzRqczdxVWdRRDd0VkVHRmFqNmQvMHpLMVEzNDlMcHNoVXpmV2hFL1JGR04v?=
 =?utf-8?B?YkNkK0VDSHcyZ1FKWVU0Z2VRK3NEYUNTQUFic1J4MWpHSVdzWTZCMnVoaGdS?=
 =?utf-8?B?MTdJL1dwTGZTbzA0ajVub0t5Vm1WZmRVS2hIcHNTQ1YvL01LY1pZWCtLei9M?=
 =?utf-8?B?TmdMY3Y2NXZpbERoRFRWcHFqNGVUb0xHenpxblY0MW4zS0p4bm92c2FwY1Aw?=
 =?utf-8?B?VWIrSlNEQ3I3VU1nSnZ1eVordUwrSC94Y3BKdzVqZFpoQjRIb2piY0M0UXgx?=
 =?utf-8?B?Yng4Y0l6TEFNTlpyUTZnTmEwTlg3cTR2YzR5YkxURnhtTDhyL1hod0kra2ho?=
 =?utf-8?B?Wk1GSHd6eC9zVUQvUzVPaklpeXR1cVNJSVJpWWYxL1RucGx0eEJFaE0zODNr?=
 =?utf-8?B?cU1FWUIzRCs1ZEgvWWJoVmNuU3gyZyt5ejlxY29kTjVOYW1JRS9uTjBmZHJ0?=
 =?utf-8?B?bWZOZmdiZnBMcEFhUCtaWUZRRlYxWGdxMG5qQnB3VURNVER1UGRaTVpmNGxO?=
 =?utf-8?B?UU42M0pVRjU0NGNYREh6UmdKbXFwSjdqQ2Z3QjdmanNYRHBLUU44bGhzTEly?=
 =?utf-8?B?THpydDhFTEtxTzJuay9DdVJWbi9wa1ZwSm1neW1UUlJQdlFTbGJ0MVBsalJH?=
 =?utf-8?B?WlkwYVFxMy9jVDZyeGF0ZkRpVUhIRFNMNjhSZEluTzg4TTkxdDBkNEJrR2hF?=
 =?utf-8?B?dDlSU2F2MCt1WnVPZnBpR1pWeTJOczVlbXptbXR6bU8yMld4UmVveEVGTi9h?=
 =?utf-8?B?TWZqWE9kaitQZytSekk5alc2Z2dFb1IyT1FFb2RzOWVWOE01elBIR3BwZlht?=
 =?utf-8?Q?AXGI/5hs+QpYtMjY2MaRrKPMRcUUvp4jbSo1XWE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b49b698-e9cb-42de-809f-08d93ca591ce
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2021 15:33:26.4967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AR1e74UrewIWBRvI0O8/pdY8i91SylxxSh+gdz+igCAc5bU2nnF9KaVp8MZRIRpBKULWSDxhRyaFVznUgiFIdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5088
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/07/2021 17:51, Thomas Lamprecht wrote:
> On 01.07.21 15:49, Nikolay Aleksandrov wrote:
>> On 01/07/2021 15:28, Wolfgang Bumiller wrote:
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
>>> Signed-off-by: Wolfgang Bumiller <w.bumiller@proxmox.com>
>>> ---
>>>  net/bridge/br_if.c | 12 ++++++++++++
>>>  1 file changed, 12 insertions(+)
>>>
>>> diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
>>> index f7d2f472ae24..183e72e7b65e 100644
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
>>> +			netdev_err(dev, "failed to sync bridge addresses to this port\n");
>>> +	}
>>>  
>>>  	netdev_update_features(br->dev);
>>>  
>>>
>>
>> Hi,
> 
> Hi, commenting as was peripherally involved into this.
> 
>> The patch is wrong because br_add_if() can fail after you sync these entries and
>> then nothing will unsync them. Out of curiousity what's the use case of a bridge with a
>> single port only ? Because, as you've also noted, this will be an issue only if there is
>> a single port and sounds like a corner case, maybe there's a better way to handle it.
> 
> In practice you're right, it is not often useful, but that does not means that it
> won't happen. For example, in Proxmox VE, a hypervisor/clustering debian-based distro,
> we recommend users that they need to migrate all (QEMU) VMs to another cluster-node when
> doing a (major) upgrade as with that way they get no downtime for the VMs.
> 
> Now, if the user had a bridge with a single port this was not an issue as long as VMs
> where running the TAP device we use for them where bridge ports too.
> 
> But on reboot, with all VMs and thus ports still gone, the system comes up with that
> bridge having a single port.
> 
> That itself was seen as a problem until recently because the system set the MAC of the
> bridge to one of the bridge ports.
> 
> But with the next Debian Version (Bullseye) we're pulling in a systemd version which
> now defaults to MACAddressPolicy=persistent[0] also for virtual devices like bridges,
> so with that update done and rebooted the bridge has another MAC address, not matching
> the one of a bridge port anymore, which means the host may, depending on some other
> side effects like vlan-awareness on (as without that promisc would be enabled anyway),
> not be ping'able and other issue anymore.
> Due to some specialty handling of learning/filtering in specific drivers this is not
> reproducible on every NIC model (IIRC, it was in igb and e1000e ones but not in some
> realtek ones).
> 
> Hope that was not written to confusingly.
> 
> [0]: https://www.freedesktop.org/software/systemd/man/systemd.link.html#MACAddressPolicy=
> 

I see, thank you for the details. Just to clarify I'm not against fixing it or against this patch,
the question was out of curiousity only, as for the patch it needs to be fixed so unsync will be
handled in the error paths after the sync and also I'd suggest changing the error message to contain
what exactly couldn't be synced:
"failed to sync bridge static fdb addresses to this port"
or something in those lines. Since this fixes actual bug please also add a Fixes: tag with the
appropriate commit id where it was introduced.

>>
>> To be honest this promisc management has caused us headaches with scale setups with thousands
>> of permanent and static entries where we don't need to sync uc lists, we've actually thought
>> about flags to disable this altogether.
> 
> FWIW, when we got this reported by a beta tester a initial (not really thought out) idea
> of mine was to drop the special br_manage_promisc case to disable promisc on the bridge
> port for one single auto-port, introduced by commit 2796d0c648c940b4796f84384fbcfb0a2399db84
> in 2014, i.e., something like (still not 100% thought out):
> 
> 
This sounds very tempting, but we might break setups which depend on that behaviour,
e.g. having 1 auto port and additional non-auto ports. There were some assumptions made
about having 1 auto port back in 2014 when these changes were made[0].

Thanks,
 Nik

[0] https://bridge.linux-foundation.narkive.com/d9Qnpa69/rfc-patch-v2-net-next-0-7-non-promisc-bidge-ports-support#post10

> ----8<----
> diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
> index f7d2f472ae24..520c79c21362 100644
> --- a/net/bridge/br_if.c
> +++ b/net/bridge/br_if.c
> @@ -147,18 +147,7 @@ void br_manage_promisc(struct net_bridge *br)
>  		if (set_all) {
>  			br_port_set_promisc(p);
>  		} else {
> -			/* If the number of auto-ports is <= 1, then all other
> -			 * ports will have their output configuration
> -			 * statically specified through fdbs.  Since ingress
> -			 * on the auto-port becomes forwarding/egress to other
> -			 * ports and egress configuration is statically known,
> -			 * we can say that ingress configuration of the
> -			 * auto-port is also statically known.
> -			 * This lets us disable promiscuous mode and write
> -			 * this config to hw.
> -			 */
> -			if (br->auto_cnt == 0 ||
> -			    (br->auto_cnt == 1 && br_auto_port(p)))
> +			if (br->auto_cnt == 0)
>  				br_port_clear_promisc(p);
>  			else
>  				br_port_set_promisc(p);
> 


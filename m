Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E575138C870
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 15:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235439AbhEUNlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 09:41:04 -0400
Received: from mail-co1nam11on2086.outbound.protection.outlook.com ([40.107.220.86]:37696
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235731AbhEUNkx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 09:40:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CEL1152yq5gJnuZK1oHsPeznxt6T9EuaslKTexL0OHX29nMo2yDpY8c37/6KuUFe5naOUoy0n0ZdjsXb8kIh/lV4/9YMznYI7ruKZqZt6MZtVWA29COWCOCEc6aTISMzomlL7yi03B4TTWOa8OWPrM7TVXqLws+JZTQEtlTMSxHyGAuIWiFvtLiB0iqb7jyO9guRBh0Jlbr5y2myId6l2Egd8rDMwgQNvrk1yBq2xwUV7re3oU6onYEFzkzyj4L0t4UFPaSchgoogTWNxjraeLsjJSbvZS50gkWbj516qdn2XWm67VXRSwK9hONVurDtPwPLqVi/kz6EnOnS24stHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UKqYZI9nxzwuFXSCBzaffii2SgXYsjJQhAfzvh25tfY=;
 b=HcALnNSLc3IkcOW8uFd2394DjZ3sbLAIQbAXPfJM6HdtuIlpMZRMnle9UBp7e2eA+5cwMbuz/dky14eCLtNC+/fmXbPsvOL/hJVTF7z1QDOlUqMJvoLwCD0Hi0/NvLudPRFj23LCJ1/HO7oJalPo2diEYNvfFesnd7V5AxrGOsRGjFFGP6sQ4NkBaNzJsSwaRA0e57uv5rbBYLOPryCMSfSBS5p4fJ44ZoAdE5O35nFqp0hl0UxREJD4PjdSgPsEa+2vOX6brcu4R2Xiq1cyPct6HUViwbLYTAg8kV7TZg/Pv7ztlTyf6Bnbtqg0P9HDIf3QTHlHwN2ykKBrAFb2rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UKqYZI9nxzwuFXSCBzaffii2SgXYsjJQhAfzvh25tfY=;
 b=o63GY08uXgRTXA7B6SX7vCdSfZlsi+WgegtincedwEGEUKzYLXBzPH8CHMwpHV2G8e45urhojpr9Fe+0qavEAI5O8scGGUp5JJ/2MGXklF5nNIlz66iR2EIsfkm7ylujG34q2j4SGC4RRhXZFXHPsCNCSdZqpqtp4th5Z5ZkW36woQqfQKFRSyLlVa7S0Tv6A3Xbzn+vn8OwkstmUsAP9DDZuxSjnZWB/ZMYOYS3f0PDkR0VdLUDpek6el2aU6Y7oCfuHx8w7k2R3H0l/F1NA0g52DZrk53/H3PKoi996onQqDdEYMPhxmOOaztPEDOvsOOAItPcQ2wW/9g4HVZJXg==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5310.namprd12.prod.outlook.com (2603:10b6:5:39e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Fri, 21 May
 2021 13:39:28 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f%6]) with mapi id 15.20.4150.026; Fri, 21 May 2021
 13:39:28 +0000
Subject: Re: [PATCH net-next v2 1/4] bonding: add pure source-mac-based tx
 hashing option
To:     Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
References: <20210518210849.1673577-1-jarod@redhat.com>
 <20210521132756.1811620-1-jarod@redhat.com>
 <20210521132756.1811620-2-jarod@redhat.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <cfdef650-265c-19fb-de91-0f1ad0fed3e5@nvidia.com>
Date:   Fri, 21 May 2021 16:39:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210521132756.1811620-2-jarod@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0134.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:40::13) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.64] (213.179.129.39) by ZR0P278CA0134.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:40::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Fri, 21 May 2021 13:39:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b02d8a6-ac60-488a-038d-08d91c5ddaec
X-MS-TrafficTypeDiagnostic: DM4PR12MB5310:
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-Microsoft-Antispam-PRVS: <DM4PR12MB531066978790BD36ED850069DF299@DM4PR12MB5310.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jbbI/zwqg9rJT5ojK6SnXNNmdDHzktT+SKojz4N/gKkv/AYmy9ZNemyKw6ibjSuxWWMDf3z1v+t2CQhy8cCogPCgDY9WbrcKQB/wHHFHmiTDmbGpJdZt69sNvNjD9MG9coiQWnMwoX17Ne+LD1u+74R/CBYeXwDE89tUzqM6EuWTyaaVq01PnUhd9xz/sEbJf60VtGVrePxwBStJ2B0wdE76bSPw4Vl8pjo2ZCf8XXj5XPzj4KkOVUpoWtwM4UhuWtJOABvjtWGzEh5MaQo0Q3mlNr1FjQre8pwYV+nynoqI94VoGVpUxGPLl+C9OdWFZWhnHgWce9FORY0uzA24W50r8ycN7Q81yYXIGoJVE0XRdfbRv8JjJKjZwtSbwr8gMk7vQbCrzLWn3l2viGQNi2kWFgYn8u7YHJ26M+ZstyZ1KuGpvyAs4d3QzIqtsn6UpPacskfdoIltiqNln7vbIhoUzaFpBMYSlWHlVzF6wI3xzgrcawzBg8/bhx55m10q0oOKZ6dS75Buf2BSvF7+yQok2JMDRuKWdWqfjaEER9BA2De0j33B0MK8NbCyehIZKpWJiZdo4lN28iTe3wcwFNu1qkBy/Fj88O7vsW6vKh+3TwMQM0vTt8he5rY/s3R+ylBCLVg8sqxCCI2Ug3FwIuS2SP05HiLv0rNg7GKq1vYVzj9tjxFdWBoxRfqGkBr4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(39860400002)(396003)(376002)(316002)(6486002)(186003)(956004)(16576012)(53546011)(8936002)(478600001)(36756003)(54906003)(16526019)(2616005)(26005)(8676002)(66946007)(83380400001)(4326008)(6666004)(66476007)(66556008)(31696002)(38100700002)(31686004)(2906002)(86362001)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZDZHLzIrMytROWFrVjlFalFkdEpuM2w5a2dYMkh4V2xCNmpxQnlzUE56Yis0?=
 =?utf-8?B?bnFCVE5oN0lXN1V4NU9NUUxyWXA0S0g5U05pM0wvQ3d5K3RDRjh5U2hYemJ4?=
 =?utf-8?B?V3NLNlVaMnpSa0ZvK2NaTEJoeUxsSWR5aTMyWGt1aUJrekVYenNzV0U1SjJ6?=
 =?utf-8?B?bVA5c3YrU1lNNkNTaitQR3FzSTJuQ0lUc2dIdjluTjRyZU0zdTZyWTMyZG9Q?=
 =?utf-8?B?OWRoUmR3b3A5U0twenZzMjhNejNpdmk0RmsvMTVTMHdaRnJrQmw2aDRRZmpq?=
 =?utf-8?B?M1BiQ1NuYWNzRHg4SStVNzN2c1NtTXlBNUJtdkZUcDdvMTZuQmNSdG1vMXNq?=
 =?utf-8?B?R291QWI0N2lMRWlKK0lJQlU3RVdQbkJDS3lnOVBPRUozM1VNZXA3U1BneS81?=
 =?utf-8?B?RW1XZDlPc1A3UnlUb3VQZ2gyK1NYL0l6cnNQNDBPSHhLOWZaZ2lERlY0TEtO?=
 =?utf-8?B?SURVV1QwR3ZSYldLN0YwVjNLc3ppVHFWR2hTbW4wTCtjbTVidnJjZGp2RGZS?=
 =?utf-8?B?V3FRWTR2QnV4R0tRbEtpWk5nZVY5bGZqcngzaTBHc3BaUkZ0eGUyK3lqeHhn?=
 =?utf-8?B?L29tZEQrZW9GbkE5aVJXZ1BrRzJwaUwzSU40aFZ5a0xkSkRXM3g0ZnQzeEM0?=
 =?utf-8?B?WnNCNmU2aDlTcWlHZ3ovOWJ6cm51SjhSbEdIYkJKSjEvQmw5cXFsNExMb3pT?=
 =?utf-8?B?RVpYeGR3Q29uWlpZWTR0OTFPQnVBbyt3ajhWUVg0eTR5UzhxTk1LWXR3VW5t?=
 =?utf-8?B?ZitaNkN5Rm56OEVBYXpncHIrRC92eUpPQnY0Q0poZFd4eTdhNFVNTFVFeEJV?=
 =?utf-8?B?L0hoUUpGSWlYMVJtTVZNcWlsU2labkwxVmdnVWZRbjRFL05pNFRCZmg2RklX?=
 =?utf-8?B?MTJQNXFEUEZENVY3R1VOOWkwbmI4N1FLczRvRDNBeVFEOXhDSzVmSU81VTg5?=
 =?utf-8?B?VHRid3F5K0ZqSVgwb1c3akM3OFNtanlLeU90SEFPM1Z6aUFseHA1cUVYeHJY?=
 =?utf-8?B?aGRUV3BJVmY4UGZXcWJtZDdXVFJSZ0R5V3VJcFFuUCs0b2JqL0dlN1B0MmFk?=
 =?utf-8?B?dUFJL3BoWGZJdjlkeG05dVArWUgwajFhNDhnaEVncEpWUUcwU1hYLzZYMHJm?=
 =?utf-8?B?N2I1WWJkSXQwM2JOU0VGdW9aakpweURoSlhtZlRKd1VPNW5odUJOdzAvMGo5?=
 =?utf-8?B?RWxPc3dXQ2c2TlIwc1JDcFZsREhoTm1MbmVJVmk3cFVnMHp1L3dLL1F6d2tB?=
 =?utf-8?B?d3NPTmUrLzJVS2FYczIrVnA0SGpsUGVMRUlsYjhDQk5tRjRrRGI3d3ZhUnhC?=
 =?utf-8?B?YytGQlJaWXpqbTBFSTcvSlBjZ2kyZ3REQWtHMWdwcDdnK1BqSk95Sk9rRjgr?=
 =?utf-8?B?NGxMbklEWEtNSVFxRUdLK0pXTmFSYkk5cXQ4d1RCeDJDWm93UVBvcFl6TlZB?=
 =?utf-8?B?WS9sR016dUR0VXFWNWk5citrR1lXREtJYVBLQ0xCQ2d6ek5KL2YzeXpnVXMx?=
 =?utf-8?B?dzdXY0l6cm5WdTJsc1JvUlNGcXBIUTJqZnlmTng2YWpZc05yK2t5M2k4Q250?=
 =?utf-8?B?SCtNVC9NRFZoSDlWT3VTOTRXZ2IzWlJxUDRQVFhTaHMvVW9qbDF3QjNFTTF1?=
 =?utf-8?B?YlY1cWxtM1AyUlArc1YvL1NkNEVLcDJIL3Q5UFlnT2szdmtqV1AzOVFwQXlD?=
 =?utf-8?B?dVI5d3hwTHkvMG02M2tWNERFem53cGlzcFQ1ZHN1NThoaUpWOVNBZFY0MWNS?=
 =?utf-8?Q?E2xvK2i8eW7EBnQLb3oGn0WJMNALyUgLd7FritO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b02d8a6-ac60-488a-038d-08d91c5ddaec
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 13:39:28.1755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3f/KBGA30TN3pgUhZCQYS9az4T6qDQcc7p8tIXroN2Om7/VkYSp+aqbZTmnBc6Y9wEQzhiYAfF/3x+pwYx7bqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5310
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/05/2021 16:27, Jarod Wilson wrote:
> As it turns out, a pure source-mac only tx hash has a place for some VM
> setups. The previously added vlan+srcmac hash doesn't work as well for a
> VM with a single MAC and multiple vlans -- these types of setups path
> traffic more efficiently if the load is split by source mac alone. Enable
> this by way of an extra module parameter, rather than adding yet another
> hashing method in the tx fast path.
> 
> Cc: Jay Vosburgh <j.vosburgh@gmail.com>
> Cc: Veaceslav Falico <vfalico@gmail.com>
> Cc: Andy Gospodarek <andy@greyhouse.net>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Thomas Davis <tadavis@lbl.gov>
> Cc: Nikolay Aleksandrov <nikolay@nvidia.com>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> ---
>  Documentation/networking/bonding.rst | 13 +++++++++++++
>  drivers/net/bonding/bond_main.c      | 18 ++++++++++++------
>  2 files changed, 25 insertions(+), 6 deletions(-)
> 

Hi,
You seem to be missing netlink support for the new option. Code-wise the rest seems fine,
my personal preference is still to make a configurable hash option and perhaps default to
srcmac+vlan, i.e. it can be aliased with this hash option. I don't mind either way, but
please add netlink support if it will be a new option as it's the preferred way for
configuring.

Thanks,
 Nik

> diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
> index 62f2aab8eaec..767dbb49018b 100644
> --- a/Documentation/networking/bonding.rst
> +++ b/Documentation/networking/bonding.rst
> @@ -707,6 +707,13 @@ mode
>  		swapped with the new curr_active_slave that was
>  		chosen.
>  
> +novlan_srcmac
> +
> +	When using the vlan+srcmac xmit_hash_policy, there may be cases where
> +	omitting the vlan from the hash is beneficial. This can be done with
> +	an extra module parameter here. The default value is 0 to include
> +	vlan ID in the transmit hash.
> +
>  num_grat_arp,
>  num_unsol_na
>  
> @@ -964,6 +971,12 @@ xmit_hash_policy
>  
>  		hash = (vlan ID) XOR (source MAC vendor) XOR (source MAC dev)
>  
> +		Optionally, if the module parameter novlan_srcmac=1 is set,
> +		the vlan ID is omitted from the hash and only the source MAC
> +		address is used, reducing the hash to
> +
> +		hash = (source MAC vendor) XOR (source MAC dev)
> +
>  	The default value is layer2.  This option was added in bonding
>  	version 2.6.3.  In earlier versions of bonding, this parameter
>  	does not exist, and the layer2 policy is the only policy.  The
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 20bbda1b36e1..32785e9d0295 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -107,6 +107,7 @@ static char *lacp_rate;
>  static int min_links;
>  static char *ad_select;
>  static char *xmit_hash_policy;
> +static int novlan_srcmac;
>  static int arp_interval;
>  static char *arp_ip_target[BOND_MAX_ARP_TARGETS];
>  static char *arp_validate;
> @@ -168,6 +169,9 @@ MODULE_PARM_DESC(xmit_hash_policy, "balance-alb, balance-tlb, balance-xor, 802.3
>  				   "0 for layer 2 (default), 1 for layer 3+4, "
>  				   "2 for layer 2+3, 3 for encap layer 2+3, "
>  				   "4 for encap layer 3+4, 5 for vlan+srcmac");
> +module_param(novlan_srcmac, int, 0);
> +MODULE_PARM_DESC(novlan_srcmac, "include vlan ID in vlan+srcmac xmit_hash_policy or not; "
> +			      "0 to include it (default), 1 to exclude it");
>  module_param(arp_interval, int, 0);
>  MODULE_PARM_DESC(arp_interval, "arp interval in milliseconds");
>  module_param_array(arp_ip_target, charp, NULL, 0);
> @@ -3523,9 +3527,9 @@ static bool bond_flow_ip(struct sk_buff *skb, struct flow_keys *fk,
>  
>  static u32 bond_vlan_srcmac_hash(struct sk_buff *skb)
>  {
> -	struct ethhdr *mac_hdr = (struct ethhdr *)skb_mac_header(skb);
> +	struct ethhdr *mac_hdr = eth_hdr(skb);
>  	u32 srcmac_vendor = 0, srcmac_dev = 0;
> -	u16 vlan;
> +	u32 hash;
>  	int i;
>  
>  	for (i = 0; i < 3; i++)
> @@ -3534,12 +3538,14 @@ static u32 bond_vlan_srcmac_hash(struct sk_buff *skb)
>  	for (i = 3; i < ETH_ALEN; i++)
>  		srcmac_dev = (srcmac_dev << 8) | mac_hdr->h_source[i];
>  
> -	if (!skb_vlan_tag_present(skb))
> -		return srcmac_vendor ^ srcmac_dev;
> +	hash = srcmac_vendor ^ srcmac_dev;
> +
> +	if (novlan_srcmac || !skb_vlan_tag_present(skb))
> +		return hash;
>  
> -	vlan = skb_vlan_tag_get(skb);
> +	hash ^= skb_vlan_tag_get(skb);
>  
> -	return vlan ^ srcmac_vendor ^ srcmac_dev;
> +	return hash;
>  }
>  
>  /* Extract the appropriate headers based on bond's xmit policy */
> 


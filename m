Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53FDE344C44
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbhCVQs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:48:58 -0400
Received: from mail-dm6nam11on2051.outbound.protection.outlook.com ([40.107.223.51]:46091
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231356AbhCVQsh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 12:48:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RAhmapgjsAhu8zvzDIrOhtcdUKafIaD3KZS1JKvSfgyvBpOy/CBt/UlwKO+o+bpeS5HaPqrpfvfeC0wy7JVPeIm8WhbnbZWnaInGaZI8L6UrMkvkzSxXQvEMdWaaXaRIWnobaOHV11bnPAutCOXWEDm7btlhC1uSOgjLWOvF6/btLoY0vRYT2X07MFyMAKk2XWmn2EgPzTGWdVPVW5pcVDUxcCyRDdMoYtromlpNH9gg0cBblx7M+AX4/46pRY1513QpiRC5W3HUsIn+uTYVTj8VradQli+oo773k6yPjY+EsLwFSqHayJiREO7a9ZOrDlYHS4E+ZdCIsUbyCKtqIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h08zEuEVFp7Cmy7R+ZuQ2LRQvyL3AbMaGstxEFgGofk=;
 b=DQqXsc/n7wRiX1xSDW+90uaHK7f9jMMxR4GR/v4Dmlb4Bkxxg+DKrv87SL6WDVwwSSwtLsaRuZlXnb1rXqRHQsOLY1x4YcdBuDfPW522WvQAFYvETpH5RqNdxHRd7RSB8hOq5psFX+K+pTZesgLT+KQhBo9vDMnI8IGiMoJUdytRYpGbQaQmTLT/Qlz7D2LYMQHuHDilgFiHWLN9osufSoIqtpPwjXKRadhqI1gj6SXNyaq92V90Jyv69+oxjgag+8eOhlvAwKsWyiLQXa00KzkuSVgCtUbGmLKz6k62noq5CYu3xRfLrgs/dXtz1lzvTM1MKHUhUMAWjUdhKuvfAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h08zEuEVFp7Cmy7R+ZuQ2LRQvyL3AbMaGstxEFgGofk=;
 b=Ip1JYaQ2y5t1TDIYEzynJdGMtkAq/ZlmbTS8sk3NJkfc+A+o0M/gqBoOH1/NqWk7ilcbOTOwcRXGC377tINBotYb1pweDpC3qLHRmJgnfCFNfe0oj1Y+wwKlmyecvc+CnVcnvGdVIDfhev5dcn83Nr8U/yCBnR03axvvxpedran36mOpeivJ8QXOirGYydPZCXcZW1lkClalHAYGieaYUG/G8f1MByc3vHys5hBXchVkg4pvJQ2AhjUV6h/+OketsZNdytmBmgqFKniHl8V/P0ty6RDfnOy5thVynKafhZhTdId/4PresTnJleP2McVhAIR2baTCYuW5IJDmWkhrUw==
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM5PR12MB1803.namprd12.prod.outlook.com (2603:10b6:3:10d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.24; Mon, 22 Mar
 2021 16:48:35 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b%5]) with mapi id 15.20.3955.027; Mon, 22 Mar 2021
 16:48:35 +0000
Subject: Re: [PATCH v3 net-next 10/12] net: dsa: replay VLANs installed on
 port when joining the bridge
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Ivan Vecera <ivecera@redhat.com>,
        linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210320223448.2452869-1-olteanv@gmail.com>
 <20210320223448.2452869-11-olteanv@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <24c6e33e-1322-eea2-8fb2-e679fe610843@nvidia.com>
Date:   Mon, 22 Mar 2021 18:48:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210320223448.2452869-11-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0119.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::16) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.38] (213.179.129.39) by ZR0P278CA0119.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:20::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Mon, 22 Mar 2021 16:48:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06035cd7-9d65-412f-9bb0-08d8ed5255af
X-MS-TrafficTypeDiagnostic: DM5PR12MB1803:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB180341356CD442687D3D4064DF659@DM5PR12MB1803.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zcvvxJOg3byCGcYwTlXdk18zUmjtfVZnGqq49HfVXcif6/+mGZzHRvKa7x1wahmmuy3U+zEU0cZZUCnl3Ve8dgOwisTdBT7qtAICVhRAfgajwtBVZhlGVyl5VHtejxouN37whtTOOLkwA47OmSIAfgYTIlRuI7okRdlAI2tYF+C5o1T8wf7tt6y1jLDnEap/pw7pTKuml3S/dc7J3uentx3T0EIocNRrCoQD0mOJyaeF5cbUZnA3Pd4yak8RL1Yx9KOaMADf/QLAnjBPVHJV73Z79NBQjqoruJjrjpE1sWe26Y+VCAh62w8T7eYGB1quNsR499shlrxHrUEn8l+EQ+Rnjfb2/4BWgilSZmtEbwNzaRnk2iG/GaRue41QY+/0/Iv7Z+kZpPuTybR8Lh2p96Axk4HtqQtmfBubDDGOe9kqG5HFITkwVHSL3b1JOC+w8iqaui5mxYX7U7DaAFEbttBq8npIce4zgDsCPgPGiS9j2A2ND85T5TNXXtN/rtd6JWLNOo90NqLnyz0yw1C48MYN5yKgszd7HVMuMhQJDB3NbMnWr89mzVx/duY/8NILFjkT6RCmy6n4tpilMtDJCARFnbqAZhn2Coe59YWsK0B+yY0pGfndPMuIo7IWVtrJuD/noUz2M1N3zyzmJAfzdlEkxGU1odJtvl1J9FMZhsUoGBwcs88dhpTj7nmSLUGld3dGocnVC//abI3C1vqQo+108EdLfq5LI7PEgNtIT/k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(366004)(136003)(376002)(396003)(6666004)(16576012)(110136005)(26005)(186003)(16526019)(4326008)(54906003)(5660300002)(316002)(36756003)(2616005)(66556008)(66476007)(956004)(8676002)(66946007)(8936002)(38100700001)(478600001)(7416002)(6486002)(83380400001)(31686004)(31696002)(53546011)(2906002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QTFlOVNTWEJOOVMzRzNqTXVRQmFUUUl4ZmxmVGxyVUJMZzBPK09MSGR2ckxN?=
 =?utf-8?B?VDF3ditXUHZ1bGhhSjNsVDRnMUZQMTk1dmJQY24rY2sybHVFS09QdHNWRG42?=
 =?utf-8?B?WERlbzcwSzlXR2tyeS9TZjFqQ3hiOXJVSVJSR2dIUVV2YmFxOFhnN00yNmZI?=
 =?utf-8?B?ZlliUUFybWs1eFVLNUpRQW5xZzltdGZFalZEc2loZllDOHRqMm84KzZ5cDRt?=
 =?utf-8?B?OHhuQVpiSWZhRFArVVN1NDVDOWc4c2p4VnpUbVpHczhyV2FERFhVUmhyRFQ3?=
 =?utf-8?B?Mkpuc1JTUmE1MnFiZXRpSCtYMTFTRnlyWWdHTjlrdlp3STM4MUJTcGd4Rndo?=
 =?utf-8?B?Yk5xZXQwNzloZXo3RG1HamwvTmQxVXRpUkxPT3dmYS9TdTRsT252MWtxUmF5?=
 =?utf-8?B?SGMvR3dyY1M3S0Y5c1h4ZE04R2o0Q2o2VndkY3pZUXJyUzF0VzJiZkZ6cmZH?=
 =?utf-8?B?eFpNZ2lVNzFEVlZnTmpuYUhxR2pOMW50S2NlakJ6cEhZSlp5VnoxbG5VL2ll?=
 =?utf-8?B?OXpTblFwY2t2NmRDSmQyNHBNbjFWK0RhcWVZNkMxYnhSeFRhYXlmTTVKQ0k1?=
 =?utf-8?B?ZUx5Sk43MHhEcFB1bHhvWC9DT2hSRzJXSU5BZUZleTEzdC9jWHBMVlBJZWNI?=
 =?utf-8?B?eFdrMlJEcERqMExQNmJ5UnVTcHZwcUVIdU5rQ2svalkxanRlNjRKMjJuM1pn?=
 =?utf-8?B?K3diUXVodkF0eUc3eW9IL09CNXppUzkxVjZzb2pWNFE1VHp3ekZvUUFBbkow?=
 =?utf-8?B?ejhaVXNjQ2UxcWpoV2pzelFibmJHWHVpY3U0aElQcWlWTnZyZkdwWlhldk0z?=
 =?utf-8?B?dzVFNjJXSWVTUFQveFkxbitKbUprNTgyYUZBWVVHVTVyZXQwMVRoU1RCNyt0?=
 =?utf-8?B?SU5lZXlaMTExSVB5d1BDRXp1V2kzY1BTNUtQMzY0WUZwbkJzUmtla1htUTlt?=
 =?utf-8?B?VFhOV0Q0M0FjcHJnTmducW8wUWU2Sk9Vb1JwZFBFU2xRc21WaFEremg2bXg1?=
 =?utf-8?B?dEVZaStYMUVHaGx1VWxjNWlERzVuNmt2L0cwUS9WMWtIdGVCYXBuaWthSTZs?=
 =?utf-8?B?UzA4SFVOejZXU244MzhzcW8rVE5peW1DQlUrN2IrQzdGWlU4N1JPMnpPc0Nj?=
 =?utf-8?B?dmFvWkNjdDVTWml4ME1Fdlh2ejV0QjFtSnhvKzJzQW0xL2s3UDU4NlpxVU8x?=
 =?utf-8?B?NkhjVDBFZmhxdVA0R05iVFhTbDFWeXp3U2ZndjBDSDFzak94WG1VZ2k0UG5P?=
 =?utf-8?B?RWdyRWRtaDgzcUhUa0Jma1dRa0xZUHJYNWxtUk10S2IrMFdEMzc3Q3JERmdn?=
 =?utf-8?B?Q0pqUFJxWGNENlhWUDF2ZVZ0OEN1eG13czNyUDVZNFRCRUhHZWhWTlFSVmZt?=
 =?utf-8?B?YUNmNkw2dTZrZTJDUFlaNVJQVW5rdlVLUi9QblJPYlZyNU9pUEwxLzd4anho?=
 =?utf-8?B?cm1jZFFFZWg0S21DUFFrR0s3dTZ1QU5UWVhHSmhZRlVoMGNUckkzZDF6V2RU?=
 =?utf-8?B?aTdhM240akhSSzRZdU5wVXFaNEozOUg1K2FJSXZ2RjdaL1pIL2F5bnhzc1FT?=
 =?utf-8?B?cDhvZG5KRlZpQUJwdHFUSXpPc3N2Y0UvdWxNaW5sK2xCRjlEdHRwaFNVMVJL?=
 =?utf-8?B?TzJWZEhSWlV0d3VSQmtGM1U4QW5DcHlqR0JmU3lBRG9CRWxrNFgxRXovM1Bt?=
 =?utf-8?B?R0s4QzdwdnoyWk5VOUI5YlQva2NwSUYxaUJEMWcxMjZSL090LzlNbW9nV2Rm?=
 =?utf-8?Q?f3loJa4kbbnMJ424/mWUEeuqcCGrP/MRAJhUsvO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06035cd7-9d65-412f-9bb0-08d8ed5255af
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 16:48:35.4842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: itn8SN3Yp7LugGKOswGjNWypwj3IgQEmkBLN7NVbb/kkvulEPokd2a8WLIzb9EDbDQgqZzNJVUDfne1X/VgyZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1803
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/03/2021 00:34, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Currently this simple setup:
> 
> ip link add br0 type bridge vlan_filtering 1
> ip link add bond0 type bond
> ip link set bond0 master br0
> ip link set swp0 master bond0
> 
> will not work because the bridge has created the PVID in br_add_if ->
> nbp_vlan_init, and it has notified switchdev of the existence of VLAN 1,
> but that was too early, since swp0 was not yet a lower of bond0, so it
> had no reason to act upon that notification.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> Changes in v3:
> Made the br_vlan_replay shim return -EOPNOTSUPP.
> 
>  include/linux/if_bridge.h | 10 ++++++
>  net/bridge/br_vlan.c      | 71 +++++++++++++++++++++++++++++++++++++++
>  net/dsa/port.c            |  6 ++++
>  3 files changed, 87 insertions(+)
[snip]
> +int br_vlan_replay(struct net_device *br_dev, struct net_device *dev,
> +		   struct notifier_block *nb, struct netlink_ext_ack *extack)
> +{
> +	struct net_bridge_vlan_group *vg;
> +	struct net_bridge_vlan *v;
> +	struct net_bridge_port *p;
> +	struct net_bridge *br;
> +	int err = 0;
> +	u16 pvid;
> +
> +	ASSERT_RTNL();
> +
> +	if (!netif_is_bridge_master(br_dev))
> +		return -EINVAL;
> +
> +	if (!netif_is_bridge_master(dev) && !netif_is_bridge_port(dev))
> +		return -EINVAL;
> +
> +	if (netif_is_bridge_master(dev)) {
> +		br = netdev_priv(dev);
> +		vg = br_vlan_group(br);
> +		p = NULL;
> +	} else {
> +		p = br_port_get_rtnl(dev);
> +		if (WARN_ON(!p))
> +			return -EINVAL;
> +		vg = nbp_vlan_group(p);
> +		br = p->br;
> +	}
> +
> +	if (!vg)
> +		return 0;
> +
> +	pvid = br_get_pvid(vg);
> +
> +	list_for_each_entry(v, &vg->vlan_list, vlist) {
> +		struct switchdev_obj_port_vlan vlan = {
> +			.obj.orig_dev = dev,
> +			.obj.id = SWITCHDEV_OBJ_ID_PORT_VLAN,
> +			.flags = br_vlan_flags(v, pvid),
> +			.vid = v->vid,
> +		};
> +
> +		if (!br_vlan_should_use(v))
> +			continue;
> +
> +		br_vlan_replay_one(nb, dev, &vlan, extack);
> +		if (err)
> +			return err;
> +	}
> +
> +	return err;
> +}

EXPORT_SYMBOL_GPL ?

>  /* check if v_curr can enter a range ending in range_end */
>  bool br_vlan_can_enter_range(const struct net_bridge_vlan *v_curr,
>  			     const struct net_bridge_vlan *range_end)
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index d21a511f1e16..84775e253ee8 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -209,6 +209,12 @@ static int dsa_port_switchdev_sync(struct dsa_port *dp,
>  	if (err && err != -EOPNOTSUPP)
>  		return err;
>  
> +	err = br_vlan_replay(br, brport_dev,
> +			     &dsa_slave_switchdev_blocking_notifier,
> +			     extack);
> +	if (err && err != -EOPNOTSUPP)
> +		return err;
> +
>  	return 0;
>  }
>  
> 


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F1831311C
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 12:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233301AbhBHLlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 06:41:18 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:7950 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233328AbhBHLiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 06:38:16 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6021227e0000>; Mon, 08 Feb 2021 03:37:34 -0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 8 Feb
 2021 11:37:33 +0000
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 8 Feb
 2021 11:37:17 +0000
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.55) by
 HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 8 Feb 2021 11:37:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jfYh9ax+WQ3YGhVN2M3SjO1mhfLsixMx6u/ruvYCyrLXICjhR7psWGJty4dDDrRs/+6zfLZuJRxj23OPgRoXkNmuegsDowA6cAY9VdzyRwZCAP3poFvszmoEyERXHl8U+JgiCpY3zUXrBC/BUdXPG3Z3eJZI2+5nXyRgun07NPq2n2tkFAEBMJwu2PijCRSV1OcjaKb2M0AXZL8sY0UKFVJHOpaCRH2FFHqLnHFp2hC/I3QnKqNZW6QYyym3cwJuwLMAA94QiZDK9EN7mskL11JGUWFPWfqhytVuEqgMmqqaqTtu4zmRjBF2s7HbmCV7G4I68jmdbmV1sNJtrPxRrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5xrkjlH3C4M0l4QFwJ9WihSogJ5HmSrMHPgdbhnBQHk=;
 b=fSunGNbyVsHC1uaVO1XZzOyY9saQsLCetwHWZ8vljTDMcOuNJAr3A0282P/6saPFN8yxR+uetPqiH7nksbdlQNRxNL9rWEQSr7xr5MVmEdL1Qa0LyrBjLf/ffjCs6iRE6t/BcmpeVN3AA/RqxKjLg+gYFwOpbJrEfSRZTlB/ijJ8vPT+9z6rrFx9fTo1aBKGNSHdxAez2F3JNqu5vjG6yjDk/gY1UOhy2w8FtZTLxTW3EOgVaqrEOdr7PmFIr9lCZjru0LvjbfVYfTwJzonENQTjpdULmnIjoG8cFjMawGxz1sfRxEITUfPGKw2tmBdU6nYKtSh+x+5nXA2DVrNVJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM6PR12MB2730.namprd12.prod.outlook.com (2603:10b6:5:41::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.27; Mon, 8 Feb
 2021 11:37:14 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b%5]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 11:37:14 +0000
Subject: Re: [PATCH net-next 2/9] net: bridge: offload initial and final port
 flags through switchdev
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>,
        "Roopa Prabhu" <roopa@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Alexandre Belloni" <alexandre.belloni@bootlin.com>,
        <UNGLinuxDriver@microchip.com>, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, <linux-omap@vger.kernel.org>
References: <20210207232141.2142678-1-olteanv@gmail.com>
 <20210207232141.2142678-3-olteanv@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <95dede91-56aa-1852-8fbf-71d446fa7ede@nvidia.com>
Date:   Mon, 8 Feb 2021 13:37:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
In-Reply-To: <20210207232141.2142678-3-olteanv@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: GV0P278CA0066.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:2a::17) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.121] (213.179.129.39) by GV0P278CA0066.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:2a::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20 via Frontend Transport; Mon, 8 Feb 2021 11:37:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d11d3c8-aea6-4185-b0fc-08d8cc25e127
X-MS-TrafficTypeDiagnostic: DM6PR12MB2730:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB27306EC60E65A8E36394C046DF8F9@DM6PR12MB2730.namprd12.prod.outlook.com>
X-Header: ProcessedBy-CMR-outbound
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PWwiJHRnQl1dZLq6Ji0DDBvQbGwNtkyaO54alplBlKZIy5AYNa3dI9K12yFUJa4Oz+1MUlaUx50baFFo2tyYIFQOkTnYUAMrdHFd9Hjj6TP2Kz3Fy8QMbKNzEGOuw621IU4vPB76udsdP89ryrb+B82gN7ROg2s4v/rcLrF2vfmZbU5VKOhmRRtsUqFKb9xRRmDZOajAnVCRMmlm0isOIALKbOo/ACzAAxthA08RNhgU7JoEb24Clzu1kQQ1tOAdpmRQbHPfT6jOJp9POCC6VROfJ4Xmj0NvJ+R7kwUHfNEY02g56M7rz8gon67TWYuMt3KGbhAyDGMWhmiTjymXBiGT2z6GNQkjr5ZQBEY3tYnI3dhWcli0zL+f0xc4DlojNMcjceQFj087u22QgY5wHLsBRKu9QW/kP6fbSSjY9KLmOXkNliyutrOeO/hJ6qwjxsfUuAORLH2Rn/lJJFrS9aGobOeiIOmNYRdPIOjjpb5D1ZzOpuxk2NQFksda9rZXUm3dzQRSZbgLe59HB4eg2/aeJ3vV3P9Rs3hRzRNwdr+m+FEHUZ0Kby4LSAHX29w3oCFxM9a7k7H/w+PRXBssI+XXRTDjyqfseekUe4z2VdQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(39860400002)(366004)(346002)(8936002)(956004)(478600001)(53546011)(316002)(16576012)(26005)(6486002)(66476007)(7416002)(5660300002)(4326008)(66556008)(2906002)(54906003)(2616005)(66946007)(6666004)(8676002)(83380400001)(110136005)(16526019)(31686004)(36756003)(31696002)(186003)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WmY4Rk5tbmZSUXY0VUt4ZGhTYTFZSWlZVzFzZ2ZnSERCelFFRCtFdm0wOFZz?=
 =?utf-8?B?U1h1ckkxTUQycmFVU0g1NXFyZ0l1bVNHM1YyTWI5TEZCdGNONFBWV1FyUFd1?=
 =?utf-8?B?bFFaK1R6MVJEZHdGTFFtay9Fck5uek44SzJpdXBkaVpzY0dWbGdlR1FDV0Vm?=
 =?utf-8?B?WUUzWjFWc05jWVdBMjNlMzlHOEd1RnNqZE1uZVNRT1BOUFE0cVZWNjVvMVcx?=
 =?utf-8?B?VnBTcEI4ZFhFN1NLUjRzUUswSUNQQXBPc3BEaHVyR2pBVURnRC93cVgrQmJW?=
 =?utf-8?B?RisySUtRWU1MQnp6NktweGU5WnVLNEpHTGR3bFk5REl5T0VUNVZWTTFpT0tv?=
 =?utf-8?B?N2JjTEw1dkwycnBEaXJBNlFTUkVYM3Q0WWxzY3BJeUlPeWxXWms0ZlltVnJi?=
 =?utf-8?B?VGhlOUY1ZW9rZ1Z0bjlBYTJCTHRPTFkxL1RiWTV1YzlaNWdRTTA2S0Z4NlRY?=
 =?utf-8?B?UkZuSkFPeGdadXdBRTVuaWVXazBBdDZBeE5WQW5PRmQ3VnV6Rkp5dk5XZkMy?=
 =?utf-8?B?VXlSRERZSXluQ0xMRUptN01YVk95aFRYWjZZeDJYZ1d4WUUzWXNSbXVYZTJY?=
 =?utf-8?B?cUZzQlVPYS8wUmplZ0l6SVdkSmptV2laNTdPblFJT1ZadDRTdFhKZFN0dlMx?=
 =?utf-8?B?RmVrMTNRV0Z6dlBxVXJQeE9WT2xkR3VpQ2MrNFExeE1MMW1pK1NuYTNTL1hu?=
 =?utf-8?B?eEZHNjRwcnB5My9tSlBLNUFZelExaUZXbjdXU2c0WnpWK0xTK0tNcnAvS1dI?=
 =?utf-8?B?R3lKUlhkUHNiMTVQN2JIaDU3czBpSTJwSlBDRTFqd25SR2tEdXd4MWhmemFi?=
 =?utf-8?B?K3NPenhHT2JFcDdCL1RrN2lic3FjNksrYXRua0pnMCtXVTRGUE1tQkd2MHFE?=
 =?utf-8?B?SjEzSDBWbFhBVnFkSDVGZ0Nad2NQdk5UaG9BY0MyY0RBMmtQdkczeTltSU83?=
 =?utf-8?B?VjVQUk5mbTE4SXkyeGxtUnI0UXE4Rjk3ZW9rM0hvQ2RmSUZJQmo0OFBCUEFH?=
 =?utf-8?B?ZFBFU1oyV1l5TUlvUUVhSFhNVUJuVGF4Si9wdkIzTkVpZkJXM1QrR2dNZ0l2?=
 =?utf-8?B?akozQ2JMTUxBakVzUlFIMnFYVDBIK1I2RzhDWUtSaFo2aFJKQXFQZkdmWnIv?=
 =?utf-8?B?Z3JkVkZKeEw1T3h1aDVpcmpPM0ZsMEJPNU9lQkdCNFJSbGhpT3dSYUtwNDZV?=
 =?utf-8?B?RFhrV0V0cEJZRGd1dmdBenMwcEVQdkdORXR1Zi96elNiOGNHTWF3cmpwSmRB?=
 =?utf-8?B?TXM4SVU1ZjZGcGNLblorcHJXZUtUMnl4eTczY3ZBQTRDeERiRVhydFRLbHJU?=
 =?utf-8?B?RjRkckRhUU1FL01JeDdMU0VpYWZCbGwzcjhiMUZUdXRmZXIxU1RTT3VkT0Fv?=
 =?utf-8?B?ZDgyV3l5dzcvZUFzZjBrdWs0SnIrYzdyZ2F1cUdxaFhCLzMyVnBZVmlWb3hL?=
 =?utf-8?B?ejA2a0VoYVdHb3Q2VXVPdkU3SjMxazJub09UMFBHcnNweGlpdFVVS0I4WlRr?=
 =?utf-8?B?Q2x6c3lMc2RHa05pb3FTQVpGeUpTUGdwSTJ6bEl2RUIwK1Y4b1lCd0NrbVV3?=
 =?utf-8?B?TjJqUS8wOHFkK1FUdkVHb21aN3VocGZmM0phbC9DUmpGaVlqc2tISklxbC81?=
 =?utf-8?B?SVFDYUhtQ0lPd1A1SVBrYXU1a05lMklHTjdMTUd5Q3UwVmx2cTNZa3c0MndH?=
 =?utf-8?B?eE52aEtick1HSFFPYVBnb0tuTHRRaFlaY3h5eFNaeWcydjgyUDUxZjJ3Q3kw?=
 =?utf-8?Q?N2E6aIjD8euhg43zkLDxt0jyLkg1cZje5aqyiJb?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d11d3c8-aea6-4185-b0fc-08d8cc25e127
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2021 11:37:14.5505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2BdPPY3cdFI+P8tO2XKYtfRlVoSOrtkb2MmHK2QdouT8w7aGwXGz8ad9ZY8XYUpQnXYkJisGbeHYGBA+hkRHXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2730
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612784254; bh=5xrkjlH3C4M0l4QFwJ9WihSogJ5HmSrMHPgdbhnBQHk=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Subject:To:CC:References:From:Message-ID:
         Date:User-Agent:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
         MIME-Version:X-MS-Exchange-MessageSentRepresentingType:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-MS-Exchange-Transport-Forked:
         X-Microsoft-Antispam-PRVS:X-Header:X-MS-Oob-TLC-OOBClassifiers:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=gEc+mLGwAUcH2ESLfXNEEwrqG0sNlauVFi0rKMTwZIT7ETGU3FtGmV2LrI1gEhwTL
         jykAobx9auobevX19GNBfLcFiIZ+J/MhhOTnMQamsRbWbc2+2aHE4zuXL1yZ6txw8o
         +3/MSpARiIWrvj9TXE41lECdhkkQHdqIKRGvMlDYVzYkP/2FFEjniPTwxkFGNSK5AS
         cgXdJqSNT2RrCPEcm7IwPABedZofJKrylCeIc38xF58ZCZ7UdlNVKh86suOHiL/MNF
         AcY5V1lbkovWflh74qWAMY7jaJvIaaqPJ7m3IHuZpfaXoRW8tGJCFKK5UP/RmI120D
         NaSGD1Srni9jg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/02/2021 01:21, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> It must first be admitted that switchdev device drivers have a life
> beyond the bridge, and when they aren't offloading the bridge driver
> they are operating with forwarding disabled between ports, emulating as
> closely as possible N standalone network interfaces.
> 
> Now it must be said that for a switchdev port operating in standalone
> mode, address learning doesn't make much sense since that is a bridge
> function. In fact, address learning even breaks setups such as this one:
> 
>    +---------------------------------------------+
>    |                                             |
>    | +-------------------+                       |
>    | |        br0        |    send      receive  |
>    | +--------+-+--------+ +--------+ +--------+ |
>    | |        | |        | |        | |        | |
>    | |  swp0  | |  swp1  | |  swp2  | |  swp3  | |
>    | |        | |        | |        | |        | |
>    +-+--------+-+--------+-+--------+-+--------+-+
>           |         ^           |          ^
>           |         |           |          |
>           |         +-----------+          |
>           |                                |
>           +--------------------------------+
> 
> because if the ASIC has a single FDB (can offload a single bridge)
> then source address learning on swp3 can "steal" the source MAC address
> of swp2 from br0's FDB, because learning frames coming from swp2 will be
> done twice: first on the swp1 ingress port, second on the swp3 ingress
> port. So the hardware FDB will become out of sync with the software
> bridge, and when swp2 tries to send one more packet towards swp1, the
> ASIC will attempt to short-circuit the forwarding path and send it
> directly to swp3 (since that's the last port it learned that address on),
> which it obviously can't, because swp3 operates in standalone mode.
> 
> So switchdev drivers operating in standalone mode should disable address
> learning. As a matter of practicality, we can reduce code duplication in
> drivers by having the bridge notify through switchdev of the initial and
> final brport flags. Then, drivers can simply start up hardcoded for no
> address learning (similar to how they already start up hardcoded for no
> forwarding), then they only need to listen for
> SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS and their job is basically done, no
> need for special cases when the port joins or leaves the bridge etc.
> 
> When a port leaves the bridge (and therefore becomes standalone), we
> issue a switchdev attribute that apart from disabling address learning,
> enables flooding of all kinds. This is also done for pragmatic reasons,
> because even though standalone switchdev ports might not need to have
> flooding enabled in order to inject traffic with any MAC DA from the
> control interface, it certainly doesn't hurt either, and it even makes
> more sense than disabling flooding of unknown traffic towards that port.
> 
> Note that the implementation is a bit wacky because the switchdev API
> for port attributes is very counterproductive. Instead of issuing a
> single switchdev notification with a bitwise OR of all flags that we're
> modifying, we need to issue 4 individual notifications, one for each bit.
> This is because the SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS notifier
> forces you to refuse the entire operation if there's at least one bit
> which you can't offload, and that is currently BR_BCAST_FLOOD which
> nobody does. So this change would do nothing for no one if we offloaded
> all flags at once, but the idea is to offload as much as possible
> instead of all or nothing.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/bridge/br_if.c      | 24 +++++++++++++++++++++++-
>  net/bridge/br_netlink.c | 16 ++++------------
>  net/bridge/br_private.h |  2 ++
>  3 files changed, 29 insertions(+), 13 deletions(-)
> 

Hi Vladimir,
I think this patch potentially breaks some use cases. There are a few problems, I'll
start with the more serious one: before the ports would have a set of flags that were
always set when joining, now due to how nbp_flags_change() handles flag setting some might
not be set which would immediately change behaviour w.r.t software fwding. I'll use your
example of BR_BCAST_FLOOD: a lot of drivers will return an error for it and any broadcast
towards these ports will be dropped, we have mixed environments with software ports that
sometimes have traffic (e.g. decapped ARP requests) software forwarded which will stop working.
The other lesser issue is with the style below, I mean these three calls for each flag are
just ugly and look weird as you've also noted, since these APIs are internal can we do better?

Cheers,
 Nik

> diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
> index f7d2f472ae24..8903333654f0 100644
> --- a/net/bridge/br_if.c
> +++ b/net/bridge/br_if.c
> @@ -89,6 +89,21 @@ void br_port_carrier_check(struct net_bridge_port *p, bool *notified)
>  	spin_unlock_bh(&br->lock);
>  }
>  
> +int nbp_flags_change(struct net_bridge_port *p, unsigned long flags,
> +		     unsigned long mask, struct netlink_ext_ack *extack)
> +{
> +	int err;
> +
> +	err = br_switchdev_set_port_flag(p, flags, mask, extack);
> +	if (err)
> +		return err;
> +
> +	p->flags &= ~mask;
> +	p->flags |= flags;
> +
> +	return 0;
> +}
> +
>  static void br_port_set_promisc(struct net_bridge_port *p)
>  {
>  	int err = 0;
> @@ -343,6 +358,10 @@ static void del_nbp(struct net_bridge_port *p)
>  		update_headroom(br, get_max_headroom(br));
>  	netdev_reset_rx_headroom(dev);
>  
> +	nbp_flags_change(p, 0, BR_LEARNING, NULL);
> +	nbp_flags_change(p, BR_FLOOD, BR_FLOOD, NULL);
> +	nbp_flags_change(p, BR_MCAST_FLOOD, BR_MCAST_FLOOD, NULL);
> +	nbp_flags_change(p, BR_BCAST_FLOOD, BR_BCAST_FLOOD, NULL);
>  	nbp_vlan_flush(p);
>  	br_fdb_delete_by_port(br, p, 0, 1);
>  	switchdev_deferred_process();
> @@ -428,7 +447,10 @@ static struct net_bridge_port *new_nbp(struct net_bridge *br,
>  	p->path_cost = port_cost(dev);
>  	p->priority = 0x8000 >> BR_PORT_BITS;
>  	p->port_no = index;
> -	p->flags = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD;
> +	nbp_flags_change(p, BR_LEARNING, BR_LEARNING, NULL);
> +	nbp_flags_change(p, BR_FLOOD, BR_FLOOD, NULL);
> +	nbp_flags_change(p, BR_MCAST_FLOOD, BR_MCAST_FLOOD, NULL);
> +	nbp_flags_change(p, BR_BCAST_FLOOD, BR_BCAST_FLOOD, NULL);
>  	br_init_port(p);
>  	br_set_state(p, BR_STATE_DISABLED);
>  	br_stp_port_timer_init(p);
> diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
> index 02aa95c08b77..ab54d1daa9b4 100644
> --- a/net/bridge/br_netlink.c
> +++ b/net/bridge/br_netlink.c
> @@ -852,28 +852,20 @@ static int br_set_port_state(struct net_bridge_port *p, u8 state)
>  	return 0;
>  }
>  
> -/* Set/clear or port flags based on attribute */
> +/* Set/clear or port flags based on netlink attribute */
>  static int br_set_port_flag(struct net_bridge_port *p, struct nlattr *tb[],
>  			    int attrtype, unsigned long mask,
>  			    struct netlink_ext_ack *extack)
>  {
> -	unsigned long flags;
> -	int err;
> +	unsigned long flags = 0;
>  
>  	if (!tb[attrtype])
>  		return 0;
>  
>  	if (nla_get_u8(tb[attrtype]))
> -		flags = p->flags | mask;
> -	else
> -		flags = p->flags & ~mask;
> -
> -	err = br_switchdev_set_port_flag(p, flags, mask, extack);
> -	if (err)
> -		return err;
> +		flags = mask;
>  
> -	p->flags = flags;
> -	return 0;
> +	return nbp_flags_change(p, flags, mask, extack);
>  }
>  
>  /* Process bridge protocol info on port */
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index a1639d41188b..f064abd86bdf 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -749,6 +749,8 @@ netdev_features_t br_features_recompute(struct net_bridge *br,
>  void br_port_flags_change(struct net_bridge_port *port, unsigned long mask);
>  void br_manage_promisc(struct net_bridge *br);
>  int nbp_backup_change(struct net_bridge_port *p, struct net_device *backup_dev);
> +int nbp_flags_change(struct net_bridge_port *p, unsigned long flags,
> +		     unsigned long mask, struct netlink_ext_ack *extack);
>  
>  /* br_input.c */
>  int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb);
> 


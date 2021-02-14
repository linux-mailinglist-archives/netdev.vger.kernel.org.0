Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9996831B021
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 11:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbhBNKoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 05:44:12 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:12496 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbhBNKoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 05:44:11 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6028fed20008>; Sun, 14 Feb 2021 02:43:30 -0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 14 Feb
 2021 10:43:29 +0000
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 14 Feb
 2021 10:43:28 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 14 Feb 2021 10:43:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kjx6avXuuTIoKVcrpNq63bUFVt3nT6qFkhtjcLlnuhs74sRfEbuPyPZBBb/tCnk6Dqj2amTjYHvsjUfrdoXY68/azYEJUWN0LlD113wcq2kIA/lSTIy/bF5iMkAIGMdfazyO+aoaqAH+4NU3jrDX9FnVSFZ7y4+NMbJlFPH2e48zt9GieNemBJpbUQH3mBfHnJRaQLsGNc4NgAkpSPgrO5gQbW2AVUxnxnfs1bMRbkDcTgxnhc1y9k8SbaeWLVHxS3i41lnj/E1528wh2CaYRK2lPhNtIiBfs+H/0TEDyeXRoCh9d/YY2oSsPX4siToOSSfi/4S7cfuRUK0qB51NaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O2Br8sDz8dHXV9hMui0I6WyBkV21Nc+c0NEnVxG5UTM=;
 b=dj7HeMHJDQfB2sZkTXXffSTydItMXVGwuIJaLmEZ3vSwcFcZy/cQ/PHo3bgCdPk73HSxZ8WsrYhCIO6wJ5qN4uDZfzmJ3t5QOAeb9ghgTMpYABRpi/fNK7innxzqNROLKhhc3sgGl0DWv5MLeKt95PP7oK+c0bfkSQ6t4Iw3TbqmppsTzRrnPmBN8ywbHuyqJl8dPmGHjto262lCs+9V3NSvjhUj05w0KiguAFXUzlf1OTCYqE9eKsyDwEm9eBKzcX4W+R3GHzxc7bnqfKBLsQIoBIDqcrnKLp0XqM/UkL8uN0X2gixQVcnrv7UvS4EYGiUEvnJ9FhJ2KZlI1L1P0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: idosch.org; dkim=none (message not signed)
 header.d=none;idosch.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM6PR12MB4896.namprd12.prod.outlook.com (2603:10b6:5:1b6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Sun, 14 Feb
 2021 10:43:25 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b%5]) with mapi id 15.20.3846.038; Sun, 14 Feb 2021
 10:43:25 +0000
Subject: Re: [PATCH net-next 2/5] net: bridge: propagate extack through
 store_bridge_parm
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Ido Schimmel <idosch@idosch.org>
References: <20210213204319.1226170-1-olteanv@gmail.com>
 <20210213204319.1226170-3-olteanv@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <9e8fdead-b8e2-7fe8-5a70-71fb788f5aa3@nvidia.com>
Date:   Sun, 14 Feb 2021 12:43:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
In-Reply-To: <20210213204319.1226170-3-olteanv@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0055.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::6) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.97] (213.179.129.39) by ZR0P278CA0055.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:21::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Sun, 14 Feb 2021 10:43:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71c5dd05-0f5b-4b33-5068-08d8d0d55b55
X-MS-TrafficTypeDiagnostic: DM6PR12MB4896:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4896AB5F9839FCEEFE9291D6DF899@DM6PR12MB4896.namprd12.prod.outlook.com>
X-Header: ProcessedBy-CMR-outbound
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DK9uOBNWSMM5MrdMtsWAaE3C56Lyxzut+/H0pO/kIpUbkrwzL/sGSyTibB3CaMmdnCCOp6cwzsy5VKEZyETykVlR7AZKavb4ygDiz2JsblD2exUyd/QWmU54lGhil3ZNbTipFqf+fUwEFW7zDtcRmYwGKXN7oPTU+R7tOtkxTtp+H88TiT8Mhv+xgtYMMCGRDzpN890XcNm18bnSfS9vhYMmF9W2ue8ygI/Cyqy71Tk9dsdSQ4cMqlJO8e6qKWYOzHMZWd2qM5In85d3Whs5g1lRTxBzRKKL83qYQdJqtOcLrRlqmeCuOVj5VnKy4DX3USpy30UCfOyvT1gKKfBV1GiO8RqgaUYGuraK6WoRV2fcNk0fwYHLZm6WP+FnQhCF25GUT0EbiPod2BM7Cso0mQXdxK9pbtpuRd5hwPog0gZFexRdRhL4HaTIVCd/q3g0kRbgy0Zr4EqTFETyNTqvoKogQh1sCk5v3PutsFxypliwUUwRXZ27p0kOOZ70UQci/jTnrGQJuOIueMWfqlOpF4WMWCpA0NiGo+poftQfNlufhFJ4mLgNXrf2IyFhKwG0RDxwEY9zRYtNTpa5hO5/bKHyToxZxNX6K34+/09YQ0w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(5660300002)(26005)(86362001)(478600001)(8936002)(31696002)(16526019)(2616005)(186003)(316002)(956004)(6486002)(66946007)(110136005)(83380400001)(53546011)(66476007)(54906003)(66556008)(8676002)(4326008)(31686004)(6666004)(16576012)(7416002)(36756003)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?d3UwaWJZVkd5MExkcXkvd1hTakI1aXNXRTFZdHFyc0UzQWVMRHlWV2Q2Mllv?=
 =?utf-8?B?RWN1VWl3ckxHWW9ldXFpMzQ2YXBDdzBrNjdPc25zM1QyRXZYRnVIb09RMnlh?=
 =?utf-8?B?QlU4QXJZRXJaYlZFc3QwMTJ0SlhHZVVYeDRxTHRPdXM2R2Z1SzRVUytHN1Ez?=
 =?utf-8?B?ZFJwWWdXbTAyTkNPZGJJQkdKMUFCMDIrOHFST2ZYei9PRFd5OThlWVJaOXdR?=
 =?utf-8?B?ZnRNeUJYSUJzUWwrd0MyUFlkSmF4Ui9rSVRqS01ac2hsSzV2ZEpjQzlEaEcx?=
 =?utf-8?B?SEtnRXljOGxRa2U5c1U2Z1hudytqYlR3Z1JocG5wbFk1MG5vWnlNeUt2MVhM?=
 =?utf-8?B?Tm45RWZXYUluWm5TVVBUSDhpQW5hRFlEM0s4WE9Pd25qYWpySzVWTCtoREI5?=
 =?utf-8?B?SGdybnZZckxaQzlNUVNvd3VTTnBPY0FTYXllVWhDcWVCM01xcm9XU2FheG9V?=
 =?utf-8?B?eHh6TE92R1E3YncxVjgzcG9obVNsUnBUb0JIcjVZeU53K24yTVRJdW5yM2Vw?=
 =?utf-8?B?L096M1FWYndRUEcyaW9xU3ZNL3FIZHFXNUdxTVhCWVN3RE83YmNSWS9WT2x0?=
 =?utf-8?B?Z3BNWGFFVTV0dWlmVFhpUkRmeGNpSGpycFJ4ZHJPVkYxOEJEcGdsZjV0V0g2?=
 =?utf-8?B?dmJ1RThRNHBPUDlZMVdFU3F4MW9tZndpSk1SaFhHUCs1L1NEckRUSkdWRS8z?=
 =?utf-8?B?N3QramsxYWlvUG5YMHVia215MnAwMHdzZmtrSGkrU1lzWFRNT0o4N2FvUDZp?=
 =?utf-8?B?UUd2Z3UzZy9kZlpiakZhZ1JObGQ5eXNQRzZ0aXo3VlMvYWVTT1FBTVNScHdQ?=
 =?utf-8?B?VU9kc1lzTnlPQkRzRmt2aTBPeFYrcGlteXFsT0YyVW1qZklYV01ETnB2NHhF?=
 =?utf-8?B?RndJakw3eWVnQ3Ard2ZvdGhpODNSZnJBZVlDbnppc01xVnhHZGtQSEZ4c0VR?=
 =?utf-8?B?RjNQckx0TDhySmk2ZUdXTWNmUUplS1VhMVNUbTFvRUxQZGpEeGtKT0dHMmx0?=
 =?utf-8?B?dDcvdlozT0xnVXdqMWhucHNnU0lsVmVHcFMxT055SFcwSG9FckxYYXowUWI3?=
 =?utf-8?B?K1BHV3ZzcS9PekRGQlNFOTlCMWZQbzNOcnVxR3lkcThlOGJyM2RicnVFNCtx?=
 =?utf-8?B?ckpZckcycUVoOWozTktUZDRhelpWdHp0WldBOThmNkJiQmhYbHJ4TUQ1WDlW?=
 =?utf-8?B?TVlUZnlTNllwMXgweDEyclBtQTdHVmFXZUZjNjNENGdzbHdGei9LVmFUak1I?=
 =?utf-8?B?TDRpNHVYR3k4NGw3czdCb1dXYmUySkYreTlKVEV0VFRpelI1bERxNmljLzU0?=
 =?utf-8?B?TGJWeVEwNnFMd3pnSnVJS1FoWWozdFVGOHpRcDd3UzdSWXcvcUhnenJ2SERR?=
 =?utf-8?B?MnJwT0FqOERSR1BNSnY1a1o4dmFJWWg0VWxQeXk0NG5PSXRUdTcxaFNucWxs?=
 =?utf-8?B?RXhDTElvRjZreHI0SjNMV0tYU1NPZFM0Tk56WGt4OXNUZ1JIUGx5c0dlK2VX?=
 =?utf-8?B?UzR3dkhlVVdyWXh1TW9ybGRSc09PMzhlUDVFckoyVmdxT0taRHpQUThnN1Bu?=
 =?utf-8?B?OEZkaEtYUGM1UkRQbDF0a3NBMFBQWmJVRkxjUEcrZmVwZFlSV1MyTGwrRDVo?=
 =?utf-8?B?M3hJWVJTczgvU0dSU1VpM3JVWlZwbjRPSDV3NnVhZDdlK0pTWDJpcHNqU3JB?=
 =?utf-8?B?c1N2SXpjT2hMR0FjcUVIVEhRbUJmaERxUytxL0gxditWK21wT01lMmZPdjZQ?=
 =?utf-8?Q?+NQXSJFD3DPA6lOsDVJ9iScFHEzopPjfFqJDeWa?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 71c5dd05-0f5b-4b33-5068-08d8d0d55b55
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2021 10:43:25.3098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w2eq0nDaIPTyfnMWiSU3wDjg+LsaQ9rrTZy7CM7PdpZBZLTkVts4nYSv477RT14DxoEDigrcorp+j5peE12PMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4896
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613299410; bh=O2Br8sDz8dHXV9hMui0I6WyBkV21Nc+c0NEnVxG5UTM=;
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
        b=qLLZGWXCcSUUbvH44JJFMD0D3NuBz6UR5hR7F5AucIJ4g7gSJILh32fKT3HcXvc22
         8asik1qaU3VCBqkuA8hWczQFo2RwF6BNk7bMdMxq853MNk+APQuy3HH18jzPe5Mabf
         ODg0YD1W1VAGN23aiI1SDvkEbUFUeKwDJUwN6fEnD5JR+ujrb7XBTIMO3IxAfaiFDK
         gT3MiGi+90GVN4D9/zjCbPOf5FUMvLNJDlpXH0/iHctyOZBPRYBhGq2RJpD6TzWrIl
         3yUeNcmEa9ynGkM+a5kS0MHJgr6SqxlBqeHNIB9M9EO5RAKpTcvdgirbAS0a6EM5zJ
         rRfsFEmxFKbxQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/02/2021 22:43, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The bridge sysfs interface stores parameters for the STP, VLAN,
> multicast etc subsystems using a predefined function prototype.
> Sometimes the underlying function being called supports a netlink
> extended ack message, and we ignore it.
> 
> Let's expand the store_bridge_parm function prototype to include the
> extack, and just print it to console, but at least propagate it where
> applicable. Where not applicable, create a shim function in the
> br_sysfs_br.c file that discards the extra function argument.
> 
> This patch allows us to propagate the extack argument to
> br_vlan_set_default_pvid, br_vlan_set_proto and br_vlan_filter_toggle,
> and from there, further up in br_changelink from br_netlink.c.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/bridge/br_netlink.c  |   2 +-
>  net/bridge/br_private.h  |   9 ++-
>  net/bridge/br_sysfs_br.c | 166 ++++++++++++++++++++++++++++++---------
>  net/bridge/br_vlan.c     |  11 ++-
>  4 files changed, 142 insertions(+), 46 deletions(-)
> 

Hi,
You have to update the !CONFIG_BRIDGE_VLAN_FILTERING br_vlan_filter_toggle stub as well
otherwise compilation will fail. 

Thanks,
 Nik


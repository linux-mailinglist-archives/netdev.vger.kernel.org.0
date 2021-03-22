Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A3E344C8D
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 18:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbhCVRAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 13:00:46 -0400
Received: from mail-mw2nam12on2080.outbound.protection.outlook.com ([40.107.244.80]:60768
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231542AbhCVRAQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 13:00:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=THjwLxLYMP7xq5jeLyMpqls8pFLgsu53qrWyPMWbrPX2YqQnbxLE6uOx6I4gVEzQNBKelUMp6JEnAfz/ToFZxv8DVDHapfyAog+q6PuL+nA7EEG76APFB0Lbnh4wPUhhjjjXIVaRGLVOlbsU/5ZQrU9SYST0fwLh6mUaBBdZgmQV6mCovsJ+oa0Pq0oMd8iSN0dmwEBgewyH4AI+oivR81YUu5xL0fQDUnmWnF9GmE0jXSNH5Fp6eSADYFb8+8si1W0jmIrUu3QpzkOTvqdmPqehT9hPOz7tTFOIFrLVposJrAtjN/CFtOOaanlFMSPEJXpNeQZELWnI3IAUKS6JLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6yttl/v7SIrQ50NWcYDrFElj+fIQz43CaeputDRrK8A=;
 b=AjnMr8Rufg5N10ydsCFY6/ChNK0stvjMtTjY//42nLzdWQ41Rfb3g/jVGebo1eGD8QlOZEPo0e9+gTQG3Va7tohu8B5Mx4qWynaeXGPv/auJBCCS51SGO/366mq6EzR9yHIzPbESD5PqewTnMXRCovmZI5N3rA/CD+/hySXmKA/x+Ws9EZ0YZEwsuHfz5mrB1v4/Ecs5SSxOsAsZCi004jQyNpLLyxqOU8XnO7it53P/4ueu00IXyzaLapyqVH7QdMS6E81hAjLccZK7MrlvOp16roH1cc88f1MhnYeKB5+s0Eh6i14LRmd+OWINqpgiCOQ1C2YGS1kgBt/Yx+Qi3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6yttl/v7SIrQ50NWcYDrFElj+fIQz43CaeputDRrK8A=;
 b=FeVCq3CYZAZccqrd4L6Ehh+Pa/tQ0FsSMO++bIZj4SoWGGu5Ov4hUoBAFZTubn0I6g0QXluBOQjK1xVTbu0adoyCE1evsBVSktG0vWV1EVvjWwaONv5kLlbGiGlx9vEuekt0aCenaM8Mtf/aPvEBoFgY6O3W8lLhbnqQajRN7ic3KOeJ53Qo2UcDHEhrpQ1ypU2l4+yCbp3fEjgiJGpIexIj82PawrvFOyPKD08bu/o5Hib4vbnblOsmFWluzZtYGNn8bP8Z8PlgdUfsLzB6A/qmZPMiIXlQ9YOlnvkq8s3brlaw+z7s8Vlx5rTiL3X210JuqWDh4SkGbbcc7CX8bA==
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM6PR12MB3724.namprd12.prod.outlook.com (2603:10b6:5:1c9::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 17:00:13 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b%5]) with mapi id 15.20.3955.027; Mon, 22 Mar 2021
 17:00:13 +0000
Subject: Re: [PATCH v3 net-next 08/12] net: dsa: replay port and host-joined
 mdb entries when joining the bridge
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
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
 <20210320223448.2452869-9-olteanv@gmail.com>
 <7a89fd44-98d7-072f-6215-84960e27b0d9@nvidia.com>
 <20210322165614.56sgtdxpmnp2dkja@skbuf>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <8ddd1fbf-69eb-3df3-0dd1-f39207c0369a@nvidia.com>
Date:   Mon, 22 Mar 2021 19:00:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210322165614.56sgtdxpmnp2dkja@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0077.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::10) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.38] (213.179.129.39) by ZR0P278CA0077.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:22::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Mon, 22 Mar 2021 17:00:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6d06ca8e-954e-4b62-dcb7-08d8ed53f5a0
X-MS-TrafficTypeDiagnostic: DM6PR12MB3724:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3724CF65E733578A4DF4F846DF659@DM6PR12MB3724.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hMQANGz3cTjEshqIt2eMLbxfPsoEyxiTIBaHAaD4+PxsmKjW6L1q5WARMnqv1J2f+xfCCN3XowDapeC4kW1oYHHEbV8WoOwz4VYNP8LMM4txCvDVDO+J+1raO5olREyOfRN5nG4dFn/p+ETMrxa2bw/3ru9U7MqxoUyd0fPmmDeVySW+bprCgfy20yWvLzgFQp7vjJk+XxSWIJttEn+4K4wM/ixDwXL/j9AWQAeb2x6VTK3nVRSmJxtJOFOwyB7pq041OI4VsaVtFdcWULKrwhOxyURskGA0S1yizFykBDUoH23hCBHkFcbAUYF/3a1MF41dhn9nqLZTooOBevIDNyWJx/DQU4FymDqiBMeAYeZvB+7izzzrrWzQUhhgDAzFzurbq7ViHj3vYkox5+nuPAqZqgLgU0nPfgNc4BdqHTu2d1QO9eS2ls5axROX2h2dX2ejR7FTM4N3qA9ZsUVVg4x2aoDuguyiAqpg6dcUE7H5oQd09TMEApkK5LzkddY+so6yFboa8hUo0hZAchDTF9/t2GtKlZuuZSBH5kLaD+1YBpX4mmN01XnvSfdNXjosaDDuvmyTG2Fk++k04ScTLtz16GwyCi5vBNkn9K2jEAOrGg4S152G/YPE+ETk7D6cw7qlv0x89aSWPTA1H3s4qDJLL66C3Iy2SX8ahJmIZ4i0hhzy4nVaxglQkHvThBTVU9U3YKN9ZFBpNR1Kj4TUhIyLtj+0Mg9bMjt9tGNgX3THjTFTbLPhZxut9ePYWgy4jqw7GlGNbgoWdBOe1ffh2hRaJOj1n6kooMsOxnXd3Eg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(396003)(366004)(346002)(31686004)(8676002)(5660300002)(6486002)(4326008)(6916009)(8936002)(31696002)(38100700001)(6666004)(7416002)(2616005)(956004)(478600001)(66556008)(66476007)(66946007)(86362001)(966005)(26005)(2906002)(83380400001)(54906003)(316002)(53546011)(16576012)(36756003)(16526019)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Q0Z6dkRlZTlqVlNpVTVxcFZZeGF2clpOdGlibHYwRVRSZ2IyUmUwbURDdkx5?=
 =?utf-8?B?QzlCcWhXWHcvVHlpN0x0TUQzTHQyNmQvWk9aODV6TURCUC9WcXdpTkUydFJ5?=
 =?utf-8?B?NUxVSGpIWHNISEQrT1U5VlBzSGtqbTFac1AvekZhRkJEZkszbW1Ha1lKQ1Zj?=
 =?utf-8?B?Zzk0d3RacjU5Y2tLdnUvSDJsWjNxRTlSdHVLc1lFS0dRaFQ0TDNpY0IwVjhC?=
 =?utf-8?B?dEowaTkxUlVuNXNNalBvUFFMSGNXR2cvWXRGODVVaFJ1dkZzUk9SSkhubWE0?=
 =?utf-8?B?ZkZIWURpak1UdVNXa3FXMHVkSCtVVXdkZ3A5MlFZOTliUlNybEZZMnRXSTNr?=
 =?utf-8?B?UU8zM3R1NTdrVTduREJHQVlpTlA0d2lGb3ZCdzBYREswQUxzQ1BTUU9IVTBP?=
 =?utf-8?B?UXkrQmNObTVuZ094eWZ0ZS9BajB2ekRBYzNEdTJlMEN3cVZ5TXlXYnJBdUNu?=
 =?utf-8?B?aXV5elVXYUYxcHBnS0NJQ2hrYmdrUEdXa1FtZE5scDROTlF1WlpldFBqbTVw?=
 =?utf-8?B?ZXFrZVJKTjNtM2pWMk5PQVhUSzd5SkxQL25WWUd4NUJVNGN2d0dnQS9XalFt?=
 =?utf-8?B?WGFUUjNrU3ZIN2RwQWxZK2N2UWdDYkRHcHJQdEVudmtkNUxxY2tNaExRQVlN?=
 =?utf-8?B?cmc5d1lmdCtQSVN6TjRtTDRaMHpacHRTeFFKTEpwaXVyYng2MWJpZXZVN0Vk?=
 =?utf-8?B?WFROK2VkVjhqTlYxRzNua205b2UvNlJxd05pdUFQNHJxSjc5bnNxbUYyLzh4?=
 =?utf-8?B?TXRuSzQ3RFJ0U0VIR2N6bjlGOEJsUFFPbE1BeGdqWm9jL1gxK0ZHaHYvT3o4?=
 =?utf-8?B?RXRHUkFXRTRwWG9zN0NmQWJMcUV3eXp5d3d3Wkd5OTZMM0hHTVlJS2pubG5F?=
 =?utf-8?B?dkpJVGRZZ3ZSbVNWRUplcE5KRE9jMlhKZkltMVlqZnpTMGJkMURjNy81b2Zi?=
 =?utf-8?B?c2VzZFJPODBKMHFjRU9mSGI4bGU2eWlFTWUrQU94eENvWDRxZURwSXMrMGMr?=
 =?utf-8?B?RER4THJQc01PcEJERGwraHVaMEdpcXBOZW5iSUhhcm5HTXE3V3JpMFFqb2pr?=
 =?utf-8?B?Tnk2T0pEWW9ndHBubFpKV1RDS2htSnR0QVdyWUtVTE40eXduTkM4RUp6Sm9Z?=
 =?utf-8?B?RTE1SW1tbG92U0RNZkdGMlhaYmJUbEtVZm5Xcjl5Z29kenpHL3g4dkppSjQ3?=
 =?utf-8?B?RVNmQ3ZwYUVZV3hXY3V1Z2pFTlJEL0RXRHlRdExVU21tbUdoMk9SaW5naW9s?=
 =?utf-8?B?ZDRmVkF2MGxua0xWQ1RCVnllMW1hOXlUQlJjUFZoMU1yRlZ5M3UvenBacG93?=
 =?utf-8?B?VFd0QVBBV0dCZUFmZ3ZXdzJVV3dQNWVNZ0ZOOXNLdlhZd3U1ZHNQcWNCMDF2?=
 =?utf-8?B?c1Bza3A3aWhCSUV0VGpLOTdXdlA2a2QrdllnM2tVYTZxZCtIdXJ4aXBnZkYx?=
 =?utf-8?B?b0FpMHFxWWc1bDBWV0dIUDB2K2M5MXVKSW8xaXBiU1EwUHdTWFY0RjNqN1E5?=
 =?utf-8?B?R2t0WG5IS1lNYTB5VElZWXBPeEQ3MVNYc25RN0Y3ZE05L3BRKzNzYTVONjVS?=
 =?utf-8?B?bGRGVHdsZHA4K216bDN4UDdzRERTTWJwNXdmMENiYkZORStWcUtMWkFrZ081?=
 =?utf-8?B?RTJoZXgwV09Rb1A5ZmFVTEQyU1ppSHMwWERBczRpUGtPSzcrOXhPQmlhSmdI?=
 =?utf-8?B?a3d3Y3pJMGdINUFIVnNZMEZIR284TWVEZVRQTU8zVk00ckNSeDBodnJXZnVl?=
 =?utf-8?Q?B1jwuS7TOl0zXw5xFwjHwE6bViKuwE3DNFchVZu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d06ca8e-954e-4b62-dcb7-08d8ed53f5a0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 17:00:13.4313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XKfloyiqRUsT5CCQmw02IiQUtRfQLFBvRjeOcsk2o4UJNKLPeMLoAncVjqZ0G779UH7l4Q6Qznq4ifwkrwB9Jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3724
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/03/2021 18:56, Vladimir Oltean wrote:
> On Mon, Mar 22, 2021 at 06:35:10PM +0200, Nikolay Aleksandrov wrote:
>>> +	hlist_for_each_entry(mp, &br->mdb_list, mdb_node) {
>>
>> You cannot walk over these lists without the multicast lock or RCU. RTNL is not
>> enough because of various timers and leave messages that can alter both the mdb_list
>> and the port group lists. I'd prefer RCU to avoid blocking the bridge mcast.
> 
> The trouble is that I need to emulate the calling context that is
> provided to SWITCHDEV_OBJ_ID_HOST_MDB and SWITCHDEV_OBJ_ID_PORT_MDB, and
> that means blocking context.
> 
> So if I hold rcu_read_lock(), I need to queue up the mdb entries, and
> notify the driver only after I leave the RCU critical section. The
> memory footprint may temporarily blow up.
> 
> In fact this is what I did in v1:
> https://patchwork.kernel.org/project/netdevbpf/patch/20210224114350.2791260-15-olteanv@gmail.com/
> 
> I just figured I could get away with rtnl_mutex protection, but it looks
> like I can't. So I guess you prefer my v1?
> 

Indeed, if you need a blocking context then you'd have to go with v1.



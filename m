Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD0431A243
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 17:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbhBLQCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 11:02:17 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:5886 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231708AbhBLQCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 11:02:05 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6026a6530000>; Fri, 12 Feb 2021 08:01:23 -0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Feb
 2021 16:01:22 +0000
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Feb
 2021 16:01:07 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 12 Feb 2021 16:01:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CvFeETw4ib8/neTmQg/y6M3APn5d23zPxlURWXy9OT7OohGc6ZeR0/HRWkvz0p90JEf/uzo++uTiBM0DozHpgs0EdRwbAlPlilMyyB4Gv66OGaDPymmea4g6cFnJGHcXZjC6sNx0xo4m6LAw8w4uYNZqO7O5hp+y9ckWjdy0XkxPYmgI7deN+SUc5J3xc311ksfiS3PxATYiZM8h0C8YMgiKP0Z1ktOrnDoerwevUB0uJvqVNN1/f41NbWms2pxJ4sEKeLUzObwI0HgjTvihVTp5w+qwb7wm7V58H9WZOTuIWioyiAWdc0xRjtBB0LBKiEE20ULs/T94B5X1SbTOTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eoxey4uRaDwnphH3f/Ib4i8PhWfZ6jebVvSmOWQ4hkY=;
 b=cZxsx0P1vTLFI1k9ycwsoEpCwidm7pCDGmmwyGEV6tZORSAf7YjsBhMAxWWJW/HjDymyEYeVs6gQ94OLtfbNqlgxkbdlm1emIHWKQbRvSJmixmYrqaLfD9g2qazc84KSrS8S4OUu0PYBEYCaF3QqTVm+G75URE7IMBCgvM4p5SggnY1oy73xOGl/ErluMxahZvWaGdlE6ErBi+c8ufF81EREQvBz+juFC1gOwpRhrJaNFP6MNjK7fF/Va8KXvqCGsvslERKeVKYtL7FTuldQ1jxy5TBiJPiu6YI2yPjopMXaK8bGlQfbbk7sk4IY1sgVupFmj0cJuCKdJtlOZPkPfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM5PR12MB1802.namprd12.prod.outlook.com (2603:10b6:3:109::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Fri, 12 Feb
 2021 16:01:03 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b%5]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 16:01:03 +0000
Subject: Re: [PATCH v5 net-next 01/10] net: switchdev: propagate extack to
 port attributes
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
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, <linux-omap@vger.kernel.org>
References: <20210212151600.3357121-1-olteanv@gmail.com>
 <20210212151600.3357121-2-olteanv@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <87f41037-4c96-b3bc-6753-03959bdd5075@nvidia.com>
Date:   Fri, 12 Feb 2021 18:00:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
In-Reply-To: <20210212151600.3357121-2-olteanv@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0109.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::6) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.151] (213.179.129.39) by ZR0P278CA0109.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:20::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 16:00:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8907a800-64ea-4a9b-5e8e-08d8cf6f6620
X-MS-TrafficTypeDiagnostic: DM5PR12MB1802:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB180296BFB7A77ACA2E32244EDF8B9@DM5PR12MB1802.namprd12.prod.outlook.com>
X-Header: ProcessedBy-CMR-outbound
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rcM1ooelnlPQmjjABqO1BrTqoycDw3PxqNkqId/EjdUa0nBNBqfx0NhWHXiWhmJxFu8ucUgkyWvkJ9ifRA077367+nWh8SaMyfJMiUJfamwIRIv6AkI/jEZCf8VKQ9gRqbFmZtm9MqbOl5ZrosU/8WrKPUja26bVkxZc6YKDrizbO1aLeySt6SugBTGM0iWKBc1J3YqDsqzNKeldVWSkwHIGA00YTDc33r6gEY10sbXyNa6pUFGF5/kLa3vTFGUFwk7V/YpWBvUrTi+EaK9FAYB1+sJbx7yY0n3+Y7IMmVk9Mf66jHX5rt1sfbvKnWnaCPTYVP9k6GPaoN3vI67G9O2rv5Wy4HLm34YD8ps3lsMOB+laoorNDIok3Kju0JYiRXfKTKF8vThQT+tdm+9LB8+cERyfG3zSRlfu3rEJwKLlqOgchLyQvpeyHCmhOmKIxp0rr6GExykJ7fSBeXgSncv5wwLOVRf8dj5a/ZJQ1FBxWst1Yzg6VuaEOH65TqWdD0yJEnEAr9WBvYti3RFiJL15hRG3o09DLibEXpgJQSwBiIQYGeYkCUn6SZmIKqzL+2eMkhnV1JKNxuz4knWuz90s/QbdhTL3gO4cPIpZbHE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(376002)(346002)(366004)(5660300002)(66946007)(956004)(83380400001)(26005)(54906003)(7416002)(66476007)(186003)(16526019)(2616005)(8676002)(2906002)(4326008)(31686004)(110136005)(6486002)(8936002)(478600001)(316002)(36756003)(86362001)(53546011)(16576012)(31696002)(66556008)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?L1d5eHVaUzI3bG9neUxPdURWWFdOajdQM1BJRUNRMDFzeUE2MVJPSzk1QVpv?=
 =?utf-8?B?L0ZFblBSaUJJbUNPL0syTmlZaFMvb2xualFjZ3JUTkRkd3JJSE4vSk9pbjI5?=
 =?utf-8?B?bWxTb2Q0NjYvR09pcWNQYnUyTzliTjVJRUtXb0I2WURvcXVJL1VOZUZNMHF2?=
 =?utf-8?B?Y3VPbUJZbzJLNlV5Uk9lTnNlNlZyM1RvcVJ4aHZ4T3JUaml2ZmNXOUczMkwr?=
 =?utf-8?B?d2xZODFQTlVDam8rKzBBZDY1RCtqazk0WkhyZnpVZ3JTS2syNWhKQUFCZWxV?=
 =?utf-8?B?anFDUGE0WEdlcjNKSS93MGhDaU9wRFZLKzJleitqeFBvNXBMZTY3ZlJWck9Y?=
 =?utf-8?B?eldMZDAvTkNMckRtN3d4ZGJnVTVGL2lkOUVPb3ZiWTF1c2VpSmVKMnF6OFpn?=
 =?utf-8?B?cFhIRUlEUDB6S0xHSSsyYjI2MjIvbVhjZUpqQnhLOTVHYnFmd0FOelA1T0Yv?=
 =?utf-8?B?cktWY1k1TjlDTG0rVnora1dPdzd6dFBwOVhENW9rZmtQZ2ViNThieW5sd2lS?=
 =?utf-8?B?LzVqZWdkZmRRbzdDN2JPWWhOY3R4N29sbkxTWUdMQXl5QXZCdUhWNmdlSG8r?=
 =?utf-8?B?RUhFQ240NUlVbFhSeGp1a2FOV1QrbkdRclRNcHhLUWxBUlh6d1YrZldYZmE3?=
 =?utf-8?B?b0swSFh4TGNrUmYvekp0K1R0aHVOc2MwWFU1bUhlOS9JQmlZQllpM2Yva0xv?=
 =?utf-8?B?ZzVFZzkvdEJMYmYzZ2JId1BESWhNZ3lBRUhLbW1DKy9uTWw5MEpteWZ5ZHUy?=
 =?utf-8?B?MVZtNmw2SEFCMFljZFVMNmNLQ3lTSUFTT1U2TklReUdTU1cwcWk0RFM1K1Iz?=
 =?utf-8?B?bzl1NkNtaGE2dEdwbE0wZzBvbE52SThpNm9HbU8zcTBoNm5NalhNM0I5UXhC?=
 =?utf-8?B?VFBpdEtnNEFIbVJBVnl4MFpxR0FrK0pwZWtUSXRSSkJSc203ekRmaFNNNy80?=
 =?utf-8?B?a1hHWXkrSlZhS2tERDkrOEJwM3FwTU5YMHRyQnNyR3dhOWtidFlHZkpTaGlF?=
 =?utf-8?B?TWZKRGRxTk1QZmxZTGJLWmtHaUdEczR1TXJQaGEvalZXNHdkMEp1WDkrQU5D?=
 =?utf-8?B?OWs3ak1lSDdzYy9SbktEMkRoOFZnUjRaVUc0OWYzYUxpTE1zMHVUZ3hPVXls?=
 =?utf-8?B?czBlTVRuaS9LY08wMFlxSmdTRkZCWVVJTUFOcUpmTkdNMVBPdVA2MFpYRHdz?=
 =?utf-8?B?WVhIMU5ZTjI2dDVaeDVleUlpUnZuNGFWeTBMSSttRERrOXh3aUZjY3NMdTFV?=
 =?utf-8?B?TkZSd2wrZ0JqV0ZXRjZFeW5CQ0R1MnR4VERJa1daT29vZVppaW05SGUxaTZT?=
 =?utf-8?B?ZVd6ckxOb0xDcHhvcDQ3TnovMXUyUzNoNXh0UWlGYWU5VDg4SjFTT3BQcHVz?=
 =?utf-8?B?ZFkyT3FERkpMSzd1akxqUE9FSGVYd3pEc2ZDMlVYT3B4STlyd1ArUm1uT2Mz?=
 =?utf-8?B?Ty8xaVRrazk5d09PdTQweVUvUzllOUJsSUY0eWpaSUFBUEUrcXg5VW5pWjRO?=
 =?utf-8?B?aVlNT2dmL2Y4c2Y5RWV5ZzhKS1BCckZvWTRPZzEzQ3QrWHViNEtQajNoeGRO?=
 =?utf-8?B?MDY4cFlqNCt0aHVhdjV0eWhkTFU4MFlxQzlza1oydWxsMG5sMno1MHNrOWdo?=
 =?utf-8?B?blo1SUF6cWltdnJOb2lOczlaUUVrT1RmOC9WbS80bDl1VjE2SHp4czR1dFFr?=
 =?utf-8?B?VkFKcGxuajF3Y2M4YlZicGdnMUdUMkVNZk42bEZYRHBYaFMydzMxNmNPWk9K?=
 =?utf-8?Q?8ULIkjsMBAQKlKIUEbLGHDKMQ8M5dnqovxwCZTI?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8907a800-64ea-4a9b-5e8e-08d8cf6f6620
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 16:01:03.6264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ELb+CGTPrBCYH1/tQCq8wsFqYkDuNdlHsHCt0bDi1I1ELO9FWa6BX85MKyHGqnvgSLDl2eqUz9bFxskMD1ahyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1802
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613145683; bh=eoxey4uRaDwnphH3f/Ib4i8PhWfZ6jebVvSmOWQ4hkY=;
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
        b=iAJ0HI2eVn44gvIuMlQpA2t2I4QhKwNKoodW8cRy1dYKcKdodpUabJgZFlrqT4p5N
         JIIMKyMG/mUKQbVSyc6JcFVJHBrnr6ZvMMlpJquMdwED2XvHO7I1cvdir6V6REk1fQ
         AVIZgjSxfZt/LsKIjAaY5IH0Gn86EkcYZ3/Z6k6DN6/3hKCMy5rupmCJKIxT8oLbBJ
         51aqhMD62yuF6wR+61RxDcvrhbS2CEFKx09M+/zODnw3Frq1e6e9ps+Gm7lEjDlrqw
         VzymRT/sCD/PBFYAboik5hG/ESdlv4H5QmyIp6ROtveb4nQppJwBllEeS8iD2gQzCn
         3V2KxQp6gfbRw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/02/2021 17:15, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> When a struct switchdev_attr is notified through switchdev, there is no
> way to report informational messages, unlike for struct switchdev_obj.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> Changes in v5:
> Rebased on top of AM65 CPSW driver merge.
> 
> Changes in v4:
> None.
> 
> Changes in v3:
> None.
> 
> Changes in v2:
> Patch is new.
> 
>  .../ethernet/marvell/prestera/prestera_switchdev.c    |  3 ++-
>  .../net/ethernet/mellanox/mlxsw/spectrum_switchdev.c  |  3 ++-
>  drivers/net/ethernet/mscc/ocelot_net.c                |  3 ++-
>  drivers/net/ethernet/ti/am65-cpsw-switchdev.c         |  3 ++-
>  drivers/net/ethernet/ti/cpsw_switchdev.c              |  3 ++-
>  include/net/switchdev.h                               |  6 ++++--
>  net/dsa/slave.c                                       |  3 ++-
>  net/switchdev/switchdev.c                             | 11 ++++++++---
>  8 files changed, 24 insertions(+), 11 deletions(-)
> 

Reviewed-by: Nikolay Aleksandrov <nikolay@nvidia.com>



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41CDD31B023
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 11:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbhBNKqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 05:46:07 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:12850 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbhBNKqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 05:46:05 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6028ff450000>; Sun, 14 Feb 2021 02:45:25 -0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 14 Feb
 2021 10:45:22 +0000
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 14 Feb
 2021 10:45:21 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 14 Feb 2021 10:45:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=foH8tEerJj/T6TYUbXIORWWA6Abqvnrnk9AjaxhFTwN09Dfr89dE13TkBYnA2aIW0W0+Ot+DfRfyzGIHSue7ugRJLMgt0bpQBIDesw4ETN+abwe/rwQVOFwfzvE2yXC9xEXl+ylmx4Ma8bLMhku+kspqnsYGOfdlMGZfmDx6ajXMEvU/oTxe9gT0oygjEBnJUPLEdMToPh3jXPQYZXbfS3iwohhv7VfvyWjXSdvP+zVkzxkrkahghGxZqv9SXaIGUzPkeW8xSA0T0fqZ8JcewrxaM6uRnOkpYsqGRuSe+hk8YJOlcaqqKLylFrVRwk4Q4P42H5g9lXPW66Xrrz2ptA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FxVmLXuDT7INap4XT4l9ysdnTifGH5EwUrw1kJZ3j28=;
 b=FrxAfX9SLzB0MSSc/XsBOwv/RUVZzgaFu6mS1GmbceGfUyHe3fHj8MT60/9ocQzw0GQ/uEH0F84SjqqRKqCNBAwLy9P1O/ZGj4E1vwp/My6csxuMDmGGh/Fi1G3YW79w/Qfayp0VbX12BQZ+/qISrOsZvHdI0g4Ar3Fk0jphQ5WYWd9aBZrocMnGW/cfeOh7/glh3LUov3jduPn0qpvLLMiCBXZHIs35daMMI647MqCfgmHiP1Amluo4diVRQ+k+39GT5eU9xSmMIsZgjB6lavt+IiNr4jZF0zTWvTY4gyl+lfSJhogpQibTIe2bYOFKpQA9cm6yzQXd6pyQkmhCIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: idosch.org; dkim=none (message not signed)
 header.d=none;idosch.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM6PR12MB4896.namprd12.prod.outlook.com (2603:10b6:5:1b6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Sun, 14 Feb
 2021 10:45:19 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b%5]) with mapi id 15.20.3846.038; Sun, 14 Feb 2021
 10:45:19 +0000
Subject: Re: [PATCH net-next 3/5] net: bridge: propagate extack through
 switchdev_port_attr_set
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
 <20210213204319.1226170-4-olteanv@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <74e91dbb-7584-1201-da88-77fbf93e26ab@nvidia.com>
Date:   Sun, 14 Feb 2021 12:45:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
In-Reply-To: <20210213204319.1226170-4-olteanv@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0055.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::6) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.97] (213.179.129.39) by ZR0P278CA0055.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:21::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Sun, 14 Feb 2021 10:45:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d33a760-6c05-42d8-3c6e-08d8d0d59f38
X-MS-TrafficTypeDiagnostic: DM6PR12MB4896:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4896A7B2DE0DBA05BC1C145ADF899@DM6PR12MB4896.namprd12.prod.outlook.com>
X-Header: ProcessedBy-CMR-outbound
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4GAzx/AgQXApDGfv37BoXSHFTk2nRt6X652SWh2MzB9NGjPTDHjYImUCdgg/Ds3fKmJKl249YXdthRrHqtF8nvQirjc44M4OrCuXZh1cr6dKfEsW2/aHlTtTei4ImLbNHdyz5yaP4b0dlwdQckQKX+mCXPrnScW2CboRbzMoeWfb5oFQc+7y2zYMD2ec8W55v9VjU6sh/4ocYEQ/tye2y+rkkYSsijn5J8RI2bB8zmALIDwdDoV+SGURy0XY+bJUup0CUVoIbeEdZgw0DxtGEONPl2EwpNXxfzKY2Z4YGZZ63rrbvhRCv9vjRX4D7pmUtXks0M1+uJqVhmnidfoImPaK9GGX18jTlPwbyf0TZHnVVWGLO5cbVQFNQrWIczUzbWI6yk0Z5xvJ5vnrwlYpRRlEnqlRdbQVL8KuyVS2tTy/9KTN4ctV9zi488pC8xM90nHndIM/tf14oz8nwvhbJc4YMf17bMHxj4KAYQT191qPcR7hIX7XW6TIbSLkRWGFkzXdIARAT3c0+tZU+LxGnbpwZsEiQ5NWYW2bevYhLFiX/2sVENbvIUH9hqpeaXRV8WdO10qjLSiYoP6PqJsD8gC65x+wnqiHC8xv/FGp0tc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(5660300002)(26005)(86362001)(478600001)(8936002)(31696002)(16526019)(2616005)(186003)(316002)(4744005)(956004)(6486002)(66946007)(110136005)(83380400001)(53546011)(66476007)(54906003)(66556008)(8676002)(4326008)(31686004)(6666004)(16576012)(7416002)(36756003)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OHhTeW1kZHgzSVFlcWxvYXhpbVpwVVNVblorVWRVckJZY0gwdmFQUTd0SVpz?=
 =?utf-8?B?YVFXNDNhYk5DeTU2dy8zclVsVThiYnZITzF5YmhFcGt2aEJaK3lTM3EzcCtJ?=
 =?utf-8?B?eXhuY0VsL2dYbGpCdzVhQll5YUx2d2l6Y0d5azNxU1pERC9aS3h3U3dlNjJG?=
 =?utf-8?B?SS9ZNVJCa2liaVdYa3FMSnJWL1gxSEs1VXJqVzk1MVZpcTExRkZSTmcrTVd2?=
 =?utf-8?B?eHdwVlRjQTRLS1FRRjk4cTcxc0VjZnpJeEZHMUpGTjJyL0VnakFhMkp0Uisy?=
 =?utf-8?B?Z04reXQrdGJUeURxVytObzdBLzdWZFZCeWNIMWxUaU43ZFBGWlJ1NWkwSmRL?=
 =?utf-8?B?a3JMWXZ5dzhxK3NwcXZjdmZiV2Nqd2Q2Qk82WEFDd2FhV09RelNDTmhPL2Zk?=
 =?utf-8?B?K25iYUw4cmdudDJkOW5jTEJlZFFuY211WGVBeVNSZXd3UHR1S2hCV2tFMWZV?=
 =?utf-8?B?WGVwWDN5NDVyWnNUVUJNbEkxQU9NWE9hbTBoSVpMY0pYbkJKOGROS0Z5QWRD?=
 =?utf-8?B?MTF6TEQ5TE45ZndSV3RYdGJROUF1RmtYMC8rN2FkcUFZd3Q3SjdWNGRYYnVh?=
 =?utf-8?B?VVBvdHpkZERBSEVhNGlKMGNDdFRkR3dPMTJaWE8yTXBDaW5zSm9TTERWTXda?=
 =?utf-8?B?TEF0MmdWd2ZjRjNMWkhPSVdTSVQwRksydEFveU9vR0RaT0tENnNoMHFhMk5Z?=
 =?utf-8?B?RE5xSFFCa3VEVC9qUkd0Vm1DbFZ3Uk1ZcGRzMjlXcFlMUVhUTHpXRlpxV0pM?=
 =?utf-8?B?NllCdkU5K3JUZERjajVmQU93WUwxNWUrUnQ3QlN1UmtQMUNKKzhKSG9Teld3?=
 =?utf-8?B?N1JtTlNqYmpUT2UrQk4waExrN0JObHZwdFdUbEVMcjBsSWUyL1orZmNxZjhj?=
 =?utf-8?B?U3E1aDdWckJ2b3BmUWZUcTd3K291MzgwaEo2NkhYTUJuY1U2ZmtzZDYwT051?=
 =?utf-8?B?MlBBK0FzY0dTS0g3K1FCVytoQXVIVWZTRTRpZHRZc2VkVFI4TkFLOURkV1Iz?=
 =?utf-8?B?N0tzOEpYVTA1MjhOZzZ2TGNVeWZYM0ExVVhHaFZJNHpiSWNOQ2hXRjFsM1gz?=
 =?utf-8?B?R0JOVlhnSUw5bUw3ZUFYWXllVDlPWk9FMGhIOVo0Q2dlWjZ6U01rTHRoS1Jy?=
 =?utf-8?B?YkJyZDFoaFcya0t6VGtycWJBRWE4VWUwcytmTmJmUkJjQUQ4WE1FZVkrRUYx?=
 =?utf-8?B?Y0JYS0VJZnVqdVRocm4yc21tSlFXS1pqK0JnSko1Z0F3VjhndDhuMmhoWjJM?=
 =?utf-8?B?b2VQWWVCMVlkL0U1Zm0vSjI4MXNZNXRFR0x1NHRuMk9oTGowY3RzZDd1UEVy?=
 =?utf-8?B?Znd6Wlo5UDRUYnlDU05Rb1REY3ViUGxGMW45TUdFTW9sZWdKbDNYWHZWSE42?=
 =?utf-8?B?dnFxYzNVODdSV0RPTFlVWEF5TVRaYVRyNTBCU21tZ1QyeUkvdHhwUFZORnlT?=
 =?utf-8?B?MXN5L3kzZWI3dzNvd1RTZFc1MjVuLzcwTGJwWVJTYkNJUzgzVnlCRTZBTy9D?=
 =?utf-8?B?YVh2ckg4Smp4bnVMV0ViRVBxZ3g2c0Vrb2EzYXd1a0lpbXNldmpDZUFzbE90?=
 =?utf-8?B?VVgxNkFOY1pqdlp3ZzFsTVp2ZUt2YWNmVk8zbnVpOUFGN2drYi9MSExKOGFs?=
 =?utf-8?B?bTkzRFNxZmM3dVBUWC9zOStZN0tFNm9hRlhiVG0xYmtkdm92ajM0a3FCNXJN?=
 =?utf-8?B?NnZUb3lkODJkZTlubUhzaURPZ2J1dzVFTmJ6UnhneXpta2RQQ2tjNW9KV0FZ?=
 =?utf-8?Q?jKlF1UaxFaabPZh33QU+LwiGeQEOoSP/oM1ykxo?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d33a760-6c05-42d8-3c6e-08d8d0d59f38
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2021 10:45:19.1894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dEKJGDwHM68zMvKT1LcPfr/EfGuPnUkCBZzh9F3MBQFvQFfeMMdaxc6us6O412VrIStZlDffyJVUEmpssmYzJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4896
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613299525; bh=FxVmLXuDT7INap4XT4l9ysdnTifGH5EwUrw1kJZ3j28=;
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
        b=fpdXo8u06XM6LzonS2VQb0BuCs/wMrqbYgAHvoJ/Z7TtrrB4oI2P03QzPEOiv9h4p
         TjHOvf4q4KfFIhjeQ2nakuTc5Xu8nSEE57UsOIlq1aILqnUwhxn2wRedOP6ejjvCuL
         XCwlnQddPrR24A+EG/orDf0ZU9S3cKiHPjYeW3OuGpecLD8SHCjfTWMoXony3oudkH
         iK7lTG3NV1/BDknxf9JGk5ks9NO7PFUAdvMXOMtzL0XLTz/NSaXUFlyiBEJlEKISNW
         4RVSC8yqsBq8OZK/ioLgyvQ3ff0hhZVhSFtJuVadJJRig5soQ3fF87t96qX34UO/y8
         LnIvzZZ3JsnmA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/02/2021 22:43, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The benefit is the ability to propagate errors from switchdev drivers
> for the SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING and
> SWITCHDEV_ATTR_ID_BRIDGE_VLAN_PROTOCOL attributes.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  include/net/switchdev.h       |  3 ++-
>  net/bridge/br_mrp_switchdev.c |  4 ++--
>  net/bridge/br_multicast.c     |  6 +++---
>  net/bridge/br_netlink.c       |  2 +-
>  net/bridge/br_private.h       |  3 ++-
>  net/bridge/br_stp.c           |  4 ++--
>  net/bridge/br_switchdev.c     |  6 ++++--
>  net/bridge/br_vlan.c          | 13 +++++++------
>  net/switchdev/switchdev.c     | 19 ++++++++++++-------
>  9 files changed, 35 insertions(+), 25 deletions(-)
> 

You have to update the !CONFIG_NET_SWITCHDEV switchdev_port_attr_set() stub as well.


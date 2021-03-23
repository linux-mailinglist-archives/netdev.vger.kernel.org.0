Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78C16345BF8
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 11:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbhCWKdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 06:33:41 -0400
Received: from mail-eopbgr690056.outbound.protection.outlook.com ([40.107.69.56]:31645
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230299AbhCWKdZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 06:33:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C+wW0WhIHnuyYJN30VzJWRYbdKRDmA2680sLD2Kylvpln7bO7VFEL0Azu9WMuwymt+Q+h08EJSQwIZWnvaJIdmKG97lnGMWnz2zmwrJYLmKf+zhEVsm3WFyeKRaIrgIlsJ4Sy/1f3xtR34nO8oIwSzFBseZToemNOnt8FVf0plJPVM/nCtPVgqOPh/+J42o2AwPxUuNWtqhZdY6UZ36tARfkffJzMEJgGxRqEiJaDtG4gy/28KCacB9PngBU3lES92KIB1P2s7f1xpKrdfs3PSBR7UjnjUGtWocgsw4GvxGT1q2pone//epRFICp/OIEo4dIO7kVFsPD43+AvUN6+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=59bdNzAwt5ZnN90XontxmC0qShXePt3P91IGq/OqWq0=;
 b=eW6V/88aT5LnYCjXw6fROaOPyOno2s8yvjpiBj0E7nnXaJ3K3Xmxqkc+HWSiFIUcssS3y/ce5GxCNSNnVFuxpgKrzO7F8z0IXfB40gTcIM7hvaqjX+XiOi3QoR7N5wA6J76M+w8IT9KPhDGOWa776eB/hpatUqvbyQVNWJjtMZhT/JWexPknxuSybFWhlXqeUDS/LwXF0Z8M4VZBExyBuxoIetGyK5zKFM+TQrobq9kHLqLqxQudXbQ4atyRcsdavdUI7hOKOLVDu71hn/t7e/Pkw11EW4NhHc1+w9He873rn/Q43Ntqgmwtj+vPImi7+mBcsgYaJLKaVVLT4qexrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=59bdNzAwt5ZnN90XontxmC0qShXePt3P91IGq/OqWq0=;
 b=UR/Ap4OOEECP7EHer4RLU0OHM8RgLtatny49SRhrm+WEyW+NT0dk9pv/Khvp2GeB9bQPkCqY5H1zMJIjFMcXQ8QVW2vPo7gRcZw8/OYPZ3ZUirYDzPUlf/IVD7oZpyiHCA6sUHSZZKqhoKj02Wzy1fewXeM4J3YjG7NN6GkPY3ZzrjG0RvQpo9Ld7nbfy+o2JVNzorRYtgRhYdMgqIuQUSvGP5r/Iqt+NITBe9TJujAzIvTYtn+KlEIhIk2O+qHOE5sAd1H+FewfCCbZl5ijwxtBUmcwVlEkJkVh8WATdNEBhaOdqUVtT84qucGDRdVn86bLv1LQS42FHGiMOvjTPQ==
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM5PR12MB4663.namprd12.prod.outlook.com (2603:10b6:4:a9::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Tue, 23 Mar
 2021 10:33:22 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b%5]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 10:33:22 +0000
Subject: Re: [PATCH v4 net-next 01/11] net: bridge: add helper for retrieving
 the current bridge port STP state
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
References: <20210322235152.268695-1-olteanv@gmail.com>
 <20210322235152.268695-2-olteanv@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <2d6ee47b-3fc5-4884-11d3-99544a95219c@nvidia.com>
Date:   Tue, 23 Mar 2021 12:33:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210322235152.268695-2-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0080.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::13) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.137] (213.179.129.39) by ZR0P278CA0080.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:22::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Tue, 23 Mar 2021 10:33:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e69c4687-3ed3-4509-ab54-08d8ede7150b
X-MS-TrafficTypeDiagnostic: DM5PR12MB4663:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB4663F0B375F4CD429B83F165DF649@DM5PR12MB4663.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z8+lItdhYk7gXA0jgBGAU5xeKRaNiq9PRfAygxuPFKOivtAOKMWIncG1r5b4c9UuwsBxcYVUE6+tPWH5dkdroCe5jM28mgoYC5uSUThVqlTb/JiJf7QqqrtoXiMNQHsf62fX+5eXXBo2tvk9wHQ6c2VrTCmf0PloYELRLxFyinz+bzB+zwMejRl4n5LYMaS+4oIonYGgr9frgQCSy6l2dUMlbc9ffM4zbniE5NecEHEWz8B2ZN9VLU5JERXblKaRhSCFkrN5Cm7VKUoANY+5GJRd34dK33sC3Ge6glVsFWm6xoMbllDOQiVbMDQwXnaeRGvESdwWC/Hea635RhwFrKDW27y6tocF1jkE+SWg9wvQ5mEhuAieMRG5qGY0weoIQlCQUES0C7k6TnoG2/fHqVoXwANHLNprjr2vVKtB38z19QVrKiX6SjsSqfX4L9jvehk+vVTYk8ZNOtWQJLeTcAkFyg/Zl9dgYxAez9t3sPBC2i7WyGqJOfu62DIeyWWgLL8AyhsEGYd0oyfhxZymaxPCvG59qyRWSyi6LZB5+fApNkDEhjUBC+BH5xMh4TdC9+rktqfcGh3TLphdkGLZ2mx/r5cbDaAPYk66wHhxVXwPuEXuQfIkoF4FNBRZQunH6ws3lXitcx1ewKO8dl3FQqRS2hxNnDptYns5xYJ2wiJvb64mdKYQEGcO8TnLFaPkkOqZLkn12eZnxiP4Y6l82A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(366004)(376002)(39860400002)(956004)(8676002)(8936002)(54906003)(2906002)(2616005)(83380400001)(5660300002)(66556008)(4326008)(31696002)(66476007)(31686004)(36756003)(53546011)(6486002)(66946007)(316002)(38100700001)(16526019)(86362001)(7416002)(478600001)(26005)(6666004)(186003)(110136005)(16576012)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RE9GNlJtdldEM0RZLzVpYTBXdEw4NXZ6V1BpVk5KamovVVFSVUNqWXROSnRk?=
 =?utf-8?B?U2ZUbTBIUjFwZlR5YnUrazNMK1dHSXN3dWZuL3BaMHArWk5iTm8vWStHWmpS?=
 =?utf-8?B?QWJvK2tnK1RCTjQ2d2NKN09QL2FVcVp2QVc5bi80Ykd4UU15VjhGV1Nnb3F6?=
 =?utf-8?B?MGZIZU0vVGR3enJkV1pCTkhYTnp5Z25CSTZxelRkYXZYRGxDOGRFNDNybFRO?=
 =?utf-8?B?S3QxaHhHR3diNXcwTmJ1akkxbHE3NENyb0Zwd0RJT2RlOVBYeWo5NCtUVXV2?=
 =?utf-8?B?TUdxYmxBbWNSaVBOeWlaMDJIUEljdmdnNEtwTjBiQm4zQnNTdWpSSENSbFJY?=
 =?utf-8?B?OUQ0bFUzZDZoLzd4TEk4RmRZR3RueGxrSWdaUGpYUjB4blFMWkpzNHVzVGZB?=
 =?utf-8?B?TWVoZFQwN2tsalFFRlVheVhJUXQ0VHhJMU5odE02RUpneWtXbEFMWEk0Tk80?=
 =?utf-8?B?SnE4bjF2VTFnbFJFL1J1OWJ4cVllVjBBMzJKTFFxZ0tjYW9PeXlyWFdwNThq?=
 =?utf-8?B?K1lQZVJIQ3VrN1V1K2FOK0M0c3lDemlUZVdzcnFYZzgzRy9xakpRbk03MHAv?=
 =?utf-8?B?NnJqVkNLbVZIT1M5ZVluWXhVc3d1R2hWeU1PeDZXNnFNaUUwaFpTS25DVXNU?=
 =?utf-8?B?dFV0S24rM2s3NTB3cjJrdGh0U1pwYUIxd2t5T21sREdYLzExOVVZUGJiaEIz?=
 =?utf-8?B?YTU2SytrS0Q0WUl3MjVCL0MzZkVHSWN3SERteDRqclhKNG1mOTcwcmE2QmZl?=
 =?utf-8?B?UGZzVCt6b1IveGlPVitkTXVuRm1QVjZnbWk5bFh6Q3MyTUY4cGZ5eW9Lb1gx?=
 =?utf-8?B?MndkZndnaHVGczd0WWluSUd6aHpZY0lnMVQ0MXBqY1MxMnVCUTREeG1qWXpk?=
 =?utf-8?B?YVA4RzJlUmRXaXVlbHVWanVZdUM1dXJHVDBRVTBZUDhJV0doS3FDYlZyaStY?=
 =?utf-8?B?Q2hWNVhIU2kzQXRQRTgyT1hRSVJSK1VkT1pJNEhadWxuWEJCSURWZnp6VExs?=
 =?utf-8?B?UFB3Z25yMFRGRi9Vb21Jcms3cjlwczV4cWZDZzkzNGpnMTA2emRnWHdnTkFq?=
 =?utf-8?B?THVtSm5nLzd0dWdxNFhGMU9UODBOUjFJZ0tqcjVwOXkyaHVmSmFPdHhHNEVs?=
 =?utf-8?B?UTdJNDlncjczckZia0dzUzFUWVVNRjBLd0JKK3BPWVJlaFg4bHc1cmdBUDBp?=
 =?utf-8?B?Ujl0Y2YwRzdNMmtXVFlBenlRcEgzVHMzMUlZZlhwaGJFcGlEeDA4UkRYL2Y0?=
 =?utf-8?B?TEZ1dmMxWFV2S1NoVENhZEVjZW5KbUh0RkFmLzhIM2Z6WnlsUnFyYWdMRDZk?=
 =?utf-8?B?MEZBMWVrTmx3aVhxMWVUTVY2WjdmNnBFNGlPRzJmNVlnRnFmN0c0RVo1T3Ji?=
 =?utf-8?B?VTZnQWJtMEtCM2FjZG1jWkplNU4rdXJzdE92cnBKMWNUc2lkMUNxRVdYS0s4?=
 =?utf-8?B?eTRjeDRiazMxem1pSjFpR25RcHVTKzhzUEFueENnMWQ4UURmcW95UU9PY0RQ?=
 =?utf-8?B?ZDM2YnpIVmZteXpQeDZ0NnJKUzNQODJuaTFpd2RpVnVlQnovRzZKWldFR0Vi?=
 =?utf-8?B?aUE0eFZVdnhkbUFMSklrQ3BXM1hvSXhjSWFFSUVadTNwMWt0eWhzUHJyY1NE?=
 =?utf-8?B?T2NOMFVycU1SN3JGTWVDaEo2NjU1YThpQ2FucStya0gxaFhjVXp0VTFDdVpB?=
 =?utf-8?B?TGVOTE5BQTZ0azF5QVorQ1VBckhrd1lDQkVhN1FXVEJCZTRSUVJPRU51YUVS?=
 =?utf-8?Q?3+geEyMDlvoN0hlFvPGl6H1SUwwc/yRFosEIGwW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e69c4687-3ed3-4509-ab54-08d8ede7150b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 10:33:22.1868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8lqr3+K31ncd9xl+Qd0VbckEurq0DvhyCab/IzA+TNDZ0+Sa2lovVPGdpKa1RdTOgHVXfG23mzbS+eGJmHrW+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB4663
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/03/2021 01:51, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> It may happen that we have the following topology with DSA or any other
> switchdev driver with LAG offload:
> 
> ip link add br0 type bridge stp_state 1
> ip link add bond0 type bond
> ip link set bond0 master br0
> ip link set swp0 master bond0
> ip link set swp1 master bond0
> 
> STP decides that it should put bond0 into the BLOCKING state, and
> that's that. The ports that are actively listening for the switchdev
> port attributes emitted for the bond0 bridge port (because they are
> offloading it) and have the honor of seeing that switchdev port
> attribute can react to it, so we can program swp0 and swp1 into the
> BLOCKING state.
> 
> But if then we do:
> 
> ip link set swp2 master bond0
> 
> then as far as the bridge is concerned, nothing has changed: it still
> has one bridge port. But this new bridge port will not see any STP state
> change notification and will remain FORWARDING, which is how the
> standalone code leaves it in.
> 
> We need a function in the bridge driver which retrieves the current STP
> state, such that drivers can synchronize to it when they may have missed
> switchdev events.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  include/linux/if_bridge.h |  6 ++++++
>  net/bridge/br_stp.c       | 14 ++++++++++++++
>  2 files changed, 20 insertions(+)
> 

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>




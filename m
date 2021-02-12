Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30FA331A234
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 17:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbhBLP7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 10:59:13 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:11475 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbhBLP7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 10:59:08 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6026a5a30000>; Fri, 12 Feb 2021 07:58:27 -0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Feb
 2021 15:58:26 +0000
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Feb
 2021 15:58:10 +0000
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.59) by
 HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 12 Feb 2021 15:58:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mnrmuk43PTgCn0/Tdjaz4N0RUgD7OT/MX8wZA04ThbKKSRVOJmU81XO5GUC/O5cN2Qx+ff++76sobETAaos72c5jqRKv1p6ibYaRutCGasKM5roBxn0M7QPVr2ivad9uA7R+DKC5GxMfb5ocZr4CQebp4azZki5xeoDpthcBQK9h2hyuTZMHMoUxSqBBlsor1eL8U4zw3KoDHPsnm9XhsqqIPxw5aD2FamTpRgScw3v1z/8NQ5EOvAJPVsOeDYz39z6EpZ24UK7a4m6qERZLcqeJOPIqVfXG2fFdn/pl9ZCypy3sctkEg1H7B+PpeXq3UskwCzS/2ZabW2FrQ7aCGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LSft3buX4w1vCQIlPiRj8m8wbjb175Ig0+OfBdf/5hs=;
 b=P9gytDg0yrA3b6GkSL4UkgrkZjn4BuvQlKJqWFXgvGwP9Rd5ni9uwp2sZzAkfgJA3HAaJ8wISH/sfGJ4Pfbe22eyGPGgFJjTREIUduzrXWukrfsIW3SX1foHAmzqoWf3I+Dz8VaSXQLtvf49NkxpjYbF4DgRe1+fhdR1D4+Lzh2yorxO0tS0J7r9cmIFdR3yMPqfTvtw7XK6MFQkl9MIOQe+iC8F8HzNFj9aI+lshERblhDYM8D1sXlvxpBib4I5wc/W3FDuPs2VBnjyWSGTYsxg+nyBo49l+Cu1II6iJJIFEbz0/cx45+Dc8UckPDT7khDMufPBLM5vxDz5bi8kMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM6PR12MB2777.namprd12.prod.outlook.com (2603:10b6:5:51::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Fri, 12 Feb
 2021 15:58:04 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b%5]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 15:58:04 +0000
Subject: Re: [PATCH v5 net-next 02/10] net: bridge: offload all port flags at
 once in br_setport
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
 <20210212151600.3357121-3-olteanv@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <23cc0f12-34a8-7a56-0bba-82bd4b2d3a44@nvidia.com>
Date:   Fri, 12 Feb 2021 17:57:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
In-Reply-To: <20210212151600.3357121-3-olteanv@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0122.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::19) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.151] (213.179.129.39) by ZR0P278CA0122.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:20::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.26 via Frontend Transport; Fri, 12 Feb 2021 15:57:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 20398b98-57db-44c6-be6a-08d8cf6efb0f
X-MS-TrafficTypeDiagnostic: DM6PR12MB2777:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB2777EF67F30DB867FEDAD01ADF8B9@DM6PR12MB2777.namprd12.prod.outlook.com>
X-Header: ProcessedBy-CMR-outbound
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5OmFOfFskQ5yUHqzqy9rrJBcuwGOCXT8nXFIJbpYYBpDbjWAVSwhClt/5ApfVqu2ITzHO0AFvlVVxN9uQwyjJqZEhpSv+dZMcbSX6js2Irdd7XCyO/3eVYvbyLYLIxZ2DFKQUZobY1ACpBM2VMaVgQJlVTkmunEAVDzVp9rsJWuRRm5LMADUw/7V+N5V0bkxln5ipyPE9LbeQAg+qTmwZ1UEbPV/LSoZxAEL3UcEThUamk3Mrojns5OjMuLj2PH1E1RzCjKii9SJP+rtIna/t4kOLruFTL59AWquBqs7VVbLhW5dCJEe0q4pLlujnEKeFq7tKbKbiNWbSUiinjGKZSdp1rRlClSuUMBgwre3shvIiMd1NYTP7iBkOYYbyIIB7XOXDeSyT1h31NRTPmiUSo58X3x/RfY0MmkUMhnTYaL4/5EqMkb5jFQQ9TqJhgSUGzZNPBQKDwFzh/IiSBtM+a42t1okcHSAJcneF9MaaZZR/LoK+K9Lr3R7bSyJbT4M9XxJNckPgAmNeMNrkbNCnFj8HKqIv7Ft91o72L3CAOvo7wKxtnBT5oq5hBQKUhqZP/mbGH5LrZjz+RBV9b0dPKy6y02sOpFUHuHLtNLGj0w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(39860400002)(136003)(376002)(83380400001)(66946007)(66476007)(2906002)(7416002)(5660300002)(956004)(2616005)(26005)(31686004)(316002)(31696002)(66556008)(6486002)(186003)(110136005)(54906003)(6666004)(478600001)(36756003)(53546011)(8676002)(16526019)(86362001)(4326008)(8936002)(16576012)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SlpHRzkyWHZjd1kzb2h4Si94M3ZoUCtZNzkzNkttVVZWZlpnWldxS2lXOTkw?=
 =?utf-8?B?WndTUHBDTHpwNi8xY2s5K2RUdk9OVlRXSzU3a3R0UnFzYlBDWGVRcHpnV2lI?=
 =?utf-8?B?NHNWbE1sN2ZDVVZyZkxjN250VnpQODRvYkhrZHY0SkVuSEd2b1ZZVmJFMFBE?=
 =?utf-8?B?bVlSYVdhRGNxZ05BS05LQWpnYlhsNENiV0FLTFlEQ2dPc3pXOEYzZS9DYkJR?=
 =?utf-8?B?RGxzZ2FGa3pjVVF2RVJSWUZibGV1MnlEeGk1MUo4QWtad0tna1M1TWpoMFpM?=
 =?utf-8?B?Y2w1ZGNUK01xNGFFcnE4dk04UFdRS0NCTzhRUVY3OUZ3enk5a1FyMm82dmNS?=
 =?utf-8?B?elNXa0ZrMUhqNUJYQU85WTFPdmtxYTBnZ0p1ek02STBJTnhXY20xTUZBcVJt?=
 =?utf-8?B?RitHNjlDZnRRd0J5QXgyZGFsbVhOdlIvNjRIdS9xMzR3eklrQWdyL0ZObHpR?=
 =?utf-8?B?Mmxlc3puZ3VZM0xCa3dSRnhZZ1ZBU1A3QUZUMll0SE96V0MxcEZDVmhIaU9y?=
 =?utf-8?B?Y2t0RU9YeXhJMWQ5WGVmVTVNSlZJQjhJMldQdThLZVM1bUptdWlnTlB5azRK?=
 =?utf-8?B?dTJEU3pndEpLVmVjdktlM3Bjd3JtNnBsV3I3NWpXcFpIcWJhbWdoek5Fc1hX?=
 =?utf-8?B?djM5Qkp2MHhmdHVhbEJGTWxjdUg2QUlwK3lzd012cHVOekFtU3RGT2pTZFY4?=
 =?utf-8?B?K3hrbkFsYkQwUkNZMVdXcGFvbnRUbWF3UEs2Y2dnaXpIcTlPdkFhU0wvcnZV?=
 =?utf-8?B?WGxvYVJwQTUxZkZjcDBwdHdSU21KVzRjcy9DekxlODY3cDFPblhOYlh4UkRC?=
 =?utf-8?B?YWQrK0hOM29PR3QyenAzY0RpbGk2WXhQQk5EMHhtSldTZnpQbk1tbm5QS0Zl?=
 =?utf-8?B?QUFkZnpoazcrVk5hV1ZvSjFQUjZSZ3BUa1pLeTJwOW8wbjFWcU9HZStVdGRh?=
 =?utf-8?B?b1F1WlNNaHJJWlVFS2VmVFQvdzZhOEZVOUoyU2RsbnlvQWJJZVRBUW5OYmpy?=
 =?utf-8?B?WElCT2x5VTk5c1RkT2VMbFRsaUMyMU5TVjlBWjRjclVQU2FuSlZpR0piMncr?=
 =?utf-8?B?Y3pjS0VrTnhqRlBHd3VwS1MveXdJME5TZFlUaFNJVEZ0RWw2UzQ2UlVVSTl6?=
 =?utf-8?B?VUxqT3o2Z0NvUjFwbE5Ta0JGaXc4VjEwMHhUakQwUUYxNklPZkVSbzNBZFRC?=
 =?utf-8?B?SG9mb09YL1I2SjFTVHIrRE1ySzJZRWc1QjhGMkNvelp1ZFpKdGRSTFh5R3dN?=
 =?utf-8?B?dmJWRDJJUE9MWXRFVGt1eWZLTW1vTWhWYVozdUU5N3o2Z2NxdXQwQ0dzWjZR?=
 =?utf-8?B?dy9FQ25LRDEzMmxnazRSSDhnWWZ0L2VpbkZjb0U1UWtZU1Z3cUZMUG5FaDd0?=
 =?utf-8?B?dDRUMVRWT2hPVlhlWVRycWtuL1dXeDJTaFp1dGxWZ0l4b3EyL094OWdXbm0y?=
 =?utf-8?B?YUxya0VrMllMQnFJU2E3OTN3eXoxZC9TUUJoaE81WnEyYmlRNUg5NVAwYTNj?=
 =?utf-8?B?OHVjK1R1T3NZcmZBaUlIZWdXQmxKdVpxZkY5elc2UW9oZ0s1VFEvZnRQN2Iz?=
 =?utf-8?B?czMxZ2VVUWVSR0ZzUWpRRE84aEUyaEQrVXlRcTJlalR0N0pTeElhM3UxcDQy?=
 =?utf-8?B?Ykw4akIvbzF3bEtkSll5bkxmTUovdEM3aCtVdHJ3NlArdmVqSWl3YTRkMFJ5?=
 =?utf-8?B?S0FFMEJySWw2YjArKzF4b05QekFIUWc1MXlEYTlVOVlkUTlUd2pkTHBubzVi?=
 =?utf-8?Q?rxlUSmFrsLz2UuZnYOCMLhGNF0DHhAP9yYdsEAT?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 20398b98-57db-44c6-be6a-08d8cf6efb0f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 15:58:04.1158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: StnyvYfrEm2hmFL+CKULPG9gF2YPSTTcBbruwVLcuTWWGu5PjRGeFaRCP2lmaCwkI+Ezal6XU1vW/GBaANjigA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2777
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613145507; bh=LSft3buX4w1vCQIlPiRj8m8wbjb175Ig0+OfBdf/5hs=;
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
        b=o9BiMKXn7VurEx/LimWb4nyWAJ5BYu0Ko5MJ0SVBI1PkKwM/TD/vHyPfhradzZDrv
         wG7OMIjbUFu6i0ASV/j/LOwMs5mD7yEeTCyYlelLFtQ6qX2qCVgAfd5ufimw/9R6JD
         v5bQjnSq7apNvrN9QBW1Kjavjfne/8JBRLDXN1g07/RkZ/Z94/ocuHRgcfijWr+ifj
         MUnwmdzL7kvbrGO6C9TtKwQiCfIh8U5vaqgiNG8WTqEqYIJOHez1fwEb9gqZJYRCDj
         QIcxH/4dB9eKrOi6D3b3iU6uQYmeZT3Y7kMupEt0kCAzmdiyslpWqSYjPV2gYBRs+V
         V2n/4U+ITS7QA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/02/2021 17:15, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> If for example this command:
> 
> ip link set swp0 type bridge_slave flood off mcast_flood off learning off
> 
> succeeded at configuring BR_FLOOD and BR_MCAST_FLOOD but not at
> BR_LEARNING, there would be no attempt to revert the partial state in
> any way. Arguably, if the user changes more than one flag through the
> same netlink command, this one _should_ be all or nothing, which means
> it should be passed through switchdev as all or nothing.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> Changes in v5:
> None.
> 
> Changes in v4:
> Leave br->lock alone completely.
> 
> Changes in v3:
> Don't attempt to drop br->lock around br_switchdev_set_port_flag now,
> move that part to a later patch.
> 
> Changes in v2:
> Patch is new.
> 
> Changes in v2:
> Patch is new.
> 
>  net/bridge/br_netlink.c   | 109 ++++++++++++--------------------------
>  net/bridge/br_switchdev.c |   6 ++-
>  2 files changed, 39 insertions(+), 76 deletions(-)
> 

LGTM, thanks!
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>


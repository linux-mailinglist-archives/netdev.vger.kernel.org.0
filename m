Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6457B64A7DE
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 20:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232938AbiLLTEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 14:04:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233271AbiLLTDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 14:03:40 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2131.outbound.protection.outlook.com [40.107.94.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E72D13F7D;
        Mon, 12 Dec 2022 11:03:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VCIJJOzZgTI6se0rUenmKuEJyxpp4RMTfMkMaPAglsM22BOjlRgOl11TCTRIGzeTlJ9vPmbfsu4xDHoK/jpNBgD0iOJShB/j13aW0wm52FjRGA3lBpUX6m2+XCPPaqNXgZUgsuIv1+kHoQ33g0Hme+t0f3WtUIyt3VrEiW7w4OErmHhsixTsJ/QYwDqzfCJwbsu6qTZVDIvwLFue8oO8ex/wrnJ15khu3xnFbjT8iQe5p8xsVdwgEZmvrpn51R2L+Rk3mfKytAWE/SvOlVDWwWIOYYkEWV97EI/tt9hQ4sH8XMMOa1fhasXHMbZaBmJSOIdqb4n5PmQPoEQHQp4vjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xmjJDiYArf/X/0pc3R36M4T7Q8PKtSoHxEoDFCztk94=;
 b=PL+/AXNNa50YW0O1++I9NYyNrJZFANipGo7IeKKWfi6HxSuI436fKfRGrjIB8RRqemHndvqNfit53MN0sS1guEi4biVIsz+7PIbbX3gUChRASV+oOmjnqQGPxPrct9rcxeLvC9hN19HGJAqC2f8mwoAznNnItCCw8cjnji+awD9pzT9y5VB1I1XKbsog26ooRENMGLo4PWw54Wv7004dFQxYZd37RbSp+lHrl3XoqVPXqAS7e4RIiNgZl5mC2qqwNnUSh7wmUL9LUXKB/RetrP+2lrbzpZNqJUNP646YTDlZsjYGMfCxPBbTotstU5gLKTqWqc0JIEx0C1GshRT2mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xmjJDiYArf/X/0pc3R36M4T7Q8PKtSoHxEoDFCztk94=;
 b=wGcELf4+JMnGRhGAsJl5v0/yCDFucldIW3xLzFKbvJz/VadPVzUeY/JfaFazMaxdfx873+YDozFDuVpjL7h6qrRPDD7P3fFQvV3phZ3F1MXyoF8KdUMAghr42zKJiOYPPINcrRA2VRPN3WILCIWScpfwVft3/0uK6ywaz/6QAks=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by IA0PR10MB6746.namprd10.prod.outlook.com
 (2603:10b6:208:43e::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 19:03:15 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 19:03:15 +0000
Date:   Mon, 12 Dec 2022 11:03:09 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-renesas-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek Vasut <marex@denx.de>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>
Subject: Re: [PATCH v5 net-next 00/10] dt-binding preparation for ocelot
 switches
Message-ID: <Y5d67SPMc/YCr0Rq@COLIN-DESKTOP1.localdomain>
References: <20221210033033.662553-1-colin.foster@in-advantage.com>
 <20221212102958.0948b360@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221212102958.0948b360@kernel.org>
X-ClientProxiedBy: SJ0PR05CA0001.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::6) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|IA0PR10MB6746:EE_
X-MS-Office365-Filtering-Correlation-Id: cb8050f0-071f-4e73-e0c8-08dadc738613
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eFOlNLbudeJmFiy5QmIgPQAaXprjmfzfJEoeNGFVNDIAssaMgk8KvI0/v47CmiDnzaKG0yf72g+ZR/xkw8+xceDCd21FxUJHeTwzuHLDGZ75f3xEqwDUs2WfebZZo8yFlQ2vOZXV90vmRALnYFucxCaXR6xY0JARVjkHNyJsD7ZLsoP5F5POTojw2I9OwtjiM97zrDuhYrqaUS476d3QcyAMDlbKZimEqg2Sm3/I2vV0UEO/wqE+yD2g4HsqLUMPEpGo04tcYIzLuk47e1s/4z+gpsYqXjh0IF74wgLf33ZjhrFlj+hMhO1Cw4x8h/4q6Goi6hPEJ1pfgaWu0pfAxGplN2jY9sBwAXzlDoj6nslcSrHnHjQ+a+hRBnyKqqZQiE8sOLngA/I+qinvLgZ7EALm5yYLjqExZMuqAPG5k8LbnfluM5Sdp6fPitk1B1cXfbTnNYVAWPMwBcPR5Ib8/ljGkfClvn+mJLDktcPF1ltnoZLihMKaz3ZBt/gnFfxn7nMdYsvUbSvHi96uk2JnMFn/GWm4amlSpPe4ghrTLt2YOZ+KCZh8NUsE5y97E7uan9hKy6ACTX7bQxsva85j3K/vG+pe2ewBPu09HvbSxfQ5qRGVtksdOOg+IxeHUzo5FE7ijLsWL+1RdoTaZZZT7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39830400003)(396003)(366004)(376002)(136003)(346002)(451199015)(66946007)(41300700001)(8936002)(38100700002)(8676002)(4326008)(66476007)(5660300002)(66556008)(7406005)(44832011)(7416002)(83380400001)(478600001)(6506007)(6486002)(6666004)(316002)(6916009)(54906003)(2906002)(9686003)(26005)(6512007)(66899015)(86362001)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b0JXdzBTQlBVY1JnT2xEN1ZnYkdoMHFoL21hOHJIcy9RMGx2T0pmTVBndmF3?=
 =?utf-8?B?MTFYRzhJTmxvTndhRzNhRlBZRVNKSE5Idm1TY09MRldWbVBSNnRqSy9YTng3?=
 =?utf-8?B?UkE3N0FRaTgzaTBucTBPUG9LSUhuWkphWXNPYjRkbVY5aEl3Nm9wVy9wb0Vv?=
 =?utf-8?B?RU9PR21OMzZHL3EyTHRwcTM0VFIzeU1MaXl1MjRqSFU4UzFhWlJPNU9zSVl6?=
 =?utf-8?B?UW1TQ2JQbU5ySFBwMTlFZ1czUWhlYkl6UnBES2pJL2NqcHhMTVdSb2xzcTZv?=
 =?utf-8?B?N09kcTNEcGVkV1F5dk9LaEh6N1BTTHl1YVRNYzJnbWllSFdJeHhjUjBQYldn?=
 =?utf-8?B?UTJ0SUhSa3REVWJWb2sxZUg0VkJ3ZnY5YnJTaHplQUdpZWRmbEVkZWo1d0pF?=
 =?utf-8?B?a2NtZ2tDalRhWGVFcUdkQTgxTHBxLy81MGIySDRRRHlMejZidDhkNlRKMEIv?=
 =?utf-8?B?bDVEMWdqa2dBREI3SXlzNlc0NG9tWEltQnQ1N2pYWHZNdTB4aHo1dVFGYnlD?=
 =?utf-8?B?cGw4aTdYQ1pkcGhBaHZpT1ZRZ1IxK1JHMEdrTFBQUmVEN01TelBBamVPMFNU?=
 =?utf-8?B?Yms4LzNYUkZtcW1Cb2dJSHVTWXFXa09nWVJPUDJrWG1ndmJRVlVKa0RBSm5Q?=
 =?utf-8?B?c21GQjVTZlc3c3UzV2lvRjg1VjBtakMwNUk2c3o5SWV5UzVjdUFhYkhSRGQ5?=
 =?utf-8?B?c3FyZmNoVGtHMDM5RE5KOTRKQWlVd1JSOXF2SExyT0t2TFpXOGlRbTFJcElC?=
 =?utf-8?B?SHUyZXBoNGs5OEhvc2NreHc1Y3dHZHUvMHMyU2UranFqTENqU1pnc3U5dEVx?=
 =?utf-8?B?eGpqSzduODFpbjlnMmJDbzhIcytJUkdsdlNiUlkwYk5jRFA5OW45N2tmY3hN?=
 =?utf-8?B?UFNvL2VCbE16a0JPVzhHSVQ3WThSS0xKZ0RIM1VaNzVVUzRhK1NiTHYwQnB0?=
 =?utf-8?B?RTlRaktJK2dLd29XMHVEOGhrNmVtcXg4RTVhMUsyQ3pIaHllVXVQbXJCMEZI?=
 =?utf-8?B?d3hWaGlDRnVhWHA5TFlPM0podUE4c01xYys0eEsxRVloRk5LWFN5U2FuSmUy?=
 =?utf-8?B?bTdQSUdpZUV0aWZNV0NFMGUyaGJJOHFjSisxQmxsL21VNFJQL0cyUmZmbXFr?=
 =?utf-8?B?dUJtV2gxam1vYVp5VVlJdlgrQWZROWNheEV6TTlWaU11RUpUNHA1bVM1UkZm?=
 =?utf-8?B?RDRKYTRYZzFNZ1ZEc3VvYUkxb01iUjd1N1FndjRaMXhRcldUQU41V0dVQ3F6?=
 =?utf-8?B?d0k0UWNETkh5SnZrbSs2VjZNeGpuY3NnbUE5RThGclNHNVNkc0hZUEhHWUw0?=
 =?utf-8?B?UDR3OXhGa1QyL3JuN25ialVIU3F6RkJmc2NMSktyVGlleXZCSFBvY2tKSFQr?=
 =?utf-8?B?NU5KR1IyeWxnZEtWVjVVNUdubjZKa2dyemV0aHdDcDcyYkZHNkZpbEVCY012?=
 =?utf-8?B?dTlQMkJDVjlMcXY5MVBmQytvUXQ5N3VJSDRmWW1lV21vRUQ0SmNjSjV5VlR1?=
 =?utf-8?B?dWtCSVp4Wi8wcXRiNlRCZCtnVGIxTkZzcmlLZWp1R21CVjBYYnNJTkJ6ZzRD?=
 =?utf-8?B?c3VhU01XVTRKRG1JbE5rSXp3Mk15U0xZdHdoYVpXTXFKcTdpSC9paE5ETXpw?=
 =?utf-8?B?N0toZXdVcVVnRE1Jc3h0SDV4NmYzUjYvNU1xQlFrU1pPMlU4WGszbmVBVlI0?=
 =?utf-8?B?OWFiU0xPWWZGMDZqUlYvNGo2LzJwVjhuZFl0MlZGQVFZWmZjV1IzOURhc0hl?=
 =?utf-8?B?eVU5UzlEdXBySU8zUzFZNlhONlk4dDE3M1NxSmYzU3VjUTZXanNMMmsyQ29Q?=
 =?utf-8?B?eVdBUnBMNHFyU29uUHJmUjVRWGs0T2kzOVcwMVN5RzliQUMreUh6SWRyOWRR?=
 =?utf-8?B?RkFnZXVlREEyNkU5eEgvYVpybFdKOWR1dkFJUDBZT29XOVFOYnZLbWJaZFFH?=
 =?utf-8?B?MmdmVkl1RmQvYkdHS2s2SzByZXM3b2VBY294b3dwdm5ML1diSk43T3NVV2dq?=
 =?utf-8?B?d0s4MHVaOUdEdXpwcFBtR2hYZDdsMzdEb3liMDBUVCtJWDFvdGNLeFhCcVBk?=
 =?utf-8?B?dlJ0ckd2L3Zvald1U2tjQnRsUVdZMGErTW9rWUViYUl2bDFrSWtKNTBXcmJR?=
 =?utf-8?B?SFltNVJHeFp0THdzbVNNS1JiZnEwbUFXcVB0eHNhTzl5RU0xZWlZRXZ6SXkr?=
 =?utf-8?Q?iPJLpArBOTzjxs5pEWgnA9k=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb8050f0-071f-4e73-e0c8-08dadc738613
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 19:03:15.7801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pEKAAegcuM+ksZkIJqqUbO5tL5CD126av13MU149HPHGFKw57VnoywiM2pnUgmqGSptFQ3/z5z4XcomqlJmv2wXPvMqEJAZEWamzfm3BkWA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6746
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 12, 2022 at 10:29:58AM -0800, Jakub Kicinski wrote:
> On Fri,  9 Dec 2022 19:30:23 -0800 Colin Foster wrote:
> > Ocelot switches have the abilitiy to be used internally via
> > memory-mapped IO or externally via SPI or PCIe. This brings up issues
> > for documentation, where the same chip might be accessed internally in a
> > switchdev manner, or externally in a DSA configuration. This patch set
> > is perparation to bring DSA functionality to the VSC7512, utilizing as
> > much as possible with an almost identical VSC7514 chip.
> > 
> > This patch set changed quite a bit from v2, so I'll omit the background
> > of how those sets came to be. Rob offered a lot of very useful guidance.
> > My thanks.
> > 
> > At the end of the day, with this patch set, there should be a framework
> > to document Ocelot switches (and any switch) in scenarios where they can
> > be controlled internally (ethernet-switch) or externally (dsa-switch).
> 
> A lot of carried over review tags here, so please let me know if
> there's anything that needs to be reviewed here, otherwise I'd like 
> to merge the series for 6.2 by the end of the day.

I just responded to patch 4, which has a small (?) outstanding issue /
discussion. I asked Rob and Arınç's opinions as to whether it should
hold up this series. Everything else is good to go, as far as I
understand.

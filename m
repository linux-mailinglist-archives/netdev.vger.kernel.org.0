Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63197614354
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 03:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbiKACkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 22:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiKACkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 22:40:19 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2124.outbound.protection.outlook.com [40.107.243.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199011788B;
        Mon, 31 Oct 2022 19:40:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=le4obEnp6HSwfCZ5eOBDApEtAUxY5LC508AULnSvmmsZJGTs9Y8mF3DSx8MpEv7ZpoFOxL2wMFNU2HoPyu9Y5J4qzWPSIVu4ocQdhvaEKiJFPeJjvchg/Si3ZO0DwOBMyTWLJ57nos1XiLl+tNyhwFeJh79TaGzBm2tSshmqftD/xS5/Ho2k6g11mvSPk2NZRWffmVSvn2D574iFuLqaDJy1zUNGqHBCIWGUNzOesfnh/rn+ly85bWp0bnhGN0tXeGPpRGc63A3vR7Q1BCNRuwaUuB6c6umYUNDBMJrYaQ2tJJaHVNaGRF7VmJE4kt+sfzxASq9HNPwn55/1Rs2DWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FMMn0g6hS4HKLJZ8rlNNix3HqvhC93TaDZXnmOBXoww=;
 b=GkgWaw2lXhEdVYKHBj6FCg7I9QnX3Qn1cto8yTsslquHQnSX1qgTReAAjleUhQig/7X+UbNqJYP1dTwKL8bN0P+GtgsbKbziJ6v5CSwQZH0Yd46D7GmhCJbI/Geqe/WKpdCLgtBRh8dsnCADsvR5EVZjn263380NxQ4zqb/4XFR58QpCRjw9nE5Ym3xWxJWsjgzwZJRAn0J1yot9NNEB8iymyl3ixbaLc3BYyyrcffL0jWaxKqCbO86CLj8j5vSrqXPawuNqdJz8l+xkEQJmhB3eEX8nwglANOmNj8+tuSeEbB7XyNcT048mmb6PK9j5wsxKdHZC9SXFi5JkqQ6ZRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FMMn0g6hS4HKLJZ8rlNNix3HqvhC93TaDZXnmOBXoww=;
 b=p4u8/R95moObehYV4NQwGkFn1kZf3N1fOqKWTbayEndkIg4z5vJckQ1H0aQ705iQ0l6jFs15KnoB96KT7VuFyyO9pwwa7d0Y9hwOvQ6bYbWvVV/a9lvhf6GvBQR2htHuyeBSebGvFfy840JZQz5lnoF20FGyhEB6eE4HE/js55U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH0PR10MB4857.namprd10.prod.outlook.com
 (2603:10b6:610:c2::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Tue, 1 Nov
 2022 02:40:16 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::a8ed:4de9:679e:9d36]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::a8ed:4de9:679e:9d36%4]) with mapi id 15.20.5769.016; Tue, 1 Nov 2022
 02:40:16 +0000
Date:   Mon, 31 Oct 2022 19:40:10 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
Subject: Re: [PATCH v1 net-next 4/7] dt-bindings: net: dsa: mediatek,mt7530:
 remove unnecessary dsa-port reference
Message-ID: <Y2CHCsLrRpFThozX@COLIN-DESKTOP1.localdomain>
References: <20221025050355.3979380-1-colin.foster@in-advantage.com>
 <20221025050355.3979380-5-colin.foster@in-advantage.com>
 <a75564ec-3a9a-1bd6-3f4f-aae28ac933ad@arinc9.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a75564ec-3a9a-1bd6-3f4f-aae28ac933ad@arinc9.com>
X-ClientProxiedBy: SJ0PR13CA0025.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::30) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|CH0PR10MB4857:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cbec6e7-e9ce-445e-5834-08dabbb268a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UbMIBX0ZWZxnZ4ypQMXi/9sLVFxZwjSIFpakFUTAiobtBdh0YM0Mxu5V73G/0Mva2iBkB9De/GafKzkLHgTe5UnnE/dfYsp57ZZ4J9cUcQutrOWnQwUCmXM9kuKJMkfTEKs2fxWVvIVki2irVBq/6Lecg9jtdGIqXuo1b53rQo09MCOFKqvQokN/+ULNHT0zpvBALtcxI/OaYLaVw8bBvWrei2vRY6VOkO/5YtNxzhawrnbVYTVcMbIvkPFkXlhl+fPcFJlaPV1tu8p+nuyPwOKt2f0s7gKdSk0hQdXgNI2c6u9rw+H2IbCxQLJGvhihihkq2HKLvRasR0yHrB/eNJOCRK8Doa60wk4pZ/Tjlsk03qa4kR4E9rE1w1VBX6SB6nWAU8Winlj/Au9ilda556lwR4lgOEAkIQqge3pTniiEsI1TimWM57H+uMsRGyZL7sNETG7mu0bbe20N57QG75wSvy2nW23CWXiKHLP8XfIKBhQJMcHHQMBNAqwADbifzQcPyXLYdS6yBKobBsGM6ShU3Wo+9bLTIBJIMbTK1PfVEV3fiEFmJDY9Wlm5VugNTWXc2mpGXoUdy1DVQb2Z0JBNjJbhjQEEwBbf0TJfCWufFlh7Mrl33ZAYfpbdNXP2U8gcLehv7Y7kXIpNCuVEwRMrkttM2TFxcHQ0+xJYj7JGHiJQtFInl1XYokH7onciQ2A9JmMLsfnQbCxNu1bQng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(396003)(346002)(39840400004)(366004)(451199015)(6666004)(9686003)(26005)(6512007)(6506007)(53546011)(7416002)(316002)(38100700002)(8936002)(41300700001)(4326008)(8676002)(478600001)(86362001)(186003)(6486002)(4744005)(5660300002)(2906002)(66556008)(66476007)(44832011)(6916009)(54906003)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bUtYOE4zWkVmbTNkWksxMkdnQjd5NmMvVmVnR0NvMEZtQTJ0aGRrL2xKR3dR?=
 =?utf-8?B?U21rRk84MWxLMzh0TWRnc2ozUzJJRkRHSFRXbjRnZjlSUW45bVhjWVRnVmhl?=
 =?utf-8?B?SWZZRk5tK0ptQ1Q1ekQzMTlYZmFkc2NscFovRUx4NnZMdmVjUzJYVzhQNnhT?=
 =?utf-8?B?b1FEcGovY3YwTjk2MVlySVVuNVVyZGFPUUNReGVRZi9RT0NRczJQZC9WSDFI?=
 =?utf-8?B?ZWVJVmhYV1Z6MlYvVXVNR3BxZGpqa3ZPYWhMN3lra1gxTVVza3huQVVPWjhm?=
 =?utf-8?B?VFcxTUk3dzdxU3BEZ25Gdy9VQTRoLzE3U1c1My83UURSVTR3NnZlTkxaNnRD?=
 =?utf-8?B?M3VpSzFuanlyUndINCtkckYxVERXb1YzL05RV29jK05xYjlqZnp6MW9JdkYr?=
 =?utf-8?B?TXhUcjFScHpiZkJxbk5SQlpDL0NTS0F1ZGpHbXVpcjc2R1RWaEdhQ1hpREFo?=
 =?utf-8?B?dGVhRnNSV2VIQ2xTQWt4aEplanhoQUgvNkJWR0FybE1pb205bDFDaVUyaDV0?=
 =?utf-8?B?dlNETGhLOCtUdEhWcTAvbzVFQ2w2RmNmMGViVHNMRXE3aS9CNUZUd1cyRGpi?=
 =?utf-8?B?Q0ExYURFanAvN0FvMkx6MDBxOEtGbW5FNW8vdThUNWkybEZwRWhZc2lOZFFV?=
 =?utf-8?B?MlhDUW9hbTg2NDJpSHJRdzVNSEZKZHF5VDZyZUgrZEdaTUJ6cmZtSzh6MW56?=
 =?utf-8?B?K0VqQXRlV3BCZ09ML2NCSmtSbHBjeGh5am8xK2Z1bnVkUk9NZHRmRXFDa2xn?=
 =?utf-8?B?QVZLUjJ5eGtKOWRpWHZ1UkpxcDZadDA3ZnhlU2c2NWQwVUtodlpEZzlNL1VZ?=
 =?utf-8?B?S2JSSFRpMWlYaXZwalBwMTY3VncrNVhUdElUWWFoeG1HR1AyOHMra2U0SzR2?=
 =?utf-8?B?NWw4aHdzL3BmQ2dGT2hRWGxkR3RCZExuc1hGTWNmK2pObG5PcldLT1JMRGRp?=
 =?utf-8?B?NVF1cmZGNjk2ZXBCNGY2VTBjbUNMTnJyek9mUmN4S05uOHVyK25yODgyS3NN?=
 =?utf-8?B?MzIvbzBVeWt6aXlCRzladWdyTCt2RmdrYmlBQ2cvU1dVMkJFK1RtNFN3TCta?=
 =?utf-8?B?elFjNnJjZjlEMWZyRVhESEx0ajluc1FtZ3FEV1VNdDEzbjhHOXg0RFMxSWpp?=
 =?utf-8?B?WVpuTHMzVXZMOGZWajhTOXdFM3djQVJNMTVlYXlwSGorQzBZOFJDQi9oUHp3?=
 =?utf-8?B?L1RMaFJmRnRTMXBXTXZxT01FcFVmVDFFOVpic1Y1RjlYL3N0OVNTL1FYYUxU?=
 =?utf-8?B?YWlVWXRLOE9JdUNBOGZJTURaOTdoVWgvc3o3ZlNiLzB0WXRUVm5NZ05KeVYv?=
 =?utf-8?B?Yk9zeTFQR0hsY0RycG5KVjhnU3gwek92ak9pOWR3Z0d2QXdBSEdnNFgyUFQr?=
 =?utf-8?B?Q2wyb045Sk1DaHpPWURDL2NndHQzdSsrOHozdHlTbTl0QnZ6ZGlxSUVyQ2pi?=
 =?utf-8?B?TkJRMnR0SmFReFZ0MHBWWnRZV1N6bjBUN1VrRUZUQzlRUHdUSjJkeEo2RTZn?=
 =?utf-8?B?THFIQlhldGt3YnZnTXVJT2Y5SzkvcFI2bWZBY2FuemV5ZmFsY3NydERHZDVF?=
 =?utf-8?B?RSsrMG5oWkttYk1vUVhOUU12SS8vM1VVZnZtd2tMajlTQ2taVnRGZGNlU3Jr?=
 =?utf-8?B?cU05bHlnQUJPTEFNMnk3MmhUMTREa24vSTZZOTd3NTRQVzJkWTdJWXhlWmEz?=
 =?utf-8?B?VkVOWUxoejBOeWhIUjZ5bUdXb2w2SzVZU1o4UTJGbDRMVlIvUVduM0p2UEJx?=
 =?utf-8?B?MTNjZXJuMHhpOHloSTRGemYxR1lBRHY0NDR1aS9jdTdDczByUGpzRjZnQnlY?=
 =?utf-8?B?LzNlN0dPWGFqYUFtczE1ZEZtSTgyYmFFcWZGbFNEeW9sTGZERVVrNzlBaUY1?=
 =?utf-8?B?OTNNQ1J5VGZaUnQxcHJJSFo4UlZDVWtzR3JFb3dHTnYzUmM2em13M05JZHZw?=
 =?utf-8?B?Zi9GR1ZiTHpsdUVabjBPclFEMlc0RGdKWGVBOWNuRmpjZDBONHluMDc5N252?=
 =?utf-8?B?Zk53ektRaWxFUUtMVkhQQU0za29ycnZDUE5PQjhPek1wNmhyRUtJa3NlYjFv?=
 =?utf-8?B?aGJENCtNaEVWNDhVcmR6eGdtZG9pVU5jSlpGMTV2cWo4aFJ5Skc4UlBBbnRW?=
 =?utf-8?B?dGlVdThlSmdqTE9rVzhzZXZ2R0lhRjBHS1hoWWpYZTJKTmR0WWVzaVdkY2lt?=
 =?utf-8?B?amc9PQ==?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cbec6e7-e9ce-445e-5834-08dabbb268a7
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2022 02:40:16.2123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sbcbQWe3KeGKH6gC/WNi6v7BWlJHjL9INhdjOpJN3r7oYiqqwHsKT+IafMOGMef5+mxHUjnHPmJJJFkLMnXhXyG1Fh8Q0UcgbBDk6ZBhprg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4857
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 30, 2022 at 08:42:32PM +0300, Arınç ÜNAL wrote:
> On 25.10.2022 08:03, Colin Foster wrote:
> > dsa.yaml contains a reference to dsa-port.yaml, so a duplicate reference to
> > the binding isn't necessary. Remove this unnecessary reference.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> 
> Reviewed-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Thanks!

> 
> Thanks.
> Arınç

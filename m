Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8A686AE50E
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 16:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbjCGPkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 10:40:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231501AbjCGPkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 10:40:08 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2122.outbound.protection.outlook.com [40.107.93.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA80925E23;
        Tue,  7 Mar 2023 07:39:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bdEl8onomhDtJVr0IWfcrW1H8bkAmAErvG7WEUEGQWxIu6jwqUud5Q5/sxumHo2M1s/JUVbQwC7kVy8FsmujHEoHguOhq8W3PxUuw5BZ6zoalOCbIlwgpSaxehbhUUb4vlZTEH8V278SUNe5i2c+nJCGfqI8siXRfbD+FSom9lSz4hW8iI96WWyUPHGqYd4l5j/M7crEVljHkxTSyDnP8gUUcFii18lDlch1zVtJAWgVS5FjHh7qCgfNzIf6ba6+pgC40+BzDKEre7PqBGFJDq1eav3UTO/9+iVSIFwerfBPrtVzcoT4D75RX2ANBVDz11mZZLyFA4aECWf/Ux0PDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PaFnE6fNHRu6Ob11T0/JZiaBAwRe5hfPBtthp/nQvU4=;
 b=H67HHJz8BGerEsUiXhaG+wxCsPY+HGZjKgxoDkQZQAsWnhVXH+O0oA+MokYXtcb8ogYrdbcrTji90Ffhe6/h1gb/DBatvz59Ej7JE197p2y/YLZnIue2DD8491nVU6xhXbkzGopkyLloQYht71TSYwrcoISrBVYROXNQrMuApBTb+xsPx/GFy2ikWTIEgSUNbkXKF2DHXwl+4Pu052ybVAPe1aTgXeyJXRQsrX2k0gym9tYlZzwUEkWasxt0fnl7XGYt4MJwraUlCt652lMqYf2010QhUF86qosdn51Z+ug3VulAR4nrJf9GZ7g5SJJ0iaFC6LZpErfENVP2wmn7Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PaFnE6fNHRu6Ob11T0/JZiaBAwRe5hfPBtthp/nQvU4=;
 b=sc6QV7qnSHaQ8FdZNmP25qU8d/YDj/ePMXZj1X28i+cId3tySuB/aqF9jXHhRM4tK4S5WKpOvtU4eMjFvr9phrPtebZ0G4stpRImOYFVOIqOilaj3nOnfwfcrQEgqejRLrQb7Elt+a4Z4PrQlSSahbNTOBscIcOV8/3H67WQgNI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5035.namprd13.prod.outlook.com (2603:10b6:510:75::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 15:39:22 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6156.029; Tue, 7 Mar 2023
 15:39:22 +0000
Date:   Tue, 7 Mar 2023 16:39:15 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Manish Chopra <manishc@marvell.com>,
        Rahul Verma <rahulv@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, GR-Linux-NIC-Dev@marvell.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] netxen_nic: Replace fake flex-array with
 flexible-array member
Message-ID: <ZAdao7B1yeXy0OWH@corigine.com>
References: <ZAZ57I6WdQEwWh7v@work>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZAZ57I6WdQEwWh7v@work>
X-ClientProxiedBy: AM0PR02CA0226.eurprd02.prod.outlook.com
 (2603:10a6:20b:28f::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5035:EE_
X-MS-Office365-Filtering-Correlation-Id: 4eab3f16-6c8e-4756-c74f-08db1f221f7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JZ1XQ7R5ZD9nTp5UZ3LeJlFAVTzVNfdYU7rFiM+iILOsanxYcARemQktqKFW21Z/oNvj4OI0RAcehMvdl0nchVtnXD08K9xss646JAotwT2a3vKFMzsvXbHamk64vL3JMmmWrbZFrAMicqpUrXrhurVdI44qYbdWucHKp+t+zTqPbKcrINLbajkgYw/G2Gexlv1G2MspnE3EeeRpvzpebC5x+4canifVNpyZDOiiWNCVdoX9SRaF5oSAeaiqRQx9xyp5X3CfeJufHhfH4sdszNXYhc762fdbopdJa72RI9fGaOJrtXoWbJCEwGhr/uMS2EZFPD5jghp9QrHCSIlq4w4Zkyt3Qt/NqHBUBL/Zhn8qMqo/sAnIlDA9t5LsYHnMTx8W9X3/VwfQ1ymmwtzXcC1KNgBsl0ylpmhYXc0f98VmWYlBvjZClznzJcGPFI46D14z/EFCOuB6YgNyjUtvCK06BsZzldATziT2o8WSUgg3LaIIkIk2an61qu7j17ZnUw9ZFjCVhi5A1S5/1CbjP+3fVnbOGVEYr3IiysiswX5D33zA3WQFX+igwoThNw70qVfZpclI6lbV0yRiorxiLQkhicm/u0fPl6THuRPbp3UlUM12TCZ2zjn+3Ql9IY9Y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(136003)(376002)(366004)(396003)(346002)(451199018)(38100700002)(86362001)(5660300002)(6666004)(36756003)(7416002)(44832011)(2906002)(4326008)(6916009)(66476007)(8676002)(8936002)(66946007)(66556008)(41300700001)(2616005)(186003)(83380400001)(316002)(6512007)(54906003)(6506007)(966005)(478600001)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MVV5Z2VxNDN5cG40Uy96U1hXbUdBdW9HQWhGWkp2b2l4ejM1NXlHVUNONHJk?=
 =?utf-8?B?SUFvNHMwQ2lHV1ZWR01yWWcyQjV3WXlPb3RBWUs1cGxkWTJHekZNSW9tOHIv?=
 =?utf-8?B?K0pTQ0NDeTFlMFVCclNnNFVrNFM3cTcrWW5zOXVqSnJnTytVeUJKQVFZbzJD?=
 =?utf-8?B?S0Zia3NPdng0NHNJY3hQZFFOWmdnRkxWNkRGVUI0RStUTTVZT04rTHlDZmYy?=
 =?utf-8?B?WVNLSFhLWjk1aTZDM1UvRkFUWkVlODVvdndtMUpGMHQyY3NwK3lCaGlHME1V?=
 =?utf-8?B?WGlmRERzVG5qYy8rZGo2YU1la24ybEQ0RFFGWDdHdS9PTUJuQ215WjN2dHlw?=
 =?utf-8?B?Sml6ek5EK3U1QUFDWi9uM1ZRaENEOW9iM0NXZUQrZktHS0tYWUlwbDVmK0Y2?=
 =?utf-8?B?WExqRWlucDJGQTNtNFNnVERka0tKOG52WGQwVkNyc2ovR2dtVEFJQ0FrcHlW?=
 =?utf-8?B?QWxkS3hsbXRFRlRVaGxlYUdFT1J2WDdjSHQ2VmdqQ080UjEzOVM1YlRUWlRs?=
 =?utf-8?B?bjNCYktiY2ZSYlpKWXdXK3p6RTUyVnM2dmxURnpTQUxSTExBYUZUdlpwL0w4?=
 =?utf-8?B?eW9lSkJGSGU2OEIzUnRtY01oUlRXVkozL1VkMWJMZ1NsakFram01aGRQaEVI?=
 =?utf-8?B?bnpPWVI1akFGaTZZUzNENVlldmtvbDhOU29tTGxQbnVSNjNsRVkwYnhoUGgr?=
 =?utf-8?B?eVd0OHBNUE9xWkVxTTMvb1dzWFhRMjF4RG5MYUc0WmhxRkwreFdJa0ZCVlJP?=
 =?utf-8?B?SFBKOWw5Ny9WSDhlSXFJbHdhajYvL3Q5Vm5Qa3FyT1dQTTFqQ1ZxUC9EWkha?=
 =?utf-8?B?U0xYNE5NNlYvdTByYlBYdEtENlArQTlDdVhBRll6MEhyMnpCTVV0VlUyN2wy?=
 =?utf-8?B?N0tQb2hjM2dxOCtaNnNNMXBrVTZURjI0NktEd2ppelFETldud1I4V3pyelg1?=
 =?utf-8?B?YXJoa1k0NVRpMHRBOGN2YzMvdWo0K1p6blY2ZHhOM3RtamI4dVQzUXNuRFhl?=
 =?utf-8?B?VnE4TlNrVlluMUZTUkRmQWpzclNCZmhQdlozRDdPS3Jaakptb2NXVEJWZ2p0?=
 =?utf-8?B?OURKcjhwZ0QrNWhhQ2duNUtOL2FGUTFQNlNSWjlCZ0lTQUxBNFNIQ2NFSE9L?=
 =?utf-8?B?RWJqQ1FUS1EzNE1EMFNpRGNIRm1NcWVQWFNjZHlwbkZnZUltdWIyVmIyTFF1?=
 =?utf-8?B?Qnh0dGM3U0N0ZEtGQWZwb0M5RXF0MEh1OVpPc0xZOU5ESUNVYzIxMW5Sekc5?=
 =?utf-8?B?VzlFRXdwdE1pMm9JY1FCMzdTaXNQZjl4WWZwU3BHcHo0Qkd0bDMxTUNRc3VS?=
 =?utf-8?B?ZUZnSjVqak9pcmhXdUpjMFR4ekZqdEI0UlNvYmJDSzVBd3R3UnNORzVnNGIw?=
 =?utf-8?B?dmhDOEttWWR3VGNQNGROQXJIU29qZFhWVC9mYW1RVUdiOUw4LzdOQVk2dElG?=
 =?utf-8?B?bkJkbjM2bkhWSElPQm1PK3hjYUMrN3JEZVArRTlja3hSNWlxajNZRDNlY0ti?=
 =?utf-8?B?b2s2KytsRW9sRnMyNjREdHhFM3dWYW1aUDQvbysyUFZ5VlVpRTFINEtvMlBO?=
 =?utf-8?B?VnJoWVpJMzV3RWMzN2FVbmJCci8yc2FLTDZTWkpiMUNKVCtyZVFnYU9VdWNW?=
 =?utf-8?B?YktZS1VRakpNRUc4dGxiR2FtVHZreUtKK09Uakp6YTRQZURHNHRiVmhsVlhQ?=
 =?utf-8?B?LzVKSjE1TkZLbFdpbVpqTTRzVnlJR3pkcTF5dGVKRlZhYWV3ZHFydUY4eUNK?=
 =?utf-8?B?d2gxU3BBZk1BK1ZlV3F5NXBqaFZPZHRsWlg4eWFhZ1Z2ZzMwR0dna0wwTEUv?=
 =?utf-8?B?eEI5Sm5UcXlKTG50RUhCSC9tdFN4Q0hhTHZJenVSQzRWc0NRV1grTXZHbUQy?=
 =?utf-8?B?TWViN09oT1RzTVJnbjZ0bm13MU45amU5Q1BvK3BvNFJ5QUxiNDVzL3dLUDQz?=
 =?utf-8?B?S0FhcTlxMHB5RWVobHZoVm0rOXM5aCtkTVE3ci9IeGkvTUNLeDF2QVZaS3Fh?=
 =?utf-8?B?cjdSWFVmd1haRFZobzRUWU9YWm5uS1prU202akNYbnhrdVpRbXhoSHVsYWw0?=
 =?utf-8?B?dWplbWdERjdYUDBTUjRTcVBQWXpTMFJBV0xReVA3bUpVVmtxZE82czhiZDBn?=
 =?utf-8?B?ZWhwL3NQekV6aDNyZ05jSmJZWkRlcWtHNS9vb2s5T0xJbjYxR3UrZ2E1M2Zx?=
 =?utf-8?B?UG0wVHBzQ2grSDB5eEtBc2pWQjk4NTBHQkx1Q2hvYWZxb2Y5YlBkTVhEbFYv?=
 =?utf-8?B?cnZvZmVhOVU3Nm1uYms3SGRtMVdRPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4eab3f16-6c8e-4756-c74f-08db1f221f7d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 15:39:22.2305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p1dz9wxcrgLSnedW5iasGclZMU9KFjgvVjweTMEduxHBU3KStH1yjUwP+ecyQQcfOCCE53sqzFLaPWnjBYLlefW6SXE74zVSPO/yTfttANk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5035
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 06, 2023 at 05:40:28PM -0600, Gustavo A. R. Silva wrote:
> Zero-length arrays as fake flexible arrays are deprecated and we are
> moving towards adopting C99 flexible-array members instead.
> 
> Transform zero-length array into flexible-array member in struct
> nx_cardrsp_rx_ctx_t.
> 
> Address the following warnings found with GCC-13 and
> -fstrict-flex-arrays=3 enabled:
> drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c:361:26: warning: array subscript <unknown> is outside array bounds of ‘char[0]’ [-Warray-bounds=]
> drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c:372:25: warning: array subscript <unknown> is outside array bounds of ‘char[0]’ [-Warray-bounds=]
> 
> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
> routines on memcpy() and help us make progress towards globally
> enabling -fstrict-flex-arrays=3 [1].
> 
> Link: https://github.com/KSPP/linux/issues/21
> Link: https://github.com/KSPP/linux/issues/265
> Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBFD068EF08
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 13:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbjBHMhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 07:37:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjBHMhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 07:37:19 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2135.outbound.protection.outlook.com [40.107.220.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B542738002
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 04:37:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nbSAc6gWwsE15Ke+De0ZaBsW3+sksHhTZLj7N4eqpjLCKZKtvGl2GsdAqrgiMxufNSc5aZvmczho44bdYTXwnk5H0hQj6x5EBzOKxq2QC//cZwQKbg6rYx/OpjTARnjT1ByTz5RCx88wp5jGq8PzhfsqJYLPh/l/qxzA96Skdy50/GopBeFV6QGbMxF47uUcc/uqPOx5tMPCpXSAX+MdTACvFV8OqLXYt3uQjGzZcfpldPQc49to9emnZHCY/rU4rTq47coS1huhc7piQZ/JHyDH+kxT8jSUJvJDSui4pLmLAKtUOnFP1G4F1IA3sLPfIU8Z3a8m7YBydwfqpaDr3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wW1vUYD+VTTSN30WjRPqkJ41HsNbK3v6JNuOdIVn5dg=;
 b=BitXxmKdtjeeiXIwk3rLf0zts1HC8liQxqixcy3P1Ph4FBWxTJRBdiUM3U3tCnPE6eZpGIOnLvjT5CdbS3r6tBOoWmwH+xxR7UDz8Ph7rtUyC6tZLzaBVRpUP6CzOeJmRdVX5tvj/BuuHbJp080vIu6VpjFGeS7cSZa4+HwDStvXHR4qjK0NMn9YoveEXVovr/Y8xnJmiDC6hqMJwAHvI3+aYX0yjGHmR0ZmEY3QABB3gi6krZ1+SyFrhLsFajlXyUe3RLfbrGiYzkGFMo9QvsLGSqRQxTO2bnHAYep3/T4YYNXFRsszCG7jAReUQACiEQYxlsbcl9ptSrB0n7ESVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wW1vUYD+VTTSN30WjRPqkJ41HsNbK3v6JNuOdIVn5dg=;
 b=WRiKSFEh4D+My8JXtXRs/0Gg8Qh8a9L1HVWhFpo2D3I2XTto58SIeVjRVJZ5xx5kBVeKRiVI23JovENsbxBJmfrMkJC5g9LFFMzkSrVnPtOj6YtIpccHzByl+EfwJafdHhjmhSFCl/qvh1pKp0EIQx9R3bWeZOyCvPq0pgFCpk8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB4556.namprd13.prod.outlook.com (2603:10b6:610:35::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Wed, 8 Feb
 2023 12:37:14 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Wed, 8 Feb 2023
 12:37:14 +0000
Date:   Wed, 8 Feb 2023 13:37:06 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, Fei Qin <fei.qin@corigine.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: Re: [PATCH/RFC net-next 1/2] devlink: expose port function commands
 to assign VFs to multiple netdevs
Message-ID: <Y+OXcvsylX8AzNg8@corigine.com>
References: <20230206153603.2801791-1-simon.horman@corigine.com>
 <20230206153603.2801791-2-simon.horman@corigine.com>
 <Y+OKPYua5jm7kHz8@nanopsycho>
 <Y+OQmjJFeQeF2kJx@corigine.com>
 <Y+OWy0prxf5pNWpv@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y+OWy0prxf5pNWpv@nanopsycho>
X-ClientProxiedBy: AS4P189CA0024.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5db::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB4556:EE_
X-MS-Office365-Filtering-Correlation-Id: 93c5feac-b249-40d7-7b39-08db09d134b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +2hUhdfpcZwE6HD62lRdxYeVKiiRheD5Pfwkcb/FjhU5KDTA/t4X6bnDwUUOAYMyiwUOZn0FNchgIZ0Dobj8tA25LeUxJ/laHZ5AePVM8D7qi7kYorNpUIcvs169u6k3tZoWHI8+RE2Q1PKq4sKvQiY4ZgAZhE2tf+VHHuLelmhlC2fq9JAXkeTg5FQgId64EeFDuN1AanLvgwj1+JXndvVn54u6ltqVoF0FOFTYcoRh4ffXdiZ8g60lgginkOYpuJ61pV8adXas62MYaKO99IHL3TnARlD6tGI1RiSQuLRtLQP4lGTdEV/gYIpfFVSESRd54Zh3cwoTTVvUMLhD3VDoXCk1+Wiea2yjundvB0vqako4xbY5IpKUkJz1PX+Ca8Bei7/bhDXqJ1/AXP4aat5S8nWb6mERgT4eoF9sqzPSyEH+pTxcq+zr6+5YFMWVyG9e+iby5pgDBqLL1GxbMtPX6ITKKITS2jOXPZds+JhW49w27weTdpsGofm+SupPJIRngVnniW5CzWf12LI2EfuQutxiD/z9i+WyiGkVS2/XVaY20ZIFKpGv55+iJJr0CXDAAbQxxKBw6d71/Y82PUR/TRJ3WjecyDBlRmMOShz1Gh1NTg7CHUkP93AnnZpQP2UWbbx1/+0JfdcKjcLUFdGPIYI/8arqH9b0bY211Kc4u/6xAGQ1VlXewKgt92q0fq07C48cTiUiaBAm2SVGViJ26nkqpCJmBBBfAGyAOeQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(39840400004)(366004)(376002)(346002)(451199018)(2906002)(44832011)(7416002)(36756003)(5660300002)(8936002)(41300700001)(83380400001)(66476007)(6916009)(66556008)(66946007)(2616005)(4326008)(316002)(6512007)(38100700002)(86362001)(186003)(6506007)(54906003)(8676002)(478600001)(6486002)(107886003)(6666004)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VXpScDBOZkFmL21LN0NkYUpkUjU0ZVliY2JDV1oyd1RLSk1reGZ2TFpFbVMr?=
 =?utf-8?B?UGJkNk9wREJuay9BVERONm96M3NpemFLdloxMTQ2MmxSZFhwdUcwVWE2czRY?=
 =?utf-8?B?QWsvQjFqUnE2STBTY1IzYnN3bStUaGJMUm5iSk83M1NkdFVsbTFrMUdob3Zv?=
 =?utf-8?B?cTd2b3VXaTAvWi8zdmVEMzhMZXpwZklPczZvLzRQbGN6Rk9WdEcvVy9Ibmox?=
 =?utf-8?B?NGFIeFp1aDZicjI1V1QyZ1FzN0pzeGh5eXhFY3pxaDI4cGdualRubnhLYjlY?=
 =?utf-8?B?b1c4OW1QTUdJdW1ndGE0MVNqbzdnYWxXaUlCR1I2eUp2NnBDRW1hVjc5dGVN?=
 =?utf-8?B?TTMvOWQ1SDFnRW1DNjZ5a0pTcGpEQUdGK0VKbDBZT0oyUUpIa0tsVVA5L21P?=
 =?utf-8?B?NkNTekwrbUFRMFQvV1BwUXFCNGVJZmVZUlVHZFFwMVNUajZqY0dENmdjME9J?=
 =?utf-8?B?Zkc4b1hqTHdGVXRLSE45SHo0ems5bWF2WDkrVEtWVk9jWjZKS1RsQ0ZTMUpT?=
 =?utf-8?B?b1VRUHFDbWtibFJUaWNlZXNySitPWmx1TW1NUmJOKzBGRE9rYWJKc2dFRVB5?=
 =?utf-8?B?VjczMTNRYkRCWmY5dmQ1NUtVT1RmUkszZHZodEphM3U3RmF4QUt2dS8rYmZ1?=
 =?utf-8?B?ejhpV095RDNFVkxodWpLK0FtajUvVEJ6alFjQ3EyY04wSzdCZWkxYm5jK0Ur?=
 =?utf-8?B?Vis3Ri9VckVxWUpqS2xsRkJKdzNaQklGSDFaK2JKWVdCSXR4MTQzSFNOdUFo?=
 =?utf-8?B?MkdzRXV0SC92allzK1BOT20xZ3hac25iNllmTGxNRmpXTFJoczF6TUZGTXFh?=
 =?utf-8?B?NXJodFZ3ZmJaeE8zMDdBZjZVdmExcjNKdFlkNFlqWDJTUHBnTTNlS2sxSll0?=
 =?utf-8?B?Z1VFV0xhempQVWlGZWtrUnFYeTQ0elFzK0ZTT0VkbC93NTdZNTFGakVxR0NF?=
 =?utf-8?B?OEpqRUQ1S1I0UHV5b2pvb2gxTE50WmZWcWRYNmNRZ05Ybi9lQTNiSVV6VE9k?=
 =?utf-8?B?NXZlL0RPbm1ZU3U2Qzg5YnZZVVhnTVBzcFBWZG1wSXc5Y05FVGd3T3lLeXl4?=
 =?utf-8?B?ODRDWEo1cVNOeVp1enp4VERQaHZ6cC96M1VJU2JndXord2szdjdlNlRmcWdx?=
 =?utf-8?B?NnpJV25wVGFUcHJSWjBxTnhYZldiWjc3SFFIaWZUeWZQY3lKQjNXamhmcDRw?=
 =?utf-8?B?Q09aTVkxaFRTYlVKbXpkY0NRdkp4dFFwR1lQYjA5Q1E4eGZ1b3ErWDBsVXNl?=
 =?utf-8?B?SFIxVHpJR0ZHaXNmMjFWWVNWMG5mdFMvekZaM2cxYk91aTNhaDEwUHZjVXR5?=
 =?utf-8?B?cFRySGp1MTFSUndFR2tma0xHVTM1MFo4MmxrbFVxYzF4NVA1bjYyL1Jkd3Fo?=
 =?utf-8?B?WklOMVdzNmtlbWFvTlE2OTllNnJlR3VNN1piV2V4UnRPZjBOV21yT3ROa1h3?=
 =?utf-8?B?WDN6RlMrN3pTK0piZGV4MkJYTXRnZVFveWwyQk5rVkZUcHpCclROcnlXemRB?=
 =?utf-8?B?OExSVWhMN3hZTys0WlhGU3BWc25kU0haRnNLWXNHTjBkNUNtQ1laSXF0S0k5?=
 =?utf-8?B?MmdPTnZ6U3VobUdYOVkwU2NQY0h6cGcxTlF3a25WUDlJazNFSTd1TWNtdFNn?=
 =?utf-8?B?akxYT2VpMkplR3oxTkV6OU9pWEJhanQyL0p6TmFFOU5MaUNwdDdEVnppU2FJ?=
 =?utf-8?B?NFl5KzBsMmQ5Um8yZm5WN282WXNTQWZLQXJ4Q09NRVhKWFJPWXZGZXRMM0Rx?=
 =?utf-8?B?RithYTRUMDVoRktGYUVFVWRhL0FUWDV5WTFSd1RMbm1KZVpId1ZQRGFoNXJE?=
 =?utf-8?B?ZWJPZnVTcGlkdmdmNllSVlUvWlJvY2tYWFlGeXJaMmQvZHdpLzlHdWJHV3F0?=
 =?utf-8?B?V2tjR0R6MnBwdGp0M3JNeXRhUE9HaVdJZXovRjdTNmFoYUJxOUY3ZlIwazNo?=
 =?utf-8?B?Z0NLeGtlWW5XUE8rWEd5ZUlpM1lRWWxCeElnMTZSeUJNb1M2VUNGK2pFaElV?=
 =?utf-8?B?dWxWeUtxcDlJMHR2Wll2OGZVKzIxdW12QUxWRkdlNVNjdlhTVHJxNVY1Tzdk?=
 =?utf-8?B?RXBOVHRLLy9XeWQ1aUdWTWd3MkluZEJFdEhCajJYM3ZDSVFUNUxya0JYckFo?=
 =?utf-8?B?cnJUUmVwcUE1MHhWRkkrdXpyeHFNUXpOdExEdEtWenRqVm1ZY3p5SFhhWksw?=
 =?utf-8?B?ODRKd0ZwWW5ESDNSZHdKMXZaMEVCYmFVVzIvV0JQV3kxR2p1aUZobTNmdDRj?=
 =?utf-8?B?ZlYxZ1RpOC9OaGxCNWZ4c2Y2OFRnPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93c5feac-b249-40d7-7b39-08db09d134b8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 12:37:14.1783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZL8Eg1JDAdwp2gqX0ZnS7oURC6mWwvjc5Mu20L9Tmnmj5av4d+4wy23+GuwE85CNZ/6EUHBSBPESogKd7SPHGtGg3uDFrsi/Up94D47YQHM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB4556
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 01:34:19PM +0100, Jiri Pirko wrote:
> Wed, Feb 08, 2023 at 01:07:54PM CET, simon.horman@corigine.com wrote:
> >On Wed, Feb 08, 2023 at 12:40:45PM +0100, Jiri Pirko wrote:
> >> Mon, Feb 06, 2023 at 04:36:02PM CET, simon.horman@corigine.com wrote:
> >> >From: Fei Qin <fei.qin@corigine.com>
> >> >
> >> >Multiple physical ports of the same NIC may share the single
> >> >PCI address. In some cases, assigning VFs to different physical
> >> >ports can be demanded, especially under high-traffic scenario.
> >> >Load balancing can be realized in virtualised use¬cases through
> >> >distributing packets between different physical ports with LAGs
> >> >of VFs which are assigned to those physical ports.
> >> >
> >> >This patch adds new attribute "vf_count" to 'devlink port function'
> >> >API which only can be shown and configured under devlink ports
> >> >with flavor "DEVLINK_PORT_FLAVOUR_PHYSICAL".
> >> 
> >> I have to be missing something. That is the meaning of "assigning VF"
> >> to a physical port? Why there should be any relationship between
> >> physical port and VF other than configured forwarding (using TC for
> >> example)?
> >> 
> >> This seems very wrong. Preliminary NAK.
> >
> >Of course if TC is involved, then we have flexibility.
> >
> >What we are talking about here is primarily legacy mode.
> 
> I don't see any reason to add knobs for purpose of supporting the legacy
> mode, sorry.
> 
> If you need this functionality, use TC.

I understand your point, even if I don't agree in this case.

> >And the behaviour described would, when enabled allow NFP based NICs
> >to behave more like most other multi-port NICs.
> >
> >That is, we can envisage a VEB with some VFs and one physical port.
> >And anther with other VFs and another physical port.
> >
> >This is as opposed to a single VEB with all VFs, as is currently
> >the case on NFP based NICs (but not most other multi-port NICs).
> >

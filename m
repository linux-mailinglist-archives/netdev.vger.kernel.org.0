Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67E86633B92
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 12:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233350AbiKVLjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 06:39:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231487AbiKVLi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 06:38:58 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60089.outbound.protection.outlook.com [40.107.6.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5488020F78
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 03:34:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IMzueqTWqhvzKPHpCRyr1OmH2k1qh7Lmwn/WaalsDwyMPxGIMQ6ELtmYbApFILGELr5THgb2NoCzUtSiCunr3+m3OCpCxzS7AIZWIMS9h8Bk5QQV7urT+0sgB8ZmQGNbnWXXaqZDNPu8BXdhWVHQvQYEHSwk4SgoKFKEYO3GU1XDeP0ax2913x6nU778zV8IMGGRwBnuFL9jrk+jquII73fYAU1RQimQmmSnr3Kh+SyOUyiaOFnSWRXlZCFqyXW3ba4MwNTplOdZZLtxqllK1IAyXLRPFC8MU2biS3rz4P5Tksbwxa3XQSG2BZYaPok0FSEC4QAWR7URW2eKi4G70w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7LZfWHP/Jk034p3I92FQ6o5rOmB9UqgxCtLjxqnp5oU=;
 b=fZYQWIzp8bexOdIZDYCGGQq2K98VAF8RgSrqf0/+85CfInKHp/Gl0I4IOkc6VEwpV2iP3erfF8ub1pkw+6pqoOZhnvqkd39ywz64dWH1g3qL58g3YAijfnGk38nRlO1C61xV/dUiJh4+sMCiIDfsLcPpKi6ak6qTP1p/fJagqYBIhsa7mgOE05qy60hqrn26bTGjx4VrgRSOwFZl6J9grA96D4n7fIwdb1uc6HYZ/jpuKnZ88Nflfw3DDVfXKntiQ6irrz6QGXgKD3J1PYJetp33L+ZPWEePQNxtIuoZ5XhcWv2po3Ke398BQnAFv+qz4njeAfsbID5UrH9jc07kug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7LZfWHP/Jk034p3I92FQ6o5rOmB9UqgxCtLjxqnp5oU=;
 b=BJj1EiiW68qzPfc6TT66HPTM7RzW9jHmhzzA7OF3FVc7UyUunIzViAvSH9N6gHBC8HZCXbzsl/N+sxZg2/6Tc21f8dQJVFX/wVtYuZcvu3xiqw0cqTIX09unfcJHUo516r9/dIVSz04zZJRcfLlfN+ks54WkxbGgpPN3kjI92Yk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB7758.eurprd04.prod.outlook.com (2603:10a6:102:c4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Tue, 22 Nov
 2022 11:34:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 11:34:30 +0000
Date:   Tue, 22 Nov 2022 13:34:28 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Steve Williams <steve.williams@getcruise.com>,
        netdev@vger.kernel.org, vinicius.gomes@intel.com,
        xiaoliang.yang_1@nxp.com
Subject: Re: [PATCH net-next] net/hanic: Add the hanic network interface for
 high availability links
Message-ID: <20221122113412.dg4diiu5ngmulih2@skbuf>
References: <20221118232639.13743-1-steve.williams@getcruise.com>
 <20221121195810.3f32d4fd@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221121195810.3f32d4fd@kernel.org>
X-ClientProxiedBy: BE0P281CA0028.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:14::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PA4PR04MB7758:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b3828ae-2ecb-4186-244e-08dacc7d851e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GxOSpRgQK1Ijx0hzi9DWq7xsw6BZhgBKcf5WQ2z+xjBqsHY4DKZOQWCHrZAJpkQUPAeX071Q81uN17liY5xm3Fj6pDyUPrD/aYplEm9QEXsgOGpGRaIBUWdrT6jNK0cFscX+VW3wcfR6PaLPnpVMcHOHoSV3SLbL1uEAiN/aKstUQkSOq21jUv7jIlhdqzbyIQnbi2fO4/jK8w2npi16Ow56mYDkyKqIW7TScHQsHz20Lih1rpzllO31eFUTU73Dt+0wuYrKV32UwcOyChq1g5CcqdQfVm2RaARwhL1agMmJ7R8IE2ylJFaM3wXZ7J0C7SEQOAY+3EFwUG0TAyDtEASimt5L+Ni06XPp+88lKFPnBVqcHj//k3buwZHuOLJ/MEhK51Wl8p8I4oQuU5zUwgr361QI9znIvEbBf2oBUWm5VIDlvZhJutHLMSljujNclOeIRQsbxG71BmvmxvqGu7EPwkPURUhKadQk/oEi48z5Qc77+OMutiTUCDdivEvw7g7Wlyl6OVUChdqev31hql+Vgj9f1J2pT4wEnGQyevpS7Br+MRjxtUNVC2Jxy9TCRVv0av3rpXSg+mHIWWyep1XUR1i5hDYyuXcSDBYjoU+P3ZyM/RFxiUxDuijKWTo/UMjj4KTDqe8rIRVOGdxdnVTQppnCySaqw/6u6YL9gGc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(376002)(39860400002)(346002)(366004)(136003)(396003)(451199015)(8936002)(5660300002)(6916009)(44832011)(966005)(1076003)(478600001)(6506007)(6486002)(316002)(186003)(33716001)(9686003)(86362001)(2906002)(6512007)(38100700002)(8676002)(83380400001)(66476007)(26005)(66556008)(4326008)(66946007)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YjRRbFltakdUUnk0eEtPVy8xWHFNSGpYT1gxcnI3Q0UwWDFEZGhsMnp5cU1k?=
 =?utf-8?B?Qk5OdUxrTHhUYlhSM1U4RUpKcytnRko0V0sySW0zMUxFWWVMb1JsUkVFNjlG?=
 =?utf-8?B?OG9iQjQyaFY0Z3MyalZOdFBEZU5OMHl3TVE1TlRWb1RsYnAxSGQ3MVhBMHg5?=
 =?utf-8?B?dFFUd1NWWUtuN3QyeGpocDZXK3RFWWg5SnBOZEtxYTd3VGFLbHFTNUx5Y2hK?=
 =?utf-8?B?aFhBNEZqR211UDNLam9BUXR1dUNTZVhWVVh4cUl0RmNPMU53RENKR2laT0g1?=
 =?utf-8?B?VlN2c28wa1JPb2FGNXhtVEpkcDJ6L29nZm4wSFlmZU1May9DbzdoL3BrKzRY?=
 =?utf-8?B?ZzVnOTkybllTNHYrUTQ1dHNoYlVjWjhNZkY1ZVdWTk5QTmJreU4vcVBkS2Ew?=
 =?utf-8?B?bXFNa0pDRHdRTVhxU3B5VUM3SitSa241cjA3SnowSVZMVmVqV3NmU1Q0aXN4?=
 =?utf-8?B?cXArNlJ0U2VwcjA3NTlia3ZoSWxPOG1mOXJLdEJQQ1kvSm1JSVNXT29kRjJp?=
 =?utf-8?B?S3dGZ2RMSFNwTFBkUmp6RXpZaGZrek40Y3FsWHhIRVBVb2VFTXlrdTdHT3FN?=
 =?utf-8?B?enZoYm1jUjFyZFd0WHZ3eWpUZWRtY1lHWGVFZ0hqMXpqREdlTGdabWF1Ukxk?=
 =?utf-8?B?V2RGQVRTd3NUV09PS3QrSXpPZUdEdjFpM09uMmFweFFNV2hQNThhWnpiOUVt?=
 =?utf-8?B?dER0NnNnQmdjVUFFR1o1dTEzWDgyNk5aMGVQZkNFQk1IUTZLUyswekNWQktY?=
 =?utf-8?B?SG9XbTdjZ3NPdFJYdVZJQzVTbXA5WVQ2djRBU3p4RGJ3KzF0YXNpQW9qZ2pO?=
 =?utf-8?B?LzIydlhvVkxLZE5tMzFoc1NnVGpKR0pMbG1xMENrc3NTL3lOQU5FVzZTTXl6?=
 =?utf-8?B?SzdrLzAvVWRGdXFRQzJySnlJdGIwcG1HZnZWTFNmNHF5WmFoaFpFWGN1RFZP?=
 =?utf-8?B?YUM4R1paUFR4WlQ1eE01NFRKTUhrVG9GZE01MFZ2Tk9aSFZ5Y1BNeDRDZmJk?=
 =?utf-8?B?aE1sMDIwMFdjalJiWFdYYkVISzFnTkhZMFJvalJzaGo3MEsrN0dxckozaUVK?=
 =?utf-8?B?YmJyZVpoR1VoSGNtbGROSWR2WGxwUjdoYWprbStKRjM5Y3pwSmtJMmgwRmxE?=
 =?utf-8?B?bVJVNkZocUQwalFBN1hqS0JFSmxTTGxlMXhDSkRDSnFjN3VBMGFLYXExMHcv?=
 =?utf-8?B?LzBnKzZSUEc0MWdCVitaQmFoRlBtQU0zRUhUdXlmRzRXTDAvWmVERHpOY2lq?=
 =?utf-8?B?TFkzeDJDcHZIR05rRlo0VVJ6SVFmQnFYY3VTdUdBaEhzbnNuSXQ1M1dRSDhJ?=
 =?utf-8?B?THFOSklEU3FvNkpZTnkxSE5GMWZRL2ZIV1hVV3FGWFdKQzZYbjNjSjczbjg5?=
 =?utf-8?B?ZFZpektiYWRFejZQK1BtRTZZK2MwbGVGV3ZxYU0yMmhKYjVzVDZEUlRESTBC?=
 =?utf-8?B?TFhUV0FPMUh0ZCtjQkw1RE1tcGpnOXdPNzdlMFJYOVIzNFN0K2xPSkovUytv?=
 =?utf-8?B?RjJRSThWZGNiME10ZjdMQXNRcDNvcjJITGNmd2dZSk4rcFk0bE9LODZpdThV?=
 =?utf-8?B?c1pjdjl1SFFDdFkwRFk0clVjQnE0QndUUXVUQ2lpeWNxZmhnWGtGaEMxKy9h?=
 =?utf-8?B?VVBkSDEzWFBzRG50cWVTakNBVjFxeElZbEJXSDdST21EM2JFVWJiT1l0NHBF?=
 =?utf-8?B?S0lTR0RzcG14a2w0Y0czZmV5emc5OG8zRlV3RmhBZkUxbFVqS20vaHJGSXZH?=
 =?utf-8?B?ZWdWOXpTYjA1VEY2VWpmckoxcHUyZk10WW40UVk2WnhwNHBUSWQ0bUxSVzdj?=
 =?utf-8?B?UVZDcUhud2pJOHZqNnk4eVVZckQwd0FwbkRnOHRHQzJlUTNWZHBxeEgvSGtT?=
 =?utf-8?B?eTlzWEg5dUlvdUR4V2Z5ZjZlNG12YlcyTjYrdEs2WjhFQXZNaVNXNjJ2K1My?=
 =?utf-8?B?MmhoQVd2cjhPMVB3cVJYRjZQUGhDaW1YWWM1R0NnNkZ4a1hZaHYrUTdaOUUv?=
 =?utf-8?B?S0plZGQ3V1B1d3ZkMExEZlhOVDgzRnptWnVZQzZka3B3ZjBvNDJQM2NZKzdQ?=
 =?utf-8?B?MVptbEJlb3h0dmlsSWJxTG5VMU9UajB4amJ2UWRoOS93dVJnKzBobi80aTVn?=
 =?utf-8?B?cDdseXZuUTZMVW1rbVNta1o5bVgyN1M5L1VzalV0QzUvN0JmSzh6ZW45ZTRw?=
 =?utf-8?B?aXc9PQ==?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b3828ae-2ecb-4186-244e-08dacc7d851e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 11:34:30.4388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rvve3I0BjcCiEuHO4F4NYUiCOHEA1YIOP6koX41jAY3W0Bt6084ExOaAAQMFa2BjwPqdftzFOhjlAYenQ2Ox4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7758
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 07:58:10PM -0800, Jakub Kicinski wrote:
> On Fri, 18 Nov 2022 15:26:39 -0800 Steve Williams wrote:
> > This is a virtual device that implements support for 802.1cb R-TAGS
> > and duplication and deduplication. The hanic nic itself is not a device,
> > but enlists ethernet nics to act as parties in a high-availability
> > link. Outbound packets are duplicated and tagged with R-TAGs, then
> > set out the enlisted links. Inbound packets with R-TAGs have their
> > R-TAGs removed, and duplicates are dropped to complete the link. The
> > algorithm handles links being completely disconnected, sporadic packet
> > loss, and out-of-order arrivals.
> >
> > To the extent possible, the link is self-configuring: It detects and
> > brings up streams as R-TAG'ed packets are detected, and creates streams
> > for outbound packets unless explicitly filtered to skip tagging.
>
> Superficially pattern matching on the standard - there has been
> a discussion about 802.1cb support in the HW offload context:
>
> https://lore.kernel.org/netdev/20210928114451.24956-1-xiaoliang.yang_1@nxp.com/
>
> Would be great if the two effort could align.

Thanks, Jakub, I hadn't noticed Steve's patch.

I have some problems getting it to compile with W=1 C=1 (possibly not only
with those flags).

  CHECK   ../drivers/net/hanic/hanic_dev.c
../drivers/net/hanic/hanic_dev.c:70:16: warning: Using plain integer as NULL pointer
../drivers/net/hanic/hanic_dev.c:106:29: warning: Using plain integer as NULL pointer
../drivers/net/hanic/hanic_dev.c:109:22: warning: Using plain integer as NULL pointer
../drivers/net/hanic/hanic_dev.c:128:29: warning: Using plain integer as NULL pointer
../drivers/net/hanic/hanic_dev.c:242:19: warning: Using plain integer as NULL pointer
../drivers/net/hanic/hanic_dev.c:295:29: warning: Using plain integer as NULL pointer
../drivers/net/hanic/hanic_dev.c:510:54: warning: Using plain integer as NULL pointer
../drivers/net/hanic/hanic_dev.c:596:22: warning: Using plain integer as NULL pointer
../drivers/net/hanic/hanic_dev.c:639:39: warning: Using plain integer as NULL pointer
../drivers/net/hanic/hanic_dev.c:640:39: warning: Using plain integer as NULL pointer
../drivers/net/hanic/hanic_dev.c:655:47: warning: Using plain integer as NULL pointer
../drivers/net/hanic/hanic_dev.c:656:47: warning: Using plain integer as NULL pointer
../drivers/net/hanic/hanic_dev.c:753:42: warning: Using plain integer as NULL pointer
../drivers/net/hanic/hanic_dev.c:754:42: warning: Using plain integer as NULL pointer
../drivers/net/hanic/hanic_dev.c:776:20: warning: Using plain integer as NULL pointer
../drivers/net/hanic/hanic_dev.c:800:34: warning: Using plain integer as NULL pointer
../drivers/net/hanic/hanic_dev.c:802:33: warning: Using plain integer as NULL pointer
../drivers/net/hanic/hanic_netns.c:14:14: warning: symbol 'hanic_net_id' was not declared. Should it be static?
../drivers/net/hanic/hanic_filter.c:70:42: warning: Using plain integer as NULL pointer
../drivers/net/hanic/hanic_filter.c:77:21: warning: Using plain integer as NULL pointer
../drivers/net/hanic/hanic_filter.c:92:42: warning: Using plain integer as NULL pointer
../drivers/net/hanic/hanic_filter.c:99:21: warning: Using plain integer as NULL pointer
../drivers/net/hanic/hanic_filter.c:115:21: warning: Using plain integer as NULL pointer
../drivers/net/hanic/hanic_filter.c:127:21: warning: Using plain integer as NULL pointer
../drivers/net/hanic/hanic_filter.c:160:78: warning: Using plain integer as NULL pointer
../drivers/net/hanic/hanic_filter.c:161:34: warning: Using plain integer as NULL pointer
In file included from ../include/linux/kobject.h:20,
                 from ../include/linux/energy_model.h:7,
                 from ../include/linux/device.h:16,
                 from ../drivers/net/hanic/hanic_priv.h:10,
                 from ../drivers/net/hanic/hanic_sysfs.c:7:
../drivers/net/hanic/hanic_sysfs.c: In function ‘hanic_init_sysfs’:
../drivers/net/hanic/hanic_sysfs.c:83:31: error: ‘struct hanic_netns’ has no member named ‘class_attr_sandlan_interfaces’; did you mean ‘class_attr_hanic_interfaces’?
   83 |         sysfs_attr_init(&xns->class_attr_sandlan_interfaces.attr);
      |                               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../include/linux/sysfs.h:55:10: note: in definition of macro ‘sysfs_attr_init’
   55 |         (attr)->key = &__key;                           \
      |          ^~~~
In file included from ../include/linux/kobject.h:20,
                 from ../include/linux/energy_model.h:7,
                 from ../include/linux/device.h:16,
                 from ../drivers/net/hanic/hanic_priv.h:10,
                 from ../drivers/net/hanic/hanic_streams.c:11:
../drivers/net/hanic/hanic_streams.c: In function ‘hanic_map_stream’:
../include/linux/sysfs.h:55:15: error: ‘struct device_attribute’ has no member named ‘key’
   55 |         (attr)->key = &__key;                           \
      |               ^~
../drivers/net/hanic/hanic_streams.c:90:17: note: in expansion of macro ‘sysfs_attr_init’
   90 |                 sysfs_attr_init(&stream->attr);
      |                 ^~~~~~~~~~~~~~~


It will take me a while until I come with more intelligent feedback, but
as a first set of questions (based solely on the documentation and not
the code, I'm wondering a few things):

1. You seem to create a usage model which is heavily optimized for ping
   (the termination plane), but not at all optimized for the forwarding
   plane. What I mean is that the documentation says "Inbound traffic
   that does not have an R-TAG is assumed to not be redundant, and is
   simply passed up the network stack." That's a pretty big limitation,
   isn't that so? If you want to build a RED box (intermediary device
   which connects a non-redundant device into a redundant network) out
   of a Linux device with hanic, how would you do that? Inbound traffic
   which comes from the FRER-unaware device must match on a TSN stream
   which says where it should go and how it should be tagged. And the
   set of destination ports for inbound traffic may well be a subset of
   the other enlisted ports, not the hanic device or one of its VLAN
   uppers.

2. What about stream identification rules which aren't based on MAC DA/VLAN?
   How about MAC SA/VLAN, or SIP, DIP, or active identification rules,
   or generic byte@offset pattern matching?

3. Shouldn't TSN streams be input by NETCONF/YANG in a useful industrial
   production network, rather than be auto-discovered based on incoming
   and outgoing traffic?

I mean, I can truly, genuinely understand why you made some of the
choices you've made in the design of this driver, but the more I look at
Xiaoliang's tc filter/action based take, the more I get the feeling that
his approach is the way to fully exploit what can be accomplished with
the 802.1CB standard. What you're presenting is more like your take on a
subset that's useful to you (I mean, it *is* called "Cruise High
Availability NIC driver", so at least it's truthful to that).

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 848DC5BF582
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 06:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbiIUEld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 00:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbiIUElF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 00:41:05 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2099.outbound.protection.outlook.com [40.107.237.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAEB97F0AF;
        Tue, 20 Sep 2022 21:40:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=entJfmPYI0quZDsO+wMpBFJKaJTRIw/nB4rnfm6rfSOkkc9rf+kusQ2rKU6bOfPGdpatwxghECGycnSvgYpJtT6u3GBxEGraACj6qVjBnHJWVO+RDjzw2hWJjsU0F1vZO3TqeZgDx0IwTrrrP8CJmoISBdG6PjoNPXyVtm3TA4ZnDYMOf9SyByHGIMXUCH971VgS4R7oevBOAJ+DXV5fVDw+QcIj5TvyApeDs7kykMkTGONfFGn8A7XsjQSYgI1zKA4KJ1ytOPZQsyf/Wb8/3AEwWFiO/Pa2TTcwBHsSBKChB8v8HtKmzUQ9Xb/qXhTC79Skkqrd7wse7rxVjHmyJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oFAXLMeGc2TFgzLu/qGWPivgOjyADbhKP3q6Y6AfD78=;
 b=nQV0esdDVwDDc1m9HNe8smjRpkvHCPJujCbyFwiGQVGpEwFl3pNgek4L1oZFihyR4e8mRM463g/Z3HQXwLF5mwDynLFyArp7J2MdlgAbIbXJNqubT3BGR/qkoLRujwlH3F8M8AZrBJVRcI1JmNT6L2Q6hq0Wdv5SiZ7KBR++0JQe8EdenqgoOr0KdyJfDx+0ldUVLJLCJx+ElCMGCwyfBuTVzNTgO81a89ArBzsV2/ueCPL82snqsdVAQ+uL6VxfsdohS8lAWraRIe1jjP3HBertcd0wW8NuyRfZ69z5LLtR6hMD44q+tBQiwtL3iUjhPwDC5JP16RP/8wGkMdpiLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oFAXLMeGc2TFgzLu/qGWPivgOjyADbhKP3q6Y6AfD78=;
 b=GWtzlZOITdk9CV4B85Oq/Xh91dkFMbhMbp303jHT0Fi/xHN+8LknqbFJA4oNXMrfL8ClhEFzLzUJB+iGiWNyy/hHcJt600d4Mf3rSiZ+Smlr9yyXQWLLjGpTh/gPcyzcauSFWVx1yaIudC0P5nAtzUr+oxiMcAeSpbOCbate4T8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MN2PR10MB4206.namprd10.prod.outlook.com
 (2603:10b6:208:1df::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Wed, 21 Sep
 2022 04:40:52 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::5811:8108:ab44:c4a8]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::5811:8108:ab44:c4a8%7]) with mapi id 15.20.5654.014; Wed, 21 Sep 2022
 04:40:52 +0000
Date:   Tue, 20 Sep 2022 21:40:48 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lee Jones <lee@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: manual merge of the net-next tree with Linus' tree
Message-ID: <YyqV0IrItyL/70BJ@euler>
References: <20220921110032.7cd28114@canb.auug.org.au>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921110032.7cd28114@canb.auug.org.au>
X-ClientProxiedBy: SJ0PR05CA0022.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::27) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|MN2PR10MB4206:EE_
X-MS-Office365-Filtering-Correlation-Id: 6aca105f-08a9-48bd-5fa8-08da9b8b7680
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CoFRY1pRU+vxVhc4qb78tAlArTLjUhSYdaKmyDgQ6qlwbkBm6gvyd1JCRw1spiBQIEnPj0zxZsyANSq+v0FgAk4gR9lVDPWcylnuXM6vzyloFeTNL6yc3GGzdJX4gDaEaEujMThEIQuM+tZkNtM2Dps9XkvbUqcS5uKZVii52J0SiA8vsvMgBxBu1cXiNJ7AMDVKcUgoHFQp5Gz/WVdMsMgMFhSh6YHaDiTIp5d52bjy/M8mzSMHP4j061xXTWQw8ZGhs6sru0jhTUR1URrNdXRpU9R0dc4KIJwfXZin8dcW9xjD+JeCs2R9PF0Ywy3u35b4RXYAFJEchMIWscJ5E6Us7q6UQGRY9IUjmw0iWJCaZfoKZiw7byAKYkXVGrkFpgnLGjkKNDgfMAPcPVBLtIZCXz09ebTvgEIJNOeDJL4fhc++Nwju8vyuzse/nDIsilyIchlmslJqdBBHPu0JDZ6DCuHqY1S65d9+XZQTn2hkGxj9bGNzhdQpuy+dmH83widaux6dJQYc5oFQCriACtdyrCLh0LE3hVNCJkl9A0k+ix/zFU22cBqd5wsAqTKa8ABRWHXybWivknXXmZjaIjMCmsJ8wJJdnR5xuh63c4tl+1caGuf6QNYVS1NIRmsto+RBRhVEYe2CQhfsGjfgDhGbGRjH0pnkQQCSnAM/kXj53a/QR+aHkC0TvGgtxVECm/U8fJXn10L+tK2HeTllDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(376002)(39830400003)(366004)(136003)(346002)(451199015)(9686003)(26005)(6506007)(6512007)(38100700002)(5660300002)(478600001)(6486002)(2906002)(44832011)(66476007)(86362001)(33716001)(186003)(6666004)(66556008)(41300700001)(66946007)(8936002)(4326008)(6916009)(54906003)(316002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lyWoIl0uOY0iqtZCdhRizX4NY+MDZ7F0r1P44xQLBusER0fkU7OUqYhZnelN?=
 =?us-ascii?Q?rNWtsTc2yKUDE6ntZIGuHVQMqubSq83t0FvuR0mHAqExidrMAuA7tWYn/XqS?=
 =?us-ascii?Q?swNPPjl3KBzXHivCRekAJD+AwsM8RFAyUQ/14RwhmnbGUiwZrXBx/Wxots3m?=
 =?us-ascii?Q?ZhpaIvJKjpkVqPcBxK+gIlpJNE9+zIQ6dD7r5DW9qi5U2qtB2DnLNs31UPj3?=
 =?us-ascii?Q?OSl/35HXzicCBVeRBAdtdW4hEOfz4bME4VOl0lIODkg0mtOgW5sC2PK0Wag8?=
 =?us-ascii?Q?BgabicsI7ppcUZu0M4Y1W49PuR4AwQyTqE2RrbYvcX9jsQSxgLTOVXUrZva2?=
 =?us-ascii?Q?FQqKmWWZ4VRqnGiRLy4VlGDIswIlP7YkobX0KQQDkzi86+QUMZnc6Gm1+CLU?=
 =?us-ascii?Q?C7IcFs9oyVbI9YV7U8NWadNKBcXASXKrxEhVvjSFLlGznc76I/DSG4JWoLDN?=
 =?us-ascii?Q?RdrS3EvuZr/GFTqh66UJJvhjwebxEJ7E3k6G3wNLBweD1+fKWLwu8wwODtsy?=
 =?us-ascii?Q?IYhVmOViZOwsEymPmNbIIO6n2MvegXuCTqtazvvOZeB5/xErFnI4m7/UkOof?=
 =?us-ascii?Q?FJBPPSnuqLXjk8XOQqViYExDirAUzdw8pjvs2jQQQnGT3kEJg5lZlV/laKXp?=
 =?us-ascii?Q?LewnKfIJtg5G3eo0A91/7t89LeqMUBrL3V1wWb/RG0z77Kw2Pge3pn3knSk2?=
 =?us-ascii?Q?ItQAUnN6WtF+EWUPIqNirpgOxCh9rpWUtDxSFj0EezROrAnS7r4L/cnMfst1?=
 =?us-ascii?Q?Uo6fXH1/lp63WNMu0cbCMF+WNFWHSMHnCreVivonE+yjcLiX5rJdw0iRj4t8?=
 =?us-ascii?Q?pOGneJrxFAWdUG1K7gOAfWh06RbKqLdmtKy8GMnJHkpJFr2xn2rHkjegbUk9?=
 =?us-ascii?Q?cldtJ9O+1IxGevVDvILE0GQM63IOVN73dmq3Cz0oANabxzl0OvJcl4rCSb0s?=
 =?us-ascii?Q?ZrQdzXvWIoY5hP8YlGtZzELQwxw8VgwhjdBWxIReppN1GEbst0jteP02emwz?=
 =?us-ascii?Q?ryhRElj+zE1r3U8ltJrAhM0l96ZOUNFNHpZR2S4NA+//6/1s1Hh2cq8H4te+?=
 =?us-ascii?Q?ubMvSUe74tsGDvmMHp46iZP3mtX+od0AL6EKU/sHI6lJZ5txmOe9+1kECIo4?=
 =?us-ascii?Q?JNO1laPMo4A7or4C4supO8+PtJXHo709ywyryBKAM2MnTAF5n09w4LNQrHGG?=
 =?us-ascii?Q?+VL2q+agMGQfZzXlNv1Sbcl5r5Sb0f4ffrwQyEBell/yYbK4S4lAWM3tNuq0?=
 =?us-ascii?Q?bNwzTuvdi2z4Ylz9NWDTF3VtwWzKci97kXSlYDynO99vOl/++tDyJxpMCOVf?=
 =?us-ascii?Q?+BvF1+m3UJlKb+GMdYcLM4tzCHbyV4jFHUgpHY6KAaZnVo5rcyXBIMlFMjV4?=
 =?us-ascii?Q?KQtolCzpGSh0z4eGSKZbk9CaGLf8wK0D7RQdZyKXJVrGf0606xZJZ+Sv7TGg?=
 =?us-ascii?Q?qphmu/uFFy8B7nVSdLrZWUmDMmewwYnZIqYVk5iwQBygDrgoOV5LnRloNy7u?=
 =?us-ascii?Q?egFKI6908Sah8oAG7Kt4YS++p8t6cRlkPOWtXJ5baJDNibRdW+wsf4qfhGSk?=
 =?us-ascii?Q?UqOQmP6jkWULgvtqPxiE3Q/0+yFHldjK94/ZEc0u/i8f60hul4aMiuyufIvz?=
 =?us-ascii?Q?LA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6aca105f-08a9-48bd-5fa8-08da9b8b7680
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 04:40:51.9417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mHj4X/HExbeEik8gfvAxUPW+PQHmJrRvApmZPlNBO/azSvGFiCIk2jqHisrN4x95SfofBs7F9zdBFZ0uSBoJmnpwMciE7cPrQAbrWT3XMs4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4206
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 21, 2022 at 11:00:32AM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the net-next tree got a conflict in:
> 
>   drivers/pinctrl/pinctrl-ocelot.c
> 
> between commit:
> 
>   c297561bc98a ("pinctrl: ocelot: Fix interrupt controller")
> 
> from Linus' tree and commit:
> 
>   181f604b33cd ("pinctrl: ocelot: add ability to be used in a non-mmio configuration")
> 
> from the net-next tree.
> 
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.

Hi Stephen,

I can see how this conflict came about. If there is anything specific I
can do to try to recognize and avoid these in the future, please let me
know. And other subsystem maintainers, please let me know if there is
anything I have to do / should have done.

Thanks, and apologies.

Colin Foster

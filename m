Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F24C35ECE81
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 22:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231902AbiI0UaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 16:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232994AbiI0U3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 16:29:39 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2119.outbound.protection.outlook.com [40.107.223.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C7B9151DC8
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 13:28:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QWu5yhXi6sgd75AM59PS4E4DTE1Ni0vL3cRVk7Ki1atYyVZZUzydsxyzyMV7oiGdtmC08p9Em/sujYHrjkK15Z5Jqo2UffIjZ3LNlGQmRd56i/6+jgTftPqX7xxEbxfJ3aXLOMf+r8kMRuPErJqkrV6kWKDvScOUS103Or5Nas/Do6JBhh+b8SvRWkhDOwnGxUaAreo688wuKd7wfVtb90z31/lp4msSdOgstbG/oHJqsuK37K90htIZXIq7CUmu8VSNJHQ54chMBaxV7vg1ke3yc7PncHIzZnrTzAdNPaxoqZyfBXe2+wMfAMiBUgMjrjQmPtGeS6UWzeAhj2FXbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j18W7W479nRxQUzkYDY4BXMr9VryMz2U7hZxPjz9smg=;
 b=Fe0o0wdEo+9bt1aVFO75CQxq14tXReO9Wy3unGwIk7GYdZSL8KkW7DCOEPq3WAmn8VdbeT8zEXXTsDo0OrmnKVBcLosq3XSBuXyXoACmP+7nZw1WpbL2jpu4RMbL4+aNmijN3DzJxWQ7zLFmsgpZxXTszz/HceO6obRYJkyC3ZTO+lCIu6I9vZvGFMhFnQ0/DumfwZ8Cwvn/lEFvk7IIkEqYyIvFkoKKKKmrN21+7PuFjLLE50WklPJQJtM3FO5gioWczAje1+ZfKe4b/BH1MgMjF8W4czjtQjCmaCKr/iEEW1idYpa+NenjFA/tRu3MfxMlr2IaIQ0ErBwfxGXELA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j18W7W479nRxQUzkYDY4BXMr9VryMz2U7hZxPjz9smg=;
 b=YWxSZt3I9k8bDQ5KBku4cJU80UfFipbtrWpzqV3lhN0f6MIYlq6u8tAQGTwOGn7/QtQBk3djApVvW24XO5tqtiMnYsq7FfRELumE7Ufmok38PyJGbTHm3WsG4/QHrXu6GRgW7itLlHPlUEHlS9HkMD50+q6aRNcxjpRJWW0qAr4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM4PR10MB6061.namprd10.prod.outlook.com
 (2603:10b6:8:b5::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Tue, 27 Sep
 2022 20:28:44 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b417:2ac7:1925:8f69]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b417:2ac7:1925:8f69%4]) with mapi id 15.20.5654.026; Tue, 27 Sep 2022
 20:28:44 +0000
Date:   Tue, 27 Sep 2022 13:28:40 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: Re: [PATCH net-next 5/5] net: dsa: felix: update regmap requests to
 be string-based
Message-ID: <YzNc+O/FsoRLle60@colin-ia-desktop>
References: <20220927191521.1578084-1-vladimir.oltean@nxp.com>
 <20220927191521.1578084-7-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927191521.1578084-7-vladimir.oltean@nxp.com>
X-ClientProxiedBy: MW4P223CA0001.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::6) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|DM4PR10MB6061:EE_
X-MS-Office365-Filtering-Correlation-Id: c6569888-f245-4012-19fa-08daa0c6df58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3/C9i58n4Sz9K3ssZ3OegAEtDq4sGslu9osbUIpyKiklkZWAkTz2lq3Lwjj1wkv8ywEHo19GX1VdGoEM1Q2B99GLwH1XML/MZw7+OCHFXE7r70YTcu3vKNHks5NCsbfKATEDPDIvecceOhTP/09ZPIjX8hz5oEm+8zC5IYQu/iSHrqtTCInNd1z4BfbfP2tGILVTbSAH1Ws0jDYojjCK+3rKC/8ulTL5zjfujAFoB0oTSlTajut4K183ZG13pbzQAnKzjcol3NCXn2Fwz7sUPi5KuX6+l4WVJcxTzhdNIKkcpihlcM1gY1qzuSq/M+DYL+4GVEN/GbbM3WAwO8nGHbWsIa/LBVbazMMIeHPtdkNs9VhB+S5vkqVl/R4a/5MCDw+TjFH0tdhJ9OFIYmTE2SB4J30fMZv34z+mAYqeMSQZOG19E0Ab82cr504gkLc8xfMfQu0z3MpqDvuUiPlyTG/22dg7rQ5D+LnlYKN0F37pgv1GVciDn04qJSk6eRGudAInCitGpgigf25mpRoqp28b44znCfrEvNnuO15nF+CrzA4RAXhAqQaTNyMmetPtPEhzgArRnpwmrs+R7XKUSqh+O/rMWmzeaccHJN7Fcv7wHwdUzwF8CsaaX/3cWiMdMArE5rIJErRy+KOdZRwgBzk4Jjni6Z8cGHM/XnBs/G8kNA0IV0JByGqLnHzaiuHEtD8m4uDbVJDhg20PifG89g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39830400003)(136003)(396003)(366004)(346002)(376002)(451199015)(4744005)(66946007)(8676002)(83380400001)(66556008)(66476007)(4326008)(478600001)(8936002)(9686003)(6512007)(2906002)(44832011)(38100700002)(26005)(5660300002)(7416002)(33716001)(186003)(6666004)(41300700001)(86362001)(6506007)(54906003)(6486002)(6916009)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qkY3cLJSfrVFVAdT/bd2fqBsDL375qIK0f8co3QnFfl7992nkB+ElxCdAyFJ?=
 =?us-ascii?Q?4dBIYJSiaueuazaAIZ6oCGbjDgZuZZM7Kr2cZTs8t043yCBGQQgakNMv9ZPs?=
 =?us-ascii?Q?HrkDzdsy2EFlJZgWU4G6pe9YdFK+bRu663/XpicCAztMbUVSfEKcFE23GVIS?=
 =?us-ascii?Q?YFXfyR2TEqIFCLDEAaYXJ1zGTwU//YvUUAtMEAiOKIfTg3MvbcadWCkBBoFV?=
 =?us-ascii?Q?O3LRpt/5IHAN5Bp3oL8fK1AtqTIgZ/3sc7HBfo/7IW00bI0pmR3rjQMsX73h?=
 =?us-ascii?Q?j+W1iVSeiS9dvvoHIUpZepXKnMEae/x2xaEUoqTeysGMLw/GA2ldcyhhHRkX?=
 =?us-ascii?Q?9BsunPwzltO3Fuy27jy5XJwGFXqA36rAE698V9ry2Gx8SWl9P8yTAaJFrwKS?=
 =?us-ascii?Q?5LELgUJ6H3+h+tsiw76qcVkvcM2Y0r2NRpDoZM/boAoJ/ljE8YpShL5dFq/I?=
 =?us-ascii?Q?mnayuPRMiYzLxnl2tox7v7d8WRED8G3wCu8oDRSIcNbpeUGKXUxl1VShzaqO?=
 =?us-ascii?Q?PDv4lseea5qAzmkUJ5AuL9j7Z7xnh7VokjRZuHaRXkjRbOCzCNCKVQgm/dMF?=
 =?us-ascii?Q?0zhYrJ22w9qTHZl6lrz9s3++1vtOOEwrUuk65L4JZ8jVc0f3IeeymmfxCkyS?=
 =?us-ascii?Q?COl8iwTBEbUZUUuTpoiD7rj/J16hUinGhG/AMITKqixgMjANTZyHNUcUmk13?=
 =?us-ascii?Q?wbXP/uWsLQez+Y1hJfVqbKB9AqobTAim+K7mtamJKk+7tMPcgOH593qElYt0?=
 =?us-ascii?Q?TGB5uU5nc3wZmrd3yJt006/NAxCIH7w3mF0VnK+Dx8iL6W0SsEnsjInmnqGe?=
 =?us-ascii?Q?RMTejreTBN7wBzFecYlXrRHYymQMqAOYeuVcL449K2r3C5M5CHHSZ7JO0b+9?=
 =?us-ascii?Q?A96j/APlU/DRnghIGV8IVLy31YJzmEysKSHLDMi5LPevrF3PyMOlhAVQQ9Ks?=
 =?us-ascii?Q?ponjs6lU2Loxf/tCzWFoYIdx7TXRL/HBUggyqbrnyg+PoF6QDaJl2afknM4X?=
 =?us-ascii?Q?y3lgwhKvQxPk9FsZY1yRiXNnf9FUdTOAk/vGPs6VT/Xup/5C3uxbemUVtBvi?=
 =?us-ascii?Q?W3VHUSQOTPze6emSc0N1PlXv12CuaCVzHbqjgqHRzGTpZ9UWPak6wWb7KpMb?=
 =?us-ascii?Q?nx3gf+ZGAtlAJ8WFv7GHpghrZQalzP9Ea9JTIm/fUSf/pPT3QdN07oVcPwbi?=
 =?us-ascii?Q?1/g7woQ/XJ0/JARXOcZZxV2ZeXn5z7pSrOL5QKsj+uYNyTafYx3y9/KXhcXW?=
 =?us-ascii?Q?vT5oeiE1PDIc6+6Y5Cb0Szlay0MsxPK9EChkepYGgQtpCnfpq8VZKW3QEMuQ?=
 =?us-ascii?Q?3epQIjT+bv/RvBfcfCuAkuDH78HrZhQZyNOUQlQNIihRa4X1Qy3/pnROj1pa?=
 =?us-ascii?Q?VFqbRTf89eOpfZZzkK6jcG8BhngvCeDdrALXU8taLFLCK2L9zMpmA5XmHro6?=
 =?us-ascii?Q?cwRD60zMIrlB/1bMzY8kp8yx23iuUSs3KpTQka19ozcw6K2gHfk+FGLR9LmK?=
 =?us-ascii?Q?4D38PC/3v4QFak6goFQE08dLuQO0POsFbtlCWfCAFjaqypIX3g7hSN/u5D6l?=
 =?us-ascii?Q?zgLG/XFvM0kG+OyKd9tG96m6Fyaanuvxb6/nPRZW7UMdIQRIVSsuSyKlYwar?=
 =?us-ascii?Q?vQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6569888-f245-4012-19fa-08daa0c6df58
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2022 20:28:44.0845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2rKEKGXuNlvkI3ibDCeD4tp2x5lUxBJhCfn078WZ0ge/P8EJwnfWV+zvWY1OnkbmO1EQOHPGSWyI92s/ou3J57oU/FSSd8DSBVr9pSrUz84=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6061
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 10:15:21PM +0300, Vladimir Oltean wrote:
> +static struct regmap *felix_request_regmap_by_name(struct felix *felix,
> +						   const char *resource_name)
> +{
> +	struct ocelot *ocelot = &felix->ocelot;
> +	struct resource res;
> +	int i;
> +

I like it. And a simple:

if (!felix->resources)
    return dev_get_regmap(ocelot->dev->parent, resource_name);

here (with an appropriate comment) would be all I need in the MFD
scenario.


I'll share the names via macros for "reg", "ana", etc. by way of
linux/mfd/ocelot.h, unless you think felix / seville also want them.

Thanks Vladimir!

> +	for (i = 0; i < felix->info->num_resources; i++) {
> +		if (strcmp(resource_name, felix->info->resources[i].name))
> +			continue;
> +
> +		memcpy(&res, &felix->info->resources[i], sizeof(res));
> +		res.start += felix->switch_base;
> +		res.end += felix->switch_base;
> +
> +		return ocelot_regmap_init(ocelot, &res);
> +	}
> +
> +	return ERR_PTR(-ENOENT);
> +}

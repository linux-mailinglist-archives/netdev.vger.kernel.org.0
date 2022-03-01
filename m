Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED8874C8C30
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 14:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbiCAND3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 08:03:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbiCAND1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 08:03:27 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2128.outbound.protection.outlook.com [40.107.244.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259285E773;
        Tue,  1 Mar 2022 05:02:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vlw0csmZhUuzc8fyNkdUCY38DRKVtqKFrbV3wn/SnI/cvY3KMUqdaFCLv3byGcW/I+La68KvKgVhgofQ20knqpm3fVG7dXypTBRfPgqN5Ah+p/6ey3DxTryTUe+L78UArYUY7J00gNHCKRcFi/USrsKINv3RyTrzb17oKI6U9Zrg6nzlvqHIAWwlAsNN301PN6Hu5fvx/Pyes0XYmaZ3eiErktaS+2MtZ0eLTrZpKkjWxKveQDLHnlw/KQBeB5BDF603sw58/3ZxLZZ/Y69DGI5dfMMuKwl0QWfeRu0tob73vbfpufb8IZEI02ahOiMJgBq9UjevEPAlFN4KwIyEhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5WT1A82nxaTc+NmJkejjECZLBHt92JVO0i1h82Jwi9Q=;
 b=Cx7dSxA7hLyHyFFAywzeHmMMTC29exWjuNLoHAXka0kzOrfmLWAtdpB3iPx6xepwqVNDP7pFgCAByl0q6VHKwVYop4A4chZfWvYc6iIBiQTMPv10Y5DFG6LUNW2TBL7NZjHXXgm49MEIeqSk2zjJKEf72UyrEj04FSkNMHcN6a6eMoA5s1gUmGPdLE3mNPOCQH1AEzhxxL9J9G5K8Epp62r7sLzWotvEjjMwrx0f8zcA7LGg1NekV+oMBOnjzVWeeCtUxM68CYA74Ai9aeTzyhJ326sRj5ujabT7r1/Ie9i2I2CT/0EYeHlT8BV0fyafGJrT3loHt+3txIiLOvG0qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5WT1A82nxaTc+NmJkejjECZLBHt92JVO0i1h82Jwi9Q=;
 b=Nkf5bAt8OEhRpyvIHc8aYf7ozldGgtgmIC+bLr/zD8RjgEMj/gXoK3dKg1ibieULf1VAmPGxkiE8DWERx3lBOX3w+aVPj7b5hACYtCwAJN7cCopOVfOB7omkj90DqwvA9/rOMItV/i2gRWrEVFJL1oqnR9brfVjdzY0KyavnXr4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (13.101.92.70) by
 MWHPR13MB0957.namprd13.prod.outlook.com (10.169.205.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.11; Tue, 1 Mar 2022 13:02:41 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e%2]) with mapi id 15.20.5038.014; Tue, 1 Mar 2022
 13:02:41 +0000
Date:   Tue, 1 Mar 2022 14:02:35 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Peng Zhang <peng.zhang@corigine.com>, oss-drivers@corigine.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kael_w@qq.com
Subject: Re: [PATCH] nfp: avoid newline at end of message in
 NL_SET_ERR_MSG_MOD
Message-ID: <20220301130232.GF11653@corigine.com>
References: <20220301112356.1820985-1-wanjiabing@vivo.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301112356.1820985-1-wanjiabing@vivo.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM0PR04CA0057.eurprd04.prod.outlook.com
 (2603:10a6:208:1::34) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 14682d35-1757-44bf-90ea-08d9fb83c4eb
X-MS-TrafficTypeDiagnostic: MWHPR13MB0957:EE_
X-Microsoft-Antispam-PRVS: <MWHPR13MB09573ED89242805D780F291CE8029@MWHPR13MB0957.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ytiYyPmoMqqUP83584LXbJdVl60fjYv1ZKDKlLTmXTl5T1Na4p71fNWd6jfWcwsMIs3mxjvSVaKy6tGnUpiH22qfx3qufVYmnTZcfUmAvLEGsDK2iImb3yCMLIOXhQx41KmwmrFyqkKXIqjU6DuFhzV/J8eqTwx6VF1irPgcitBdY/WL6o6TACs+EgNZlvwIBTQDXnJf/yPfNTgn0S5fxl7sYTk4aKIexn5MBCF5NnMmjsygz2xpaRiO4BIxgjZBG1mL5gNDEhX4Qd/U5SPZ8JMVkQO8yiD1KBapgc1jpI2L6SYme9AUdRRs0nHRDLHXXSaPMiPv+vzLJTRunoZ5hvRBiNq23m9Xdr+//F2c+5dSdoiU77g9aSJgXpxtdBNVlDW/uBYDa5eY2Dtd0HjPh/CaUKlAyhMkomEA/71vXDxUUHmUNkH5jaX1Ebh+SnO7GyalsEK9uZoG2Q2BVAn/WCeGyCyLvaHvUJfEYzuap15CRYccVfEGMAZmrQdNl49Y+zgPCCRMShtejZFOjl0x/2WeFkwtaED28xZJ+OcoMSkoB04Sk7u7n6SeIoLGeLJmnkA/dgXsyB+kcRQypV1c5pmOZjRJ6/Qk0L3jQQz/Wuv7NBRMF51RNFhAtYzD6fVhBvi4JIlDvw64BPc/7MvAEdiG9fh63fN2/aPmlBptjZD9GWuvIXvek/dHigyF+8Gd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(396003)(376002)(346002)(39830400003)(136003)(316002)(6916009)(15650500001)(36756003)(33656002)(86362001)(54906003)(8676002)(66556008)(4326008)(5660300002)(66946007)(66476007)(4744005)(8936002)(44832011)(38100700002)(83380400001)(186003)(1076003)(2616005)(52116002)(6512007)(6506007)(6666004)(508600001)(6486002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CcSFsdpx4rKCNQelWShMveDusEr9/0Acd6ejh5AIkB+Vp314H2KUbb7c8GlV?=
 =?us-ascii?Q?wdkiMPvzpZGuUmYriaxArTakaB7VNSnwLlGoC6DuPMeox/izpD7i1d/wG5ox?=
 =?us-ascii?Q?L/vEWADntrYlh/8/aaEfa9UQFNnxenkikF0JzD6saXqOGosIRNkVA8wxCWMI?=
 =?us-ascii?Q?wN7L+sARyJx+8RCHRn4DZ12g1C69Nq6e6t+D0wwLOskaYVhAzv5vvT7EWDFp?=
 =?us-ascii?Q?BFjcvk3HCeSD3isyhY4fct7UA8uONNCqymHV7L4DxQzw0lcyPbfIlFsulygh?=
 =?us-ascii?Q?ltdyV997Az1dXG6e3LyY2Rv2cJDXuFznpqjOB9xW4oYSXk/AnqAVIfhs4xie?=
 =?us-ascii?Q?bomvjeX/IbMaPvz6PYjKvMNqSn8/VaqFS8vgAVP+doo7iqOOSsR18a8bZWk0?=
 =?us-ascii?Q?ssiqfMI6Fj39Jyo0bnjCeBI12VkC+m0W3/mglpD+5T6uYkitkOgq/HwzYGmM?=
 =?us-ascii?Q?8g4mE+lmwhds3pk0aYcGSCshK4Z8BzMyrP16alOFuBKAre6wAefGw0XgPabz?=
 =?us-ascii?Q?5VkFJZu/aYeT3HwH/33CVFRU68s7W5Z1f0fChfp0UTabLw1Oto9XBas+44Fb?=
 =?us-ascii?Q?FrsJz4dqLpTxhAN3XMOqPoRc6lKixzVAPtV2QAoUQ0NB6D7MjTLPv06GNN8k?=
 =?us-ascii?Q?sTGCHb4EsZ138p8ZQ4fAiWbPcjJtx/XhqV2mBWSz+3BH0DK4OqWJIxJ1M9DW?=
 =?us-ascii?Q?y/b/KhI4H8m7XN3pzq4NVvWdmeqKgAed4oQa23rOUcaruEYnJLiF6UJG7t5v?=
 =?us-ascii?Q?fvWmkbN6INlZ5bdeZGso/K/MCsQwg+tvcYQuEAUa7pxcYCd6KX3jikFZiiJb?=
 =?us-ascii?Q?atV6vkGDmlUaY9iWSvXHcr1alIdKO/6Q1X/CDFsGPQpUmovgtb3lfcGJxpZq?=
 =?us-ascii?Q?1lPWSaghdmLLBij47b4dKARlQZXQiOoI0c6y0UpuEwEpQsVpYD89sCZqfSNY?=
 =?us-ascii?Q?aIwTwNrs8oIpiE/RlRr28OV1khb0tQZqV89ohWfLWEo9/a94sKVr7fsS9TMD?=
 =?us-ascii?Q?Yq+LMLMOQYBcoianNjAnWuwYzo6vbhX6e3fr8CUA+rlyHRNGQc59QgOW09FA?=
 =?us-ascii?Q?+clZJJRMsGtAVjz6krRe/3RPDDWpZes+c014MIuA3S3ENCMdaM1KJHozNJIW?=
 =?us-ascii?Q?K8ynny/paSJI1O/lJ+n5RDk5wZSLzSguWOmqB6gxyrmxFZenSqAtym4N43RI?=
 =?us-ascii?Q?UDTJHSjJo+S8OeF22DBwPQ/YHt6SUNP+dqTWd4cjC7WyCADfpplNYDPaFlEW?=
 =?us-ascii?Q?1aAwPhE5H3AmzhzZGNIu3pxqQ03FqBFnBJuc6hytVYH88ya7S6cPEz6e9jMR?=
 =?us-ascii?Q?Qh25SFPr4TDAVUiJPOEqfIJJiylHEwcqHKBJXU4oecHMMSi0e7lESXKb+xSj?=
 =?us-ascii?Q?n+VjGldiJWV/Wgxg91JziISwtj1bN33uoZRI9sHN9pn0iAk3S6iitjtvTzIZ?=
 =?us-ascii?Q?l3BSdzZrf001UiFtswp6qTq+zQ0YiwFU1ImoAbE/ssqeeKds5Tjki+ClaEAH?=
 =?us-ascii?Q?v9BYERqRrxHJ6dDMw/XJdZQR3143wo+mIfd1hZNJNKfxOtxiTfnd3067Upow?=
 =?us-ascii?Q?jJvMSzLza8EaURxxlOaTps6Ncyj8a4v5JPxvs7xIWWpFlE0iZy4Ng9m7qfPy?=
 =?us-ascii?Q?RufwfuJiP6tvzLRR6pu7NCX+rag3592/xV+pDsUPv3RSjCYy3iKRhqUANiR4?=
 =?us-ascii?Q?W+ye2R4MPBi35mwKVpEZmRFTVO8uLwj21L5+AH9JYF8D+GflYoFGPyQUiOxk?=
 =?us-ascii?Q?AQTsY1WC8w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14682d35-1757-44bf-90ea-08d9fb83c4eb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 13:02:41.6445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iP4kmaSERdPtgJpzZRtaV2KeXFS+uhdlBlRy3AF1GFt4qwRXKEaWKgtMhHKklOBx+Qg2F2G8UfF4UD+y0sslz0WXGW1rUe6uxDtL878Jqag=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR13MB0957
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 01, 2022 at 07:23:54PM +0800, Wan Jiabing wrote:
> Fix the following coccicheck warning:
> ./drivers/net/ethernet/netronome/nfp/flower/qos_conf.c:750:7-55: WARNING
> avoid newline at end of message in NL_SET_ERR_MSG_MOD
> 
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>

Thanks Wan Jiabing,

much appreciated.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

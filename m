Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81AEC6B5B86
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 13:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjCKMPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 07:15:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjCKMPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 07:15:37 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2116.outbound.protection.outlook.com [40.107.237.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B138F711
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 04:15:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bJ9MqT7eUbJ13WeY2LiteqTB1bzzS687e2ogUPfAM+//rDKCj2KEnhurmPm3NqjvC8/t7dzxkKIoPsF8uL7Em7qvPxyGu0rYDSDMYwu8FavsY8XfGem30OTibL552x6DpyFp1/2+cBMiEJcyJW/PWhe5G/eTwijWbTdPSXpS3nifZpUtIGFVIDeDxqUlug4Tr9h/Puj/dtW6yioVxqAsSopc2n8+kIu5y2rOrpzW5zxP6ZF5lYJmmA6G1rL/i3sThzt/nTxdbNszjDrYh+ZKhbDrc2MUWLU2NlJR08huC8jGzOzZ9rLhcgi4XjiOtoYw74t46yIue0PR2LOeK8uAUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d0nlTH6aFbxLGIHvGDCiOXeh+d/ZjK0Ivl1vqIJhjyI=;
 b=WWMt9gcIjTkTta7XdkOhoUqB1RzLZpJy9pLCISjmiqRwP1pKY71Jm7+Ahm6wjJ7nN77rLMhKO1Gp3tOkvjsv7HNIPGjLN2daUhupes8z1HiQrVGpXFFCWeJbRJ7uPGG7KhlzdPDVk+o9sRalmfUrBpASPgDcZgeL1nB/OhoTtk1/n8Ddm92rFo6L9+GQNw+674UsJYJszP1q43WvvwE132WAX9zea5XNbOyT4txcS3B7TcjNYrJnRDWSi9PWekQJRYiAolRUs7fOOQdOXZ4utkT+q4rawu3EnXLTCRLOQKKpxq04fTmjj92Ohe+1rciq33Dl7q+VDNV5CWfya+ylrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d0nlTH6aFbxLGIHvGDCiOXeh+d/ZjK0Ivl1vqIJhjyI=;
 b=ZXrOO3CPJOjBah975sN+PJpTIpmYbhnudyb/+8FvtnolQ5Nl1Y0lyhwy/hLGYRroOpQDNva/ieyFQjxUf03MLdCKIlLbjZYNgnnq6t/gH3NL0Q5qN9yJ9VRQpGXCTipxoaduHtFuRY8I6qcxKdXnjnbnDv+D4SUb93hPMbkw2mw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO3PR13MB5751.namprd13.prod.outlook.com (2603:10b6:303:175::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.22; Sat, 11 Mar
 2023 12:15:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.020; Sat, 11 Mar 2023
 12:15:31 +0000
Date:   Sat, 11 Mar 2023 13:15:24 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Hao Lan <lanhao@huawei.com>
Cc:     andrew@lunn.ch, davem@davemloft.net, kuba@kernel.org,
        alexander.duyck@gmail.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, edumazet@google.com, pabeni@redhat.com,
        richardcochran@gmail.com, shenjian15@huawei.com,
        netdev@vger.kernel.org, wangjie125@huawei.com
Subject: Re: [PATCH v3 net-next] net: hns3: support wake on lan configuration
 and query
Message-ID: <ZAxw3PWVLiGQtTMS@corigine.com>
References: <20230310081404.947-1-lanhao@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310081404.947-1-lanhao@huawei.com>
X-ClientProxiedBy: AS4P190CA0028.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d0::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO3PR13MB5751:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bd52ace-3768-4d6c-b02e-08db222a4eb1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JkfXZlixsEQODm2afL7FCI7K7VJqWMpJ88IzOlU2ODrUJbHk3fMsVroK/jLGbzi2bnnq1Vge/AW29PD8w/r2cpgpkOPZmeSg1RTADK9jJbfrbzSLFJNuaJvDJrxjoCcuEKmVakU+YD2/i6nFrLfC6//qWhoEAz0q0vgk1KQWLvsKJKXRMl++jY6f8Vp4fMoCcPp0ivbqIOVcBIOPPeoYZFENrXdppiNOE3u3/BcdI4KeC4OHOUoKk1tiXm61NTzWwpduXdBtTuBKkgURqAK0RoYE4rYrYN4X5BBK9UXBAb6fN/Si+TaOkktY19OL6DSb0ajI4mG+C61PPGJNlU2mVn7YLiqajQxd2VtsyUGbVOIQAo8qF7N1IsdjUMAksPUYGdrHH/wijqSXnRDQSXzE8gmdQZ5pQ3Q9LOP98MwT/XOg+8V2ZDc7/5cQh8tx6WhVAQNVNdhYYOwk3wJ8hFnLg3s2qv5+xD8mqAzP8+Tco1stLFNknhrw/woF10iro8LrI76wQiN5eaSDyDAk3/DykXBEiISplhkg9d1nPObHhN7mJUI8ocMN4+EnajtTfXlYCokE4Ndr4fFZHFoQ5soLPLnRM6h42slNSLXqiNDGuiJUIbUBuebheZnb74je24CF/UZGU5xpwNVYA3CmAZiJ8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39840400004)(366004)(136003)(376002)(346002)(451199018)(36756003)(316002)(478600001)(6486002)(7416002)(5660300002)(2906002)(8936002)(66946007)(4326008)(66476007)(8676002)(66556008)(44832011)(6916009)(41300700001)(86362001)(38100700002)(6512007)(6506007)(186003)(2616005)(6666004)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JFwDs8WYQwytPyh8o+XBCd6UdTsf9xqaiVvu45H6SZCVjSsdQDjNmmv1VfZo?=
 =?us-ascii?Q?HU8o5iouD8JhMhTxE4FmlKZgKqshK5K9+3Ivi8W/GNq/ut+vMM/hrk2Rp6J5?=
 =?us-ascii?Q?7WOZ7AKdIkiTPI1YiIKAPFFN8nDWYZ84AqjLtZPAk2OtXMra96+S2CSNPxwV?=
 =?us-ascii?Q?Xmk8szvT6+4pc+VUbO0EYWPUi3WUjrAK5nn+i8Qv/sThDFzDUnRh5Rj+ySKl?=
 =?us-ascii?Q?TgR40sEKFfdAxOm1vzqyfzzOuAvypeqAt+mB+UiBXkn2Iifc5g1YpgBnUU9n?=
 =?us-ascii?Q?ydjYCkaum8lxLAaFILy3oYDCOhTxjO6qbhXAbeYx2eyvhmPJur/7Xzf5qxbq?=
 =?us-ascii?Q?t6i2B9acnp2spO+Jz2TV94JziinKRuCODAK1zGqO5DSMNUd4eCJgD2O4IDKU?=
 =?us-ascii?Q?BBF5HIpuE4u+ep8DlzhxcK3iOwbMB5Iwv1Wosl46E8aW2gZRJ0dj+YYnO4Id?=
 =?us-ascii?Q?CSZuTpO6voDJm2rbgFq/ZXN2g2B6SJSy811poQgRxOdUse170kFt9cTM9wsW?=
 =?us-ascii?Q?d15HAFCvmcXYZiId3b8IYUPa45DRMYGZJsLeLfF6FYeozX/qMdZKHugLx8FM?=
 =?us-ascii?Q?S5oj8GxrVuT6lsZHr20GamVygWhfbA4Cu5fVut5APHLiH7KBPjzKyQaEZ+ic?=
 =?us-ascii?Q?pUMbJkAB2DQhNP6ChaH+RRiwzmbnWPgLi/pMga+HdGGAnV0avr5LTmCosHW8?=
 =?us-ascii?Q?MoYexbnmwoulBvCF5t0UFwF6yrIyfa4tz9w9MMy9K/+KK2LdyNY355YPiSPr?=
 =?us-ascii?Q?ItQivExlhTt4bWsklteDzAQjGm+/qu47QJzB/Hh76fgDGdN8bTmljt3PjZvH?=
 =?us-ascii?Q?aERywoyZpul8jtKQ7UZX2kMi/PLtHQ7bXVK9Qjw8Uq23ToPXRRzf1LYZ534+?=
 =?us-ascii?Q?/pEHMlNnTJuNFSJhV7NdQu2eythMNX+lZ8FBb2PGK55W2wdeoY1wjN22sz0Y?=
 =?us-ascii?Q?MpXc28/VXs4f4znzjgItoyJ99n6YLWwzyP4dU6nEPIbY+Q2+TTmRjnQYaoe2?=
 =?us-ascii?Q?Wi0NscU2oChx5RFExH/ZKms2VVbosJ81LM+HPnpjvrYOn6on+jsvf2Aa5BGk?=
 =?us-ascii?Q?ByRkv6DZ+/gCI/ioyanPlF2teIKgWaLw4NQbSsmmPRB9tIXkyhqYstqsMgmd?=
 =?us-ascii?Q?cXj8Yjm9IDwgaROUaitMdGX7hYOqznYPJ3CsL/WHJPROb4xlsdndeXgxLm3p?=
 =?us-ascii?Q?UhGPhMQEh1f+uqAgZSjYLiQptH5sE9LE/wPHgSbPP0fVHZ/0eQFD2GAda9FP?=
 =?us-ascii?Q?Og/UXs2/J6WyGg9F4/9RT/Oj55HYrEUvWZAYGLocK5dQWuA86535QWUB9p6Y?=
 =?us-ascii?Q?pbd/xVxDJnHEu+PdYf3tCssC2tUt7+TjGgP+ZfSM6cF+lI2Xwq5wJBW2XZ7r?=
 =?us-ascii?Q?iC6lzBQGePveOuEsIq1FkcXXfkZg9M+7HXiosO/GkYyMZqs7P4qOPoUZYNmv?=
 =?us-ascii?Q?QPUV/qY+7z4lNB9H+dHoyOVLRuQHabCBcr6jQ06RSTPJIlWhWRJcDTyNtZQy?=
 =?us-ascii?Q?LXz0cMwYBLayNSC6Y1n0S6Czu8blNUvlZzTnrCcnRwTEUe/DSMCIHYFIIY5i?=
 =?us-ascii?Q?J8KaK6twFih5t+5FbQfG8PZtwBVjqYMwL4AHBHHVPXnxP2hki8glI8cxY/l9?=
 =?us-ascii?Q?B392zQlLkw7yiTQxOcubdFcNE7CRc3QeBZ6ig6my6oszRdym9nLmHqMJp1AT?=
 =?us-ascii?Q?T49slA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bd52ace-3768-4d6c-b02e-08db222a4eb1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2023 12:15:31.2619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fia7AjyH75VMRub/G48ummI460mznESMMPY5vR7OFSUOUC+0V3sW1HpcNm428ax3DwRiBxITBEtMinLUFkAaQVUr8UGnQ8HnAedOTQWcvBs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO3PR13MB5751
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 04:14:04PM +0800, Hao Lan wrote:
> The HNS3 driver supports Wake-on-LAN, which can wake up
> the server from power off state to power on state by magic
> packet or magic security packet.
> 
> ChangeLog:
> v1->v2:
> Deleted the debugfs function that overlaps with the ethtool function
> from suggestion of Andrew Lunn.
> 
> v2->v3:
> Return the wol configuration stored in driver,
> suggested by Alexander H Duyck.
> 
> Signed-off-by: Hao Lan <lanhao@huawei.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

...

> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
> index 55306fe8a540..10de2b4c401b 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
> @@ -2063,6 +2063,31 @@ static int hns3_get_link_ext_state(struct net_device *netdev,
>  	return -ENODATA;
>  }
>  
> +static void hns3_get_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
> +{
> +	struct hnae3_handle *handle = hns3_get_handle(netdev);
> +	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(handle->pdev);
> +	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;

nit: the local variable declarations could be reverse xmas tree
     - longest line to shortest line. One option being:

	const struct hnae3_ae_ops *ops;
	struct hnae3_handle *handle;
	struct hnae3_ae_dev *ae_dev;

	handle = hns3_get_handle(netdev);
	ae_dev = pci_get_drvdata(handle->pdev);
	ops = handle->ae_algo->ops;

Likewise elsewhere in this patch.

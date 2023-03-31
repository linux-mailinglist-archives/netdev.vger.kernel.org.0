Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 858CF6D298A
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 22:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232718AbjCaUib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 16:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbjCaUia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 16:38:30 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2111.outbound.protection.outlook.com [40.107.93.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 234BB1D863
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 13:38:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UeXtJTz1kOLRbiojUR4EiDmojyfhSUaMr7VV7vHK/r/g2vYYUdV6d2AA8wveGYDRCFhoCDgSNcgwofeca2w2eiLwZ0+4MzbmYNKtEcrpe9yagSpUx4Do9BzWrO9wF8CK58PoPFGYirr2wpe3X2RrbFAT6STnMW99duXiDCEByWTnKav7wyOop23FhSSDcgnQZ8ub6s794dCtg4oT5stD3pLi4RUIrqSHePoGYP2y/RtgJipBhl7nhiy++jmC1yN3rXlqYihT127Rnv+W1r/8f5Moh+Jd8iLdEVItCo0bPysbWPvcThb1kvpp56xD3sAAHQthVKXWrXrdyVYM8sJCSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RmOggmyv9TtkRk3DYCtwpIDf9aEYepM6gN4WappJHkM=;
 b=H9R4tJXMMfYeHAmdeSTZMkcH4NX/jNed0GeUovxxJHBbScuLozENhFwEI9ybbBbvOOnizLYSPdOLCcrjjRgSrpFQMCw2YdaXkvoJTYhEcb+F7vEI7hN2cP0jXz3OA3kmCHbBGLLqaCv00Vwy2a3frwWW4QBv4llzDX0SHBoWUxapUWH/cDaZ0Tzj+G7hvYMSI4uAdKYi1RmmhEBqOexLi/SW5V3Hv/ZZUqJDCzUM6yewa9S8zUsNgQzZJvIVQUAGzVo0tE8vG8H+I/fObG5ymFT1X+FM7wrp/QwlzdjBGZYT/UHIbOfgYXYR9Y57q2YjoUfY/e0QOlHEJBwTbOUqvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RmOggmyv9TtkRk3DYCtwpIDf9aEYepM6gN4WappJHkM=;
 b=pECCs3OTYCj5SkUsoAb8kuxu80tlb1rxqWR3uLvs/R5eQbtPM68sEzX+ZZXhYgWySwG6XzT3FYLycb5unPW1nnhHtFiHzh3sKV2WRP4rVK8up7GVem9QcuE/VVnGrxHCxfkG7q6GfpHqg10kDZMAXaSpWwOmTTxw7MlURMy+r68=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5288.namprd13.prod.outlook.com (2603:10b6:a03:3db::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.23; Fri, 31 Mar
 2023 20:38:25 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.021; Fri, 31 Mar 2023
 20:38:25 +0000
Date:   Fri, 31 Mar 2023 22:38:20 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 1/2] net: ethernet: mtk_eth_soc: add code for
 offloading flows from wlan devices
Message-ID: <ZCdEvEJTJewWnuU9@corigine.com>
References: <20230331124707.40296-1-nbd@nbd.name>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230331124707.40296-1-nbd@nbd.name>
X-ClientProxiedBy: AS4PR09CA0004.eurprd09.prod.outlook.com
 (2603:10a6:20b:5e0::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5288:EE_
X-MS-Office365-Filtering-Correlation-Id: 37e2e014-b7bf-47fa-dd5a-08db3227dff5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WC7niwMjxaDpqThN5Q7SrYJC4R0oIjrgWQCm9Ftr9ekrMopi/dtt62PADwldkkNHxojTixFYoPW6Qcxt0yCm6HWErxryUHobQT4jbnhEF86JO+fknxjud4ui6DCaFZ4fvHe43HfWQOND8nqd8Pc9bcFibwwDwL9feHkk6GUemlz9CHvSsm4Xhu0tri7aRBc7pnAI9NAsyHKIk/9dOvWoe8I614QPveE6XtxVgCcOHfA2ocHdpqErcDN9sIA01HuBx4GYZwzth2ihY+3zXMaWGCyPHy66oA2kPPUaVv2SBWVQ6qfJSWHCaLErz5afzmqrpVcXwjBsGBUkMwls42K/JvJ5euN1+W2Le+H8xzBCCpTXht4tEkEf9AgAwrePzvzSgGB2v/KFYaD27k7Cl32l47ChdD7I5hGfBQ4+fhlojxYy0Pje1938U03lc2Qie/Nhn+heCwxcwDX9VyupU2N5/zg2RLhqg90Q4jcnchxaqIpP3LjkC3lPI8Tfg2Pwz1+s2J/GyaXBDQmxliF4mSyaBue+jEASAAv1VNo37jUewiAEhY+eJkIexbNTWwkxQihR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(366004)(136003)(39840400004)(396003)(451199021)(6506007)(6666004)(186003)(8936002)(5660300002)(6512007)(86362001)(44832011)(66476007)(66946007)(316002)(2616005)(478600001)(83380400001)(41300700001)(66556008)(2906002)(36756003)(4326008)(6486002)(38100700002)(6916009)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1K0fPKKEVGUbzWodjbH1vbat+5oJcXUKizhI3MDMNvgOh/XO5Y41Pt4TV+Vy?=
 =?us-ascii?Q?n0ZVJcBd0vQ5Ziv5F6D6FfbebrzpBc6x2zyqRdSAtK/+IyotvtJu7fRiIWAe?=
 =?us-ascii?Q?5g1TQz6Avyj/D1P6OZHz0ho1rX/mzpeIcOzkF2C2bsX6GEV6ALjSm96MiUS4?=
 =?us-ascii?Q?7EpGiOylv+sUrkf/E4moj/wNQ5qj6TIPcTi1vMZS+TWawCxjQJI3EkBn4bgW?=
 =?us-ascii?Q?RBHb7HFdntQPuUUzA/umTECbRA1nwQJAjX3A5EPtYjKy2LVyzGryTN2tH80s?=
 =?us-ascii?Q?30/BBMxYC7ArFvAl/MC9wBV4rsWE2s+7x8mg/YjH0/dhO0A0PkwdsKGOLrus?=
 =?us-ascii?Q?/eikucEJkgqdtGV0mx1Y2j5mmIr23aXWIh75kwhKARdK0Qx1mg/fsx/UYxsY?=
 =?us-ascii?Q?qP0+FOuJ34OFAo3LFpL4SKQSvgPoDjJi3Oc4udN9JGxw5IKChSMQdo4QiClB?=
 =?us-ascii?Q?HTG0Li/2lhwFRLHOzpEKcvw+sOJKH/IQxRpVU4rj4VLMBoMNvVO/R4Nxi5W3?=
 =?us-ascii?Q?mrc38kUXzzlBKFkZgbgylu76kOhIkir2qiEEo2Rf8m+ldCb2qGCRE3Y8AuWt?=
 =?us-ascii?Q?9kOiT4nHE3wBCqeziaFoF/93QkfgGhb7q4A+zFmmafDgST4mwhs1AN6xwksd?=
 =?us-ascii?Q?GZ4Lz5B2lhl1xu4ft4YGy1xjE5h2W+guly/jpRO56VTSa1rwFYaGxqX5vq5I?=
 =?us-ascii?Q?XLTDZqsyJji1frXvUU7o3/h+WI7KV3mze2FxaX11CggfKOC0iM7k78DAY9Wj?=
 =?us-ascii?Q?OnUwUV5+URALpvpkHQbCodZdnWhJ2/jPYBp74kQypzRt/qIn0tb/ZDPlgyeF?=
 =?us-ascii?Q?vnBOvSQgLCIj11B3Lhmbs4hWM5+QO71FwFVgcM/mtnmxLCbdsdcSrQp01/bC?=
 =?us-ascii?Q?VKvFnRxhCZFkwkAnAFPi8hUNifXtOue4jqhovHpeKxZwJRyf1WuhWiAyaVIw?=
 =?us-ascii?Q?dLF3PNByyEFPBK9PfHQguNH2xhqSoBVKc1QsqIAcMYU427gSV12YvIdVuJGp?=
 =?us-ascii?Q?HaWN1ATo9w1ZuoWq1XfgQ7CzUXu7HKqu3pxNq4m4QeDxQ5HtnXXVYWUbMAEV?=
 =?us-ascii?Q?/fwzuaaDdDKp89AwPFC5mWj/nIj2VkPGN3m4hB88vXbpDQFTR+12T5jeq8tP?=
 =?us-ascii?Q?gQhlxQ+wUZqBgynj/C83C7Tsr6VPyoGLKyRuInhOa2Nu7c4AUKDTwoKtOEBX?=
 =?us-ascii?Q?EZ8bmM3YYoBOG1nG7fDmBV9kG8kH3GxPF0nXsKjYUs6VaK6LlcPSZuBLOdTh?=
 =?us-ascii?Q?PIKoO0iSdo0QVXK0AD4hXAYcoOjF+Qml5moJjVynMfWk6xiiATUd2xv19v4N?=
 =?us-ascii?Q?hKa/vdJ2jTQE4+0Xtd9ZpDsgRMVGq7U8w3ZxBRDHSjZaZxO5Ifk7mrciln15?=
 =?us-ascii?Q?1qDNzveXjOVV/66trw3NK0fmtszf/7jn/ZWg/RhBfyIhHxMwGf8GJ4UfDgLr?=
 =?us-ascii?Q?fglwYbowXhCRMtrniytbI3JsTqRDJDAqSFP7b3amJIF9NcvzcAjWqyl2cbHf?=
 =?us-ascii?Q?Ce0L/MzT0JYsMtcHVdZbByRoIgfomcOGZ81bX52ZFZN5horfNwXsfpWjcE/K?=
 =?us-ascii?Q?XflLairJztxI0R8nnHxBM75CKKEDgO1lBUiOXM8X/Nwdl5ucq/oem7nUgK8+?=
 =?us-ascii?Q?/DhwSDGn/DePJraJlnzg4d9d99c3jWQyGrUjyQxOydMoOlz3A2JqbvBwPqxA?=
 =?us-ascii?Q?2bClHA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37e2e014-b7bf-47fa-dd5a-08db3227dff5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 20:38:24.9776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ej+WxVsVBrso8jkllS2XE7/yJ/YV+4UDGmiPGeiuGiWMo4bivDJ3VUEjucUcBZ8zjKsc69GEs8+cS87PWoXV8NRkDvM/8LNNDZziqi7QxxM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5288
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 02:47:06PM +0200, Felix Fietkau wrote:
> WED version 2 (on MT7986 and later) can offload flows originating from
> wireless devices.
> In order to make that work, ndo_setup_tc needs to be implemented on the
> netdevs. This adds the required code to offload flows coming in from WED,
> while keeping track of the incoming wed index used for selecting the
> correct PPE device.
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

...

> diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c

...

> +static int
> +mtk_eth_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_priv)
> +{
> +	struct flow_cls_offload *cls = type_data;
> +	struct mtk_mac *mac = netdev_priv(dev);

This does not compile because dev is undefined at this point.

> +	struct net_device *dev = cb_priv;
> +	struct mtk_eth *eth = mac->hw;

I would suggest something like this:

        struct flow_cls_offload *cls = type_data;
        struct net_device *dev = cb_priv;
        struct mtk_mac *mac;
        struct mtk_eth *eth;

        mac = netdev_priv(cb_priv);
        eth = mac->hw;

> +
> +	if (!tc_can_offload(dev))
> +		return -EOPNOTSUPP;
> +
> +	if (type != TC_SETUP_CLSFLOWER)
> +		return -EOPNOTSUPP;
> +
> +	return mtk_flow_offload_cmd(eth, cls, 0);
> +}
> +
>  static int
>  mtk_eth_setup_tc_block(struct net_device *dev, struct flow_block_offload *f)
>  {
> diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c

...

> +static int
> +mtk_wed_setup_tc_block(struct mtk_wed_hw *hw, struct net_device *dev,
> +		       struct flow_block_offload *f)
> +{
> +	struct mtk_wed_flow_block_priv *priv;
> +	static LIST_HEAD(block_cb_list);
> +	struct flow_block_cb *block_cb;
> +	struct mtk_eth *eth = hw->eth;
> +	bool register_block = false;

gcc-12 with W=1 tellsme that register_block is unused.
It should be removed.

> +	flow_setup_cb_t *cb;
> +
> +	if (!eth->soc->offload_version)
> +		return -EOPNOTSUPP;
> +
> +	if (f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
> +		return -EOPNOTSUPP;
> +
> +	cb = mtk_wed_setup_tc_block_cb;
> +	f->driver_block_list = &block_cb_list;
> +
> +	switch (f->command) {
> +	case FLOW_BLOCK_BIND:
> +		block_cb = flow_block_cb_lookup(f->block, cb, dev);
> +		if (block_cb) {
> +			flow_block_cb_incref(block_cb);
> +			return 0;
> +		}
> +
> +		priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> +		if (!priv)
> +			return -ENOMEM;
> +
> +		priv->hw = hw;
> +		priv->dev = dev;
> +		block_cb = flow_block_cb_alloc(cb, dev, priv, NULL);
> +		if (IS_ERR(block_cb)) {
> +			kfree(priv);
> +			return PTR_ERR(block_cb);
> +		}
> +
> +		flow_block_cb_incref(block_cb);
> +		flow_block_cb_add(block_cb, f);
> +		list_add_tail(&block_cb->driver_list, &block_cb_list);
> +		return 0;
> +	case FLOW_BLOCK_UNBIND:
> +		block_cb = flow_block_cb_lookup(f->block, cb, dev);
> +		if (!block_cb)
> +			return -ENOENT;
> +
> +		if (!flow_block_cb_decref(block_cb)) {
> +			flow_block_cb_remove(block_cb, f);
> +			list_del(&block_cb->driver_list);
> +			kfree(block_cb->cb_priv);
> +		}
> +		return 0;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}

...

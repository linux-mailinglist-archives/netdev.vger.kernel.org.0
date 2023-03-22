Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52FF56C4CDF
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 15:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbjCVOEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 10:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231286AbjCVOEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 10:04:38 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2100.outbound.protection.outlook.com [40.107.92.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A42F55516
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 07:04:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ro+fhHenSerAx9E/uE8eH/LrGQv31lfzt6Z9k1leZ426x66NJ1/HyzLNBlBuGInMvRo2JGmqGVc+34w+K/YzPD8Cx6iIr6taMfYVsd5Y9S7ACEHIL8O7qj6uO0xcLjuGTExXNG802391dk+ggpT7+FSggWXb0ezUJC12fRfO1iG4lBNnhxIN3QMyBUeAAuzv1VibZRdlR9IQM0xtNnJhuop73w7HpO5xoBYDNCogoFr4okhjH0Z/Lx6wTAy+oGsWu1ZoP6Z9gneaYAUBVKUEnEZE5vlIX6YyJ2MBXFIuwvJt/uWFwCE4gRdPPV3jptaZaxxPTJQ5lNU02e9WZ9L0Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5lqL/3B6wqeNmb8yJRi3z1fyJdlHvfWcgK5y9p1nhB4=;
 b=edIEAUc5o0uQ8ShLT3NQHwCzhhPTrbOTuzCzoBfzUafUynYhoonW9f5uPvDm9skgO84HzIoACDDs6Aqvr8aQBiZK1DSlMzqROafmK3oKdETNkr41hQfXV7hxBy33JQL3uLMMzkUEtSk1Sub2JC45NIo3P1pxgxPOhe90clttcAYNXPmqwdkUGwK+4u1vdei0a7A/luyt8bIWcMabAFTd4dGFU2rtsjeGfH4QDuFc0BG5tAejLazg46KDboKK2P82uyhHB56gn0RxgymfGPJkRi9+6CVJeA+sgp8sJkVk0hdDrWnHY2sSkCh9QgogMntRVzJg2F47KP05Byt+nRb7kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5lqL/3B6wqeNmb8yJRi3z1fyJdlHvfWcgK5y9p1nhB4=;
 b=sXQjXxW0ywQr5PtcAeEeJO9dpM8W/WqjYmEbper9xAQPQTlh0G0medgq3iW3h1lDwWGZ3j4J/KfEY9zOtBFk2Qn0yY+JLS9HtRjrL0cUGkhJW5EdpJS5FF1jlFAhUzPyI1g32vpCXm6e9oUWEavO9UBqWhFyYz4Ln2Qq6aROrqU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5304.namprd13.prod.outlook.com (2603:10b6:a03:3d5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 14:04:24 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 14:04:24 +0000
Date:   Wed, 22 Mar 2023 15:04:19 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: ethernet: mtk_eth_soc: add code for
 offloading flows from wlan devices
Message-ID: <ZBsK46vmNtjxJZH6@corigine.com>
References: <20230321133609.49591-1-nbd@nbd.name>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321133609.49591-1-nbd@nbd.name>
X-ClientProxiedBy: AM0PR06CA0131.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::36) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5304:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d6e2812-63a7-460e-2913-08db2ade5754
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e1BG/RYepJBCG/hbU5FIWOU6cJ0mioZMM9SSL3vSWKs0evvyXs2/R9T7oy6PMYadw8NpynsmqQv1iYLDeifFR4o7cAzTuXsPabAm/45/RJOEr1IlXe7AEmEfFtu2WAnZFoNikwxeb1LvuPbJaqwcQdF/Dx/pOEA3PwBfjAClqL50OuJDpWatvqvc9nYgQrMKvalrC9L2P8wqHu8ikDh78BsSxFiKIg24YSC85/wEg7FJ6Vs6R0jtHDb6CRX99s7VNaUqjkMx7k1HfCA1GXHpIMtrnnplJtb85MkJ3d7GTNfl3m6QsD4adxQeNLhZV3EHXCuauXEAS9urFp71ymfsqn9MiwzXVtmRkG+LzupxTykjjlUzTnFGIipJEm6CxCbJmT63QPMCR6HM9+GpMK2AUaO8cEnxsmZs8ArJGs8JF7sq/gikSUH0FDCgrDIe3pQFOOhqMfNBXkGVZXriYGkD6K1hfWeDYmrWE0FJQfq0INHNJ1OgDbLQaSjav7SKfmrVrupb6B3xB4iue9e7PAavq9OP3Ib+L69X08NnpVynNrUt8EaUBU+c7T1UEkKDaXctmrlgmDbvdBe5C53WnUEtSJGEMUUG0Veoi1tzI32YtpZGMLAAnhtHjB1LZmIhpULP7jumrvxL0V+rg+IzsFIwNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(136003)(396003)(346002)(39840400004)(451199018)(38100700002)(6666004)(6486002)(478600001)(44832011)(5660300002)(83380400001)(86362001)(66556008)(2616005)(8676002)(4326008)(66946007)(6916009)(316002)(66476007)(36756003)(8936002)(6512007)(6506007)(2906002)(186003)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z1PdPduHzUg2OX7rTbSFUU8Ls3Qx6iqgerCQXirTZ/zbRz+GMhC6KnIvApYs?=
 =?us-ascii?Q?kdxHcpV7sAtU6JEQvYl0eg0axCQsaBiR+smbiL1FgB/X0reUrivyNdyNo9UN?=
 =?us-ascii?Q?Z4nCXm9iRweXHpPdN5r0P2C9HwTh7szwJzDxzlncLOE7w8oY9hNSJnr7IduM?=
 =?us-ascii?Q?0bxZwXZLlAMzov0IXVxdW1IT8p3ym2VtkJlp0/CBZPy8A0gDZqhcutZTA8D1?=
 =?us-ascii?Q?aCHJbpvOMg6dVSrJMqcPjiemtqjaJ6QmhAZoiDx96xhU+SO5S56Tkhn5jzTj?=
 =?us-ascii?Q?ke1GXj0f2WGaHTInMDxHlcgDwMCUeEhFQAVooTi+rRLE3idqTld3qwDGoUU6?=
 =?us-ascii?Q?J0xqiNzwf3MtlihDKVBi4OMuP+s0pmmynOg5WNVZEQ3xr/B2KJDki1hd+hi4?=
 =?us-ascii?Q?PrYkh5LDAAT5TM4H9ghrG7Afo0Ulv15+buMekG6gER58SWPTVruNvZm3UoIz?=
 =?us-ascii?Q?hMZAobG9K07pECxIgpyJfunbezckfsM79AFmClnUJ6QR84K7wik/L9wybR+4?=
 =?us-ascii?Q?ZCo5kJY8HhGQNXHJaDXjz92xjKVNCh+XMmgd42nIJlv9n/AAribhOZAIKX/j?=
 =?us-ascii?Q?mpDhGQq/8xXOot+gdYXZf/xNlejDR0wkbqJoupsA2PB35A+m8ZRqssRgQnBS?=
 =?us-ascii?Q?3Dd6DM8/LmGAWSnqqn3uR5mer+peu4zJ/k8LkcQBEnTqDN9gqZKnvgJxQdj3?=
 =?us-ascii?Q?SSSYLL6Mz/5s9EqyhiiSPkVAi96m+Am5scgNb1IM4R6Hpz5Uqs8Y1xONUzmf?=
 =?us-ascii?Q?Cq+nLEiAVrgrqqLXYP8hCuYSX/2JTlDCJcMxe0fETgcwMbvEjyfQ7Tl9lvP8?=
 =?us-ascii?Q?J2e0AAIQ0MnBNFmXCDUIXEQQOoOCYBQSmjU/hHJFPzr5SLzhN5vOOOBeMUep?=
 =?us-ascii?Q?MI2+2ohj+yem3xRZZ7uzgad84fLhLYThrh1dvj7yqQjRi36N2qxSzTe+tL3q?=
 =?us-ascii?Q?Sp/OwH5TpkTl0Kf31hr9uXXWGHpaJRHiiGOnvSK4kMK9tFg8GSAMuua8bWOa?=
 =?us-ascii?Q?OYRo3ORX4soz2tJ6C9cjs4MooViJK3+R1ghBuhmg7PEKVNqU0XPIF4MG9baP?=
 =?us-ascii?Q?hFoleLvucQxPeYq4/Xyc849iPbXtnOkJ4Ra8a0Tnp3Vee/c476CasoaxcyQu?=
 =?us-ascii?Q?l9y5AfTXmh6Auj8uphEZrDF73t7VXhwsHaYqYoT9LJTNB6Mg1/F4NaYKTJgG?=
 =?us-ascii?Q?RNrsg6pzXW4ZXQRy9/1LlU/qyOIFRvl2NxouWJPwTFnzURQGmCvixixvTFxj?=
 =?us-ascii?Q?3Q8SCVoyXYD3BoMaHzQFul10CRB6pOSMFq45CRKLEL5xNRuDVHvC9OeugRKe?=
 =?us-ascii?Q?medbTKWeVe3i394ZGmtayPjYVHGsAfKKahJO1cM2fIA++Sc1/ydK+F0AOPDw?=
 =?us-ascii?Q?Nr+84gzKBfSUDW9iaDkuLuB9CDAAmEV6+LWUWdnSXqZL3qfXH6JSjYRisR8r?=
 =?us-ascii?Q?yQQ48APZ7WvDiAXgk2FerykefG/Ngs0bm4xTyxj44EZTWok8yI6R/CF8u7ek?=
 =?us-ascii?Q?f9f7OCBVUI3R8x2u/wXs+zdZMwy1MFL8lTysvbggDTp73uuKEDetLaXL1JB8?=
 =?us-ascii?Q?61O0608pzL7BCI+/GyFkiB8V7yhBryJJcNnRj20iw8Fon4TWccUbwIDcCzOt?=
 =?us-ascii?Q?Qc4OcrFwjL/spS1dcT4bHtcH/2+KoXFnOHjkD+a2DsaVp4CfKV/DuKbnHVSE?=
 =?us-ascii?Q?YvjBtw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d6e2812-63a7-460e-2913-08db2ade5754
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 14:04:24.0858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0wwa6l7DBEXM0ojq4Aaobu7DmHXFtRDrlmPdHvvzJiCClt2ybZKobUs1zJxUZFfdcCxqjbJ4q681Ymc5QK4tiB7Uu7FMWd5EgYVYOsUvyrE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5304
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 02:36:08PM +0100, Felix Fietkau wrote:
> WED version 2 (on MT7986 and later) can offload flows originating from wireless
> devices. In order to make that work, ndo_setup_tc needs to be implemented on
> the netdevs. This adds the required code to offload flows coming in from WED,
> while keeping track of the incoming wed index used for selecting the correct
> PPE device.
>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

Hi Felix,

A few nits from my side.

First, please reformat the patch description to have a maximum of 75 characters
per line, as suggested by checkpatch.

...

> @@ -512,25 +514,15 @@ mtk_flow_offload_stats(struct mtk_eth *eth, struct flow_cls_offload *f)
>  
>  static DEFINE_MUTEX(mtk_flow_offload_mutex);
>  
> -static int
> -mtk_eth_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_priv)
> +int mtk_flow_offload_cmd(struct mtk_eth *eth, struct flow_cls_offload *cls,
> +			 int ppe_index)
>  {
> -	struct flow_cls_offload *cls = type_data;
> -	struct net_device *dev = cb_priv;
> -	struct mtk_mac *mac = netdev_priv(dev);
> -	struct mtk_eth *eth = mac->hw;
>  	int err;
>  
> -	if (!tc_can_offload(dev))
> -		return -EOPNOTSUPP;
> -
> -	if (type != TC_SETUP_CLSFLOWER)
> -		return -EOPNOTSUPP;
> -
>  	mutex_lock(&mtk_flow_offload_mutex);
>  	switch (cls->command) {
>  	case FLOW_CLS_REPLACE:
> -		err = mtk_flow_offload_replace(eth, cls);
> +		err = mtk_flow_offload_replace(eth, cls, ppe_index);
>  		break;
>  	case FLOW_CLS_DESTROY:
>  		err = mtk_flow_offload_destroy(eth, cls);
> @@ -547,6 +539,23 @@ mtk_eth_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_pri
>  	return err;
>  }
>  
> +static int
> +mtk_eth_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_priv)
> +{
> +	struct flow_cls_offload *cls = type_data;
> +	struct net_device *dev = cb_priv;
> +	struct mtk_mac *mac = netdev_priv(dev);
> +	struct mtk_eth *eth = mac->hw;

Reverse xmas tree - longest line to shortest -
for local variable declarations please.

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
> index 95d890870984..30fe1281d2d3 100644
> --- a/drivers/net/ethernet/mediatek/mtk_wed.c
> +++ b/drivers/net/ethernet/mediatek/mtk_wed.c

...

> @@ -1745,6 +1752,102 @@ void mtk_wed_flow_remove(int index)
>  	mutex_unlock(&hw_lock);
>  }
>  
> +static int
> +mtk_wed_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_priv)
> +{
> +	struct mtk_wed_flow_block_priv *priv = cb_priv;
> +	struct flow_cls_offload *cls = type_data;
> +	struct mtk_wed_hw *hw = priv->hw;
> +
> +	if (!tc_can_offload(priv->dev))
> +		return -EOPNOTSUPP;
> +
> +	if (type != TC_SETUP_CLSFLOWER)
> +		return -EOPNOTSUPP;
> +
> +	return mtk_flow_offload_cmd(hw->eth, cls, hw->index);

This seems very similar to mtk_eth_setup_tc_block_cb().
Can further consolidation be considered?

> +}
> +
> +static int
> +mtk_wed_setup_tc_block(struct mtk_wed_hw *hw, struct net_device *dev,
> +		       struct flow_block_offload *f)
> +{
> +	struct mtk_wed_flow_block_priv *priv;
> +	static LIST_HEAD(block_cb_list);
> +	struct flow_block_cb *block_cb;
> +	struct mtk_eth *eth = hw->eth;
> +	bool register_block = false;
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
> +		if (!block_cb) {

I wonder if this could be written more idiomatically as:

		if (block_cb) {
			flow_block_cb_incref(block_cb);
			return 0;
		}

		priv = kzalloc(sizeof(*priv), GFP_KERNEL);
		...

> +			priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> +			if (!priv)
> +				return -ENOMEM;
> +
> +			priv->hw = hw;
> +			priv->dev = dev;
> +			block_cb = flow_block_cb_alloc(cb, dev, priv, NULL);
> +			if (IS_ERR(block_cb)) {
> +				kfree(priv);
> +				return PTR_ERR(block_cb);
> +			}
> +
> +			register_block = true;
> +		}
> +
> +		flow_block_cb_incref(block_cb);
> +
> +		if (register_block) {
> +			flow_block_cb_add(block_cb, f);
> +			list_add_tail(&block_cb->driver_list, &block_cb_list);
> +		}
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

> diff --git a/include/linux/soc/mediatek/mtk_wed.h b/include/linux/soc/mediatek/mtk_wed.h

...

> @@ -237,6 +240,8 @@ mtk_wed_get_rx_capa(struct mtk_wed_device *dev)
>  	(_dev)->ops->msg_update(_dev, _id, _msg, _len)
>  #define mtk_wed_device_stop(_dev) (_dev)->ops->stop(_dev)
>  #define mtk_wed_device_dma_reset(_dev) (_dev)->ops->reset_dma(_dev)
> +#define mtk_wed_device_setup_tc(_dev, _netdev, _type, _type_data) \
> +	(_dev)->ops->setup_tc(_dev, _netdev, _type, _type_data)

nit: checkpatch says:

include/linux/soc/mediatek/mtk_wed.h:243: ERROR: Macros with complex values should be enclosed in parentheses
+#define mtk_wed_device_setup_tc(_dev, _netdev, _type, _type_data) \
+	(_dev)->ops->setup_tc(_dev, _netdev, _type, _type_data)

include/linux/soc/mediatek/mtk_wed.h:243: CHECK: Macro argument reuse '_dev' - possible side-effects?
+#define mtk_wed_device_setup_tc(_dev, _netdev, _type, _type_data) \
+	(_dev)->ops->setup_tc(_dev, _netdev, _type, _type_data)

>  #else
>  static inline bool mtk_wed_device_active(struct mtk_wed_device *dev)
>  {

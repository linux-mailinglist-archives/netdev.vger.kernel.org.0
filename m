Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CEB96C5755
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 21:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbjCVURw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 16:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232298AbjCVURh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 16:17:37 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2070e.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::70e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0015D268
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 13:08:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X7g6AU0c4jjOlZmvo9quix90cl3ufwNdHmWmbt/RJ8uv71AlG2lWmkina6HWXVCrWiAszncmX5qCWFBrQp9BCHQXynI1vz+TzdJcOPAC8IRZeLCDLY33kcqmY/HYoFZkK/zw8pcJbUxjc2XILDRvti2HK461gGjngl5HetpiauOmqSMPCta4MAOsYbun9klaFJReZZu5sVXJ3ArzN91LwNvspg0sh7uebJVGb+2fW0W1qSQLSLcysTWSAqLEGiesbpGswbxDRY2ToY+IyU+NT00VbR5Wb1OdFJs/dXD7gMCXA4hJBUrSK5l9S7PanWFvZyzTajvs54IiZ25n3rfqoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ssCH2dMajs7EvIIXTH5IbnSK4zb7fIrKf92X59FPX9w=;
 b=Q/5e/WBfE7w7gGwVr61cRGG4xAqEv+7XZuvQh5Nk8q7RJVDBJhCmtRGIJpDuGjxtFhCGfTEehgnZxKg5GpLOVxWmAXfhRr3CRhe/xExEdZo7gQDWO4IDXyqE0+yuVdmnk5BgsRDiS4t23uyjXCduYAHhPt5xMBab9FDxzaXQCXK8bnlWweA4s/J5o0k0QenEakY9QiY7GlK2PepCWl2Nl2Ow51F9RoHFe9KhJ6Z+L3d8fHNVF7wCD0EcSloZyiGv6weibt3n60BbfxLZfrR4+X2jRYhiainOcCfpN5qL+Nr7vJw35dcO5IgYj0HfrrWf8s44J1Uym55zqmBh74gzRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ssCH2dMajs7EvIIXTH5IbnSK4zb7fIrKf92X59FPX9w=;
 b=bEyjvOnuIm+3Z6Fe6HrVTe6/xf06+luCS/qEuF+kuU7itSWi9H43OdHmxO9kaMFBgQuzF1ZcMXN+AAjcweF1QcF+bXrtVOZjqVqH0uUowJVBRa5pOdi/u2pxoIYm3KK1oCbJsaz7463uuqi1Ofi+kMRe+++0o+Z3gBnBNZNfkzI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5286.namprd13.prod.outlook.com (2603:10b6:a03:3db::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 20:04:50 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 20:04:50 +0000
Date:   Wed, 22 Mar 2023 21:04:45 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: ethernet: mtk_eth_soc: add code for
 offloading flows from wlan devices
Message-ID: <ZBtfXe5mvfIr/a8z@corigine.com>
References: <20230321133609.49591-1-nbd@nbd.name>
 <ZBsK46vmNtjxJZH6@corigine.com>
 <cbded874-8fc7-0ba5-89d2-20a09809364c@nbd.name>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbded874-8fc7-0ba5-89d2-20a09809364c@nbd.name>
X-ClientProxiedBy: AS4P192CA0006.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5da::7) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5286:EE_
X-MS-Office365-Filtering-Correlation-Id: 487463fb-e416-48b2-2ba1-08db2b10b14e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7ZN2Iv/ejZ7TPeNlSbDjy/lgWozGXNZLshrRLdAqJx+HYsIk/H2Y1z4BayAnCgY4m+F4s9dR+S+zp4I4wk0T9avTaIagyed50h4utPee8NCuAfFYAJgJGRvZ5YJu0hdwcBwMzHNj2MMkhEKHLOq2qndnENaOGMTwA3LzrrZbT4xITGkCaReB92+N1S7q9jgyenADyQaFLYqN3ScEd7PyHfZRHX9iDg6wDH4f7OD9O2ne+b8Kj9EnjBUaw2lVoL+44bu9ckFXjqEKFawZC23v/wQ7xX1YvMPryj7RfUnAOkGWH4Buc0B7Yx/MHpnc+Nyb7KlhcEC7vVjR/lbKJjoWbO61dL+QzAYXrDNB6XejTZteCr7b7Bhfs2BxiyfaLaW/ISPVPmdHZT3OyiYZcLMPVqCplSArA6+rmbACE6+skwdurGbhnITplR+RD8MhIuaxonLPWEKSOWfROV8DQTNHRfYhfuVsNZqoDwM3VMOcyF/2iw8uyGOubcUn84eragph38Hg2/9zeDirD7FgM3zvwi4Ino7eZ/SFjspmNT2GIQcqK1/0P/dUssAmpzTCNaQtHKuFg5VQovJ7czy2SxvxQfGttVH04iUklq0Qb9SKv4wGycb90BO0k+LiDEyLN3DeofZDBnkd4gwjBrQtgW+0FJPJ5F7ZxYy2ORNWo5wzX3saz5I+EF6rdgIShQXR0LmC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(39840400004)(346002)(366004)(376002)(451199018)(2616005)(6666004)(186003)(6486002)(4326008)(83380400001)(478600001)(6916009)(66946007)(316002)(66556008)(8676002)(66476007)(6506007)(53546011)(5660300002)(44832011)(6512007)(8936002)(2906002)(41300700001)(38100700002)(36756003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3MY6t2xPHOK4DczqAdr6jdKAybUj7crmNTSNJLmE1ZxLJCOzlEBVzJ2nYaOV?=
 =?us-ascii?Q?CSgmDLplLLv7GMPFPKhI4BJ2dbClIJYH9IEMrYNmHWTz54AsofFxnbGRhI47?=
 =?us-ascii?Q?XCWypIDV1T8ZkmIG0/+0cYUDWsltj5s1NiCMFFWDBqs/A5abJJswwjIVbp5y?=
 =?us-ascii?Q?TKYOMNzY95Xc4ctee4vhwd1WKKFuuIIAs0e4Mv+QENXcS6dA78rz7ZrmUInx?=
 =?us-ascii?Q?P9+K7CfyJpdzTqDKBtpFrqWidJnZMCjzZ0NZOX9ci1v8b9zvEHpPGGUYBFQV?=
 =?us-ascii?Q?FyX7uf8wECYGkO+cjk7jxBqfsrjfnInfMX+R3Mx/I4zv1gSVmUfN/HwatFk4?=
 =?us-ascii?Q?U4FQDOYHBn7pLAE9djtV69/sesmgr0sXlLdmtRq5U/4c7mDFnobQFmzE0eao?=
 =?us-ascii?Q?AjmneUUMbmjC3FawQZA1Ix9fztITDeGHnFczxntwR+ntzhcNOWWy7SalTry1?=
 =?us-ascii?Q?BxjJez2pQ1k9V+kySCHgaAq8YDLwmcpzLroGHYt46ibORabq4vomdSaW8934?=
 =?us-ascii?Q?pzK/7tJCw5DW8kUpSUIRiVwvV29JUuux0SF/8469PCQJRG4qHv2SZ256oN/B?=
 =?us-ascii?Q?S/p0SB48jmuJCzYC5KpYw1vCgSrULk54DhhYVznq88chh58OtLICMWs7q53D?=
 =?us-ascii?Q?ItZ5UKkFjFfIelEPGTL0ySipnzdTsNbY7zRsumucOUh4ABZVHksArFPiHnoX?=
 =?us-ascii?Q?IZG8j4iwwCi22FkCljLgKiktmaK79o5epILrJTaVjRnMlPpfpgq2lNagd2Jk?=
 =?us-ascii?Q?1S6X+yF0saWnzSSuatuwgzg1FgUL0pwkkMABfzG5Jrw8yzLLIj03grTjVI5+?=
 =?us-ascii?Q?RXW6f5fNBljYqrGlcqQJ1/sXK4kImLRubLK4037wG3jt6dSy4V3t5h1SJOte?=
 =?us-ascii?Q?LrGzXsA8a6ubzQ+oBAMFqI2x26EDl1mZDzSuYgGLFcjhocISrlfO/cjYptHR?=
 =?us-ascii?Q?qf1+pdzUggDl5uXkxI+PZ3UNwuopIvkrs/o8kyXLj7QEnEfih16sQRLY4ENr?=
 =?us-ascii?Q?vebg/AgzsqQwxYu/1nlfP5L9l1pFhOQhryXpgb8up/Iudq98qRMC0UmA+4VD?=
 =?us-ascii?Q?BI00SiHt2tzsBlw4kU9V46O5Pz3Jcc97zoOem8NiCV65710D81cz9hWpCl4Y?=
 =?us-ascii?Q?uy39lS+60B6RAhUjY+4cnbnfWxj5FbAAHQK1QbB9WyCqmm6jpFu5d6oyXA0s?=
 =?us-ascii?Q?bazkIMtZpNmk3nCJTYt+jY6P9JmLUl5fgX86yAwBNEK452gU+OdrHynvJvYV?=
 =?us-ascii?Q?kRgRdVB6WIDsf9BW9DAUJ4uaYIitcV2gpc3RwXyiHlUWUkW82FFNlRmH1eTF?=
 =?us-ascii?Q?JWlfJu46IN7ywdPFTM9U96t8y5g0Cz1sR8+AaYYh+MOFhf96WXIkWpuwGzfr?=
 =?us-ascii?Q?LtgamVmiOTyBwWudbjFtzqbw/nEeY8djnQuK1IiY8T2qKtcdfLlcU3lbHvq1?=
 =?us-ascii?Q?K5RUPTFttuajAzF4HSeNy8APYHxMBqJwi8SwXpcu5A0pG7fWiVijMabxQBr8?=
 =?us-ascii?Q?r+XCnIFKE0h61+lptebnekRSmR+EPg5HU08buXqVe+YJVNwoFf7p0BPGiDYv?=
 =?us-ascii?Q?8z/ywhFQ95oSRoJjuGDe+hsJhynXbqlogCd6qA0jUb2PlTm35AmKlJ5y389G?=
 =?us-ascii?Q?jKGkIRxIdM3HhMgEg6ErrTz5pDz9KaggfzsqvTOvC9cPq3wv9pvMNXmsSbvL?=
 =?us-ascii?Q?sCODGQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 487463fb-e416-48b2-2ba1-08db2b10b14e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 20:04:50.0030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x6ksx3MWxN//9IhFJMuX7Mor0joq/NgR0OfIM2qDzuvv7C8XqApQ9p7GRWmNsCri7dLMn25imx70/9NNDRsmanHYOgORciZTW+iGkqpcGKU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5286
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 04:18:29PM +0100, Felix Fietkau wrote:
> On 22.03.23 15:04, Simon Horman wrote:
> > On Tue, Mar 21, 2023 at 02:36:08PM +0100, Felix Fietkau wrote:
> > > WED version 2 (on MT7986 and later) can offload flows originating from wireless
> > > devices. In order to make that work, ndo_setup_tc needs to be implemented on
> > > the netdevs. This adds the required code to offload flows coming in from WED,
> > > while keeping track of the incoming wed index used for selecting the correct
> > > PPE device.
> > > 
> > > Signed-off-by: Felix Fietkau <nbd@nbd.name>
> > 
> > Hi Felix,
> > 
> > A few nits from my side.
> > 
> > First, please reformat the patch description to have a maximum of 75 characters
> > per line, as suggested by checkpatch.
> Will do
> 
> > > @@ -512,25 +514,15 @@ mtk_flow_offload_stats(struct mtk_eth *eth, struct flow_cls_offload *f)
> > >  static DEFINE_MUTEX(mtk_flow_offload_mutex);
> > > -static int
> > > -mtk_eth_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_priv)
> > > +int mtk_flow_offload_cmd(struct mtk_eth *eth, struct flow_cls_offload *cls,
> > > +			 int ppe_index)
> > >  {
> > > -	struct flow_cls_offload *cls = type_data;
> > > -	struct net_device *dev = cb_priv;
> > > -	struct mtk_mac *mac = netdev_priv(dev);
> > > -	struct mtk_eth *eth = mac->hw;
> > >  	int err;
> > > -	if (!tc_can_offload(dev))
> > > -		return -EOPNOTSUPP;
> > > -
> > > -	if (type != TC_SETUP_CLSFLOWER)
> > > -		return -EOPNOTSUPP;
> > > -
> > >  	mutex_lock(&mtk_flow_offload_mutex);
> > >  	switch (cls->command) {
> > >  	case FLOW_CLS_REPLACE:
> > > -		err = mtk_flow_offload_replace(eth, cls);
> > > +		err = mtk_flow_offload_replace(eth, cls, ppe_index);
> > >  		break;
> > >  	case FLOW_CLS_DESTROY:
> > >  		err = mtk_flow_offload_destroy(eth, cls);
> > > @@ -547,6 +539,23 @@ mtk_eth_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_pri
> > >  	return err;
> > >  }
> > > +static int
> > > +mtk_eth_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_priv)
> > > +{
> > > +	struct flow_cls_offload *cls = type_data;
> > > +	struct net_device *dev = cb_priv;
> > > +	struct mtk_mac *mac = netdev_priv(dev);
> > > +	struct mtk_eth *eth = mac->hw;
> > 
> > Reverse xmas tree - longest line to shortest -
> > for local variable declarations please.
> Will do.
> 
> > > diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
> > > index 95d890870984..30fe1281d2d3 100644
> > > --- a/drivers/net/ethernet/mediatek/mtk_wed.c
> > > +++ b/drivers/net/ethernet/mediatek/mtk_wed.c
> > 
> > ...
> > 
> > > @@ -1745,6 +1752,102 @@ void mtk_wed_flow_remove(int index)
> > >  	mutex_unlock(&hw_lock);
> > >  }
> > > +static int
> > > +mtk_wed_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_priv)
> > > +{
> > > +	struct mtk_wed_flow_block_priv *priv = cb_priv;
> > > +	struct flow_cls_offload *cls = type_data;
> > > +	struct mtk_wed_hw *hw = priv->hw;
> > > +
> > > +	if (!tc_can_offload(priv->dev))
> > > +		return -EOPNOTSUPP;
> > > +
> > > +	if (type != TC_SETUP_CLSFLOWER)
> > > +		return -EOPNOTSUPP;
> > > +
> > > +	return mtk_flow_offload_cmd(hw->eth, cls, hw->index);
> > 
> > This seems very similar to mtk_eth_setup_tc_block_cb().
> > Can further consolidation be considered?
> It's similar, but using different data structures and pointer chains.
> Consolidation does not make sense here.

Thanks, I see that now.

> > > +}
> > > +
> > > +static int
> > > +mtk_wed_setup_tc_block(struct mtk_wed_hw *hw, struct net_device *dev,
> > > +		       struct flow_block_offload *f)
> > > +{
> > > +	struct mtk_wed_flow_block_priv *priv;
> > > +	static LIST_HEAD(block_cb_list);
> > > +	struct flow_block_cb *block_cb;
> > > +	struct mtk_eth *eth = hw->eth;
> > > +	bool register_block = false;
> > > +	flow_setup_cb_t *cb;
> > > +
> > > +	if (!eth->soc->offload_version)
> > > +		return -EOPNOTSUPP;
> > > +
> > > +	if (f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
> > > +		return -EOPNOTSUPP;
> > > +
> > > +	cb = mtk_wed_setup_tc_block_cb;
> > > +	f->driver_block_list = &block_cb_list;
> > > +
> > > +	switch (f->command) {
> > > +	case FLOW_BLOCK_BIND:
> > > +		block_cb = flow_block_cb_lookup(f->block, cb, dev);
> > > +		if (!block_cb) {
> > 
> > I wonder if this could be written more idiomatically as:
> > 
> > 		if (block_cb) {
> > 			flow_block_cb_incref(block_cb);
> > 			return 0;
> > 		}
> > 
> > 		priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> flow_block_cb_incref needs to be called for the newly allocated flow block
> cb as well. I was following the same pattern that several

I guess that to some extent it is a question of style.
It seems to me that having separate calls to
flow_block_cb_incref() for the different cases
leads to nicer, and less indented, code.

But its just a suggestion from my side.

> > > diff --git a/include/linux/soc/mediatek/mtk_wed.h b/include/linux/soc/mediatek/mtk_wed.h
> > 
> > ...
> > 
> > > @@ -237,6 +240,8 @@ mtk_wed_get_rx_capa(struct mtk_wed_device *dev)
> > >  	(_dev)->ops->msg_update(_dev, _id, _msg, _len)
> > >  #define mtk_wed_device_stop(_dev) (_dev)->ops->stop(_dev)
> > >  #define mtk_wed_device_dma_reset(_dev) (_dev)->ops->reset_dma(_dev)
> > > +#define mtk_wed_device_setup_tc(_dev, _netdev, _type, _type_data) \
> > > +	(_dev)->ops->setup_tc(_dev, _netdev, _type, _type_data)
> > 
> > nit: checkpatch says:
> > 
> > include/linux/soc/mediatek/mtk_wed.h:243: ERROR: Macros with complex values should be enclosed in parentheses
> > +#define mtk_wed_device_setup_tc(_dev, _netdev, _type, _type_data) \
> > +	(_dev)->ops->setup_tc(_dev, _netdev, _type, _type_data)
> > 
> > include/linux/soc/mediatek/mtk_wed.h:243: CHECK: Macro argument reuse '_dev' - possible side-effects?
> > +#define mtk_wed_device_setup_tc(_dev, _netdev, _type, _type_data) \
> > +	(_dev)->ops->setup_tc(_dev, _netdev, _type, _type_data)
> In my opinion that's a false positive. The newly added macros follow the
> same pattern as the existing ones.

Ack.

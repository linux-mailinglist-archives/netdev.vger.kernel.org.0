Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3E2B6C4F41
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 16:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbjCVPSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 11:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbjCVPSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 11:18:33 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07573591DD
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 08:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Subject:From
        :References:Cc:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sCG4rkTPbNXSwulciG0CG1ttJMFnvJAiuCEzeY2PkC0=; b=bCX2rZ6K/tPHHytITQUzYpNMjP
        DTE+6IKh4rZVzoaItZfa5CEgh51T6aMl7VqpcD6CfQ3wF9bJ7PRV0TGwecuYx6DWZDOKRbN2LnE3m
        ouNq6MOOmAQFY3/qr02q5zGw14SW0/mRI4au5H1vu3Oe7MyvDON3h8YF+evQSgqVE+jI=;
Received: from [2a01:598:b1a6:ae43:fdb0:2ef2:7059:9fb7] (helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pf0EQ-005hrG-4D; Wed, 22 Mar 2023 16:18:30 +0100
Message-ID: <cbded874-8fc7-0ba5-89d2-20a09809364c@nbd.name>
Date:   Wed, 22 Mar 2023 16:18:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org
References: <20230321133609.49591-1-nbd@nbd.name>
 <ZBsK46vmNtjxJZH6@corigine.com>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH net-next 1/2] net: ethernet: mtk_eth_soc: add code for
 offloading flows from wlan devices
In-Reply-To: <ZBsK46vmNtjxJZH6@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.03.23 15:04, Simon Horman wrote:
> On Tue, Mar 21, 2023 at 02:36:08PM +0100, Felix Fietkau wrote:
>> WED version 2 (on MT7986 and later) can offload flows originating from wireless
>> devices. In order to make that work, ndo_setup_tc needs to be implemented on
>> the netdevs. This adds the required code to offload flows coming in from WED,
>> while keeping track of the incoming wed index used for selecting the correct
>> PPE device.
>>
>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> 
> Hi Felix,
> 
> A few nits from my side.
> 
> First, please reformat the patch description to have a maximum of 75 characters
> per line, as suggested by checkpatch.
Will do

>> @@ -512,25 +514,15 @@ mtk_flow_offload_stats(struct mtk_eth *eth, struct flow_cls_offload *f)
>>  
>>  static DEFINE_MUTEX(mtk_flow_offload_mutex);
>>  
>> -static int
>> -mtk_eth_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_priv)
>> +int mtk_flow_offload_cmd(struct mtk_eth *eth, struct flow_cls_offload *cls,
>> +			 int ppe_index)
>>  {
>> -	struct flow_cls_offload *cls = type_data;
>> -	struct net_device *dev = cb_priv;
>> -	struct mtk_mac *mac = netdev_priv(dev);
>> -	struct mtk_eth *eth = mac->hw;
>>  	int err;
>>  
>> -	if (!tc_can_offload(dev))
>> -		return -EOPNOTSUPP;
>> -
>> -	if (type != TC_SETUP_CLSFLOWER)
>> -		return -EOPNOTSUPP;
>> -
>>  	mutex_lock(&mtk_flow_offload_mutex);
>>  	switch (cls->command) {
>>  	case FLOW_CLS_REPLACE:
>> -		err = mtk_flow_offload_replace(eth, cls);
>> +		err = mtk_flow_offload_replace(eth, cls, ppe_index);
>>  		break;
>>  	case FLOW_CLS_DESTROY:
>>  		err = mtk_flow_offload_destroy(eth, cls);
>> @@ -547,6 +539,23 @@ mtk_eth_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_pri
>>  	return err;
>>  }
>>  
>> +static int
>> +mtk_eth_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_priv)
>> +{
>> +	struct flow_cls_offload *cls = type_data;
>> +	struct net_device *dev = cb_priv;
>> +	struct mtk_mac *mac = netdev_priv(dev);
>> +	struct mtk_eth *eth = mac->hw;
> 
> Reverse xmas tree - longest line to shortest -
> for local variable declarations please.
Will do.

>> diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
>> index 95d890870984..30fe1281d2d3 100644
>> --- a/drivers/net/ethernet/mediatek/mtk_wed.c
>> +++ b/drivers/net/ethernet/mediatek/mtk_wed.c
> 
> ...
> 
>> @@ -1745,6 +1752,102 @@ void mtk_wed_flow_remove(int index)
>>  	mutex_unlock(&hw_lock);
>>  }
>>  
>> +static int
>> +mtk_wed_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_priv)
>> +{
>> +	struct mtk_wed_flow_block_priv *priv = cb_priv;
>> +	struct flow_cls_offload *cls = type_data;
>> +	struct mtk_wed_hw *hw = priv->hw;
>> +
>> +	if (!tc_can_offload(priv->dev))
>> +		return -EOPNOTSUPP;
>> +
>> +	if (type != TC_SETUP_CLSFLOWER)
>> +		return -EOPNOTSUPP;
>> +
>> +	return mtk_flow_offload_cmd(hw->eth, cls, hw->index);
> 
> This seems very similar to mtk_eth_setup_tc_block_cb().
> Can further consolidation be considered?
It's similar, but using different data structures and pointer chains. 
Consolidation does not make sense here.

>> +}
>> +
>> +static int
>> +mtk_wed_setup_tc_block(struct mtk_wed_hw *hw, struct net_device *dev,
>> +		       struct flow_block_offload *f)
>> +{
>> +	struct mtk_wed_flow_block_priv *priv;
>> +	static LIST_HEAD(block_cb_list);
>> +	struct flow_block_cb *block_cb;
>> +	struct mtk_eth *eth = hw->eth;
>> +	bool register_block = false;
>> +	flow_setup_cb_t *cb;
>> +
>> +	if (!eth->soc->offload_version)
>> +		return -EOPNOTSUPP;
>> +
>> +	if (f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
>> +		return -EOPNOTSUPP;
>> +
>> +	cb = mtk_wed_setup_tc_block_cb;
>> +	f->driver_block_list = &block_cb_list;
>> +
>> +	switch (f->command) {
>> +	case FLOW_BLOCK_BIND:
>> +		block_cb = flow_block_cb_lookup(f->block, cb, dev);
>> +		if (!block_cb) {
> 
> I wonder if this could be written more idiomatically as:
> 
> 		if (block_cb) {
> 			flow_block_cb_incref(block_cb);
> 			return 0;
> 		}
> 
> 		priv = kzalloc(sizeof(*priv), GFP_KERNEL);
flow_block_cb_incref needs to be called for the newly allocated flow 
block cb as well. I was following the same pattern that several
>> diff --git a/include/linux/soc/mediatek/mtk_wed.h b/include/linux/soc/mediatek/mtk_wed.h
> 
> ...
> 
>> @@ -237,6 +240,8 @@ mtk_wed_get_rx_capa(struct mtk_wed_device *dev)
>>  	(_dev)->ops->msg_update(_dev, _id, _msg, _len)
>>  #define mtk_wed_device_stop(_dev) (_dev)->ops->stop(_dev)
>>  #define mtk_wed_device_dma_reset(_dev) (_dev)->ops->reset_dma(_dev)
>> +#define mtk_wed_device_setup_tc(_dev, _netdev, _type, _type_data) \
>> +	(_dev)->ops->setup_tc(_dev, _netdev, _type, _type_data)
> 
> nit: checkpatch says:
> 
> include/linux/soc/mediatek/mtk_wed.h:243: ERROR: Macros with complex values should be enclosed in parentheses
> +#define mtk_wed_device_setup_tc(_dev, _netdev, _type, _type_data) \
> +	(_dev)->ops->setup_tc(_dev, _netdev, _type, _type_data)
> 
> include/linux/soc/mediatek/mtk_wed.h:243: CHECK: Macro argument reuse '_dev' - possible side-effects?
> +#define mtk_wed_device_setup_tc(_dev, _netdev, _type, _type_data) \
> +	(_dev)->ops->setup_tc(_dev, _netdev, _type, _type_data)
In my opinion that's a false positive. The newly added macros follow the 
same pattern as the existing ones.

Thanks,

- Felix


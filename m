Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8669C6D29B3
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 23:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbjCaVB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 17:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjCaVBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 17:01:25 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C59E51D2E3
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 14:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=XromMjU24NB/gF+AwdswgIFUBAjfaDk+WGupOCyfYFI=; b=JXuZ7wfKLRpQ7KV5EUQFx04xwB
        Gm0IkJlmotywoLm5Gc8US7nqte4S1eCrt8XJPT2+aBEvAnrIVjogbcnS+TrZhARF19714Yj2DbYDV
        mv5+hoTDA55ee5oFrjAJtmsK8By7CczCTSg/t2ejdeM++vqZfdzTDkSC48BM667gmAIE=;
Received: from p54ae9730.dip0.t-ipconnect.de ([84.174.151.48] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1piLs8-0094EL-MV; Fri, 31 Mar 2023 23:01:20 +0200
Message-ID: <2380a961-ca3e-7693-fc90-11a0a5aa454b@nbd.name>
Date:   Fri, 31 Mar 2023 23:01:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH v3 net-next 1/2] net: ethernet: mtk_eth_soc: add code for
 offloading flows from wlan devices
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org
References: <20230331124707.40296-1-nbd@nbd.name>
 <ZCdEvEJTJewWnuU9@corigine.com>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <ZCdEvEJTJewWnuU9@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31.03.23 22:38, Simon Horman wrote:
> On Fri, Mar 31, 2023 at 02:47:06PM +0200, Felix Fietkau wrote:
>> WED version 2 (on MT7986 and later) can offload flows originating from
>> wireless devices.
>> In order to make that work, ndo_setup_tc needs to be implemented on the
>> netdevs. This adds the required code to offload flows coming in from WED,
>> while keeping track of the incoming wed index used for selecting the
>> correct PPE device.
>> 
>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> 
> ...
> 
>> diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
> 
> ...
> 
>> +static int
>> +mtk_eth_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_priv)
>> +{
>> +	struct flow_cls_offload *cls = type_data;
>> +	struct mtk_mac *mac = netdev_priv(dev);
> 
> This does not compile because dev is undefined at this point.
Yes, I had fixed that, but forgot to amend the commit before sending it 
out. Sorry about that.

> ...
> 
>> +static int
>> +mtk_wed_setup_tc_block(struct mtk_wed_hw *hw, struct net_device *dev,
>> +		       struct flow_block_offload *f)
>> +{
>> +	struct mtk_wed_flow_block_priv *priv;
>> +	static LIST_HEAD(block_cb_list);
>> +	struct flow_block_cb *block_cb;
>> +	struct mtk_eth *eth = hw->eth;
>> +	bool register_block = false;
> 
> gcc-12 with W=1 tellsme that register_block is unused.
> It should be removed.
Right. Will send v4 tomorrow.

Thanks,

- Felix

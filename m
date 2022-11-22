Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45B0F6338D5
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 10:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbiKVJmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 04:42:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233389AbiKVJly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 04:41:54 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B53751C0B
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 01:41:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Subject:From
        :References:Cc:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=iUicmmVomUQkSXsaTcz/OLEpjGhlAZbL6cmcVVrzB4c=; b=nsvSo2RnnNLjLwQZBi7FGYfZuZ
        NUVxdq33+g8wTb50kyrc7Lie8nviNoXUbW9wtIa4SnhJHHIJBQi9bcu0LyJSurJIsQmH4ikhCE/pt
        +gmTqZL1F36PKHc/qAw4MA3zDMYsTO5d4XXuGq9Hx7gGkwENWo7LmUHrXmqkCu2iFmhE=;
Received: from p200300daa7225c007502151ad3a4cf6f.dip0.t-ipconnect.de ([2003:da:a722:5c00:7502:151a:d3a4:cf6f] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1oxPmT-003iat-EV; Tue, 22 Nov 2022 10:41:29 +0100
Message-ID: <0193456e-0acb-75d6-8c6f-be0917990708@nbd.name>
Date:   Tue, 22 Nov 2022 10:41:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        sujuan.chen@mediatek.com, linux-mediatek@lists.infradead.org
References: <cover.1669020847.git.lorenzo@kernel.org>
 <9c4dded2b7a35a8e44b255a74e776a703359797b.1669020847.git.lorenzo@kernel.org>
 <20221121121718.4cc2afe5@kernel.org> <Y3vrKcqlmxksq1rC@lore-desk>
 <20221121201917.080365ce@kernel.org>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH net-next 5/5] net: ethernet: mtk_wed: add reset to
 tx_ring_setup callback
In-Reply-To: <20221121201917.080365ce@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.11.22 05:19, Jakub Kicinski wrote:
> On Mon, 21 Nov 2022 22:18:33 +0100 Lorenzo Bianconi wrote:
>> > On Mon, 21 Nov 2022 09:59:25 +0100 Lorenzo Bianconi wrote:  
>> > > +#define mtk_wed_device_tx_ring_setup(_dev, _ring, _regs, _reset) \
>> > > +	(_dev)->ops->tx_ring_setup(_dev, _ring, _regs, _reset)  
>> > 
>> > FWIW I find the "op macros" quite painful when trying to read a driver
>> > I'm not familiar with. stmmac does this, too. Just letting you know,
>> > it is what it is.  
>> 
>> ack, fine. I maintained the approach currently used in the driver.
>> Do you prefer to run the function pointer directly?
> 
> That's a tiny bit better, yes, saves the reader one lookup.
> 
> Are the ops here serving as a HAL or a way of breaking the dependency
> between the SoC/Eth and the WiFi drivers?
The latter. For a multi-platform kernel it's important that the wifi 
driver does not depend on mtk_eth_soc directly, even when support for 
WED is enabled.

- Felix

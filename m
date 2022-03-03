Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF2454CB75A
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 08:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbiCCG7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 01:59:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiCCG7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 01:59:52 -0500
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED5427FD5;
        Wed,  2 Mar 2022 22:59:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2m4RpdrvDWJ2Lbwggqe1wkzLSnbf7tDq1lOz4LACayk=; b=GclwX64l6V5f8kehmfrWiI/+J4
        8RzkcfMFFgiuiQCodv/2gnIC3ikLB3SpzKZ+MKquDyTvf/2qcEKEzwnC6vkUyw5AA6m8mjD6nBBat
        vT32LnKyaFoveOXK23R0XVuJkpl2HRzOcOM8BKTQACcHejpQBocleespRVWlGy48Yi+s=;
Received: from p200300daa7204f000c852a81b34becd9.dip0.t-ipconnect.de ([2003:da:a720:4f00:c85:2a81:b34b:ecd9] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1nPfQN-000124-AR; Thu, 03 Mar 2022 07:58:55 +0100
Message-ID: <2bd80da6-944c-4c9d-febf-f83b4302492a@nbd.name>
Date:   Thu, 3 Mar 2022 07:58:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH 03/11] net: ethernet: mtk_eth_soc: add support for
 Wireless Ethernet Dispatch (WED)
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20220225101811.72103-1-nbd@nbd.name>
 <20220225101811.72103-4-nbd@nbd.name>
 <20220225221848.7c7be7f6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <20220225221848.7c7be7f6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 26.02.22 07:18, Jakub Kicinski wrote:
> On Fri, 25 Feb 2022 11:18:02 +0100 Felix Fietkau wrote:
>> +	page_list = kcalloc(n_pages, sizeof(*page_list), GFP_KERNEL);
>> +	if (!page_list)
>> +		return -ENOMEM;
>> +
>> +	dev->buf_ring.size = ring_size;
>> +	dev->buf_ring.pages = page_list;
>> +
>> +	desc = dma_alloc_coherent(dev->hw->dev, ring_size * sizeof(*desc),
>> +				  &desc_phys, GFP_KERNEL);
>> +	if (!desc)
>> +		return -ENOMEM;
>> +
>> +	dev->buf_ring.desc = desc;
>> +	dev->buf_ring.desc_phys = desc_phys;
>> +
>> +	for (i = 0, page_idx = 0; i < ring_size; i += MTK_WED_BUF_PER_PAGE) {
>> +		dma_addr_t page_phys, buf_phys;
>> +		struct page *page;
>> +		void *buf;
>> +		int s;
>> +
>> +		page = __dev_alloc_pages(GFP_KERNEL, 0);
>> +		if (!page)
>> +			return -ENOMEM;
> 
> I haven't looked at the code, yet, but this sure looks leaky.
It's not leaky. If the alloc fails, mtk_wed_detach is still called, 
which cleans up even incomplete ring allocations.

- Felix

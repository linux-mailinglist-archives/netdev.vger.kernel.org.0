Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF2D2657C0
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 05:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725681AbgIKD5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 23:57:17 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:11810 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725283AbgIKD5R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 23:57:17 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 3389ACA3CCD13B1B6CFA;
        Fri, 11 Sep 2020 11:57:15 +0800 (CST)
Received: from [127.0.0.1] (10.57.22.126) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Fri, 11 Sep 2020
 11:57:06 +0800
Subject: Re: [PATCH net-next] net: stmmac: Remove unused variable 'ret' at
 stmmac_rx_buf1_len()
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>,
        <joabreu@synopsys.com>, <davem@davemloft.net>,
        <mcoquelin.stm32@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>
References: <1599705765-15562-1-git-send-email-luojiaxing@huawei.com>
 <20200910122912.5792f657@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   luojiaxing <luojiaxing@huawei.com>
Message-ID: <b81783e5-1c12-e06e-1416-3a8883d21cf1@huawei.com>
Date:   Fri, 11 Sep 2020 11:57:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20200910122912.5792f657@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.57.22.126]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/9/11 3:29, Jakub Kicinski wrote:
> On Thu, 10 Sep 2020 10:42:45 +0800 Luo Jiaxing wrote:
>> Fixes the following warning when using W=1 to build kernel:
>>
>> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:3634:6: warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]
>> int ret, coe = priv->hw->rx_csum;
>>
>> When digging stmmac_get_rx_header_len(), dwmac4_get_rx_header_len() and
>> dwxgmac2_get_rx_header_len() return 0 by default. Therefore, ret do not
>> need to check the error value and can be directly deleted.
>>
>> Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
>> ---
>>   drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> index 89b2b34..7e95412 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> @@ -3631,15 +3631,15 @@ static unsigned int stmmac_rx_buf1_len(struct stmmac_priv *priv,
>>   				       struct dma_desc *p,
>>   				       int status, unsigned int len)
>>   {
>> -	int ret, coe = priv->hw->rx_csum;
>>   	unsigned int plen = 0, hlen = 0;
>> +	int coe = priv->hw->rx_csum;
>>   
>>   	/* Not first descriptor, buffer is always zero */
>>   	if (priv->sph && len)
>>   		return 0;
>>   
>>   	/* First descriptor, get split header length */
>> -	ret = stmmac_get_rx_header_len(priv, p, &hlen);
>> +	stmmac_get_rx_header_len(priv, p, &hlen);
> This function should return void if there never are any errors to
> report.


Yes, you are right. So, if we need to modify the function type , this 
patch need to be drop.

And I will send a new patch later to redefine get_rx_header_len() to 
void and delete ret there.


Please check "net: stmmac: set get_rx_header_len() as void for it didn't 
have any error code to return" later.


Thanks

Jiaxing


>>   	if (priv->sph && hlen) {
>>   		priv->xstats.rx_split_hdr_pkt_n++;
>>   		return hlen;
>
> .
>


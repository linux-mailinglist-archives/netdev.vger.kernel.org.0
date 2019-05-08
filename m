Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15902180BD
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 21:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbfEHTy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 15:54:59 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:38112 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727405AbfEHTy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 15:54:58 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id x48JsntP091229;
        Wed, 8 May 2019 14:54:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1557345289;
        bh=1HSSbjkn49htu7J0scqHJVwyKQjdVeMq0i/wqOSoiSA=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=dCPKZqPuuemoqejVI5vFQYMSEF9F6ms3xixOLRdNfUTNxCLJgouqYlBH79rsz/95i
         Avo52K6wEhGJfMI62iEE+sEeyAs9HqTP8/7U9ESZ3QesPMeempSaZuy0r4g9I3yFS5
         u8USSEIhpbwL88w49J60nncPcHAzy3SvxIOJdxsA=
Received: from DLEE102.ent.ti.com (dlee102.ent.ti.com [157.170.170.32])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x48JsnM7056173
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 8 May 2019 14:54:49 -0500
Received: from DLEE102.ent.ti.com (157.170.170.32) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Wed, 8 May
 2019 14:54:49 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Wed, 8 May 2019 14:54:49 -0500
Received: from [10.250.90.63] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id x48JsmLG035228;
        Wed, 8 May 2019 14:54:48 -0500
Subject: Re: [PATCH v11 1/5] can: m_can: Create a m_can platform framework
To:     Marc Kleine-Budde <mkl@pengutronix.de>, <wg@grandegger.com>,
        <davem@davemloft.net>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20190319172651.10012-1-dmurphy@ti.com>
 <8b53474d-9dbf-4b81-defd-1587e022990b@pengutronix.de>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <35d179a7-2682-111e-638b-903559f0974a@ti.com>
Date:   Wed, 8 May 2019 14:54:56 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <8b53474d-9dbf-4b81-defd-1587e022990b@pengutronix.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marc

Thanks for the comments

On 5/8/19 9:35 AM, Marc Kleine-Budde wrote:
> On 3/19/19 6:26 PM, Dan Murphy wrote:
>> Create a m_can platform framework that peripheral
>> devices can register to and use common code and register sets.
>> The peripheral devices may provide read/write and configuration
>> support of the IP.
>>
>> Acked-by: Wolfgang Grandegger <wg@grandegger.com>
>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> 
> [...]
> 
>> -/* m_can private data structure */
>> -struct m_can_priv {
>> -	struct can_priv can;	/* must be the first member */
>> -	struct napi_struct napi;
>> -	struct net_device *dev;
>> -	struct device *device;
>> -	struct clk *hclk;
>> -	struct clk *cclk;
>> -	void __iomem *base;
>> -	u32 irqstatus;
>> -	int version;
>> -
>> -	/* message ram configuration */
>> -	void __iomem *mram_base;
>> -	struct mram_cfg mcfg[MRAM_CFG_NUM];
>> -};
>> +static u32 m_can_read(struct m_can_priv *priv, enum m_can_reg reg)
>> +{
>> +	if (priv->ops->read_reg)
>> +		return priv->ops->read_reg(priv, reg);
>> +	else
>> +		return -EINVAL;
>> +}
> 
> How do you plan to check the return value here?
> What's the difference between a register value of 0xffffffe9 and
> returning -EINVAL?
> 

Good point.  I could just inline this and return whatever is sent from the callback
and as you said allow a backtrace to happen if read_reg is invalid.

>>  
>> -static inline u32 m_can_read(const struct m_can_priv *priv, enum m_can_reg reg)
>> +static int m_can_write(struct m_can_priv *priv, enum m_can_reg reg, u32 val)
>>  {
>> -	return readl(priv->base + reg);
>> +	if (priv->ops->write_reg)
>> +		return priv->ops->write_reg(priv, reg, val);
>> +	else
>> +		return -EINVAL;
>>  }
> 
> I don't see anyone checking the return value. Better just dereference
> the pointer and the kernel will produce a nice backtrace.
> 
> Same should be done for all read and write variants.
> 

I will need to go through this and see if there is any caller checking the return.  But
I think you are correct.  If thats true I will just change this to a void, inline the function
and allow a backtrace if the callback is null

Dan



> Marc
> 

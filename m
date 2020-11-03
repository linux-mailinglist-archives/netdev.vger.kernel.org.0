Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 427352A3DB7
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 08:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbgKCHcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 02:32:32 -0500
Received: from linux.microsoft.com ([13.77.154.182]:53368 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725968AbgKCHcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 02:32:32 -0500
Received: from [192.168.0.114] (unknown [49.207.216.192])
        by linux.microsoft.com (Postfix) with ESMTPSA id 2F3B720B4905;
        Mon,  2 Nov 2020 23:32:28 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2F3B720B4905
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1604388752;
        bh=DbeTq7NUrIzUmq5PgNVdkpfqtCpYVRzMavAigeVW9yQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=oeARVw5kmaJz3zZvrDN40so1sjy0Yc9EX7ZAFGNyN/tpqcEdKR3VU8K5w57DpjqiZ
         MdPRCbX/xzK2GU9QE3qJAmOpzQ1VyzCqbHpefrs5x0PnRQhgwQhsiVqfsRnWvnKk6r
         yscwbxpazaIW7gPJCF7tnogOWhD22YhY5hreQuuQ=
Subject: Re: [next-next v3 05/10] net: cdc_ncm: convert tasklets to use new
 tasklet_setup() API
To:     Jakub Kicinski <kuba@kernel.org>, Allen Pais <allen.lkml@gmail.com>
Cc:     davem@davemloft.net, m.grzeschik@pengutronix.de, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, petkan@nucleusys.com,
        netdev@vger.kernel.org, Romain Perier <romain.perier@gmail.com>
References: <20201006061159.292340-1-allen.lkml@gmail.com>
 <20201006061159.292340-6-allen.lkml@gmail.com>
 <20201008165859.2e96ef7c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Allen Pais <apais@linux.microsoft.com>
Message-ID: <ed37373b-218c-600d-7837-efdd217fd799@linux.microsoft.com>
Date:   Tue, 3 Nov 2020 13:02:26 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201008165859.2e96ef7c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> 
>> @@ -815,7 +815,7 @@ int cdc_ncm_bind_common(struct usbnet *dev, struct usb_interface *intf, u8 data_
>>   
>>   	hrtimer_init(&ctx->tx_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
>>   	ctx->tx_timer.function = &cdc_ncm_tx_timer_cb;
>> -	tasklet_init(&ctx->bh, cdc_ncm_txpath_bh, (unsigned long)dev);
>> +	tasklet_setup(&ctx->bh, cdc_ncm_txpath_bh);
>>   	atomic_set(&ctx->stop, 0);
>>   	spin_lock_init(&ctx->mtx);
>>   
>> @@ -1468,9 +1468,9 @@ static enum hrtimer_restart cdc_ncm_tx_timer_cb(struct hrtimer *timer)
>>   	return HRTIMER_NORESTART;
>>   }
>>   
>> -static void cdc_ncm_txpath_bh(unsigned long param)
>> +static void cdc_ncm_txpath_bh(struct tasklet_struct *t)
>>   {
>> -	struct usbnet *dev = (struct usbnet *)param;
>> +	struct usbnet *dev = from_tasklet(dev, t, bh);
>>   	struct cdc_ncm_ctx *ctx = (struct cdc_ncm_ctx *)dev->data[0];
>>   
>>   	spin_lock_bh(&ctx->mtx);
> 
> This one is wrong.
> 
> ctx is struct cdc_ncm_ctx, but you from_tasklet() struct usbdev.
> They both happen to have a tasklet called bh in 'em.

  from_tasklet() is struct usbnet. So it should pick the right bh isn't it?

Thanks.


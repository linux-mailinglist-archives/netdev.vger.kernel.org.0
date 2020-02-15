Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E77D15FDE4
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 10:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbgBOJsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 04:48:01 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:34802 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbgBOJsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 04:48:01 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48KQR23G5cz1rhs2;
        Sat, 15 Feb 2020 10:47:58 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48KQR22Y2qz1qqlF;
        Sat, 15 Feb 2020 10:47:58 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id yVhZKld_Dcn4; Sat, 15 Feb 2020 10:47:57 +0100 (CET)
X-Auth-Info: tjJ8pdeQxWTkTIAWEqkdpoSW/7s12LQSfIuPiLR/Y60=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sat, 15 Feb 2020 10:47:57 +0100 (CET)
Subject: Re: [PATCH 2/3] net: ks8851-ml: Fix 16-bit data access
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, lukas@wunner.de, ynezz@true.cz,
        yuehaibing@huawei.com
References: <20200210184139.342716-1-marex@denx.de>
 <20200210184139.342716-2-marex@denx.de>
 <20200215.012458.724817187941650024.davem@davemloft.net>
From:   Marek Vasut <marex@denx.de>
Message-ID: <925845a7-c79b-a434-ca1c-bc9b660aa3ba@denx.de>
Date:   Sat, 15 Feb 2020 10:47:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200215.012458.724817187941650024.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/15/20 10:24 AM, David Miller wrote:
> From: Marek Vasut <marex@denx.de>
> Date: Mon, 10 Feb 2020 19:41:38 +0100
> 
>> @@ -197,7 +197,7 @@ static inline void ks_inblk(struct ks_net *ks, u16 *wptr, u32 len)
>>  {
>>  	len >>= 1;
>>  	while (len--)
>> -		*wptr++ = (u16)ioread16(ks->hw_addr);
>> +		*wptr++ = swab16(ioread16(ks->hw_addr));
> 
> I agree with the other feedback, the endianness looks wrong here.
> 
> The ioread16() translates whatever is behind ks->hw_addr into cpu
> endianness.
> 
> This is either always little endian (for example), which means that
> unconditionally swapping this doesn't seem to make sense.

So what is the suggestion to fix this properly ?

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 258C64B18D1
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 23:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345266AbiBJWui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 17:50:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238083AbiBJWuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 17:50:37 -0500
Received: from mail.turbocat.net (turbocat.net [IPv6:2a01:4f8:c17:6c4b::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DAC2B76;
        Thu, 10 Feb 2022 14:50:33 -0800 (PST)
Received: from [10.36.2.165] (unknown [178.17.145.105])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.turbocat.net (Postfix) with ESMTPSA id 468AA2616B4;
        Thu, 10 Feb 2022 23:50:31 +0100 (CET)
Message-ID: <3624a7e7-3568-bee1-77e5-67d5b7d48aa6@selasky.org>
Date:   Thu, 10 Feb 2022 23:50:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; FreeBSD amd64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [RFC] CDC-NCM: avoid overflow in sanity checking
Content-Language: en-US
To:     =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>
Cc:     Oliver Neukum <oneukum@suse.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220210155455.4601-1-oneukum@suse.com>
 <a9143724-51ca-08ea-588c-b849a4ba7011@selasky.org>
 <87v8xmocng.fsf@miraculix.mork.no>
From:   Hans Petter Selasky <hps@selasky.org>
In-Reply-To: <87v8xmocng.fsf@miraculix.mork.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/10/22 18:27, Bjørn Mork wrote:
> Hans Petter Selasky <hps@selasky.org> writes:
> 
>> "int" variables are 32-bit, so 0xFFF0 won't overflow.
>>
>> The initial driver code written by me did only support 16-bit lengths
>> and offset. Then integer overflow is not possible.
>>
>> It looks like somebody else introduced this integer overflow :-(
>>
>> commit 0fa81b304a7973a499f844176ca031109487dd31
>> Author: Alexander Bersenev <bay@hackerdom.ru>
>> Date:   Fri Mar 6 01:33:16 2020 +0500
>>
>>      cdc_ncm: Implement the 32-bit version of NCM Transfer Block
>>
>>      The NCM specification defines two formats of transfer blocks: with
>>      16-bit
>>      fields (NTB-16) and with 32-bit fields (NTB-32). Currently only
>>      NTB-16 is
>>      implemented.
>>
>> ....
>>
>> With NCM 32, both "len" and "offset" must be checked, because these
>> are now 32-bit and stored into regular "int".
>>
>> The fix you propose is not fully correct!
> 
> Yes, there is still an issue if len > skb_in->len since
> (skb_in->len - len) then ends up as a very large unsigned int.
> 
> I must admit that I have some problems tweaking my mind around these
> subtle unsigned overflow thingies.  Which is why I suggest just
> simplifying the whole thing with an additional test for the 32bit case
> (which never will be used for any sane device):
> 
> 		} else {
> 			offset = le32_to_cpu(dpe.dpe32->dwDatagramIndex);
> 			len = le32_to_cpu(dpe.dpe32->dwDatagramLength);
>                          if (offset < 0 || len < 0)
>                                  goto err_ndp;
> 		}

Hi,

I think something like this would do the trick:

if (offset < 0 || offset > sbk_in->len ||
     len < 0 || len > sbk_in->len)

> 
> And just keep the signed integers as-is.  You cannot possible use all
> bits of these anyway.

Right.

> 
> Yes, OK, that won't prevent offset +  len from becoming negative, but
> if will still work when compared to the unsigned skb_in->len.
>

--HPS

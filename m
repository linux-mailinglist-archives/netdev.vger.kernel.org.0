Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 006D43EC325
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 16:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238542AbhHNOSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 10:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbhHNOSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 10:18:15 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495ADC061764;
        Sat, 14 Aug 2021 07:17:47 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id p38so25695895lfa.0;
        Sat, 14 Aug 2021 07:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LmN8AjLyVtZIe0c8A8b2Bofe2fcHgxC16V0C8hTy0RA=;
        b=GLvRpM7DDVbbViD09WZVyRPPCR9PHvtB3Qgoj65HXazddUlbbgyihC+4bg6jbwIkSz
         MFCHvmPMM1MUBFGFfKkXl9dxMRwMSMD1LNvlftvLe6wLIsUkUiGauNEej1nphCrYDv4r
         AlF85v+Rrynvq12W+UK55uQ1oDd3Ko/dmTqzjlFOg/zecaV8pKdcprnEN7aSm+eIMwhx
         Sh+R3sDVcXBwpkXZOLoOVV3NGP0igG0BSLhwUyR+J8VQg8XA6rHg9UVWVj3/HvCbz88Y
         BLOiOnp0Am9GF4008pfP64+JcQEATtcrhBl8zfytvilU7+E2Pj9swRUEdvKeqXPe7F13
         FShA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LmN8AjLyVtZIe0c8A8b2Bofe2fcHgxC16V0C8hTy0RA=;
        b=YkMImn0Cenjwx5NRv3CNl7byq0KT5Tg2AfZQZXctUnWNFVBqRS+vNc+eKK1uMb1XiW
         QXDOoZNYnuXqmdMxsiL73n65yEg/PfKCdK9NM/JnPF7W/hJoJ0t7a05gWl7hwhwn8hLQ
         K7xSWSbogOtf8xyJdG/cite7a6lwFO5Lf69KnMyEAzQ5nVL1SENrulYiYypKWQPFDM96
         PUZ3e6SgDRrDpgbDehyP10wRZgDU4a052Jnz/kKPmxBf+Zi58IXMRgOQ6kHxeN6OuX73
         poYB+AOM3YCaB4e1NYrBIzPBa6/J1TM4Bn3SF9WLYnwMHPBzxPDRfkzkepm/syZbuapi
         PH+A==
X-Gm-Message-State: AOAM531XBEUaQN8AsFBnODf3oGnKlNGbRJscFDC+gJhe/7ywuEZD2E5N
        /HMfGXszQTO9dVaNw+sEa/Y=
X-Google-Smtp-Source: ABdhPJxT+k9E8RhU1d+/0pnEsSkDnVgHOfRoZ9nXTb+8W6/geyg7abLUP823Tnzmd2b5vpHK8WLJFA==
X-Received: by 2002:a19:610d:: with SMTP id v13mr1650665lfb.641.1628950665530;
        Sat, 14 Aug 2021 07:17:45 -0700 (PDT)
Received: from localhost.localdomain ([185.215.60.122])
        by smtp.gmail.com with ESMTPSA id u2sm426506lfd.43.2021.08.14.07.17.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Aug 2021 07:17:45 -0700 (PDT)
Subject: Re: [PATCH] net: 6pack: fix slab-out-of-bounds in decode_data
To:     Kevin Dawson <hal@kd.net.au>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     ajk@comnets.uni-bremen.de, davem@davemloft.net, kuba@kernel.org,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+fc8cd9a673d4577fb2e4@syzkaller.appspotmail.com
References: <20210813112855.11170-1-paskripkin@gmail.com>
 <20210813145834.GC1931@kadam> <20210814002345.GA19994@auricle.kd>
From:   Pavel Skripkin <paskripkin@gmail.com>
Message-ID: <1021b8cb-e763-255f-1df9-753ed2934b69@gmail.com>
Date:   Sat, 14 Aug 2021 17:17:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210814002345.GA19994@auricle.kd>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/14/21 3:23 AM, Kevin Dawson wrote:
> On Fri, Aug 13, 2021 at 05:58:34PM +0300, Dan Carpenter wrote:
>> On Fri, Aug 13, 2021 at 02:28:55PM +0300, Pavel Skripkin wrote:
>> > Syzbot reported slab-out-of bounds write in decode_data().
>> > The problem was in missing validation checks.
>> > 
>> > Syzbot's reproducer generated malicious input, which caused
>> > decode_data() to be called a lot in sixpack_decode(). Since
>> > rx_count_cooked is only 400 bytes and noone reported before,
>> > that 400 bytes is not enough, let's just check if input is malicious
>> > and complain about buffer overrun.
>> > 
>> > ...
>> > 
>> > diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
>> > index fcf3af76b6d7..f4ffc2a80ab7 100644
>> > --- a/drivers/net/hamradio/6pack.c
>> > +++ b/drivers/net/hamradio/6pack.c
>> > @@ -827,6 +827,12 @@ static void decode_data(struct sixpack *sp, unsigned char inbyte)
>> >  		return;
>> >  	}
>> >  
>> > +	if (sp->rx_count_cooked + 3 >= sizeof(sp->cooked_buf)) {
>> 
>> It should be + 2 instead of + 3.
>> 
>> We write three bytes.  idx, idx + 1, idx + 2.  Otherwise, good fix!
> 
> I would suggest that the statement be:
> 
> 	if (sp->rx_count_cooked + 3 > sizeof(sp->cooked_buf)) {
> 
> or even, because it's a buffer overrun test:
> 
> 	if (sp->rx_count_cooked > sizeof(sp->cooked_buf) - 3) {
>

Hmm, I think, it will be more straightforward for someone not aware 
about driver details.

@Dan, can I add your Reviewed-by tag to v3 and what do you think about 
Kevin's suggestion?


> This is because if there are three bytes being written, that is the number that should be obvious in the test.
> 
> I haven't looked at the surrounding code and there may be some other consideration why the "+ 2 >=" rather than "+ 3 >" (and from the description of "idx, idx + 1, idx + 2", I suspect it's visual consistency), so if that is important, feel free to adjust as required.
>



With regards,
Pavel Skripkin



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA08717AC51
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 18:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbgCERTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 12:19:51 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:36941 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728078AbgCERTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 12:19:49 -0500
Received: by mail-pj1-f65.google.com with SMTP id o2so2794433pjp.2
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 09:19:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7VTIIznQBmvnJ/8O+im4yptPfKhiIkM3KIhret3K2T4=;
        b=GRm7PbStnoRYbF5qoP73UT4Z8n3AqdaejXALm2P3df5457oc/QzajC9XcEhGqwo+bt
         rVFc4Smw9JaPC8fwVODncNBvezhTLQhunywA1FDvlNcUTIIRMKdScYssjRemHMgRhDfz
         V2tETh/NFZqWA6oQykaSQQPcb3fuex8dr+2G+phX4/wNGCuTJglFEh1LxZKFDGlgryX2
         NEpoGfH6rzAcuiZHYKYdmWmXVIhhH0ApvgPseH929moB8KCU5uNaXyjIzq57YErdpPoP
         qNocahkK0nA+z4+ZlOcrPD5meQXSvCFk0NY0VReqSm0wTHPQlXM/IaD7ubT6x6NEo32s
         rLDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7VTIIznQBmvnJ/8O+im4yptPfKhiIkM3KIhret3K2T4=;
        b=G0JGj8ZfhAJGBmPqYaEmxoW+gMpZW1siKnmW31UoyWm2KrbtDj2dILKcKuVXIu9eUD
         nZGXV4oZ6tC6dtNr1dNKvjEsrjaVnvkvw7UbSYP8H5Tp3Ij3ioRxRb7u7BID2MeSo2GB
         VCC2O71tPquL5XwE5sV2OdoarkDBCpwCKMkCWOCnIEECZbpAGRKbVVMcxkBSWbZ3WcTN
         NKTc43hFnD/Lpom0RVV3sPN6Hii/ZEiuDdI7ovTg+GnTF5dOe48DcFwppEchRQRUjAK7
         uWKKf4PcXbQ0ot3WMA7z/1iahcvka5mrVnWfzKSANN8Bf9EWgBj5YBvcI7Mspk0LcIBj
         0Few==
X-Gm-Message-State: ANhLgQ16ABmGXS1l3sssjWpkR0W6vot9VjXH9rXuIISKpQJfUO2DqQCN
        X1wG/eKX6lo+XOy5wFgzC00YgfOa
X-Google-Smtp-Source: ADFU+vt2Xk3Ln0g88HWUzMF7abf9LO70vIh3bu6DMV13UwfAol5rwQlTh62/8rt7kGVW/IksdmCjBA==
X-Received: by 2002:a17:90b:3581:: with SMTP id mm1mr9347194pjb.169.1583428787692;
        Thu, 05 Mar 2020 09:19:47 -0800 (PST)
Received: from [192.168.84.72] (8.100.247.35.bc.googleusercontent.com. [35.247.100.8])
        by smtp.gmail.com with ESMTPSA id t71sm6956007pjb.41.2020.03.05.09.19.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Mar 2020 09:19:46 -0800 (PST)
Subject: Re: [PATCH v2] net: Make skb_segment not to compute checksum if
 network controller supports checksumming
To:     David Laight <David.Laight@ACULAB.COM>,
        'Willem de Bruijn' <willemdebruijn.kernel@gmail.com>,
        Yadu Kishore <kyk.segfault@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
References: <20200228.120150.302053489768447737.davem@davemloft.net>
 <1583131910-29260-1-git-send-email-kyk.segfault@gmail.com>
 <CABGOaVRdsw=4nqBMR0h8JPEiunOEpHR+02H=HRbgt_TxhVviiA@mail.gmail.com>
 <945f6cafc86b4f1bb18fa40e60d5c113@AcuMS.aculab.com>
 <CABGOaVQMq-AxwQOJ5DdDY6yLBOXqBg6G7qC_MdOYj_z4y-QQiw@mail.gmail.com>
 <de1012794ec54314b6fe790c01dee60b@AcuMS.aculab.com>
 <CABGOaVSddVL-T-Sz_GPuRoZbKM_HsZND84rJUm2G9RRw6cUwCQ@mail.gmail.com>
 <CA+FuTSc5QVF_kv8FNs03obXGbf6axrG5umCipE=LXvqQ_-hDAA@mail.gmail.com>
 <817a6418ac8742e6bb872992711beb47@AcuMS.aculab.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <91fafe40-7856-8b22-c279-55df5d06ca39@gmail.com>
Date:   Thu, 5 Mar 2020 09:19:43 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <817a6418ac8742e6bb872992711beb47@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/5/20 9:00 AM, David Laight wrote:
> From: Willem de Bruijn
>> Sent: 05 March 2020 16:07
> ..
>> It seems do_csum is called because csum_partial_copy executes the
>> two operations independently:
>>
>> __wsum
>> csum_partial_copy(const void *src, void *dst, int len, __wsum sum)
>> {
>>         memcpy(dst, src, len);
>>         return csum_partial(dst, len, sum);
>> }
> 
> And do_csum() is superbly horrid.
> Not the least because it is 32bit on 64bit systems.

There are many versions, which one is discussed here ?

At least the current one seems to be 64bit optimized.

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=5777eaed566a1d63e344d3dd8f2b5e33be20643e


> 
> A better inner loop (even on 32bit) would be:
> 	u64 result = 0; // better old 'sum' the caller wants to add in.
> 	...
> 	do {
> 		result += *(u32 *)buff;
> 		buff += 4;
> 	} while (buff < end);
> 
> (That is as fast as the x86 'adc' loop on intel x86 cpus
> prior to Haswell!)
> Tweaking the above might cause gcc to generate code that
> executes one iteration per clock on some superscaler cpus.
> Adding alternate words to different registers may be
> beneficial on cpus that can do two memory reads in 1 clock.
> 
> Then reduce from 64bits down to 16. Maybe with:
> 	if (odd)
> 		result <<= 8;
> 	result = (u32)result + (result >> 32);
> 	result32 = (u16)result + (result >> 16);
> 	result32 = (u16)result32 + (result32 >> 16);
> 	result32 = (u16)result32 + (result32 >> 16);
> I think you need 4 reduces.
> Modulo 0xffff might generate faster code, but the result domain
> is then 0..0xfffe not 1..0xffff.
> Which is actually better because it is correct when inverted.
> 
> If reducing with adds, it is best to initialise the csum to 1.
> Then add 1 after inverting.
> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 

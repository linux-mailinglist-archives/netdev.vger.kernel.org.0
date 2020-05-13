Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E97031D1ADF
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 18:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389454AbgEMQSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 12:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387522AbgEMQSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 12:18:39 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3A1C061A0C;
        Wed, 13 May 2020 09:18:39 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id j21so7989471pgb.7;
        Wed, 13 May 2020 09:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=M8fG8T9ptCSCK6IcvKJyhlz7IkTokymFqJGL0gqbWiY=;
        b=eW4SV1k1WFNQT/QfgFcSM9x7XW1V8NefUaP7owlayu8J0xFjA6XfYi02g+KUQ/1Ag/
         Wc+c2ywASYFEipxREOKKqKwQlsFigiGgL+F1WPbpbFOomTZzxx54pBc0Z0ra/mI7b/Yf
         v7OPehggPv0vCRg0m/2WrT3smOEUtQbLWS26ECMH4L2SrllHgf2lzLc37cNCV2jV7d05
         7yOaK24ZyaXDQ+Xa6xNGFZYQ/v1R6IkZF+7CFuDx/dzLERwgSPl6e6m329VGymO2l1Sg
         QF1c2osf6ei725DUlFg9aSGU17Ama5xWC0cGIvbNIZptmllUkibNqnQRTEVh8yBC3p5T
         wUow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M8fG8T9ptCSCK6IcvKJyhlz7IkTokymFqJGL0gqbWiY=;
        b=mp26crsh99NktBtv9PR5c8hT0S4ODyiXCqN9IXD06+RN1ty/RMZY/rGgwx7KpX5cHL
         fUHUX06syAuMPPnUezBpov7w8AT0+dD3+nAtmI52SbdTrsSbfRNo7YJAunehxmJQGnul
         O8SZPSqFRgvUfrabXKguXT+uAUxwnhIzocg7Cvyug2LnBmu6pr50ePdT6Xrgg1tX32tV
         ex0xJCj+xJfI8mhxT6FFYqkB5YYNvvQPHxKKY1EDJDseJFjT6YKD9Mhv6TV0a398nn3+
         7gafKyTZawlLxl9vzwJnPthpukjPxFflLsNgWpcxB8TF3sQw3u/3DTDxYWwL54Oy1FcH
         Ok/g==
X-Gm-Message-State: AOAM533HaChN7pxTgtaGf4OqhN4x1pnXPntHmlyl/94B+lqefxDU8fle
        FM54NvGn8GSSIM77KxrY18bwSjRA
X-Google-Smtp-Source: ABdhPJzi9VvKa0/w5+1BuHtl2XrkQ6+7t8LtH32KXQAPY7Sg77A5eb6WnreaERWludW2pfWXwKtlsw==
X-Received: by 2002:a62:32c1:: with SMTP id y184mr87112pfy.306.1589386718638;
        Wed, 13 May 2020 09:18:38 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id kr1sm12486408pjb.26.2020.05.13.09.18.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2020 09:18:37 -0700 (PDT)
Subject: Re: [PATCH 3/3] net: cleanly handle kernel vs user buffers for
 ->msg_control
To:     Christoph Hellwig <hch@lst.de>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200511115913.1420836-1-hch@lst.de>
 <20200511115913.1420836-4-hch@lst.de>
 <c88897b9-7afb-a6f6-08f1-5aaa36631a25@gmail.com>
 <20200513160938.GA22381@lst.de>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b9728e02-e317-2aa6-9ed4-723ee3abfb78@gmail.com>
Date:   Wed, 13 May 2020 09:18:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200513160938.GA22381@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/13/20 9:09 AM, Christoph Hellwig wrote:
> On Wed, May 13, 2020 at 08:41:57AM -0700, Eric Dumazet wrote:
>>> +	 * recv* side when msg_control_is_user is set, msg_control is the kernel
>>> +	 * buffer used for all other cases.
>>> +	 */
>>> +	union {
>>> +		void		*msg_control;
>>> +		void __user	*msg_control_user;
>>> +	};
>>> +	bool		msg_control_is_user : 1;
>>
>> Adding a field in this structure seems dangerous.
>>
>> Some users of 'struct msghdr '  define their own struct on the stack,
>> and are unaware of this new mandatory field.
>>
>> This bit contains garbage, crashes are likely to happen ?
>>
>> Look at IPV6_2292PKTOPTIONS for example.
> 
> I though of that, an that is why the field is structured as-is.  The idea
> is that the field only matters if:
> 
>  (1) we are in the recvmsg and friends path, and
>  (2) msg_control is non-zero
> 
> I went through the places that initialize msg_control to find any spot
> that would need an annotation.  The IPV6_2292PKTOPTIONS sockopt doesn't
> need one as it is using the msghdr in sendmsg-like context.
> 
> That being said while I did the audit I'd appreciate another look from
> people that know the networking code better than me of course.
> 

Please try the following syzbot repro, since it crashes after your patch.

// autogenerated by syzkaller (https://github.com/google/syzkaller)

#define _GNU_SOURCE

#include <endian.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <unistd.h>

uint64_t r[1] = {0xffffffffffffffff};

int main(void)
{
  syscall(__NR_mmap, 0x1ffff000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
  syscall(__NR_mmap, 0x20000000ul, 0x1000000ul, 7ul, 0x32ul, -1, 0ul);
  syscall(__NR_mmap, 0x21000000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
  intptr_t res = 0;

  // socket(AF_INET6, SOCK_STREAM, IPPROTO_IP) = 3
  res = syscall(__NR_socket, 0xaul, 1ul, 0);
  if (res != -1)
    r[0] = res;

  *(uint32_t*)0x20000080 = 7;
  // setsockopt(3, SOL_IPV6, IPV6_2292HOPLIMIT, [7], 4) = 0
  syscall(__NR_setsockopt, r[0], 0x29, 8, 0x20000080ul, 4ul);

  *(uint32_t*)0x20000040 = 0x18ff8;
  // getsockopt(3, SOL_IPV6, IPV6_2292PKTOPTIONS, "\24\0\0\0\0\0\0\0)\0\0\0\10\0\0\0\1\0\0\0\0\0\0\0", [102392->24]) = 0
  syscall(__NR_getsockopt, r[0], 0x29, 6, 0x20004040ul, 0x20000040ul);

  return 0;
}



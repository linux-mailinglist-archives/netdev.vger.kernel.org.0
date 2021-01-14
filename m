Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA652F66C8
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 18:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbhANRGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 12:06:25 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.51]:22767 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727773AbhANRGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 12:06:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1610643809;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:From:
        Subject:Sender;
        bh=99qN2kXUT/2RMJYWOuie1CE2v87wytss3dTpa0fwnqU=;
        b=FI0ij6QYk8H8UwIsX0twj00Iw9XZzhzzBDPm+gwZnMir/A4nr+auY8lZN9+3zUpHWp
        DrQ3j6C9iH3dgKUcL2cneXdu7Ev7eKKWaX51RBJqITNik1LqVsuax823SOaLBe8OBuFa
        +X/7QGpOpTjR3FWMGu4igiVYYTIWEIWprstoicS86pplLzvssLoLUXuT9X2oSq9igMP2
        RCBjKl+3IO9s0rb1Ga30U581s2y5jiNnZS48JLhNh6ktqC7U4N6A7JpRyctycPTKpTso
        PTOZzIJN8Il9OKUWg+o3cn86SNKVdLUoHne4jsQq6DMmjYUcitFeQDgYiRP62eoYGMoc
        PiVQ==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMJVMh7kiA="
X-RZG-CLASS-ID: mo00
Received: from [192.168.50.177]
        by smtp.strato.de (RZmta 47.12.1 DYNA|AUTH)
        with ESMTPSA id k075acx0EH3JUq9
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Thu, 14 Jan 2021 18:03:19 +0100 (CET)
Subject: Re: [net-next 09/17] can: length: can_fd_len2dlc(): simplify length
 calculcation
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-can <linux-can@vger.kernel.org>, kernel@pengutronix.de
References: <20210113211410.917108-1-mkl@pengutronix.de>
 <20210113211410.917108-10-mkl@pengutronix.de>
 <CAMZ6Rq+Wxn_kG7rSkUrMYMqNw790SMe-UKmpUVdEA_eGcjoT+g@mail.gmail.com>
 <2f3fff1a-9a50-030b-6a29-2009c8b65b68@hartkopp.net>
 <CAMZ6RqLKYnGDePueN1ftL9a47Qf-ZR7bc4eLGwzCkncsD6ok2Q@mail.gmail.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <75d3c8e9-acbd-09e9-e185-94833dbfb391@hartkopp.net>
Date:   Thu, 14 Jan 2021 18:03:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CAMZ6RqLKYnGDePueN1ftL9a47Qf-ZR7bc4eLGwzCkncsD6ok2Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 14.01.21 10:16, Vincent MAILHOL wrote:
> On Tue. 14 Jan 2021 at 17:23, Oliver Hartkopp <socketcan@hartkopp.net> wrote:
>> On 14.01.21 02:59, Vincent MAILHOL wrote:
>>> On Tue. 14 Jan 2021 at 06:14, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>>>>
>>>> If the length paramter in len2dlc() exceeds the size of the len2dlc array, we
>>>> return 0xF. This is equal to the last 16 members of the array.
>>>>
>>>> This patch removes these members from the array, uses ARRAY_SIZE() for the
>>>> length check, and returns CANFD_MAX_DLC (which is 0xf).
>>>>
>>>> Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
>>>> Link: https://lore.kernel.org/r/20210111141930.693847-9-mkl@pengutronix.de
>>>> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
>>>> ---
>>>>    drivers/net/can/dev/length.c | 6 ++----
>>>>    1 file changed, 2 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/drivers/net/can/dev/length.c b/drivers/net/can/dev/length.c
>>>> index 5e7d481717ea..d695a3bee1ed 100644
>>>> --- a/drivers/net/can/dev/length.c
>>>> +++ b/drivers/net/can/dev/length.c
>>>> @@ -27,15 +27,13 @@ static const u8 len2dlc[] = {
>>>>           13, 13, 13, 13, 13, 13, 13, 13, /* 25 - 32 */
>>>>           14, 14, 14, 14, 14, 14, 14, 14, /* 33 - 40 */
>>>>           14, 14, 14, 14, 14, 14, 14, 14, /* 41 - 48 */
>>>> -       15, 15, 15, 15, 15, 15, 15, 15, /* 49 - 56 */
>>>> -       15, 15, 15, 15, 15, 15, 15, 15  /* 57 - 64 */
>>>>    };
>>>>
>>>>    /* map the sanitized data length to an appropriate data length code */
>>>>    u8 can_fd_len2dlc(u8 len)
>>>>    {
>>>> -       if (unlikely(len > 64))
>>>> -               return 0xF;
>>>> +       if (len > ARRAY_SIZE(len2dlc))
>>>
>>> Sorry but I missed an of-by-one issue when I did my first
>>> review. Don't know why but it popped to my eyes this morning when
>>> casually reading the emails.
>>
>> Oh, yes.
>>
>> The fist line is 0 .. 8 which has 9 bytes.
>>
>> I also looked on it (from the back), and wondered if it was correct. But
>> didn't see it either at first sight.
>>
>>>
>>> ARRAY_SIZE(len2dlc) is 49. If len is between 0 and 48, use the
>>> array, if len is greater *or equal* return CANFD_MAX_DLC.
>>
>> All these changes and discussions make it very obviously more tricky to
>> understand that code.
>>
>> I don't really like this kind of improvement ...
>>
>> Before that it was pretty clear that we only catch an out of bounds
>> value and usually grab the value from the table.
> 
> I understand your point: all three of us initially missed that
> bug. But now that it is fixed, I would still prefer to keep
> Marc's patch.

No, I'm still against it as it is now.

Even

	if (len >= ARRAY_SIZE(len2dlc))

would need some comment that values > 48 lead to a DLC = 15.

This is not intuitively understandable from that value 
"ARRAY_SIZE(len2dlc)" !

Using ARRAY_SIZE() is a bad choice IMO.

If it's really worth to save 16 bytes I would suggest this:

diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index 3486704c8a95..0b0a5a16943a 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -42,18 +42,17 @@ static const u8 len2dlc[] = {0, 1, 2, 3, 4, 5, 6, 7, 
8,             /* 0 - 8 */
                              10, 10, 10, 10,                    /* 13 - 
16 */
                              11, 11, 11, 11,                    /* 17 - 
20 */
                              12, 12, 12, 12,                    /* 21 - 
24 */
                              13, 13, 13, 13, 13, 13, 13, 13,    /* 25 - 
32 */
                              14, 14, 14, 14, 14, 14, 14, 14,    /* 33 - 
40 */
-                            14, 14, 14, 14, 14, 14, 14, 14,    /* 41 - 
48 */
-                            15, 15, 15, 15, 15, 15, 15, 15,    /* 49 - 
56 */
-                            15, 15, 15, 15, 15, 15, 15, 15};   /* 57 - 
64 */
+                            14, 14, 14, 14, 14, 14, 14, 14};   /* 41 - 
48 */
+                            /* 49 - 64 is checked in  can_fd_len2dlc() */

  /* map the sanitized data length to an appropriate data length code */
  u8 can_fd_len2dlc(u8 len)
  {
-       if (unlikely(len > 64))
+       if (len > 48)
                 return 0xF;

         return len2dlc[len];
  }
  EXPORT_SYMBOL_GPL(can_fd_len2dlc);

Regards,
Oliver

> 
> 
> Yours sincerely,
> Vincent
> 
>>>
>>> In short, replace > by >=:
>>> +       if (len >= ARRAY_SIZE(len2dlc))
>>>
>>>> +               return CANFD_MAX_DLC;
>>>>
>>>>           return len2dlc[len];
>>>>    }

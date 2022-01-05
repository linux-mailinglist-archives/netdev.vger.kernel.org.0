Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE59484FB0
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 10:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233410AbiAEJCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 04:02:00 -0500
Received: from proxima.lasnet.de ([78.47.171.185]:44226 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiAEJB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 04:01:59 -0500
X-Greylist: delayed 48033 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Jan 2022 04:01:58 EST
Received: from [IPV6:2003:e9:d722:f5b8:b3df:e256:11d7:2e0d] (p200300e9d722f5b8b3dfe25611d72e0d.dip0.t-ipconnect.de [IPv6:2003:e9:d722:f5b8:b3df:e256:11d7:2e0d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 7AC8FC0A36;
        Wed,  5 Jan 2022 10:01:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1641373317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bvqacC8i3xL41fYYYbc5wjA74e/tTyJLPCJ2AoWFAiw=;
        b=TPmAWeHqVwKrLpgrodE7JTdS3xsNYv7Rwo2OPJAmJ2YcI8HEsdW/5oZbVfRQQTeup3QFpZ
        EB4HvZNfpzyrrTDBnMzTBQLL2JMSOIlFw+NGYoHVjPboBn14T2XnzTn/UgoQCeruPZeL18
        eZfzVmJDiteQ3orTqIAbsp/vd5v1xI9HPWJxeWogMpI1t5ySkSpgHn5eQK+Jsy4M1cGMdA
        BeCqi1uu+RBaCklnHfrHP3v97erl1c47GChyW7hE4CW4VC9yBrMhfq/zdIlkrvuJqGmVc0
        IQElFQ9QiSTNWKUj20sLvF9ReA2GcylEYOzKug2D/614yIvYFPJ177F2J8Rm+w==
Message-ID: <33c41865-4915-38f4-448a-9dc80c403b6c@datenfreihafen.org>
Date:   Wed, 5 Jan 2022 10:01:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH RFT] ieee802154: atusb: move to new USB API
Content-Language: en-US
To:     Greg KH <greg@kroah.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Pavel Skripkin <paskripkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "# 3.19.x" <stable@vger.kernel.org>,
        Alexander Potapenko <glider@google.com>
References: <CAG_fn=VDEoQx5c7XzWX1yaYBd5y5FrG1aagrkv+SZ03c8TfQYQ@mail.gmail.com>
 <20220102171943.28846-1-paskripkin@gmail.com> <YdL0GPxy4TdGDzOO@kroah.com>
 <CAB_54W7HQmm1ncCEsTmZFR+GVf6p6Vz0RMWDJXAhXQcW4r3hUQ@mail.gmail.com>
 <ab1ec1c0-389c-dcae-9cd8-6e6771a94178@datenfreihafen.org>
 <YdVSBy47e0+OdXAo@kroah.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <YdVSBy47e0+OdXAo@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello.

On 05.01.22 09:08, Greg KH wrote:
> On Tue, Jan 04, 2022 at 08:41:23PM +0100, Stefan Schmidt wrote:
>> Hello.
>>
>> On 03.01.22 16:35, Alexander Aring wrote:
>>> Hi,
>>>
>>> On Mon, 3 Jan 2022 at 08:03, Greg KH <greg@kroah.com> wrote:
>>>>
>>>> On Sun, Jan 02, 2022 at 08:19:43PM +0300, Pavel Skripkin wrote:
>>>>> Alexander reported a use of uninitialized value in
>>>>> atusb_set_extended_addr(), that is caused by reading 0 bytes via
>>>>> usb_control_msg().
>>>>>
>>>>> Since there is an API, that cannot read less bytes, than was requested,
>>>>> let's move atusb driver to use it. It will fix all potintial bugs with
>>>>> uninit values and make code more modern
>>>>>
>>>>> Fail log:
>>>>>
>>>>> BUG: KASAN: uninit-cmp in ieee802154_is_valid_extended_unicast_addr include/linux/ieee802154.h:310 [inline]
>>>>> BUG: KASAN: uninit-cmp in atusb_set_extended_addr drivers/net/ieee802154/atusb.c:1000 [inline]
>>>>> BUG: KASAN: uninit-cmp in atusb_probe.cold+0x29f/0x14db drivers/net/ieee802154/atusb.c:1056
>>>>> Uninit value used in comparison: 311daa649a2003bd stack handle: 000000009a2003bd
>>>>>    ieee802154_is_valid_extended_unicast_addr include/linux/ieee802154.h:310 [inline]
>>>>>    atusb_set_extended_addr drivers/net/ieee802154/atusb.c:1000 [inline]
>>>>>    atusb_probe.cold+0x29f/0x14db drivers/net/ieee802154/atusb.c:1056
>>>>>    usb_probe_interface+0x314/0x7f0 drivers/usb/core/driver.c:396
>>>>>
>>>>> Fixes: 7490b008d123 ("ieee802154: add support for atusb transceiver")
>>>>> Cc: stable@vger.kernel.org # 5.9
>>>>> Reported-by: Alexander Potapenko <glider@google.com>
>>>>> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
>>>>> ---
>>>>>    drivers/net/ieee802154/atusb.c | 61 +++++++++++++++++++++-------------
>>>>>    1 file changed, 38 insertions(+), 23 deletions(-)
>>>>>
>>>>> diff --git a/drivers/net/ieee802154/atusb.c b/drivers/net/ieee802154/atusb.c
>>>>> index 23ee0b14cbfa..43befea0110f 100644
>>>>> --- a/drivers/net/ieee802154/atusb.c
>>>>> +++ b/drivers/net/ieee802154/atusb.c
>>>>> @@ -80,10 +80,9 @@ struct atusb_chip_data {
>>>>>     * in atusb->err and reject all subsequent requests until the error is cleared.
>>>>>     */
>>>>>
>>>>> -static int atusb_control_msg(struct atusb *atusb, unsigned int pipe,
>>>>> -                          __u8 request, __u8 requesttype,
>>>>> -                          __u16 value, __u16 index,
>>>>> -                          void *data, __u16 size, int timeout)
>>>>> +static int atusb_control_msg_recv(struct atusb *atusb, __u8 request, __u8 requesttype,
>>>>> +                               __u16 value, __u16 index,
>>>>> +                               void *data, __u16 size, int timeout)
>>>>
>>>> Why do you need a wrapper function at all?  Why not just call the real
>>>> usb functions instead?
>>
>>> ...
>>
>>>>
>>>> I would recommend just moving to use the real USB functions and no
>>>> wrapper function at all like this, it will make things more obvious and
>>>> easier to understand over time.
>>>
>>> okay.
>>
>> With the small fix handle the actual KASAN report applied now
> 
> It was?  What is the git commit id?

I applied it to my wpan tree from where it will go to the net tree with 
my next pull request.

https://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan.git/commit/?id=754e4382354f7908923a1949d8dc8d05f82f09cb

regards
Stefan Schmidt

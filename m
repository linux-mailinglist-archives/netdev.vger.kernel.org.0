Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C863C48487E
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 20:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236511AbiADTZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 14:25:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233519AbiADTZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 14:25:19 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC83C061761;
        Tue,  4 Jan 2022 11:25:18 -0800 (PST)
Received: from [IPV6:2003:e9:d728:ec47:4b31:73e4:34c5:505a] (p200300e9d728ec474b3173e434c5505a.dip0.t-ipconnect.de [IPv6:2003:e9:d728:ec47:4b31:73e4:34c5:505a])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id CEE48C0415;
        Tue,  4 Jan 2022 20:25:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1641324317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bw3hpNQowQK11PHaZnn5IhTyLqHlg1dmT/+wocBWB+A=;
        b=ve+OL/AvIGLVMZQjagL89I7SCFIr0h9EHDZ5Apw1iwLuVm+rWjK9pH0N4UUPWAgp1IC643
        31MsUxhnNXofNqWUVHOVxRzl+K+3/fgG3LpkeECJaCG9biD+lslTfQopQOVu9/qSRwX6EW
        NIWYUIhaO3HKg0LEnIRHn/5jN1m3x7EwG5ee9go3VQq6dTOUBI8YsksksPCgfgidnBsi38
        rj8YwWHCR+RZaiZY39eeUnuxIt0TARDFcWC7MXyAS+L1wKQmdw3/2ikVjRe0KrANpsCG9h
        /dQniN9zR+h+kRNxXLfig4Gqfea30GngBP21LKz8H8u7ETP7527M5DiAfCbKlw==
Message-ID: <3b35da92-0468-cc08-b7aa-d9d52af74291@datenfreihafen.org>
Date:   Tue, 4 Jan 2022 20:25:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3] ieee802154: atusb: fix uninit value in
 atusb_set_extended_addr
Content-Language: en-US
To:     Alexander Aring <aahringo@redhat.com>,
        Pavel Skripkin <paskripkin@gmail.com>
Cc:     alex.aring@gmail.com, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>, linux-wpan@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Alexander Potapenko <glider@google.com>
References: <e8e73fcc-b902-4972-6001-84671361146d@datenfreihafen.org>
 <20220104182806.7188-1-paskripkin@gmail.com>
 <CAK-6q+jkQqZ-Mog2Bwq2EGWFYv-vYtSYRJMqJUARm=C+Cd+uRA@mail.gmail.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <CAK-6q+jkQqZ-Mog2Bwq2EGWFYv-vYtSYRJMqJUARm=C+Cd+uRA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 04.01.22 19:57, Alexander Aring wrote:
> Hi,
> 
> On Tue, Jan 4, 2022 at 1:28 PM Pavel Skripkin <paskripkin@gmail.com> wrote:
>>
>> Alexander reported a use of uninitialized value in
>> atusb_set_extended_addr(), that is caused by reading 0 bytes via
>> usb_control_msg().
>>
>> Fix it by validating if the number of bytes transferred is actually
>> correct, since usb_control_msg() may read less bytes, than was requested
>> by caller.
>>
>> Fail log:
>>
>> BUG: KASAN: uninit-cmp in ieee802154_is_valid_extended_unicast_addr include/linux/ieee802154.h:310 [inline]
>> BUG: KASAN: uninit-cmp in atusb_set_extended_addr drivers/net/ieee802154/atusb.c:1000 [inline]
>> BUG: KASAN: uninit-cmp in atusb_probe.cold+0x29f/0x14db drivers/net/ieee802154/atusb.c:1056
>> Uninit value used in comparison: 311daa649a2003bd stack handle: 000000009a2003bd
>>   ieee802154_is_valid_extended_unicast_addr include/linux/ieee802154.h:310 [inline]
>>   atusb_set_extended_addr drivers/net/ieee802154/atusb.c:1000 [inline]
>>   atusb_probe.cold+0x29f/0x14db drivers/net/ieee802154/atusb.c:1056
>>   usb_probe_interface+0x314/0x7f0 drivers/usb/core/driver.c:396
>>
>> Fixes: 7490b008d123 ("ieee802154: add support for atusb transceiver")
>> Reported-by: Alexander Potapenko <glider@google.com>
>> Acked-by: Alexander Aring <aahringo@redhat.com>
>> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
>> ---
>>
>> Changes in v3:
>>          - Changed atusb_control_msg() to usb_control_msg() in
>>            atusb_get_and_show_build(), since request there may read various length
>>            data
>>
> 
> Thanks for catching this.

Test passed my testing.


This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt

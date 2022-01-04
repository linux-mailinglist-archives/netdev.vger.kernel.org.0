Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA4F48476A
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 19:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236075AbiADSFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 13:05:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233070AbiADSFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 13:05:03 -0500
X-Greylist: delayed 8655 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 04 Jan 2022 10:05:02 PST
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC97C061761;
        Tue,  4 Jan 2022 10:05:02 -0800 (PST)
Received: from [IPV6:2003:e9:d728:ec47:4b31:73e4:34c5:505a] (p200300e9d728ec474b3173e434c5505a.dip0.t-ipconnect.de [IPv6:2003:e9:d728:ec47:4b31:73e4:34c5:505a])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 0115BC0415;
        Tue,  4 Jan 2022 19:04:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1641319499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DKQgdD9UVcoJQH9gQCvyiU77/QftK6OHmHhiDWE5QIg=;
        b=n29ks7y+azv5RfM5srljIY8TOtYBNRriyQe3KisZ3F2HczxWmSJutqqJA1dUj5s2KulEl3
        HUjsf12Dc11nVUu8Pd2gJuvFASp0NdT3ev4YWzEzGBhyPc5gvK7lpbzcI/yHRacapMj9iv
        gaggDAp0pGnNiXtz1bTa/Epp2LTRl+HLe+D7ylf28psbyBw1NtWrIskrWWiG+Z1cyfkEI4
        s0OB39ZLTs1x+FW9FhsCgmLDUle8SPHA38X+wV0HRswC33akrH9Kvx7ypesDMD8mqSoC7Y
        7MYmTLmmcq+UXygAbmxbcGNPdp60fqJrsTTt47+hS8L3Ae6XvCUgeTlxk5BTkQ==
Message-ID: <e8e73fcc-b902-4972-6001-84671361146d@datenfreihafen.org>
Date:   Tue, 4 Jan 2022 19:04:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2] ieee802154: atusb: fix uninit value in
 atusb_set_extended_addr
Content-Language: en-US
To:     Pavel Skripkin <paskripkin@gmail.com>, alex.aring@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexander Potapenko <glider@google.com>
References: <CAB_54W50xKFCWZ5vYuDG2p4ijpd63cSutRrV4MLs9oasLmKgzQ@mail.gmail.com>
 <20220103120925.25207-1-paskripkin@gmail.com>
 <ed39cbe6-0885-a3ab-fc30-7c292e1acc53@datenfreihafen.org>
 <5b0b8dc6-f038-bfaa-550c-dc23636f0497@gmail.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <5b0b8dc6-f038-bfaa-550c-dc23636f0497@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 04.01.22 18:27, Pavel Skripkin wrote:
> On 1/4/22 18:40, Stefan Schmidt wrote:
>>
>> It compiles, but does not work on the real hardware.
>>
>> [    1.114698] usb 1-1: new full-speed USB device number 2 using uhci_hcd
>> [    1.261691] usb 1-1: New USB device found, idVendor=20b7,
>> idProduct=1540, bcdDevice= 0.01
>> [    1.263421] usb 1-1: New USB device strings: Mfr=0, Product=0,
>> SerialNumber=1
>> [    1.264952] usb 1-1: SerialNumber: 4630333438371502231a
>> [    1.278042] usb 1-1: ATUSB: AT86RF231 version 2
>> [    1.281087] usb 1-1: Firmware: major: 0, minor: 3, hardware type:
>> ATUSB (2)
>> [    1.285191] usb 1-1: atusb_control_msg: req 0x01 val 0x0 idx 0x0,
>> error -61
>> [    1.286903] usb 1-1: failed to fetch extended address, random 
>> address set
>> [    1.288757] usb 1-1: atusb_probe: initialization failed, error = -61
>> [    1.290922] atusb: probe of 1-1:1.0 failed with error -61
>>
>>
>> Without your patch it works as expected:
>>
>> [    1.091925] usb 1-1: new full-speed USB device number 2 using uhci_hcd
>> [    1.237743] usb 1-1: New USB device found, idVendor=20b7,
>> idProduct=1540, bcdDevice= 0.01
>> [    1.239788] usb 1-1: New USB device strings: Mfr=0, Product=0,
>> SerialNumber=1
>> [    1.241432] usb 1-1: SerialNumber: 4630333438371502231a
>> [    1.255012] usb 1-1: ATUSB: AT86RF231 version 2
>> [    1.258073] usb 1-1: Firmware: major: 0, minor: 3, hardware type:
>> ATUSB (2)
>> [    1.262170] usb 1-1: Firmware: build #132 Mo 28. Nov 16:20:35 CET 2016
>> [    1.266195] usb 1-1: Read permanent extended address
>> 10:e2:d5:ff:ff:00:02:e8 from device
>>
> 
> Hi Stefan,
> 
> thanks for testing on real hw.
> 
> It looks like there is corner case, that Greg mentioned in this thread. 
> atusb_get_and_show_build() reads firmware build info, which may have 
> various length.
> 
> Maybe we can change atusb_control_msg() to usb_control_msg() in 
> atusb_get_and_show_build(), since other callers do not have this problem

That works for me.

I will also have a look at the use of the modern USB API for next. The 
fix here has a higher prio for me to get in and backported though. Once 
we have this we can look at bigger changes in atusb.

regards
Stefan Schmidt

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAB8219609F
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 22:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbgC0VrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 17:47:12 -0400
Received: from canardo.mork.no ([148.122.252.1]:42535 "EHLO canardo.mork.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726781AbgC0VrL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 17:47:11 -0400
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 02RLl9rZ024837
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Fri, 27 Mar 2020 22:47:09 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1585345629; bh=FbBNkhdDWvf9d/rLzYaTbyjNQY3RpIExha48Cd2+P/c=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=gb2b4vzqhf0kiyQ5MEDhH+kc8s4gj7bS0md1Z4OEbLXxRoJNozLQhnF40iUrLx9ig
         48Xl1tbvwfOp1nF/m0BPl0KIxG0fiO+XwKruILAq2CklvbRjwD23OGNjSt3HcJunBQ
         a4IpJ0zLwWRe0swdSao6UJ5nWrS0x18/MiNgp47c=
Received: from bjorn by miraculix.mork.no with local (Exim 4.92)
        (envelope-from <bjorn@mork.no>)
        id 1jHwon-0005Yu-2Z; Fri, 27 Mar 2020 22:47:09 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Bobby Jones <rjones@gateworks.com>
Cc:     netdev@vger.kernel.org
Subject: Re: Toby MPCI - L201 cellular modem http hang after random MAC address assignment
Organization: m
References: <CALAE=UDvPU-MBX5B7NU1A7WPq1gofUnr8Rf+v81AxHLLcZhMvA@mail.gmail.com>
Date:   Fri, 27 Mar 2020 22:47:09 +0100
In-Reply-To: <CALAE=UDvPU-MBX5B7NU1A7WPq1gofUnr8Rf+v81AxHLLcZhMvA@mail.gmail.com>
        (Bobby Jones's message of "Mon, 23 Mar 2020 10:21:36 -0700")
Message-ID: <871rpdeahu.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.102.1 at canardo
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bobby Jones <rjones@gateworks.com> writes:

>> --- a/drivers/net/usb/rndis_host.c
>> +++ b/drivers/net/usb/rndis_host.c
>> @@ -428,7 +428,11 @@ generic_rndis_bind(struct usbnet *dev, struct usb_i=
nterface *intf, int flags)
>>                 dev_err(&intf->dev, "rndis get ethaddr, %d\n", retval);
>>                 goto halt_fail_and_release;
>>         }
>> -       memcpy(net->dev_addr, bp, ETH_ALEN);
>> +
>> +       if (bp[0] & 0x02)
>> +               eth_hw_addr_random(net);
>> +       else
>> +               ether_addr_copy(net->dev_addr, bp);
>>
>>         /* set a nonzero filter to enable data transfers */
>>         memset(u.set, 0, sizeof *u.set);
>
> I know that there is some internal routing done by the modem firmware,
> and I'm assuming that overwriting the MAC address breaks said routing.
> Can anyone suggest what a proper fix would be?

That change should not break anything that wasn't already broken, given
that the driver allows userspace to set any valid ethernet address.

But I'm sure you're right that the modem doesn't like it. Since the
patch also fixed a real problem, then I guess we need to add a device
specific workaround for this modem.

I know exactly nothing about RNDIS and have no such device. But looking
at this now I wonder if the driver should have informed the device about
any adress changes?  I note that we have an
RNDIS_OID_802_3_CURRENT_ADDRESS, which is unused by the usb host driver.

Looking at the rndis gadget driver, I also note that it would refuse
setting RNDIS_OID_802_3_CURRENT_ADDRESS, Which probably means that any
Linux based device would fail if we tried that.  So it's probably not
a good idea as a workaround even if it helped your case. Which is very
unlikely after all. Don't even know if that's how it was supposed to
be.

Oh well.  Just add a device specific exception. Look at the
RNDIS_DRIVER_DATA_POLL_STATUS thing and do something similar for this
case, avoiding the unwanted address update


Bj=C3=B8rn

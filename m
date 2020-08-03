Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA2823A2CF
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 12:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgHCKln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 06:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgHCKlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 06:41:42 -0400
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CBF6C06174A;
        Mon,  3 Aug 2020 03:41:42 -0700 (PDT)
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 073AesFj020085
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Mon, 3 Aug 2020 12:40:54 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1596451255; bh=sbO29wH2iO2+x7SK3Zlts21jZX4eIU9YpmoVEt1ZL7k=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=drTWXDkhr7GiZjh19NA5scC5D6LIJ+0wMGxz4Bwp8zydwY22yIBBjhgLHjAedrCtX
         wBp3xpd8oTT8yjF5CogqL7OELT1nStp6a0MtkEf7cLIzuZTDfho1dKZun9vBhDMyXn
         tp8aGlgHlEOt//TII+owcnChrKEeqbwg5wb40DFM=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94)
        (envelope-from <bjorn@mork.no>)
        id 1k2Xtm-000IZu-E7; Mon, 03 Aug 2020 12:40:54 +0200
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, yzc666@netease.com,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev@vger.kernel.org, linux-usb <linux-usb@vger.kernel.org>,
        carl <carl.yin@quectel.com>
Subject: Re: [PATCH] qmi_wwan: support modify usbnet's rx_urb_size
Organization: m
References: <20200803065105.8997-1-yzc666@netease.com>
        <20200803081604.GC493272@kroah.com>
        <CAGRyCJE-BF=0tWakreObGv-skahDp-ui8zP1TPPkX48sMFk4-w@mail.gmail.com>
        <20200803094931.GD635660@kroah.com>
        <CAGRyCJER3J4BkLohcPumdKUkQ9g39YsjERac5CSrY2-8jj+N7A@mail.gmail.com>
Date:   Mon, 03 Aug 2020 12:40:54 +0200
In-Reply-To: <CAGRyCJER3J4BkLohcPumdKUkQ9g39YsjERac5CSrY2-8jj+N7A@mail.gmail.com>
        (Daniele Palmas's message of "Mon, 3 Aug 2020 12:33:03 +0200")
Message-ID: <87lfiw9fm1.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.102.4 at canardo
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniele Palmas <dnlplm@gmail.com> writes:
> Il giorno lun 3 ago 2020 alle ore 11:49 Greg KH
> <gregkh@linuxfoundation.org> ha scritto:
>>
>> Where does QMI_WDA_SET_DATA_FORMAT come from?
>>
>
> This is a request of Qualcomm proprietary protocol used, among other
> things, to configure data aggregation for modems. There's an open
> source userspace implementation in the libqmi project
> (https://cgit.freedesktop.org/libqmi/tree/data/qmi-service-wda.json)
>
>> And the commit log says that this "depends on the chipset being used",
>> so why don't you know that at probe time, does the chipset change?  :)
>>
>
> Me too does not understand this, I let the author explain...
>
>> > Currently there's a workaround for setting rx_urb_size i.e. changing
>> > the network interface MTU: this is fine for most uses with qmap, but
>> > there's the limitation that certain values (multiple of the endpoint
>> > size) are not allowed.
>>
>> Why not just set it really high to start with?  That should not affect
>> any older devices, as the urb size does not matter.  The only thing is
>> if it is too small that things can not move as fast as they might be
>> able to.
>>
>
> Yes, this was proposed in the past by Bj=C3=B8rn
> (https://lists.freedesktop.org/archives/libqmi-devel/2020-February/003221=
.html),
> but I was not sure about issues with old modems.

Ah, right.  Forgot about that.

> Now I understand that there are no such issues, then I agree this is
> the simplest solution: I've seen modems requiring as much as 49152,
> but usually the default for qmap is <=3D 16384.
>
> And, by the way, increasing the rx urb size is required also in
> non-qmap mode, since the current value leads to babbling issues with
> some chipsets (mine
> https://www.spinics.net/lists/linux-usb/msg198025.html and Paul's
> https://lists.freedesktop.org/archives/libqmi-devel/2020-February/003217.=
html),
> so I think we should definitely increase this also for non-qmap mode.
>
> Bj=C3=B8rn, what do you think?


I think we have good enough reasons to increase the rx urb size by
default.  Let's try.



Bj=C3=B8rn

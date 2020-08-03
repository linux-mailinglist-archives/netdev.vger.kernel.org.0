Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB2023A2C4
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 12:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgHCKdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 06:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgHCKds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 06:33:48 -0400
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37212C06174A;
        Mon,  3 Aug 2020 03:33:48 -0700 (PDT)
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 073AWlCj014053
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Mon, 3 Aug 2020 12:32:47 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1596450769; bh=ywKJJYEaqrMP3rBbr28H7fcIEWJIbjsJG6XvCfIuoIc=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=XMZj0/gFO9BEzWA6ofys6f7lT75FSd1mVqJK8eoQYLlM04FCMSvgDdi5jthD89iVg
         C+36d2xFgPK7cdVY9YAdeQ1CgRqL1GK5olfzlMJ9q8UvlPOqGGbjVrpIcNyiGOe6bT
         C0mW0NGqwr/0j7qwi76eXYRFGnyjIdVFhO6bA4Os=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94)
        (envelope-from <bjorn@mork.no>)
        id 1k2Xlu-000IZR-IL; Mon, 03 Aug 2020 12:32:46 +0200
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
Date:   Mon, 03 Aug 2020 12:32:46 +0200
In-Reply-To: <CAGRyCJE-BF=0tWakreObGv-skahDp-ui8zP1TPPkX48sMFk4-w@mail.gmail.com>
        (Daniele Palmas's message of "Mon, 3 Aug 2020 10:26:18 +0200")
Message-ID: <87r1so9fzl.fsf@miraculix.mork.no>
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
> Il giorno lun 3 ago 2020 alle ore 10:18 Greg KH
> <gregkh@linuxfoundation.org> ha scritto:
>
>> Actually, no, this all should be done "automatically", do not change the
>> urb size on the fly.  Change it at probe time based on the device you
>> are using, do not force userspace to "know" what to do here, as it will
>> not know that at all.
>>
>
> the problem with doing at probe time is that rx_urb_size is not fixed,
> but depends on the configuration done at the userspace level with
> QMI_WDA_SET_DATA_FORMAT, so the userspace knows that.

Yes, but the driver "will know" (or "may assume") this based on the
QMI_WWAN_FLAG_MUX flag, as long as we are using the driver internal
(de)muxing.  We should be able to automatically set a sane rx_urb_size
value based on this?

Not sure if the rmnet driver currently can be used on top of qmi_wwan?
That will obviously need some other workaround.

> Currently there's a workaround for setting rx_urb_size i.e. changing
> the network interface MTU: this is fine for most uses with qmap, but
> there's the limitation that certain values (multiple of the endpoint
> size) are not allowed.

And this also requires an additional setup step for user/userspace,
which we should try to avoid if possible.

I'm all for a fully automatic solution.  I don't think rx_urb_size
should be directly configurable. And it it were, then it should be
implemented in the usbnet framework. It is not a qmi_wwan specific
attribute.


Bj=C3=B8rn

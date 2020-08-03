Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAFE623A80D
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 16:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgHCOHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 10:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbgHCOHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 10:07:51 -0400
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E18FC06174A;
        Mon,  3 Aug 2020 07:07:50 -0700 (PDT)
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 073E5rAv030315
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Mon, 3 Aug 2020 16:05:54 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1596463556; bh=nnHyknsloTg9/zoyWFmVkZWq8+E9g/PKeL3PmL0/MdA=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=C+Akmr9GOm64OcPrxh44HxykYacQvrvq6JhIZEEE6o6Fo1NRdgFx+QkVv2GY3o6dX
         CU4a+x/VK2/6uUEP3bheU+9malNY5KIhs63V39Ls+mmbMjXsadRa43jKyuHFOekhV8
         pUy4ZM6w+1Ss5Hh7/jM84lZ3/BwSCnfyywY1obX8=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94)
        (envelope-from <bjorn@mork.no>)
        id 1k2b68-000J0p-U2; Mon, 03 Aug 2020 16:05:52 +0200
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     =?utf-8?B?Q2FybCBZaW4o5q635byg5oiQKQ==?= <carl.yin@quectel.com>
Cc:     Daniele Palmas <dnlplm@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "yzc666\@netease.com" <yzc666@netease.com>,
        David Miller <davem@davemloft.net>,
        "kuba\@kernel.org" <kuba@kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>
Subject: Re: =?utf-8?B?562U5aSNOg==?= [PATCH] qmi_wwan: support modify
 usbnet's rx_urb_size
Organization: m
References: <2a2ddc57522e8fb2512e02feacbc2886@sslemail.net>
        <87r1so9fzl.fsf@miraculix.mork.no>
        <HK2PR06MB3507C4CD349BBD29C68F3FCE864D0@HK2PR06MB3507.apcprd06.prod.outlook.com>
Date:   Mon, 03 Aug 2020 16:05:52 +0200
In-Reply-To: <HK2PR06MB3507C4CD349BBD29C68F3FCE864D0@HK2PR06MB3507.apcprd06.prod.outlook.com>
        ("Carl =?utf-8?B?WWluKOaut+W8oOaIkCkiJ3M=?= message of "Mon, 3 Aug 2020
 12:08:24 +0000")
Message-ID: <87d047akov.fsf@miraculix.mork.no>
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

"Carl Yin(=E6=AE=B7=E5=BC=A0=E6=88=90)" <carl.yin@quectel.com> writes:

> Hi Bj=C3=B8rn,=20
> 	You can check cdc_ncm.c.
> 	cdc ncm driver set 'rx_urb_size' on driver probe time, and the value rea=
d from' cdc_ncm_bind_common() 's USB_CDC_GET_NTB_FORMAT '.
> 	and also allow the userspace to modify 'rx_urb_size' by ' /sys/class/net=
/wwan0/cdc_ncm/rx_max'.

And I must admit I wrote that code ;-)

NCM has the concept of 'dwNtbInMaxSize' and 'dwNtbOutMaxSize'
controlling the maximum USB buffer size in each direction. The values
are set by the device and provided to the host driver when probing. The
driver then knows it must be prepared to receive up to 'dwNtbInMaxSize'
buffers and set 'rx_urb_size' to this value.

This is fully automatic and will Just Work without user/userspace
intervention for any sane NCM or MBIM device.

'rx_max' was introduced to handle the insane devices, wanting buffers
larger than the host was prepared to give them. The limit used to be
hard coded in the driver.  But it was enough for some low end
hosts, so I made it configurable using that sysfs knob.

You are right that the rmnet aggregation situation is similar. But
similar to NCM, I would like a solution which is fully automatic for
most of the users.  Or preferably all, if possible.  A sysfs knob is a
last resort thing.  Let's try to do without it first.



Bj=C3=B8rn

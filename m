Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD2F3FD54A
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 10:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243117AbhIAIXp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 1 Sep 2021 04:23:45 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:27786 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242926AbhIAIXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 04:23:42 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-100-_u3ncUtINZaJltL-_PpvhA-1; Wed, 01 Sep 2021 09:22:44 +0100
X-MC-Unique: _u3ncUtINZaJltL-_PpvhA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Wed, 1 Sep 2021 09:22:42 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.023; Wed, 1 Sep 2021 09:22:42 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jakub Kicinski' <kuba@kernel.org>,
        Peter Collingbourne <pcc@google.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Colin Ian King <colin.king@canonical.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Arnd Bergmann" <arnd@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] net: don't unconditionally copy_from_user a struct
 ifreq for socket ioctls
Thread-Topic: [PATCH v2] net: don't unconditionally copy_from_user a struct
 ifreq for socket ioctls
Thread-Index: AQHXnoV4A6XjTyzNuk62FGlW78jf5auO1z/Q
Date:   Wed, 1 Sep 2021 08:22:42 +0000
Message-ID: <bf0f47974d7141358d810d512d4b9a00@AcuMS.aculab.com>
References: <20210826194601.3509717-1-pcc@google.com>
 <20210831093006.6db30672@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210831093006.6db30672@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski
> Sent: 31 August 2021 17:30
> 
> On Thu, 26 Aug 2021 12:46:01 -0700 Peter Collingbourne wrote:
> > @@ -3306,6 +3308,8 @@ static int compat_ifr_data_ioctl(struct net *net, unsigned int cmd,
> >  	struct ifreq ifreq;
> >  	u32 data32;
> >
> > +	if (!is_socket_ioctl_cmd(cmd))
> > +		return -ENOTTY;
> >  	if (copy_from_user(ifreq.ifr_name, u_ifreq32->ifr_name, IFNAMSIZ))
> >  		return -EFAULT;
> >  	if (get_user(data32, &u_ifreq32->ifr_data))
> 
> Hi Peter, when resolving the net -> net-next merge conflict I couldn't
> figure out why this chunk is needed. It seems all callers of
> compat_ifr_data_ioctl() already made sure it's a socket IOCTL.
> Please double check my resolution (tip of net-next) and if this is
> indeed unnecessary perhaps send a cleanup? Thanks!

To stop the copy_from_user() faulting when the user buffer
isn't long enough.
In particular for iasatty() on arm with tagged pointers.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


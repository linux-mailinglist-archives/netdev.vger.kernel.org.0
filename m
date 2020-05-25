Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A021E14D4
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 21:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390136AbgEYThy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 25 May 2020 15:37:54 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:45912 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389985AbgEYThy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 15:37:54 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-232-sTToDJtAOvqxCcC2xDEG0A-1; Mon, 25 May 2020 20:37:50 +0100
X-MC-Unique: sTToDJtAOvqxCcC2xDEG0A-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 25 May 2020 20:37:49 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 25 May 2020 20:37:49 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Christoph Hellwig' <hch@lst.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: do a single memdup_user in sctp_setsockopt
Thread-Topic: do a single memdup_user in sctp_setsockopt
Thread-Index: AQHWL5hibpEyDKsV4UyRPKuzFFnyuaizvkKggAGHkhuAA+6CkA==
Date:   Mon, 25 May 2020 19:37:49 +0000
Message-ID: <38061a608f294766846e23170bdf0177@AcuMS.aculab.com>
References: <20200521174724.2635475-1-hch@lst.de>
 <348217b7a3e14c1fa4868e47362be9c5@AcuMS.aculab.com>
 <20200522143623.GA386664@localhost.localdomain>
 <20200523071929.GA10466@lst.de>
In-Reply-To: <20200523071929.GA10466@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: 'Christoph Hellwig'
> Sent: 23 May 2020 08:19
...
> Alternatively I'll also happily only do a partial conversion for what
> I need for the kernel_setsockopt removal and let you and Dave decided
> what you guys prefer for the rest.

I presume the justification for removing kernel_[sg]etsockopt()
is that you want to get rid of set_fs(KERNEL_DS).
(Which I believe is only a flag to access_ok()?)
In any case I'm not against that at all.

To do that you also need to solve the problem of the BPF 'hook'
in setsockopt() that can also need to pass a kernel buffer through.

I don't see a rush to remove kernel_[sg]etsockopt() until you
have a solution for the BPF hook.
Especially since, until set_fs() is removed, any driver can
(and probably will) just implement their own version.

I think you may end up with the protocols being able to export
either [sg]etsockopt() functions or kernel_[sg]setsockopt()
functions and some paths erroring if the required function is absent.

But even that isn't trivial given the broken nature of one
sctp option - where the returned length has to be invalid!

I'm going to post a V3 of my big patch - I spotted an error.
I'll include a different (smaller) patch in 0/1 that generates
exactly the same object code but is easier to review.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


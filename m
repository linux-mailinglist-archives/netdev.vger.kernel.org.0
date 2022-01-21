Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01698495D83
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 11:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349944AbiAUKNa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 21 Jan 2022 05:13:30 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:54345 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349942AbiAUKNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 05:13:30 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mtapsc-8-R0oBiZPIM5ejc0JhiWe5Bg-1; Fri, 21 Jan 2022 10:13:27 +0000
X-MC-Unique: R0oBiZPIM5ejc0JhiWe5Bg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Fri, 21 Jan 2022 10:13:26 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Fri, 21 Jan 2022 10:13:26 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Tony Nguyen' <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: RE: [PATCH net 1/5] i40e: Increase delay to 1 s after global EMP
 reset
Thread-Topic: [PATCH net 1/5] i40e: Increase delay to 1 s after global EMP
 reset
Thread-Index: AQHYDlpdj2YNPWG2vEOJK5k4JOB2f6xtQe0g
Date:   Fri, 21 Jan 2022 10:13:26 +0000
Message-ID: <9fadab3c5fa04310a1171ef7f48c8f88@AcuMS.aculab.com>
References: <20220121000305.1423587-1-anthony.l.nguyen@intel.com>
 <20220121000305.1423587-2-anthony.l.nguyen@intel.com>
In-Reply-To: <20220121000305.1423587-2-anthony.l.nguyen@intel.com>
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

From: Tony Nguyen
> Sent: 21 January 2022 00:03
> 
> Recently simplified i40e_rebuild causes that FW sometimes
> is not ready after NVM update, the ping does not return.
> 
> Increase the delay in case of EMP reset.
> Old delay of 300 ms was introduced for specific cards for 710 series.
> Now it works for all the cards and delay was increased.
...
> +	if (test_and_clear_bit(__I40E_EMP_RESET_INTR_RECEIVED, pf->state)) {
> +		/* The following delay is necessary for firmware update. */
> +		mdelay(1000);
>  	}

Spinning for a second isn't 'user friendly'.
If there are no locks held you can sleep.
If there are locks held then another cpu can spin waiting for the lock.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78A674BC17B
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 22:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235888AbiBRVBj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 18 Feb 2022 16:01:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233324AbiBRVBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 16:01:38 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A9FD028B609
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 13:01:20 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-23--g5gUCALPh2mW1qf-CLnLg-1; Fri, 18 Feb 2022 21:01:17 +0000
X-MC-Unique: -g5gUCALPh2mW1qf-CLnLg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Fri, 18 Feb 2022 21:01:15 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Fri, 18 Feb 2022 21:01:15 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Tom Lendacky' <thomas.lendacky@amd.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     David Miller <davem@davemloft.net>,
        Shyam-sundar S-k <Shyam-sundar.S-k@amd.com>,
        Anthony Pighin <anthony.pighin@nokia.com>,
        "Rasmus Villemoes" <linux@rasmusvillemoes.dk>
Subject: RE: [PATCH net] net: amd-xgbe: Replace kasprintf() with snprintf()
 for debugfs name
Thread-Topic: [PATCH net] net: amd-xgbe: Replace kasprintf() with snprintf()
 for debugfs name
Thread-Index: AQHYJQLU3flOGAqTeEGTAeXiGfwRf6yZyMfA
Date:   Fri, 18 Feb 2022 21:01:15 +0000
Message-ID: <5cf6cfc8f5bc4808b37e21fcfa7cafc7@AcuMS.aculab.com>
References: <b21d35da33357b20ece39c7892f57084b94c017a.1645214686.git.thomas.lendacky@amd.com>
In-Reply-To: <b21d35da33357b20ece39c7892f57084b94c017a.1645214686.git.thomas.lendacky@amd.com>
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
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Lendacky
> Sent: 18 February 2022 20:05
> 
> It was reported that using kasprintf() produced a kernel warning as the
> network interface name was being changed by udev rules at the same time
> that the debugfs entry for the device was being created.

What was the error?
I'm guessing the length changed and that made kvasprintf() unhappy??

...
> -	buf = kasprintf(GFP_KERNEL, "amd-xgbe-%s", pdata->netdev->name);
> -	if (!buf)
> +	ret = snprintf(buf, sizeof(buf), "%s%s", XGBE_DIR_PREFIX,
> +		       pdata->netdev->name);

You can do:
	snprintf(buf, sizeof buf, XGBE_DIR_PREFIX "%s", pdata->netdev->name)

> +	if (ret >= sizeof(buf))
>  		return;

Unlike kasnprintf() where kmalloc() can fail, the simple snprintf()
can't really overrun unless pdata->netdev->name isn't '\0' terminated.
Even if it being changed while you look at it that shouldn't happen.


Don't you need to synchronise this anyway?

If the debugfs create and rename can happen at the same time then
the rename can be requested before the create and you get the wrong
name.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


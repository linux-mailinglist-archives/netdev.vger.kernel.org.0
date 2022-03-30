Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9FB34EB892
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 04:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242144AbiC3C7H convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 29 Mar 2022 22:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236193AbiC3C7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 22:59:07 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 62E6AB6C
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 19:57:20 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-260-sKBCBKFINtqPnd_8YrB5ZA-1; Wed, 30 Mar 2022 03:57:17 +0100
X-MC-Unique: sKBCBKFINtqPnd_8YrB5ZA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Wed, 30 Mar 2022 03:57:16 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Wed, 30 Mar 2022 03:57:15 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Michael Walle' <michael@walle.cc>, Xu Yilun <yilun.xu@intel.com>,
        Tom Rix <trix@redhat.com>, Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     "linux-hwmon@vger.kernel.org" <linux-hwmon@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 1/5] hwmon: introduce hwmon_sanitize_name()
Thread-Topic: [PATCH v2 1/5] hwmon: introduce hwmon_sanitize_name()
Thread-Index: AQHYQ4dUrIB0cQMH/kajVzJ0H3I8wazXOSsg
Date:   Wed, 30 Mar 2022 02:57:15 +0000
Message-ID: <16d8b45eba7b44e78fa8205e6666f2bd@AcuMS.aculab.com>
References: <20220329160730.3265481-1-michael@walle.cc>
 <20220329160730.3265481-2-michael@walle.cc>
In-Reply-To: <20220329160730.3265481-2-michael@walle.cc>
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

From: Michael Walle
> Sent: 29 March 2022 17:07
> 
> More and more drivers will check for bad characters in the hwmon name
> and all are using the same code snippet. Consolidate that code by adding
> a new hwmon_sanitize_name() function.

I'm assuming these 'bad' hwmon names come from userspace?
Like ethernet interface names??

Is silently changing the name of the hwmon entries the right
thing to do at all?

What happens if the user tries to create both "foo_bar" and "foo-bar"?
I'm sure that is going to go horribly wrong somewhere.

It would certainly make sense to have a function to verify the name
is actually valid.
Then bad names can be rejected earlier on.

I'm also intrigued about the list of invalid characters:

+static bool hwmon_is_bad_char(const char ch)
+{
+	switch (ch) {
+	case '-':
+	case '*':
+	case ' ':
+	case '\t':
+	case '\n':
+		return true;
+	default:
+		return false;
+	}
+}

If '\t' and '\n' are invalid why are all the other control characters
allowed?
I'm guessing '*' is disallowed because it is the shell wildcard?
So what about '?'.
Then I'd expect '/' to be invalid - but that isn't checked.
Never mind all the values 0x80 to 0xff - they are probably worse
than whitespace.

OTOH why are any characters invalid at all - except '/'?

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


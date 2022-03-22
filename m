Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E33F14E4926
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 23:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237943AbiCVW3f convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 22 Mar 2022 18:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiCVW3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 18:29:33 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 34F6936B4B
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 15:28:02 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-62-EXb9IYMXOCiR4--bAPJEbQ-1; Tue, 22 Mar 2022 22:27:59 +0000
X-MC-Unique: EXb9IYMXOCiR4--bAPJEbQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Tue, 22 Mar 2022 22:27:58 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Tue, 22 Mar 2022 22:27:58 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jakub Kicinski' <kuba@kernel.org>
CC:     'Alexander Lobakin' <alexandr.lobakin@intel.com>,
        'Wan Jiabing' <wanjiabing@vivo.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "Tony Nguyen" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] ice: use min_t() to make code cleaner in ice_gnss
Thread-Topic: [PATCH v2] ice: use min_t() to make code cleaner in ice_gnss
Thread-Index: AQHYPSxszwX/VYzTWUmJ1ZXJKTtOx6zJ/3twgAGw2QCAAAVpMIAABOQAgABC8EA=
Date:   Tue, 22 Mar 2022 22:27:58 +0000
Message-ID: <cea4f99c8162405ca4337d20ec0b85d4@AcuMS.aculab.com>
References: <20220321135947.378250-1-wanjiabing@vivo.com>
        <f888e3cf09944f9aa63532c9f59e69fb@AcuMS.aculab.com>
        <20220322175038.2691665-1-alexandr.lobakin@intel.com>
        <af3fa59809654c9b9939f1e0bd8ca76b@AcuMS.aculab.com>
 <20220322112730.482d674d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220322112730.482d674d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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

From: Jakub Kicinski
> Sent: 22 March 2022 18:28
> 
> On Tue, 22 Mar 2022 18:12:08 +0000 David Laight wrote:
> > > > Oh FFS why is that u16?
> > > > Don't do arithmetic on anything smaller than 'int'
> > >
> > > Any reasoning? I don't say it's good or bad, just want to hear your
> > > arguments (disasms, perf and object code measurements) etc.
> >
> > Look at the object code on anything except x86.
> > The compiler has to add instruction to mask the value
> > (which is in a full sized register) down to 16 bits
> > after every arithmetic operation.
> 
> Isn't it also slower on some modern x86 CPUs?
> I could have sworn someone mentioned that in the past.

Not in the cpu clock count tables I've read.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


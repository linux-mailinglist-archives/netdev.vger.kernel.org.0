Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F05467C698
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 10:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236237AbjAZJFC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 26 Jan 2023 04:05:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236675AbjAZJEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 04:04:48 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734A92E0CA
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 01:04:46 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-196-pzF3oIVmP7SJwOTHVf6jTw-1; Thu, 26 Jan 2023 09:04:43 +0000
X-MC-Unique: pzF3oIVmP7SJwOTHVf6jTw-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.45; Thu, 26 Jan
 2023 09:04:42 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.045; Thu, 26 Jan 2023 09:04:42 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Breno Leitao' <leitao@debian.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "leit@fb.com" <leit@fb.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Michael van der Westhuizen" <rmikey@meta.com>
Subject: RE: [PATCH v3] netpoll: Remove 4s sleep during carrier detection
Thread-Topic: [PATCH v3] netpoll: Remove 4s sleep during carrier detection
Thread-Index: AQHZMO474M9dVibggUerw/Y/8Leyua6wZmjA
Date:   Thu, 26 Jan 2023 09:04:42 +0000
Message-ID: <6d13242627e84bde8129e75b6324d905@AcuMS.aculab.com>
References: <20230125185230.3574681-1-leitao@debian.org>
In-Reply-To: <20230125185230.3574681-1-leitao@debian.org>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Breno Leitao
> Sent: 25 January 2023 18:53
> This patch removes the msleep(4s) during netpoll_setup() if the carrier
> appears instantly.
> 
> Here are some scenarios where this workaround is counter-productive in
> modern ages:
> 
> Servers which have BMC communicating over NC-SI via the same NIC as gets
> used for netconsole. BMC will keep the PHY up, hence the carrier
> appearing instantly.
> 
> The link is fibre, SERDES getting sync could happen within 0.1Hz, and
> the carrier also appears instantly.
> 
> Other than that, if a driver is reporting instant carrier and then
> losing it, this is probably a driver bug.

I can't help feeling that this will break something.
The 4 second delay does look counter productive though.
Obvious alternatives are 'wait a bit before the first check'
and 'require carrier to be present for a few checks'.

It also has to be said that checking every ms seems over enthusiastic.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


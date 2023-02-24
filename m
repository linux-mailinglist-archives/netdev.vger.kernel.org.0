Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56ABA6A23FE
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 22:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjBXV64 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 24 Feb 2023 16:58:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjBXV6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 16:58:55 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D983617CD9
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 13:58:52 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-220-6Epjr51tPVCho_ubGcioOg-1; Fri, 24 Feb 2023 21:58:49 +0000
X-MC-Unique: 6Epjr51tPVCho_ubGcioOg-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.47; Fri, 24 Feb
 2023 21:58:48 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.047; Fri, 24 Feb 2023 21:58:48 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jakub Kicinski' <kuba@kernel.org>,
        Saeed Mahameed <saeed@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>
Subject: RE: [net 07/10] net/mlx5e: Correct SKB room check to use all room in
 the fifo
Thread-Topic: [net 07/10] net/mlx5e: Correct SKB room check to use all room in
 the fifo
Thread-Index: AQHZR+hZhb5WHqB4FkmQODJmKZivMq7epLig
Date:   Fri, 24 Feb 2023 21:58:47 +0000
Message-ID: <07806a76504b49dbb2deb71702d5c008@AcuMS.aculab.com>
References: <20230223225247.586552-1-saeed@kernel.org>
        <20230223225247.586552-8-saeed@kernel.org>
 <20230223163836.546bbc76@kernel.org>
In-Reply-To: <20230223163836.546bbc76@kernel.org>
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
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,PDS_BAD_THREAD_QP_64,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski
> Sent: 24 February 2023 00:39
> 
> On Thu, 23 Feb 2023 14:52:44 -0800 Saeed Mahameed wrote:
> > From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
> >
> > Previous check was comparing against the fifo mask. The mask is size of the
> > fifo (power of two) minus one, so a less than or equal comparator should be
> > used for checking if the fifo has room for the SKB.
> >
> > Fixes: 19b43a432e3e ("net/mlx5e: Extend SKB room check to include PTP-SQ")
> 
> How big is the fifo? Not utilizing a single entry is not really worth
> calling a bug if the fifo has at least 32 entries..

There is also the question of how 'fifo full' and 'fifo empty'
are differentiated if they both have the same index values.
I've not looked at the code in question, but not using the
last slot is less likely to be buggy.

I've taken to using array[index++ & mask] and just letting
the index wrap at 2**32 (or even (not) wrap an 2**64).
Then the full and empty conditions are trivially separated.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


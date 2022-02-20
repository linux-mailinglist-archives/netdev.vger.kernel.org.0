Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8B754BD0AE
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 19:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244526AbiBTSjA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 20 Feb 2022 13:39:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244523AbiBTSi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 13:38:59 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B084D31347
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 10:38:37 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-219-6TDIEW8hNVurO84BnXfUDA-1; Sun, 20 Feb 2022 18:38:35 +0000
X-MC-Unique: 6TDIEW8hNVurO84BnXfUDA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Sun, 20 Feb 2022 18:38:32 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Sun, 20 Feb 2022 18:38:32 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Paul Blakey' <paulb@nvidia.com>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>
CC:     Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>
Subject: RE: [PATCH net v4 1/1] openvswitch: Fix setting ipv6 fields causing
 hw csum failure
Thread-Topic: [PATCH net v4 1/1] openvswitch: Fix setting ipv6 fields causing
 hw csum failure
Thread-Index: AQHYJlzZVDgqK+VKxkyxWlnJv8JcTKycwUnA
Date:   Sun, 20 Feb 2022 18:38:32 +0000
Message-ID: <6dad3593d88d4afcae331b1225888884@AcuMS.aculab.com>
References: <20220220132114.18989-1-paulb@nvidia.com>
In-Reply-To: <20220220132114.18989-1-paulb@nvidia.com>
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
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey
> Sent: 20 February 2022 13:21
> 
> Ipv6 ttl, label and tos fields are modified without first
> pulling/pushing the ipv6 header, which would have updated
> the hw csum (if available). This might cause csum validation
> when sending the packet to the stack, as can be seen in
> the trace below.
> 
> Fix this by updating skb->csum if available.
...
> +static inline __wsum
> +csum_block_replace(__wsum csum, __wsum old, __wsum new, int offset)
> +{
> +	return csum_block_add(csum_block_sub(csum, old, offset), new, offset);
> +}

That look computationally OTT for sub 32bit adjustments.

It ought to be enough to do:
	return csum_add(old_csum, 0xf0000fff + new - old);

Although it will need 'tweaking' for odd aligned 24bit values.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


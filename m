Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0B1F4E1D72
	for <lists+netdev@lfdr.de>; Sun, 20 Mar 2022 19:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343535AbiCTSsP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 20 Mar 2022 14:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233851AbiCTSsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 14:48:14 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A8D67180041
        for <netdev@vger.kernel.org>; Sun, 20 Mar 2022 11:46:50 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-211-OvTu6yGEPO-aZeWLosJXtg-1; Sun, 20 Mar 2022 18:46:46 +0000
X-MC-Unique: OvTu6yGEPO-aZeWLosJXtg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Sun, 20 Mar 2022 18:46:46 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Sun, 20 Mar 2022 18:46:46 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'trix@redhat.com'" <trix@redhat.com>,
        "toke@toke.dk" <toke@toke.dk>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] ath9k: initialize arrays at compile time
Thread-Topic: [PATCH] ath9k: initialize arrays at compile time
Thread-Index: AQHYPG4UGesvc0U9PEWregiQnXO486zIm6Kg
Date:   Sun, 20 Mar 2022 18:46:46 +0000
Message-ID: <d06ce4fa239645cc9de48c1062f58f14@AcuMS.aculab.com>
References: <20220320152028.2263518-1-trix@redhat.com>
In-Reply-To: <20220320152028.2263518-1-trix@redhat.com>
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

From: trix@redhat.com <trix@redhat.com>
> Sent: 20 March 2022 15:20
> 
> Early clearing of arrays with
> memset(array, 0, size);
> is equivilent to initializing the array in its decl with
> array[size] = { 0 };
> 
> Since compile time is preferred over runtime,
> convert the memsets to initializations.
...
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
> b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
> index dc24da1ff00b1..39fcc158cb159 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
> @@ -891,10 +891,9 @@ static void ar9003_hw_tx_iq_cal_outlier_detection(struct ath_hw *ah,
>  {
>  	int i, im, nmeasurement;
>  	int magnitude, phase;
> -	u32 tx_corr_coeff[MAX_MEASUREMENT][AR9300_MAX_CHAINS];
> +	u32 tx_corr_coeff[MAX_MEASUREMENT][AR9300_MAX_CHAINS] = { 0 };

For a two dimensional array that needs to be {{0}} (or {}).
And, since there is only one definitions of 'coeff' it can
be static!
(Currently on 96 bytes - si not a real problem on-stack.)

Although I just failed to find the lock that stops
concurrent execution on multiple cpu.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


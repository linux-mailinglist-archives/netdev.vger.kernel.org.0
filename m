Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 682EE69948F
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 13:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjBPMkp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 16 Feb 2023 07:40:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjBPMko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 07:40:44 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D182111
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 04:40:42 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-286-07AOuENLMTqReFLjCT9AWA-1; Thu, 16 Feb 2023 12:40:39 +0000
X-MC-Unique: 07AOuENLMTqReFLjCT9AWA-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.45; Thu, 16 Feb
 2023 12:40:37 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.045; Thu, 16 Feb 2023 12:40:37 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Manish Chopra' <manishc@marvell.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "aelior@marvell.com" <aelior@marvell.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Bhaskar Upadhaya <bupadhaya@marvell.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: RE: [PATCH net] qede: fix interrupt coalescing configuration
Thread-Topic: [PATCH net] qede: fix interrupt coalescing configuration
Thread-Index: AQHZQf2FVioXTA4DjUOZdaf870vTVq7Rg2GQ
Date:   Thu, 16 Feb 2023 12:40:37 +0000
Message-ID: <8b0f8c22f6d24461b25001d907b09179@AcuMS.aculab.com>
References: <20230216115447.17227-1-manishc@marvell.com>
In-Reply-To: <20230216115447.17227-1-manishc@marvell.com>
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

From: Manish Chopra
> Sent: 16 February 2023 11:55
> 
> On default driver load device gets configured with unexpected
> higher interrupt coalescing values instead of default expected
> values as memory allocated from krealloc() is not supposed to
> be zeroed out and may contain garbage values.
> 
> Fix this by allocating the memory of required size first with
> kcalloc() and then use krealloc() to resize and preserve the
> contents across down/up of the interface.

Doesn't any extra memory allocated by krealloc() need to
be zerod ?

	David

> 
> Signed-off-by: Manish Chopra <manishc@marvell.com>
> Fixes: b0ec5489c480 ("qede: preserve per queue stats across up/down of interface")
> Cc: stable@vger.kernel.org
> Cc: Bhaskar Upadhaya <bupadhaya@marvell.com>
> Cc: David S. Miller <davem@davemloft.net>
> Link: https://bugzilla.redhat.com/show_bug.cgi?id=2160054
> Signed-off-by: Alok Prasad <palok@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> ---
>  drivers/net/ethernet/qlogic/qede/qede_main.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c
> b/drivers/net/ethernet/qlogic/qede/qede_main.c
> index 953f304b8588..af39513db1ba 100644
> --- a/drivers/net/ethernet/qlogic/qede/qede_main.c
> +++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
> @@ -970,8 +970,15 @@ static int qede_alloc_fp_array(struct qede_dev *edev)
>  		goto err;
>  	}
> 
> -	mem = krealloc(edev->coal_entry, QEDE_QUEUE_CNT(edev) *
> -		       sizeof(*edev->coal_entry), GFP_KERNEL);
> +	if (!edev->coal_entry) {
> +		mem = kcalloc(QEDE_MAX_RSS_CNT(edev),
> +			      sizeof(*edev->coal_entry), GFP_KERNEL);
> +	} else {
> +		mem = krealloc(edev->coal_entry,
> +			       QEDE_QUEUE_CNT(edev) * sizeof(*edev->coal_entry),
> +			       GFP_KERNEL);
> +	}
> +
>  	if (!mem) {
>  		DP_ERR(edev, "coalesce entry allocation failed\n");
>  		kfree(edev->coal_entry);
> --
> 2.27.0

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A68256380BD
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 22:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiKXVxQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 24 Nov 2022 16:53:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiKXVxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 16:53:16 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE767D29F
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 13:53:14 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-212-n2r8P3EFMP-tlugDzyoltw-1; Thu, 24 Nov 2022 21:53:10 +0000
X-MC-Unique: n2r8P3EFMP-tlugDzyoltw-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Thu, 24 Nov
 2022 21:53:09 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.044; Thu, 24 Nov 2022 21:53:09 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jacob Keller' <jacob.e.keller@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: RE: [PATCH net-next v2 1/9] devlink: use min_t to calculate data_size
Thread-Topic: [PATCH net-next v2 1/9] devlink: use min_t to calculate
 data_size
Thread-Index: AQHY/3u0GPIWenbZ/0+Xu9BNaPVoNq5OnL0Q
Date:   Thu, 24 Nov 2022 21:53:09 +0000
Message-ID: <d561b49935234451ac062f9f12c50e83@AcuMS.aculab.com>
References: <20221123203834.738606-1-jacob.e.keller@intel.com>
 <20221123203834.738606-2-jacob.e.keller@intel.com>
In-Reply-To: <20221123203834.738606-2-jacob.e.keller@intel.com>
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

From: Jacob Keller
> Sent: 23 November 2022 20:38
> 
> The calculation for the data_size in the devlink_nl_read_snapshot_fill
> function uses an if statement that is better expressed using the min_t
> macro.

There ought to be a 'duck shoot' arranged for all uses of min_t().
I was testing a patch (I might submit next week) that relaxes the
checks in min() so that it doesn't error a lot of valid cases.
In particular a positive integer constant can always be cast to (int)
and the compare will DTRT.

I found things like min_t(u32, u32_length, u64_limit) where
you really don't want to mask the limit down.
There are also the min_t(u8, ...) and min_t(u16, ...).


...
> +		data_size = min_t(u32, end_offset - curr_offset,
> +				  DEVLINK_REGION_READ_CHUNK_SIZE);

Here I think both xxx_offset are u32 - so the CHUNK_SIZE
constant probably needs a U suffix.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


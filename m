Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD505AE505
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 12:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiIFKIs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 6 Sep 2022 06:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238746AbiIFKIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 06:08:41 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC4228706
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 03:08:40 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-401-NB3rbti0MM2xd_Niba6zbA-1; Tue, 06 Sep 2022 11:08:37 +0100
X-MC-Unique: NB3rbti0MM2xd_Niba6zbA-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Tue, 6 Sep
 2022 11:08:36 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.040; Tue, 6 Sep 2022 11:08:36 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Optimising csum_fold()
Thread-Topic: Optimising csum_fold()
Thread-Index: AdjB1DI30FR3JKD2Qfa1hVtyBWnMow==
Date:   Tue, 6 Sep 2022 10:08:36 +0000
Message-ID: <c6051e9d96b94c94aff3a41572dfa851@AcuMS.aculab.com>
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
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The default C version is:

static inline __sum16 csum_fold(__wsum csum)
{
        u32 sum = (__force u32)csum;
        sum = (sum & 0xffff) + (sum >> 16);
        sum = (sum & 0xffff) + (sum >> 16);
        return (__force __sum16)~sum;
}

This is has a register dependency of at least 5.
More if register moves cost and the final mask has to be done.

x86 (and other architectures with a carry flag) may use:
static inline __sum16 csum_fold(__wsum sum)
{
        asm("addl %1, %0                ;\n"
            "adcl $0xffff, %0   ;\n"
            : "=r" (sum)
            : "r" ((__force u32)sum << 16),
              "0" ((__force u32)sum & 0xffff0000));
        return (__force __sum16)(~(__force u32)sum >> 16);
}
This isn't actually any better!

arm64 (and a few others) have the C version:
static inline __sum16 csum_fold(__wsum csum)
{
        u32 sum = (__force u32)csum;
        sum += (sum >> 16) | (sum << 16);
        return (__force __sum16)~(sum >> 16);
}
Assuming the shifts get converted to a rotate
this is one instruction shorter.

Finally arc has the slight variant:
static inline __sum16 csum_fold(__wsum s)
{
        unsigned r = s << 16 | s >> 16; /* ror */
        s = ~s;
        s -= r;
        return s >> 16;
}
On a multi-issue cpu the rotate and ~ can happen in the same clock.
If the compiler is any good the final mask is never needed.
So this has a register dependency chain length of 3.

This looks to be better than the existing versions for
almost all architectures.
(There seem to be a few where the shifts aren't converted
to a rotate. I'd be surprised if the cpus don't have a
rotate instruction - so gcc must get confused.)

See https://godbolt.org/z/on1v6naoE

Annoyingly it isn't trivial to convert most of the architectures to
the generic version because they don't include asm-generic/checksum.h

It has to be said that this function seems to generate 0x0000
instead of 0xffff.
That definitely matters for IPv6.
One solution is to add one to the initial constant checksum
(usually 0) and then add one to the result of csum_fold().

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


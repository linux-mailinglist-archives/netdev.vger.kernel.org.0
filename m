Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5AC967AF9D
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 11:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235523AbjAYKYW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 25 Jan 2023 05:24:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233965AbjAYKYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 05:24:21 -0500
Received: from mail.holtmann.org (coyote.holtmann.net [212.227.132.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0ADE52A9AD
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 02:24:19 -0800 (PST)
Received: from smtpclient.apple (p4ff9f072.dip0.t-ipconnect.de [79.249.240.114])
        by mail.holtmann.org (Postfix) with ESMTPSA id 2BF2CCECDD;
        Wed, 25 Jan 2023 11:24:19 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.2\))
Subject: Re: Setting TLS_RX and TLS_TX crypto info more than once?
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <Y9Bbz60sAwkmrsrt@hog>
Date:   Wed, 25 Jan 2023 11:24:18 +0100
Cc:     Dave Watson <davejwatson@fb.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <77DB4DFF-0950-47D4-A6A1-56F6D7142B19@holtmann.org>
References: <A07B819E-A406-457A-B7DB-8926DCEBADCD@holtmann.org>
 <Y9Bbz60sAwkmrsrt@hog>
To:     Sabrina Dubroca <sd@queasysnail.net>
X-Mailer: Apple Mail (2.3696.120.41.1.2)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sabrina,

>> in commit 196c31b4b5447 you limited setsockopt for TLS_RX and TLS_TX
>> crypto info to just one time.
> 
> Looking at commit 196c31b4b5447, that check was already there, it only
> got moved.

I still think that check is not needed. We should get rid of it for
TLS 1.2 and TLS 1.3.

(and Ilya seems to have left Mellanox/nVidia anyway)

>> +       crypto_info = &ctx->crypto_send;
>> +       /* Currently we don't support set crypto info more than one time */
>> +       if (TLS_CRYPTO_INFO_READY(crypto_info))
>> +               goto out;
>> 
>> This is a bit unfortunate for TLS 1.3 where the majority of the TLS
>> handshake is actually encrypted with handshake traffic secrets and
>> only after a successful handshake, the application traffic secrets
>> are applied.
>> 
>> I am hitting this issue since I am just sending ClientHello and only
>> reading ServerHello and then switching on TLS_RX right away to receive
>> the rest of the handshake via TLS_GET_RECORD_TYPE. This works pretty
>> nicely in my code.
>> 
>> Since this limitation wasn’t there in the first place, can we get it
>> removed again and allow setting the crypto info more than once? At
>> least updating the key material (the cipher obviously has to match).
>> 
>> I think this is also needed when having to do any re-keying since I
>> have seen patches for that, but it seems they never got applied.
> 
> The patches are still under discussion (I only posted them a week ago
> so "never got applied" seems a bit harsh):
> https://lore.kernel.org/all/cover.1673952268.git.sd@queasysnail.net/T/#u

My bad, I kinda remembered they are from end of 2020. Anyway, following
that thread, I see you fixed my problem already.

The encrypted handshake portion is actually simple since it defines
really clear boundaries for the handshake traffic secret. The deployed
servers are a bit optimistic since they send you an unencrypted
ServerHello followed right away by the rest of the handshake messages
fully encrypted. I was surprised I can MSG_PEEK at the TLS record
header and then just read n bytes of just the ServerHello leaving
everything else in the receive buffer to be automatically decrypted
once I set the keys. This allows for just having the TLS handshake
implemented in userspace.

It is a little bit unfortunate that with the support for TLS 1.3, the
old tls12_ structures for providing the crypto info have been used. I
would have argued for providing the traffic_secret into the kernel and
then the kernel could have easily derived key+iv by itself. And with
that it could have done the KeyUpdate itself as well.

The other problem is actually that userspace needs to know when we are
close to the limits of AES-GCM encryptions or when the sequence number
is about to wrap. We need to feed back the status of the rec_seq back
to userspace (and with that also from the HW offload).

I would argue that it might have made sense not just specifying the
starting req_seq, but also either an ending or some trigger when
to tell userspace that it is a good time to re-key.

Regards

Marcel


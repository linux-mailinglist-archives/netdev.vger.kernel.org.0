Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 261C66719E7
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 12:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbjARLDe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 18 Jan 2023 06:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbjARLAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 06:00:46 -0500
Received: from us-smtp-delivery-44.mimecast.com (unknown [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87959689F1
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 02:08:13 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-339-kS2CfjCFMp24Pkn6TIGQ7w-1; Wed, 18 Jan 2023 05:07:55 -0500
X-MC-Unique: kS2CfjCFMp24Pkn6TIGQ7w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B263F87B2A0;
        Wed, 18 Jan 2023 10:07:54 +0000 (UTC)
Received: from hog (unknown [10.39.192.162])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E9C41121315;
        Wed, 18 Jan 2023 10:07:53 +0000 (UTC)
Date:   Wed, 18 Jan 2023 11:06:25 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Frantisek Krenzelok <fkrenzel@redhat.com>
Subject: Re: [PATCH net-next 0/5] tls: implement key updates for TLS1.3
Message-ID: <Y8fEodSWeJZyp+Sh@hog>
References: <cover.1673952268.git.sd@queasysnail.net>
 <20230117180351.1cf46cb3@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230117180351.1cf46cb3@kernel.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_VALIDITY_RPBL,RDNS_NONE,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2023-01-17, 18:03:51 -0800, Jakub Kicinski wrote:
> Please CC all the maintainers.

Sorry.

> On Tue, 17 Jan 2023 14:45:26 +0100 Sabrina Dubroca wrote:
> > This adds support for receiving KeyUpdate messages (RFC 8446, 4.6.3
> > [1]). A sender transmits a KeyUpdate message and then changes its TX
> > key. The receiver should react by updating its RX key before
> > processing the next message.
> > 
> > This patchset implements key updates by:
> >  1. pausing decryption when a KeyUpdate message is received, to avoid
> >     attempting to use the old key to decrypt a record encrypted with
> >     the new key
> >  2. returning -EKEYEXPIRED to syscalls that cannot receive the
> >     KeyUpdate message, until the rekey has been performed by userspace
> 
> Why? We return to user space after hitting a cmsg, don't we?
> If the user space wants to keep reading with the old key - 🤷️

But they won't be able to read anything. Either we don't pause
decryption, and the socket is just broken when we look at the next
record, or we pause, and there's nothing to read until the rekey is
done. I think that -EKEYEXPIRED is better than breaking the socket
just because a read snuck in between getting the cmsg and setting the
new key.

> >  3. passing the KeyUpdate message to userspace as a control message
> >  4. allowing updates of the crypto_info via the TLS_TX/TLS_RX
> >     setsockopts
> > 
> > This API has been tested with gnutls to make sure that it allows
> > userspace libraries to implement key updates [2]. Thanks to Frantisek
> > Krenzelok <fkrenzel@redhat.com> for providing the implementation in
> > gnutls and testing the kernel patches.
> 
> Please explain why - the kernel TLS is not faster than user space, 
> the point of it is primarily to enable offload. And you don't add
> offload support here.

Well, TLS1.3 support was added 4 years ago, and yet the offload still
doesn't support 1.3 at all.

IIRC support for KeyUpdates is mandatory in TLS1.3, so currently the
kernel can't claim to support 1.3, independent of offloading.

Some folks did tests with and without kTLS using nbdcopy and found a
small but noticeable performance improvement (around 8-10%).

> > Note: in a future series, I'll clean up tls_set_sw_offload and
> > eliminate the per-cipher copy-paste using tls_cipher_size_desc.
> 
> Yeah, I think it's on Vadim's TODO list as well.

I've already done most of the work as I was working on this, I'll
submit it later.

-- 
Sabrina


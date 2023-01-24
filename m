Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC4D679E16
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 16:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234472AbjAXP6G convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 24 Jan 2023 10:58:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234330AbjAXP6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 10:58:04 -0500
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A16BE448A
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 07:58:00 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-502-a8fTusk4Pvm1gLpPlMB6Tg-1; Tue, 24 Jan 2023 10:57:58 -0500
X-MC-Unique: a8fTusk4Pvm1gLpPlMB6Tg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8ED1E38149A3;
        Tue, 24 Jan 2023 15:57:57 +0000 (UTC)
Received: from hog (unknown [10.39.192.162])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CD820492C14;
        Tue, 24 Jan 2023 15:57:55 +0000 (UTC)
Date:   Tue, 24 Jan 2023 16:56:23 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Boris Pismenny <borisp@nvidia.com>, Simo Sorce <simo@redhat.com>,
        Daiki Ueno <dueno@redhat.com>
Cc:     Gal Pressman <gal@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Frantisek Krenzelok <fkrenzel@redhat.com>
Subject: Re: [PATCH net-next 0/5] tls: implement key updates for TLS1.3
Message-ID: <Y8//pypyM3HAu+cf@hog>
References: <cover.1673952268.git.sd@queasysnail.net>
 <20230117180351.1cf46cb3@kernel.org>
 <Y8fEodSWeJZyp+Sh@hog>
 <20230118185522.44c75f73@kernel.org>
 <516756d7-0a99-da18-2818-9bef6c3b6c24@nvidia.com>
 <bb406004-f344-4783-b1f0-883d254f2146@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <bb406004-f344-4783-b1f0-883d254f2146@nvidia.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(adding Simo and Daiki for the OpenSSL/GnuTLS sides)

2023-01-23, 10:13:58 +0000, Boris Pismenny wrote:
> On 19/01/2023 10:27, Gal Pressman wrote:
> > On 19/01/2023 4:55, Jakub Kicinski wrote:
> >> On Wed, 18 Jan 2023 11:06:25 +0100 Sabrina Dubroca wrote:
> >>> 2023-01-17, 18:03:51 -0800, Jakub Kicinski wrote:
> >>>> On Tue, 17 Jan 2023 14:45:26 +0100 Sabrina Dubroca wrote:  
> >>>>> This adds support for receiving KeyUpdate messages (RFC 8446, 4.6.3
> >>>>> [1]). A sender transmits a KeyUpdate message and then changes its TX
> >>>>> key. The receiver should react by updating its RX key before
> >>>>> processing the next message.
> >>>>>
> >>>>> This patchset implements key updates by:
> >>>>>  1. pausing decryption when a KeyUpdate message is received, to avoid
> >>>>>     attempting to use the old key to decrypt a record encrypted with
> >>>>>     the new key
> >>>>>  2. returning -EKEYEXPIRED to syscalls that cannot receive the
> >>>>>     KeyUpdate message, until the rekey has been performed by userspace  
> >>>>
> >>>> Why? We return to user space after hitting a cmsg, don't we?
> >>>> If the user space wants to keep reading with the old key - 🤷️  
> >>>
> >>> But they won't be able to read anything. Either we don't pause
> >>> decryption, and the socket is just broken when we look at the next
> >>> record, or we pause, and there's nothing to read until the rekey is
> >>> done. I think that -EKEYEXPIRED is better than breaking the socket
> >>> just because a read snuck in between getting the cmsg and setting the
> >>> new key.
> >>
> >> IDK, we don't interpret any other content types/cmsgs, and for well
> >> behaved user space there should be no problem (right?).
> >> I'm weakly against, if nobody agrees with me you can keep as is.
> >>
> >>>>>  3. passing the KeyUpdate message to userspace as a control message
> >>>>>  4. allowing updates of the crypto_info via the TLS_TX/TLS_RX
> >>>>>     setsockopts
> >>>>>
> >>>>> This API has been tested with gnutls to make sure that it allows
> >>>>> userspace libraries to implement key updates [2]. Thanks to Frantisek
> >>>>> Krenzelok <fkrenzel@redhat.com> for providing the implementation in
> >>>>> gnutls and testing the kernel patches.  
> >>>>
> >>>> Please explain why - the kernel TLS is not faster than user space, 
> >>>> the point of it is primarily to enable offload. And you don't add
> >>>> offload support here.  
> >>>
> >>> Well, TLS1.3 support was added 4 years ago, and yet the offload still
> >>> doesn't support 1.3 at all.
> >>
> >> I'm pretty sure some devices support it. None of the vendors could 
> >> be bothered to plumb in the kernel support, yet, tho.
> > 
> > Our device supports TLS 1.3, it's in our plans to add driver/kernel support.
> > 
> >> I don't know of anyone supporting rekeying.
> > 
> > Boris, Tariq, do you know?
> 
> Rekeying is not trivial to get right with offload. There are at least
> two problems to solve:
> 1. On transmit, we need to handle both the new and the old key for new
> and old (retransmitted) data, respectively. Our device will be able to
> hold both keys in parallel and to choose the right one at the cost of an
> if statement in the data-path. Alternatively, we can just fallback to
> software for the old key and focus on the new key.

We'll need to keep the old key around until we know all the records
using it have been fully received, right?  And that could be multiple
old keys, in case of a quick series of key updates.

> 2. On Rx, packets with the new key may arrive before the key is
> installed unless we design a mechanism for preemptively setting the next
> key in HW. As a result, we may get a resync on every rekey.
> 
> Have you considered an API to preemptively set the next key in the
> kernel such that there is never a need to stop the datapath? I think
> that the change in SSL libraries is minor and it can really help KTLS.

I don't like the idea of having some unused key stored in the kernel
for long durations too much.

You can't be sure that there will be only one rekey in the next short
interval, so you'll need to be able to handle those resyncs anyway, in
case userspace is too slow providing the 3rd key (for the 2nd
rekey). For example, the RFC mentions:

   If implementations independently send their own KeyUpdates with
   request_update set to "update_requested" and they cross in flight,
   then each side will also send a response, with the result that each
   side increments by two generations.

   https://www.rfc-editor.org/rfc/rfc8446#section-4.6.3

So I think what you're suggesting can only be an optimization,
not a full solution.

I hope I'm not getting too confused by all this.

-- 
Sabrina


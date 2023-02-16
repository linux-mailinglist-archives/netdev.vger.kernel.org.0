Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E416E6999E7
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 17:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjBPQXw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 16 Feb 2023 11:23:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjBPQXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 11:23:50 -0500
Received: from us-smtp-delivery-44.mimecast.com (unknown [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23CE42BF01
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 08:23:41 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-417-x2lOQOJ3PaKoaytBypW2-w-1; Thu, 16 Feb 2023 11:23:24 -0500
X-MC-Unique: x2lOQOJ3PaKoaytBypW2-w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A7FAC100F90F;
        Thu, 16 Feb 2023 16:23:23 +0000 (UTC)
Received: from hog (ovpn-195-113.brq.redhat.com [10.40.195.113])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 95673140EBF6;
        Thu, 16 Feb 2023 16:23:20 +0000 (UTC)
Date:   Thu, 16 Feb 2023 17:23:19 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vadim Fedorenko <vfedorenko@novek.ru>,
        Frantisek Krenzelok <fkrenzel@redhat.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Apoorv Kothari <apoorvko@amazon.com>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Gal Pressman <gal@nvidia.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH net-next v2 0/5] tls: implement key updates for TLS1.3
Message-ID: <Y+5Yd/8tjCQNOF31@hog>
References: <cover.1676052788.git.sd@queasysnail.net>
 <20230214210811.448b5ec4@kernel.org>
 <Y+0Wjrc9shLkH+Gg@hog>
 <20230215111020.0c843384@kernel.org>
 <Y+1pX/vL8t2nU00c@hog>
 <20230215195748.23a6da87@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230215195748.23a6da87@kernel.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
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

2023-02-15, 19:57:48 -0800, Jakub Kicinski wrote:
> On Thu, 16 Feb 2023 00:23:11 +0100 Sabrina Dubroca wrote:
> > > Offloads being available for 1.2 may be stalling adoption of 1.3
> > > (just a guess, I run across this article mentioning 1.2 being used
> > > in Oracle cloud for instance:
> > > https://blogs.oracle.com/cloudsecurity/post/how-oci-helps-you-protect-data-with-default-encryption
> > > could be because MITM requirements, or maybe they have HW which
> > > can only do 1.2? Dunno).
> > > 
> > > But I'm willing to compromise, we just need a solid plan of how to
> > > handle the inevitable. I'm worried that how this will pay out is:
> > >  - you don't care about offload and add rekey  
> > 
> > I think that's a bit unfair. Not having to deal with offload at all
> > would make things easier for me, sure, but I'm open to the discussion,
> > even if I don't have a good understanding of the offloading side.
> > 
> > I'd just like to avoid holding this feature (arguably a bug fix) until
> > the vendors finally decide that they care about 1.3, if possible. If
> > not, so be it.
> > 
> > I wasn't trying to force you to accept this series. Sorry if that's
> > what it sounded like. I really wanted to understand what you were
> > asking for, because your question wasn't clear to me. Now it makes
> > sense.
> > 
> > >  - vendors don't care about rekey and add 1.3
> > >   ... time passes ...
> > >  - both you and the vendors have moved on
> > >  - users run into issues, waste their time debugging and
> > >    eventually report the problem upstream
> > >  - it's on me to fix?
> > > 
> > > :(  
> > 
> > Yeah, I see. If the rekey already exists in SW, I think it'll be a bit
> > harder for them to just not care about it, but maybe I'm being
> > optimistic.
> 
> True, they may try to weasel out / require some pushing and support.
> Depends on which vendor gets to it first, I guess.
> 
> > I'm not sure we can come up with the correct uAPI/rekey design without
> > trying to implement rekey with offload and seeing how that blows up
> > (and possibly in different ways with different devices).
> 
> Yes, best we can do now is have a plan in place... and your promise 
> of future help? :) (incl. being on the lookout for when the patches 
> come because I'll probably forget)

I'll try to help. None of us can guarantee that we'll be around :)

> > Picking up from where the discussion died off in the previous thread:
> > 
> > On transmit, I think the software fallback for retransmits will be
> > needed, whether we can keep two generations of keys on the device or
> > just one. We could have 2 consecutive rekeys, without even worrying
> > about a broken peer spamming key updates for both sides (or the local
> > user's library doing that). If devices can juggle 3 generations of
> > keys, then maybe we don't have to worry too much about software
> > fallback, but we'll need to define an API to set the extra keys ahead
> > of time and then advance to the next one. Will all devices support
> > installing 2 or 3 keys?
> 
> I think we could try to switch to SW crypto on Tx until all data using
> old key is ACK'ed, drivers can look at skb->decrypted to skip touching
> the transitional skbs. Then remove old key, install new one, resume
> offload.

"all data using the old key" needs to be one list of record per old
key, since we can have multiple rekeys.

Could we install the new key in HW a bit earlier? Keep the old key as
SW fallback for rtx, but the driver installs the new key when the
corresponding KeyUpdate record has gone through and tells the stack to
stop doing SW crypto? I'm not sure that'd be a significant improvement
in the standard case, though.

> We may need special care to make sure we don't try to encrypt the same
> packet with both keys. In case a rtx gets stuck somewhere and comes to
> the NIC after it's already acked (happens surprisingly often).

Don't we have that already? If there's a retransmit while we're
setting the TX key in HW, data that was queued on the socket before
(and shouldn't be encrypted at all) would also be encrypted
otherwise. Or is it different with rekey?

> Multiple keys on the device would probably mean the device needs some
> intelligence to know when to use which - not my first choice.

I only mentioned that because Boris talked about it in the previous
thread.  It's also not my first choice because I doubt all devices
will support it the same way.

> > On receive, we also have the problem of more than one rekey arriving,
> > so if we can't feed enough keys to the device in advance, we'll have
> > to decrypt some records in software. The host will have to survive the
> > burst of software decryption while we wait until the device config
> > catches up.
> 
> I think receive is easier. The fallback is quite effective and already
> in place.

I was thinking about a peer sending at line rate just after the rekey,
and we have to handle that in software for a short while. If the peer
is also dropping to a software fallback, I guess there's no issue,
both sides will slow down.

> Here too we may want to enforce some transitional SW-only
> mode to avoid the (highly unlikely?) case that NIC will decrypt
> successfully a packet with the old key, even tho new key should be used.

Not a crypto expert, but I don't think that's a realistic thing to
worry about.

If the NIC uses the old key to decrypt a record that was encrypted
with the new key and fails, we end up seeing the encrypted record and
decrypting it in SW, right? (and then we can pick the correct key in
the SW fallback) We don't just tear down the connection?

> Carrying "key ID" with the skb is probably an overkill.

I think we can retrieve it from the sequence of records. When we see a
KeyUpdate, we advance the "key ID" after we're done with the message.


This makes me wonder again if we should have fake offloads on veth
(still calling the kernel's crypto library to simulate a device doing
the encryption and/or decryption), to make it easy to play with the
software bits, without requiring actual hardware that can offload
TLS/IPsec/MACsec. But maybe it's too complex to be useful and we'd
just waste our time fixing bugs in the fake offload rather than
improving the stack.

> > One option might be to do the key derivation in the kernel following
> > section 7.2 of the RFC [1]. I don't know how happy crypto/security
> > people would be with that. We'd have to introduce new crypto_info
> > structs, and new cipher types (or a flag in the upper bits of the
> > cipher type) to go with them. Then the kernel processes incoming key
> > update messages on its own, and emits its own key update messages when
> > its current key is expiring. On transmit we also need to inject a
> > Finished message before the KeyUpdate [2]. That's bringing a lot of
> > TLS logic in the kernel. At that point we might as well do the whole
> > handshake... but I really hope it doesn't come to that.
> 
> I think it's mostly a device vs host state sharing problem, so TLS ULP
> or user space - not a big difference, both are on the host.

Maybe. But that's one more implementation of TLS (or large parts of
it) that admins and security teams have to worry about. Maintained by
networking people. I really want to avoid going down that route.


I'll try to dig more into what you're proposing and to poke some holes
into it over the next few days.

-- 
Sabrina


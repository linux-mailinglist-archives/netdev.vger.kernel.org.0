Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3847E69ED69
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 04:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbjBVDTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 22:19:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbjBVDTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 22:19:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E57D2118;
        Tue, 21 Feb 2023 19:19:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5805EB811BC;
        Wed, 22 Feb 2023 03:19:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A351C433EF;
        Wed, 22 Feb 2023 03:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677035986;
        bh=IE6CRV7lcpGHmmeA2fh3tovQFRqR6F+N+C9MDYRJpys=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UjC4rrhLyUHC15gxoZmAOFuyqDibowWY2/EN4oLvWVk9foywe15vMS0m2AWXmVeVu
         vsNRXpnri4PLfbeW5V4/k7+nV48YSRJBqaawvZJM0HmShlyuE0Vp/GgcDtC30c4EF1
         mmnwTJrE4+uTXH5+lSxi+EIgLD7nblKZm6319jcmENyD/WFaAbAEEMPJpFaC86XKWx
         w6/BY7Rz888Nz0pQprcyDWAvG3aVLhSy66NDqqswAqGA/ZqnkTwAcgbg+4MBCeA7Sr
         BT65oi3fYaX2Jazx6144c67c1kVA7wKNG3Fad5lb8gtHtefcDXBH6mpXWFvdpzmkou
         q64Jx+g/PQUGQ==
Date:   Tue, 21 Feb 2023 19:19:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sabrina Dubroca <sd@queasysnail.net>
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
Message-ID: <20230221191944.4d162ec7@kernel.org>
In-Reply-To: <Y+5Yd/8tjCQNOF31@hog>
References: <cover.1676052788.git.sd@queasysnail.net>
        <20230214210811.448b5ec4@kernel.org>
        <Y+0Wjrc9shLkH+Gg@hog>
        <20230215111020.0c843384@kernel.org>
        <Y+1pX/vL8t2nU00c@hog>
        <20230215195748.23a6da87@kernel.org>
        <Y+5Yd/8tjCQNOF31@hog>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry for the delay, long weekend + merge window.

On Thu, 16 Feb 2023 17:23:19 +0100 Sabrina Dubroca wrote:
> 2023-02-15, 19:57:48 -0800, Jakub Kicinski wrote:
> > On Thu, 16 Feb 2023 00:23:11 +0100 Sabrina Dubroca wrote:  
> > > I'm not sure we can come up with the correct uAPI/rekey design without
> > > trying to implement rekey with offload and seeing how that blows up
> > > (and possibly in different ways with different devices).  
> > 
> > Yes, best we can do now is have a plan in place... and your promise 
> > of future help? :) (incl. being on the lookout for when the patches 
> > come because I'll probably forget)  
> 
> I'll try to help. None of us can guarantee that we'll be around :)

Right.

> > I think we could try to switch to SW crypto on Tx until all data using
> > old key is ACK'ed, drivers can look at skb->decrypted to skip touching
> > the transitional skbs. Then remove old key, install new one, resume
> > offload.  
> 
> "all data using the old key" needs to be one list of record per old
> key, since we can have multiple rekeys.

No fully parsing this bit.

> Could we install the new key in HW a bit earlier? Keep the old key as
> SW fallback for rtx, but the driver installs the new key when the
> corresponding KeyUpdate record has gone through and tells the stack to
> stop doing SW crypto? I'm not sure that'd be a significant improvement
> in the standard case, though.

Important consideration is making the non-rekey path as fast as
possible (given rekeying is extremely rare). Looking at skb->decrypted
should be very fast but we can possibly fit some other indication of
"are we rekeying" into another already referenced cache line.
We definitely don't want to have to look up the record to know what
state we're in.

The fallback can't use AES-NI (it's in sirq context) so it's slower 
than SW encrypt before queuing to TCP. Hence my first thought is using
SW crypto for new key and let the traffic we already queued with old
key drain leveraging HW crypto. But as I said the impact on performance
when not rekeying is more important, and so is driver simplicity.

> > We may need special care to make sure we don't try to encrypt the same
> > packet with both keys. In case a rtx gets stuck somewhere and comes to
> > the NIC after it's already acked (happens surprisingly often).  
> 
> Don't we have that already? If there's a retransmit while we're
> setting the TX key in HW, data that was queued on the socket before
> (and shouldn't be encrypted at all) would also be encrypted
> otherwise. Or is it different with rekey?

We have a "start marker" record which is supposed to indicate that
anything before it has already been encrypted. The driver is programmed
with the start seq no, when it sees a packet from before this seq no
it checks if a record exists, finds its before the start marker and
sends the data as is.

> > Multiple keys on the device would probably mean the device needs some
> > intelligence to know when to use which - not my first choice.  
> 
> I only mentioned that because Boris talked about it in the previous
> thread.  It's also not my first choice because I doubt all devices
> will support it the same way.
> 
> > > On receive, we also have the problem of more than one rekey arriving,
> > > so if we can't feed enough keys to the device in advance, we'll have
> > > to decrypt some records in software. The host will have to survive the
> > > burst of software decryption while we wait until the device config
> > > catches up.  
> > 
> > I think receive is easier. The fallback is quite effective and already
> > in place.  
> 
> I was thinking about a peer sending at line rate just after the rekey,
> and we have to handle that in software for a short while. If the peer
> is also dropping to a software fallback, I guess there's no issue,
> both sides will slow down.
> 
> > Here too we may want to enforce some transitional SW-only
> > mode to avoid the (highly unlikely?) case that NIC will decrypt
> > successfully a packet with the old key, even tho new key should be used.  
> 
> Not a crypto expert, but I don't think that's a realistic thing to
> worry about.
> 
> If the NIC uses the old key to decrypt a record that was encrypted
> with the new key and fails, we end up seeing the encrypted record and
> decrypting it in SW, right? (and then we can pick the correct key in
> the SW fallback) We don't just tear down the connection?

Right, in the common case it should just work. We're basically up
against the probability of a hash collision on the auth tag (match 
with both old and new key).

> > Carrying "key ID" with the skb is probably an overkill.  
> 
> I think we can retrieve it from the sequence of records. When we see a
> KeyUpdate, we advance the "key ID" after we're done with the message.
> 
> 
> This makes me wonder again if we should have fake offloads on veth
> (still calling the kernel's crypto library to simulate a device doing
> the encryption and/or decryption), to make it easy to play with the
> software bits, without requiring actual hardware that can offload
> TLS/IPsec/MACsec. But maybe it's too complex to be useful and we'd
> just waste our time fixing bugs in the fake offload rather than
> improving the stack.

It should be quite useful. I also usually just hack up veth, but 
I reckon adding support to netdevsim would be a better fit.
We just need a way to tell two netdevsim ports to "connect to each
other".

> > > One option might be to do the key derivation in the kernel following
> > > section 7.2 of the RFC [1]. I don't know how happy crypto/security
> > > people would be with that. We'd have to introduce new crypto_info
> > > structs, and new cipher types (or a flag in the upper bits of the
> > > cipher type) to go with them. Then the kernel processes incoming key
> > > update messages on its own, and emits its own key update messages when
> > > its current key is expiring. On transmit we also need to inject a
> > > Finished message before the KeyUpdate [2]. That's bringing a lot of
> > > TLS logic in the kernel. At that point we might as well do the whole
> > > handshake... but I really hope it doesn't come to that.  
> > 
> > I think it's mostly a device vs host state sharing problem, so TLS ULP
> > or user space - not a big difference, both are on the host.  
> 
> Maybe. But that's one more implementation of TLS (or large parts of
> it) that admins and security teams have to worry about. Maintained by
> networking people. I really want to avoid going down that route.
> 
> 
> I'll try to dig more into what you're proposing and to poke some holes
> into it over the next few days.

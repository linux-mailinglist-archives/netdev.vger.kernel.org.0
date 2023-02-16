Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB060698B48
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 04:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjBPD54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 22:57:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjBPD5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 22:57:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53A3FF04;
        Wed, 15 Feb 2023 19:57:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB0B761E73;
        Thu, 16 Feb 2023 03:57:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF825C433EF;
        Thu, 16 Feb 2023 03:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676519870;
        bh=K3aJO/OPjYpzOExI+dV4Zv4xNCwbT5SJsXIfbje+PI4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EqQxcJYXsKqYaVOLZcN4l26/qm/YKWbWpoRPhPTMjaq0oZIjsHclmowTgJ0zkbki1
         Tw8An7ZDOLwOWQIFhCB7RMbAkwo2iU1tunktTnIzcbmHCXGte02WB0qSFjq5Ss1QF2
         Uzi3XXWNQmWiT8F9n8XONOgWLgoCDKsREK1CpZdz4mqGFcLDm+Rc3zFpwXgr/lDiFT
         hfclzRmdpLk/Yk3gA24t0TeCpNN3iH7OZ6XQOixLgpkrenJrcAXvSVJa18GvbkuajH
         KV7SWq3iT63HghJr+n9iMtSHOy30Y35JngbO6q/GNStWAR9pFnIZHebzqVbEzQAYn4
         qL1PC7pygxf9g==
Date:   Wed, 15 Feb 2023 19:57:48 -0800
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
Message-ID: <20230215195748.23a6da87@kernel.org>
In-Reply-To: <Y+1pX/vL8t2nU00c@hog>
References: <cover.1676052788.git.sd@queasysnail.net>
        <20230214210811.448b5ec4@kernel.org>
        <Y+0Wjrc9shLkH+Gg@hog>
        <20230215111020.0c843384@kernel.org>
        <Y+1pX/vL8t2nU00c@hog>
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

On Thu, 16 Feb 2023 00:23:11 +0100 Sabrina Dubroca wrote:
> > Offloads being available for 1.2 may be stalling adoption of 1.3
> > (just a guess, I run across this article mentioning 1.2 being used
> > in Oracle cloud for instance:
> > https://blogs.oracle.com/cloudsecurity/post/how-oci-helps-you-protect-data-with-default-encryption
> > could be because MITM requirements, or maybe they have HW which
> > can only do 1.2? Dunno).
> > 
> > But I'm willing to compromise, we just need a solid plan of how to
> > handle the inevitable. I'm worried that how this will pay out is:
> >  - you don't care about offload and add rekey  
> 
> I think that's a bit unfair. Not having to deal with offload at all
> would make things easier for me, sure, but I'm open to the discussion,
> even if I don't have a good understanding of the offloading side.
> 
> I'd just like to avoid holding this feature (arguably a bug fix) until
> the vendors finally decide that they care about 1.3, if possible. If
> not, so be it.
> 
> I wasn't trying to force you to accept this series. Sorry if that's
> what it sounded like. I really wanted to understand what you were
> asking for, because your question wasn't clear to me. Now it makes
> sense.
> 
> >  - vendors don't care about rekey and add 1.3
> >   ... time passes ...
> >  - both you and the vendors have moved on
> >  - users run into issues, waste their time debugging and
> >    eventually report the problem upstream
> >  - it's on me to fix?
> > 
> > :(  
> 
> Yeah, I see. If the rekey already exists in SW, I think it'll be a bit
> harder for them to just not care about it, but maybe I'm being
> optimistic.

True, they may try to weasel out / require some pushing and support.
Depends on which vendor gets to it first, I guess.

> I'm not sure we can come up with the correct uAPI/rekey design without
> trying to implement rekey with offload and seeing how that blows up
> (and possibly in different ways with different devices).

Yes, best we can do now is have a plan in place... and your promise 
of future help? :) (incl. being on the lookout for when the patches 
come because I'll probably forget)

> Picking up from where the discussion died off in the previous thread:
> 
> On transmit, I think the software fallback for retransmits will be
> needed, whether we can keep two generations of keys on the device or
> just one. We could have 2 consecutive rekeys, without even worrying
> about a broken peer spamming key updates for both sides (or the local
> user's library doing that). If devices can juggle 3 generations of
> keys, then maybe we don't have to worry too much about software
> fallback, but we'll need to define an API to set the extra keys ahead
> of time and then advance to the next one. Will all devices support
> installing 2 or 3 keys?

I think we could try to switch to SW crypto on Tx until all data using
old key is ACK'ed, drivers can look at skb->decrypted to skip touching
the transitional skbs. Then remove old key, install new one, resume
offload.

We may need special care to make sure we don't try to encrypt the same
packet with both keys. In case a rtx gets stuck somewhere and comes to
the NIC after it's already acked (happens surprisingly often).

Multiple keys on the device would probably mean the device needs some
intelligence to know when to use which - not my first choice.

> On receive, we also have the problem of more than one rekey arriving,
> so if we can't feed enough keys to the device in advance, we'll have
> to decrypt some records in software. The host will have to survive the
> burst of software decryption while we wait until the device config
> catches up.

I think receive is easier. The fallback is quite effective and already
in place. Here too we may want to enforce some transitional SW-only
mode to avoid the (highly unlikely?) case that NIC will decrypt
successfully a packet with the old key, even tho new key should be used.
Carrying "key ID" with the skb is probably an overkill.

> One option might be to do the key derivation in the kernel following
> section 7.2 of the RFC [1]. I don't know how happy crypto/security
> people would be with that. We'd have to introduce new crypto_info
> structs, and new cipher types (or a flag in the upper bits of the
> cipher type) to go with them. Then the kernel processes incoming key
> update messages on its own, and emits its own key update messages when
> its current key is expiring. On transmit we also need to inject a
> Finished message before the KeyUpdate [2]. That's bringing a lot of
> TLS logic in the kernel. At that point we might as well do the whole
> handshake... but I really hope it doesn't come to that.

I think it's mostly a device vs host state sharing problem, so TLS ULP
or user space - not a big difference, both are on the host.

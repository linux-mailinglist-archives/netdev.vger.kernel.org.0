Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B345C6988C1
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 00:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjBOXZQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 15 Feb 2023 18:25:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjBOXZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 18:25:15 -0500
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2107142BE9
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 15:25:14 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-488-_bKElc76P1KgmCX_2MWQIA-1; Wed, 15 Feb 2023 18:25:02 -0500
X-MC-Unique: _bKElc76P1KgmCX_2MWQIA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 679A4101A55E;
        Wed, 15 Feb 2023 23:25:01 +0000 (UTC)
Received: from hog (ovpn-195-113.brq.redhat.com [10.40.195.113])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E83032026D4B;
        Wed, 15 Feb 2023 23:24:58 +0000 (UTC)
Date:   Thu, 16 Feb 2023 00:23:11 +0100
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
Message-ID: <Y+1pX/vL8t2nU00c@hog>
References: <cover.1676052788.git.sd@queasysnail.net>
 <20230214210811.448b5ec4@kernel.org>
 <Y+0Wjrc9shLkH+Gg@hog>
 <20230215111020.0c843384@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230215111020.0c843384@kernel.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2023-02-15, 11:10:20 -0800, Jakub Kicinski wrote:
> On Wed, 15 Feb 2023 18:29:50 +0100 Sabrina Dubroca wrote:
> > > And how will we handle re-keying in offload?  
> > 
> > Sorry for the stupid question... do you mean that I need to solve that
> > problem before this series can progress, or that the cover letter
> > should summarize the state of the discussion?
> 
> I maintain that 1.3 offload is much more important than rekeying.

Sure, it'd be great if we had 1.3 offload (and it should also support
rekeying, because you can't force the peer to not rekey). But I can't
implement offload.

> Offloads being available for 1.2 may be stalling adoption of 1.3
> (just a guess, I run across this article mentioning 1.2 being used
> in Oracle cloud for instance:
> https://blogs.oracle.com/cloudsecurity/post/how-oci-helps-you-protect-data-with-default-encryption
> could be because MITM requirements, or maybe they have HW which
> can only do 1.2? Dunno).
> 
> But I'm willing to compromise, we just need a solid plan of how to
> handle the inevitable. I'm worried that how this will pay out is:
>  - you don't care about offload and add rekey

I think that's a bit unfair. Not having to deal with offload at all
would make things easier for me, sure, but I'm open to the discussion,
even if I don't have a good understanding of the offloading side.

I'd just like to avoid holding this feature (arguably a bug fix) until
the vendors finally decide that they care about 1.3, if possible. If
not, so be it.

I wasn't trying to force you to accept this series. Sorry if that's
what it sounded like. I really wanted to understand what you were
asking for, because your question wasn't clear to me. Now it makes
sense.

>  - vendors don't care about rekey and add 1.3
>   ... time passes ...
>  - both you and the vendors have moved on
>  - users run into issues, waste their time debugging and
>    eventually report the problem upstream
>  - it's on me to fix?
> 
> :(

Yeah, I see. If the rekey already exists in SW, I think it'll be a bit
harder for them to just not care about it, but maybe I'm being
optimistic.

I'm not sure we can come up with the correct uAPI/rekey design without
trying to implement rekey with offload and seeing how that blows up
(and possibly in different ways with different devices).

Picking up from where the discussion died off in the previous thread:

On transmit, I think the software fallback for retransmits will be
needed, whether we can keep two generations of keys on the device or
just one. We could have 2 consecutive rekeys, without even worrying
about a broken peer spamming key updates for both sides (or the local
user's library doing that). If devices can juggle 3 generations of
keys, then maybe we don't have to worry too much about software
fallback, but we'll need to define an API to set the extra keys ahead
of time and then advance to the next one. Will all devices support
installing 2 or 3 keys?

On receive, we also have the problem of more than one rekey arriving,
so if we can't feed enough keys to the device in advance, we'll have
to decrypt some records in software. The host will have to survive the
burst of software decryption while we wait until the device config
catches up.

One option might be to do the key derivation in the kernel following
section 7.2 of the RFC [1]. I don't know how happy crypto/security
people would be with that. We'd have to introduce new crypto_info
structs, and new cipher types (or a flag in the upper bits of the
cipher type) to go with them. Then the kernel processes incoming key
update messages on its own, and emits its own key update messages when
its current key is expiring. On transmit we also need to inject a
Finished message before the KeyUpdate [2]. That's bringing a lot of
TLS logic in the kernel. At that point we might as well do the whole
handshake... but I really hope it doesn't come to that.

It's hard, but I don't think "let's just kill the connection" is a
nice solution. It's definitely easier for the kernel.

[1] https://www.rfc-editor.org/rfc/rfc8446#section-7.2
[2] https://www.rfc-editor.org/rfc/rfc8446#section-4.6.3

-- 
Sabrina


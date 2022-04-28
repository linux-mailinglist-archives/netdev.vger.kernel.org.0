Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2701512CC2
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 09:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245215AbiD1HaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 03:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245185AbiD1H36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 03:29:58 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035ED33E27;
        Thu, 28 Apr 2022 00:26:43 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 634F01F37B;
        Thu, 28 Apr 2022 07:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651130802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8La7nCythI606QEFjhYh0xAtTpWBmAV8ZgAbWFDSAPA=;
        b=TnOjymCYipj5i9iYJ4tqA02l2//PJs/MLyhkcsGXRO8bIJsFAYY6ljO08fm4BlCle8b4qa
        XCvEW9KmxikZ9vLeim2z87ct0thesl+g8oMRz+KUYMihyTtz3kGiO63vVnmFFWnzyAUgGD
        PKnV4KaxyRq93BMxMavoN/NAsQJw05U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651130802;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8La7nCythI606QEFjhYh0xAtTpWBmAV8ZgAbWFDSAPA=;
        b=he8LWbJqoFVYeywHCdfUwWz6vUMo6u4hljkW69oEvLXDd9V8Xm1jTpX7AQnisfdfKXdWsb
        AkdHhSkzi7uGuODQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 330CF13AF8;
        Thu, 28 Apr 2022 07:26:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id vNDPC7JBamK3DgAAMHmgww
        (envelope-from <hare@suse.de>); Thu, 28 Apr 2022 07:26:42 +0000
Message-ID: <23f497ab-08e3-3a25-26d9-56d94ee92cde@suse.de>
Date:   Thu, 28 Apr 2022 09:26:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH RFC 4/5] net/tls: Add support for PF_TLSH (a TLS handshake
 listener)
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Chuck Lever <chuck.lever@oracle.com>, netdev@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ak@tempesta-tech.com, borisp@nvidia.com, simo@redhat.com
References: <165030051838.5073.8699008789153780301.stgit@oracle-102.nfsv4.dev>
 <165030059051.5073.16723746870370826608.stgit@oracle-102.nfsv4.dev>
 <20220425101459.15484d17@kernel.org>
 <66077b73-c1a4-d2ae-c8e4-3e19e9053171@suse.de>
 <1fca2eda-83e4-fe39-13c8-0e5e7553689b@grimberg.me>
 <20220426080247.19bbb64e@kernel.org>
 <40bc060f-f359-081d-9ba7-fae531cf2cd6@suse.de>
 <20220426170334.3781cd0e@kernel.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220426170334.3781cd0e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/27/22 02:03, Jakub Kicinski wrote:
> On Tue, 26 Apr 2022 17:58:39 +0200 Hannes Reinecke wrote:
>>> Plus there are more protocols being actively worked on (QUIC, PSP etc.)
>>> Having per ULP special sauce to invoke a user space helper is not the
>>> paradigm we chose, and the time as inopportune as ever to change that.
>>
>> Which is precisely what we hope to discuss at LSF.
>> (Yes, I know, probably not the best venue to discuss network stuff ...)
> 
> Indeed.
> 
>> Each approach has its drawbacks:
>>
>> - Establishing sockets from userspace will cause issues during
>> reconnection, as then someone (aka the kernel) will have to inform
>> userspace that a new connection will need to be established.
>> (And that has to happen while the root filesystem is potentially
>> inaccessible, so you can't just call arbitrary commands here)
>> (Especially call_usermodehelper() is out of the game)
> 
> Indeed, we may need _some_ form of a notification mechanism and that's
> okay. Can be a (more generic) socket, can be something based on existing
> network storage APIs (IDK what you have there).
> 
Which is one of the issues; we don't have any.
Network storage is accessed from userspace via read()/write(), and for 
control everyone rolls its own thing.
So speaking of a 'network storage API' is quite optimistic.

> My thinking was that establishing the session in user space would be
> easiest. We wouldn't need all the special getsockopt()s which AFAIU
> work around part of the handshake being done in the kernel, and which,
> I hope we can agree, are not beautiful.
> 
Well; that is open to debate.
During open-iscsi development (which followed your model of having a 
control- and dataplane split between userspace and kernel) we found that 
the model is great for keeping the in-kernel code simple.
But we also found that it's not so great once you come down to the 
gritty details; you have to duplicate quite some protocol handling in 
userspace, and you have to worry about session re-establishment.
Up to the point where we start wondering if moving things into userspace 
was a good idea at all...

As for this particular interface: the problem we're facing is that TLS 
has to be started in-band. For some reason NVMexpress decided not to 
follow the traditional method of establishing the socket, start TLS, and 
then start protocol processing, but it rather has specified a hybrid 
model: establishing the socket, doing authentication, _then_ start TLS, 
and only then continue with protocol processing on the TLS socket.

Moving _that_ into userspace would require us to move the most of the 
protocol logic into userspace, too. Which really is something we want to 
avoid, as this would be quite a code duplication.
Not to mention the maintenance burden, as issues would need to be fixed 
in two locations.
(Talk to me about iscsiuio.)

And that's before we even get to things like TLS session tickets, which 
opens yet another can of worms.

>> - Having ULP helpers (as with this design) mitigates that problem
>> somewhat in the sense that you can mlock() that daemon and having it
>> polling on an intermediate socket; that solves the notification problem.
>> But you have to have ULP special sauce here to make it work.
> 
> TBH I don't see how this is much different to option 1 in terms of
> constraints & requirements on the user space agent. We can implement
> option 1 over a socket-like interface, too, and that'll carry
> notifications all the same.
> 
>> - Moving everything in kernel is ... possible. But then you have yet
>> another security-relevant piece of code in the kernel which needs to be
>> audited, CVEd etc. Not to mention the usual policy discussion whether it
>> really belongs into the kernel.
> 
> Yeah, if that gets posted it'd be great if it includes removing me from
> the TLS maintainers 'cause I want to sleep at night ;)
> 
>> So I don't really see any obvious way to go; best we can do is to pick
>> the least ugly :-(
> 
> True, I'm sure we can find some middle ground between 1 and 2.
> Preferably implemented in a way where the mechanism is separated
> from the fact it's carrying TLS handshake requests, so that it can
> carry something else tomorrow.
> 
Which was actually our goal.
The whole thing started off with the problem on _how_ sockets could be 
passed between kernel and userspace and vice versa.
While there is fd passing between processes via AF_UNIX, there is no 
such mechanism between kernel and userspace.

So accept() was an easy way out as the implementation was quite simple.
And it was moved into net/tls as this was the primary use-case.
But it's by no means meant to be exclusive for TLS; we could expand it 
to other things once there is a need.
But we really didn't want to over-engineer things here.

However, if you have another idea, by all means, do tell.
It's just that I don't think creating sockets in userspace is a great 
fit for us.

Cheers,

Hannes

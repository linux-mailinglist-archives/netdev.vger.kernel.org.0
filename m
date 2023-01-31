Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0069C6825AA
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 08:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbjAaHk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 02:40:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbjAaHk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 02:40:27 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE5D83B3DC
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 23:40:24 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 93FA522351;
        Tue, 31 Jan 2023 07:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1675150823; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u2kyF+fsDO9J1KIZEj9k/57WEFh5NTiCvOzqgcs09E4=;
        b=J7OH4K/KnO60okJxZBtvVgHQtQM3ihV9Iff0WkqHZwp/QIOdKdqXtu4FM0kbQ8kfI69vp1
        lPXWkfuGGw2OVJaNEY2HhswUxr9/L2G5esZy2iVa4gdzglaMhKibovvyLqHcnHZNOGL0P4
        Im+wNWZiY4+GsQG1fXblKA0Qfg/KI0M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1675150823;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u2kyF+fsDO9J1KIZEj9k/57WEFh5NTiCvOzqgcs09E4=;
        b=wiIcRF9Q0x+qWNHvwLd1hFKpmSokSqgT7sMWSsWBvfZDwvlVPlr1DC0Ob1yQCbBFCkbBbx
        ajMnBjgWcE1A4MCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5C362138E8;
        Tue, 31 Jan 2023 07:40:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 3SX2FefF2GN3AgAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 31 Jan 2023 07:40:23 +0000
Message-ID: <10d117b6-a1bf-ee19-7d61-f6ba764aeab6@suse.de>
Date:   Tue, 31 Jan 2023 08:40:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 2/3] net/handshake: Add support for PF_HANDSHAKE
Content-Language: en-US
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        hare@suse.com, dhowells@redhat.com, kolga@netapp.com,
        jmeneghi@redhat.com, bcodding@redhat.com, jlayton@redhat.com
References: <167474840929.5189.15539668431467077918.stgit@91.116.238.104.host.secureserver.net>
 <167474894272.5189.9499312703868893688.stgit@91.116.238.104.host.secureserver.net>
 <20230128003212.7f37b45c@kernel.org>
 <048cba69-aa9a-08d1-789f-fe17c408cfb2@suse.de>
 <60962833-2EA3-449C-8F58-887C833DFC5C@holtmann.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <60962833-2EA3-449C-8F58-887C833DFC5C@holtmann.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/30/23 14:44, Marcel Holtmann wrote:
> Hi Hannes,
> 
>>>> I've designed a way to pass a connected kernel socket endpoint to
>>>> user space using the traditional listen/accept mechanism. accept(2)
>>>> gives us a well-worn building block that can materialize a connected
>>>> socket endpoint as a file descriptor in a specific user space
>>>> process. Like any open socket descriptor, the accepted FD can then
>>>> be passed to a library such as GnuTLS to perform a TLS handshake.
>>> I can't bring myself to like the new socket family layer.
>>> I'd like a second opinion on that, if anyone within netdev
>>> is willing to share..
>>
>> I am not particularly fond of that, either, but the alternative of using
>> netlink doesn't make it any better
>> You can't pass the fd/socket directly via netlink messages, you can only
>> pass the (open!) fd number with the message.
>> The fd itself _needs_ be be part of the process context of the application
>> by the time the application processes that message.
>> Consequently:
>> - I can't see how an application can _reject_ the message; the fd needs to
>> be present in the fd table even before the message is processed, rendering
>> any decision by the application pointless (and I would _so_ love to be proven
>> wrong on this point)
>> - It's slightly tricky to handle processes which go away prior to handling
>> the message; I _think_ the process cleanup code will close the fd, but I guess
>> it also depends on how and when the fd is stored in the process context.
>>
>> If someone can point me to a solution for these points I would vastly prefer
>> to move to netlink. But with these issues in place I'm not sure if netlink
>> doesn't cause more issues than it solves.
> 
> I think we first need to figure out the security model behind this.
> 
> For kTLS you have the TLS Handshake messages inline with the TCP
> socket and thus credentials are given by the owner of that socket.
> This is simple and makes a lot of sense since whoever opened that
> connection has to decide to give a client certificate or accept
> the server certificate (in case of session resumption also provide
> the PSK).
> 
> I like to have a generic TLS Handshake interface as well since more
> and more protocols will take TLS 1.3 as reference and use its
> handshake protocol. What I would not do is insist on using an fd,
> because that is what OpenSSL and others are just used to. The TLS
> libraries need to go away from the fd as IO model and provide
> appropriate APIs into the TLS Handshake (and also TLS Alert
> protocol) for a “codec style” operation.
> 
That's something we have discussed, too.
We could forward the TLS handshake frames via netlink, thus saving us 
the headache of passing an entire socket to userspace.
However, that would require a major infrastructure work on the 
libraries, and my experience with fixing/updating things in gnutls have 
not been stellar. So I didn't pursue this route.

> Fundamentally nothing speaks against TLS Handshake in the kernel. All
> the core functionality is already present. All KPP, HKDF and even the
> certifiacate handling is present. In a simplified view, you just need
> To give the kernel a keyctl keyring that has the CA certs to verify
> and provide the keyring with either client or server certificate to
> use.
> 
> On a TCP socket for example you could do this:
> 
> 	setsockopt(fd, SOL_TCP, TCP_ULP, “tls+hs", ..);
> 
> 	tls_client.cert_id = key_id_cert;
> 	tls_client.ca_id = key_id_ca;
> 
> 	setsockopt(fd, SOL_TLS, TLS_CLIENT, &tls_client, ..);
> 
> Failures or errors would be reported out via socket errors or SCM.
> And you need some extra options to select cipher ranges or limit to
> TLS 1.3 only etc.
> 
Fundamentally you are correct. But these are security relevant areas, 
and any implementation we do will have to be vetted by some security 
people. _And_ will have to be maintained by someone well-versed in 
security, too, lest we have a security breach in the kernel.
And that person will certainly not be me, so I haven't attempt that route.

> But overall it would make using TCP+TLS really simple. The complicated
> part is providing the key ring. Then again, the CA key ring could be
> inherited from systemd or some basic component setting it up and
> sealing it.
> 
I don't think that's a major concern. The good thing with the keyring is 
that it can be populated externally, ie one can have a daemon to fetch 
the certificate and stuff it in the keyring. request_key() and all that ...

> For other protocols or usages the input would be similar. It should
> be rather straight forward to provide key ring identifiers as mount
> option or via an ioctl.
> 
> This however needs to overcome the fear of putting the TLS Handshake
> into the kernel. I can understand anybody thinking that it is not a
> good idea and with TLS 1.2 and before it is a bit convoluted and
> error prone. However starting with TLS 1.3 things are a lot simpler
> and streamlined. There are few oddities where TLS 1.3 has to look
> like TLS 1.2 on the wire, but that mainly only affects the TLS
> record protocol and kTLS does that today already anyway.
> 
See above. It's not so much 'fear' as rather the logistics of it. 
Getting hold of a TLS library is reasonably easy (Chuck had another 
example ready), but massaging it for inclusion into the kernel is quite 
some effort.
You might even succeed in convincing the powers that be to include it 
into the kernel.
But then you are stuck with having to find a capable maintainer, who is 
willing _and qualified_ to take the work and answer awkward questions.
And take the heat when that code introduced a security breach in the 
linux kernel.
Which excluded essentially everybody who had been working on this 
project; we are capable enough engineers in the network and storage 
space, but deep security issues ... not so much.

> For reference ELL (git.kernel.org/pub/scm/libs/ell/ell.git) has a
> TLS implementation that utilizes AF_ALG and keyctl for all the
> basic crypto needs. Certificates and certificate operations are
> purely done via keyctl and that works nicely. If KPP would finally
> get an usersapce interface, even shared secret derivation would go
> via kernel crypto.
> 
> The code is currently TLS 1.2 and earlier, but I have code for
> TLS 1.3 and also code for utilizing kTLS. It needs a bit more
> cleanup, but then I am happy to publish it. The modified code
> for TLS 1.3 support has TLS Handshake+Alert separated from TLS
> Record protocol and doesn’t even rely on an fd to operate. This
> comes from the requirement that TLS for WiFi Enterprise (or in
> the future QUIC) doesn’t have a fd either.
> 
If you have code to update it to 1.3 I would be very willing to look at 
it; the main reason why with went with gnutls was that no-one of us was 
eager (not hat the knowledge) to really delve into TLS and do fancy things.

And that was the other thing; we found quite some TLS implementations, 
but nearly all of the said '1.3 support to come' ...

> Long story short, who is suppose to run the TLS Handshake if
> we push it to userspace. There will be never a generic daemon
> that handles all handshakes since they are all application
> specific. No daemon can run the TLS Handshake on behalf of
> Chrome browser for example. This leads me to AF_HANDSHAKE
> is not a good idea.
> 
> One nice thing we found with using keyctl for WiFi Enterprise
> is that we can have certificates that are backed by the TPM.
> Doing that via keyctl was a lot simpler than dealing with the
> different oddities of SSL engines or different variations of
> crypto libraries. The unification by the kernel is really
> nice. I have to re-read how much EFI can provide securely
> hardware backed keys, but for everybody working in early
> userspace or initramfs it is nice to be able to utilize
> this without having to drag in megabytes of TLS library.
> 
We don't deny that having TLS handshake in the kernel would be a good 
thing. It's just the hurdles to _get_ there are quite high, and we 
thought that the userspace daemon would be an easier route.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman


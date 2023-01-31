Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43503682FA2
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 15:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232019AbjAaOr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 09:47:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbjAaOrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 09:47:24 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CCE4474EF
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 06:47:22 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B8A5C2082A;
        Tue, 31 Jan 2023 14:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1675176440; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gzOgU24TkSp+FJ0RZYJ5k6ENeRHc0t+rJQnLcoUk2g0=;
        b=NF7D1uYsjKCKR2sodRlRM+wIqeVPB2i8/GybeJY0OmTX+taZjHsV4KxLQzDoGa8ebXlctV
        6JH5fSdeAKKfuo4TIlz9REGRJ2Ym7xaUZuE4rn0uUC3Qa3tDyig3HUw9RvtAGmPeHv4X+j
        QclXkJPGAhOxA+zAKbiqrkZAJanBcrM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1675176440;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gzOgU24TkSp+FJ0RZYJ5k6ENeRHc0t+rJQnLcoUk2g0=;
        b=TJmXo/2gHQAJsYyXn9lrKNn+1YxU1TtVnx2XitfY41dJaxqKBLXD9GXLBRQZfSqQLxA+DH
        5nkGh6bZa7IHr+Ag==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A20EA13585;
        Tue, 31 Jan 2023 14:47:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id vrgxJ/gp2WMTTgAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 31 Jan 2023 14:47:20 +0000
Message-ID: <29575fc2-5b1d-bdc0-e4bc-dbf5bd51075f@suse.de>
Date:   Tue, 31 Jan 2023 15:47:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
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
 <10d117b6-a1bf-ee19-7d61-f6ba764aeab6@suse.de>
 <98A14BB2-67BB-4B63-8FC7-E673980EB773@holtmann.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <98A14BB2-67BB-4B63-8FC7-E673980EB773@holtmann.org>
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

On 1/31/23 15:17, Marcel Holtmann wrote:
> Hi Hannes,
> 
[ .. ]
>>> I like to have a generic TLS Handshake interface as well since more
>>> and more protocols will take TLS 1.3 as reference and use its
>>> handshake protocol. What I would not do is insist on using an fd,
>>> because that is what OpenSSL and others are just used to. The TLS
>>> libraries need to go away from the fd as IO model and provide
>>> appropriate APIs into the TLS Handshake (and also TLS Alert
>>> protocol) for a “codec style” operation.
>> That's something we have discussed, too.
>> We could forward the TLS handshake frames via netlink, thus saving
>> us the headache of passing an entire socket to userspace.
>> However, that would require a major infrastructure work on the
>> libraries, and my experience with fixing/updating things in gnutls
>> have not been stellar. So I didn't pursue this route.
> 
> I know, utilizing existing TLS libraries is a pain if you don’t do
> exactly what they had in mind. I started looking at QUIC a while
> back and quickly realized, I have to start looking at TLS 1.3 first.
> 
> My past experience with GnuTLS and OpenSSL have been bad and that is
> why iwd (our WiFi daemon) has its own TLS implementation utilizing
> AF_ALG and keyctl.
> 
I know the feeling :-)

>>> Fundamentally nothing speaks against TLS Handshake in the kernel. All
>>> the core functionality is already present. All KPP, HKDF and even the
>>> certifiacate handling is present. In a simplified view, you just need
>>> To give the kernel a keyctl keyring that has the CA certs to verify
>>> and provide the keyring with either client or server certificate to
>>> use.
>>> On a TCP socket for example you could do this:
>>> 	setsockopt(fd, SOL_TCP, TCP_ULP, “tls+hs", ..);
>>> 	tls_client.cert_id = key_id_cert;
>>> 	tls_client.ca_id = key_id_ca;
>>> 	setsockopt(fd, SOL_TLS, TLS_CLIENT, &tls_client, ..);
>>> Failures or errors would be reported out via socket errors or SCM.
>>> And you need some extra options to select cipher ranges or limit to
>>> TLS 1.3 only etc.
>> Fundamentally you are correct. But these are security relevant areas,
>> and any implementation we do will have to be vetted by some security >> people. _And_ will have to be maintained by someone well-versed in
>> security, too, lest we have a security breach in the kernel.
>> And that person will certainly not be me, so I haven't attempt that route.
> 
> While that might have been true in the past and with TLS 1.2 and earlier,
> I am not sure that is all true today.
> 
> Lets assume we start with TLS 1.3 and don’t have backwards compatibility
> with TLS 1.2 and earlier. And for now we don’t worry about Middleboxes
> compatibility mode since you don’t have to for all the modern protocols
> that utilize just the TLS 1.3 handshake like QUIC.
> 
> Now the key derivation is just choosing 1 out of 5 ciphers and using
> its associated hash algorithm to derive the keys. This is all present
> functionality in the kernel and so well tested that it doesn’t worry
> me at all. We also have a separate RFC with just sample data so you
> can check your derivation functionality. Especially if you check it
> against AEAD encrypted sample data, any mistake is fatal.
> 
> The shared key portion is just ECDHE or DHE and you either end up with
> x25519 or secp256r1 and both are in the kernel. Bluetooth has been
> using secp256r1 inside the kernel for many years now. We all know how
> to handle and verify public keys from secp256r1 and neat part is that
> it would be also offloaded to hardware if needed. So the private key
> doesn’t need to stay even in kernel memory.
> 
ECDHE has now been stabilized, too; I needed that for NVMe 
authentication. So all's good there.

> So dealing with generating your key material for your cipher is really
> simple and similar things have been done for Bluetooth for a long
> time now. And it looks like NVMe is also utilizing KPP as of today.
> 
Yes. Guess who did that.

> The tricky part is the authentication portion of TLS utilizing
> certificates. That part is complicated, but then again, we already
> decided the kernel needs to handle certificates for various places
> and you have to assume that it is fairly secure.
> 
> Now, you need to secure the handshake protocol like any other protocol
> and the only difference is that it will lead to key material and
> does authentication with certificates. All of it, the kernel already
> does in one form or another.
> 
> The TLS 1.3 spec is also really nicely written and explicit in
> error behavior in case of attempts to attack the protocol. While
> implementing my TLS 1.3 only prototype I have been positively
> surprised on how clean it is. I personally think they went over
> board with the key verification, but so be it.
> 
> Once I have cleaned up my TLS 1.3 prototype, I am happy to take
> a stab at a kernel version.
> 
Oh, please. I would so love it to get it done properly; the TLS 
handshake has been a major worry for us.
And even if you would just add TLS1.3 support for ELL that'll be 
fantastic, as then I could give it a stab at the netlink frame handling 
interface (which shouldn't be too hard).

>>> But overall it would make using TCP+TLS really simple. The complicated
>>> part is providing the key ring. Then again, the CA key ring could be
>>> inherited from systemd or some basic component setting it up and
>>> sealing it.
>> I don't think that's a major concern. The good thing with the keyring
>> is that it can be populated externally, ie one can have a daemon to
>> fetch the certificate and stuff it in the keyring. request_key() and all that ...
> 
> It is just painful for the simple reason that there is no real
> standard around CA certificates and where to place them. Every
> distro is kinda doing it their way and you expect your TLS
> library to do the magic.
> 
> I like to see systemd create a keyring of the CA certs, seal it
> and then provide it do every process/service it launches. And
> for non systemd distros they need to find a way to actually
> provide that one keyring that can be used as master for all the
> CA certs.
> 
> We have not bothered with that yet since for WiFi, you always
> have a client cert derived from the CA of the server. So you
> give a CA cert and a client cert when you connect to WiFi
> Enterprise systems.
> 
The good thing is that NVMe is currently PSK-only, so the certificate 
bit is easy for me. Others like NFS will have to do proper X.509 cert 
handling, but I'll let them worry about that :-)

>>> For other protocols or usages the input would be similar. It should
>>> be rather straight forward to provide key ring identifiers as mount
>>> option or via an ioctl.
>>> This however needs to overcome the fear of putting the TLS Handshake
>>> into the kernel. I can understand anybody thinking that it is not a
>>> good idea and with TLS 1.2 and before it is a bit convoluted and
>>> error prone. However starting with TLS 1.3 things are a lot simpler
>>> and streamlined. There are few oddities where TLS 1.3 has to look
>>> like TLS 1.2 on the wire, but that mainly only affects the TLS
>>> record protocol and kTLS does that today already anyway.
>> See above. It's not so much 'fear' as rather the logistics of it.
>> Getting hold of a TLS library is reasonably easy (Chuck had another
>> example ready), but massaging it for inclusion into the kernel is
>> quite some effort.
>> You might even succeed in convincing the powers that be to include
>> it into the kernel.
>> But then you are stuck with having to find a capable maintainer, who
>> is willing _and qualified_ to take the work and answer awkward questions.
>> And take the heat when that code introduced a security breach in the linux kernel.
>> Which excluded essentially everybody who had been working on this project;
>> we are capable enough engineers in the network and storage space, but
>> deep security issues ... not so much.
> 
> Having looked at various TLS libraries during the past few months,
> I would not even recommend taking any of them. This needs to be
> written from scratch. Some of them are just license wise a problem
> others are just too much legacy for TLS 1.3 support.
> 
> I am happy to give this stab and see how badly I would fail ;)
> 
Cool. Count me in; I'll gladly give it a spin for NVMe-TLS where
I've all the surrounding infrastructure like keyrings and certificate 
generation ready. It really just need a TLS handshake protocol handling...

> But as stated above, I am surprised on how good TLS 1.3 spec is
> when it comes to ensuring good and secure implementations. The
> thing can be really easily unit testes to death. I think people
> underestimate the huge effort from the guys at IETF to make
> this simple and more secure.
> 

True. TLS 1.3 _is_ simple, and it might be that quite some issues
around TLS is related to older versions.

[ .. ]

>>> The code is currently TLS 1.2 and earlier, but I have code for
>>> TLS 1.3 and also code for utilizing kTLS. It needs a bit more
>>> cleanup, but then I am happy to publish it. The modified code
>>> for TLS 1.3 support has TLS Handshake+Alert separated from TLS
>>> Record protocol and doesn’t even rely on an fd to operate. This
>>> comes from the requirement that TLS for WiFi Enterprise (or in
>>> the future QUIC) doesn’t have a fd either.
>> If you have code to update it to 1.3 I would be very willing to
>> look at it; the main reason why with went with gnutls was that
>> no-one of us was eager (not hat the knowledge) to really delve
>> into TLS and do fancy things.
>>
>> And that was the other thing; we found quite some TLS implementations,
>> but nearly all of the said '1.3 support to come' ...
> 
> True to that. I think even OpenSSL started an effort to have a
> QUIC specific API now.
> 
> The problem that I found is that TLS Handshake, TLS Alert and
> TLS Record protocol are not cleanly separated. They are mixed
> together.
> 
Yep.

> For example if I want to use kTLS, I mostly just have to deal
> with TLS Handshake portion. QUIC was specific and just uses
> TLS Handshake and TLS Alert are converted to QUIC errors.
> 
Some for us. Alerts don't make sense to us as we have long-lived 
connections, so the prime reason for alerts is gone, and we have to 
re-establish the connection whenever the cipher is changed. So we will 
be converting alerts in errors, too.

>>> Long story short, who is suppose to run the TLS Handshake if
>>> we push it to userspace. There will be never a generic daemon
>>> that handles all handshakes since they are all application
>>> specific. No daemon can run the TLS Handshake on behalf of
>>> Chrome browser for example. This leads me to AF_HANDSHAKE
>>> is not a good idea.
>>> One nice thing we found with using keyctl for WiFi Enterprise
>>> is that we can have certificates that are backed by the TPM.
>>> Doing that via keyctl was a lot simpler than dealing with the
>>> different oddities of SSL engines or different variations of
>>> crypto libraries. The unification by the kernel is really
>>> nice. I have to re-read how much EFI can provide securely
>>> hardware backed keys, but for everybody working in early
>>> userspace or initramfs it is nice to be able to utilize
>>> this without having to drag in megabytes of TLS library.
 >>
>> We don't deny that having TLS handshake in the kernel would
>> be a good thing. It's just the hurdles to _get_ there are
>> quite high, and we thought that the userspace daemon would be an easier route.
> 
> My problem with doing an upcall for TLS Handshake messages
> is to ensure that the right process has the correct rights
> to receive and send the messages. And nobody else can
> interfere with that or intercept messages without proper
> right to do so.
> 
Correct. That is a concern.

> And I am certain that Wireshark would love to get hold of
> the unencrypted TLS Handshake traffic. Debugging TLS
> and also QUIC transfers is hugely painful. The method of
> SSLKEYLOGFILE works but it is so cumbersome and defeats
> any kind of live traffic analysis. So having some DIAG
> here would help a lot of developers.
> 
Oh, yes. That would be nice side-effect.

So, when can I expect the patch?
:-)

Cheers,

Hannes


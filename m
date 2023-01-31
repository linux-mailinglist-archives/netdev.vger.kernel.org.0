Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB0A682F02
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 15:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231708AbjAaOSA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 31 Jan 2023 09:18:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232183AbjAaOR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 09:17:58 -0500
Received: from mail.holtmann.org (coyote.holtmann.net [212.227.132.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A4681CDF3
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 06:17:54 -0800 (PST)
Received: from smtpclient.apple (p5b3d2422.dip0.t-ipconnect.de [91.61.36.34])
        by mail.holtmann.org (Postfix) with ESMTPSA id 18D16CED28;
        Tue, 31 Jan 2023 15:17:53 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.2\))
Subject: Re: [PATCH v2 2/3] net/handshake: Add support for PF_HANDSHAKE
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <10d117b6-a1bf-ee19-7d61-f6ba764aeab6@suse.de>
Date:   Tue, 31 Jan 2023 15:17:52 +0100
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        hare@suse.com, dhowells@redhat.com, kolga@netapp.com,
        jmeneghi@redhat.com, bcodding@redhat.com, jlayton@redhat.com
Content-Transfer-Encoding: 8BIT
Message-Id: <98A14BB2-67BB-4B63-8FC7-E673980EB773@holtmann.org>
References: <167474840929.5189.15539668431467077918.stgit@91.116.238.104.host.secureserver.net>
 <167474894272.5189.9499312703868893688.stgit@91.116.238.104.host.secureserver.net>
 <20230128003212.7f37b45c@kernel.org>
 <048cba69-aa9a-08d1-789f-fe17c408cfb2@suse.de>
 <60962833-2EA3-449C-8F58-887C833DFC5C@holtmann.org>
 <10d117b6-a1bf-ee19-7d61-f6ba764aeab6@suse.de>
To:     Hannes Reinecke <hare@suse.de>
X-Mailer: Apple Mail (2.3696.120.41.1.2)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hannes,

>>>>> I've designed a way to pass a connected kernel socket endpoint to
>>>>> user space using the traditional listen/accept mechanism. accept(2)
>>>>> gives us a well-worn building block that can materialize a connected
>>>>> socket endpoint as a file descriptor in a specific user space
>>>>> process. Like any open socket descriptor, the accepted FD can then
>>>>> be passed to a library such as GnuTLS to perform a TLS handshake.
>>>> I can't bring myself to like the new socket family layer.
>>>> I'd like a second opinion on that, if anyone within netdev
>>>> is willing to share..
>>> 
>>> I am not particularly fond of that, either, but the alternative of using
>>> netlink doesn't make it any better
>>> You can't pass the fd/socket directly via netlink messages, you can only
>>> pass the (open!) fd number with the message.
>>> The fd itself _needs_ be be part of the process context of the application
>>> by the time the application processes that message.
>>> Consequently:
>>> - I can't see how an application can _reject_ the message; the fd needs to
>>> be present in the fd table even before the message is processed, rendering
>>> any decision by the application pointless (and I would _so_ love to be proven
>>> wrong on this point)
>>> - It's slightly tricky to handle processes which go away prior to handling
>>> the message; I _think_ the process cleanup code will close the fd, but I guess
>>> it also depends on how and when the fd is stored in the process context.
>>> 
>>> If someone can point me to a solution for these points I would vastly prefer
>>> to move to netlink. But with these issues in place I'm not sure if netlink
>>> doesn't cause more issues than it solves.
>> I think we first need to figure out the security model behind this.
>> For kTLS you have the TLS Handshake messages inline with the TCP
>> socket and thus credentials are given by the owner of that socket.
>> This is simple and makes a lot of sense since whoever opened that
>> connection has to decide to give a client certificate or accept
>> the server certificate (in case of session resumption also provide
>> the PSK).
>> I like to have a generic TLS Handshake interface as well since more
>> and more protocols will take TLS 1.3 as reference and use its
>> handshake protocol. What I would not do is insist on using an fd,
>> because that is what OpenSSL and others are just used to. The TLS
>> libraries need to go away from the fd as IO model and provide
>> appropriate APIs into the TLS Handshake (and also TLS Alert
>> protocol) for a “codec style” operation.
> That's something we have discussed, too.
> We could forward the TLS handshake frames via netlink, thus saving us the headache of passing an entire socket to userspace.
> However, that would require a major infrastructure work on the libraries, and my experience with fixing/updating things in gnutls have not been stellar. So I didn't pursue this route.

I know, utilizing existing TLS libraries is a pain if you don’t do
exactly what they had in mind. I started looking at QUIC a while
back and quickly realized, I have to start looking at TLS 1.3 first.

My past experience with GnuTLS and OpenSSL have been bad and that is
why iwd (our WiFi daemon) has its own TLS implementation utilizing
AF_ALG and keyctl.

>> Fundamentally nothing speaks against TLS Handshake in the kernel. All
>> the core functionality is already present. All KPP, HKDF and even the
>> certifiacate handling is present. In a simplified view, you just need
>> To give the kernel a keyctl keyring that has the CA certs to verify
>> and provide the keyring with either client or server certificate to
>> use.
>> On a TCP socket for example you could do this:
>> 	setsockopt(fd, SOL_TCP, TCP_ULP, “tls+hs", ..);
>> 	tls_client.cert_id = key_id_cert;
>> 	tls_client.ca_id = key_id_ca;
>> 	setsockopt(fd, SOL_TLS, TLS_CLIENT, &tls_client, ..);
>> Failures or errors would be reported out via socket errors or SCM.
>> And you need some extra options to select cipher ranges or limit to
>> TLS 1.3 only etc.
> Fundamentally you are correct. But these are security relevant areas, and any implementation we do will have to be vetted by some security people. _And_ will have to be maintained by someone well-versed in security, too, lest we have a security breach in the kernel.
> And that person will certainly not be me, so I haven't attempt that route.

While that might have been true in the past and with TLS 1.2 and earlier,
I am not sure that is all true today.

Lets assume we start with TLS 1.3 and don’t have backwards compatibility
with TLS 1.2 and earlier. And for now we don’t worry about Middleboxes
compatibility mode since you don’t have to for all the modern protocols
that utilize just the TLS 1.3 handshake like QUIC.

Now the key derivation is just choosing 1 out of 5 ciphers and using
its associated hash algorithm to derive the keys. This is all present
functionality in the kernel and so well tested that it doesn’t worry
me at all. We also have a separate RFC with just sample data so you
can check your derivation functionality. Especially if you check it
against AEAD encrypted sample data, any mistake is fatal.

The shared key portion is just ECDHE or DHE and you either end up with
x25519 or secp256r1 and both are in the kernel. Bluetooth has been
using secp256r1 inside the kernel for many years now. We all know how
to handle and verify public keys from secp256r1 and neat part is that
it would be also offloaded to hardware if needed. So the private key
doesn’t need to stay even in kernel memory.

So dealing with generating your key material for your cipher is really
simple and similar things have been done for Bluetooth for a long
time now. And it looks like NVMe is also utilizing KPP as of today.

The tricky part is the authentication portion of TLS utilizing
certificates. That part is complicated, but then again, we already
decided the kernel needs to handle certificates for various places
and you have to assume that it is fairly secure.

Now, you need to secure the handshake protocol like any other protocol
and the only difference is that it will lead to key material and
does authentication with certificates. All of it, the kernel already
does in one form or another.

The TLS 1.3 spec is also really nicely written and explicit in
error behavior in case of attempts to attack the protocol. While
implementing my TLS 1.3 only prototype I have been positively
surprised on how clean it is. I personally think they went over
board with the key verification, but so be it.

Once I have cleaned up my TLS 1.3 prototype, I am happy to take
a stab at a kernel version.

>> But overall it would make using TCP+TLS really simple. The complicated
>> part is providing the key ring. Then again, the CA key ring could be
>> inherited from systemd or some basic component setting it up and
>> sealing it.
> I don't think that's a major concern. The good thing with the keyring is that it can be populated externally, ie one can have a daemon to fetch the certificate and stuff it in the keyring. request_key() and all that ...

It is just painful for the simple reason that there is no real
standard around CA certificates and where to place them. Every
distro is kinda doing it their way and you expect your TLS
library to do the magic.

I like to see systemd create a keyring of the CA certs, seal it
and then provide it do every process/service it launches. And
for non systemd distros they need to find a way to actually
provide that one keyring that can be used as master for all the
CA certs.

We have not bothered with that yet since for WiFi, you always
have a client cert derived from the CA of the server. So you
give a CA cert and a client cert when you connect to WiFi
Enterprise systems.

>> For other protocols or usages the input would be similar. It should
>> be rather straight forward to provide key ring identifiers as mount
>> option or via an ioctl.
>> This however needs to overcome the fear of putting the TLS Handshake
>> into the kernel. I can understand anybody thinking that it is not a
>> good idea and with TLS 1.2 and before it is a bit convoluted and
>> error prone. However starting with TLS 1.3 things are a lot simpler
>> and streamlined. There are few oddities where TLS 1.3 has to look
>> like TLS 1.2 on the wire, but that mainly only affects the TLS
>> record protocol and kTLS does that today already anyway.
> See above. It's not so much 'fear' as rather the logistics of it. Getting hold of a TLS library is reasonably easy (Chuck had another example ready), but massaging it for inclusion into the kernel is quite some effort.
> You might even succeed in convincing the powers that be to include it into the kernel.
> But then you are stuck with having to find a capable maintainer, who is willing _and qualified_ to take the work and answer awkward questions.
> And take the heat when that code introduced a security breach in the linux kernel.
> Which excluded essentially everybody who had been working on this project; we are capable enough engineers in the network and storage space, but deep security issues ... not so much.

Having looked at various TLS libraries during the past few months,
I would not even recommend taking any of them. This needs to be
written from scratch. Some of them are just license wise a problem
others are just too much legacy for TLS 1.3 support.

I am happy to give this stab and see how badly I would fail ;)

But as stated above, I am surprised on how good TLS 1.3 spec is
when it comes to ensuring good and secure implementations. The
thing can be really easily unit testes to death. I think people
underestimate the huge effort from the guys at IETF to make
this simple and more secure.

Some of it comes from the fact that Middleboxes have been doing
stupid things over the years, but it resulted in an even more
encrypted and secure Internet along the way.

I am also wondering if there is a use case for offloading the
TLS Handshake to some crypto accelerator. Especially when it
comes to TLS 1.3 and server role, you really don’t have much
of a handshake. You get all required information in the
ClientHello message and if you like the public key, you can
produce almost all key material in one go.

The reality is that even the shared secret is not required
anymore once you derived your handshake secret.

And WiFi FullMac cards have been offloading EAP-TLS for a while
now.

>> For reference ELL (git.kernel.org/pub/scm/libs/ell/ell.git) has a
>> TLS implementation that utilizes AF_ALG and keyctl for all the
>> basic crypto needs. Certificates and certificate operations are
>> purely done via keyctl and that works nicely. If KPP would finally
>> get an usersapce interface, even shared secret derivation would go
>> via kernel crypto.
>> The code is currently TLS 1.2 and earlier, but I have code for
>> TLS 1.3 and also code for utilizing kTLS. It needs a bit more
>> cleanup, but then I am happy to publish it. The modified code
>> for TLS 1.3 support has TLS Handshake+Alert separated from TLS
>> Record protocol and doesn’t even rely on an fd to operate. This
>> comes from the requirement that TLS for WiFi Enterprise (or in
>> the future QUIC) doesn’t have a fd either.
> If you have code to update it to 1.3 I would be very willing to look at it; the main reason why with went with gnutls was that no-one of us was eager (not hat the knowledge) to really delve into TLS and do fancy things.
> 
> And that was the other thing; we found quite some TLS implementations, but nearly all of the said '1.3 support to come' ...

True to that. I think even OpenSSL started an effort to have a
QUIC specific API now.

The problem that I found is that TLS Handshake, TLS Alert and
TLS Record protocol are not cleanly separated. They are mixed
together.

For example if I want to use kTLS, I mostly just have to deal
with TLS Handshake portion. QUIC was specific and just uses
TLS Handshake and TLS Alert are converted to QUIC errors.

>> Long story short, who is suppose to run the TLS Handshake if
>> we push it to userspace. There will be never a generic daemon
>> that handles all handshakes since they are all application
>> specific. No daemon can run the TLS Handshake on behalf of
>> Chrome browser for example. This leads me to AF_HANDSHAKE
>> is not a good idea.
>> One nice thing we found with using keyctl for WiFi Enterprise
>> is that we can have certificates that are backed by the TPM.
>> Doing that via keyctl was a lot simpler than dealing with the
>> different oddities of SSL engines or different variations of
>> crypto libraries. The unification by the kernel is really
>> nice. I have to re-read how much EFI can provide securely
>> hardware backed keys, but for everybody working in early
>> userspace or initramfs it is nice to be able to utilize
>> this without having to drag in megabytes of TLS library.
> We don't deny that having TLS handshake in the kernel would be a good thing. It's just the hurdles to _get_ there are quite high, and we thought that the userspace daemon would be an easier route.

My problem with doing an upcall for TLS Handshake messages
is to ensure that the right process has the correct rights
to receive and send the messages. And nobody else can
interfere with that or intercept messages without proper
right to do so.

And I am certain that Wireshark would love to get hold of
the unencrypted TLS Handshake traffic. Debugging TLS
and also QUIC transfers is hugely painful. The method of
SSLKEYLOGFILE works but it is so cumbersome and defeats
any kind of live traffic analysis. So having some DIAG
here would help a lot of developers.

Regards

Marcel


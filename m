Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE86680F3F
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 14:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236015AbjA3NpE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 30 Jan 2023 08:45:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbjA3NpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 08:45:03 -0500
Received: from mail.holtmann.org (coyote.holtmann.net [212.227.132.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C0DC8367CC
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 05:44:59 -0800 (PST)
Received: from smtpclient.apple (p5b3d2422.dip0.t-ipconnect.de [91.61.36.34])
        by mail.holtmann.org (Postfix) with ESMTPSA id 8285FCED1C;
        Mon, 30 Jan 2023 14:44:58 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.2\))
Subject: Re: [PATCH v2 2/3] net/handshake: Add support for PF_HANDSHAKE
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <048cba69-aa9a-08d1-789f-fe17c408cfb2@suse.de>
Date:   Mon, 30 Jan 2023 14:44:57 +0100
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        hare@suse.com, dhowells@redhat.com, kolga@netapp.com,
        jmeneghi@redhat.com, bcodding@redhat.com, jlayton@redhat.com
Content-Transfer-Encoding: 8BIT
Message-Id: <60962833-2EA3-449C-8F58-887C833DFC5C@holtmann.org>
References: <167474840929.5189.15539668431467077918.stgit@91.116.238.104.host.secureserver.net>
 <167474894272.5189.9499312703868893688.stgit@91.116.238.104.host.secureserver.net>
 <20230128003212.7f37b45c@kernel.org>
 <048cba69-aa9a-08d1-789f-fe17c408cfb2@suse.de>
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

>>> I've designed a way to pass a connected kernel socket endpoint to
>>> user space using the traditional listen/accept mechanism. accept(2)
>>> gives us a well-worn building block that can materialize a connected
>>> socket endpoint as a file descriptor in a specific user space
>>> process. Like any open socket descriptor, the accepted FD can then
>>> be passed to a library such as GnuTLS to perform a TLS handshake.
>> I can't bring myself to like the new socket family layer.
>> I'd like a second opinion on that, if anyone within netdev
>> is willing to share..
> 
> I am not particularly fond of that, either, but the alternative of using netlink doesn't make it any better
> You can't pass the fd/socket directly via netlink messages, you can only pass the (open!) fd number with the message.
> The fd itself _needs_ be be part of the process context of the application by the time the application processes that message.
> Consequently:
> - I can't see how an application can _reject_ the message; the fd needs to be present in the fd table even before the message is processed, rendering any decision by the application pointless (and I would _so_ love to be proven wrong on this point)
> - It's slightly tricky to handle processes which go away prior to handling the message; I _think_ the process cleanup code will close the fd, but I guess it also depends on how and when the fd is stored in the process context.
> 
> If someone can point me to a solution for these points I would vastly prefer to move to netlink. But with these issues in place I'm not sure if netlink doesn't cause more issues than it solves.

I think we first need to figure out the security model behind this.

For kTLS you have the TLS Handshake messages inline with the TCP
socket and thus credentials are given by the owner of that socket.
This is simple and makes a lot of sense since whoever opened that
connection has to decide to give a client certificate or accept
the server certificate (in case of session resumption also provide
the PSK).

I like to have a generic TLS Handshake interface as well since more
and more protocols will take TLS 1.3 as reference and use its
handshake protocol. What I would not do is insist on using an fd,
because that is what OpenSSL and others are just used to. The TLS
libraries need to go away from the fd as IO model and provide
appropriate APIs into the TLS Handshake (and also TLS Alert
protocol) for a “codec style” operation.

Fundamentally nothing speaks against TLS Handshake in the kernel. All
the core functionality is already present. All KPP, HKDF and even the
certifiacate handling is present. In a simplified view, you just need
To give the kernel a keyctl keyring that has the CA certs to verify
and provide the keyring with either client or server certificate to
use.

On a TCP socket for example you could do this:

	setsockopt(fd, SOL_TCP, TCP_ULP, “tls+hs", ..);

	tls_client.cert_id = key_id_cert;
	tls_client.ca_id = key_id_ca;

	setsockopt(fd, SOL_TLS, TLS_CLIENT, &tls_client, ..);

Failures or errors would be reported out via socket errors or SCM.
And you need some extra options to select cipher ranges or limit to
TLS 1.3 only etc.

But overall it would make using TCP+TLS really simple. The complicated
part is providing the key ring. Then again, the CA key ring could be
inherited from systemd or some basic component setting it up and
sealing it.

For other protocols or usages the input would be similar. It should
be rather straight forward to provide key ring identifiers as mount
option or via an ioctl.

This however needs to overcome the fear of putting the TLS Handshake
into the kernel. I can understand anybody thinking that it is not a
good idea and with TLS 1.2 and before it is a bit convoluted and
error prone. However starting with TLS 1.3 things are a lot simpler
and streamlined. There are few oddities where TLS 1.3 has to look
like TLS 1.2 on the wire, but that mainly only affects the TLS
record protocol and kTLS does that today already anyway.

For reference ELL (git.kernel.org/pub/scm/libs/ell/ell.git) has a
TLS implementation that utilizes AF_ALG and keyctl for all the
basic crypto needs. Certificates and certificate operations are
purely done via keyctl and that works nicely. If KPP would finally
get an usersapce interface, even shared secret derivation would go
via kernel crypto.

The code is currently TLS 1.2 and earlier, but I have code for
TLS 1.3 and also code for utilizing kTLS. It needs a bit more
cleanup, but then I am happy to publish it. The modified code
for TLS 1.3 support has TLS Handshake+Alert separated from TLS
Record protocol and doesn’t even rely on an fd to operate. This
comes from the requirement that TLS for WiFi Enterprise (or in
the future QUIC) doesn’t have a fd either.

Long story short, who is suppose to run the TLS Handshake if
we push it to userspace. There will be never a generic daemon
that handles all handshakes since they are all application
specific. No daemon can run the TLS Handshake on behalf of
Chrome browser for example. This leads me to AF_HANDSHAKE
is not a good idea.

One nice thing we found with using keyctl for WiFi Enterprise
is that we can have certificates that are backed by the TPM.
Doing that via keyctl was a lot simpler than dealing with the
different oddities of SSL engines or different variations of
crypto libraries. The unification by the kernel is really
nice. I have to re-read how much EFI can provide securely
hardware backed keys, but for everybody working in early
userspace or initramfs it is nice to be able to utilize
this without having to drag in megabytes of TLS library.

Regards

Marcel


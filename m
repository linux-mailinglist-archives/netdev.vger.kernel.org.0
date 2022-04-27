Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C84B85127D5
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 01:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbiD0X5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 19:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiD0X5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 19:57:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 050E110D;
        Wed, 27 Apr 2022 16:53:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92C8E614A5;
        Wed, 27 Apr 2022 23:53:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65FB2C385AA;
        Wed, 27 Apr 2022 23:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651103635;
        bh=EamM+bDxfmz3jX7DrFUs3xgkTXROOpZ4JGaFwQ/Y3QU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jkk2UtcnFpqH2EH/z/QO9z9LQjKzH/QcWW2kvHc8mAZ6iFYGo2oF2Fb4B098XDJQC
         1aoSrEGmG1FgiKIJ/vQorRIubhuqrGKFBe9MX1ZhuKDiS3O92ZeO29NrgMrzpEhKox
         q7QNF5+FXLQ8L8aUAnnztQcK7ZQ03eDo1YBUEjxYFLXgWEGjoIJa3M9SEyPjT488+7
         papRiV/xuEq7oEAtExC7N33MSGxKUcRGxgwdbRAp3iYNLBXHCFKwAsMNa4T6mMQjWw
         UBz/7/LDIDJYKRvijouRlQP491ut7nCfIVYdfRr4uuTz1cGkSBxLs0rex7ycgK5ydZ
         2Mfef0uyZTj/g==
Date:   Wed, 27 Apr 2022 16:53:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "ak@tempesta-tech.com" <ak@tempesta-tech.com>,
        "borisp@nvidia.com" <borisp@nvidia.com>,
        "simo@redhat.com" <simo@redhat.com>
Subject: Re: [PATCH RFC 4/5] net/tls: Add support for PF_TLSH (a TLS
 handshake listener)
Message-ID: <20220427165354.2eed6c5b@kernel.org>
In-Reply-To: <7B871201-AC3C-46E2-98B0-52B44530E7BD@oracle.com>
References: <165030051838.5073.8699008789153780301.stgit@oracle-102.nfsv4.dev>
        <165030059051.5073.16723746870370826608.stgit@oracle-102.nfsv4.dev>
        <20220425101459.15484d17@kernel.org>
        <E8809EC2-D49A-4171-8C88-D5E24FFA4079@oracle.com>
        <20220426075504.18be4ee2@kernel.org>
        <BA6BB8F6-3A2A-427B-A5D7-30B5F778B7E0@oracle.com>
        <20220426164712.068e365c@kernel.org>
        <7B871201-AC3C-46E2-98B0-52B44530E7BD@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Apr 2022 14:42:53 +0000 Chuck Lever III wrote:
> > On Apr 26, 2022, at 7:47 PM, Jakub Kicinski <kuba@kernel.org> wrote:
> >> RPC-with-TLS requires one RPC as a "starttls" token. That could be
> >> done in user space as part of the handshake, but it is currently
> >> done in the kernel to enable the user agent to be shared with other
> >> kernel consumers of TLS. Keep in mind that we already have two
> >> real consumers: NVMe and RPC-with-TLS; and possibly QUIC.
> >> 
> >> You asserted earlier that creating sockets in user space "scales
> >> better" but did not provide any data. Can we see some? How well
> >> does it need to scale for storage protocols that use long-lived
> >> connections?  
> > 
> > I meant scale with the number of possible crypto protocols, 
> > I mentioned three there.  
> 
> I'm looking at previous emails. The "three crypto protocols"
> don't stand out to me. Which ones?

TLS, QUIC and PSP maybe that was in a different email that what you
quoted, sorry:
https://lore.kernel.org/all/20220426080247.19bbb64e@kernel.org/

PSP:
https://raw.githubusercontent.com/google/psp/main/doc/PSP_Arch_Spec.pdf

> The prototype has a "handshake type" option that enables the kernel
> to request handshakes for different transport layer security
> protocols. Is that the kind of scalability you mean?
> 
> For TLS, we expect to have at least:
> 
>  - ClientHello
>   - X509
>   - PSK
>  - ServerHello
>  - Re-key
> 
> It should be straightforward to add the ability to service
> other handshake types.
> 
> >> I can include unit tests with the prototype. Someone needs to
> >> educate me on what is the preferred unit test paradigm for this
> >> type of subsystem. Examples in the current kernel code base would
> >> help too.  
> > 
> > Whatever level of testing makes you as an engineer comfortable
> > with saying "this test suite is sufficient"? ;)
> > 
> > For TLS we have tools/testing/selftests/net/tls.c - it's hardly
> > an example of excellence but, you know, it catches bugs here and 
> > there.  
> 
> My question wasn't clear, sorry. I meant, what framework is
> appropriate to use for unit tests in this area?

Nothing area specific, tools/testing/selftests/kselftest_harness.h
is what the tls test uses.

> >> When we started discussing TLS handshake requirements with some
> >> community members several years ago, creating the socket in
> >> kernel and passing it up to a user agent was the suggested design.
> >> Has that recommendation changed since then?  
> > 
> > Hm, do you remember who you discussed it with? Would be good 
> > to loop those folks in.  
> 
> Yes, I remember. Trond Myklebust discussed this with Dave Miller
> during a hallway conversation at a conference (probably Plumbers)
> in 2018 or 2019.
> 
> Trond is Cc'd on this thread via linux-nfs@ and Dave is Cc'd via
> netdev@.
> 
> I also traded email with Boris Pismenny about this a year ago,
> and if memory serves he also recommended passing an existing
> socket up to user space. He is Cc'd on this directly.

I see.

> > I wasn't involved at the beginning of the 
> > TLS work, I know second hand that HW offload and nbd were involved 
> > and that the design went thru some serious re-architecting along 
> > the way. In the beginning there was a separate socket for control
> > records, and that was nacked.
> > 
> > But also (and perhaps most importantly) I'm not really objecting 
> > to creating the socket in the kernel. I'm primarily objecting to 
> > a second type of a special TLS socket which has TLS semantics.  
> 
> I don't understand your objection. Can you clarify?
> 
> AF_TLSH is a listen-only socket. It's just a rendezvous point
> for passing a kernel socket up to user space. It doesn't have
> any particular "TLS semantics". It's the user space agent
> listening on that endpoint that implements particular handshake
> behaviors.
> 
> In fact, if the name AF_TLSH gives you hives, that can be made
> more generic.

Yes, a more generic "user space please bake my socket" interface 
is what I'm leaning towards.

> However, that makes it harder for the kernel to
> figure out which listening endpoint handles handshake requests.

Right, the listening endpoint...

Is it possible to instead create a fd-passing-like structured message
which could carry the fd and all the relevant context (what goes 
via the getsockopt() now)? 

The user space agent can open such upcall socket, then bind to
whatever entity it wants to talk to on the kernel side and read
the notifications via recv()?

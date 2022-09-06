Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3823C5AE077
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 09:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238733AbiIFHC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 03:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233100AbiIFHC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 03:02:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B66265642
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 00:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662447775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=caiMWj7kissLoLR8KbqAK5Ap+BIXDNFbPV4Fgn7cTvo=;
        b=Zj0zo5SR3LtzUEHdnemLL2fL/9gEhWJaHUA/Orb4xfbKR1Ri0LIs5fU75jTodDFfNsaKTH
        mvdlTIBv2tZaG94wb3RgCzvAm9NKc1nZPIFpSvLY+EpfQ+UID2K5A1her03TU05D7OESuV
        YjKE29t4O34NuK301z7VzL8FrkNx/hQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-634-Hq43GBnDPUiuMsF1n6uZyQ-1; Tue, 06 Sep 2022 03:02:54 -0400
X-MC-Unique: Hq43GBnDPUiuMsF1n6uZyQ-1
Received: by mail-wm1-f72.google.com with SMTP id v67-20020a1cac46000000b003a615c4893dso5926061wme.3
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 00:02:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=caiMWj7kissLoLR8KbqAK5Ap+BIXDNFbPV4Fgn7cTvo=;
        b=DTqgtV85gOHuNjJwHYVCgjw39ejZtR4/gXyrxOynX9fkyPByAFSR6f8H00TsN+dtYa
         aQMKbhIg9XvpK9Ec6VswDUWKSldM5eNYIOkheZWFVeNcctXcJYsl9KQ+/VtA3BwmhmeW
         x3Lr/RILDYWf8wCojUpMo+aSzaYyf3H5p/tNrxtkGHAKqGqa3RWS9XtFU1yMVAA9e1VU
         DmJVf8K3PK4myO4s2r94KoQ1GYEybzdcZd6JuOkC2ShMvZ9bCvqMfeJeaor8uJp8eXIo
         mIa5OBnVP6nAo90GbRtP8TRIIEG1yNGK5pcdXT89UDOps3o3ssTj/sqfC4jIQ7YTjEUn
         flUw==
X-Gm-Message-State: ACgBeo14aSbKOj0YvNtSccCDU3BR/CUfoqDmQzAffkIe0JTBDHNczpzQ
        1We86dSjQW5ab+Icv8UDgTu0KTaNElhVTuILO/AqIF5GPHb7pLiBNDsVEMb4JhkTfaiA/1dB0Ex
        1kTnfn4DAkPb5y6jr
X-Received: by 2002:a05:6000:2c8:b0:221:7aea:c87f with SMTP id o8-20020a05600002c800b002217aeac87fmr24730975wry.242.1662447773121;
        Tue, 06 Sep 2022 00:02:53 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7ZmSle1dv1s+lU9GYM3ItTuU9f+IG09LYuoLPgYQEDdFv42SwKl7Dvk2wH5naxB49JkETJTA==
X-Received: by 2002:a05:6000:2c8:b0:221:7aea:c87f with SMTP id o8-20020a05600002c800b002217aeac87fmr24730955wry.242.1662447772809;
        Tue, 06 Sep 2022 00:02:52 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-72.dyn.eolo.it. [146.241.112.72])
        by smtp.gmail.com with ESMTPSA id k4-20020a7bc404000000b003a601a1c2f7sm19388512wmi.19.2022.09.06.00.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 00:02:52 -0700 (PDT)
Message-ID: <1bfe80691f6d7c1cf427e5fb979d5dd6f841a4f0.camel@redhat.com>
Subject: Re: [PATCH net] net: mptcp: fix unreleased socket in accept queue
From:   Paolo Abeni <pabeni@redhat.com>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, Menglong Dong <imagedong@tencent.com>
Date:   Tue, 06 Sep 2022 09:02:50 +0200
In-Reply-To: <CADxym3agY5PmVOgCKpxO8mwrCTGnJ6BNvYZUcgu0jwRJEiawHw@mail.gmail.com>
References: <20220905050400.1136241-1-imagedong@tencent.com>
         <da8998cba112cbdea9d403052732c794f3882bd2.camel@redhat.com>
         <CADxym3agY5PmVOgCKpxO8mwrCTGnJ6BNvYZUcgu0jwRJEiawHw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-09-05 at 17:03 +0800, Menglong Dong wrote:
> On Mon, Sep 5, 2022 at 4:26 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > 
> > Hello,
> > 
> > On Mon, 2022-09-05 at 13:04 +0800, menglong8.dong@gmail.com wrote:
> > > From: Menglong Dong <imagedong@tencent.com>
> > > 
> > > The mptcp socket and its subflow sockets in accept queue can't be
> > > released after the process exit.
> > > 
> > > While the release of a mptcp socket in listening state, the
> > > corresponding tcp socket will be released too. Meanwhile, the tcp
> > > socket in the unaccept queue will be released too. However, only init
> > > subflow is in the unaccept queue, and the joined subflow is not in the
> > > unaccept queue, which makes the joined subflow won't be released, and
> > > therefore the corresponding unaccepted mptcp socket will not be released
> > > to.
> > > 
> > > This can be reproduced easily with following steps:
> > > 
> > > 1. create 2 namespace and veth:
> > >    $ ip netns add mptcp-client
> > >    $ ip netns add mptcp-server
> > >    $ sysctl -w net.ipv4.conf.all.rp_filter=0
> > >    $ ip netns exec mptcp-client sysctl -w net.mptcp.enabled=1
> > >    $ ip netns exec mptcp-server sysctl -w net.mptcp.enabled=1
> > >    $ ip link add red-client netns mptcp-client type veth peer red-server \
> > >      netns mptcp-server
> > >    $ ip -n mptcp-server address add 10.0.0.1/24 dev red-server
> > >    $ ip -n mptcp-server address add 192.168.0.1/24 dev red-server
> > >    $ ip -n mptcp-client address add 10.0.0.2/24 dev red-client
> > >    $ ip -n mptcp-client address add 192.168.0.2/24 dev red-client
> > >    $ ip -n mptcp-server link set red-server up
> > >    $ ip -n mptcp-client link set red-client up
> > > 
> > > 2. configure the endpoint and limit for client and server:
> > >    $ ip -n mptcp-server mptcp endpoint flush
> > >    $ ip -n mptcp-server mptcp limits set subflow 2 add_addr_accepted 2
> > >    $ ip -n mptcp-client mptcp endpoint flush
> > >    $ ip -n mptcp-client mptcp limits set subflow 2 add_addr_accepted 2
> > >    $ ip -n mptcp-client mptcp endpoint add 192.168.0.2 dev red-client id \
> > >      1 subflow
> > > 
> > > 3. listen and accept on a port, such as 9999. The nc command we used
> > >    here is modified, which makes it uses mptcp protocol by default.
> > >    And the default backlog is 1:
> > >    ip netns exec mptcp-server nc -l -k -p 9999
> > > 
> > > 4. open another *two* terminal and connect to the server with the
> > >    following command:
> > >    $ ip netns exec mptcp-client nc 10.0.0.1 9999
> > >    input something after connect, to triger the connection of the second
> > >    subflow
> > > 
> > > 5. exit all the nc command, and check the tcp socket in server namespace.
> > >    And you will find that there is one tcp socket in CLOSE_WAIT state
> > >    and can't release forever.
> > 
> > Thank you for the report!
> > 
> > I have a doubt WRT the above scenario: AFAICS 'nc' will accept the
> > incoming sockets ASAP, so the unaccepted queue should be empty at
> > shutdown, but that does not fit with your description?!?
> > 
> 
> By default, as far as in my case, nc won't accept the new connection
> until the first connection closes with the '-k' set. Therefor, the second
> connection will stay in the unaccepted queue.

I missed the fact you opened 2 connections. I guess that is point 4
above. Please rephrase that sentence with something alike:

---
4. open another *two* terminal and use each of them to connect to the
server with the following command:
...
So that there are two established mptcp connections, with the second
one still unaccepted.
---
> 
> > > There are some solutions that I thought:
> > > 
> > > 1. release all unaccepted mptcp socket with mptcp_close() while the
> > >    listening tcp socket release in mptcp_subflow_queue_clean(). This is
> > >    what we do in this commit.
> > > 2. release the mptcp socket with mptcp_close() in subflow_ulp_release().
> > > 3. etc
> > > 
> > 
> > Can you please point to a commit introducing the issue?
> > 
> 
> In fact, I'm not sure. In my case, I found this issue in kernel 5.10.
> And I wanted to find the solution in the upstream, but find that
> upstream has this issue too.
> 
> Hmm...I am curious if this issue exists in the beginning? I
> can't find the opportunity that the joined subflow which are
> unaccepted can be released.

It looks like the problem is there since MPJ support, commit
f296234c98a8fcec94eec80304a873f635d350ea

> 
> > > Signed-off-by: Menglong Dong <imagedong@tencent.com>
> > > ---
> > >  net/mptcp/subflow.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > > 
> > > diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
> > > index c7d49fb6e7bd..e39dff5d5d84 100644
> > > --- a/net/mptcp/subflow.c
> > > +++ b/net/mptcp/subflow.c
> > > @@ -1770,6 +1770,10 @@ void mptcp_subflow_queue_clean(struct sock *listener_ssk)
> > >               msk->first = NULL;
> > >               msk->dl_next = NULL;
> > >               unlock_sock_fast(sk, slow);
> > > +
> > > +             /*  */
> > > +             sock_hold(sk);
> > > +             sk->sk_prot->close(sk);
> > 
> > You can call mptcp_close() directly here.
> > 
> > Perhaps we could as well drop the mptcp_sock_destruct() hack?
> 
> Do you mean to call mptcp_sock_destruct() directly here?

I suspect that with this change setting msk->sk_destruct to
mptcp_sock_destruct in subflow_syn_recv_sock() is not needed anymore,
and the relevant intialization (and callback definition) could be
removed.

> 
Cheers,

Paolo


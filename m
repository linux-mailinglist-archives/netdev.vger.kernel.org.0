Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 330B654D04F
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 19:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355914AbiFORr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 13:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245041AbiFORr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 13:47:28 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 899F6229;
        Wed, 15 Jun 2022 10:47:26 -0700 (PDT)
Received: from [IPv6:2003:f8:3f08:ad00:4f10:e432:a44c:8e65] (p200300f83f08ad004f10e432a44c8e65.dip0.t-ipconnect.de [IPv6:2003:f8:3f08:ad00:4f10:e432:a44c:8e65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: jluebbe@lasnet.de)
        by proxima.lasnet.de (Postfix) with ESMTPSA id C6C94C0747;
        Wed, 15 Jun 2022 19:47:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lasnet.de; s=2021;
        t=1655315241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9bz2STt3kmdDn2VeVPZgDH8qBkZlDCUWWkMWbxg3vV8=;
        b=JXvpMPg5zJiUlnfeUG5vuPjKWS3deA/7wOON1oCwrC4EhjLjeBDdi1/RAN5Z4lj3VdNER9
        p2Z6zB+JpIcMlMug3EuqosgSrBISYDBhUn2objvZiF5OifzA7AjN//b4DQGoBjzakkXEOs
        /8A5itR9sR1UU8GumA5llZC2F2ga2URSMCuNT7ML7qtDuztN1ZSeVoW6s2YBw7osS+WNVe
        aWEAoxLmOBlIgqBzz/HPuuDhDYqcl0t+yCTT5pzT2RQBS0cG8pQ1x1GjnjEMvo2RFtzFwb
        OeD+zD0cF/n7Nri2QsFd7h094QFkDXbTvkX1FG1eTkcL/GBTojkn3xHDgY5Oaw==
Message-ID: <3d0991cf30d6429e8dd059f7e0d1c54a2200c5a0.camel@lasnet.de>
Subject: Re: [REGRESSION] connection timeout with routes to VRF
From:   Jan Luebbe <jluebbe@lasnet.de>
To:     David Ahern <dsahern@kernel.org>,
        Robert Shearman <robertshearman@gmail.com>,
        Andy Roulin <aroulin@nvidia.com>
Cc:     Mike Manning <mvrmanning@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        regressions@lists.linux.dev,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Wed, 15 Jun 2022 19:47:44 +0200
In-Reply-To: <6410890e-333d-5f0e-52f2-1041667c80f8@kernel.org>
References: <a54c149aed38fded2d3b5fdb1a6c89e36a083b74.camel@lasnet.de>
         <6410890e-333d-5f0e-52f2-1041667c80f8@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2022-06-11 at 10:44 -0600, David Ahern wrote:
> On 6/11/22 5:14 AM, Jan Luebbe wrote:
> > Hi,
> > 
> > TL;DR: We think we have found a regression in the handling of VRF route
> > leaking
> > caused by "net: allow binding socket in a VRF when there's an unbound
> > socket"
> > (3c82a21f4320).
> 
> This is the 3rd report in the past few months about this commit.
> 
> ...

Hmm, I've not been able to find other reports. Could you point me to them?

> > 
> > Our minimized test case looks like this:
> >  ip rule add pref 32765 from all lookup local
> >  ip rule del pref 0 from all lookup local
> >  ip link add red type vrf table 1000
> >  ip link set red up
> >  ip route add vrf red unreachable default metric 8192
> >  ip addr add dev red 172.16.0.1/24
> >  ip route add 172.16.0.0/24 dev red
> >  ip vrf exec red socat -dd TCP-LISTEN:1234,reuseaddr,fork SYSTEM:"echo
> > connected" &
> >  sleep 1
> >  nc 172.16.0.1 1234 < /dev/null
> > 
> 
> ...
> Thanks for the detailed analysis and reproducer.
> 
> > 
> > The partial revert
> > diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
> > index 98e1ec1a14f0..41e7f20d7e51 100644
> > --- a/include/net/inet_hashtables.h
> > +++ b/include/net/inet_hashtables.h
> > @@ -310,8 +310,9 @@ static inline struct sock *inet_lookup_listener(struct
> > net *net,
> >  #define INET_MATCH(__sk, __net, __cookie, __saddr, __daddr, __ports, __dif,
> > __sdif) \
> >         (((__sk)->sk_portpair == (__ports))                     &&      \
> >          ((__sk)->sk_addrpair == (__cookie))                    &&      \
> > -        (((__sk)->sk_bound_dev_if == (__dif))                  ||      \
> > -         ((__sk)->sk_bound_dev_if == (__sdif)))                &&      \
> > +        (!(__sk)->sk_bound_dev_if      ||                              \
> > +          ((__sk)->sk_bound_dev_if == (__dif))                 ||      \
> > +          ((__sk)->sk_bound_dev_if == (__sdif)))               &&      \
> >          net_eq(sock_net(__sk), (__net)))
> >  #else /* 32-bit arch */
> >  #define INET_ADDR_COOKIE(__name, __saddr, __daddr) \
> > @@ -321,8 +322,9 @@ static inline struct sock *inet_lookup_listener(struct
> > net *net,
> >         (((__sk)->sk_portpair == (__ports))             &&              \
> >          ((__sk)->sk_daddr      == (__saddr))           &&              \
> >          ((__sk)->sk_rcv_saddr  == (__daddr))           &&              \
> > -        (((__sk)->sk_bound_dev_if == (__dif))          ||              \
> > -         ((__sk)->sk_bound_dev_if == (__sdif)))        &&              \
> > +        (!(__sk)->sk_bound_dev_if      ||                              \
> > +          ((__sk)->sk_bound_dev_if == (__dif))         ||              \
> > +          ((__sk)->sk_bound_dev_if == (__sdif)))       &&              \
> >          net_eq(sock_net(__sk), (__net)))
> >  #endif /* 64-bit arch */
> > 
> > restores the original behavior when applied on v5.18. This doesn't apply
> > directly on master, as the macro was replaced by an inline function in
> > "inet:
> > add READ_ONCE(sk->sk_bound_dev_if) in INET_MATCH()" (4915d50e300e).
> > 
> > I have to admit I don't quite understand 3c82a21f4320, so I'm not sure how
> > to proceed. What would be broken by the partial revert above? Are there
> > better ways to configure routing into the VRF than simply "ip route add
> > 172.16.0.0/24 dev red" that still work?
> > 
> > Thanks,
> > Jan
> > 
> > #regzbot introduced: 3c82a21f4320
> > 
> > 
> > 
> 
> Andy Roulin suggested the same fix to the same problem a few weeks back.
> Let's do it along with a test case in fcnl-test.sh which covers all of
> these vrf permutations.

Thanks! I'd be happy to test any patch in our real setup.

Regards,
Jan



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3FAE54742C
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 13:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbiFKLTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 07:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiFKLTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 07:19:38 -0400
X-Greylist: delayed 312 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 11 Jun 2022 04:19:36 PDT
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C685C0E;
        Sat, 11 Jun 2022 04:19:36 -0700 (PDT)
Received: from [IPv6:2003:f8:3f14:2000:8797:6795:925b:bcbb] (p200300f83f14200087976795925bbcbb.dip0.t-ipconnect.de [IPv6:2003:f8:3f14:2000:8797:6795:925b:bcbb])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: jluebbe@lasnet.de)
        by proxima.lasnet.de (Postfix) with ESMTPSA id D76C4C0106;
        Sat, 11 Jun 2022 13:14:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lasnet.de; s=2021;
        t=1654946063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=tP7Lwh/5getqoLrsB1KpDEqmPHPuv8MuUka2JaZruq8=;
        b=NyAA1orBLANUqz0mfifyxFEoKsvfDsd0GARx3tK/L0h4XSc5JWg0JD2KUnOwRRljBRAANk
        MNGwF7mi2Be1BNzkpzkfcyBrrcYZAQZBaUU7lgRgUOIdGdk26kHxRiR639oxBY29vD9aXV
        FFT4ZNoqFuwBbhMQMS/Ap+aXEsAHxstsnKN2XC/u8Bj+kKZ3WaBuAVfhJm0ACLoT+hHkXm
        vyz1HsVQFaGUVCRFXwK1h0J3b4omX7sJEHNCJrsIB4x7dgn3+cdumj1OonCxVMltPDiUSb
        c8o0F942z1iCDENempgrQE8naLKlSVhoz26p96K4Hu28OwU1Vryt1Mftj0M76w==
Message-ID: <a54c149aed38fded2d3b5fdb1a6c89e36a083b74.camel@lasnet.de>
Subject: [REGRESSION] connection timeout with routes to VRF
From:   Jan Luebbe <jluebbe@lasnet.de>
To:     David Ahern <dsahern@kernel.org>,
        Robert Shearman <robertshearman@gmail.com>
Cc:     Mike Manning <mvrmanning@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        regressions@lists.linux.dev,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sat, 11 Jun 2022 13:14:43 +0200
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

Hi,

TL;DR: We think we have found a regression in the handling of VRF route leaking
caused by "net: allow binding socket in a VRF when there's an unbound socket"
(3c82a21f4320).


We've been using VRF on 4.19 (from Debian buster) for serveral years and want to
update. After updating to 5.10 (from bullseye), we can no longer use routes
pointed at the VRF to reach services in the VRF

We use only one VRF, which contains some wireguard VPN interfaces.
Then we have routes outside the VRF to make the network connected to it
reachable from normal processes.

Our minimized test case looks like this:
 ip rule add pref 32765 from all lookup local
 ip rule del pref 0 from all lookup local
 ip link add red type vrf table 1000
 ip link set red up
 ip route add vrf red unreachable default metric 8192
 ip addr add dev red 172.16.0.1/24
 ip route add 172.16.0.0/24 dev red
 ip vrf exec red socat -dd TCP-LISTEN:1234,reuseaddr,fork SYSTEM:"echo connected" &
 sleep 1
 nc 172.16.0.1 1234 < /dev/null

While in our real setup, we connect to hosts reachable via th VRF's VPN
interfaces, the issue also shows up with a simple listening socket in the VRF.
In that case, the SYN-ACK from the remote host leads to a RST from the VRF, so
it seems that the outbound socket is not found.

A bisection with this leads to "net: allow binding socket in a VRF when there's
an unbound socket" (3c82a21f4320).

Before 3c82a21f4320, this connects fine:
 2022/06/11 11:11:03 socat[326] N listening on AF=2 0.0.0.0:1234
 nc 172.16.0.1 1234
 2022/06/11 11:11:04 socat[326] N accepting connection from AF=2 172.16.0.1:44164 on AF=2 172.16.0.1:1234
 ...
 connected

Since 3c82a21f4320, the connection does not complete:
 2022/06/11 11:16:31 socat[324] N listening on AF=2 0.0.0.0:1234
 + nc 172.16.0.1 1234
 (... times out)

We've retested with v5.19-rc1-262-g0885eacdc81f, and continue to get the
timeout.

The partial revert
diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index 98e1ec1a14f0..41e7f20d7e51 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -310,8 +310,9 @@ static inline struct sock *inet_lookup_listener(struct net *net,
 #define INET_MATCH(__sk, __net, __cookie, __saddr, __daddr, __ports, __dif, __sdif) \
        (((__sk)->sk_portpair == (__ports))                     &&      \
         ((__sk)->sk_addrpair == (__cookie))                    &&      \
-        (((__sk)->sk_bound_dev_if == (__dif))                  ||      \
-         ((__sk)->sk_bound_dev_if == (__sdif)))                &&      \
+        (!(__sk)->sk_bound_dev_if      ||                              \
+          ((__sk)->sk_bound_dev_if == (__dif))                 ||      \
+          ((__sk)->sk_bound_dev_if == (__sdif)))               &&      \
         net_eq(sock_net(__sk), (__net)))
 #else /* 32-bit arch */
 #define INET_ADDR_COOKIE(__name, __saddr, __daddr) \
@@ -321,8 +322,9 @@ static inline struct sock *inet_lookup_listener(struct net *net,
        (((__sk)->sk_portpair == (__ports))             &&              \
         ((__sk)->sk_daddr      == (__saddr))           &&              \
         ((__sk)->sk_rcv_saddr  == (__daddr))           &&              \
-        (((__sk)->sk_bound_dev_if == (__dif))          ||              \
-         ((__sk)->sk_bound_dev_if == (__sdif)))        &&              \
+        (!(__sk)->sk_bound_dev_if      ||                              \
+          ((__sk)->sk_bound_dev_if == (__dif))         ||              \
+          ((__sk)->sk_bound_dev_if == (__sdif)))       &&              \
         net_eq(sock_net(__sk), (__net)))
 #endif /* 64-bit arch */

restores the original behavior when applied on v5.18. This doesn't apply
directly on master, as the macro was replaced by an inline function in "inet:
add READ_ONCE(sk->sk_bound_dev_if) in INET_MATCH()" (4915d50e300e).

I have to admit I don't quite understand 3c82a21f4320, so I'm not sure how to
proceed. What would be broken by the partial revert above? Are there better ways
to configure routing into the VRF than simply "ip route add 172.16.0.0/24 dev
red" that still work?

Thanks,
Jan

#regzbot introduced: 3c82a21f4320




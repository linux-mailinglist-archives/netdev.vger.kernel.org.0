Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B55C569221
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 20:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233846AbiGFSsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 14:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbiGFSsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 14:48:53 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6C41F2DE;
        Wed,  6 Jul 2022 11:48:51 -0700 (PDT)
Received: from [IPv6:2a01:c23:9553:2700:569c:b316:2406:eb4c] (dynamic-2a01-0c23-9553-2700-569c-b316-2406-eb4c.c23.pool.telefonica.de [IPv6:2a01:c23:9553:2700:569c:b316:2406:eb4c])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: jluebbe@lasnet.de)
        by proxima.lasnet.de (Postfix) with ESMTPSA id F3EA5C0373;
        Wed,  6 Jul 2022 20:48:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lasnet.de; s=2021;
        t=1657133329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q1N88M69xDw45XQpZsRsQu5rF1MU+rMW1YQ0tIbUWkM=;
        b=pTxEw9xvEo8NmFgytApBz58B51c7rSRlcJd/LGcOr5Xa0NpxIcqsBL1Mn9oILQipdn0ZF+
        xLTeG04YGQSVrDohQrniIkm0DbTT6+W3IuuxqV3kSWPLB5Gfrz9TzdBhpx5+O/n2YkASvl
        9Ouwb01iWqRXXGxCs3mtZZYVYzdbkQ6vm81QH9hmLD0LdYrCIbqqC0uhQ55gxFqKEhnnw4
        sYAk+uT0TOxdLyaafrxtdJU7z+SZCHja/r5podGM6R8ZHiCiKxN170xL1pk1UKjk8hJK10
        RZsGDgDTzRzPor8Yq9H9x6NNaYJzXtvCEZXR/yWSJCeocgXqFF3vBE+mZerwtg==
Message-ID: <a32428fa0f3811c25912cd313a6fe1fb4f0a4fac.camel@lasnet.de>
Subject: Re: [REGRESSION] connection timeout with routes to VRF
From:   Jan Luebbe <jluebbe@lasnet.de>
To:     Mike Manning <mvrmanning@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Robert Shearman <robertshearman@gmail.com>,
        Andy Roulin <aroulin@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        regressions@lists.linux.dev,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Wed, 06 Jul 2022 20:49:27 +0200
In-Reply-To: <940fa370-08ce-1d39-d5cc-51de8e853b47@gmail.com>
References: <a54c149aed38fded2d3b5fdb1a6c89e36a083b74.camel@lasnet.de>
         <6410890e-333d-5f0e-52f2-1041667c80f8@kernel.org>
         <940fa370-08ce-1d39-d5cc-51de8e853b47@gmail.com>
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

On Sun, 2022-06-26 at 21:06 +0100, Mike Manning wrote:
...
> Andy Roulin suggested the same fix to the same problem a few weeks back.
> Let's do it along with a test case in fcnl-test.sh which covers all of
> these vrf permutations.
> 
Reverting 3c82a21f4320 would remove isolation between the default and other VRFs
needed when no VRF route leaking has been configured between these: there may be
unintended leaking of packets arriving on a device enslaved to an l3mdev due to
the potential match on an unbound socket.

Thanks for the explanation.

VRF route leaking requires routes to be present for both ingress and egress
VRFs,
the testcase shown only has a route from default to red VRF. The implicit return
path from red to default VRF due to match on unbound socket is no longer
present.


If there is a better configuration that makes this work in the general case
without a change to the kernel, we'd be happy as well.

In our full setup, the outbound TCP connection (from the default VRF) gets a
local IP from the interface enslaved to the VRF. Before 3c82a21f4320, this would
simply work.

How would the return path route from the red VRF to the default VRF look in that
case?

Match on unbound socket in all VRFs and not only in the default VRF should be
possible by setting this option (see
https://www.kernel.org/doc/Documentation/networking/vrf.txt):


Do you mean unbound as in listening socket not bound to an IP with bind()? Or as
in a socket in the default VRF?

sysctl net.ipv4.tcp_l3mdev_accept=1


The sysctl docs sound like this should only apply to listening sockets. In this
case, we have an unconnected outbound socket.

However, for this to work a change similar to the following is needed (I have
shown the change to the macro for consistency with above, it is now an inline
fn):


I can also test on master and only used the macro form only because I wasn't
completely sure how to translate it to the inline function form.

---
 include/net/inet_hashtables.h |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -300,9 +300,8 @@
 #define INET_MATCH(__sk, __net, __cookie, __saddr, __daddr, __ports, __dif,
__sdif) \
        (((__sk)->sk_portpair == (__ports))                     &&      \
         ((__sk)->sk_addrpair == (__cookie))                    &&      \
-        (((__sk)->sk_bound_dev_if == (__dif))                  ||      \
-         ((__sk)->sk_bound_dev_if == (__sdif)))                &&      \
-        net_eq(sock_net(__sk), (__net)))
+        net_eq(sock_net(__sk), (__net))                        &&      \
+        inet_sk_bound_dev_eq((__net), (__sk)->sk_bound_dev_if, (__dif),
(__sdif)))
 #else /* 32-bit arch */
 #define INET_ADDR_COOKIE(__name, __saddr, __daddr) \
        const int __name __deprecated __attribute__((unused))
@@ -311,9 +310,8 @@
        (((__sk)->sk_portpair == (__ports))             &&              \
         ((__sk)->sk_daddr      == (__saddr))           &&              \
         ((__sk)->sk_rcv_saddr  == (__daddr))           &&              \
-        (((__sk)->sk_bound_dev_if == (__dif))          ||              \
-         ((__sk)->sk_bound_dev_if == (__sdif)))        &&              \
-        net_eq(sock_net(__sk), (__net)))
+        net_eq(sock_net(__sk), (__net))                &&              \
+        inet_sk_bound_dev_eq((__net), (__sk)->sk_bound_dev_if, (__dif),
(__sdif)))
 #endif /* 64-bit arch */

 /* Sockets in TCP_CLOSE state are _always_ taken out of the hash, so we need

I can confirm that this gets my testcase working with 
net.ipv4.tcp_l3mdev_accept=1.

This is to get the testcase to pass, I will leave it to others to comment on
the testcase validity in terms of testing forwarding using commands on 1 device.

So a network-namespace-based testcase would be preferred? We used the simple
setup because it seemed easier to understand.

The series that 3c82a21f4320 is part of were introduced into the kernel in 2018
by the Vyatta team, who regularly run an extensive test suite for routing
protocols
for VRF functionality incl. all combinations of route leaking between default
and
other VRFs, so there is no known issue in this regard. I will attempt to reach
out
to them so as to advise them of this thread.

Are these testcases public? Perhaps I could use them find a better configuration
that handles our use-case.

Thanks,

Jan


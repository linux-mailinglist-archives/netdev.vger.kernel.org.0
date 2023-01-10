Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F1F66367D
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 01:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjAJA7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 19:59:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjAJA7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 19:59:22 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4E83D1D1
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 16:59:19 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pF2yo-00Fs0S-2q; Tue, 10 Jan 2023 08:59:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 10 Jan 2023 08:59:06 +0800
Date:   Tue, 10 Jan 2023 08:59:06 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Kyle Zeng <zengyhkyle@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH] ipv6: raw: Deduct extension header length in
 rawv6_push_pending_frames
Message-ID: <Y7y4Wsfjm0G7kUBm@gondor.apana.org.au>
References: <Y7iQeGb2xzkf0iR7@westworld>
 <20230106145553.6dd014f1@kernel.org>
 <CADW8OBu8R7tp-SfEwNByZqJaV-j2squT1JigniZLPwe0sWpRWg@mail.gmail.com>
 <CANn89iJTtmdT0HsUtVMBdWeuj8pNY-FN6hkv0Z3QYr8_Yt_3Rg@mail.gmail.com>
 <Y7vm00H/+oVXqsya@gondor.apana.org.au>
 <CANn89i+B6ZWJpHEPBS=cQxpa=R8LU=fO+CisdbM9bA9aCwE3_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89i+B6ZWJpHEPBS=cQxpa=R8LU=fO+CisdbM9bA9aCwE3_Q@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 09, 2023 at 11:08:08AM +0100, Eric Dumazet wrote:
>
> Kyle posted one in https://lore.kernel.org/netdev/Y7s%2FFofVXLwoVgWt@westworld/

Thanks for the link!

It looks like I didn't think about extension headers in the original
patch.

---8<---
The total cork length created by ip6_append_data includes extension
headers, so we must exclude them when comparing them against the
IPV6_CHECKSUM offset which does not include extension headers.

Reported-by: Kyle Zeng <zengyhkyle@gmail.com>
Fixes: 357b40a18b04 ("[IPV6]: IPV6_CHECKSUM socket option can corrupt kernel memory")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index c51d5ce3711c..c68020b8de89 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -539,6 +539,7 @@ static int rawv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 static int rawv6_push_pending_frames(struct sock *sk, struct flowi6 *fl6,
 				     struct raw6_sock *rp)
 {
+	struct ipv6_txoptions *opt;
 	struct sk_buff *skb;
 	int err = 0;
 	int offset;
@@ -556,6 +557,9 @@ static int rawv6_push_pending_frames(struct sock *sk, struct flowi6 *fl6,
 
 	offset = rp->offset;
 	total_len = inet_sk(sk)->cork.base.length;
+	opt = inet6_sk(sk)->cork.opt;
+	total_len -= opt ? opt->opt_flen : 0;
+
 	if (offset >= total_len - 1) {
 		err = -EINVAL;
 		ip6_flush_pending_frames(sk);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D91C7662275
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 11:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236690AbjAIKHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 05:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234238AbjAIKGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 05:06:46 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42CACB6F
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 02:05:21 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pEp1f-00FYox-C1; Mon, 09 Jan 2023 18:05:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 09 Jan 2023 18:05:07 +0800
Date:   Mon, 9 Jan 2023 18:05:07 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Kyle Zeng <zengyhkyle@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: net: ipv6: raw: fixes null pointer deference in
 rawv6_push_pending_frames
Message-ID: <Y7vm00H/+oVXqsya@gondor.apana.org.au>
References: <Y7iQeGb2xzkf0iR7@westworld>
 <20230106145553.6dd014f1@kernel.org>
 <CADW8OBu8R7tp-SfEwNByZqJaV-j2squT1JigniZLPwe0sWpRWg@mail.gmail.com>
 <CANn89iJTtmdT0HsUtVMBdWeuj8pNY-FN6hkv0Z3QYr8_Yt_3Rg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iJTtmdT0HsUtVMBdWeuj8pNY-FN6hkv0Z3QYr8_Yt_3Rg@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 09, 2023 at 09:45:14AM +0100, Eric Dumazet wrote:
> 
> OK, but it seems we would be in an error condition, and would need to
> purge sk_write_queue ?

No the bug is elsewhere.  We already checked whether the offset
is valid at the top of the function:

	total_len = inet_sk(sk)->cork.base.length;
	if (offset >= total_len - 1) {
		err = -EINVAL;
		ip6_flush_pending_frames(sk);
		goto out;
	}

So we should figure out why the socket cork queue contains less
data than it claims.

Do we have a reproducer?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

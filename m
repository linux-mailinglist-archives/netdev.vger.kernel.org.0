Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 010FF6805E1
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 07:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235592AbjA3GJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 01:09:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbjA3GJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 01:09:19 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 030769009;
        Sun, 29 Jan 2023 22:09:17 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pMNLr-005Tuy-1Z; Mon, 30 Jan 2023 14:09:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 30 Jan 2023 14:09:11 +0800
Date:   Mon, 30 Jan 2023 14:09:11 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     Thomas Graf <tgraf@suug.ch>, netdev <netdev@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: Re: Fwd: [PATCH RFC] NFSD: Convert filecache to rhltable
Message-ID: <Y9dfB322nu5d3fB1@gondor.apana.org.au>
References: <15afb0215ec76ffb54854eda8916efa4b5b3f6c3.camel@redhat.com>
 <7456FF95-0C16-45C7-8CD9-B4436BE80B71@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7456FF95-0C16-45C7-8CD9-B4436BE80B71@oracle.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 24, 2023 at 02:57:35PM +0000, Chuck Lever III wrote:
>
> > I could be wrong, but it looks like you're safe to traverse the list
> > even in the case of removals, assuming the objects themselves are
> > rcu-freed. AFAICT, the object's ->next pointer is not changed when it's
> > removed from the table. After all, we're not holding a "real" lock here
> > so the object could be removed by another task at any time.
> > 
> > It would be nice if this were documented though.

Yes this is correct.  As long as rcu_read_lock is still held,
the list will continue to be valid for walking even if you remove
entries from it.

> Is there a preferred approach for this with rhltable? Can we just
> hold rcu_read_lock and call rhltable_remove repeatedly without getting
> a fresh copy of the list these items reside on?

Yes you can walk the whole returned list while removing the nodes
one by one, assuming that you hold the RCU read lock throughout.
The unhashed nodes are only freed after the RCU grace period so the
list remains valid after removal.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

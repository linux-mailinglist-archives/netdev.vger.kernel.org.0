Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4460E6E06D9
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 08:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbjDMGXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 02:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjDMGXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 02:23:39 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F8861A1;
        Wed, 12 Apr 2023 23:23:38 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pmqMG-00FNRM-UJ; Thu, 13 Apr 2023 14:23:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 13 Apr 2023 14:23:00 +0800
Date:   Thu, 13 Apr 2023 14:23:00 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <error27@gmail.com>,
        David Laight <David.Laight@aculab.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri05@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Leonard Crestez <cdleonard@gmail.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org
Subject: [PATCH 0/6] crypto: api - Add support for cloning tfms
Message-ID: <ZDefxOq6Ax0JeTRH@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP,URIBL_BLOCKED
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Over the years, various networking-related users have needed
per-packet keys for hashing (and potentially for ciphers because
hashing can be derived from ciphers, e.g., CMAC).

Currently this is impossible to do with the Crypto API for two
reasons.  Each key is tied to a tfm object, which cannot be
allocated on the network data path (as it requires sleeping).
Secondly, various drivers rely on the fact that setkey is usually
done right after allocating a tfm object and therefore sleep in
their setkey functions.

This series tries to resolve this by making it possible to clone
an existing tfm object, thus making it possible to allocate new
tfms on the data path.

To do so you simply call crypto_clone_ahash/shash on an existing
tfm object.  Afterwards you may call setkey on it as usual.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

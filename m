Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE492BF79
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 08:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbfE1GeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 02:34:09 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:42382 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbfE1GeI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 02:34:08 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hVVgV-00039p-Mx; Tue, 28 May 2019 14:34:07 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hVVgR-00079H-Le; Tue, 28 May 2019 14:34:03 +0800
Date:   Tue, 28 May 2019 14:34:03 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        eric.dumazet@gmail.com, syzkaller@googlegroups.com
Subject: Re: [PATCH net-next 11/11] inet: frags: rework rhashtable dismantle
Message-ID: <20190528063403.ukfh37igryq4u2u6@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190524160340.169521-12-edumazet@google.com>
X-Newsgroups: apana.lists.os.linux.netdev
Organization: Core
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric:

Eric Dumazet <edumazet@google.com> wrote:
>
> +void fqdir_exit(struct fqdir *fqdir)
> +{
> +       fqdir->high_thresh = 0; /* prevent creation of new frags */
> +
> +       /* paired with READ_ONCE() in inet_frag_kill() :
> +        * We want to prevent rhashtable_remove_fast() calls
> +        */
> +       smp_store_release(&fqdir->dead, true);
> +
> +       INIT_RCU_WORK(&fqdir->destroy_rwork, fqdir_rwork_fn);
> +       queue_rcu_work(system_wq, &fqdir->destroy_rwork);
> +
> +}

What is the smp_store_release supposed to protect here? If it's
meant to separate the setting of dead and the subsequent destruction
work then it doesn't work because the barrier only protects the code
preceding it, not after.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

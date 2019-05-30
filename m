Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22BAB30249
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbfE3Svz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:51:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57498 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfE3Svz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 14:51:55 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C8A9514D9DAB4;
        Thu, 30 May 2019 11:51:54 -0700 (PDT)
Date:   Thu, 30 May 2019 11:51:54 -0700 (PDT)
Message-Id: <20190530.115154.102635044166921930.davem@davemloft.net>
To:     herbert@gondor.apana.org.au
Cc:     edumazet@google.com, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, syzkaller@googlegroups.com
Subject: Re: [PATCH] inet: frags: Remove unnecessary
 smp_store_release/READ_ONCE
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190529054026.fwcyhzt33dshma4h@gondor.apana.org.au>
References: <20190528063403.ukfh37igryq4u2u6@gondor.apana.org.au>
        <CANn89i+NfFLHDthLC-=+vWV6fFSqddVqhnAWE_+mHRD9nQsNyw@mail.gmail.com>
        <20190529054026.fwcyhzt33dshma4h@gondor.apana.org.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 11:51:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Wed, 29 May 2019 13:40:26 +0800

> The smp_store_release call in fqdir_exit cannot protect the setting
> of fqdir->dead as claimed because its memory barrier is only
> guaranteed to be one-way and the barrier precedes the setting of
> fqdir->dead.
> 
> IOW it doesn't provide any barriers between fq->dir and the following
> hash table destruction.
> 
> In fact, the code is safe anyway because call_rcu does provide both
> the memory barrier as well as a guarantee that when the destruction
> work starts executing all RCU readers will see the updated value for
> fqdir->dead.
> 
> Therefore this patch removes the unnecessary smp_store_release call
> as well as the corresponding READ_ONCE on the read-side in order to
> not confuse future readers of this code.  Comments have been added
> in their places.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Applied.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E20D957BC2A
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 18:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234777AbiGTQ7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 12:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbiGTQ7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 12:59:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13EA691F8
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 09:59:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5243561DE8
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 16:59:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728A8C3411E;
        Wed, 20 Jul 2022 16:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658336377;
        bh=zQSH0dYF0b8vZI7w0oyshMK8XOvmU/4puzJkgeJf8K8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hrNjlSXqtxSOYZeeo1KruWBEEqeqlKuCrVKC4etxON8wK5wVSH64JH1XSK0VH4AEQ
         6j+AJw3MPQP4TAD/9hk3ra8kDj9ouK+ir4nXAoboBQVFYkVoxphCTAElwHOuep1HQB
         7tXQg7vmdfcnqiUkvPPBf3a7pZn16F7YHHW9PETL0wGLqmry5brKHrgcZZ8eOdjxOn
         ror+lDgyLEEozcGY24ry7gvsGyPrAsLS7B+M3tcjjOyqncnLkxFAho1BsOGLbshv1+
         pRjK9uVZu4atScM7i77CDZq9jErDCsH4ZDdpkomCVfB1uiIIHIXfPMWvnQQTH6lJhf
         qO2Jf13zS28UQ==
Date:   Wed, 20 Jul 2022 09:59:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>, vfedorenko@novek.ru
Subject: Re: [PATCH net-next v2 01/11] tls: rx: allow only one reader at a
 time
Message-ID: <20220720095936.3cfa28bc@kernel.org>
In-Reply-To: <CANn89iLtDU+w=5bb89Om5FGx6MrQwsDBQKp8UL6=O21wS0LFqw@mail.gmail.com>
References: <20220715052235.1452170-1-kuba@kernel.org>
        <20220715052235.1452170-2-kuba@kernel.org>
        <CANn89iLtDU+w=5bb89Om5FGx6MrQwsDBQKp8UL6=O21wS0LFqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jul 2022 10:37:02 +0200 Eric Dumazet wrote:
> > +               if (!timeo)
> > +                       return -EAGAIN;  
> 
> We return with socket lock held, and callers seem to not release the lock.
>  
> > +               if (signal_pending(current))
> > +                       return sock_intr_errno(timeo);  
> 
> same here.

Thanks a lot for catching these.
 
> Let's wait for syzbot to catch up :)

I'll send the fixes later today. This is just a passing comment, right?
There isn't a report you know is coming? Otherwise I can wait to give
syzbot credit, too.

I have two additional questions while I have you :)

Is the timeo supposed to be for the entire operation? Right now TLS
seems to use a fresh timeo every time it goes to wait so the cumulative
wait can be much longer, as long as some data keeps coming in :/

Last one - I posted a bit of a disemboweling patch for TCP, LMK if it's
no bueno:

https://lore.kernel.org/all/20220719231129.1870776-6-kuba@kernel.org/

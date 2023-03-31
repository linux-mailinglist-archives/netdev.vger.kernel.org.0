Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A39AC6D15F5
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 05:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjCaDXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 23:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjCaDXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 23:23:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1995C1883B
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 20:23:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0660622EC
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 03:23:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1380CC433D2;
        Fri, 31 Mar 2023 03:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680233014;
        bh=1Tm3PsME2A3u44nSPimHsP84GIhNmzOo3r0qHO7XOZ0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KtLqD0cUcZ6x309SL2huIppX4GwWs1xh1oaLfkacc5Esvr7rgYLv63V8wDBLSOU+E
         IEwAX6dLsLD9wWr5vtm7IyBBSmJUoG9JIUDhUawIhxxPGZOOhohX8bcwcpYpRJ21H2
         SQJPApjO0g6oBE0wVlOMjmvmE5Hl1s4X5MymHdQ0afEsN/u6+awrtqELnhaep1LAS3
         edauXwR2LthSaK+GkVe3f/FzhEugtL3jDBV6aOre0Iu6f/TAsNsitnbK9e477jfyLu
         VvHJjMkONwFeJrqy/xYaVbijNrmR8hcGgfy0L470886gr4XhWlJBuLAA6eAlKsVF9X
         x1Y7OYmfCvahw==
Date:   Thu, 30 Mar 2023 20:23:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
        Roman Gushchin <roman.gushchin@linux.dev>, leitao@debian.org,
        shemminger@linux.foundation.org
Subject: Re: [PATCH net] net: don't let netpoll invoke NAPI if in xmit
 context
Message-ID: <20230330202333.108dadd9@kernel.org>
In-Reply-To: <CANn89iL99-uzrktK=hKLrmoWhhqCnH5rNUC9K4W9cOs+CQrbdA@mail.gmail.com>
References: <20230331022144.2998493-1-kuba@kernel.org>
        <CANn89iL99-uzrktK=hKLrmoWhhqCnH5rNUC9K4W9cOs+CQrbdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Mar 2023 04:41:23 +0200 Eric Dumazet wrote:
> Note that we update WRITE_ONCE(txq->xmit_lock_owner, cpu) _after_
> spin_lock(&txq->_xmit_lock);
> 
> So there is a tiny window I think, for missing that we got the
> spinlock, but I do not see how to avoid it without excessive cost.

Ugh, true. Hopefully the chances of taking an IRQ which tries to print
something between those two instructions are fairly low. 

I was considering using dev_recursion_level() but AFAICT we don't
currently bump it when dequeuing from the qdisc..

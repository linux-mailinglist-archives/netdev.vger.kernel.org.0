Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0D050BE5A
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 19:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352953AbiDVROP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 13:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353761AbiDVROF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 13:14:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6877996807
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 10:10:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B1296218E
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 17:10:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE95C385BD;
        Fri, 22 Apr 2022 17:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650647446;
        bh=Q4z24ekbA4hQm2C+daKJ3dj3+OveoY8KY0sKAuXbMao=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ikiUr4BUgWH+o57GxReYNC3PX+SJJrNZ4aog77A9xzfcHQN0EoGFA8xqNz3SVV3QR
         +z1RPKcZYTUojFGXKez5DJMWsXtRUAqQvzOI74qqii+k2XtyDuQd+RZzWHRh8Si5vU
         K+UleTrUlPMh08fxRf6HXM3MpiVo/LjgZmE6umzFGkA7A0kmVEZPRHTJqKVBPD/Lhg
         Rk+7vJiL2AzDfTPKYcwFHzeKm1QMQWgnEwvMTPU5NqAPKBPvhtxDQ1BXU80oTuE5la
         Qy8DYRCv8q5U2S4GJjxmNJCMxkBb+cTTFM9KVJd08r89yk/uLGZDsuF/I3pHfXZ4xv
         8x4wHqtCy9iTw==
Date:   Fri, 22 Apr 2022 10:10:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: generalize skb freeing deferral to
 per-cpu lists
Message-ID: <20220422101045.352eb086@kernel.org>
In-Reply-To: <CANn89iLK5i9y5=iAHS=8+SinGkmGgEXR=xk=ATpnXPakD1j-vQ@mail.gmail.com>
References: <20220421153920.3637792-1-eric.dumazet@gmail.com>
        <20220422094014.1bcf78d5@kernel.org>
        <CANn89iLK5i9y5=iAHS=8+SinGkmGgEXR=xk=ATpnXPakD1j-vQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Apr 2022 09:50:33 -0700 Eric Dumazet wrote:
> The thing is that with a typical number of RX queues (typically 16 or
> 32 queues on a 100Gbit NIC),
> there is enough sharding for this spinlock to be a non-issue.
> 
> Also, we could quite easily add some batching in a future patch, for
> the cases where the number of RX queues
> is too small.
> 
> (Each cpu could hold up to 8 or 16 skbs in a per-cpu cache, before
> giving them back to alloc_cpu(s))

I was wondering if we want to keep the per-socket queue for the
batching but you're right, per CPU batch is better anyway if needed.

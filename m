Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCF06CCFD0
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 04:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjC2CK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 22:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjC2CK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 22:10:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5FA10F3
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 19:10:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9D5EB819D1
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 02:10:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E746C433D2;
        Wed, 29 Mar 2023 02:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680055852;
        bh=F1c5m9g0gDKJO+BxV98JGi0JqFdwtToUt61yhGp6OZQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lzOZQcznAlcKiyV6Vfnq6Mc8Sc8cD5eJJmhmycsGaJHnByFnfg8dlSb5a6ubZhmrk
         uLvNR8v28Fxl35Dmobqp2j1wJcQ6a68cx+9fLCdvqPkk8bvBA0d6SFeSrh9m5uEPs5
         kgeMfyplL/tQRLNPTV6Dfz7WP1HWCSYQvdIguhLC5t41wj+EWgmGEffx7HSL0J7QuZ
         4e+dkNpULXDRRl9rj8Xa6oZN2z5kcs6rpcy6Cq4FTOsAF1Q63ZHjgfzNZzgSpXgMIc
         d9VI4puKnlSN7ileM6GsYWUYGWbetn5z6U4DNc8EpaeT6ZGZfEqyQkURuXpU8tSOZQ
         Zdjy/622FYIBQ==
Date:   Tue, 28 Mar 2023 19:10:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Liang He <windhl@126.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] rionet: Fix refcounting bugs
Message-ID: <20230328191051.4ceea7bb@kernel.org>
In-Reply-To: <20230328045006.2482327-1-windhl@126.com>
References: <20230328045006.2482327-1-windhl@126.com>
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

On Tue, 28 Mar 2023 12:50:06 +0800 Liang He wrote:
> In rionet_start_xmit(), we should put the refcount_inc()
> before we add *skb* into the queue, otherwise it may cause
> the consumer to prematurely call refcount_dec().

Are you sure the race can happen? Look around the code, please.

> Besides, before the next rionet_queue_tx_msg() when we
> meet the 'RIONET_MAC_MATCH', we should also call
> refcount_inc() before the skb is added into the queue.

And why is that?

As far as I can tell your patch reorders something that doesn't matter
and then adds a bug :|

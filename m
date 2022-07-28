Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 107A8584365
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 17:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiG1Pmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 11:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiG1Pms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 11:42:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485B268DD8
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 08:42:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7FDDB82499
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 15:42:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BFA6C433C1;
        Thu, 28 Jul 2022 15:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659022965;
        bh=+KqI30ezo5Fz68wR+fomDRBAog8Zz5PmyAPgNlGXQMs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P4RBzcf4GZ0/eeLQZspD7LD27gR0jLlGvFDf/kI5fQVKQPz5ArucS+ppstU+13rj8
         4YbkFycRg6gOqsvHBZ/9BuaClAcXgdgEEvP32WsLbsaYoYDKceqZTrsUMI8w+UE9mc
         dF+cNst3OI7VHkJf+KV+ydDAaIwCDw+d+GkTkCr7YRUue/xcB3XvJpoylmtAdixc0y
         +iLKEN3lB3zr1P45Q8G7LzE/m+5+x1fdO2iDebDLev3gdD1ZXcvVyfs2WSNM1SYlA8
         WU31jb8VZXEOjFXuJCwjZZHdHJB+b8+xn/tYFAZZ/9Mpy5WgwqS4BBdomF0Jko/BCU
         MgGYLNsPiFAhw==
Date:   Thu, 28 Jul 2022 08:42:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru
Subject: Re: [PATCH net-next 2/4] tls: rx: don't consider sock_rcvtimeo()
 cumulative
Message-ID: <20220728084244.7c654a6e@kernel.org>
In-Reply-To: <e70b924a0a2ef69c4744a23862258ebb23b60907.camel@redhat.com>
References: <20220727031524.358216-1-kuba@kernel.org>
        <20220727031524.358216-3-kuba@kernel.org>
        <e70b924a0a2ef69c4744a23862258ebb23b60907.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jul 2022 15:50:03 +0200 Paolo Abeni wrote:
> I have a possibly dumb question: this patch seems to introduce a change
> of behavior (timeo re-arming after every progress vs a comulative one),
> while re-reading the thread linked above it I (mis?)understand that the
> timeo re-arming is the current behavior?
> 
> Could you please clarify/help me understand this better?

There're two places we use timeo - waiting for the exclusive reader 
lock and waiting for data. Currently (net-next as of now) we behave
cumulatively in the former and re-arm in the latter.

That's to say if we have a timeo of 50ms, and spend 10ms on the lock,
the wait for each new data record must be shorter than 40ms.

Does that make more sense?

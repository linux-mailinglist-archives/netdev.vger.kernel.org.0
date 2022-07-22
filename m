Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F01B57E974
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 00:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236532AbiGVWEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 18:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiGVWEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 18:04:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F096212AD3
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 15:04:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B328FB82B28
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 22:04:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234D4C341C6;
        Fri, 22 Jul 2022 22:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658527477;
        bh=nX/JSoO6B6hqeRlgSxaFhwHvFU6j2deWlNk3Sf6KCD8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QElE4ezErMrCtex91mrCs0RWKqztQycqKd0vg4LH1R6atfn6vilKbIaG4BYMAg0Rg
         IzD+6zpuhkEkMbrd2tYOTMOKraZ2QZjmREBPxCCfnXSr7mk0g+lxXl/VQyMbzlQFY5
         M00pajkHm0P1NnHvS0BZb5diBwdyX7IqLC6zKywgUPa4AkxVHnCySV+hW1s4tYTx7E
         3dJ+uKZHeRzmv7ddxWXD1T7l7haCSt5FZaavvYdqlXKBQ4dQzTjAdhdSiWjYcqmtlw
         dvnkWy/Dzh995Oz75GThXfELRv0KzvOqPLPRfkOyg7s+QWkdwJs+kvgWRPqzuK3AXI
         Vrs/2NYueaH9w==
Date:   Fri, 22 Jul 2022 15:04:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     <netdev@vger.kernel.org>, Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH net] net/tls: Remove the context from the list in
 tls_device_down
Message-ID: <20220722150435.371a4fd9@kernel.org>
In-Reply-To: <20220721091127.3209661-1-maximmi@nvidia.com>
References: <20220721091127.3209661-1-maximmi@nvidia.com>
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

On Thu, 21 Jul 2022 12:11:27 +0300 Maxim Mikityanskiy wrote:
> tls_device_down takes a reference on all contexts it's going to move to
> the degraded state (software fallback). If sk_destruct runs afterwards,
> it can reduce the reference counter back to 1 and return early without
> destroying the context. Then tls_device_down will release the reference
> it took and call tls_device_free_ctx. However, the context will still
> stay in tls_device_down_list forever. The list will contain an item,
> memory for which is released, making a memory corruption possible.
> 
> Fix the above bug by properly removing the context from all lists before
> any call to tls_device_free_ctx.

SGTM. The tls_device_down_list has no use, tho, is the plan to remove
it later as a cleanup or your upcoming patches make use of it?

We can delete it now if you don't have a preference, either way the fix
is small.

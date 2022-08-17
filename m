Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 082E05966ED
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 03:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238195AbiHQBl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 21:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237611AbiHQBlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 21:41:55 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF1D96767
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 18:41:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 87F2ECE19E3
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 01:41:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A15FC433C1;
        Wed, 17 Aug 2022 01:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660700511;
        bh=3sVMS8qvQygobiObSinuRe3S8Yc95cgPMuKX04iB15Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=a25hmZZMKCyYDByGwSrXVs14u29YE2wrfyoR28hy2fs07f0ZGj4Lc2eZ1Q8zVCzOv
         xg1JkLsogzpey12vtkhEZEohyfg1fdZzH9l5SOOZT+NDsaTkbXwn+WVQiOE8d/QUrM
         O8fSgmT3onIYiRLFvgFVkUQE997PCKmpid577wfORSUvDgz8O88RYASwIiGibwK1Zb
         TlmEerpCm7L2RipE0pivW+BGnuqteSc6A7AhRYDVqkPqhLVlhNMDz1N4Xk+e7Jp7ZQ
         9yo7VwVqpMITwC5TerwqaJJJXG3LciJuiZmbTePadZAzGhUR6Bahb4VJWqgFrjZWN9
         6Nvk3tejGXEHg==
Date:   Tue, 16 Aug 2022 18:41:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Haowei Yan <g1042620637@gmail.com>,
        Tom Parkin <tparkin@katalix.com>
Subject: Re: [PATCH net v2] l2tp: Serialize access to sk_user_data with sock
 lock
Message-ID: <20220816184150.78d6e3e3@kernel.org>
In-Reply-To: <20220815130107.149345-1-jakub@cloudflare.com>
References: <20220815130107.149345-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Aug 2022 15:01:07 +0200 Jakub Sitnicki wrote:
> sk->sk_user_data has multiple users, which are not compatible with each
> other. To synchronize the users, any check-if-unused-and-set access to the
> pointer has to happen with sock lock held.
> 
> l2tp currently fails to grab the lock when modifying the underlying tunnel
> socket. Fix it by adding appropriate locking.
> 
> We don't to grab the lock when l2tp clears sk_user_data, because it happens
> only in sk->sk_destruct, when the sock is going away.

Note to other netdev maintainers that based on the discussion about 
the reuseport locking it's unclear whether we shouldn't also take 
the callback lock...

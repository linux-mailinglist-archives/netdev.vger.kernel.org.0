Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B55975106C9
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 20:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351162AbiDZS1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 14:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235205AbiDZS1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 14:27:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE2F15A42F
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 11:24:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A0D5B821FB
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 18:24:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DF2C385A0;
        Tue, 26 Apr 2022 18:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650997475;
        bh=y4gkgIfvSpub65s9k+vK99yqZ8YdRy9um/AYU/EdLhs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DsLS45jQ93keCHA3gE4f9d17SgqZ7tac9S0Ar+sLvpnNEaimXCibVRio+trzKO5Ho
         EBlh0VkuohImoGU6hqQNi6JYPxHnelhDfE46KWsMec9hBQEnNptQuumzFvG3qlMsjv
         rRY6fjr0P8rmz5xq8LToouo5168K4hRLcAWvFprRMM8d3bmcSIQRK0rrSNi02vyilt
         EoUtsUtdFd7u7mZbERnbG5vQ9s5uWZ8q/oVTtLyDXkeyWmkm6Ijn5s4g9bmt//tz1L
         SU3NqySpFjxRZNYOMKAngR0oWR1WSFvfWiYHgfQefTo4kEf5G7wRnaPck3jbDzCi3X
         g78mG6oy+j8AQ==
Date:   Tue, 26 Apr 2022 11:24:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Aviad Yehezkel <aviadye@mellanox.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net v2] tls: Skip tls_append_frag on zero copy size
Message-ID: <20220426112433.1f8cfc0b@kernel.org>
In-Reply-To: <20220426154949.159055-1-maximmi@nvidia.com>
References: <20220426154949.159055-1-maximmi@nvidia.com>
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

On Tue, 26 Apr 2022 18:49:49 +0300 Maxim Mikityanskiy wrote:
> Calling tls_append_frag when max_open_record_len == record->len might
> add an empty fragment to the TLS record if the call happens to be on the
> page boundary. Normally tls_append_frag coalesces the zero-sized
> fragment to the previous one, but not if it's on page boundary.
> 
> If a resync happens then, the mlx5 driver posts dump WQEs in
> tx_post_resync_dump, and the empty fragment may become a data segment
> with byte_count == 0, which will confuse the NIC and lead to a CQE
> error.
> 
> This commit fixes the described issue by skipping tls_append_frag on
> zero size to avoid adding empty fragments. The fix is not in the driver,
> because an empty fragment is hardly the desired behavior.
> 
> Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>

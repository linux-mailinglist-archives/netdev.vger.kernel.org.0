Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEAB500B15
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 12:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242275AbiDNKao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 06:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240915AbiDNKak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 06:30:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0C678908
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 03:28:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7988C61ED5
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 10:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57DC7C385A1;
        Thu, 14 Apr 2022 10:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649932095;
        bh=qOVMcIRed93FqSM6f1Yv6XH6fG5xRT3u2822rP5io44=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eNm/iLrM09olyezza7rh3gEladiF1NNeIBpiSQo6Eumw97jAgRs7pnec4xEMev2Rn
         Yp7HMHCSQhAb8GoBsKa3bML4Zw3aMx0CPnKtRZP1z9TeTdWljM+wYerg6XmU3HqnPS
         lAOVOScA2BbvrW81kT7vXSX2TodYXcYwfxjSnlNS6QQhHR8aE6XsKaGwTL2sWNRbjJ
         SkMBm9u2B8OKQqXRbcy4vmLqed9emKtEV5MgangbU0jjEZ0alJEGzPnZBVdbfIMJsj
         LwRuXcZL/As3+xeLqakhh9XHWkpOh/VE320kRiTjA4acob27ZdUBvSgZ4oPgjJzNMn
         FbD7OHSG6U+Ag==
Date:   Thu, 14 Apr 2022 12:28:08 +0200
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        "Ilya Lesokhin" <ilyal@mellanox.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net] tls: Skip tls_append_frag on zero copy size
Message-ID: <20220414122808.09f31bfe@kernel.org>
In-Reply-To: <20220413134956.3258530-1-maximmi@nvidia.com>
References: <20220413134956.3258530-1-maximmi@nvidia.com>
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

On Wed, 13 Apr 2022 16:49:56 +0300 Maxim Mikityanskiy wrote:
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
> ---
>  net/tls/tls_device.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
> index 12f7b56771d9..af875ad4a822 100644
> --- a/net/tls/tls_device.c
> +++ b/net/tls/tls_device.c
> @@ -483,11 +483,13 @@ static int tls_push_data(struct sock *sk,
>  		copy = min_t(size_t, size, (pfrag->size - pfrag->offset));
>  		copy = min_t(size_t, copy, (max_open_record_len - record->len));
>  
> -		rc = tls_device_copy_data(page_address(pfrag->page) +
> -					  pfrag->offset, copy, msg_iter);
> -		if (rc)
> -			goto handle_error;
> -		tls_append_frag(record, pfrag, copy);
> +		if (copy) {
> +			rc = tls_device_copy_data(page_address(pfrag->page) +
> +						  pfrag->offset, copy, msg_iter);
> +			if (rc)
> +				goto handle_error;
> +			tls_append_frag(record, pfrag, copy);
> +		}

I appreciate you're likely trying to keep the fix minimal but Greg
always says "fix it right, worry about backports later".

I think we should skip more, we can reorder the mins and if 
min(size, rec space) == 0 then we can skip the allocation as well.
Maybe some application wants to do zero-length sends to flush the
MSG_MORE and would benefit that way?

>  		size -= copy;
>  		if (!size) {


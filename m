Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 281716D2E2A
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 06:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbjDAE32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 00:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231213AbjDAE31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 00:29:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE592130
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 21:29:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70C8B61926
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 04:29:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C03AC433EF;
        Sat,  1 Apr 2023 04:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680323365;
        bh=ZJQCLHhFFU1nSXhnu5oJO1Lb2NN8z9L3+0BfO/wFo3I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KRHLbEHFa61TDjHslmE4n25g/DdFhJ/7r9H0TusmMPfyC+mdiu0HMlaV4xlvq1Xvi
         bKbWMyHlyKmeZEshsTfEmkuih3gl8MaRWITljPH4tHiSRhauQr3wWHFG7z3T3o+wrj
         dSb2SV1AD0d11DJLGZ2HQVI0HbiDLZ8QHEgHW5lnMYw6im3nT5su8odS36eRVve5Ky
         zrR9EBkA6+ZirsdyfsmWCHd30raKs0Cz7RU03Ln7Sv8o6E9VlyWeroNDNGRMzgE8Eq
         gnsmDrFUagLOy2BOQm39E6Na5uDN36OiNvfggw1zp2XVNI7wEbnXpaem2jmVbtvzDh
         ZShvA1dblRHqQ==
Date:   Fri, 31 Mar 2023 21:29:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shailend Chand <shailend@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net] gve: Secure enough bytes in the first TX desc for
 all TCP pkts
Message-ID: <20230331212924.49bc1c64@kernel.org>
In-Reply-To: <20230330220939.2341562-1-shailend@google.com>
References: <20230330220939.2341562-1-shailend@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Mar 2023 15:09:39 -0700 Shailend Chand wrote:
> +	/* If the skb is gso, then we want the tcp header alone in the first segment
> +	 * otherwise we want the spec-stipulated minimum of 182B.
>  	 */
>  	hlen = is_gso ? l4_hdr_offset + tcp_hdrlen(skb) :
> -			skb_headlen(skb);
> +			min_t(int, 182, skb->len);

What spec are we talking about here?
Please add a define for the magic number.

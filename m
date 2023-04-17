Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1B246E50CF
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 21:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbjDQT0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 15:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbjDQT0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 15:26:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448C87A91
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 12:26:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB990624AB
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 19:26:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3FD7C4339B;
        Mon, 17 Apr 2023 19:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681759577;
        bh=x7RT5DmwA0MN1byo3Vn7b8wi7XhNBsENhrYQRgalGpc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OCskGTGYtwKdGfGqvGUzmlTh4aS/6cGVs8v3I7mB/f95wOS+3fPdbFZ1WhRZH0d+N
         Vpj9NSJlsF9MMawqr8oEfzDvMru0rjtcsgzPtdgbrh3yLjEY7/9orSL/2nGZU+TOEY
         oPqsjvb/WGrhuD3gWjQiTt4xpllcRtnOo9lr2ahZJTTRQtN9npsNV8LUhgfauHvVkE
         09ofZKPb01OAbdXz6O1eHtYhoQcOY8rSDgL/7XKhYZX6q4ER7SiBdoCQG48ZKKSfzp
         Ofqer+eo0eQzQRKX+lKmi3vSTYjYV9U2oyQCD4byolBz7VqjqqjlctchonbLPI1ABo
         hRziWkQUX9sxA==
Date:   Mon, 17 Apr 2023 12:26:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next v2 0/5] net: skbuff: hide some bitfield members
Message-ID: <20230417122616.230880c1@kernel.org>
In-Reply-To: <20230417155350.337873-1-kuba@kernel.org>
References: <20230417155350.337873-1-kuba@kernel.org>
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

On Mon, 17 Apr 2023 08:53:45 -0700 Jakub Kicinski wrote:
> There is a number of protocol or subsystem specific fields
> in struct sk_buff which are only accessed by one subsystem.
> We can wrap them in ifdefs with minimal code impact.
> 
> This gives us a better chance to save a 2B and a 4B holes
> resulting with the following savings (assuming a lucky
> kernel config):
> 
> -	/* size: 232, cachelines: 4, members: 28 */
> -	/* sum members: 227, holes: 1, sum holes: 4 */
> -	/* sum bitfield members: 8 bits (1 bytes) */
> +	/* size: 224, cachelines: 4, members: 28 */
>  	/* forced alignments: 2 */
> -	/* last cacheline: 40 bytes */
> +	/* last cacheline: 32 bytes */
> 
> I think that the changes shouldn't be too controversial.
> The only one I'm not 100% sure of is the SCTP one,
> 12 extra LoC for one bit.. But it did fit squarely
> in the "this bit has only one user" category.

Missed Simon's tag, sorry about that: 
https://lore.kernel.org/all/ZD03APYJqdhflYNJ@kernel.org/

Acked-by: Simon Horman <horms@kernel.org>

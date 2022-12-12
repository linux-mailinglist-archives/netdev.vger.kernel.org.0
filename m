Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 084F664A93B
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 22:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233364AbiLLVKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 16:10:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232643AbiLLVKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 16:10:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004A813D72;
        Mon, 12 Dec 2022 13:10:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9ECBAB80E61;
        Mon, 12 Dec 2022 21:10:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE97C433D2;
        Mon, 12 Dec 2022 21:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670879428;
        bh=CCrikyLYWYoT8cMMMxS7RNkwk9Q+H7h5XTWP1Z9Mkyo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m8WZb8YkLlqs7i3dWKX4ecQAQo6QdPXDnE5uQUJI3Ddv26dcSTsPTSles/EhvNP4b
         JKkX/Qb9xgaFJFbMxSd2fXt0p97fYEbpL4VHNtIA+ZqFmxHWVASxzoB96SMlV8eASo
         hUg6M15HO7SghHNzrzZzo32Ge6R2zXZ7cvBOvIPumGhOb0SxNulbjhZ736VTVurIzx
         jc7AI3hXqzvMrbD4TINJnSIRVbn/ssfM3EGoxZ7QIL+4aKY/oHQd9CXQwuG9L/z8k5
         OK9DoEaOqK/PaIyrrIbipDEI1E7BJ6ehzAXK0rZWDT9hLDhuW+UuX9dPK+jE4lwPRs
         B+32g1/eqCegg==
Date:   Mon, 12 Dec 2022 13:10:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] genetlink: Fix an error handling path in
 ctrl_dumppolicy_start()
Message-ID: <20221212131026.120bdd71@kernel.org>
In-Reply-To: <7186dae6d951495f6918c45f8250e6407d71e88f.1670878949.git.christophe.jaillet@wanadoo.fr>
References: <7186dae6d951495f6918c45f8250e6407d71e88f.1670878949.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Dec 2022 22:03:06 +0100 Christophe JAILLET wrote:
> If this memory allocation fails, some resources need to be freed.
> Add the missing goto to the error handling path.
> 
> Fixes: b502b3185cd6 ("genetlink: use iterator in the op to policy map dumping")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> This patch is speculative.
> 
> This function is a callback and I don't know how the core works and handles
> such situation, so review with care!

It's fine, the function has pretty much two completely separate paths.
Dump all ops and dump a single op.
Anything that allocs state before this point is on the single op path,
while the iterator is only allocated for dump all.
This should be evident from the return 0; at the end of the 
  if (tb[CTRL_ATTR_OP])

> More-over, should this kmalloc() be a kzalloc()?
> genl_op_iter_init() below does not initialize all fields, be they are maybe
> set correctly before uses.

It's fine, op_iters are put on the stack without initializing, iter
init must (and currently does) work without depending on zeroed memory.

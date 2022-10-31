Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 196B4613BBC
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 17:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbiJaQwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 12:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiJaQwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 12:52:16 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB3BA46D;
        Mon, 31 Oct 2022 09:52:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C5AA0CE1787;
        Mon, 31 Oct 2022 16:52:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD29FC433C1;
        Mon, 31 Oct 2022 16:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667235132;
        bh=4LBbaOp5pkVKnJvh0thaErh2rpcgi2vvQSPR6sAuTmM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VH5KIN5cCvqym505CXMlogO9wxchEgnm9y4Z9IFmYdeQA5qPnO2DvjlEQObz0Vnoe
         WUABDQI32Rne0BsEdU81IWOcA2AZq9DbN6nODuiAaUBCcO22qqWG44YNjiHYdx/RLN
         KDL9nQN9v70o/8xO+8uM0r+/rY9jT1YovgvJ7dyo=
Date:   Mon, 31 Oct 2022 17:53:08 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     drake@draketalley.com
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Coiby Xu <coiby.xu@gmail.com>, netdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] staging: qlge: add comment explaining memory barrier
Message-ID: <Y1/9dMavegJ+bQza@kroah.com>
References: <20221031142516.266704-1-drake@draketalley.com>
 <20221031142516.266704-4-drake@draketalley.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031142516.266704-4-drake@draketalley.com>
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 31, 2022 at 10:25:16AM -0400, drake@draketalley.com wrote:
> From: Drake Talley <drake@draketalley.com>
> 
> codestyle change that fixes the following report from checkpatch:
> 
> > WARNING: memory barrier without comment
> > #2101: FILE: drivers/staging/qlge/qlge_main.c:2101:
> 
> The added comment identifies the next item from the circular
> buffer (rx_ring->curr_entry) and its handling/unmapping as the two
> operations that must not be reordered.  Based on the kernel
> documentation for memory barriers in circular buffers
> (https://www.kernel.org/doc/Documentation/circular-buffers.txt) and
> the presence of atomic operations in the current context I'm assuming
> this usage of the memory barrier is akin to what is explained in the
> linked doc.
> 
> There are a couple of other uncommented usages of memory barriers in
> the current file.  If this comment is adequate I can add similar
> comments to the others.
> 
> Signed-off-by: Drake Talley <drake@draketalley.com>
> ---
>  drivers/staging/qlge/qlge_main.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> index c8403dbb5bad..f70390bce6d8 100644
> --- a/drivers/staging/qlge/qlge_main.c
> +++ b/drivers/staging/qlge/qlge_main.c
> @@ -2098,6 +2098,12 @@ static int qlge_clean_outbound_rx_ring(struct rx_ring *rx_ring)
>  			     rx_ring->cq_id, prod, rx_ring->cnsmr_idx);
>  
>  		net_rsp = (struct qlge_ob_mac_iocb_rsp *)rx_ring->curr_entry;
> +		/*
> +		 * Ensure that the next item from the ring buffer is loaded
> +		 * before being processed.
> +		 * Adding rmb() prevents the compiler from reordering the read
> +		 * and subsequent handling of the outbound completion pointer.
> +		 */

Which "next item"?

>  		rmb();

>  		switch (net_rsp->opcode) {

So the opcode read is what you want to prevent from reordering?  Where
is the other users of this that could have changed it?

Changes like this are hard to determine if your comments are correct.
We know what a rmb() does, the question that needs to be answered here
is _why_ it is used here.  So try to step back and see if it really is
needed at all.

If it is needed, why?  And go from there on how to document this
properly.

thanks,

greg k-h

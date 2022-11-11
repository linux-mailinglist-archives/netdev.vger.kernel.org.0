Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5A5D62601B
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 18:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234348AbiKKRI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 12:08:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234303AbiKKRHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 12:07:53 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DFD887173
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 09:07:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4C02ACE2874
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 17:07:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE7CC433D6;
        Fri, 11 Nov 2022 17:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668186442;
        bh=PQ26AHPWNJR28VnZdQ1xCyQuyADHcf2UOKzEvdM4ukY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dqUhMkj81H1ksF0h34WCR6kffwfTzB/uv3RSEGf/sefPLvJ3nnNpY8fNJmI4XlHKm
         OoU6QoPavy3j5cL38zPlMVuo5zpjkNaKiVCi7DNi0Pkw2bRbaaOU3w/Ac+i1tauWlL
         1X+7HGs85LEVOlbdu1DJ43tVcP3jg8Ji+8WZh+UDY86Jy6dEw1Qx14HJhSKhNHycoE
         Se+gQlYNsY8EGfB/+ONLlw6bdcucnGuqzAtEggQvsFRh3EC774sh8HoLqsgNqVK9S6
         nH9VKA0iU1mSXk6EosCkag1uPfPSAWMMxht6AbiYqDxWrRcmOr8TiINjhLPBQ7JgxK
         cnRhLL8A6yFjw==
Date:   Fri, 11 Nov 2022 09:07:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] ethtool: add tx aggregation parameters
Message-ID: <20221111090720.278326d1@kernel.org>
In-Reply-To: <20221109180249.4721-2-dnlplm@gmail.com>
References: <20221109180249.4721-1-dnlplm@gmail.com>
        <20221109180249.4721-2-dnlplm@gmail.com>
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

On Wed,  9 Nov 2022 19:02:47 +0100 Daniele Palmas wrote:
> Add the following ethtool tx aggregation parameters:
> 
> ETHTOOL_A_COALESCE_TX_MAX_AGGR_SIZE
> Maximum size of an aggregated block of frames in tx.

perhaps s/size/bytes/ ? Or just mention bytes in the doc? I think it's
the first argument in coalescing expressed in bytes, so to avoid
confusion we should state that clearly.

> ETHTOOL_A_COALESCE_TX_MAX_AGGR_FRAMES
> Maximum number of frames that can be aggregated into a block.
> 
> ETHTOOL_A_COALESCE_TX_USECS_AGGR_TIME
> Time in usecs after the first packet arrival in an aggregated
> block for the block to be sent.

Can we add this info to the ethtool-netlink.rst doc?

Can we also add a couple of sentences describing what aggregation is?
Something about copying the packets into a contiguous buffer to submit
as one large IO operation, usually found on USB adapters?

People with very different device needs will read this and may pattern
match the parameters to something completely different like just
delaying ringing the doorbell. So even if things seem obvious they are
worth documenting.

> diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
> index d578b8bcd8a4..a6f115867648 100644
> --- a/Documentation/networking/ethtool-netlink.rst
> +++ b/Documentation/networking/ethtool-netlink.rst
> @@ -1001,6 +1001,9 @@ Kernel response contents:
>    ``ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL``  u32     rate sampling interval
>    ``ETHTOOL_A_COALESCE_USE_CQE_TX``            bool    timer reset mode, Tx
>    ``ETHTOOL_A_COALESCE_USE_CQE_RX``            bool    timer reset mode, Rx
> +  ``ETHTOOL_A_COALESCE_TX_MAX_AGGR_SIZE``      u32     max aggr packets size, Tx
> +  ``ETHTOOL_A_COALESCE_TX_MAX_AGGR_FRAMES``    u32     max aggr packets, Tx
> +  ``ETHTOOL_A_COALESCE_TX_USECS_AGGR_TIME``    u32     time (us), aggr pkts, Tx

nit: perhaps move _aggr before the specifics? e.g.

 ETHTOOL_A_COALESCE_TX_AGGR_MAX_SIZE
 ETHTOOL_A_COALESCE_TX_AGGR_USECS_TIME

FWIW I find that the easiest way to do whole-sale renames in a series
is to generate the patches as .patch files, run sed on those, and apply
them back on a fresh branch. Rebasing is a PITA with renames.

Other then these nit picks - looks very reasonable :)

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21B0C681BAB
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 21:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbjA3UmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 15:42:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjA3UmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 15:42:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21063C2AB;
        Mon, 30 Jan 2023 12:42:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35626B80E78;
        Mon, 30 Jan 2023 20:42:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E24BC433D2;
        Mon, 30 Jan 2023 20:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675111336;
        bh=oAro2jcac7Rko4BzuSdSd0vnnKeJ9Zl1UVwMJLXobKs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pWe/qpCR7131VcqO/bmmKgy2MS+KQaDQE7hRgBgP7CQ2Mh2sMFvlDLYiPCgjOflLL
         4nfcbKXiVQHtT401WsYv9dE3FF95zm0Qzxnwg4c0CbT8kjV2RV3rG4gflIMFhZFWH0
         OdrHjaoLKzSMrccbgqr1Jyu33leRkPwGpiMBgFvhtlIsMmS+mft1loCDPfXL0KSB6d
         Y8o9qtGDY5i9J9Axuklqt7dyhQWnQax1FyZHEo0h6tc4eEWzebl+IOnaw1i53omoGs
         /RYtjp00NtkDUMbAebQ2iizgj1KGOioPAs/+URBVN2Uxa5x7ivn8Lg26nfE06kdFcV
         GvtWgLTJhbNKw==
Date:   Mon, 30 Jan 2023 12:42:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     esben@geanix.com
Cc:     Jonas Suhr Christensen <jsc@umbraculum.org>,
        netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, michal.simek@xilinx.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: ll_temac: improve reset of buffer on dma
 mapping
Message-ID: <20230130124215.1a06c5af@kernel.org>
In-Reply-To: <87edrc8aav.fsf@geanix.com>
References: <20230126101607.88407-1-jsc@umbraculum.org>
        <20230126101607.88407-2-jsc@umbraculum.org>
        <20230127231322.08b75b36@kernel.org>
        <87edrc8aav.fsf@geanix.com>
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

On Mon, 30 Jan 2023 13:40:56 +0100 esben@geanix.com wrote:
> > On Thu, 26 Jan 2023 11:16:07 +0100 Jonas Suhr Christensen wrote:  
> >> Free buffer and set pointer to null on dma mapping error.  
> >
> > Why? I don't see a leak. You should provide motivation in the commit
> > message.  
> 
> I don't think there is a leak.  But if one of the dma_map_single() calls
> in temac_dma_bd_init() fails, the error handling calls into
> temac_dma_bd_release(), which will then call dma_unmap_single() on the
> address that failed to be mapped.

I see, seems worth fixing. Please explain that in the commit message,
it's not immediately clear what the concern is, otherwise.
On top of that please add a Fixes tag here as well and repost.

> Can we be sure that doing so is always safe?  If not, this change
> ensures that we only unmap buffers that were succesfully mapped.

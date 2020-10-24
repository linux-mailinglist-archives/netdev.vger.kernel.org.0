Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 802BE297A2D
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 03:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1759105AbgJXBaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 21:30:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758374AbgJXBaf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 21:30:35 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E759F24248;
        Sat, 24 Oct 2020 01:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603503048;
        bh=x5Z3BxJamZWJHbN/ae8iRgL3C6hpakpG7U7uZIwqix0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K/ghEOJzPZajtixQ73DFYy7GPpMcaNqLOAm7LvdLGVLgLDpUWePbJ+PIJurvgeOx2
         g4YiAcDGht7T0jWlQEyJinlHPJ65v38eHRJjw06ZmwkCmoai/vEj4MFUdFJGGigN4C
         R/Bc5RFzgjsjwdAbPXHoUEiDgqx6nxVYtAxB8ZV4=
Date:   Fri, 23 Oct 2020 18:30:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        swboyd@chromium.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: ipa: command payloads already mapped
Message-ID: <20201023183047.42e315c1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201022010029.11877-1-elder@linaro.org>
References: <20201022010029.11877-1-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Oct 2020 20:00:29 -0500 Alex Elder wrote:
> IPA transactions describe actions to be performed by the IPA
> hardware.  Three cases use IPA transactions:  transmitting a socket
> buffer; providing a page to receive packet data; and issuing an IPA
> immediate command.  An IPA transaction contains a scatter/gather
> list (SGL) to hold the set of actions to be performed.
> 
> We map buffers in the SGL for DMA at the time they are added to the
> transaction.  For skb TX transactions, we fill the SGL with a call
> to skb_to_sgvec().  Page RX transactions involve a single page
> pointer, and that is recorded in the SGL with sg_set_page().  In
> both of these cases we then map the SGL for DMA with a call to
> dma_map_sg().
> 
> Immediate commands are different.  The payload for an immediate
> command comes from a region of coherent DMA memory, which must
> *not* be mapped for DMA.  For that reason, gsi_trans_cmd_add()
> sort of hand-crafts each SGL entry added to a command transaction.
> 
> This patch fixes a problem with the code that crafts the SGL entry
> for an immediate command.  Previously a portion of the SGL entry was
> updated using sg_set_buf().  However this is not valid because it
> includes a call to virt_to_page() on the buffer, but the command
> buffer pointer is not a linear address.
> 
> Since we never actually map the SGL for command transactions, there
> are very few fields in the SGL we need to fill.  Specifically, we
> only need to record the DMA address and the length, so they can be
> used by __gsi_trans_commit() to fill a TRE.  We additionally need to
> preserve the SGL flags so for_each_sg() still works.  For that we
> can simply assign a null page pointer for command SGL entries.
> 
> Fixes: 9dd441e4ed575 ("soc: qcom: ipa: GSI transactions")
> Reported-by: Stephen Boyd <swboyd@chromium.org>
> Tested-by: Stephen Boyd <swboyd@chromium.org>
> Signed-off-by: Alex Elder <elder@linaro.org>

Applied, thanks!

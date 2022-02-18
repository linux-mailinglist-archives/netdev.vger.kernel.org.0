Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5FA74BB0CB
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 05:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiBREgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 23:36:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiBREgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 23:36:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D44D119859;
        Thu, 17 Feb 2022 20:36:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D682661E26;
        Fri, 18 Feb 2022 04:36:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7555C340E9;
        Fri, 18 Feb 2022 04:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645158966;
        bh=+l51Or4meOwBjDYBCyGfvqc9xDIc92UbsEMYwevC4GU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bhzOeCh+qbxrFrS19HvOwc/3b5/uRJOVdjviXbed4BOboHQCLykNMNnIm11/UEp4g
         JfsuFeZueOuuzgsZNacwAn/W1Gstm7Y76s3i1EL35oXAvOVDCN7YWGfzD9aGnwFOCF
         DG423bQqmu99o5m0uZAQ1ZSQ93J/O5Z6LAtamCBaDYHWlWfY6vb3vekbBtvY6/jzWM
         1F6AsTOW3+nKFc50Ca8WJ8Ev09pRSR0CBdLaqt71RXftx/snsyVLKDxcq5KBBumKPo
         nvtk6CjyGzGgNiQem+gpeVaXFSq/rXZMjM3xCiz6mizVn6rCUXwVJipEioOiGsm/o+
         A0TKo2ruBhcSg==
Date:   Thu, 17 Feb 2022 20:36:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>, <kernel@axis.com>,
        Lars Persson <larper@axis.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: stmmac: Enable NAPI before interrupts go live
Message-ID: <20220217203604.39e318d0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220217145527.2696444-1-vincent.whitchurch@axis.com>
References: <20220217145527.2696444-1-vincent.whitchurch@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Feb 2022 15:55:26 +0100 Vincent Whitchurch wrote:
> From: Lars Persson <larper@axis.com>
> 
> The stmmac_open function has a race window between enabling the RX
> path and its interrupt to the point where napi_enabled is called.
> 
> A chatty network with plenty of broadcast/multicast traffic has the
> potential to completely fill the RX ring before the interrupt handler
> is installed. In this scenario the single interrupt taken will find
> napi disabled and the RX ring will not be processed. No further RX
> interrupt will be delivered because the ring is full.
> 
> The RX stall could eventually clear because the TX path will trigger a
> DMA interrupt once the tx_coal_frames threshold is reached and then
> NAPI becomes scheduled.

LGTM, although now the ndo_open and ndo_stop paths are not symmetrical.
Is there no way to mask the IRQs so that they don't fire immediately?
More common flow (IMO) would be:
 - request irq
 - mask irq
 - populate rings
 - start dma
 - enable napi
 - unmask irq
Other than the difference in flow between open/stop there may also be
some unpleasantness around restarting tx queues twice with the patch
as is.

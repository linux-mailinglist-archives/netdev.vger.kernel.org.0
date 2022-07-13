Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8E61573CB0
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 20:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236806AbiGMSsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 14:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236773AbiGMSsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 14:48:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 628122C65B;
        Wed, 13 Jul 2022 11:48:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0C2461DA8;
        Wed, 13 Jul 2022 18:48:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F23C34114;
        Wed, 13 Jul 2022 18:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657738085;
        bh=38NO3lToKP38VLjzuaPVixfjEIcb7gzrFoGrZclOBjM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X3+cEjFov0rh2HZDTIpJHWFKA7YlK5aYe8/Tux6Q3iRSa98dLWA6runnxqoLiJ78Z
         X0hhqOmDDDfFAvi75v4S6goWoggWVGvsC1bbHEv1u5iamT/Wf2zz5DeCT8VkNzRWdl
         DkT09Ld4qwoyfmZp9B3mcWRENAJ470+ZAnVDNX3zM+woaK8AnTnYnbhRt0TYPO7IHt
         rb/zEQ60m7JTB3bgzxkV1jtFETxQJoZ3Ok4JyYSZrW4ZoE0XR5dMicNNRusPC1M7Kf
         luYS2kK6arAEvaClpDVAvU0wUeLCluKdGyCj5g8WO2EIYdclOsd1PlhYln9BX5Ne5z
         OFKWyXm7+itjg==
Date:   Wed, 13 Jul 2022 11:48:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin Habets <habetsm.xilinx@gmail.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, netdev@vger.kernel.org,
        ecree.xilinx@gmail.com, linux-pci@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH net-next v2 0/2] sfc: Add EF100 BAR config support
Message-ID: <20220713114804.11c7517e@kernel.org>
In-Reply-To: <Ys6E4fvoufokIFqk@gmail.com>
References: <165719918216.28149.7678451615870416505.stgit@palantir17.mph.net>
        <20220707155500.GA305857@bhelgaas>
        <Yswn7p+OWODbT7AR@gmail.com>
        <20220711114806.2724b349@kernel.org>
        <Ys6E4fvoufokIFqk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Jul 2022 09:40:01 +0100 Martin Habets wrote:
> > So it's switching between ethernet and vdpa? Isn't there a general
> > problem for configuring vdpa capabilities (net vs storage etc) and
> > shouldn't we seek to solve your BAR format switch in a similar fashion
> > rather than adding PCI device attrs, which I believe is not done for
> > anything vDPA-related?  
> 
> The initial support will be for vdpa net. vdpa block and RDMA will follow
> later, and we also need to consider FPGA management.
> 
> When it comes to vDPA there is a "vdpa" tool that we intend to support.
> This comes into play after we've switched a device into vdpa mode (using
> this new file).
> For a network device there is also "devlink" to consider. That could be used
> to switch a device into vdpa mode, but it cannot be used to switch it
> back (there is no netdev to operate on).
> My current understanding is that we won't have this issue for RDMA.
> For FPGA management there is no general configuration tool, just what
> fpga_mgr exposes (drivers/fpga). We intend to remove the special PF
> devices we have for this (PCI space is valuable), and use the normal
> network device in stead. I can give more details on this if you want.
> Worst case a special BAR config would be needed for this, but if needed I
> expect we can restrict this to the NIC provisioning stage.
> 
> So there is a general problem I think. The solution here is something at
> lower level, which is PCI in this case.
> Another solution would be a proprietary tool, something we are off course
> keen to avoid.

Okay. Indeed, we could easily bolt something onto devlink, I'd think
but I don't know the space enough to push for one solution over
another. 

Please try to document the problem and the solution... somewhere, tho.
Otherwise the chances that the next vendor with this problem follows
the same approach fall from low to none.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 594124BA69C
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 18:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243516AbiBQRB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 12:01:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232955AbiBQRB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 12:01:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A702B3572
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 09:01:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 114EB61723
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 17:01:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395CEC340E8;
        Thu, 17 Feb 2022 17:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645117271;
        bh=Ia5Dn1+tqryB1ZNf1RhQ/Xj/dJmGuRYwzzhqJw9HVP4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sOF+DHy/XPm4QCQc6LoXRPkKHglQOKKhmbyJBL7Dqg7G2JpMDWPMO4E7gyqcnS4jA
         l//k3S4JKt4kDAK4dyCs1XXG4mHarU3dXFa1Gzw+xC6Mb3Gh9eubDND8T4qJPbBNTW
         qqj+e0w7lJ9po8ybgY/tWnfvEsbZ4MLtMKOGiYv97/iDcstCNHaBFFAEv7xcpEEuPC
         ZTTXPiJojFRMiQEG9VkTWEAaw6mBnP5y70th0UXBaJImNnIVf3aVN4tJNl+kxODt/o
         wA9kgYQUqreYY/uVVXm+G3+nhkcKrlhHvlqtCazAl0eWJ2XANvrp279ntt9OBCvmZ0
         1ylX6qU9+gXJg==
Date:   Thu, 17 Feb 2022 09:01:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <sundeep.lkml@gmail.com>, <hkelam@marvell.com>,
        <gakula@marvell.com>, <sgoutham@marvell.com>
Subject: Re: [net-next PATCH 0/2] Add ethtool support for completion event
 size
Message-ID: <20220217090110.48bcad89@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1645109346-27600-1-git-send-email-sbhatta@marvell.com>
References: <1645109346-27600-1-git-send-email-sbhatta@marvell.com>
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

On Thu, 17 Feb 2022 20:19:04 +0530 Subbaraya Sundeep wrote:
> After a packet is sent or received by NIC then NIC posts
> a completion event which consists of transmission status
> (like send success or error) and received status(like
> pointers to packet fragments). These completion events may
> also use a ring similar to rx and tx rings. This patchset
> introduces ce-size ethtool parameter to modify the size
> of the completion event if NIC hardware has that capability.
> A bigger completion event can have more receive buffer pointers
> inturn NIC can transfer a bigger frame from wire as long as
> hardware(MAC) receive frame size limit is not exceeded.
> 
> Patch 1 adds support setting/getting ce-size via
> ethtool -G and ethtool -g.
> 
> Patch 2 includes octeontx2 driver changes to use
> completion event size set from ethtool -G.

Please add an explanation to ethtool-netlink.rst so people can
understand what the semantics are.

I think we may want to rename CE -> CQE, we used cqe for IRQ config.

Does changing the CQE size also change the size of the completion ring?
Or does it only control aggregation / writeback size?

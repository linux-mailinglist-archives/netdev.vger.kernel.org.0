Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B88F4FEB13
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 01:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbiDLX0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 19:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbiDLX00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 19:26:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92CDAD1117
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 15:12:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D36261CBC
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 21:49:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE80C385A1;
        Tue, 12 Apr 2022 21:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649800148;
        bh=TKFoBgN6gGcBl8AdG9TLB647TtG60QoAqZ631HFi/EI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gN9lkXh2IvIgBGjzPkfaXcUio4abDWiRkH06RTzWcYa39bbaqix+cHQeH6Ye2ILBb
         /dCbkRo0P03jE3HnHm0Msn7QZa+TVM06xxyCAFpLviKbcaJAGnKs9al15Vj2EKTMcI
         bVTTKnLYfQhmM7xtEt4597MWTFJyqOOyTkZSPu54OUDpGfpNwqeTvNCjGVHSfhO5kG
         tIz4GpNiOQ5cCfs2kjs5PYkqJiDnHc8Y/X+w7on9Kqo/5hMz4u97jhP8FqdtJGkw0I
         sBRguXsOVRIr6czzg+37knaB+rKLV3OLzP02WY6PtUhAlkHuOg5DQsL6NFQEI+ANcv
         9E0UtmGPMDFog==
Date:   Tue, 12 Apr 2022 14:49:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ray Jui <ray.jui@broadcom.com>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [RFC] Applicability of using 'txq_trans_update' during ring
 recovery
Message-ID: <20220412144906.40d935f2@kernel.org>
In-Reply-To: <040cd578-946f-0141-c28a-2f04d00d9790@broadcom.com>
References: <1bdb8417-233d-932b-1dc0-c56042aedabd@broadcom.com>
        <20220412103724.54924945@kernel.org>
        <999fab5e-08e1-888e-6672-4fc868555b32@broadcom.com>
        <CACKFLinCdTELX7-19-hp4dK3Ysm2tCmW=qeh-SHoiKU5TShwuw@mail.gmail.com>
        <7bdffaa4-0977-414d-c28f-7408fde20bab@broadcom.com>
        <CACKFLim6ty5Pxih+aPn_mDGEy5RvZpJLFN8aV5UAhzfysL9bdA@mail.gmail.com>
        <040cd578-946f-0141-c28a-2f04d00d9790@broadcom.com>
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

On Tue, 12 Apr 2022 12:34:23 -0700 Ray Jui wrote:
> Sure, that is the general error recovery case which is very different
> from this specific recovery case we are discussing here. This specific
> recovery is solely performed by driver (without resetting firmware and
> chip) on a per NAPI ring set basis. While a specific NAPI ring set is
> being recovered, traffic is still going with the rest of the NAPI ring
> sets. Average recovery time is in the 1 - 2 ms range in this type of
> recovery.
> 
> Also as I already said, 'netif_carrier_off' is not an option given that
> the RoCE/infiniband subsystem has a dependency on 'netif_carrier_status'
> for many of their operations.
> 
> Basically I'm looking for a solution that allows one to be able to:
> 1) quieice traffic and perform recovery on a per NAPI ring set basis
> 2) During recovery, it does not cause any drastic effect on RoCE
> 
> 'txq_trans_update' may not be the most optimal solution, but it is a
> solution that satisfies the two requirements above. If there are any
> other option that is considered more optimal than 'txq_trans_update' and
> can satisfy the two requirements, please let me know.

The optimal solution would be to not have to reset your rings and
pretend like nothing happened :/ If you can't reset the ring in time
you'll have to live with the splat. End of story.

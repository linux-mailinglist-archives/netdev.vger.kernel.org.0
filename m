Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99079595D28
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 15:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235091AbiHPNV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 09:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbiHPNV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 09:21:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E5582FA1;
        Tue, 16 Aug 2022 06:21:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 348CBB819FE;
        Tue, 16 Aug 2022 13:21:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9C8C433C1;
        Tue, 16 Aug 2022 13:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660656114;
        bh=SGCFkEPXbuXFQ29cVAWMkukHHalqDiWVWCljeDC5JYE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bF2nLRyEGQ7BIRga6y5LKr4b6J/EniemAsTg8GNf3Vg20QerkiLCW3Rm/q2hcWeMJ
         BrUQ8GR/JJUZk8eX1X78/f4StLK3mDKHrIxJULdx+Ww12lOkNtU4w4cHYeFtggZa/Z
         YIjBAA7mnTZuYfaKqz6nfZyDPpMrVuLxnzvMfPNEeUuWDDJHNoUm6s1nYNTWg8z3Fp
         Rg4Y2Fj19v77fS7d4OP76gMGwxyPSGwWHvAg5EwEb5fN3eLZYcg0jFP0gODXYL3RDb
         lp2EKQgu6mg5MWqls63jwsYZyebcPrIMPT14KSVOhgDpPXPDuJr6ARRdM0iQRcl/0d
         luuJEPT/bYvQg==
Date:   Tue, 16 Aug 2022 16:21:50 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org, jgg@nvidia.com,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, keescook@chromium.org, bharat@chelsio.com
Subject: Re: [PATCH for-rc] RDMA/cxgb4: fix accept failure due to increased
 cpl_t5_pass_accept_rpl size
Message-ID: <YvuZ7h3Knz0xIGHU@unreal>
References: <20220809184118.2029-1-rahul.lakkireddy@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809184118.2029-1-rahul.lakkireddy@chelsio.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 10, 2022 at 12:11:18AM +0530, Rahul Lakkireddy wrote:
> From: Potnuri Bharat Teja <bharat@chelsio.com>
> 
> Commit 'c2ed5611afd7' has increased the cpl_t5_pass_accept_rpl{} structure
> size by 8B to avoid roundup. cpl_t5_pass_accept_rpl{} is a HW specific
> structure and increasing its size will lead to unwanted adapter errors.
> Current commit reverts the cpl_t5_pass_accept_rpl{} back to its original
> and allocates zeroed skb buffer there by avoiding the memset for iss field.
> Reorder code to minimize chip type checks.
> 
> Fixes: c2ed5611afd7 ("iw_cxgb4: Use memset_startat() for cpl_t5_pass_accept_rpl")
> Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
> Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
> ---
>  drivers/infiniband/hw/cxgb4/cm.c            | 25 ++++++++-------------
>  drivers/net/ethernet/chelsio/cxgb4/t4_msg.h |  2 +-
>  2 files changed, 10 insertions(+), 17 deletions(-)
> 

Thanks, applied to -rc.

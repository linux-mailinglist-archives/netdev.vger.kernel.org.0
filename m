Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD55655025C
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 05:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383790AbiFRDQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 23:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbiFRDQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 23:16:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A45C6D196
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 20:16:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1359F61F8A
        for <netdev@vger.kernel.org>; Sat, 18 Jun 2022 03:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC43C341C4;
        Sat, 18 Jun 2022 03:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655522206;
        bh=WgVTNAr0rsGGrg4S/L1a/OPNXwYC007oqe3RUhhk6sg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Fgm933TBHVBe2x+VhrOxRNzy1qhamKto0EWPTzVjC9WiyD1Qxgz5PIp+u7B4+Oucj
         MYdaeeHAAwPU7USORIeY5ct7ImLf7yPM47dYpaFpytf3mT+rmoCeCXxv/pbs2JrHQo
         Y9f7a1JcZzmb9WKNaAP2kNEh4YtVpyneX8fnlWPiXFA+ITpDCXD0Oovw4gScYdHirP
         iz2ED5qXvMjMPA7kA7GcNQcPhTszVNTDswAtE95HSTb9oAqTLPIth0IOVsUXvF7DO0
         vNOZ1BUbxEcGoHrW5fs6GXHsQGgPTJC6I2eIaMxExD8IPTuOd0BTx+EtXLYQ8TRraA
         2rkVP0kNO8DEA==
Date:   Fri, 17 Jun 2022 20:16:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        brouer@redhat.com, anthony.l.nguyen@intel.com, edumazet@google.com,
        intel-wired-lan@lists.osuosl.org, lorenzo.bianconi@redhat.com,
        magnus.karlsson@intel.com, sven.auhagen@voleatech.de
Subject: Re: [PATCH net] igb: fix a use-after-free issue in
 igb_clean_tx_ring
Message-ID: <20220617201644.368bab1b@kernel.org>
In-Reply-To: <108bf94b-85a6-98d4-175b-2c0d43e17b11@redhat.com>
References: <e5c01d549dc37bff18e46aeabd6fb28a7bcf84be.1655388571.git.lorenzo@kernel.org>
        <f137891f-eb33-b32b-5a16-912eb524ddef@intel.com>
        <108bf94b-85a6-98d4-175b-2c0d43e17b11@redhat.com>
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

On Fri, 17 Jun 2022 16:36:56 +0200 Jesper Dangaard Brouer wrote:
> On 16/06/2022 20.26, Jesse Brandeburg wrote:
> > On 6/16/2022 7:13 AM, Lorenzo Bianconi wrote:  
> >> Fixes: 9cbc948b5a20c ("igb: add XDP support")
> >> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>  
> > 
> > Thanks Lorenzo, @maintainers this fix seems simple enough you could 
> > directly apply it without going through intel-wired-lan, once you think 
> > it's ready.
> > 
> > Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> 
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

It got marked as Awaiting Upstream so the bot won't respond.
It's the commit 3f6a57ee8544 ("igb: fix a use-after-free issue 
in igb_clean_tx_ring") in net now.

Thanks!

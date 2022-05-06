Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1667151DD7E
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 18:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443689AbiEFQZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 12:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443219AbiEFQZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 12:25:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 806A45B884;
        Fri,  6 May 2022 09:21:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 331E0B832EB;
        Fri,  6 May 2022 16:21:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B2ABC385A8;
        Fri,  6 May 2022 16:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651854113;
        bh=trRiNmmL1AtuUo3L5IjmeWtY1NNXS8ALpeRvHwoFxTg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NJ7O3m0Rusa8vfHkct4H+5Qq/xcPwpx60ExUdfRVNut74kUn+kMPNknU0mL7b5SJU
         2gxnmh7d2qY2yJjFGajLS8icgwF2k1qBNLx3mac0UdXaYXQWcNkmN/PEbaqvmtHU6L
         e3Uwd5mWnZs0MppGnM2fC2CdA/b5VbG4Rma4IfXwi3bon0dWuaK0I+PpMqiwlNqg8x
         azsjmgJZFTuDp7gKGUPNq7IeHX3esTKWT2I8nntxhqUv80Qa+DCekTh659oBEpHKfO
         oIh8HiFAeBoKCWSodeqb80NE7CzHABo7gSYx6kEgKS3i/yb32WQuxoMe5CVv1bptlI
         cQjWdiNmzbmOg==
Date:   Fri, 6 May 2022 09:21:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc:     linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        netdev@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        davem@davemloft.net, edumazet@google.com
Subject: Re: [PATCH] ethernet: tulip: fix missing pci_disable_device() on
 error in tulip_init_one()
Message-ID: <20220506092152.405ce691@kernel.org>
In-Reply-To: <5564948.DvuYhMxLoT@eto.sf-tec.de>
References: <20220506094250.3630615-1-yangyingliang@huawei.com>
        <5564948.DvuYhMxLoT@eto.sf-tec.de>
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

On Fri, 06 May 2022 12:11:56 +0200 Rolf Eike Beer wrote:
> Am Freitag, 6. Mai 2022, 11:42:50 CEST schrieb Yang Yingliang:
> > Fix the missing pci_disable_device() before return
> > from tulip_init_one() in the error handling case.  
> 
> I would suggest removing the pci_disable_device() from tulip_remove_one() 
> instead and using pcim_enable_device(), i.e. devres, and let the driver core 
> handle all these things. Of course more of the used functions could be 
> converted them, e.g. using devm_alloc_etherdev() and so on.

Let's not rewrite the error handling in this dinosaur of a driver 
any more than absolutely necessary, please.

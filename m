Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E11B5741E2
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 05:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbiGNDcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 23:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiGNDcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 23:32:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38AA25E86
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 20:32:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33AE761E28
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 03:32:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61CF5C34114;
        Thu, 14 Jul 2022 03:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657769524;
        bh=T6J0LjVt+sJUzFsG23ZJLRPEkIwsv5eceulJ9pVHBMU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XQsPQo2AJqmiRJLpKi0b92A428ZKFqEftu5+4lO81e8ECtsJxBKSl5ffd/aNtuGLY
         0xJ6doM4AfYQ0yAghg7JMNWWY9jbxW+qpww/ZUdLj41Uj/32IP2p+10PNbVu5F004W
         CGX1iK+7dX/znaRUrlv42OrBdnwmTBDAj8P2eQiwCCYPIZw0Nwi9iTMWyr7bo9KLjC
         /2AoGMFaH+iWhor9cuv7y/gdOmQUtPUn5fQIGxd02w6UhqHtuxVrTD9K5uHTM6QKr2
         tIve2O90mpPpZAjd0Jwkx0vDtlG+nuriBzLK7bbfYxxu/jd6+H8f+/01vOCUVLQ9QC
         tslMinkWKtqjw==
Date:   Wed, 13 Jul 2022 20:32:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yonglong Li <liyonglong@chinatelecom.cn>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, alexanderduyck@fb.com
Subject: Re: [PATCH] net: sort queues in xps maps
Message-ID: <20220713203203.19662c5f@kernel.org>
In-Reply-To: <bf741f12-0587-5870-2c59-a52c36a1d2d6@chinatelecom.cn>
References: <1657679096-38572-1-git-send-email-liyonglong@chinatelecom.cn>
        <20220713190748.323cf866@kernel.org>
        <bf741f12-0587-5870-2c59-a52c36a1d2d6@chinatelecom.cn>
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

On Thu, 14 Jul 2022 11:24:31 +0800 Yonglong Li wrote:
> >> @@ -2654,6 +2660,13 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
> >>  					  skip_tc);
> >>  	}
> >>  
> >> +	for (j = -1; j = netif_attrmask_next_and(j, online_mask, mask, nr_ids),
> >> +	     j < nr_ids;) {
> >> +		tci = j * num_tc + tc;
> >> +		map = xmap_dereference(new_dev_maps->attr_map[tci]);
> >> +		sort(map->queues, map->len, sizeof(u16), cmp_u16, NULL);
> >> +	}
> >> +  
> > 
> > Can we instead make sure that expand_xps_map() maintains order?
> >   
> expand_xps_map() only alloc new_map and copy old map's queue to new_map.
> I think it is not suitable to do it in expand_xps_map().
> WDYT?

Oh, right, sorry for the confusion, I assumed since it reallocates that
it also fills the entry. It probably doesn't to make sure that all
allocations succeed before making any modifications.

Can we factor out the inside of the next loop - starting from the 
"add tx-queue to CPU/rx-queue maps" comment into a helper? My worry is
that __netif_set_xps_queue() is already pretty long and complicated we
should try to move some code out rather than make it longer.

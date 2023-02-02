Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2777C6873A4
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 04:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbjBBDII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 22:08:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjBBDIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 22:08:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD631630D
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 19:08:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8F86B80DCD
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 03:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40BCFC433EF;
        Thu,  2 Feb 2023 03:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675307282;
        bh=gkPEukK7gDVS5VE2efgY9FWIHcyG7126XeuykzvfobY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XQZ27lQn2xbRotEBFSL/z5N6RdSnpOoRs+nupn0qszLMEodrc0Jg0VHGIyxiGyQAC
         e5kKsZTVqqV0IxVxvr090SALctTg0WSc2q7CHxY/WdAvKVOu3crDFXNLORUDqDCyWU
         +Fm90TAxmuWtCe+/HYu7+W4YrISaIA60cx4qd+Lr+NwR00oROwxXndJNK3FbgqU0VK
         QFHipdv030z2cysyR5X7MuvOH/RcvanSBFEg9nZt8rew2u7RC+BsNU6seNZYNFvPEB
         69PbTbqVZgVYG+7wBwuDKxEKNiGTrKttUw/R8IozxohnqeIaqk73DpBq1lQLfwNkWi
         /DnNPVruAfzxQ==
Date:   Wed, 1 Feb 2023 19:08:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadim Fedorenko <vadfed@meta.com>
Cc:     Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        "Tariq Toukan" <ttoukan.linux@gmail.com>,
        Gal Pressman <gal@nvidia.com>,
        "Saeed Mahameed" <saeed@kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net v4 2/2] mlx5: fix possible ptp queue fifo
 use-after-free
Message-ID: <20230201190801.5082bb49@kernel.org>
In-Reply-To: <20230201122605.1350664-3-vadfed@meta.com>
References: <20230201122605.1350664-1-vadfed@meta.com>
        <20230201122605.1350664-3-vadfed@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 Feb 2023 04:26:05 -0800 Vadim Fedorenko wrote:
> +	if (skb_cc > skb_id || PTP_WQE_CTR2IDX(ptpsq->skb_fifo_pc) < skb_id) {

FWIW I still can't understand why this is correct. If we lose ts for
the last elem before wrap we'll see something like (assume wrap at 256
for easier math):

  cc: 255  pc: 2    skb_id: 0   => cc > skb_id, OOO, drop
  cc: 255  pc: 2    skb_id: 1   => cc > skb_id, OOO, drop
  cc: 255  pc: 3 // produce 
  cc: 255  pc: 3    skb_id: 2   => cc > skb_id, OOO, drop
  cc: 255  pc: 4 // produce
  cc: 255  pc: 4    skb_id: 3   => cc > skb_id, OOO, drop

No?

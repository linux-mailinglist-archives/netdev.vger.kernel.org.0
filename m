Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6D36A145D
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 01:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjBXAil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 19:38:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBXAik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 19:38:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E9C367DB
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 16:38:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 437B5617A6
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 00:38:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D10C433EF;
        Fri, 24 Feb 2023 00:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677199118;
        bh=Pj7cnq9ilNwrZsKKZs9Q7zw+iTyVVwzR9mfD4HF/OWc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FYWrZEsb0gMhBV33sOSm5s085gVxGmRwxAZEMiCjvtOpR3wDFbD9e/TxvGkM3C08/
         MGtkx7iUHstcXLgXkkCkcQMKUc3HR5sKglgGo+/DrJQgVqM9/5QdUfsWhXolLi3Q56
         R0/ez8EjoT6mjiEd4YkFC29MEX7W68s4O7Ss5Ir6NRiSwexoot3EwVdTz+srqAk46D
         dXqbZZToA9R3mXQM0w//0GoqEBUqO/6BwJo6VySFB0b4/ZYrH++0zPFZE+CPHlecfM
         d0jUdK3ICQEDsdxXQtAy+XgdAjjtTvF4zTDRHHOCCbID+L9TD7K6/PCuN/onBbTPQs
         h5vrlW0stGT8g==
Date:   Thu, 23 Feb 2023 16:38:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>
Subject: Re: [net 07/10] net/mlx5e: Correct SKB room check to use all room
 in the fifo
Message-ID: <20230223163836.546bbc76@kernel.org>
In-Reply-To: <20230223225247.586552-8-saeed@kernel.org>
References: <20230223225247.586552-1-saeed@kernel.org>
        <20230223225247.586552-8-saeed@kernel.org>
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

On Thu, 23 Feb 2023 14:52:44 -0800 Saeed Mahameed wrote:
> From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
> 
> Previous check was comparing against the fifo mask. The mask is size of the
> fifo (power of two) minus one, so a less than or equal comparator should be
> used for checking if the fifo has room for the SKB.
> 
> Fixes: 19b43a432e3e ("net/mlx5e: Extend SKB room check to include PTP-SQ")

How big is the fifo? Not utilizing a single entry is not really worth
calling a bug if the fifo has at least 32 entries..

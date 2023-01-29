Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83FA967FDDF
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 10:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbjA2Jfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 04:35:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjA2Jfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 04:35:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F9E22024;
        Sun, 29 Jan 2023 01:35:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8A50B80B9E;
        Sun, 29 Jan 2023 09:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B0DC433EF;
        Sun, 29 Jan 2023 09:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674984946;
        bh=Cvo52ASuF2lQFZBueeg4HBKdxNy5lM1KuIeUrid6CT4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q0Flz9WtrhmUUBhjWZRC+pfv5QQWtSImJe74uTRX1/y8T/qi5FNypwE/F+r7pVxEY
         zXEyPZrfel1IgZ2SwPN4BQKCUZO22HuyTZelnVKt8H9h3P/ZikKgBHpI4PrahsiNy/
         lFmcZUk+GMYQh+Oav9zWCZkQCRzolV2F6uq+EBk7Avqch3PV1RWzGKdG2Tti9aUBlX
         EREf5obqEg/IFNylq696LmDB5q9Z9s+C+ROpliRXKPVuybtPK4bkJQgqQWok7OMfpA
         eugf0wkFkg4/BJcMHYxVLQo82f80bymWb2p7NoLknR0M8EIR0bBmlS+4fse1daTO8t
         xK4/DZXtmPPtg==
Date:   Sun, 29 Jan 2023 11:35:42 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        decui@microsoft.com, kys@microsoft.com, paulros@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net, 2/2] net: mana: Fix accessing freed irq affinity_hint
Message-ID: <Y9Y97pNR/jeOy1jA@unreal>
References: <1674767085-18583-1-git-send-email-haiyangz@microsoft.com>
 <1674767085-18583-3-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1674767085-18583-3-git-send-email-haiyangz@microsoft.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023 at 01:04:45PM -0800, Haiyang Zhang wrote:
> After calling irq_set_affinity_and_hint(), the cpumask pointer is
> saved in desc->affinity_hint, and will be used later when reading
> /proc/irq/<num>/affinity_hint. So the cpumask variable needs to be
> allocated per irq, and available until freeing the irq. Otherwise,
> we are accessing freed memory when reading the affinity_hint file.
> 
> To fix the bug, allocate the cpumask per irq, and free it just
> before freeing the irq.
> 
> Cc: stable@vger.kernel.org
> Fixes: 71fa6887eeca ("net: mana: Assign interrupts to CPUs based on NUMA nodes")
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  .../net/ethernet/microsoft/mana/gdma_main.c   | 40 ++++++++++---------
>  include/net/mana/gdma.h                       |  1 +
>  2 files changed, 23 insertions(+), 18 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

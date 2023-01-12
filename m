Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAD0666A86
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 05:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235975AbjALEqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 23:46:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbjALEqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 23:46:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA74E10CD
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 20:46:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B5C5B81D89
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 04:46:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3A1C433EF;
        Thu, 12 Jan 2023 04:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673498806;
        bh=Ak+Rz7gbko+WLE5xia8sjLPsKVkFD9Dz2zDvW6nijKM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MyMj/SBJPn05NLtdrkrRTgXwWYkwGCpj4B1OM03MZIxfhoy2K7JfbElScFEWeSM3c
         E5uJ8zDcL5ybmAtq9tC8J5OkNOM3PV2A1ifAPdYdE76ZMgOkcLI190DW1Buzt+ZkKn
         Z8QEIeLREJurL2BYjxKZuT5UD/EAenSX15GCjzfOvYk+4UGazTDNbMyj9C61WMBh6o
         eh0P6Je9i+eAY3xQE3vhLugX/N6iqxAFWXiX3Lh3tLMfWrpmJwd+LJC4A1Jsi7SinD
         qe1egyWNB47Cnb/+gW2cfsuW7RBTq8juLLvbTHYDSOvARoSAmKKcI8khKamNlNeLBf
         JluF+JjNjTl/w==
Date:   Wed, 11 Jan 2023 20:46:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aurelien Aptel <aaptel@nvidia.com>
Cc:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net,
        aurelien.aptel@gmail.com, smalin@nvidia.com, malin1024@gmail.com,
        ogerlitz@nvidia.com, yorayz@nvidia.com, borisp@nvidia.com
Subject: Re: [PATCH v8 03/25] net/ethtool: add ULP_DDP_{GET,SET} operations
 for caps and stats
Message-ID: <20230111204644.040d0a9d@kernel.org>
In-Reply-To: <20230109133116.20801-4-aaptel@nvidia.com>
References: <20230109133116.20801-1-aaptel@nvidia.com>
        <20230109133116.20801-4-aaptel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  9 Jan 2023 15:30:54 +0200 Aurelien Aptel wrote:
> - 2 new netlink messages:
>   * ULP_DDP_GET: returns a bitset of supported and active capabilities
>   * ULP_DDP_SET: tries to activate requested bitset and returns results
> 
> - 2 new netdev ethtool_ops operations:
>   * ethtool_ops->get_ulp_ddp_stats(): retrieve device statistics
>   * ethtool_ops->set_ulp_ddp_capabilities(): try to apply
>     capability changes

The implementation of stats is not what I had in mind. 
None of the stats you listed under "Statistics" in the documentation
look nVidia specific. The implementation should look something like
the pause frame stats (struct ethtool_pause_stats etc) but you can add
the dynamic string set if you like. 

If given implementation does not support one of the stats it will not
fill in the value and netlink will skip over it. The truly vendor-
-specific stats (if any) can go to the old ethtool -S.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 782EB606F1A
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 07:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiJUFFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 01:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiJUFFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 01:05:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD70152C7C
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 22:05:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EDC961DB4
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 05:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 046CAC433C1;
        Fri, 21 Oct 2022 05:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666328741;
        bh=ik0qCeO7x7gDxThiGNslgszS5S/5jn/mqyzKI9T4MjE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LxOfCJXJhEVcsqX/X41JhyUYVsFM5/jEzN3bNwspL1wNxQuC36ujBub8Qrn0dbbff
         2CWEdxQph5nqFLdHEJ+OPaQ8gUYhoZibaj0t2uWdRxB2OWXJ2JlRk3krI0cKJcpaRm
         e0n1gZjGwKKc1QrjmABX5ba8Di36nL0z+qSl6ks7IEuuAFjprH+/IXwjgFAEr0F19d
         Wvw+DSAHj/c+H5mrVfe14HyAr9tAy9FmJBFmUfhWezeybWDk6pq0tURmuN57sP5P6t
         svpHbTROQXp8vE17MYj1CA14YhOGjhx4XME+dCQVBTvakr8166hNCoqjJOzhzkjRre
         ON3pLJnVUghig==
Date:   Thu, 20 Oct 2022 22:05:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aurelien Aptel <aaptel@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, saeedm@nvidia.com, tariqt@nvidia.com,
        linux-nvme@lists.infradead.org, sagi@grimberg.me, hch@lst.de,
        kbusch@kernel.org, axboe@fb.com, chaitanyak@nvidia.com,
        smalin@nvidia.com, ogerlitz@nvidia.com, yorayz@nvidia.com,
        borisp@nvidia.com, aurelien.aptel@gmail.com, malin1024@gmail.com
Subject: Re: [PATCH v6 01/23] net: Introduce direct data placement tcp
 offload
Message-ID: <20221020220540.363b0d02@kernel.org>
In-Reply-To: <20221020101838.2712846-2-aaptel@nvidia.com>
References: <20221020101838.2712846-1-aaptel@nvidia.com>
        <20221020101838.2712846-2-aaptel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Oct 2022 13:18:16 +0300 Aurelien Aptel wrote:
> +#ifdef CONFIG_ULP_DDP
> +	__u8                    ulp_ddp:1;
> +	__u8			ulp_crc:1;
> +#define IS_ULP_DDP(skb) ((skb)->ulp_ddp)
> +#define IS_ULP_CRC(skb) ((skb)->ulp_crc)
> +#else
> +#define IS_ULP_DDP(skb) (0)
> +#define IS_ULP_CRC(skb) (0)
> +#endif

This spews 10000 sparse warnings. I think it may be because of 
the struct_group() magic. Try moving the macros outside of the struct
definition. And make it a static inline while at it, dunno why you used
a define in the first place :S

Please don't repost before Monday just for that, maybe someone will find
time to review over the weekend... 

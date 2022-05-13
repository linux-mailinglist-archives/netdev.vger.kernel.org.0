Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACF1F5267DD
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 19:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382723AbiEMRE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 13:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356197AbiEMREZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 13:04:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66AA326D7
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 10:04:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01D5861F82
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 17:04:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F6BC34115;
        Fri, 13 May 2022 17:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652461463;
        bh=GJ6CMMnqTxjbB9oNTRvQbgOX+aFkYzqkYpmRMH1CL0A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SdBPU/wi7nRq/KrwlU5VXIDOhv55OaNN/Vib3ZDv/k4ckFFuzLD5s93VqqBVfQUhm
         I+4//wAPQm2mN1MVlfnjU7M7s0GlsmV09SdkjweBuFeDFMt0sLYNlbvuJK1FJcEUnA
         iAP7tl2DcxWoAFeRaBTahBrNfC5VO1qybduJoMr9YUcA5L1RsiloyabUA9P6ZqafVB
         ovXstYxEcT4zXvUuFEr4yAzj26EAMkCQEAzJyLa95ISsCR2OqHb16II7zIcSW4qF4e
         s/iTLDZm1IVAQPb4R1h3KYChyK7EX0cEm9dJJN54sblU9F8mZNl0SdaaLMxZl4SLmE
         C6k9QRJLxvvmw==
Date:   Fri, 13 May 2022 10:04:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v6 net-next 13/13] mlx5: support BIG TCP packets
Message-ID: <20220513100421.7c6d9f20@kernel.org>
In-Reply-To: <CANn89i+Y8XO9b2LSLorER2-NEPzfcAo3uG+VDxrTcimyS-kdTg@mail.gmail.com>
References: <20220510033219.2639364-1-eric.dumazet@gmail.com>
        <20220510033219.2639364-14-eric.dumazet@gmail.com>
        <20220512084023.tgjcecnu6vfuh7ry@LT-SAEEDM-5760.attlocal.net>
        <51bc118ff452c42fef489818422f278ab79e6dd4.camel@redhat.com>
        <20220513042955.rnid4776hwp556vr@fedora>
        <CANn89iKSs3bwUBho_XEuSBRB+v+iR98OZTrhaSS88D4ZYwCwSA@mail.gmail.com>
        <20220513054945.6zpaegnsgtued4up@fedora>
        <CANn89i+Y8XO9b2LSLorER2-NEPzfcAo3uG+VDxrTcimyS-kdTg@mail.gmail.com>
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

On Fri, 13 May 2022 06:05:36 -0700 Eric Dumazet wrote:
> The problem is that  skb_cow_head() can fail.
> 
> Really we have thought about this already.
> 
> A common helper for drivers is mostly unusable, you would have to
> pre-allocate a per TX-ring slot to store the headers.
> We would end up with adding complexity at queue creation/dismantle.
> 
> We could do that later, because some NICs do not inline the headers in
> TX descriptor, but instead request
> one mapped buffer for the headers part only.
> 
> BTW, I know Tariq already reviewed, the issue at hand is about
> CONFIG_FORTIFY which is blocking us.
> 
> This is why I was considering not submitting mlx5 change until Kees
> Cook and others come up with a solution.

We do have the solution, no?

commit 43213daed6d6 ("fortify: Provide a memcpy trap door for sharp
corners")

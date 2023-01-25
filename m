Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1402267BF7F
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 23:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbjAYWCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 17:02:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbjAYWCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 17:02:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C12A113D6
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 14:02:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6AFBB81BA4
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 22:02:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E348C433EF;
        Wed, 25 Jan 2023 22:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674684123;
        bh=GpyiARbyu7YJf2l5oawGqME8Od161fw3pypqlTR+IQo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EZng57PNXR9C8zat/gRJ3JCTAF0WBzy8rzADdcvsRXZJn+yJnuMfwDO67uLyXvrhB
         rv6qv0ybFhppbaUIqkPW0OhQi6peQD1rmnt6OD+2/Bs8VOP8G/AlL8iA7g0BZQqkFA
         cAcQpgLIqX/pf1fyUXleN/64CX+2lsyIt+C4gATSvjS0KSBPWemt8sohrL90jQaoOz
         dQTKvGN+oaHmHHFWE2Rd0zgmvUhiM0W8Isc4EbTnMldRc4qSkgfhtRFTip9jtJXXsw
         UGX/Wz/965z4YkllEAvdugM1+IKdvOVqRFlKEtbvmsq822UN4AJULb88cogG/RJ3PO
         kPDQ3LwsMvODg==
Date:   Wed, 25 Jan 2023 14:02:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadim Fedorenko <vadfed@meta.com>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>, Aya Levin <ayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net v2 1/2] mlx5: fix possible ptp queue fifo overflow
Message-ID: <20230125140202.44744390@kernel.org>
In-Reply-To: <85fe01df-e194-2f3c-f20a-99a71051d1d9@meta.com>
References: <20230124000836.20523-1-vfedorenko@novek.ru>
        <20230124000836.20523-2-vfedorenko@novek.ru>
        <20230123201912.42bc89fc@kernel.org>
        <85fe01df-e194-2f3c-f20a-99a71051d1d9@meta.com>
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

On Tue, 24 Jan 2023 16:03:42 +0000 Vadim Fedorenko wrote:
> > Are you sure this works for all cases?
> > Directly comparing indexes of a ring buffer seems dangerous.
> > We'd need to compare like this:
> > 
> > 	(s16)(skb_cc - skb_id) < 0
> >  
> 
> Here I would like to count (and skip re-syncing) all the packets that 
> are not going to be in FIFO. Your suggestion will not work for the 
> simplest example. Imagine we have FIFO for 16 elements, and current 
> counters are:
>   (consumer) skb_cc = 13, (producer) skb_pc = 15, so 3 packets are in.
> Then skb_id = 10 arrives out-of-order. It will be counted because of 
> (skb_cc > skb_id), but will not be catched by (skb_cc - skb_id) < 0.

Oh, I may be confused about what the producer and consumer are.
The point I was trying to make is that comparing indexes on rings is
hard. Instead of writing:

	if (a < b)

you need to write:

	if ((signed)(a - b) < 0)

"mathematically" it's the same, but in "wrapping logic" it works
because if you're further than half a ring around then it counts 
as a second negation..

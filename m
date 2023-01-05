Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7208765E4D9
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 05:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbjAEEuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 23:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbjAEEuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 23:50:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A457E41D7B
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 20:50:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03934B818F2
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 04:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793C7C433EF;
        Thu,  5 Jan 2023 04:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672894218;
        bh=im0cVNDOtqig+1wB6ZSUdUmnhtoEmBcOY8CWImB04qQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dTRNG8SQ/4CrkmvLeF08RlXioST6uvj9gGIsTp5na9uJeLFXfABi/52RMRLSafHas
         8cmx1yn00UDGo4aMwTzxofNZ0WbbksqtjXqFALJjB4WnxxPZJO3g1PEhD4MaCI6SS1
         nzrWG7R6GH4gpff3HauvMVh7nrAr8a1WXppYO4ooBAKeoydlw3zN/Msi6u/Loq6WTi
         IeDilHcwAaE3Y+bgBxk70pYdPtBfvzVC799cGSnAKXU4PQVLcKyMv3PEw7hMDYFYTb
         3AHHBACW+vIVdF13fIY+aN5ccoUW8yrKIKdhiVxW8VIG94yFm+P/4gKOhWbeY0c4Bd
         4HJiwTAfrDTwQ==
Date:   Wed, 4 Jan 2023 20:50:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 3/3] net: thunderbolt: Add tracepoints
Message-ID: <20230104205017.3e3cff38@kernel.org>
In-Reply-To: <20230104081731.45928-4-mika.westerberg@linux.intel.com>
References: <20230104081731.45928-1-mika.westerberg@linux.intel.com>
        <20230104081731.45928-4-mika.westerberg@linux.intel.com>
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

On Wed,  4 Jan 2023 10:17:31 +0200 Mika Westerberg wrote:
> +DECLARE_EVENT_CLASS(tbnet_ip_frame,
> +	TP_PROTO(u32 size, u32 id, u32 index, u32 count),
> +	TP_ARGS(size, id, index, count),
> +	TP_STRUCT__entry(
> +		__field(u32, size)
> +		__field(u32, id)
> +		__field(u32, index)
> +		__field(u32, count)
> +	),
> +	TP_fast_assign(
> +		__entry->size = le32_to_cpu(size);
> +		__entry->id = le32_to_cpu(id);
> +		__entry->index = le32_to_cpu(index);
> +		__entry->count = le32_to_cpu(count);

Looks like sparse is not happy with the byte swaps, perhaps PROTO
can also use the __le32 type?

Could you make sure there are no new warnings when building with

  make drivers/net/thunderbolt/ C=1 W=1

?

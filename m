Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30B652F3B24
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 20:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393184AbhALTtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 14:49:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:57750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393171AbhALTtk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 14:49:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8351E2311C;
        Tue, 12 Jan 2021 19:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610480939;
        bh=k2RvpzuAQAJgMUCYEgmLCHVgf5LAp7MTRGbLwfHksvI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EavPA6JzneKDXFR/5P+rK+3gAUiiBJSHU5EBD0qfT4coCqNnsZ3CWzeXE4knjIQFB
         teIOq/LulMhmbXPu4GBOh8PZXDgpMOZQhHaag0V+wcKkhZrWrPFrM+4Mjjq2POQ61d
         oWbZ3oF7PhwTgLlBmNJI2gL/9WBQMepSTEythsGxJHBhQOKKbRozAIDC4A1k9xhU02
         uMDMZ3XnsDEUfqnPjg7L5MNr6vrulo1uZpXiLzzocR/Ox7QvJJqRueoHYhKEFVMpA5
         /pfY6MsoTF/+ow/YSG7YorcF0b5fJzQNs28x3hKEA93J+mQXkGx6Blve0lbpj1b4MD
         3zMUTRvbn0B8A==
Message-ID: <ee2fe19334bc8a23009df4cf1c54731bacb7d95c.camel@kernel.org>
Subject: Re: [PATCH net-next v2 3/7] ibmvnic: avoid allocating rwi entries
From:   Saeed Mahameed <saeed@kernel.org>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>, netdev@vger.kernel.org
Cc:     Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Date:   Tue, 12 Jan 2021 11:48:58 -0800
In-Reply-To: <20210112181441.206545-4-sukadev@linux.ibm.com>
References: <20210112181441.206545-1-sukadev@linux.ibm.com>
         <20210112181441.206545-4-sukadev@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-01-12 at 10:14 -0800, Sukadev Bhattiprolu wrote:
> Whenever we need to schedule a reset, we allocate an rwi (reset work
> item?) entry and add to the list of pending resets.
> 
> Since we only add one rwi for a given reason type to the list (no
> duplicates).
> we will only have a handful of reset types in the list - even in the
> worst case. In the common case we should just have a couple of
> entries
> at most.
> 
> Rather than allocating/freeing every time (and dealing with the
> corner
> case of the allocation failing), use a fixed number of rwi entries.
> The extra memory needed is tiny and most of it will be used over the
> active life of the adapter.
> 
> This also fixes a couple of tiny memory leaks. One is in
> ibmvnic_reset()
> where we don't free the rwi entries after deleting them from the list
> due
> to a transport event.  The second is in __ibmvnic_reset() where if we
> find that the adapter is being removed, we simply break out of the
> loop
> (with rc = EBUSY) but ignore any rwi entries that remain on the list.
> 
> Fixes: 2770a7984db58 ("Introduce hard reset recovery")
> Fixes: 36f1031c51a2 ("ibmvnic: Do not process reset during or after
> device removal")
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 123 +++++++++++++++++--------
> ----
>  drivers/net/ethernet/ibm/ibmvnic.h |  14 ++--
>  2 files changed, 78 insertions(+), 59 deletions(-)
> 

[...]

> -enum ibmvnic_reset_reason {VNIC_RESET_FAILOVER = 1,
> +enum ibmvnic_reset_reason {VNIC_RESET_UNUSED = 0,
> +			   VNIC_RESET_FAILOVER = 1,
>  			   VNIC_RESET_MOBILITY,
>  			   VNIC_RESET_FATAL,
>  			   VNIC_RESET_NON_FATAL,
>  			   VNIC_RESET_TIMEOUT,
> -			   VNIC_RESET_CHANGE_PARAM};
> -
> -struct ibmvnic_rwi {
> -	enum ibmvnic_reset_reason reset_reason;
> -	struct list_head list;
> -};
> +			   VNIC_RESET_CHANGE_PARAM,
> +			   VNIC_RESET_MAX};	// must be last
       this is not the preferred comment style: ^^

I would just drop the comment here, it is clear from the name of the
enum.




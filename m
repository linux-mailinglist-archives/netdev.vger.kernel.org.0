Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 090645202E8
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 18:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239398AbiEIQxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 12:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239397AbiEIQx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 12:53:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D749A23BB54;
        Mon,  9 May 2022 09:49:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 738F2614F3;
        Mon,  9 May 2022 16:49:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E0CC385B1;
        Mon,  9 May 2022 16:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652114972;
        bh=ZE1LjbjFRbBwul1h9YV9cChUc6Y9SFbxkE8x6LsYzt4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R4tFdXksOs/FnCjxIoQCxrFN9+QvqCB+kiemC+rFHNuO6+pOyeDzFVNtDOv1/AW80
         O+SKsWQ2yaUN9X8XfPWrNpFHXIuUIf5uWRAVIoWebF3k4Cw1L0pWzKfrkzIsKtKVcH
         Exb/9tTHwWPWFioRhtWJg8zxUjCTQzEU8tCCnbsTsy/BG8g3/XYMVG2e72siDrTm7G
         py80Cj4ZrQ6huy+vRN5Sd9K2HuldKrMwvtHo4sQXTEplddzGwIyr0Bls9kD+WFN+K6
         Ug4zgoAWKAueitNKB3UHfsqpF3hbWUKs7aiQ+eHrL4YfRUl9/vCJOpYxLhCT2L6bTo
         c/raD5fW6kQww==
Date:   Mon, 9 May 2022 09:49:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        andriy.shevchenko@linux.intel.com, dinesh.sharma@intel.com,
        eliot.lee@intel.com, ilpo.johannes.jarvinen@intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com, madhusmita.sahu@intel.com
Subject: Re: [PATCH net-next v8 02/14] net: skb: introduce
 skb_data_area_size()
Message-ID: <20220509094930.6d5db0f8@kernel.org>
In-Reply-To: <20220506181310.2183829-3-ricardo.martinez@linux.intel.com>
References: <20220506181310.2183829-1-ricardo.martinez@linux.intel.com>
        <20220506181310.2183829-3-ricardo.martinez@linux.intel.com>
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

On Fri,  6 May 2022 11:12:58 -0700 Ricardo Martinez wrote:
> Helper to calculate the linear data space in the skb.
> 
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
> ---
>  include/linux/skbuff.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 5c2599e3fe7d..d58669d6cb91 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -1665,6 +1665,11 @@ static inline void skb_set_end_offset(struct sk_buff *skb, unsigned int offset)
>  }
>  #endif
>  
> +static inline unsigned int skb_data_area_size(struct sk_buff *skb)
> +{
> +	return skb_end_pointer(skb) - skb->data;
> +}

Not a great name, skb->data_len is the length of paged data.
There is no such thing as "data area", data is just a pointer
somewhere into skb->head.

Why do you need this? Why can't you use the size you passed 
to the dev_alloc_skb() like everyone else?

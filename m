Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16A9452F72D
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 02:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238216AbiEUA5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 20:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353585AbiEUA4G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 20:56:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B1B42E69D
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 17:56:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 362ADB82EDA
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 00:56:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD23C385A9;
        Sat, 21 May 2022 00:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653094562;
        bh=FioqQY5QXxTGQH+4KjAaPVHiju3wQBtxpqFLsi8FyzE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OChTNRaCCnZOjTUUQCYjy0Xnd+f4/LtXBTLK/moR1YHxeUi7QweGnKis64USQUE79
         eNhNjnRw13XFh0xS0OcBxwaQeVr6NRU9taSZj+VV9E7T1N1hcBfPzACwoSp6VEOg4o
         F59mEbWu/RGfA023Nbn/sc4rYZKbJhzPSn69t4k/LETveGDIwRi/8LZX22/7NZ9xJB
         QXAdk1jjS9fBfyviallMYpTiPFY1zrI9/0hTpTnnfd1euuXNxlFHMcYbK+u9nv7PB+
         GI9K9eEofESOT/AI8D9Ll/z9J7EOvpqDjjuUR6XpsJqK+E5C6ozBXJSqcGdRRLn6sT
         4nyrMimmXe19Q==
Date:   Fri, 20 May 2022 17:56:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yuwei Wang <wangyuweihx@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, daniel@iogearbox.net,
        roopa@nvidia.com, dsahern@kernel.org, qindi@staff.weibo.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net, neigh: introduce interval_probe_time for periodic
 probe
Message-ID: <20220520175601.630bde21@kernel.org>
In-Reply-To: <20220520055104.1528845-1-wangyuweihx@gmail.com>
References: <20220520055104.1528845-1-wangyuweihx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 May 2022 05:51:04 +0000 Yuwei Wang wrote:
> commit 7482e3841d52 ("net, neigh: Add NTF_MANAGED flag for managed neighbor entries")
> neighbor entries which with NTF_EXT_MANAGED flags will periodically call neigh_event_send()
> for performing the resolution. and the interval was set to DELAY_PROBE_TIME
> 
> DELAY_PROBE_TIME was configured as the first probe time delay, and it makes sense to set it to `0`.
> 
> when DELAY_PROBE_TIME is `0`, the resolution of neighbor entries with NTF_EXT_MANAGED will
> trap in an infinity recursion.

Recursion or will constantly get re-resolved?

> as commit messages mentioned in the above commit, we should introduce a new option which means resolution interval.
> 
> Signed-off-by: Yuwei Wang <wangyuweihx@gmail.com>

> diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
> index 39c565e460c7..5ae538be64b9 100644
> --- a/include/uapi/linux/neighbour.h
> +++ b/include/uapi/linux/neighbour.h
> @@ -143,6 +143,7 @@ enum {
>  	NDTPA_RETRANS_TIME,		/* u64, msecs */
>  	NDTPA_GC_STALETIME,		/* u64, msecs */
>  	NDTPA_DELAY_PROBE_TIME,		/* u64, msecs */
> +	NDTPA_INTERVAL_PROBE_TIME,	/* u64, msecs */
>  	NDTPA_QUEUE_LEN,		/* u32 */
>  	NDTPA_APP_PROBES,		/* u32 */
>  	NDTPA_UCAST_PROBES,		/* u32 */

You can't insert values in the middle of a uAPI enum,
you'll break binary compatibility with older kernels.

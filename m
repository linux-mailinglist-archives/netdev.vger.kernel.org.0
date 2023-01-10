Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE0B663F45
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 12:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbjAJLcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 06:32:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232988AbjAJLcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 06:32:07 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26C350148
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 03:32:06 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id fc4so27733147ejc.12
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 03:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5qiv/JLLYkHcqOBIKvuqBd6ea5glLyyaQWfxWXjA4/w=;
        b=Tq1VlylbbFTlgjSkX8Q+9jPefU/4Rh2+PThmpSY8g+9Y2LqKNxBboJiVi+Y+gqtfH7
         xgfzjEcHhDKIVx2GP1MtjYvk8tG64DYXdxye5W5bOu0TZM6UB0vPsjNpe0TuEPaM3KbV
         fTJbZvzCCUzqYxgtXj8dkQrOVHwbdjabmLwBqp6T+l9uIV1WIi+VQbcnAsi/mOWyOxoi
         UqculsqF6Ydk6EhdyL0BktXzxRc9okjg4lxZno5mTMQ508paQyYVOsma+o9zxRZV0UA6
         W4TT1Qp5AahAyQ5IzPDsktaKPCBO539f4KDj0ly64pHjEE+OwF1da6gSxRKS2gQ48Jzc
         x5eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5qiv/JLLYkHcqOBIKvuqBd6ea5glLyyaQWfxWXjA4/w=;
        b=aknBhOEKX9TiFcqQ0juUixooxYjY0y07K5NVzN8Oz9cVkvSO0cMu/lLVNxD4yX3zZF
         yU0IocSeb2dLKOqGlDPRmbR4LomPaga8OnrfxGMZRY633uP2k9zxxEHRAcJX8n13GqVX
         Rn7EGRdstDIAWaDFmn/sWmwFgmhYdmipg5vMh3bDKW4dk0rK6aCANQcBTQCN5L04SFrG
         et3zY17XKEgkLToWptqd/RlFLOl/Qgz8bd7C+FveT3IG86VJyx6Zp502qh2KzyY/8aux
         Niw8GNpicujkPwWiU8IFekH9fcOOAsXCqYtZze83YfoMG6YRNRfC9D0XQPsYKmBMdXCt
         yoOg==
X-Gm-Message-State: AFqh2kpzCCGCo0a5w1r+Rd1a+e8ajnfTXMgOvVZIrQSwyoqNddvJHRFZ
        HgdDi6cpdNBS6KAZfQXpCTL0D0WZnFR6iNdC
X-Google-Smtp-Source: AMrXdXufLSAPWJ64Vd/dBx3BWFnbyUq0u55ryQha6rwXXJXzzc1rFO5rFVi3UvNsV+PAYQkPbpBZzQ==
X-Received: by 2002:a17:907:c516:b0:7c1:e78:11ed with SMTP id tq22-20020a170907c51600b007c10e7811edmr61904228ejc.0.1673350325323;
        Tue, 10 Jan 2023 03:32:05 -0800 (PST)
Received: from hera (ppp079167090036.access.hol.gr. [79.167.90.36])
        by smtp.gmail.com with ESMTPSA id ov38-20020a170906fc2600b0084d4733c428sm2382496ejb.88.2023.01.10.03.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 03:32:04 -0800 (PST)
Date:   Tue, 10 Jan 2023 13:32:02 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>, netdev@vger.kernel.org,
        linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 21/24] page_pool: Pass a netmem to init_callback()
Message-ID: <Y71MsumlyUMMz6sY@hera>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-22-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105214631.3939268-22-willy@infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 09:46:28PM +0000, Matthew Wilcox (Oracle) wrote:
> Convert the only user of init_callback.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  include/net/page_pool.h | 2 +-
>  net/bpf/test_run.c      | 4 ++--
>  net/core/page_pool.c    | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index c607d67c96dc..d2f98b9dce13 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -181,7 +181,7 @@ struct page_pool_params {
>  	enum dma_data_direction dma_dir; /* DMA mapping direction */
>  	unsigned int	max_len; /* max DMA sync memory size */
>  	unsigned int	offset;  /* DMA addr offset */
> -	void (*init_callback)(struct page *page, void *arg);
> +	void (*init_callback)(struct netmem *nmem, void *arg);
>  	void *init_arg;
>  };
>
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index 2723623429ac..bd3c64e69f6e 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -116,9 +116,9 @@ struct xdp_test_data {
>  #define TEST_XDP_FRAME_SIZE (PAGE_SIZE - sizeof(struct xdp_page_head))
>  #define TEST_XDP_MAX_BATCH 256
>
> -static void xdp_test_run_init_page(struct page *page, void *arg)
> +static void xdp_test_run_init_page(struct netmem *nmem, void *arg)
>  {
> -	struct xdp_page_head *head = phys_to_virt(page_to_phys(page));
> +	struct xdp_page_head *head = netmem_to_virt(nmem);
>  	struct xdp_buff *new_ctx, *orig_ctx;
>  	u32 headroom = XDP_PACKET_HEADROOM;
>  	struct xdp_test_data *xdp = arg;
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 5624cdae1f4e..a1e404a7397f 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -334,7 +334,7 @@ static void page_pool_set_pp_info(struct page_pool *pool,
>  	nmem->pp = pool;
>  	nmem->pp_magic |= PP_SIGNATURE;
>  	if (pool->p.init_callback)
> -		pool->p.init_callback(netmem_page(nmem), pool->p.init_arg);
> +		pool->p.init_callback(nmem, pool->p.init_arg);
>  }
>
>  static void page_pool_clear_pp_info(struct netmem *nmem)
> --
> 2.35.1
>
Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>


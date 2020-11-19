Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD7822B9BEF
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 21:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbgKSUVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 15:21:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:47298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727126AbgKSUVR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 15:21:17 -0500
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD41122261;
        Thu, 19 Nov 2020 20:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605817277;
        bh=pBVHrDHgQ1mX9Sh2tBEYtO1DnQXC3jBFQkwSm5azjGY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=oXO7TQbyU6bsd6/CzM05DDzSzPXnIKW+Ury9SlbjLJ0k9tvN/3cczCKdkNr4wWDqv
         b+VwYEGaiQPzuxzhl7l+Hp6urQWxTvRi3zw+17xw/A+9r5wAQEEyPSUc8kr7xIN4ou
         nNerf+eoObWRG9umJV/a6E5GEnbcFuBHDMDKNQ8k=
Message-ID: <9b38c47593d2dedd5cad2c425b778a60cc7eeedf.camel@kernel.org>
Subject: Re: [PATCH net-next v7 1/4] gve: Add support for raw addressing
 device option
From:   Saeed Mahameed <saeed@kernel.org>
To:     David Awogbemila <awogbemila@google.com>, netdev@vger.kernel.org
Cc:     Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Date:   Thu, 19 Nov 2020 12:21:15 -0800
In-Reply-To: <20201118232014.2910642-2-awogbemila@google.com>
References: <20201118232014.2910642-1-awogbemila@google.com>
         <20201118232014.2910642-2-awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-11-18 at 15:20 -0800, David Awogbemila wrote:
> From: Catherine Sullivan <csully@google.com>
> 
> Add support to describe device for parsing device options. As
> the first device option, add raw addressing.
> 
> "Raw Addressing" mode (as opposed to the current "qpl" mode) is an
> operational mode which allows the driver avoid bounce buffer copies
> which it currently performs using pre-allocated qpls
> (queue_page_lists)
> when sending and receiving packets.
> For egress packets, the provided skb data addresses will be
> dma_map'ed and
> passed to the device, allowing the NIC can perform DMA directly - the
> driver will not have to copy the buffer content into pre-allocated
> buffers/qpls (as in qpl mode).
> For ingress packets, copies are also eliminated as buffers are handed
> to
> the networking stack and then recycled or re-allocated as
> necessary, avoiding the use of skb_copy_to_linear_data().
> 
> This patch only introduces the option to the driver.
> Subsequent patches will add the ingress and egress functionality.
> 
> Reviewed-by: Yangchun Fu <yangchun@google.com>
> Signed-off-by: Catherine Sullivan <csully@google.com>
> Signed-off-by: David Awogbemila <awogbemila@google.com>
> ---
> 
...
> diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c
> b/drivers/net/ethernet/google/gve/gve_adminq.c
> index 24ae6a28a806..1e2d407cb9d2 100644
> --- a/drivers/net/ethernet/google/gve/gve_adminq.c
> +++ b/drivers/net/ethernet/google/gve/gve_adminq.c
> @@ -14,6 +14,57 @@
>  #define GVE_ADMINQ_SLEEP_LEN		20
>  #define GVE_MAX_ADMINQ_EVENT_COUNTER_CHECK	100
>  
> +#define GVE_DEVICE_OPTION_ERROR_FMT "%s option error:\n" \
> +"Expected: length=%d, feature_mask=%x.\n" \
> +"Actual: length=%d, feature_mask=%x.\n"
> +
> +static inline
> +struct gve_device_option *gve_get_next_option(struct
> 

Following Dave's policy, no static inline functions in C files.
This is control path so you don't really need the inline here.




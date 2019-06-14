Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3644540B
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 07:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbfFNFfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 01:35:05 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43312 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbfFNFfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 01:35:05 -0400
Received: by mail-qt1-f194.google.com with SMTP id z24so1128284qtj.10
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 22:35:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u7JDn2kn/Kr0sPOLeia3KyOoUc9rhMH4xH4wlKrtpDM=;
        b=enlLbEqzkpGa/BfoA97Ee06pfXpUdxeOkfVY/USYhLkRfVls0U97zj/nscUQDFnw1t
         8WR38U8WHyV8LojCI7Dkc67W2pD4ekLpI4Klm3UMSwxcSvJwbMjX7qLI3H4uNRLtn5Tn
         oTlH6lfb+DhVnErsHWdLsBVv0Mi5QlpOstaBbwJKN8rVjh+DR3KFjU4CubNe5Nyy/AJc
         cIg5FIuTgDbjrh6z5XtDIXbv10rRZiDQ5zdxrWDIfSmA1SdNrAVaLGyxten7rPijjMfV
         /B/gfBhttHibP41e/FjAZ6vLHQJslSwkhRFlH/SGLPj74PfqIsOixjnMu1dTDVjdK2Mx
         Sbkg==
X-Gm-Message-State: APjAAAVZkG2Mi6CckNiskOUKuhR6EnUmYE81FoNqb5xykU4VC12X48qo
        Wnh7SsULZnzmUUaeidLN6l3HGg==
X-Google-Smtp-Source: APXvYqzC3WAJNpM5+x/HrAKG1SBpWHt7nLEnvbUXiuq0C25oxhFRCy1Mok+7QVYdG/kHW7HHS1Rvqg==
X-Received: by 2002:ac8:19ac:: with SMTP id u41mr60858553qtj.46.1560490504056;
        Thu, 13 Jun 2019 22:35:04 -0700 (PDT)
Received: from redhat.com (pool-100-0-197-103.bstnma.fios.verizon.net. [100.0.197.103])
        by smtp.gmail.com with ESMTPSA id k5sm949102qkc.75.2019.06.13.22.35.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 22:35:03 -0700 (PDT)
Date:   Fri, 14 Jun 2019 01:35:00 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jasowang@redhat.com,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH net-next] virtio_net: enable napi_tx by default
Message-ID: <20190614013449-mutt-send-email-mst@kernel.org>
References: <20190613162457.143518-1-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190613162457.143518-1-willemdebruijn.kernel@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 12:24:57PM -0400, Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> NAPI tx mode improves TCP behavior by enabling TCP small queues (TSQ).
> TSQ reduces queuing ("bufferbloat") and burstiness.
> 
> Previous measurements have shown significant improvement for
> TCP_STREAM style workloads. Such as those in commit 86a5df1495cc
> ("Merge branch 'virtio-net-tx-napi'").
> 
> There has been uncertainty about smaller possible regressions in
> latency due to increased reliance on tx interrupts.
> 
> The above results did not show that, nor did I observe this when
> rerunning TCP_RR on Linux 5.1 this week on a pair of guests in the
> same rack. This may be subject to other settings, notably interrupt
> coalescing.
> 
> In the unlikely case of regression, we have landed a credible runtime
> solution. Ethtool can configure it with -C tx-frames [0|1] as of
> commit 0c465be183c7 ("virtio_net: ethtool tx napi configuration").
> 
> NAPI tx mode has been the default in Google Container-Optimized OS
> (COS) for over half a year, as of release M70 in October 2018,
> without any negative reports.
> 
> Link: https://marc.info/?l=linux-netdev&m=149305618416472
> Link: https://lwn.net/Articles/507065/
> Signed-off-by: Willem de Bruijn <willemb@google.com>


Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
> 
> now that we have ethtool support and real production deployment,
> it seemed like a good time to revisit this discussion.
> 
> ---
>  drivers/net/virtio_net.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 0d4115c9e20b..4f3de0ac8b0b 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -26,7 +26,7 @@
>  static int napi_weight = NAPI_POLL_WEIGHT;
>  module_param(napi_weight, int, 0444);
>  
> -static bool csum = true, gso = true, napi_tx;
> +static bool csum = true, gso = true, napi_tx = true;
>  module_param(csum, bool, 0444);
>  module_param(gso, bool, 0444);
>  module_param(napi_tx, bool, 0644);
> -- 
> 2.22.0.rc2.383.gf4fbbf30c2-goog

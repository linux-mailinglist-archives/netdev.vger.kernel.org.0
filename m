Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A99ACBAEE6
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 10:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437054AbfIWIHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 04:07:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38752 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405519AbfIWIHW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Sep 2019 04:07:22 -0400
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1DAF83D94D
        for <netdev@vger.kernel.org>; Mon, 23 Sep 2019 08:07:22 +0000 (UTC)
Received: by mail-qt1-f197.google.com with SMTP id o34so16352971qtf.22
        for <netdev@vger.kernel.org>; Mon, 23 Sep 2019 01:07:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GtkVLxajS9qecd1iiLjWKYP8KasxkZAd70jCNiNzvoI=;
        b=CqrT9QajVG10+l9458G++KgJuQKi5Oya8fRHbP+pxUIT980KSvUf+A2eu1latR3FnQ
         l5ANIC5OxPyxn4CQirO/CO7M2T8eAPfcA4yipp0LioHg6JjHq5JtNbwuU0Wl7ctDWc7h
         HinQ8f5nEYyUo0qy6orVRFD0cHOo+MapAkIRwwL/HqGtwVDarO4RBQwjEcjCwb25Bfhg
         9perSZqfc8NjFJEBzcGfhS2umyo5cpKBwabtP6Zy8VkKTI7c5dVL2xJy6/u8zZTnzNwn
         TszjjLjo2Z8Z4s1SSrZnE1URxBkK8lM84IbyRqqGw3reAU5T0SZ4YLyD0lIGxauHBiv7
         1K7w==
X-Gm-Message-State: APjAAAWuNiOv//x2cU00eWW9rNIG9E2Ajf+OhY2JrWOqSgZe7B30eoPi
        zhFaVCMf7Sv+pYORlZLQHdhUovYy/N9PE3qUv3d3Gji+ltYiq1jJbJ722uEPCMZ0BCrxZAQrZXC
        iUjJc1P+9+1ZU9SPm
X-Received: by 2002:ac8:1767:: with SMTP id u36mr15795732qtk.152.1569226041433;
        Mon, 23 Sep 2019 01:07:21 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxTFCDVmbYMZjvOnYtH+mE9geB7di4826uJa+jSeyr2GrwRD/VkW9bYWy7gYlmWOdfHPTBHMg==
X-Received: by 2002:ac8:1767:: with SMTP id u36mr15795722qtk.152.1569226041292;
        Mon, 23 Sep 2019 01:07:21 -0700 (PDT)
Received: from redhat.com (bzq-79-176-40-226.red.bezeqint.net. [79.176.40.226])
        by smtp.gmail.com with ESMTPSA id 60sm5445508qta.77.2019.09.23.01.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Sep 2019 01:07:20 -0700 (PDT)
Date:   Mon, 23 Sep 2019 04:07:15 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     wangxu <wangxu72@huawei.com>
Cc:     jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost: It's better to use size_t for the 3rd parameter
 of vhost_exceeds_weight()
Message-ID: <20190923040518-mutt-send-email-mst@kernel.org>
References: <1569224801-101248-1-git-send-email-wangxu72@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1569224801-101248-1-git-send-email-wangxu72@huawei.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 23, 2019 at 03:46:41PM +0800, wangxu wrote:
> From: Wang Xu <wangxu72@huawei.com>
> 
> Caller of vhost_exceeds_weight(..., total_len) in drivers/vhost/net.c
> usually pass size_t total_len, which may be affected by rx/tx package.
> 
> Signed-off-by: Wang Xu <wangxu72@huawei.com>


Puts a bit more pressure on the register file ...
why do we care? Is there some way that it can
exceed INT_MAX?

> ---
>  drivers/vhost/vhost.c | 4 ++--
>  drivers/vhost/vhost.h | 7 ++++---
>  2 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 36ca2cf..159223a 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -412,7 +412,7 @@ static void vhost_dev_free_iovecs(struct vhost_dev *dev)
>  }
>  
>  bool vhost_exceeds_weight(struct vhost_virtqueue *vq,
> -			  int pkts, int total_len)
> +			  int pkts, size_t total_len)
>  {
>  	struct vhost_dev *dev = vq->dev;
>  
> @@ -454,7 +454,7 @@ static size_t vhost_get_desc_size(struct vhost_virtqueue *vq,
>  
>  void vhost_dev_init(struct vhost_dev *dev,
>  		    struct vhost_virtqueue **vqs, int nvqs,
> -		    int iov_limit, int weight, int byte_weight)
> +		    int iov_limit, int weight, size_t byte_weight)
>  {
>  	struct vhost_virtqueue *vq;
>  	int i;
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index e9ed272..8d80389d 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -172,12 +172,13 @@ struct vhost_dev {
>  	wait_queue_head_t wait;
>  	int iov_limit;
>  	int weight;
> -	int byte_weight;
> +	size_t byte_weight;
>  };
>  


This just costs extra memory, and value is never large,
so I don't think this matters.

> -bool vhost_exceeds_weight(struct vhost_virtqueue *vq, int pkts, int total_len);
> +bool vhost_exceeds_weight(struct vhost_virtqueue *vq, int pkts,
> +			  size_t total_len);
>  void vhost_dev_init(struct vhost_dev *, struct vhost_virtqueue **vqs,
> -		    int nvqs, int iov_limit, int weight, int byte_weight);
> +		    int nvqs, int iov_limit, int weight, size_t byte_weight);
>  long vhost_dev_set_owner(struct vhost_dev *dev);
>  bool vhost_dev_has_owner(struct vhost_dev *dev);
>  long vhost_dev_check_owner(struct vhost_dev *);
> -- 
> 1.8.5.6

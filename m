Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 768D54200A6
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 10:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbhJCIHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 04:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbhJCIHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Oct 2021 04:07:45 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC83C0613EC
        for <netdev@vger.kernel.org>; Sun,  3 Oct 2021 01:05:58 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id g7so51013674edv.1
        for <netdev@vger.kernel.org>; Sun, 03 Oct 2021 01:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nftDd/VZBjRt+xb7Lvr+SgeXmDg+7RLGPv63rB/K664=;
        b=WKUOBtR5nOhAKaBB1a8tHf+uJ/N0es90F16HEzEqPgxTv/ytFq4mztI55okXFJWHPb
         kfaDFC95cBQTIfM57m/74DICwGVOKIXg6+IV0dyxRi4WfohxL5qJ1PSF0zmJa29CacCE
         soA28E+GAIWJaTRmr4sug4c8X5MCDZ/fzCGS+pTQMMoacJNCILVCzEGo2TME4/5RMz25
         RRtIerh9I8EPvi7nu4A2WlV2Y5CYdd2T5owjmCb+Rs5jd9lHHZ4UjRucUMSHnH3HvJj9
         VqNMi4ntphx1AHEMjbbfNz3jK8Anvfu4hFPL28WSwTGTKojhRXhNfa+bsWSNkicGrdBw
         PjIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nftDd/VZBjRt+xb7Lvr+SgeXmDg+7RLGPv63rB/K664=;
        b=7KRCXYeQCehUm/mf3xFg1Q/NYMTkbtEPBw9yuCb2LqDA4wHnze67rHbz40cJKprgNe
         X6EFYLlBfyyMAd8xFHHLTS7Z3kutvtuX9LcUW8ljX8naPtr63L6obiWr9RWNHz0yx6HY
         OrApey1kewM+0qwA11cLoH9/cJHnGPh+K8fYy4juT2YRUJAkif0wwKqKjUK4nCaVTdqh
         CdBFkD01fGIi5B0wOgM3KoCN4058NZRCao6XYSwXV591uQqy7A7egmRK3Bz7kjbS5xPB
         xO2U1xEDy52V8lxg3IBkGg9zn6PZZ8iGlEJxNi8cec93DkNHyzBbswhty2/Kf8rQHQe6
         XYmQ==
X-Gm-Message-State: AOAM53331ozUA26VjCoI8PGzAuMdQ9Evw3OjqIycgsMUqvQDRflhF5uq
        GLmALWhwPaNxm9vLFWKddRM=
X-Google-Smtp-Source: ABdhPJxQgfGpt1XjE9ndFs7MCC/RAaOf7ysEIty1CVwAqdKJFBvvggHzh7+WmQBJF/A2z2sbPVmuSg==
X-Received: by 2002:a17:906:318b:: with SMTP id 11mr9453012ejy.493.1633248357283;
        Sun, 03 Oct 2021 01:05:57 -0700 (PDT)
Received: from [192.168.0.108] ([176.228.98.2])
        by smtp.gmail.com with ESMTPSA id j14sm5610563edl.21.2021.10.03.01.05.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Oct 2021 01:05:56 -0700 (PDT)
Subject: Re: [PATCH V2 net-next] net/mlx4_en: avoid one cache line miss to
 ring doorbell
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Tariq Toukan <tariqt@nvidia.com>
References: <20211001005249.3945672-1-eric.dumazet@gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <c677b3d3-62d4-7e1c-24a0-a099ce28f12a@gmail.com>
Date:   Sun, 3 Oct 2021 11:05:54 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211001005249.3945672-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/1/2021 3:52 AM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> This patch caches doorbell address directly in struct mlx4_en_tx_ring.
> 
> This removes the need to bring in cpu caches whole struct mlx4_uar
> in fast path.
> 
> Note that mlx4_uar is not guaranteed to be on a local node,
> because mlx4_bf_alloc() uses a single free list (priv->bf_list)
> regardless of its node parameter.
> 
> This kind of change does matter in presence of light/moderate traffic.
> In high stress, this read-only line would be kept hot in caches.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Tariq Toukan <tariqt@nvidia.com>
> ---
> V2: added __iomem attribute to remove sparse errors (Jakub)
> 
>   drivers/net/ethernet/mellanox/mlx4/en_tx.c   | 4 ++--
>   drivers/net/ethernet/mellanox/mlx4/mlx4_en.h | 1 +
>   2 files changed, 3 insertions(+), 2 deletions(-)
> 


Thanks for your patch.
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

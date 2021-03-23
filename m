Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92E0334621C
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 15:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232464AbhCWO6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 10:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232328AbhCWO6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 10:58:03 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96353C061574;
        Tue, 23 Mar 2021 07:58:03 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id 31-20020a9d00220000b02901b64b9b50b1so19690209ota.9;
        Tue, 23 Mar 2021 07:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pBTbJ1gqi6qZwGjIPLuEyNrn1jPsCIcXzL71BITfVqc=;
        b=WXQNB9fjlah/beKPue2wrQpvMFcQ8DSm5+6P1bqhDdQTBRYp0pJHUr763Vs7ZlvwLa
         L8fGcDyauTE7mItfKvlUxAMyEvBzpvW473HrmtiCirb6LmbVYJoU6i2kF3em2We4uB3a
         m9/0m9Wh5hGviZI7LBCN0adW/0bwNRjUo5oE2ryqR6ZQsXnEXMKEWlrCRbEHw5CvydKk
         K5KEpN3w9QV11FLFbM3oD6Jm7Wq7oFa0I9HNOKfTw+YYAB1qBpalBze4IBwWPRpbB4UX
         FC3dInEH35bCapJCUDLCgjMWVUYz4yTJD6546Fa3mKlpL2B/jJakvmZQ9pdHFO5s7M2Q
         jWSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pBTbJ1gqi6qZwGjIPLuEyNrn1jPsCIcXzL71BITfVqc=;
        b=A7VKznta7RrO4K/e6eKS/vf11xyMwVVsbtB/dTP7RryfQCOtHF2kpkM0p/tDmAxv9k
         w7cxFBNKt0AIJWxaFhYX9BT9dxdfh1KHtCOaGj+uRLQelnBem4tuZnt+ExPEUMOU7FbB
         JFdRNqEn3XU0QboDNumqKJ1sBuHwGBFUkMYbiEyPuFJxQJFrItX1CJXPVZ5uzNmr+F1x
         8r/IOeOQzbkFMUuljmDp0ouRg/UGiUAlY9jJohFTOjgwwgo8Sw5ICru9lpjcFm2NeP4Y
         IcYSb1pSO68plJ4asiul/pcgHCEHwtJBMX3sEDGxuJQPM2ayh27KOI58dBSI3i/64vzL
         9w6w==
X-Gm-Message-State: AOAM532re/7PBEvhfu7sd41DYFd+sg/oL9nYClHET48/XyvT6sdspqMa
        wrDPBWLiWGfGb6MGomh3vnM=
X-Google-Smtp-Source: ABdhPJzSxbq/FoTwpbbJi7IS9UcsaS8Jb5VWG+fVs0bKzHES3xpvO8J2Z9z54n7eKIDeo1pmYyti5g==
X-Received: by 2002:a05:6830:17d0:: with SMTP id p16mr4623060ota.127.1616511483045;
        Tue, 23 Mar 2021 07:58:03 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id e12sm3760527oou.33.2021.03.23.07.58.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Mar 2021 07:58:02 -0700 (PDT)
Subject: Re: [PATCH net-next 0/6] page_pool: recycle buffers
To:     Matteo Croce <mcroce@linux.microsoft.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>, Andrew Lunn <andrew@lunn.ch>
References: <20210322170301.26017-1-mcroce@linux.microsoft.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f5ef2e4f-fcba-2e06-86ec-17522744b6a8@gmail.com>
Date:   Tue, 23 Mar 2021 08:57:57 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210322170301.26017-1-mcroce@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/22/21 11:02 AM, Matteo Croce wrote:
> From: Matteo Croce <mcroce@microsoft.com>
> 
> This series enables recycling of the buffers allocated with the page_pool API.
> The first two patches are just prerequisite to save space in a struct and
> avoid recycling pages allocated with other API.
> Patch 2 was based on a previous idea from Jonathan Lemon.
> 
> The third one is the real recycling, 4 fixes the compilation of __skb_frag_unref
> users, and 5,6 enable the recycling on two drivers.

patch 4 should be folded into 3; each patch should build without errors.

> 
> In the last two patches I reported the improvement I have with the series.
> 
> The recycling as is can't be used with drivers like mlx5 which do page split,
> but this is documented in a comment.
> In the future, a refcount can be used so to support mlx5 with no changes.

Is the end goal of the page_pool changes to remove driver private caches?



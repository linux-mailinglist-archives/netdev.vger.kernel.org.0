Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A572EEA91
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 01:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729674AbhAHAux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 19:50:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729663AbhAHAux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 19:50:53 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D7AC0612F5
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 16:50:13 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id p18so6507531pgm.11
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 16:50:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=aV7cj3PKcKgrjSt+F3CvxyD76lss2wpxKzg35jttMAI=;
        b=EOOt6Cjs3cCuAWvRElNB+slmQDg52pnQaK/X+dYj/G7qmVhNvCpqijuWJIX85tvrP8
         m1IiQS2cg55TEwlDHwLmKhGn9uVR0K9qs7FsCYJa39bkFeIOfhmc+7cru+HCTjaivV/R
         wGjnBBPL8mllB+U9ExinWYhJ5CotfykPCpgdHgMo5H1rsbHBRlG0RnEtOEg/9BIXF9mW
         ekvSEHYUAz5wdKQNQdy+QnyJbJML99p3eXgKDd+5H57zANVu8EKwNhbGUPo5GmR/4mAl
         vBka8rTggqp+xhpi2sohgHvgNJH0+nyhnxgdBkTt9susH6sLWlr/fLsTH1QOlmkReB7m
         t7Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=aV7cj3PKcKgrjSt+F3CvxyD76lss2wpxKzg35jttMAI=;
        b=foRwgL1Xoipz98CwAhIU4kztFG0b8ldzH2Kr9/9ixa5k1GE8Dm6a4d9qBswGqqxw/h
         2DCjWs9PHPlrtVpyp5RBoqOfQvdeGl8oAaeMRlsXYgOZjWS3k2aO4A9aEsEMnoATpAvd
         4OdkYBjrsigkfM2qhUwuqb0dAWVdGRtGUZXJ7lESqlH1VNPMEbbCT9U3GcaSN0JNP45S
         /ua62+EPym2PUL4xpY5sgfW7iw5iHnqRqXEJzGfSUM8ozQwUc7vcMeneXZiKOjMywTEN
         0U9llkHnXYGguqaga6NR8iDj3r3sjkq1+wTHjbAGzEgezyZPXue92bGynBak0pYnxXT0
         PyyQ==
X-Gm-Message-State: AOAM530QySstZLcHWJlm4UbMyuSDCyYdGt3Vph56uqWW3gvpJUNWVfY0
        Phv9BpxBuwyUV6vG+OqvZp9txw==
X-Google-Smtp-Source: ABdhPJzbgULcbMqjtezmp4QPNzeiCFrUd4tZIYgSjeGxqkrnx9ia+RBpNxlF1ND0wXz1Vrn8L9vIYQ==
X-Received: by 2002:a62:1c16:0:b029:1a6:8b06:68e9 with SMTP id c22-20020a621c160000b02901a68b0668e9mr1131328pfc.45.1610067012682;
        Thu, 07 Jan 2021 16:50:12 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id i6sm7771634pgc.58.2021.01.07.16.50.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jan 2021 16:50:12 -0800 (PST)
Subject: Re: [PATCH net-next v1 1/2] net: core: count drops from GRO
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org
Cc:     intel-wired-lan@lists.osuosl.org,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
References: <20210106215539.2103688-1-jesse.brandeburg@intel.com>
 <20210106215539.2103688-2-jesse.brandeburg@intel.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <1e4ee1cf-c2b7-8ba3-7cb1-5c5cb3ff1e84@pensando.io>
Date:   Thu, 7 Jan 2021 16:50:10 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210106215539.2103688-2-jesse.brandeburg@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/6/21 1:55 PM, Jesse Brandeburg wrote:
> When drivers call the various receive upcalls to receive an skb
> to the stack, sometimes that stack can drop the packet. The good
> news is that the return code is given to all the drivers of
> NET_RX_DROP or GRO_DROP. The bad news is that no drivers except
> the one "ice" driver that I changed, check the stat and increment

If the stack is dropping the packet, isn't it up to the stack to track 
that, perhaps with something that shows up in netstat -s?  We don't 
really want to make the driver responsible for any drops that happen 
above its head, do we?

sln

> the dropped count. This is currently leading to packets that
> arrive at the edge interface and are fully handled by the driver
> and then mysteriously disappear.
>
> Rather than fix all drivers to increment the drop stat when
> handling the return code, emulate the already existing statistic
> update for NET_RX_DROP events for the two GRO_DROP locations, and
> increment the dev->rx_dropped associated with the skb.
>
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> ---
>   net/core/dev.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 8fa739259041..ef34043a9550 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6071,6 +6071,7 @@ static gro_result_t napi_skb_finish(struct napi_struct *napi,
>   		break;
>   
>   	case GRO_DROP:
> +		atomic_long_inc(&skb->dev->rx_dropped);
>   		kfree_skb(skb);
>   		break;
>   
> @@ -6159,6 +6160,7 @@ static gro_result_t napi_frags_finish(struct napi_struct *napi,
>   		break;
>   
>   	case GRO_DROP:
> +		atomic_long_inc(&skb->dev->rx_dropped);
>   		napi_reuse_skb(napi, skb);
>   		break;
>   


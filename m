Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAFF22F583
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 18:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732400AbgG0Qhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 12:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732325AbgG0Qht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 12:37:49 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC70C061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 09:37:49 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id il6so4009861pjb.0
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 09:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=fIGfqaJmJFoaxgyP3OWPgU9tUy3b/GWbTSir2GRgpZs=;
        b=Wheb/efKyR1ynWQ372/rLG4kJzAjjX+7rFs9C7oJzODF18fq5OwP0yFAwhW20FOsPz
         RpOo4wxZfu4wWXijffKgKEe07w023ClcFc1+z9XGLr3yfZF4LOVggYfuArcURaEUlZPE
         076ds5kDMAR6t4qM4b8gBfS+hnJmSGn6uG7lY+hS88DvRAvArIRVPNWwSZSWmCW0dnfq
         hFAD1EwakfMXss2KxOQ355EUuf2OWOxDz7v0bJb2SetSZud49K9nbrr5s5uMHswDbPXz
         ek4x9nYo0pxHQsA4TlmyocpNzZOS3XtSp2sy9gUS+x9TUNxkjvloKb+qktlPjFQ25KcN
         gYxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=fIGfqaJmJFoaxgyP3OWPgU9tUy3b/GWbTSir2GRgpZs=;
        b=Ftt340nXkyZlGPAjEba71uphc2roz11SiMXYdxm+XgxY/i9YPSu2rgUjSsh18VqVbE
         EHwX0Exk5nRGoWvmLeXgKdbTLQPEepcS31TAE61WwaJEcCVMfHIHmCY0nsTYHF86VlZ+
         +0CGdK3qHx85Pq/TcPJb28IP2HpCo4+YKfyuHeBJE6mQYG7WcEi23ETCeeIQ6sezsQzl
         CYHYHsds/sf/jP7XAFfoOxf8I1ysnB/CjHu2jLiXgdQmvUHJYzpIzZnkB+Fq+zf6AkBS
         LwxLHO9kIv1JAJkKT1xvh2B1ckIqM/G+c/Iu2NF95NXzjAfVLDfgnqYyl8y/aqc18W3R
         zhLw==
X-Gm-Message-State: AOAM5311UvVJt/tgSRV66qcCfXSpL/IsNbZ1gLuVP8toY3i0+bljdUH/
        liGYiTQA8dOpcXtAxbcLeFKuTQ==
X-Google-Smtp-Source: ABdhPJxOEGfYQd6aT5JlrtfLhsMQSnkwzXM/M2WXfDhEH6krDXetLVTpwOcQkN79DlhObMtlg1WXxg==
X-Received: by 2002:a17:90a:c70b:: with SMTP id o11mr107703pjt.169.1595867868898;
        Mon, 27 Jul 2020 09:37:48 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id v22sm15584896pfe.48.2020.07.27.09.37.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2020 09:37:48 -0700 (PDT)
Subject: Re: [PATCH net-next 4/4] ionic: separate interrupt for Tx and Rx
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200725002326.41407-1-snelson@pensando.io>
 <20200725002326.41407-5-snelson@pensando.io>
 <20200724175611.7b514bb1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <4a43aeb0-ab14-1c8f-0ff6-9ce7cad815c9@pensando.io>
Date:   Mon, 27 Jul 2020 09:37:45 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200724175611.7b514bb1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/24/20 5:56 PM, Jakub Kicinski wrote:
> On Fri, 24 Jul 2020 17:23:26 -0700 Shannon Nelson wrote:
>> Add the capability to split the Tx queues onto their own
>> interrupts with their own napi contexts.  This gives the
>> opportunity for more direct control of Tx interrupt
>> handling, such as CPU affinity and interrupt coalescing,
>> useful for some traffic loads.
>>
>> To enable, use the ethtool private flag:
>> 	ethtool --set-priv-flag enp20s0 split-q-intr on
>> To restore defaults
>> 	ethtool --set-priv-flag enp20s0 split-q-intr off
>>
>> When enabled, the number of queues is cut in half in order
>> to reuse the interrupts that have already been allocated to
>> the device.  When disabled, the queue count is restored.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> Splitting queues into tx-only and rx-only is done like this:
>
> ethtool -L enp20s0 rx N tx N combined 0
>
> And then back to combined:
>
> ethtool -L enp20s0 rx 0 tx 0 combined N
>
> No need for a private flag here.

Sure, we can do it that way.

Thanks,
sln


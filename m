Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 076703F8B92
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 18:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243015AbhHZQLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 12:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242968AbhHZQLr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 12:11:47 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78D1C061757
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 09:10:59 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id e15so2097641plh.8
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 09:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XPZ98kCvbBE5LDe+y2Gv/hAazxEFy1ioeKczjzoPFzQ=;
        b=soJ8IFnqpfGtADJRhWvBFEfEBoNKz7vemWl+w5tL+ngtINNwZInyxe1C7NCTMAI/Dp
         usxhbRtw/dEGNnj+nT4ee2dC1oP1x9zq9UVU5EojchnjR2wabffbdE51VawD1c2U/DW8
         AkKXn1TS0icoOpAMF1v+rzwI/83gcCxVHCsRpdfpzFmDPXvo0OsNvPQMv93CpdZwqwJW
         gJlp6uS24Hwdeq4L7c1K3zbIbw/Oxo+gOSQiwRRBisFnP4W0mQgjUPP+tMJMo7Ikax2j
         ZLXyOU8sWtKGHziysE7/ELnfrJv/FvMlszhjwQcqSrrtgNyKCDAyvfMAWse4R4k2vyMU
         7kfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XPZ98kCvbBE5LDe+y2Gv/hAazxEFy1ioeKczjzoPFzQ=;
        b=qorYnQdL76u9tqtrbzpHjhzRrd34RGajkr37V97LTMGle3md25bZTE5EwmO9hYOKMs
         Kx9yxveyl0nF0Tl2vmeq3lo4u0ZsCO6+dS1zGNm+oX21qezhJArWiXVgdZpA7o1nKUwj
         ASoNgUKfS4u7xDvVnS7hrFou6SynJsBYnL9aRae9Ud9eIiSZptY5vefI+el/apzMt+O/
         HkXXiVGxHKRP314NUyGXA30VUHqQAWil77o4xYKx28aIMHNQ9FtFo51QyKITOvnK0Al/
         5TaPD71l8UgvnWMs8CJLlmtWRyzJZgqC3CAwntLdxbzJ6Et1+vdpS4jSCMNYNVPbNE7g
         tEvw==
X-Gm-Message-State: AOAM5329PKJgyeMcN0XM87EK9yfhfImBVlBA8qlZrxrohiU5oNzwX6Yq
        NoHMdzobt6/tSQFmEPD/O+AcG0raSUM=
X-Google-Smtp-Source: ABdhPJzO8QSuij5URbFG61hKnOTJOmFq/mgf9IpkEXb7UtAdolwK6LLryw+vp1aytTca5tKeJgqc1A==
X-Received: by 2002:a17:90b:30c1:: with SMTP id hi1mr5072964pjb.187.1629994258877;
        Thu, 26 Aug 2021 09:10:58 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id me10sm9329037pjb.51.2021.08.26.09.10.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Aug 2021 09:10:58 -0700 (PDT)
Subject: Re: [PATCH net] sch_htb: Fix inconsistency when leaf qdisc creation
 fails
To:     Maxim Mikityanskiy <maximmi@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org
References: <20210826115425.1744053-1-maximmi@nvidia.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <69a54b65-fe1d-8c1c-792d-0958778c4379@gmail.com>
Date:   Thu, 26 Aug 2021 09:10:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210826115425.1744053-1-maximmi@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/26/21 4:54 AM, Maxim Mikityanskiy wrote:
> In HTB offload mode, qdiscs of leaf classes are grafted to netdev
> queues. sch_htb expects the dev_queue field of these qdiscs to point to
> the corresponding queues. However, qdisc creation may fail, and in that
> case noop_qdisc is used instead. Its dev_queue doesn't point to the
> right queue, so sch_htb can lose track of used netdev queues, which will
> cause internal inconsistencies.
> 
> This commit fixes this bug by keeping track of the netdev queue inside
> struct htb_class. All reads of cl->leaf.q->dev_queue are replaced by the
> new field, the two values are synced on writes, and WARNs are added to
> assert equality of the two values.
> 
> The driver API has changed: when TC_HTB_LEAF_DEL needs to move a queue,
> the driver used to pass the old and new queue IDs to sch_htb. Now that
> there is a new field (offload_queue) in struct htb_class that needs to
> be updated on this operation, the driver will pass the old class ID to
> sch_htb instead (it already knows the new class ID).
> 
> Fixes: d03b195b5aa0 ("sch_htb: Hierarchical QoS hardware offload")
> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/en/qos.c  | 15 ++-
>  .../net/ethernet/mellanox/mlx5/core/en/qos.h  |  4 +-
>  .../net/ethernet/mellanox/mlx5/core/en_main.c |  3 +-
>  include/net/pkt_cls.h                         |  3 +-
>  net/sched/sch_htb.c                           | 97 ++++++++++++-------
>  5 files changed, 72 insertions(+), 50 deletions(-)

Having one patch touching net/sched and one driver looks odd.

I guess it is not possible to split it ?


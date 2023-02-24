Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3EE6A1C08
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 13:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbjBXMSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 07:18:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjBXMSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 07:18:51 -0500
Received: from out-22.mta0.migadu.com (out-22.mta0.migadu.com [IPv6:2001:41d0:1004:224b::16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDE4679A8
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 04:18:38 -0800 (PST)
Message-ID: <28ccadd6-7c79-2a18-315e-3eabb14db80e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1677241114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lUfxqG7lqXq7n4rbertvs+ZhiP2BgCFlJCmIgP+KpgQ=;
        b=mMBRSZMcY++kd/lhO5t4LLyiP2XzsdJ8IYjDJM80q3nRLRSSZUbAfnxUweXpslSrvB7qcg
        5V4WEibSwCwp8JaTaaNvmGFdarxAYOq6l1GiINOhiF4r9PE4B8+PHXAT427Tw4S0qvYkHY
        FeGecQK1t+c1sT58AYZBgOu/OcRaoQc=
Date:   Fri, 24 Feb 2023 12:18:32 +0000
MIME-Version: 1.0
Subject: Re: [net 07/10] net/mlx5e: Correct SKB room check to use all room in
 the fifo
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>
References: <20230223225247.586552-1-saeed@kernel.org>
 <20230223225247.586552-8-saeed@kernel.org>
 <20230223163836.546bbc76@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Vadim Fedorenko <vadim.fedorenko@linux.dev>
In-Reply-To: <20230223163836.546bbc76@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/02/2023 00:38, Jakub Kicinski wrote:
> On Thu, 23 Feb 2023 14:52:44 -0800 Saeed Mahameed wrote:
>> From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
>>
>> Previous check was comparing against the fifo mask. The mask is size of the
>> fifo (power of two) minus one, so a less than or equal comparator should be
>> used for checking if the fifo has room for the SKB.
>>
>> Fixes: 19b43a432e3e ("net/mlx5e: Extend SKB room check to include PTP-SQ")
> 
> How big is the fifo? Not utilizing a single entry is not really worth
> calling a bug if the fifo has at least 32 entries..

AFAIK, it has the same size that any other SQ queue, up to 8192 entries 
for now.

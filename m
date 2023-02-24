Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9382D6A2119
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 19:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbjBXSEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 13:04:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjBXSEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 13:04:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF8B4C36
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 10:03:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57859B81CB7
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 18:03:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92EEC4339B;
        Fri, 24 Feb 2023 18:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677261833;
        bh=OFXqEuczEfQ9oSCgYwELIySt+0/XYC46iPnYnMQWtR8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AC4D8UGIIyce2RtIG0daYooqZ2+BPE12ZGA1CvV6ruyVfVoU7+q+J50NbXjOl/b0M
         nbLSgrdik+3XYYfL3BE92gEdz2nbBItWmU9oIlz4QREMT1+pvLJCBFomN6Qsx5+pZ6
         UtX8xrkNiEOLQO+DxysVQzQduZkJIQgSiuXhbj4a+sdUF+YCqYEmlbVuLz1Yr6YpSP
         JlKx5SVOG3t0Brwfor1YFZyQTwI9d45W+3fQRldXxAEmAi3YQThKAMJWioD1CjOCzE
         6MezIkd1RlaIG97VI+Vk5urA9koBVG94tEGerjtbcTsgRLD28X6mHX19pXwA+VHPbK
         oSaSvZksnEnNg==
Date:   Fri, 24 Feb 2023 10:03:51 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>
Subject: Re: [net 07/10] net/mlx5e: Correct SKB room check to use all room in
 the fifo
Message-ID: <Y/j8BzO2HQHZyopO@x130>
References: <20230223225247.586552-1-saeed@kernel.org>
 <20230223225247.586552-8-saeed@kernel.org>
 <20230223163836.546bbc76@kernel.org>
 <28ccadd6-7c79-2a18-315e-3eabb14db80e@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <28ccadd6-7c79-2a18-315e-3eabb14db80e@linux.dev>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24 Feb 12:18, Vadim Fedorenko wrote:
>On 24/02/2023 00:38, Jakub Kicinski wrote:
>>On Thu, 23 Feb 2023 14:52:44 -0800 Saeed Mahameed wrote:
>>>From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
>>>
>>>Previous check was comparing against the fifo mask. The mask is size of the
>>>fifo (power of two) minus one, so a less than or equal comparator should be
>>>used for checking if the fifo has room for the SKB.
>>>
>>>Fixes: 19b43a432e3e ("net/mlx5e: Extend SKB room check to include PTP-SQ")
>>
>>How big is the fifo? Not utilizing a single entry is not really worth
>>calling a bug if the fifo has at least 32 entries..
>
>AFAIK, it has the same size that any other SQ queue, up to 8192 
>entries for now.

I agree minimum size is 64, so not critical.


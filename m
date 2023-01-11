Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95FC4666543
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 22:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbjAKVFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 16:05:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231801AbjAKVE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 16:04:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F4D1158
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 13:03:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84FD461E53
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 21:03:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D88AC433EF;
        Wed, 11 Jan 2023 21:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673471023;
        bh=MCajAVLQnlfRcWDapC0cckaIUmaBeREbK/psS+9q8N8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U0WG/ERaKcismFvoTnJRiwpM5MqS9+N4GjluUyU5DJAJJrj0TVDcyVBJIO98DEbWs
         tyijmbKAMJwxOwyV4qYGftb3bdkL0faiWL5cri8Kd8fGwsxjtXZXRFr/cps5kPwYAJ
         FmYPd/sYQ1a+p+nTfZxpXMQom9uBxs8fB09ie96M+nUdomy9iNh7SHUYmbPGGHlgTs
         l7aP09OSEOzxewnw8YLpQ3Kdk+NyRGBCkGxw6Btz+r8PrY0NKMhuGL7QT0sDFcJr0s
         NOy1Ws/eiZHzU0x8+zxJ+6l0cY8DVfLjrFfoZct8M9J1ni3nOiC6833c2WNWbVdkr2
         njUf/nZxdOBJQ==
Date:   Wed, 11 Jan 2023 13:03:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: Re: [net-next 08/15] net/mlx5e: Add hairpin debugfs files
Message-ID: <20230111130342.6cef77d7@kernel.org>
In-Reply-To: <Y78gEBXP9BuMq09O@x130>
References: <20230111053045.413133-1-saeed@kernel.org>
        <20230111053045.413133-9-saeed@kernel.org>
        <20230111103422.102265b3@kernel.org>
        <Y78gEBXP9BuMq09O@x130>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Jan 2023 12:46:08 -0800 Saeed Mahameed wrote:
> On 11 Jan 10:34, Jakub Kicinski wrote:
> >On Tue, 10 Jan 2023 21:30:38 -0800 Saeed Mahameed wrote:  
> >> +	debugfs_create_file("hairpin_num_queues", 0644, tc->dfs_root,
> >> +			    &tc->hairpin_params, &fops_hairpin_queues);
> >> +	debugfs_create_file("hairpin_queue_size", 0644, tc->dfs_root,
> >> +			    &tc->hairpin_params, &fops_hairpin_queue_size);  
> >
> >debugfs should be read-only, please LMK if I'm missing something,
> >otherwise this series is getting reverted  
> 
> I remember asking you about this and you said it's ok to use write for
> debug features, this is needed for debugging performance bottlenecks.

FWIW I don't think this fits into the debug exemption. What I meant by
debug was stuff like write to configure what traces or debug features
of the chip are enabled. This falls into configuration, even if it's
not expected to be tweaked by users.

> hairpin + steering performance behaves differently between different
> hardware versions and under different NIC/E-Switch configs, so it's really
> important to have some control on some of these attributes when debugging.

Can you expand on the use of this params when debugging? AFAICT these
configure the RQ/SQ pairs (count and size) so really the only
"debugging" you can do here is change the config and see if it fixes
performance...

> Our dilemma was either to use devlink vendor params or a debug interface, 
> since we are pretty sure that our NIC hairpin implementation
> is unique as it uses software constructs (RQs/SQs) managed internally
> by Firmware for abstraction of a TC redirect action, thus the only place
> for this is either devlink vendor params or debugfs, we chose debugfs since
> we want to keep this for debug purposes on production systems.
> 
> we also considered extending TC but again since this is unique to CX
> architecture of the current chips, we didn't want to pollute TC.
> 
> Also devlink resource wasn't a good match since these resources don't
> exist until a TC redirect action is offloaded.
> 
> Please let me know what you think and whether this is acceptable by you.

I don't know of any other devices which need the hairpin setup 
so I won't push for a common API. But we *do* need to list these
tunables somewhere because my ability to grep them out of mlx5 when
another vendor comes with the same problem will be very limited.
Which is one of the reasons why devlink params have to be documented.
Plus IIRC you already have the EQ configuration via params.

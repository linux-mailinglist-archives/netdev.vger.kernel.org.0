Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8D04F8C54
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 05:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbiDHDSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 23:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233927AbiDHDSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 23:18:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92DC188577
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 20:16:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5488861D5C
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 03:16:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78AE4C385A4;
        Fri,  8 Apr 2022 03:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649387799;
        bh=ELeRB4SUY9zP9AOzaqaEIpiOIJ3Meieqn010mj9BZi0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MoIBDLs4Ygvgw7BhpjO6OmYdeJHdicttrDU7hR9Pzzv98IiZ9Wy9pVYj4To13BlTy
         IZnuNXz33l2sy5RtWwVn88DnSB7uXfS/V3kZLF4VO0jSwCxPTwM/jq3CV2cbd2XNW0
         vpVGTqYZkEfTk31GTGKQMlpQGmFlY78Sv0T+Y9ivwEfVSZqsTjDH7/YyDM5SufPtfd
         O2ChaWrCPuXh1Cn8kHFRW/WweWLc306kiHU3DpF8L7yiuaaS16W5JnxV2/1tP407XY
         sCeSdVEe3R0MZov87yl6luqe+aysUOUgqUATgCIKhPE/+7MIZ+CQdbkFQDF+1lTwTm
         3v0xoJ910z9ag==
Date:   Thu, 7 Apr 2022 20:16:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Guralnik <michaelgur@nvidia.com>
Cc:     <netdev@vger.kernel.org>, <jiri@nvidia.com>, <ariela@nvidia.com>,
        <maorg@nvidia.com>, <saeedm@nvidia.com>, <moshe@nvidia.com>
Subject: Re: [RFC PATCH net-next 0/2] devlink: Add port stats
Message-ID: <20220407201638.46e109d1@kernel.org>
In-Reply-To: <20220407084050.184989-1-michaelgur@nvidia.com>
References: <20220407084050.184989-1-michaelgur@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Apr 2022 11:40:48 +0300 Michael Guralnik wrote:
> This patch set adds port statistics to the devlink port object.
> It allows device drivers to dynamically attach and detach counters from a
> devlink port object.

The challenge in defining APIs for stats is not in how to wrap a free
form string in a netlink message but how do define values that have
clear semantics and are of value to the user.

Start from that, discuss what you have with the customer who requested
the feature. Then think about the API.

I have said this multiple times to multiple people on your team.

> The approach of adding object-attached statistics is already supported for trap
> with traffic statistics and for the dev object with reload statistics.

That's an entirely false comparison.

> For the port object, this will allow the device driver to expose and dynamicly
> control a set of metrics related to the port.
> Currently we add support only for counters, but later API extensions can be made
> to support histograms or configurable counters.
> 
> The statistics are exposed to the user with the port get command.
> 
> Example:
> # devlink -s port show
> pci/0000:00:0b.0/65535: type eth netdev eth1 flavour physical port 0 splittable false
>   stats:
>     counter1 235
>     counter2 18

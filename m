Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3AD63CEFF1
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 01:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352902AbhGSWtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 18:49:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358523AbhGSTsW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 15:48:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C5276109E;
        Mon, 19 Jul 2021 20:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626726541;
        bh=kBXee+brflaLe0t6ZlxZrXD08ISe59xEAGNE60i3ghk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=sOcSiK7uc0c3GX6bPRdC1rGXEPKCwwblC54f8qdXL57BbhXE0cydqTww8HjszL2au
         kaTeB5koH12qQdshfOKdg2Aob3dpQgQIjSg7tOR0i9kBndxPY+FkXpN+1h4Sh5aet/
         VPcyn0vf5ZTjix8z6LXJV1fbFVFRw7FirlhnvMEQ6fLgit9q72qpAdwmq+ktsw0RSi
         31hv4fktuqmN/Jmd1/UQyXNvymfWGPJxirnf0jW3Amz0u/1833TRkcj8D0OcR6XUjL
         f6kiXrh4WI/yto1vrYE03nP63u58ZrvKKTE2mfswEa4xg+kuT0HN3AqV7pCHn/tgTz
         h2pL79xjRHpag==
Message-ID: <24f5387bc2bec23627ea9cfaec4ed4e416c60510.camel@kernel.org>
Subject: Re: XDP applications running in driver mode on mlx5_core can't
 access various helper functions
From:   Saeed Mahameed <saeed@kernel.org>
To:     David Ramirez <davramir@fiu.edu>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Date:   Mon, 19 Jul 2021 13:29:00 -0700
In-Reply-To: <BN7PR05MB592314B791EB8654A59E8841CC129@BN7PR05MB5923.namprd05.prod.outlook.com>
References: <BN7PR05MB592314B791EB8654A59E8841CC129@BN7PR05MB5923.namprd05.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-07-15 at 13:59 +0000, David Ramirez wrote:
> Hey all,
> 
> I am having issues with calling some bpf helper functions
> when running my XDP program in driver on the mlx5_core driver.
> Several of the helpers I've tried to use for ringbuf and maps always
> return 0.
> While this may seem to imply that for functions that merely return
> null instead of
> a pointer in case of an error are working as intended,
> some functions which return negative on failure and 0 on success are
> are also affected,
> as while they return 0, they do not result in the desired effect.
> 
> Observed examples:
>  - bpf_ringbuf_output always returns 0, but no data is pushed to the
> ringbuf
>  - bpf_map_update_elem always returns 0, but the element is not
> updated
>  - bpf_ringbuf_reserve always returns 0
>  - bpf_map_lookup_elem always returns 0
>  
> I'm uncertain if this is a driver specific issue or an ebpf issue.

this is purely ebpf issue or user prog issue.
1. the ebpf program/helpers are agnostic to run mode, driver/native
v.s. skb/generic modes.
2. the above helpers are pure bpf callbacks, the driver is not
involved.

> Testing with xdp in driver mode on veth devices works as expected,
> which suggests this is more likely a driver issue.
> 

The driver or its implementation are not involved with the above
helpers, so further debug is required in the user prog or the helpers
logic themselves.

> Additional Details:
> 
> Linux Distro: Ubuntu 21.04
> Linux Kernel version: 5.11.0-18-generic
> driver: mlx5_core
> version: 5.11.0-18-generic
> 
> Thank you,
> David Ramirez



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90817680844
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 10:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235594AbjA3JMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 04:12:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236130AbjA3JMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 04:12:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6F99F
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 01:12:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD2A1B80C7B
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 09:12:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57E8C4339B;
        Mon, 30 Jan 2023 09:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675069933;
        bh=zzLTWopEGXdDYBa/wMQV5gC9XG2VUFl/cEOChSq8osk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B6puhhzjxXQtWfH4ChdrHVfxJ/OL+r5mXuYD5cYD/p8oyizc0ZkEDA7zPf+fcg/e2
         2X+sJUUb0ysNSLXlCZZ6DCMo/85wmCpJjKZlze3jGcENvpoJMr41pwb/7dwQOeMD2G
         5ORJw9fBXEdk8MFug5+n25bpXpxZza6Lm/tXWzDHC4MPn8p84yD9OJL3cNsaFLUXE4
         QJkMxYJSjGfMGcry8puJrlKH9hcJDoyWUKY/y2XCbkqyhyyFt3iPyalb1noE8E8kdy
         JWcj9nktLaWGE8uUBy5wAfGWwP9E+pWlgOmXDq2EB7h9vdJ25Hkg+raMskGsDxa710
         phZy5LPTI8rSg==
Date:   Mon, 30 Jan 2023 11:12:09 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, Dave Ertman <david.m.ertman@intel.com>,
        netdev@vger.kernel.org, Gurucharan G <gurucharanx.g@intel.com>
Subject: Re: [PATCH net v4 1/2] ice: Prevent set_channel from changing queues
 while RDMA active
Message-ID: <Y9eJ6TasOLEK/LYO@unreal>
References: <20230127225333.1534783-1-anthony.l.nguyen@intel.com>
 <20230127225333.1534783-2-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127225333.1534783-2-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 02:53:32PM -0800, Tony Nguyen wrote:
> From: Dave Ertman <david.m.ertman@intel.com>
> 
> The PF controls the set of queues that the RDMA auxiliary_driver requests
> resources from.  The set_channel command will alter that pool and trigger a
> reconfiguration of the VSI, which breaks RDMA functionality.
> 
> Prevent set_channel from executing when RDMA driver bound to auxiliary
> device.
> 
> Adding a locked variable to pass down the call chain to avoid double
> locking the device_lock.
> 
> Fixes: 348048e724a0 ("ice: Implement iidc operations")
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice.h         |  2 +-
>  drivers/net/ethernet/intel/ice/ice_dcb_lib.c | 23 +++++++++-------
>  drivers/net/ethernet/intel/ice/ice_dcb_lib.h |  4 +--
>  drivers/net/ethernet/intel/ice/ice_ethtool.c | 28 +++++++++++++++++---
>  drivers/net/ethernet/intel/ice/ice_main.c    |  5 ++--
>  5 files changed, 43 insertions(+), 19 deletions(-)

Honestly, it looks horrid to see holding two locks and "locked"
parameter just to send an event to AUX driver.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

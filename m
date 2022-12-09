Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A004647B63
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 02:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbiLIBZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 20:25:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbiLIBYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 20:24:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC28801C9
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 17:24:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32C27B826CD
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 01:24:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4EB8C433EF;
        Fri,  9 Dec 2022 01:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670549064;
        bh=BEYP4XxTC8bVZOysNK3+PQyW5SWU+1e9Fg55C8a+q80=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qfkSDgB338lCMwPdMwSGYCR8YzwNodZaDvJO/rB/eMPJCrYqPUts8SVDUHqTmnLSo
         7SmrdQijsDTIKkzSjLzqSYoWfE/y9B17poR48wQad9BT6zcJGcJ511Ak2f5KytnZUF
         9dyI8ZWYBf1Rv5kd1d8Ueu2Fi44xuCSjEJjguz+ExnQMmWOPy0hhwYC0qA+x+DFBon
         YIlO37zKso+GolwDqpcZYDCm+OpK1noPBZL64KjmV9ZN5GYEtQpVhYq5HKs6b7Pzp4
         l3pXDuxCaQbckfaTSRd0wFNqZezEzt3b5wmoimfku0OtwHPHDG95eSJmHQf5i/Vv7f
         i0VeX9a02ykKQ==
Date:   Thu, 8 Dec 2022 17:24:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Shannon Nelson <shannon.nelson@amd.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <jiri@nvidia.com>
Subject: Re: [PATCH net-next 1/2] devlink: add fw bank select parameter
Message-ID: <20221208172422.37423144@kernel.org>
In-Reply-To: <d194be5e-886b-d69b-7d8d-3894354abe7f@intel.com>
References: <20221205172627.44943-1-shannon.nelson@amd.com>
        <20221205172627.44943-2-shannon.nelson@amd.com>
        <20221206174136.19af0e7e@kernel.org>
        <7206bdc8-8d45-5e2d-f84d-d741deb6073e@amd.com>
        <20221207163651.37ff316a@kernel.org>
        <06865416-5094-e34f-d031-fa7d8b96ed9b@amd.com>
        <d194be5e-886b-d69b-7d8d-3894354abe7f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75 autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 8 Dec 2022 16:47:31 -0800 Jacob Keller wrote:
> This is what I was thinking of and looks good to me. As for how to add 
> attributes to get us from the current netlink API to this, I'm not 100% 
> sure.
> 
> I think we can mostly just add the bank ID and flags to indicate which 
> one is active and which one will be programmed next.

Why flags, tho?

The current nesting is:

  DEVLINK_ATTR_INFO_DRIVER_NAME		[str]
  DEVLINK_ATTR_INFO_SERIAL_NUMBER	[str]
  DEVLINK_ATTR_INFO_BOARD_SERIAL_NUMBER	[str]

  DEVLINK_ATTR_INFO_VERSION_FIXED	[nest] // multiple VERSION_* nests follow
    DEVLINK_ATTR_INFO_VERSION_NAME	[str]
    DEVLINK_ATTR_INFO_VERSION_VALUE	[str]
  DEVLINK_ATTR_INFO_VERSION_FIXED	[nest]
    DEVLINK_ATTR_INFO_VERSION_NAME	[str]
    DEVLINK_ATTR_INFO_VERSION_VALUE	[str]
  DEVLINK_ATTR_INFO_VERSION_RUNNING	[nest]
    DEVLINK_ATTR_INFO_VERSION_NAME	[str]
    DEVLINK_ATTR_INFO_VERSION_VALUE	[str]
  DEVLINK_ATTR_INFO_VERSION_RUNNING	[nest]
    DEVLINK_ATTR_INFO_VERSION_NAME	[str]
    DEVLINK_ATTR_INFO_VERSION_VALUE	[str]


Now we'd throw the bank into the nests, and add root attrs for the
current / flash / active as top level attrs:

  DEVLINK_ATTR_INFO_DRIVER_NAME		[str]
  DEVLINK_ATTR_INFO_SERIAL_NUMBER	[str]
  DEVLINK_ATTR_INFO_BOARD_SERIAL_NUMBER	[str]
  DEVLINK_ATTR_INFO_BANK_ACTIVE		[u32] // << optional
  DEVLINK_ATTR_INFO_BANK_UPDATE_TGT	[u32] // << optional

  DEVLINK_ATTR_INFO_VERSION_FIXED	[nest] // multiple VERSION_* nests follow
    DEVLINK_ATTR_INFO_VERSION_NAME	[str]
    DEVLINK_ATTR_INFO_VERSION_VALUE	[str]
  DEVLINK_ATTR_INFO_VERSION_FIXED	[nest]
    DEVLINK_ATTR_INFO_VERSION_NAME	[str]
    DEVLINK_ATTR_INFO_VERSION_VALUE	[str]
  DEVLINK_ATTR_INFO_VERSION_RUNNING	[nest]
    DEVLINK_ATTR_INFO_VERSION_NAME	[str]
    DEVLINK_ATTR_INFO_VERSION_VALUE	[str]
  DEVLINK_ATTR_INFO_VERSION_RUNNING	[nest]
    DEVLINK_ATTR_INFO_VERSION_NAME	[str]
    DEVLINK_ATTR_INFO_VERSION_VALUE	[str]
  DEVLINK_ATTR_INFO_VERSION_STORED	[nest]
    DEVLINK_ATTR_INFO_VERSION_NAME	[str]
    DEVLINK_ATTR_INFO_VERSION_VALUE	[str]
    DEVLINK_ATTR_INFO_VERSION_BANK	[u32] // << optional
  DEVLINK_ATTR_INFO_VERSION_STORED	[nest]
    DEVLINK_ATTR_INFO_VERSION_NAME	[str]
    DEVLINK_ATTR_INFO_VERSION_VALUE     [str]
    DEVLINK_ATTR_INFO_VERSION_BANK	[u32] // << optional

> I think we could also add a new attribute to both reload and flash which 
> specify which bank to use. For flash, this would be which bank to 
> program, and for update this would be which bank to load the firmware 
> from when doing a "fw_activate".

SG!

> Is that reasonable? Do you still need a permanent "use this bank by 
> default" parameter as well?

I hope we cover all cases, so no param needed?

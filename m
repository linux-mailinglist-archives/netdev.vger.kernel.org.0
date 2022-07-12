Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67D2457108E
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 05:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiGLDEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 23:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiGLDEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 23:04:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5559920F66
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 20:03:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3179B81642
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:03:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68119C34115;
        Tue, 12 Jul 2022 03:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657595036;
        bh=g7d2hk6bD5VJY38m2WJkmo/TNZdGh+08QeBLBE9lyWI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Su4GjR2ZFyOSbsIorwjTkUJuNkhDUxSqCYIHldb0ps6dKJFCdq4T3gBiVCGh0Mvmi
         47nwmG1p9SceFK0oU+o8hojt3zuieykJ/58ioTqYSWIeihouXdHW2jQ+Wckf1za52Z
         b/RjsBy2vCRzSEkbU1esZv8ntZbE9cJeqUMP9jyPnx52FPL/LoXShaGUwNTZIgR4If
         gk6zq8PVLigektl4kghHUZBXMCsBrmpFq+nNZeh0hDZVSs/TnthpjiC11ZZ6jWBPFu
         6pTQqde8GPhWSEW9/AI+OBaeHSUoGO3cYJQQLnz0n87yJXe9beZYDJ6ERf/KQVpNZH
         4VACtZo+s4guQ==
Date:   Mon, 11 Jul 2022 20:03:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/9] mlx5 devlink mutex removal part 1
Message-ID: <20220711200355.57a9c3da@kernel.org>
In-Reply-To: <20220711081408.69452-1-saeed@kernel.org>
References: <20220711081408.69452-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Jul 2022 01:13:59 -0700 Saeed Mahameed wrote:
> 1) Fix devlink lock in mlx5 devlink eswitch callbacks
> 
> Following the commit 14e426bf1a4d "devlink: hold the instance lock
> during eswitch_mode callbacks" which takes devlink instance lock for all
> devlink eswitch callbacks and adds a temporary workaround, this patchset
> removes the workaround, replaces devlink API functions by devl_ API
> where called from mlx5 driver eswitch callbacks flows and adds devlink
> instance lock in other driver's path that leads to these functions.
> While moving to devl_ API the patchset removes part of the devlink API
> functions which mlx5 was the last one to use and so not used by any
> driver now.
> 
> The patchset also remove DEVLINK_NL_FLAG_NO_LOCK flag from the callbacks
> of port_new/port which are called only from mlx5 driver and the already
> locked by the patchset as parallel paths to the eswitch callbacks using
> devl_ API functions.
> 
> This patchset will be followed by another patchset that will remove
> DEVLINK_NL_FLAG_NO_LOCK flag from devlink reload and devlink health
> callbacks. Thus we will have all devlink callbacks locked and it will
> pave the way to remove devlink mutex.

Acked-by: Jakub Kicinski <kuba@kernel.org>

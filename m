Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46BFC6308F7
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 02:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233706AbiKSB57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 20:57:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233765AbiKSB5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 20:57:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD868B30
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 17:48:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 743FEB825D8
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 01:48:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D86CC433C1;
        Sat, 19 Nov 2022 01:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668822505;
        bh=VzDrer0bz+FZpawMXS8PurXbPmdnniOqJP03qNEGsdY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R7zukn6QOqBHEedtwmT6qGdt51qE63QFCoT4qJ5LAiOLA7fPrQJNsUb/WRu2OU14c
         zDvdvYr/vDI1PvajkQISkzp4VZJQCyQKk8HIDbyZE6l75vXLa6nB8KywVvQXCrVCzx
         NOIu8MlPgXelzSWgmI/xm5sxX2rCGsbbQp7OVrWwne/VAXmz2+IuV0Xh0wUEuWPdrM
         Xpwd7EqTsdre90maf7KXtcwT0/aW/V+vE8nlMv9yBHhHPhjgBgEVymdPpnPB7XWd5/
         LWKcc9WwmSWQkq6BoE2iRYIpGKM60XaFiXqDq8B+UqX4iyY0kC5WUsHIHZHSuca9cf
         UtVBf4oDTa7jA==
Date:   Fri, 18 Nov 2022 17:48:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next 5/8] devlink: refactor
 region_read_snapshot_fill to use a callback function
Message-ID: <20221118174824.513e15d8@kernel.org>
In-Reply-To: <20221117220803.2773887-6-jacob.e.keller@intel.com>
References: <20221117220803.2773887-1-jacob.e.keller@intel.com>
        <20221117220803.2773887-6-jacob.e.keller@intel.com>
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

On Thu, 17 Nov 2022 14:08:00 -0800 Jacob Keller wrote:
> +	/* Allocate and re-use a single buffer */
> +	data = kzalloc(DEVLINK_REGION_READ_CHUNK_SIZE, GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;

Why zalloc? If we expect drivers may underfill we should let them
return actual length.


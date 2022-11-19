Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5C446308FC
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 02:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbiKSB6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 20:58:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233511AbiKSB56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 20:57:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C75609FF2
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 17:49:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 525A462762
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 01:49:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8980EC433D6;
        Sat, 19 Nov 2022 01:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668822598;
        bh=dGHTvDB6EWcD//eljOzunEgw/G3LOla2CtV1gzVJYC8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EhF6TL/7EXiGuAdGPtQZCJalz95HpAHOle+gwL8OwfNeEds7zdOWYGizAnbTo/m24
         jU5aR5bzLfCWcuMt15/UVcGZLBBJC1cWJeMQ/6NpP30AaaB7N4CLLtzHzDZKCoWzGA
         rzTKxSX7qNxc16Du+WQmnROrQA/PMC1egSElPvu6Zvf1nD6ayadUVxA52abKsYkKVq
         RjcHgo6FD3aGZWOdEzCjTjxo4M6KmIjZ4UinQBy8bVaQaUbR2kEkJ1DbIFb/Mn4B09
         Umd6n9b20yHdrBQkZhEq4p39+NzsR1cRlghtUjR87cI17IgkCX9+LIUSa2kB+At2En
         86AaLph+vdcQA==
Date:   Fri, 18 Nov 2022 17:49:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next 6/8] devlink: support directly reading from
 region memory
Message-ID: <20221118174957.7c672c75@kernel.org>
In-Reply-To: <20221117220803.2773887-7-jacob.e.keller@intel.com>
References: <20221117220803.2773887-1-jacob.e.keller@intel.com>
        <20221117220803.2773887-7-jacob.e.keller@intel.com>
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

On Thu, 17 Nov 2022 14:08:01 -0800 Jacob Keller wrote:
> +Regions may optionally allow directly reading from their contents without a
> +snapshot. A driver wishing to enable this for a region should implement the
> +``.read`` callback in the ``devlink_region_ops`` structure.

Perhaps worth adding that direct read has weaker atomicity guarantees
than snapshot? User at the CLI level may not expect the read request
to be broken up into smaller chunks.

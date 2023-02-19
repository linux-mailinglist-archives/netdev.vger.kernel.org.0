Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDB3069BFED
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 11:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbjBSKLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 05:11:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjBSKLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 05:11:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A619510262
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 02:11:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F67160C11
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 10:11:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31A7C433D2;
        Sun, 19 Feb 2023 10:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676801509;
        bh=eE9lfpK3G1YJx17Pr2aCt9XNdhqKNuWTIPmuLuJv8iY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nIki6vln/yPargHen0u14zjo9CtKVrEFX5gSxzxh6ERsCnpNCyJpMbI8xsqnPU68W
         xcqceLUrpam99heDZgyrUkKme+jjoDBAZkgfNh9myJuZgqYBg2/vY2gmYuIw4I5Wii
         cb3sZT+xbsqSpSCWvAT63sN8Gzwcn1fIoaOAxJmCE4msUDOJxVIJN0FiuhrTpslBvP
         TSOA8Hrufo/dTLFWGLtekMFjwRBgtW8Qyjoteudz/6WrNetffXRMmyUeQ7WPoiAhBu
         c2cUZ7WYFBwZ2C79w/OGBczZsqVLVxxUcI6SmEdYaEpt4VScf7tt3nkhq0ZqX8huTA
         Nvk5OXwfVfDaA==
Date:   Sun, 19 Feb 2023 12:11:44 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io, brett.creeley@amd.com
Subject: Re: [PATCH v3 net-next 00/14] pds_core driver
Message-ID: <Y/H14ByDBPTA+yqg@unreal>
References: <20230217225558.19837-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217225558.19837-1-shannon.nelson@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 02:55:44PM -0800, Shannon Nelson wrote:
> Summary:
> --------
> This patchset implements new driver for use with the AMD/Pensando
> Distributed Services Card (DSC), intended to provide core configuration
> services through the auxiliary_bus for VFio and vDPA feature specific
> drivers.

Hi,

I didn't look very deeply to this series, but three things caught my
attention and IMHO they need to be changed/redesinged before someone
can consider to merge it.

1. Use of bus_register_notifier to communicate between auxiliary devices.
This whole concept makes aux logic in this driver looks horrid. The idea
of auxiliary bus is separate existing device to sub-devices, while every
such sub-device is controlled through relevant subsystem. Current
implementation challenges this assumption by inventing own logic.
2. devm_* interfaces. It is bad. Please don't use them in such a complex
driver.
3. Listen to PCI BOUND_DRIVER event can't be correct either.

Thanks

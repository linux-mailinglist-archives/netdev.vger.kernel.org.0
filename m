Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7419C4D9F75
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 16:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349885AbiCOP7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 11:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349877AbiCOP7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 11:59:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB77C4A3F9
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 08:58:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4875A6128E
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 15:58:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5489DC340EE;
        Tue, 15 Mar 2022 15:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647359910;
        bh=4ErQhCwA/6LL/dWP4zLfh3clRCW8n5F8aedaQ8LoEWI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VH0L2oN4SJdJszcWXyh+l/lne9UexBQNdUgr7AQcFMpzoC2TuSGrNFAA1UA1xXwEI
         EQJM0xVd1potnVcadi/RAsgigAXuvPEHqEuXuTs1dk31g4dFDwJjg8Ujr5slJ7sAOs
         eRImb57IhLgz3tsXFAQE3pfSHtR4c1hESeP9cb2v3qBxYz4kc28IyPWapoozVAcDPE
         YVl+GjVzIcf8AU+aVtYsoFmeS7NDJIHcf4NTbKqvp3fIF0YjdJQlgUxKEnJrtJsqjO
         579UFAcesZfUb8OlCAMJAu3i92DyklE++mTmQQz/CO9nSBTM1bjD20G4U2b4t+hn0F
         fUtsSPmvQmacw==
Date:   Tue, 15 Mar 2022 08:58:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leonro@nvidia.com>
Cc:     Ido Schimmel <idosch@idosch.org>, <idosch@nvidia.com>,
        <petrm@nvidia.com>, <simon.horman@corigine.com>,
        <netdev@vger.kernel.org>, <jiri@resnulli.us>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [RFT net-next 0/6] devlink: expose instance locking and
 simplify port splitting
Message-ID: <20220315085829.51d2fd5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YjBCs/uc+djgQRgH@unreal>
References: <20220310001632.470337-1-kuba@kernel.org>
        <Yim9aIeF8oHG59tG@shredder>
        <Yipp3sQewk9y0RVP@shredder>
        <20220314114645.5708bf90@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YjBCs/uc+djgQRgH@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Mar 2022 09:39:31 +0200 Leon Romanovsky wrote:
> > I have the eswitch mode conversion patches almost ready with the
> > "almost" being mlx5.   
> 
> I wonder why do you need to change eswitch locking in mlx5?

I want DEVLINK_CMD_ESWITCH_SET to drop the DEVLINK_NL_FLAG_NO_LOCK
marking.

Other drivers are rather simple in terms of locking (bnxt, nfp,
netdevsim) and I can replace driver locking completely with a few 
minor changes. Other drivers have no locking (insert cry/laugh emoji).

mlx5 has layers and multiple locks, if you're okay with devl_unlock() /
devl_lock() inside the callback that's perfect for me.

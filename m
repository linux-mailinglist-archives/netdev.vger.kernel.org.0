Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40B4D4D69A8
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 21:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbiCKUuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 15:50:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiCKUuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 15:50:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12FCF158E8B
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 12:49:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACB96B82D27
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 20:49:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050D6C340E9;
        Fri, 11 Mar 2022 20:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647031751;
        bh=FFYRdbkIHURE3PpvBE7FqfZbP3E+3QitH+hyHqoKbg4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y6Y2Me8bJfgy0lpjE2Rqfsh/AnTEYLaHF7FMh8oXWzwoaGVV+wIQxX6b4lHSN75Sh
         uAf81QwhlLJCRJ34HenMR/JX/+t7rEiqYxWd+TK1Xzik4Vv/mtFRpz+sLM5dNtsFLJ
         akxx3phxMxx6y6rw4LPOU27/x8+8FyZqjBuZV/5lAAQXnkrmR8o8zM98cslPDbknxA
         S932gzefOCnj9HWx+h4Y3bC0bigWZddAsE5beVqTooiGZRtRGqhiNs4sClHR1XCOuq
         XIToYubN7BqJUQRGIVU2HbNB3zcv1cTZpvsH4+41/3lEfQ+AR9sGNuYqD8XCeNZO8U
         PjvuW/Q3u+9Cw==
Date:   Fri, 11 Mar 2022 12:49:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
        Kiran Patil <kiran.patil@intel.com>, <netdev@vger.kernel.org>,
        <sudheer.mogilappagari@intel.com>, <amritha.nambiar@intel.com>,
        <jiri@nvidia.com>, <leonro@nvidia.com>,
        Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Subject: Re: [PATCH net-next 2/2] ice: Add inline flow director support for
 channels
Message-ID: <20220311124909.7112318a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <135a75f8-2da9-407b-40b2-b84ecb229110@intel.com>
References: <20220310231235.2721368-1-anthony.l.nguyen@intel.com>
        <20220310231235.2721368-3-anthony.l.nguyen@intel.com>
        <20220310203416.3b725bd2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <135a75f8-2da9-407b-40b2-b84ecb229110@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Mar 2022 12:36:55 -0600 Samudrala, Sridhar wrote:
> > Why is this in devlink and not ethtool?  
> 
> This is 16bit value with each bit representing a TC and is used to
> enable/disable inline flow director per queue group or TC.
> tc mqprio command allows creating upto 16 TCs.
> 
> My understanding is that ethtool parameters are per netedev or per-queue,
> but we don't have good way to configure per-queue_group parameters
> via ethtool. So we went with devlink.

ethtool has RSS context which is what you should use.
I presume you used TCs because it's a quick shortcut for getting
rate control?

> > All devlink params must be clearly documented.  
> 
> Based on the discussion in the other thread, we will make this a
> devlink parameter that is registered at probe time
>     https://lore.kernel.org/netdev/Yit3sLq6b+ZNZ07j@unreal/
> Will add documentation in the next revision.
> Hope this is OK.

It is not. Please tell everyone at intel that ramming features
thru devlink params is not welcome. You would know that if you
read the mailing list but I guess that's asking too much :/

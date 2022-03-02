Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0D84CAEF8
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 20:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238298AbiCBTpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 14:45:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbiCBTpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 14:45:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA457CD334;
        Wed,  2 Mar 2022 11:45:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 662C8616C6;
        Wed,  2 Mar 2022 19:45:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714A1C004E1;
        Wed,  2 Mar 2022 19:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646250304;
        bh=1W/G4/AiFxRCl9GMpz3PEUfvGAV1r8A7+I72k72aDdU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LOrsfp1lINN8sGYqwTHS57Iq/BOYxs/XVd2zbP7LBOSfsU1mJNtFAA9n6qlTYEG0y
         oGWTkH0b2qhuIV8TwOkxmaoDgrdm6/6AkmRLjptS3ozzQ2P6sDQ21tVh2TB8XLZC2Y
         wyMVl11P/V3IYIDiGpfqE0c8lxakFHzNiv9xNfRsxUb4dLf3vdhA2jcBuE77YrPjZZ
         OjE/Qn6+Zzjfg+sy5cy3CIQBH31sjOjEm45Q1cx6AYf+uoup+A0jRjE1Junjtzsciw
         X47z10hzkDGXDMzz+2r1KYyiDS0a6dVksYcBph7iC+qxuAM+aCQevhY5/ZJkcrLFlD
         QOcSZzAtgjISw==
Date:   Wed, 2 Mar 2022 11:45:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     kernel test robot <lkp@intel.com>
Cc:     Dust Li <dust.li@linux.alibaba.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>, davem@davemloft.net,
        kbuild-all@lists.01.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next] net/smc: fix compile warning for smc_sysctl
Message-ID: <20220302114503.47d64a55@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <202203022234.AMB3WcyJ-lkp@intel.com>
References: <20220302034312.31168-1-dust.li@linux.alibaba.com>
        <202203022234.AMB3WcyJ-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Mar 2022 23:02:23 +0800 kernel test robot wrote:
>    In file included from net/smc/smc_sysctl.c:18:
>    net/smc/smc_sysctl.h:23:19: note: previous definition of 'smc_sysctl_init' with type 'int(void)'
>       23 | static inline int smc_sysctl_init(void)
>          |                   ^~~~~~~~~~~~~~~
> >> net/smc/smc_sysctl.c:78:1: warning: ignoring attribute 'noinline' because it conflicts with attribute 'gnu_inline' [-Wattributes]  
>       78 | {
>          | ^

The __net_init / __net_exit attr has to go on the prototype as well.

This doesn't look right, tho, why __net_* attrs?  You call those
functions from the module init/exit. __net_ is for namespace code.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1B196094C1
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 18:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbiJWQim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 12:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiJWQij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 12:38:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 070A21D646
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 09:38:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EF9B60C05
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 16:38:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27242C433D6;
        Sun, 23 Oct 2022 16:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666543118;
        bh=FSRDRfFlGGlPIzaQwJERVcJaJvHEUxttTLK/bXfvGzw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TrOUOd9cW0YfCyZJsn/DimqRo4mdE4yhp+WHomBhcDEJe+s8cXw0e4rd8N+3UPJrW
         jtqFNSh6q9rwV7cW53+DZ7CCU6wJJIjky8nwuXD7FVzgOWlB/t/6Hk4o1kVKxxrmcu
         7UAIoHaIDvMT8F+pKUlM1xuAu4xzOhATHYye9PwmkAdFllTDGXHEe3GQtplQsxm753
         A2/w4gffsGsSv+CLdv3NOJWAMhNQXYuuAgGoKv8ThyRg/yCt9eSeEWQiDBA2pBJ+zt
         6lsH2PX0LEIHgsg/k6T/si1uDjkTxRFgaG5PRb6K8qDd9evyBzpaT+bky40uMrSQVH
         9x87brIAGRZ+w==
Date:   Sun, 23 Oct 2022 19:38:33 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Slawomir Laba <slawomirx.laba@intel.com>,
        Michal Jaron <michalx.jaron@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: Re: [PATCH net] i40e: Fix ethtool rx-flow-hash setting for X722
Message-ID: <Y1VuCYixOEqWgBdc@unreal>
References: <20221021213819.3958289-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021213819.3958289-1-jacob.e.keller@intel.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 21, 2022 at 02:38:19PM -0700, Jacob Keller wrote:
> From: Slawomir Laba <slawomirx.laba@intel.com>
> 
> When enabling flow type for RSS hash via ethtool:
> 
> ethtool -N $pf rx-flow-hash tcp4|tcp6|udp4|udp6 s|d
> 
> the driver would fail to setup this setting on X722
> device since it was using the mask on the register
> dedicated for X710 devices.
> 
> Apply a different mask on the register when setting the
> RSS hash for the X722 device.
> 
> When displaying the flow types enabled via ethtool:
> 
> ethtool -n $pf rx-flow-hash tcp4|tcp6|udp4|udp6
> 
> the driver would print wrong values for X722 device.
> 
> Fix this issue by testing masks for X722 device in
> i40e_get_rss_hash_opts function.
> 
> Fixes: eb0dd6e4a3b3 ("i40e: Allow RSS Hash set with less than four parameters")
> Signed-off-by: Slawomir Laba <slawomirx.laba@intel.com>
> Signed-off-by: Michal Jaron <michalx.jaron@intel.com>
> Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
> Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
> ---

Jacob,

I don't see your SOB here.

Thanks

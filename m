Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76FB65159AA
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 03:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382014AbiD3BuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 21:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239100AbiD3BuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 21:50:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12F414016;
        Fri, 29 Apr 2022 18:46:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6413BB8387A;
        Sat, 30 Apr 2022 01:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C941C385DC;
        Sat, 30 Apr 2022 01:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651283198;
        bh=8kP/MRpm1KKd3Rl9molXNCPZpQsRev4DC366b3abSJg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FHOkqeeY341VJtIRkHZ/wFD9kpmdQmlxFxvjQmxtTGNiHWWFY2WQDyFuUj7xUn0QX
         aa/G+NaZUzfDfYHjIAs+OSETdfW/RThbzraDlNwj81q9LCVO+Ees3IArkGIUur/1Vc
         mVVFGhaTZovAp7DMr+7+DBRXjNhZzbZI03Lwx6rbZQEBl938YpGI9ajnlftd03djV/
         i1xar24F3qGUJk01ngzu37vgE7T28CzHWhJCXc4Imryd5zQEAgwhY7J5nr9T2W3BFd
         IO/XANqI4YZfboz5VJuZFqcrpo+s0KS+9P6Rr9g2E3e5ycbVZseLZz2zFMvwdustxP
         EBzhOSMg3KlpA==
Date:   Fri, 29 Apr 2022 18:46:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
Cc:     netdev@vger.kernel.org, outreachy@lists.linux.dev,
        roopa@nvidia.com, jdenham@redhat.com, sbrivio@redhat.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, pabeni@redhat.com, vladimir.oltean@nxp.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        shshaikh@marvell.com, manishc@marvell.com, razor@blackwall.org,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, GR-Linux-NIC-Dev@marvell.com,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next v5 1/2] rtnetlink: add extack support in fdb
 del handlers
Message-ID: <20220429184636.0b869ae7@kernel.org>
In-Reply-To: <26815b6deebef7f02e864ca41714533c7009e7b7.1651236082.git.eng.alaamohamedsoliman.am@gmail.com>
References: <cover.1651236081.git.eng.alaamohamedsoliman.am@gmail.com>
        <26815b6deebef7f02e864ca41714533c7009e7b7.1651236082.git.eng.alaamohamedsoliman.am@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Apr 2022 14:49:06 +0200 Alaa Mohamed wrote:
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
> index fde839ef0613..3fccac358198 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -5678,7 +5678,7 @@ ice_fdb_add(struct ndmsg *ndm, struct nlattr __always_unused *tb[],
>  static int
>  ice_fdb_del(struct ndmsg *ndm, __always_unused struct nlattr *tb[],
>  	    struct net_device *dev, const unsigned char *addr,
> -	    __always_unused u16 vid)
> +	    __always_unused u16 vid, struct netlink_ext_ack *extack)

You need to update the kdoc on this one.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B19B61A4DB
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 23:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbiKDWwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 18:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbiKDWvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 18:51:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298C94B9AF;
        Fri,  4 Nov 2022 15:48:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B91B662365;
        Fri,  4 Nov 2022 22:48:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D313C433C1;
        Fri,  4 Nov 2022 22:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667602091;
        bh=bqV/vszFeBDsONkoSz/IwUrRhBqKQlBIMsG1jNqmdtM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YZsRN0TFyDcszgT4fq/V9blHS7nDEmG8ozFrrQgBSC29lwI3YtwsyDOz0AoJfWd2u
         WN81pmcGCiOercsVzUh7qzywCuQwlbDTkt87OXHD0sEFotpLynAR1fQKVKBR/Y5Yc0
         mjmYjjRf9kCqBpWQqFqaO5SMPkLChSR41ExsTgGc2y1ii0LT3ktS/Z13NsfwMBYtiQ
         3U/ucX3HhXW50GXF+c0filSvc/HuFld10F5Y8iBkdUXkPmNIMoq29igs5R1TK54/Gz
         7QrWvLdhkO5t2WpthCYsq89nw+evHaMtT9EkXrJhuFNHW5dQJgvTb0wjZWwQs+hnUJ
         oyd6fZjXTo7ig==
Date:   Fri, 4 Nov 2022 15:48:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, Florian Fainelli <f.fainelli@gmail.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andrew Lunn <andrew@lunn.ch>, corbet@lwn.net,
        hkallweit1@gmail.com, huangguangbin2@huawei.com,
        chenhao288@hisilicon.com, moshet@nvidia.com,
        linux@rempel-privat.de, linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next v5] ethtool: linkstate: add a statistic for PHY
 down events
Message-ID: <20221104154809.671ac378@kernel.org>
In-Reply-To: <Y2VzoD5uwW64yYgD@shell.armlinux.org.uk>
References: <20221104190125.684910-1-kuba@kernel.org>
        <Y2VzoD5uwW64yYgD@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Nov 2022 20:18:40 +0000 Russell King (Oracle) wrote:
> I guess we'll need phylink to support this as well, so phylink using
> drivers can provide this statistic not only for phylib based PHYs, but
> also for direct SFP connections as well.
> 
> Thinking about the complexities of copper SFPs that may contain a PHY,
> it seems to me that the sensible implementation would be for phylink
> to keep the counter and not use the phylib counter (as that PHY may
> be re-plugged and thus the count can reset back to zero) which I
> suspect userspace would not be prepared for.

Makes sense, having the counter go back on a netdev could be highly
confusing for local detection.

How would you like to proceed? I can try to take a stab at a phylink
implementation but a stab it will be. 

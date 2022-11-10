Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBDC624DAB
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 23:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbiKJWeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 17:34:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiKJWeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 17:34:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18EE0B87B
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 14:34:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD8C7B823C0
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 22:34:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 172C5C433C1;
        Thu, 10 Nov 2022 22:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668119654;
        bh=/LBO/Ecl/HBHUQekg90BnBlHjLR8MIB4sQs4U/vL0OM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HiPN62IW1tjUAKmutyq4u/G8QBlheUwPxS/xwshRQiIDKYGd4K30PaUsX1t9vbI/m
         zvKYb7YEwlZ1+ojPhnZJvHz4Qv8xz/RqACzdUoZOSdOjM/3OexZFFto9FY8rEif2Jd
         mYqUnaOw2lFBhNpdlKqXLuC7SNNBIDi7q1t2D7Fa3l7YwC9ujq1HOR1LfdeyN8Qxo9
         kJbWflFBw7f4ZWt/tdwzWBLsjlxnkV6ZaMB2qw4GiOtvZvuNRk47NY52ojNofgXukX
         /JupD633byhH2u1568kgh4Sm7g4XLUlp9iOlEUa3RVgZuKTynSQ5LqmPmSIJr4txJp
         4DFzV9KuGjlSg==
Date:   Thu, 10 Nov 2022 14:34:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc:     "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH net-next v2] ethtool: add netlink based get rxfh support
Message-ID: <20221110143413.58f107c2@kernel.org>
In-Reply-To: <eba940d8-a2da-9a7e-2802-fbac680b7df6@intel.com>
References: <20221104234244.242527-1-sudheer.mogilappagari@intel.com>
        <20221107182549.278e0d7a@kernel.org>
        <IA1PR11MB626686775A30F79E8AE85905E4019@IA1PR11MB6266.namprd11.prod.outlook.com>
        <20221109164603.1fd508ca@kernel.org>
        <eba940d8-a2da-9a7e-2802-fbac680b7df6@intel.com>
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

On Thu, 10 Nov 2022 16:08:04 -0600 Samudrala, Sridhar wrote:
> Can we use QGRP as a prefix to indicate that these are per-queue group parameters
> and not restricted to RSS related parameters?
> 
>    QGRP_CONTEXT
>    QGRP_RSS_HFUNC
>    QGRP_RSS_KEY
>    QGRP_RSS_INDIR_TABLE
> 
> In future, we would like to add per-queue group parameters like
>    QGRP_INLINE_FLOW_STEERING (Round robin flow steering of TCP flows)

The RSS context thing is a pretty shallow abstraction, I don't think we
should be extending it into "queue groups" or whatnot. We'll probably
need some devlink objects at some point (rate configuration?) and
locking order is devlink > rtnl, so spawning things from within ethtool
will be a pain :S

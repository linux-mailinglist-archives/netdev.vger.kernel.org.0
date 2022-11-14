Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9576286C9
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 18:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237620AbiKNRQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 12:16:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237497AbiKNRQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 12:16:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF8420376
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 09:16:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F985B810A3
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 17:16:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE87C433C1;
        Mon, 14 Nov 2022 17:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668446160;
        bh=Z/7xDXK5TvTTm4rkGpf2Z2TUPofurbtfPZaYAOS9Mow=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kUPQxSoNKBwqDrd57VXNIGKAohpuH3zR8tLo6ROmwbKsQ82fm/poXpYkWdZyfVIuY
         VBbK0d2APAZniIonwf1y+uRRK0C+eLC+uXj8Gz+W5QgI92p3vM/g6N339pgMcAwagf
         TvXdJOJYXphIbIfUmyxNbGcRXBTnVVETZDA9lvEZQD5GV+Jmz9xpLdttIAiEhKxcjh
         BEYCMdiACG7J77bNxXOdebRA6OTRJWJJ3/2Dp55SJJzwYHiRJ5sT8NigvyhBIxHbtF
         pzh9yDOqCzM65i4cfdaqfaVly8J3RcAve/H1UG8GSDlSxsZBNkIesJ9N54Ggw4kyYS
         uZh9Dqh1dY4Cw==
Date:   Mon, 14 Nov 2022 09:15:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc:     "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH net-next v2] ethtool: add netlink based get rxfh support
Message-ID: <20221114091559.7e24c7de@kernel.org>
In-Reply-To: <c40e7ed0-1118-168b-7fdc-a833b461b918@intel.com>
References: <20221104234244.242527-1-sudheer.mogilappagari@intel.com>
        <20221107182549.278e0d7a@kernel.org>
        <IA1PR11MB626686775A30F79E8AE85905E4019@IA1PR11MB6266.namprd11.prod.outlook.com>
        <20221109164603.1fd508ca@kernel.org>
        <eba940d8-a2da-9a7e-2802-fbac680b7df6@intel.com>
        <20221110143413.58f107c2@kernel.org>
        <0402fc4f-21c9-eded-bed7-fd82a069ca70@intel.com>
        <20221110161257.35d37983@kernel.org>
        <c40e7ed0-1118-168b-7fdc-a833b461b918@intel.com>
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

On Sun, 13 Nov 2022 22:23:25 -0600 Samudrala, Sridhar wrote:
> > My worry is that if we go with a more broad name like
> > "queue group" someone may be mislead to adding controls
> > unrelated to flow <> queue assignment here.  
> 
> Later we would like to add a per queue-group parameter that would allow
> reducing/changing the number of napi pollers for a queue group from the default
> value equal to the number of queues in the queue group. Are you suggesting
> creating a queue-group object and use devlink API to configure such parameters
> for a queue-group?

I was thinking devlink because of scheduler/QoS and resource control.
For NAPI config not so sure, but either way RSS will not be a place 
for NAPI/IRQ config.

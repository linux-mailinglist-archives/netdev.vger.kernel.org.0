Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74171624EBD
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 01:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbiKKANC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 19:13:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbiKKANA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 19:13:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B539460EA1
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 16:12:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 410FB61E31
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 00:12:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA12C433D6;
        Fri, 11 Nov 2022 00:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668125578;
        bh=Sm3Z/+UMDK/gv1dO32aqux91pXL6Mt4ZNYwrr1Imvwc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p4Vq7thRFve+fCrLRIR3qrpWCRuF48jvTHkstUoAbhdDYGvIM+5z4fDTQH/HfidGs
         v5Y1pcf1Ox1RHcBnH9HU3rmGG6vWI1mEUfPH/v9kcb/lB1NKtmoOyuqeHRti8YI6b6
         jOv1Mu2B4gJYZwCnHliANVjRo5jut8hIOfoCvkvm5GJpEy+47G1r/+sw5YyeP1RH5x
         C2ngOqzz1DJEDXGzwDbkmhGuFDZxgrofHsaA3PH63ZsMXnmfu5Eh44erbXTdcrBC8M
         vaU2YT0U2goiCojI+7KY3QrXCJ3kcWjwmeo1TTZjPA45TFFwKxH2pnBkjZKE5xZ2ZD
         pDG5Je+CZX0Cw==
Date:   Thu, 10 Nov 2022 16:12:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc:     "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH net-next v2] ethtool: add netlink based get rxfh support
Message-ID: <20221110161257.35d37983@kernel.org>
In-Reply-To: <0402fc4f-21c9-eded-bed7-fd82a069ca70@intel.com>
References: <20221104234244.242527-1-sudheer.mogilappagari@intel.com>
        <20221107182549.278e0d7a@kernel.org>
        <IA1PR11MB626686775A30F79E8AE85905E4019@IA1PR11MB6266.namprd11.prod.outlook.com>
        <20221109164603.1fd508ca@kernel.org>
        <eba940d8-a2da-9a7e-2802-fbac680b7df6@intel.com>
        <20221110143413.58f107c2@kernel.org>
        <0402fc4f-21c9-eded-bed7-fd82a069ca70@intel.com>
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

On Thu, 10 Nov 2022 17:24:15 -0600 Samudrala, Sridhar wrote:
> > The RSS context thing is a pretty shallow abstraction, I don't think we
> > should be extending it into "queue groups" or whatnot. We'll probably
> > need some devlink objects at some point (rate configuration?) and
> > locking order is devlink > rtnl, so spawning things from within ethtool
> > will be a pain :S  
> 
> We are going this path of extending ethtool rss context interface to support
> per queue-group parameters based on this feedback.
>    https://lore.kernel.org/netdev/20220314131114.635d5acb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/
> 
> Per queue-group rate can already be configured when creating queue groups via
> tc-mpqrio interface using bw_rlimit parameters.

Right, but that's still just flow-director-y/hash-y thing?
Does the name RSS imply purely hash based distribution?

My worry is that if we go with a more broad name like
"queue group" someone may be mislead to adding controls 
unrelated to flow <> queue assignment here.

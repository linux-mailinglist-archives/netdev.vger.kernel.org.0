Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5BFD631686
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 22:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiKTVCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 16:02:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiKTVCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 16:02:22 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D8A27DCF
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 13:02:20 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 3C71222465;
        Sun, 20 Nov 2022 21:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1668978138; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RxKbu+qC1IYnBdBlnSnxMb1XpreJD9BYcgC9EF7cay8=;
        b=Ta5pxxm/+MCk2Xi2xCzxGLyRv27R05z1CRFwtIZWEePfSJbjk7+/gurSfsOdlkfrepkRpS
        g3YVK6fTF6H+D+hEhujlHS5dID9skHJu5LT7PonI6mR/K3UYryScwBpJvtyGMzkJqSqnCB
        LLpxGCyZFZDMz9xRyYjdlhSkcDKc5fw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1668978138;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RxKbu+qC1IYnBdBlnSnxMb1XpreJD9BYcgC9EF7cay8=;
        b=bToWfJPciosXaIgOX1AtC1KSXDcj37zXQ0SX2IHYNhw2TJOk8JmPMvTVBi+szQQYnh8iLu
        wuMeCZegcD3xn6BA==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id D319D2C143;
        Sun, 20 Nov 2022 21:02:17 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id AE13760401; Sun, 20 Nov 2022 22:02:17 +0100 (CET)
Date:   Sun, 20 Nov 2022 22:02:17 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>
Cc:     Francois Romieu <romieu@fr.zoreil.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH net-next v3] ethtool: add netlink based get rss support
Message-ID: <20221120210217.zcdmr47r6ck33cf4@lion.mk-sys.cz>
References: <20221116232554.310466-1-sudheer.mogilappagari@intel.com>
 <Y3dgpNASNn6pvT05@electric-eye.fr.zoreil.com>
 <IA1PR11MB6266E62A4F46CCE62C053451E40B9@IA1PR11MB6266.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <IA1PR11MB6266E62A4F46CCE62C053451E40B9@IA1PR11MB6266.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 20, 2022 at 08:40:19AM +0000, Mogilappagari, Sudheer wrote:
> > -----Original Message-----
> > From: Francois Romieu <romieu@fr.zoreil.com>
> > Subject: Re: [PATCH net-next v3] ethtool: add netlink based get rss
> > support
> > 
> > Sudheer Mogilappagari <sudheer.mogilappagari@intel.com> :
> > > Add netlink based support for "ethtool -x <dev> [context x]"
> > > command by implementing ETHTOOL_MSG_RSS_GET netlink message.
> > > This is equivalent to functionality provided via ETHTOOL_GRSSH
> >                                                    ^^^^^^^^^^^^^
> > Nit: s/ETHTOOL_GRSSH/ETHTOOL_GRXFH/
> > 
> 
> Hi Ueimor, 
> My observation is there is mix-up of names in current ioctl implementation where ethtool_get_rxfh() is called for ETHTOOL_GRSSH command. Since this implementation is for ETHTOOL_GRSSH ioctl, we are using RSS instead of RXFH as Jakub suggested earlier. Why do you think it should be ETHOOL_GRXFH ?
> 
> https://elixir.bootlin.com/linux/latest/source/net/ethtool/ioctl.c#L2916
> 
> 	case ETHTOOL_GRXFH:
> 		rc = ethtool_get_rxnfc(dev, ethcmd, useraddr);
> 
> 	case ETHTOOL_GRSSH:
> 		rc = ethtool_get_rxfh(dev, useraddr);
> 
> -Sudheer

The mapping between ioctl subcommand and netlink message types does not
have to be 1:1, new ioctl subcommands were often added just because the
structures passed via ioctl could not be extended. In this case,
ETHTOOL_MSG_RSS_GET would reimplement ETHTOOL_GRSSH as well as
ETHTOOL_GRXFHINDIR, and ETHTOOL_MSG_RSS_SET would reimplement
ETHTOOL_SRSSH as well as ETHTOOL_SRXFHINDIR.

It's IMHO clear that there should be a GET/SET pair of messages for RSS
hash configuration (ethtool -n rx-flow-hash) and one for RSS rule
configuration (ethtool -n rule).

That would leave us with two questions:

1. What to do with ETHTOOL_GRXRING? Can we use ETHTOOL_MSG_RINGS_GET as
it is? (I.e. should the count be always equal to rx + combined?) If not,
should we extend it or put the count into ETHTOOL_MSG_RSS_GET?

2. What would be the best way to handle creation and deletion of RSS
contexts? I guess either a separate message type or combining the
functionality into ETHTOOL_MSG_RSS_SET somehow (but surely not via some
magic values like it's done in ioctl).

Michal

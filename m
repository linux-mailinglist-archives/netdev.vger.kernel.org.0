Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75979645594
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 09:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiLGImq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 03:42:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiLGImo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 03:42:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5900811831
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 00:42:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBE8860B5C
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 08:42:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818E7C433D6;
        Wed,  7 Dec 2022 08:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670402563;
        bh=Z8I26HdwXwrL46lIBCvAfS8t1Fkz1ez9XuNjctW+Qac=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=icrz2/h/kAkISPfa56Kj71a2gvF+4qx8v0j/kaK3TZ3W9chfgjnaHZ3T2yDXEr6kc
         y3jY0hyxrl+75w4Q5vP/+s2ljeMSt7FdOjqSXLelmAwR3RcC1E3BzHBsVmuhGorrYz
         CdWKHbSgrvbwZbvMQUfUCfie+cCedCNSzN3AZr3GY09u9rIFBakg/9NvrdwVOJt3Uc
         PFDetUb3Ai05cX0SOSPzzbkYQSsnRA+MDe7Uu5+/izEi3iBegi5KXul71DsWbwBDP/
         cqDPecK28/TVbJcFzHK9BqysNkFPgTiVvUkSnEP/LhjxH5eRKqaX31w85JnbAlfT+N
         P0O6mB0+d1X1w==
Date:   Wed, 7 Dec 2022 10:42:38 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>,
        netdev@vger.kernel.org, andrew@lunn.ch, corbet@lwn.net,
        sridhar.samudrala@intel.com, anthony.l.nguyen@intel.com
Subject: Re: [PATCH net-next v7] ethtool: add netlink based get rss support
Message-ID: <Y5BR/n7/rqQ+q8gm@unreal>
References: <20221202002555.241580-1-sudheer.mogilappagari@intel.com>
 <Y4yPwR2vBSepDNE+@unreal>
 <20221204153850.42640ac2@kernel.org>
 <Y42hg4MsATH/07ED@unreal>
 <20221206161441.ziprba72sfydmjrk@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206161441.ziprba72sfydmjrk@lion.mk-sys.cz>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 05:14:41PM +0100, Michal Kubecek wrote:
> On Mon, Dec 05, 2022 at 09:45:07AM +0200, Leon Romanovsky wrote:
> > On Sun, Dec 04, 2022 at 03:38:50PM -0800, Jakub Kicinski wrote:
> > > Conversion to netlink stands on its own.
> > 
> > It doesn't answer on my question. The answer is "we do, just because
> > we can" is nice but doesn't remove my worries that such "future"
> > extension will work with real future feature. From my experience, many
> > UAPI designs without real use case in hand will require adaptions and
> > won't work out-of-box.
> > 
> > IMHO, it is the same sin as premature optimization.
> 
> Extensibility is likely the most obvious benefit of the netlink
> interface but it's not the only one, even without an immediate need to
> add a new feature, there are other benefits, e.g.
> 
>   - avoiding the inherently racy get/modify/set cycle

How? IMHO, it is achieved in netlink by holding relevant locks, it can
be rtnl lock or specific to that netlink interface lock (devl). You cam
and should have same locking protection for legacy flow as well.

>   - more detailed error reporting thanks to extack

This is extremely good argument. 

>   - notifications (ethtool --monitor)
> 
> And I'm pretty sure the list is not complete. Thus I believe converting
> the ioctl UAPI to netlink is useful even without waiting until we need
> to add new features that would require it.

Thanks

> 
> Michal

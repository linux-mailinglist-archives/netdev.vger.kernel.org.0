Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F11EC6423CE
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 08:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbiLEHpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 02:45:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbiLEHpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 02:45:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9D012761
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 23:45:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEB4D60F98
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 07:45:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47FC9C433C1;
        Mon,  5 Dec 2022 07:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670226312;
        bh=GvaD5zsBva7v2B+iqjF99NwdyBB2t465+NtpNiSq8b4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bXPHyOb04a7hp30NAlGMjZS+kprdpHDx+2Ua1v7MRt4bMistybV0ci0l9PwJOaU6p
         +QocxFncSAGABW4f+qWXa33LK9r+2/pbRo75frxJGc2+EOvwO+AigF5pqRFH1X6O+7
         1jAQNXcbUTmr5Sw+HEKPVSjx53nUgntdmnGoUg/xILecwzX8peBZqoLIjNbS+BZaBv
         7vzOOBbIX3jCKCkeBfDjuEx7oh51YGfffXJRDaWfA/1kwiqSmQyf09Ku3uxwJE3LE3
         i9e4CeYbsSCtN30SP/82k05GmXEhctME9OWsS6lsG4EmpPGgtoiRI0Gd+OVD7/w6XM
         omhnOPCRK2b1w==
Date:   Mon, 5 Dec 2022 09:45:07 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>,
        netdev@vger.kernel.org, mkubecek@suse.cz, andrew@lunn.ch,
        corbet@lwn.net, sridhar.samudrala@intel.com,
        anthony.l.nguyen@intel.com
Subject: Re: [PATCH net-next v7] ethtool: add netlink based get rss support
Message-ID: <Y42hg4MsATH/07ED@unreal>
References: <20221202002555.241580-1-sudheer.mogilappagari@intel.com>
 <Y4yPwR2vBSepDNE+@unreal>
 <20221204153850.42640ac2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221204153850.42640ac2@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 04, 2022 at 03:38:50PM -0800, Jakub Kicinski wrote:
> On Sun, 4 Dec 2022 14:17:05 +0200 Leon Romanovsky wrote:
> > On Thu, Dec 01, 2022 at 04:25:55PM -0800, Sudheer Mogilappagari wrote:
> > > Add netlink based support for "ethtool -x <dev> [context x]"
> > > command by implementing ETHTOOL_MSG_RSS_GET netlink message.
> > > This is equivalent to functionality provided via ETHTOOL_GRSSH
> > > in ioctl path. It sends RSS table, hash key and hash function
> > > of an interface to user space.
> > > 
> > > This patch implements existing functionality available
> > > in ioctl path and enables addition of new RSS context
> > > based parameters in future.  
> > 
> > But why do you do this conversion now? Was this "future" already
> > discussed on the ML?
> 
> Conversion to netlink stands on its own.

It doesn't answer on my question. The answer is "we do, just because we
can" is nice but doesn't remove my worries that such "future" extension
will work with real future feature. From my experience, many UAPI designs
without real use case in hand will require adaptions and won't work out-of-box.

IMHO, it is the same sin as premature optimization.

> 
> > > +	u8 *rss_config;
> > > +	int ret;  
> > 
> > <...>
> > 
> > > +		data->indir_table = (u32 *)rss_config;  
> > 
> > Please use correct type from the beginning.
> 
> There are two tables in this memory, the second one is u8.
> So one of them will need the cast, the code is fine AFAICT.

Right, I missed hkey.

Thanks

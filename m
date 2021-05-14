Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 347D8380864
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 13:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhENLYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 07:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbhENLYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 07:24:10 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C162C061574
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 04:22:59 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lhVuC-0092Aj-SY; Fri, 14 May 2021 13:22:56 +0200
Message-ID: <8e2a8567d79141f8f5cb180be656efb378dcfee8.camel@sipsolutions.net>
Subject: Re: [PATCH net-next] alx: use fine-grained locking instead of RTNL
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Nikolai Zhubr <zhubr.2@gmail.com>
Cc:     netdev@vger.kernel.org
Date:   Fri, 14 May 2021 13:22:56 +0200
In-Reply-To: <609E5817.8090000@gmail.com> (sfid-20210514_124949_830593_01576FC8)
References: <20210512121950.c93ce92d90b3.I085a905dea98ed1db7f023405860945ea3ac82d5@changeid>
         <609E5817.8090000@gmail.com> (sfid-20210514_124949_830593_01576FC8)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-05-14 at 13:59 +0300, Nikolai Zhubr wrote:
> Hi Johannes,
> 
> 12.05.2021 13:19, Johannes Berg:
> > In the alx driver, all locking depended on the RTNL, but
> [...]
> > @@ -232,7 +240,7 @@ static int alx_set_pauseparam(struct net_device *netdev,
> >   	if (pause->autoneg)
> >   		fc |= ALX_FC_ANEG;
> > 
> > -	ASSERT_RTNL();
> > +	mutex_lock(&alx->mtx);
> > 
> >   	/* restart auto-neg for auto-mode */
> >   	if (hw->adv_cfg&  ADVERTISED_Autoneg) {
> > @@ -254,6 +262,7 @@ static int alx_set_pauseparam(struct net_device *netdev,
> >   		alx_cfg_mac_flowcontrol(hw, fc);
> > 
> >   	hw->flowctrl = fc;
> > +	mutex_unlock(&alx->mtx);
> > 
> >   	return 0;
> >   }
> 
> Isn't this fragment missing a mutex_unlock(&alx->mtx) for the "return 
> err" codepath in the middle? I'm not sure, its like very suspicious, 
> please have a look.

I clearly missed it, somebody already picked up on it:

https://lore.kernel.org/r/20210514082405.91011-1-pulehui@huawei.com

johannes


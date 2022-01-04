Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5934845C7
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 17:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234103AbiADQHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 11:07:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233501AbiADQHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 11:07:37 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1C4C061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 08:07:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=XXVGZ/BgLrLhjwZ75h4eDhHflCypstRSBlRdwyIhLDc=;
        t=1641312456; x=1642522056; b=vzdmJLlA6KQCfqa2a2V6aI2tQ23Ze3DE/QtbsBAf5nBJ8gg
        UQdtWjdFOxlQiYAMmjQKRzHXh4MIeGdDGv5DyRw5nqLbJAtoWfnu/2ZJi6ITJFyvpNlmQvv48v+O8
        hHwCdMjHvxOvPXjlCI9Wxa05utKRE1JNKEDF3Kg/8oFo+Wrsun2jW67AI5OkvKaU/u1oO2gPtVYkQ
        EmL8CKSNw652Do1e0cuGN20gdccvTNOSgE66CpSuJ7/V9SLd4AvdkzyEbbwrbTAJGbi3ybl3UqiP/
        TUCNJrLFVr7KLq9puGYYus0kwvu02QfCtjssxBPQOyMP0m2vzkzgGewS/DIbc7ng==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1n4mLT-001oDa-5P;
        Tue, 04 Jan 2022 17:07:31 +0100
Message-ID: <c14b5872799b071145c79a78aab238884510f2a9.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 11/13] netlink: add net device refcount tracker
 to struct ethnl_req_info
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Date:   Tue, 04 Jan 2022 17:07:30 +0100
In-Reply-To: <CANn89i+yzt=Y_fgjYJb3VMYCn7aodFVRbZ9hUjb0e4+T+d14ww@mail.gmail.com>
References: <20211207013039.1868645-1-eric.dumazet@gmail.com>
         <20211207013039.1868645-12-eric.dumazet@gmail.com>
         <5836510f3ea87678e1a3bf6d9ff09c0e70942d13.camel@sipsolutions.net>
         <CANn89i+yzt=Y_fgjYJb3VMYCn7aodFVRbZ9hUjb0e4+T+d14ww@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

> > > @@ -624,6 +625,7 @@ static void ethnl_default_notify(struct net_device *dev, unsigned int cmd,
> > >       }
> > > 
> > >       req_info->dev = dev;
> > > +     netdev_tracker_alloc(dev, &req_info->dev_tracker, GFP_KERNEL);
> > >       req_info->flags |= ETHTOOL_FLAG_COMPACT_BITSETS;
> > > 
> > 
> > I may have missed a follow-up patch (did a search on netdev now, but
> > ...), but I'm hitting warnings from this and I'm not sure it's right?
> > 
> > This req_info is just allocated briefly and freed again, and I'm not
> > even sure there's a dev_get/dev_put involved here, I didn't see any?
> 
> We had a fix.
> 
> commit 34ac17ecbf575eb079094d44f1bd30c66897aa21
> Author: Eric Dumazet <edumazet@google.com>
> Date:   Tue Dec 14 00:42:30 2021 -0800
> 
>     ethtool: use ethnl_parse_header_dev_put()
> 

Hmm. I have this in my tree, and I don't think it affected
ethnl_default_notify() anyway?

johannes

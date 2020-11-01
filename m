Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 316252A1B9D
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 02:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbgKABhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 21:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726243AbgKABhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 21:37:31 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D545C0617A6
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 18:37:31 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id l16so10603381eds.3
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 18:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KHBl6NV8WXAvJo+tIpVUVsoiQEhodnzKJ+Hs90Hve6U=;
        b=XBEhfJzfObdl1CERY4BmjbK0sXeCVBcf/gPdOrPsjpoMfsC/GJrlXLftvBJ0AcePU5
         zjC0Hpe8h1KITJQL/F7gTF1IO2Ck9JHoyfCHDC37FFDnwqss3wzIy1OmCNZ2mx8yyWfp
         6C1biChkHSTz2oOZ0QWVSmr/5cVFvRIz0Ct+KDZT5IvVPirX4ET1rWNtP5pd40WiIZ9E
         qcwguL8vECckfa+oqR8tdI/BnygZAAFHWU+8qOxc2UfdWf9DGO6srjQTkgk8rb3ZV2BF
         d2txUvyziY4rrXdPwTzRPpkrkSiWVcntEtfRQWLlEoSKEoS0ieBTZ4bknWv8S+TsW7/t
         WjqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KHBl6NV8WXAvJo+tIpVUVsoiQEhodnzKJ+Hs90Hve6U=;
        b=HIOUfL8iogAPhw6i1ti3oWgJ8zcqg2XIl/N4jp9Q5cMN2uvhtMSvwxI7BRkHaxZ/E/
         ZX+yGKC/NzUDI9AvLNSJ6yiGb5UHt7JbHzCssVCF4P0H4Sf2vZFGApMglMhF+N88WXEK
         UMM+pzTa6tAjRziDJnLPu8zsmAagx8oB8qMDQqF1g7cxB2s6jXvttRO+nuMgXebNxWVe
         6qo4SzslLiYq12r+XIfahkIfldek1BoP75Xxkejy5xidSizLMjb1DCbVZpJ2Lq564K2p
         Sd6yhDNEulXL3DzbkPDBz3AHmksqS+s0SicnZL03OugofQvbnJpeYrW4/5DODeBePM9Z
         R4hA==
X-Gm-Message-State: AOAM530KrBa0U5pYJVxjjZ4pHh2shYgGR3FzTEifys+RIYuOMm+pR/JB
        imWDNTgPTzDzoxcnoC7zrQY=
X-Google-Smtp-Source: ABdhPJxf5agTw7wnw0u2JGgSFGq3r0uf6IjAVkiSLGsPRvM/GM5a+7CRbL2sLvBsBisGXqlJ/pz5eQ==
X-Received: by 2002:aa7:cac2:: with SMTP id l2mr10170646edt.141.1604194650095;
        Sat, 31 Oct 2020 18:37:30 -0700 (PDT)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id h4sm6707739edj.1.2020.10.31.18.37.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 18:37:29 -0700 (PDT)
Date:   Sun, 1 Nov 2020 03:37:28 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [PATCH v2 net-next 01/12] net: dsa: implement a central TX
 reallocation procedure
Message-ID: <20201101013728.zzepqg3tl4ddgdt5@skbuf>
References: <20201030014910.2738809-1-vladimir.oltean@nxp.com>
 <20201030014910.2738809-2-vladimir.oltean@nxp.com>
 <20201031180043.2f6bed15@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20201101011434.e5crugmwy7drnvqt@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201101011434.e5crugmwy7drnvqt@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 01, 2020 at 03:14:34AM +0200, Vladimir Oltean wrote:
> On Sat, Oct 31, 2020 at 06:00:43PM -0700, Jakub Kicinski wrote:
> > On Fri, 30 Oct 2020 03:48:59 +0200 Vladimir Oltean wrote:
> > > @@ -567,6 +591,17 @@ static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
> > >  	 */
> > >  	dsa_skb_tx_timestamp(p, skb);
> > >  
> > > +	if (dsa_realloc_skb(skb, dev)) {
> > > +		kfree_skb(skb);
> > 
> > dev_kfree_skb_any()?
> 
> Just showing my ignorance, but where does the hardirq context come from?

I mean I do see that netpoll_send_udp requires IRQs disabled, but is
that the only reason why all drivers need to assume hardirq context in
.xmit, or are there more?

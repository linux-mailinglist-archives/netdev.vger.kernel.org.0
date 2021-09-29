Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2409041CE58
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 23:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347122AbhI2VqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 17:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347106AbhI2VqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 17:46:03 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA80C06161C;
        Wed, 29 Sep 2021 14:44:21 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id bd28so13818474edb.9;
        Wed, 29 Sep 2021 14:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4ofYFDjTnd9wcuSnzKe/bhp5JqBkGOHXoKoMcUiFG+s=;
        b=BUDQhajgjlnP3gyujf70KTbbdflYkXFoesQGIAGpkymi5vAMkt+T9vztIjvDk0h6Cz
         1kI9vQMf5+aKjJ39ho9tg9gNT8TcVXLB2+EWhb3U7PVGmNPu8oBbity/Q17DvqpH7tps
         C0la2b5o+zHsqcaZkPN59wTNrC/JQRfRwx/bIaPhknD9pRqM/8Ov3Ne3bSYeiLJJSeDL
         0VlLgQ6yw9eOrfOJnR/uN6oUHnUyYG/yvmdA7ZugxQztRRJvI2JhAo/gCeHvzsc8EKNd
         m5w7okQW7vhqnbMbK3ZxtKJowyUd2W5k1PlOtJYaRZ1rZU1iPQoeAnmadc/bvq70+Dgr
         yYyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4ofYFDjTnd9wcuSnzKe/bhp5JqBkGOHXoKoMcUiFG+s=;
        b=jEpzUhXiWJS8lJQs0IYqCTMUWr1+DPyQ+yHLd3Q4hFQ/dYxXrVU1v/k2CZeMc77f5g
         yKboQT/bcaGYXJ9V+s1+f+v4Ub9SLxIctBUsC8cqEpsoG2OGffBTalNh9P8iH32D1D2P
         VHOzPtSH3sMrApTjxufeph+B+F4KLFWVeJJBs3UHl0Ks+u4pkkMwcb7KzR0LQ4PjJJdO
         WgMTF/5H/uSMrhmuua205BtXxfiGZZj78mIHp/yektD0k2EdKcQPVPNdxmt0bXfGpXMR
         8oS2ABZwcROHI9P6thyKbHOpNNT+CWnwElXQ6s7+KeM/SSNj6zujWVw2/Sgf4STMbCKd
         Zk1g==
X-Gm-Message-State: AOAM530HGEps+6jPO0arxKbD/8Pc725PKrDHQgvxlWzRK4ilL7JTbCkJ
        qHsZ8CkjtywIM7Um6wP6xlY=
X-Google-Smtp-Source: ABdhPJwCV2z6MERcWxLs+awQ9+z2Q5WedzzTqXCr8ZYX3bkaxUJUgFCqeiz5RRXj1ILJrjqw+UbvPA==
X-Received: by 2002:aa7:db85:: with SMTP id u5mr2713707edt.234.1632951860257;
        Wed, 29 Sep 2021 14:44:20 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id l25sm581324eda.36.2021.09.29.14.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 14:44:19 -0700 (PDT)
Date:   Thu, 30 Sep 2021 00:44:18 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        "Paul E . McKenney" <paulmck@kernel.org>,
        rcu <rcu@vger.kernel.org>, Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [RFC PATCH net] net: dsa: tag_dsa: fix suspicious
 rcu_dereference_check() with br_vlan_get_pvid_rcu
Message-ID: <20210929214418.wwm2gpiudekspu5e@skbuf>
References: <20210928233708.1246774-1-vladimir.oltean@nxp.com>
 <d22b1596-e9ba-307c-7033-20f6a074a9df@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d22b1596-e9ba-307c-7033-20f6a074a9df@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 12:21:55AM +0300, Nikolay Aleksandrov wrote:
> To answer the question about the patch - it is correct and ok, the dereference needed
> is done inside the function and after that the value is copied. I'd only check how the
> DSA bridge pointer is handled, it seems it is dereferenced directly and I don't know
> the DSA locking rules (i.e. if anything is held by that time to ensure the pointer is
> valid). As for the patch:
> Reviewed-by: Nikolay Aleksandrov <nikolay@nvidia.com>

I think you're right in the fact that nobody ensures dp->bridge_dev
cannot be reset to NULL by dsa_port_bridge_leave(). I'll try to simulate
an issue by spin-looping for a while in the xmit function while I add
and remove the port from a bridge and see what happens. Worst case,
we'll have to add READ_ONCE and WRITE_ONCE annotations for all users,
and work with a local, on-stack reference. Because the bridge net_device
itself will not go away until the xmit itself finishes, but it's just
that it may not be our upper anymore.

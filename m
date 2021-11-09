Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3E144B13D
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 17:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240217AbhKIQdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 11:33:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240189AbhKIQdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 11:33:42 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D0FC061766
        for <netdev@vger.kernel.org>; Tue,  9 Nov 2021 08:30:55 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id z200so16354138wmc.1
        for <netdev@vger.kernel.org>; Tue, 09 Nov 2021 08:30:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K1Djn1NGugleL3fdls1eG7emz8Ub2InlCxiphHf4t7E=;
        b=qUs74T4WDHbDg4VLPJeM6tBjKDnYcGwupmuMns6IF61DOUZnlSkguJzd6OsfIj8JY2
         VwqY6DKzzfSWjyzeQa2hc87dKw577ejwMEL8avGyWKzn/9awXq1RdTrOuCpYSQyTFfCh
         pRS6pWOK9kK3o3xxjvYHA+pOQ5/Hi6AXwhsqzUb09EyQfkm6g9pBAeWOws0VlWcxOo0Y
         pnupPpPdnhI3BwlBREuAVfxjsSBxcMQI1u8XPElwnuU7ENKtB925FL/vS8QekH72gVcb
         Jn2K5y8V7wNj+J7QTYeaqYMCJUmsF3PmFr4UVR2CcH/W6d5YM61guMgRRaD5u9qMgZvx
         /2Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K1Djn1NGugleL3fdls1eG7emz8Ub2InlCxiphHf4t7E=;
        b=Ya5BJcfGxvkzrdJyiQaivPFGYJNgaPw6QLgVQS2ryYf0zZkWv/qIWRHNxrxxRFosgm
         GpK237CWV6JhoO9yzySBQsyqxWmVmz2JwQvaGeSvgOSkbd4ddn13i2ccSSg9yY6PMZLQ
         XpkmH3KUSySecJR875VfqOlBdC3sqd9TYQVbSR/M8MaC6RAmZNaPwm0iqPEmKzxzjS2H
         cYir8MD6DX2DmYQxtljAEk9JL8b5GJBjDfdX16ZRbc7sZxKCozGjsKmKx0xh+qYJQgAw
         8X7fOG6pQ5EWJ/ndlxlSmJJT/cNyHbwLItWnyx65EVGCB5zFa9X57Q/GGM7VRhb7dNGe
         6PuQ==
X-Gm-Message-State: AOAM533mA/z+pYmJ+PwxZZJCNWhBk1MtGeeHbAhnOeo+6HVkLkmCqyYs
        FW6YC/ZDR2iIaRvhWVW8G/8vCw==
X-Google-Smtp-Source: ABdhPJyCtIuHdYYcQi82w8pNg4wVwqB3rCoMLtPHTLyZOaq7970r+3UxyjCrzdHdIqWIdcnY7Ara5w==
X-Received: by 2002:a1c:4e0c:: with SMTP id g12mr8508110wmh.56.1636475454367;
        Tue, 09 Nov 2021 08:30:54 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id r1sm3145896wmr.36.2021.11.09.08.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 08:30:53 -0800 (PST)
Date:   Tue, 9 Nov 2021 17:30:52 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, edwin.peer@broadcom.com
Subject: Re: [PATCH net-next] devlink: Require devlink lock during device
 reload
Message-ID: <YYqiPIV9KoGTiTSV@nanopsycho>
References: <YYlfI4UgpEsMt5QI@unreal>
 <20211108101646.0a4e5ca4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YYlrZZTdJKhha0FF@unreal>
 <20211108104608.378c106e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YYmBbJ5++iO4MOo7@unreal>
 <20211108153126.1f3a8fe8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211109144358.GA1824154@nvidia.com>
 <20211109070702.17364ec7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YYqenGW4ftZH5Ufi@nanopsycho>
 <20211109082648.73092dfb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109082648.73092dfb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Nov 09, 2021 at 05:26:48PM CET, kuba@kernel.org wrote:
>On Tue, 9 Nov 2021 17:15:24 +0100 Jiri Pirko wrote:
>> Tue, Nov 09, 2021 at 04:07:02PM CET, kuba@kernel.org wrote:
>> >On Tue, 9 Nov 2021 10:43:58 -0400 Jason Gunthorpe wrote:  
>> >> This becomes all entangled in the aux device stuff we did before.  
>> >
>> >So entangled in fact that neither of you is willing to elucidate 
>> >the exact need ;)
>> >  
>> >> devlink reload is defined, for reasons unrelated to netns, to do a
>> >> complete restart of the aux devices below the devlink. This happens
>> >> necessarily during actual reconfiguration operations, for instance.
>> >> 
>> >> So we have a situation, which seems like bad design, where reload is
>> >> also triggered by net namespace change that has nothing to do with
>> >> reconfiguring.  
>> >
>> >Agreed, it is somewhat uncomfortable that the same callback achieves
>> >two things. As clear as the need for reload-for-reset is (reconfig,
>> >recovery etc.) I'm not as clear on reload for netns.
>> >
>> >The main use case for reload for netns is placing a VF in a namespace,
>> >for a container to use. Is that right? I've not seen use cases
>> >requiring the PF to be moved, are there any?
>> >
>> >devlink now lives in a networking namespace yet it spans such
>> >namespaces (thru global notifiers). I think we need to define what it
>> >means for devlink to live in a namespace. Is it just about the
>> >configuration / notification channel? Or do we expect proper isolation?
>> >
>> >Jiri?  
>> 
>> Well honestly the primary motivation was to be able to run smoothly with
>> syzkaller for which the "configuration / notification channel" is
>> enough.
>
>Hm. And syzkaller runs in a namespace?

Correct.

>
>> By "proper isolation" you mean what exactly?
>
>For the devlink instance and all subordinate objects to be entirely
>contained to the namespace within which devlink resides, unless
>explicitly liked up with or delegated to another namespace.

What makes sense to me and that is actually how the current drivers
should behave (mlxsw, netdevsim are for sure).

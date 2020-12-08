Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 719522D376A
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 01:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730326AbgLIALc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 19:11:32 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:23755 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbgLIALc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 19:11:32 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607472671; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=F7a2bvI/3J/IthbcdUv2Ssr5gCPWZKmwp8RPsMjnRqM=;
 b=drCGChBwaAPVToLVOgNu1NTeZjP48jJt0Jl2O8vy4JAGSjz8M87+D1teLCi8oGlLU6sJweRP
 qiHQTZLVaBfxp27I5eTACvDcpitgrohtTSjVJHodpdlh5XOxK0zOnEDASaa5B4XxFua1VdmW
 /Zp86wp09giepncuhpXhI7J3sb4=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-west-2.postgun.com with SMTP id
 5fcfd035b0e089112d37c384 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 08 Dec 2020 19:12:53
 GMT
Sender: stranche=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6E8A7C43463; Tue,  8 Dec 2020 19:12:53 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: stranche)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DD755C433CA;
        Tue,  8 Dec 2020 19:12:52 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 08 Dec 2020 12:12:52 -0700
From:   stranche@codeaurora.org
To:     Wei Wang <weiwan@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: Re: Refcount mismatch when unregistering netdevice from kernel
In-Reply-To: <CAEA6p_D+diS7jnpoGk6cncWL8qiAGod2EAp=Vcnc-zWNPg04Jg@mail.gmail.com>
References: <ca64de092db5a2ac80d22eaa9d662520@codeaurora.org>
 <56e72b72-685f-925d-db2d-d245c1557987@gmail.com>
 <CAEA6p_D+diS7jnpoGk6cncWL8qiAGod2EAp=Vcnc-zWNPg04Jg@mail.gmail.com>
Message-ID: <307c2de1a2ddbdcd0a346c57da88b394@codeaurora.org>
X-Sender: stranche@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wei and Eric,

Thanks for the replies.

This was reported to us on the 5.4.61 kernel during a customer 
regression suite, so we don't have an exact reproducer unfortunately. 
 From the trace logs we've added it seems like this is happening during 
IPv6 transport mode XFRM data transfer and the device is unregistered in 
the middle of it, but we've been unable to reproduce it ourselves.. 
We're open to trying out and sharing debug patches if needed though.

> rt6_uncached_list_flush_dev() actually tries to replace the inet6_dev
> with loopback_dev, and release the reference to the previous inet6_dev
> by calling in6_dev_put(), which is actually doing the same thing as
> ip6_dst_ifdown(). I don't understand why you say " a reference to the
> inet6_dev is simply dropped".

Fair. I was going off the semantics used by the dst_dev_put() function 
which calls dst_ops->ifdown() explicitly. At least in the case of 
xfrm6_dst_ifdown() this swap of the loopback device and putting the 
refcount seems like it could be missing a few things.

> The additional refcount to the DST is also released by doing the 
> following:
>                         if (rt_dev == dev) {
>                                 rt->dst.dev = blackhole_netdev;
>                                 dev_hold(rt->dst.dev);
>                                 dev_put(rt_dev);
>                         }
> Am I missing something?

That dev_put() is on the actual netdevice struct, not the inet6_dev 
associated with it. We're seeing many calls to icmp6_dst_alloc() and 
xfrm6_fill_dst() here, both of which seem to associate a reference to 
the inet6_dev struct with the DST in addition to the standard dev_hold() 
on the netdevice during the dst_alloc()/dst_init().

Thanks,
Sean

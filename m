Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 380A33F958A
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 09:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244482AbhH0Hwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 03:52:31 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:42196 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244446AbhH0Hwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 03:52:30 -0400
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id E72CF201237B;
        Fri, 27 Aug 2021 09:51:38 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be E72CF201237B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1630050698;
        bh=1PgvJ1kILImiZQQ5OcNaXedEWTgco9KIGb/kvqnjUmg=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=N/5rJMGYUlrRl+xG60uzdk3x+984f3evJAABb8VQh0MAGWDhGDG3yoHCfy3ZOINRE
         dAcx/TkcuYqpWHtfwO+IiI9xUZQveyAxRR+B2ud8Gcx/zuwkP2yhzADqSd5lwENE5A
         gn5apXA0AEEDrilJHtXQvdIGuoBaQeK/XtCOjQxTyASwx1jALyJ3aTxHjEHUdj7ldI
         fdmgkFLCYJv6K3kS96JmAgXC9B/247JoxE3Ay+MlMtJU5rc2uG4wNTdUQjZB7TQ/We
         hl5hlldOeVfYO6XUWwnkGERoGSVAo8Rz+5g2ubHI8zMbExx2jDcuDWlOu5yB3unj4L
         aL0b5uiIhr1Rg==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id DAC376008D7F1;
        Fri, 27 Aug 2021 09:51:38 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 7XoZlvJZBY7B; Fri, 27 Aug 2021 09:51:38 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id C14C16008437A;
        Fri, 27 Aug 2021 09:51:38 +0200 (CEST)
Date:   Fri, 27 Aug 2021 09:51:38 +0200 (CEST)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     nicolas dichtel <nicolas.dichtel@6wind.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, tom@herbertland.com,
        edumazet@google.com
Message-ID: <324963792.54305318.1630050698741.JavaMail.zimbra@uliege.be>
In-Reply-To: <76c2a8bf-e8c8-7402-ba20-a493fbf7c0e4@6wind.com>
References: <20210826140150.19920-1-justin.iurman@uliege.be> <fd41d544-31f0-8e60-a301-eb4f4e323a5b@6wind.com> <1977792481.53611744.1629994989620.JavaMail.zimbra@uliege.be> <76c2a8bf-e8c8-7402-ba20-a493fbf7c0e4@6wind.com>
Subject: Re: [RFC net-next] ipv6: Support for anonymous tunnel decapsulation
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.22.52.207]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF91 (Linux)/8.8.15_GA_4026)
Thread-Topic: ipv6: Support for anonymous tunnel decapsulation
Thread-Index: J11r844EbsWSjUQE29frG4NZmWXc8Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> [snip]
> 
>>>> Thoughts?
>>> I'm not sure to understand why the current code isn't enough. The fallback
>>> tunnels created by legacy IP tunnels drivers are able to receive and decapsulate
>>> any encapsulated packets.
>> 
>> Because, right now, you need to use the ip6_tunnel module and explicitly
>> configure a tunnel, as you described below. The goal of this patch is to
>> provide a way to apply an ip6ip6 decapsulation *without* having to configure a
>> tunnel.
> 
> What is the difference between setting a sysctl somewhere and putting an
> interface up?

Well, correct me if I'm wrong but, it's more than just putting an interface up. You'd first need ip6_tunnel (and so tunnel6) module loaded, but you'd also need to configure a tunnel on the decap node. Indeed, the current ip6_tunnel fallback handler only works if a tunnel matches the packet (i.e., ipxip6_rcv will return -1 since ip6_tnl_lookup will return NULL, leading to *no* decapsulation from this handler).

So, again, think about the case where you have lots of ingresses and egresses that should be linked (= a tunnel for each pair) altogether in a domain. You'd need to configure N tunnels on the decap node, where N is the number of ingresses. Well, actually no, you could just configure one tunnel with "remote any", but you'd still depend on the ip6_tunnel module and play with tunnel configuration and its interface. This patch provides a way to avoid that by just enabling the ip6ip6 decapsulation through a per interface sysctl.

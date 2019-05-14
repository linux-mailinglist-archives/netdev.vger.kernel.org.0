Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99C481C6F7
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 12:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbfENKYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 06:24:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52826 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbfENKYU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 May 2019 06:24:20 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 06FC7C045770;
        Tue, 14 May 2019 10:24:20 +0000 (UTC)
Received: from bistromath.localdomain (unknown [10.40.205.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DD961608A6;
        Tue, 14 May 2019 10:24:16 +0000 (UTC)
Date:   Tue, 14 May 2019 12:24:15 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     netdev@vger.kernel.org, Dan Winship <danw@redhat.com>
Subject: Re: [PATCH net v2] rtnetlink: always put ILFA_LINK for links with a
 link-netnsid
Message-ID: <20190514102415.GA24722@bistromath.localdomain>
References: <d5c4710117d390e0f204b7046483727daf452233.1557755096.git.sd@queasysnail.net>
 <b89367f0-18d5-61b2-2572-b1e5b4588d8d@6wind.com>
 <20190513150812.GA18478@bistromath.localdomain>
 <771b21d6-3b1e-c118-2907-5b5782f7cb92@6wind.com>
 <20190513214648.GA29270@bistromath.localdomain>
 <65c8778c-9be9-c81f-5a9b-13e070ca38da@6wind.com>
 <20190514080127.GA17749@bistromath.localdomain>
 <7c8880b4-86a0-c4b0-4b92-136b2ab790db@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7c8880b4-86a0-c4b0-4b92-136b2ab790db@6wind.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Tue, 14 May 2019 10:24:20 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-05-14, 12:05:16 +0200, Nicolas Dichtel wrote:
> Le 14/05/2019 à 10:01, Sabrina Dubroca a écrit :
> > 2019-05-14, 09:32:32 +0200, Nicolas Dichtel wrote:
> [snip]
> >> What about this one?
> >> Fixes: d8a5ec672768 ("[NET]: netlink support for moving devices between network
> >> namespaces.")
> > 
> > Nice. Now I think the bug can't really trigger unless one of these
> > commits are present:
> > 
> > aa79e66eee5d ("net: Make ifindex generation per-net namespace")
> > 9c7dafbfab15 ("net: Allow to create links with given ifindex")
> > 
> I don't think so.
> 
> Please have a look to commit ce286d327341 ("[NET]: Implement network device
> movement between namespaces").
> In dev_change_net_namespace(), there is the following code:
> 
>        /* If there is an ifindex conflict assign a new one */
>        if (__dev_get_by_index(net, dev->ifindex)) {
>                int iflink = (dev->iflink == dev->ifindex);
>                dev->ifindex = dev_new_index(net);
>                if (iflink)
>                        dev->iflink = dev->ifindex;
>        }
> 
> This code may change the ifindex of an interface when this interface moves to
> another netns. This may happen even before the commits you propose, because the
> global ifindex counter can wrap around.

Yes, that's possible although quite unlikely. I'll go with d8a5ec672768.

-- 
Sabrina

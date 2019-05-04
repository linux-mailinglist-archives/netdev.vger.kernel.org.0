Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1030413B80
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 20:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfEDSBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 14:01:41 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:54858 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726217AbfEDSBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 14:01:41 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hMyyh-0002HY-DZ; Sat, 04 May 2019 20:01:39 +0200
Date:   Sat, 4 May 2019 20:01:39 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Florian Westphal <fw@strlen.de>
Subject: Re: [RFC] ifa_list needs proper rcu protection
Message-ID: <20190504180139.ftpnwgefjvukda7w@breakpoint.cc>
References: <7bdc26e6-ce41-02ba-baef-3e4e908f6dd7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7bdc26e6-ce41-02ba-baef-3e4e908f6dd7@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> wrote:

Sorry for late reply.

> It looks that unless RTNL is held, accessing ifa_list needs proper RCU protection ?
> 
> indev->ifa_list can be changed under us by another cpu (which owns RTNL)
> 
> Lets took an example.
> 
> (A proper rcu_dereference() with an happy sparse support would require adding __rcu attribute,
>  I put a READ_ONCE() which should be just fine in this particular context)

I don't see e.g. __inet_insert_ifa() use rcu_assign_pointer() or similar
primitive, so I don't think its enough to change readers.

Same for __inet_del_ifa(), i see freeing gets dealyed via call_rcu, but
it uses normal assignemts instead of a rcu helper.

So, I am afraid we will have to sprinkle some rcu_assign_/derefence in
several places.


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA04DE5837
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 05:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbfJZDPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 23:15:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40176 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbfJZDPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 23:15:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 37EFC14B7BF70;
        Fri, 25 Oct 2019 20:15:49 -0700 (PDT)
Date:   Fri, 25 Oct 2019 20:15:45 -0700 (PDT)
Message-Id: <20191025.201545.532234176918755972.davem@davemloft.net>
To:     gnault@redhat.com
Cc:     jakub.kicinski@netronome.com, netdev@vger.kernel.org,
        nicolas.dichtel@6wind.com, alexei.starovoitov@gmail.com,
        pshelar@ovn.org, jbenc@redhat.com
Subject: Re: [PATCH net] netns: fix GFP flags in rtnl_net_notifyid()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <d2d9d7a0168e9c216b6755021ef4cf5b3baaf3b9.1571848485.git.gnault@redhat.com>
References: <d2d9d7a0168e9c216b6755021ef4cf5b3baaf3b9.1571848485.git.gnault@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 25 Oct 2019 20:15:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>
Date: Wed, 23 Oct 2019 18:39:04 +0200

> In rtnl_net_notifyid(), we certainly can't pass a null GFP flag to
> rtnl_notify(). A GFP_KERNEL flag would be fine in most circumstances,
> but there are a few paths calling rtnl_net_notifyid() from atomic
> context or from RCU critical sections. The later also precludes the use
> of gfp_any() as it wouldn't detect the RCU case. Also, the nlmsg_new()
> call is wrong too, as it uses GFP_KERNEL unconditionally.
> 
> Therefore, we need to pass the GFP flags as parameter and propagate it
> through function calls until the proper flags can be determined.
> 
> In most cases, GFP_KERNEL is fine. The exceptions are:
>   * openvswitch: ovs_vport_cmd_get() and ovs_vport_cmd_dump()
>     indirectly call rtnl_net_notifyid() from RCU critical section,
> 
>   * rtnetlink: rtmsg_ifinfo_build_skb() already receives GFP flags as
>     parameter.
> 
> Also, in ovs_vport_cmd_build_info(), let's change the GFP flags used
> by nlmsg_new(). The function is allowed to sleep, so better make the
> flags consistent with the ones used in the following
> ovs_vport_cmd_fill_info() call.
> 
> Found by code inspection.
> 
> Fixes: 9a9634545c70 ("netns: notify netns id events")
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Applied and queued up for -stable, thank you.

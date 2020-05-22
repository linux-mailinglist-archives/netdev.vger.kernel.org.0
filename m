Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D98421DDC22
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 02:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgEVA0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 20:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbgEVA0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 20:26:05 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE74C061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 17:26:05 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 69615120ED486;
        Thu, 21 May 2020 17:26:05 -0700 (PDT)
Date:   Thu, 21 May 2020 17:26:04 -0700 (PDT)
Message-Id: <20200521.172604.648069177650832955.davem@davemloft.net>
To:     sd@queasysnail.net
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net] net: don't return invalid table id error when we
 fall back to PF_UNSPEC
From:   David Miller <davem@davemloft.net>
In-Reply-To: <fc61912d585ccf3999c3cba5e481c1920af17ca6.1589961603.git.sd@queasysnail.net>
References: <fc61912d585ccf3999c3cba5e481c1920af17ca6.1589961603.git.sd@queasysnail.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 May 2020 17:26:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>
Date: Wed, 20 May 2020 11:15:46 +0200

> In case we can't find a ->dumpit callback for the requested
> (family,type) pair, we fall back to (PF_UNSPEC,type). In effect, we're
> in the same situation as if userspace had requested a PF_UNSPEC
> dump. For RTM_GETROUTE, that handler is rtnl_dump_all, which calls all
> the registered RTM_GETROUTE handlers.
> 
> The requested table id may or may not exist for all of those
> families. commit ae677bbb4441 ("net: Don't return invalid table id
> error when dumping all families") fixed the problem when userspace
> explicitly requests a PF_UNSPEC dump, but missed the fallback case.
> 
> For example, when we pass ipv6.disable=1 to a kernel with
> CONFIG_IP_MROUTE=y and CONFIG_IP_MROUTE_MULTIPLE_TABLES=y,
> the (PF_INET6, RTM_GETROUTE) handler isn't registered, so we end up in
> rtnl_dump_all, and listing IPv6 routes will unexpectedly print:
> 
>   # ip -6 r
>   Error: ipv4: MR table does not exist.
>   Dump terminated
> 
> commit ae677bbb4441 introduced the dump_all_families variable, which
> gets set when userspace requests a PF_UNSPEC dump. However, we can't
> simply set the family to PF_UNSPEC in rtnetlink_rcv_msg in the
> fallback case to get dump_all_families == true, because some messages
> types (for example RTM_GETRULE and RTM_GETNEIGH) only register the
> PF_UNSPEC handler and use the family to filter in the kernel what is
> dumped to userspace. We would then export more entries, that userspace
> would have to filter. iproute does that, but other programs may not.
> 
> Instead, this patch removes dump_all_families and updates the
> RTM_GETROUTE handlers to check if the family that is being dumped is
> their own. When it's not, which covers both the intentional PF_UNSPEC
> dumps (as dump_all_families did) and the fallback case, ignore the
> missing table id error.
> 
> Fixes: cb167893f41e ("net: Plumb support for filtering ipv4 and ipv6 multicast route dumps")
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>

Applied and queued up for -stable, thank you.

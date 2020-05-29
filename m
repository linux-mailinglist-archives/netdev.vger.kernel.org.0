Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9432E1E8C37
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 01:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbgE2Xm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 19:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgE2Xm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 19:42:29 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED21AC03E969
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 16:42:28 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9504B12868380;
        Fri, 29 May 2020 16:42:28 -0700 (PDT)
Date:   Fri, 29 May 2020 16:42:27 -0700 (PDT)
Message-Id: <20200529.164227.1281408645512421293.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] vxlan: remove fdb when out interface is
 removed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200527162950.9343-1-ap420073@gmail.com>
References: <20200527162950.9343-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 29 May 2020 16:42:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Wed, 27 May 2020 16:29:50 +0000

> vxlan fdb can have NDA_IFINDEX, which indicates an out interface.
> If the interface is removed, that fdb will not work.
> So, when interface is removed, vxlan's fdb can be removed.
> 
> Test commands:
>     ip link add dummy0 type dummy
>     ip link add vxlan0 type vxlan vni 1000
>     bridge fdb add 11:22:33:44:55:66 dst 1.1.1.1 dev vxlan0 via dummy0 self
>     ip link del dummy0
> 
> Before this patch, fdbs will not be removed.
> Result:
>     bridge fdb show dev vxlan0
> 11:22:33:44:55:66 dst 1.1.1.1 via if10 self permanent
> 
> 'if10' indicates 'dummy0' interface index.
> But the dummy0 interface was removed so this fdb will not work.
> 
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

But if someone adds an interface afterwards with ifindex 10 that FDB
entry will start using it.

I don't know how desirable that is, but if someone is depending upon
that behavior now this change will break things for them.

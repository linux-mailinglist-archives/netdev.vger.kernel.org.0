Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B61711D6413
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 22:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgEPUzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 16:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726592AbgEPUzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 16:55:51 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B399C061A0C;
        Sat, 16 May 2020 13:55:51 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 12BC6119445CC;
        Sat, 16 May 2020 13:55:49 -0700 (PDT)
Date:   Sat, 16 May 2020 13:55:48 -0700 (PDT)
Message-Id: <20200516.135548.2079608042651975047.davem@davemloft.net>
To:     hch@lst.de
Cc:     kuba@kernel.org, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ipv6: symbol_get to access a sit symbol
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200515063324.GA31377@lst.de>
References: <20200514145101.3000612-5-hch@lst.de>
        <20200514.175355.167885308958584692.davem@davemloft.net>
        <20200515063324.GA31377@lst.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 May 2020 13:55:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Fri, 15 May 2020 08:33:24 +0200

> My initial plan was to add a ->tunnel_ctl method to the net_device_ops,
> and lift the copy_{to,from}_user for SIOCADDTUNNEL, SIOCCHGTUNNEL,
> SIOCDELTUNNEL and maybe SIOCGETTUNNEL to net/socket.c.  But that turned
> out to have two problems:
> 
>  - first these ioctls names use SIOCDEVPRIVATE range, that can also
>    be implemented by other drivers
>  - the ip_tunnel_parm struture is only used by the ipv4 tunneling
>    drivers (including sit), the "real" ipv6 tunnels use a
>    ip6_tnl_parm or ip6_tnl_parm structure instead

Yes, this is the core of the problem, the user provided data's type
is unknown until we are very deep in the call chains.

I wonder if there is some clever way to propagate this size value
"up"?

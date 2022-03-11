Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B35F4D5DB8
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 09:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235469AbiCKIs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 03:48:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236636AbiCKIs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 03:48:58 -0500
Received: from smtp.tom.com (smtprz02.163.net [106.3.154.235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4D09756C28
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 00:47:54 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by vip-app02.163.net (Postfix) with ESMTP id 6D0AD44013F
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 16:47:53 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tom.com; s=mail;
        t=1646988473; bh=AEFZVAJwucJ2wHyqaL/XbxD7jUYcLxvLBDGo8y7nOI4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=5nn0Ihcgi0xdvTkX90xPeSHrWZLwKsKkpZkScq81Fy2jHRlxDJHN/kCVI1oGIT3Xz
         Lop/I3nqxGDJ7TsvQmfspUGKOyge3htkNVTbhlWRLmhoB4lcVOVP+v5BMl/bASOlau
         Bl1jObpBkM3hsCqmWR44b3Q/ZYCfoZ9zS5BXFm3c=
Received: from localhost (HELO smtp.tom.com) ([127.0.0.1])
          by localhost (TOM SMTP Server) with SMTP ID -2048511577
          for <netdev@vger.kernel.org>;
          Fri, 11 Mar 2022 16:47:53 +0800 (CST)
X-Virus-Scanned: Debian amavisd-new at mxtest.tom.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tom.com; s=mail;
        t=1646988473; bh=AEFZVAJwucJ2wHyqaL/XbxD7jUYcLxvLBDGo8y7nOI4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=5nn0Ihcgi0xdvTkX90xPeSHrWZLwKsKkpZkScq81Fy2jHRlxDJHN/kCVI1oGIT3Xz
         Lop/I3nqxGDJ7TsvQmfspUGKOyge3htkNVTbhlWRLmhoB4lcVOVP+v5BMl/bASOlau
         Bl1jObpBkM3hsCqmWR44b3Q/ZYCfoZ9zS5BXFm3c=
Received: from localhost (unknown [101.93.196.13])
        by antispamvip.163.net (Postfix) with ESMTPA id 1C8C815414F8;
        Fri, 11 Mar 2022 16:47:49 +0800 (CST)
Date:   Fri, 11 Mar 2022 16:47:48 +0800
From:   Mingbao Sun <sunmingbao@tom.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        tyler.sun@dell.com, ping.gan@dell.com, yanxiu.cai@dell.com,
        libin.zhang@dell.com, ao.sun@dell.com
Subject: Re: [PATCH 2/3] nvme-tcp: support specifying the congestion-control
Message-ID: <20220311164748.00000217@tom.com>
In-Reply-To: <20220311071518.GB18222@lst.de>
References: <20220311030113.73384-1-sunmingbao@tom.com>
        <20220311030113.73384-3-sunmingbao@tom.com>
        <20220311071518.GB18222@lst.de>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Mar 2022 08:15:18 +0100
Christoph Hellwig <hch@lst.de> wrote:

> On Fri, Mar 11, 2022 at 11:01:12AM +0800, Mingbao Sun wrote:
> > +		case NVMF_OPT_TCP_CONGESTION:
> > +			p = match_strdup(args);
> > +			if (!p) {
> > +				ret = -ENOMEM;
> > +				goto out;
> > +			}
> > +
> > +			kfree(opts->tcp_congestion);
> > +			opts->tcp_congestion = p;  
> 
> We'll need to check that the string is no loner than TCP_CA_NAME_MAX
> somewhere.
> 

accept.
will do that in the next version.
this would also be applied for the target side.

> >  
> > +	if (nctrl->opts->mask & NVMF_OPT_TCP_CONGESTION) {
> > +		ret = tcp_set_congestion_control(queue->sock->sk,
> > +						 nctrl->opts->tcp_congestion,
> > +						 true, true);  
> 
> This needs to be called under lock_sock() protection.  Maybe also
> add an assert to tcp_set_congestion_control to enforce that.

accept.
will handle it in the next version.
this would also be applied for the target side.
Many thanks for reminding.

as for the assertion, I failed to find a conventional way to do that.
would you like to give me a suggestion?


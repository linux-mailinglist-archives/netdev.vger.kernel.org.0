Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2850520EA1A
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 02:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgF3AQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 20:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbgF3AQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 20:16:40 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFEACC061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 17:16:39 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 88747127BE1A6;
        Mon, 29 Jun 2020 17:16:39 -0700 (PDT)
Date:   Mon, 29 Jun 2020 17:16:38 -0700 (PDT)
Message-Id: <20200629.171638.352525655758256517.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org,
        syzbot+3039ddf6d7b13daf3787@syzkaller.appspotmail.com,
        syzbot+80cad1e3cb4c41cde6ff@syzkaller.appspotmail.com,
        syzbot+736bcbcb11b60d0c0792@syzkaller.appspotmail.com,
        syzbot+520f8704db2b68091d44@syzkaller.appspotmail.com,
        syzbot+c96e4dfb32f8987fdeed@syzkaller.appspotmail.com,
        jiri@mellanox.com
Subject: Re: [Patch net] genetlink: get rid of family->attrbuf
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200627071224.12221-1-xiyou.wangcong@gmail.com>
References: <20200627071224.12221-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jun 2020 17:16:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Sat, 27 Jun 2020 00:12:24 -0700

> genl_family_rcv_msg_attrs_parse() reuses the global family->attrbuf
> when family->parallel_ops is false. However, family->attrbuf is not
> protected by any lock on the genl_family_rcv_msg_doit() code path.
> 
> This leads to several different consequences, one of them is UAF,
> like the following:
> 
> genl_family_rcv_msg_doit():		genl_start():
> 					  genl_family_rcv_msg_attrs_parse()
> 					    attrbuf = family->attrbuf
> 					    __nlmsg_parse(attrbuf);
>   genl_family_rcv_msg_attrs_parse()
>     attrbuf = family->attrbuf
>     __nlmsg_parse(attrbuf);
> 					  info->attrs = attrs;
> 					  cb->data = info;
> 
> netlink_unicast_kernel():
>  consume_skb()
> 					genl_lock_dumpit():
> 					  genl_dumpit_info(cb)->attrs
> 
> Note family->attrbuf is an array of pointers to the skb data, once
> the skb is freed, any dereference of family->attrbuf will be a UAF.
> 
> Maybe we could serialize the family->attrbuf with genl_mutex too, but
> that would make the locking more complicated. Instead, we can just get
> rid of family->attrbuf and always allocate attrbuf from heap like the
> family->parallel_ops==true code path. This may add some performance
> overhead but comparing with taking the global genl_mutex, it still
> looks better.
> 
> Fixes: 75cdbdd08900 ("net: ieee802154: have genetlink code to parse the attrs during dumpit")
> Fixes: 057af7071344 ("net: tipc: have genetlink code to parse the attrs during dumpit")
> Reported-and-tested-by: syzbot+3039ddf6d7b13daf3787@syzkaller.appspotmail.com
> Reported-and-tested-by: syzbot+80cad1e3cb4c41cde6ff@syzkaller.appspotmail.com
> Reported-and-tested-by: syzbot+736bcbcb11b60d0c0792@syzkaller.appspotmail.com
> Reported-and-tested-by: syzbot+520f8704db2b68091d44@syzkaller.appspotmail.com
> Reported-and-tested-by: syzbot+c96e4dfb32f8987fdeed@syzkaller.appspotmail.com
> Cc: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied and queued up for -stable, thank you.

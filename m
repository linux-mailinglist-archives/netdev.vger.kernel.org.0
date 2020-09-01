Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0DE259F94
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 22:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732777AbgIAUBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 16:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732069AbgIAUBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 16:01:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59757C061244;
        Tue,  1 Sep 2020 13:01:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C708B13649A5A;
        Tue,  1 Sep 2020 12:44:43 -0700 (PDT)
Date:   Tue, 01 Sep 2020 13:01:27 -0700 (PDT)
Message-Id: <20200901.130127.236989626732311083.davem@davemloft.net>
To:     rkovhaev@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH] veth: fix memory leak in veth_newlink()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200830131336.275844-1-rkovhaev@gmail.com>
References: <20200830131336.275844-1-rkovhaev@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 01 Sep 2020 12:44:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rustam Kovhaev <rkovhaev@gmail.com>
Date: Sun, 30 Aug 2020 06:13:36 -0700

> when register_netdevice(dev) fails we should check whether struct
> veth_rq has been allocated via ndo_init callback and free it, because,
> depending on the code path, register_netdevice() might not call
> priv_destructor() callback
> 
> Reported-and-tested-by: syzbot+59ef240dd8f0ed7598a8@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=59ef240dd8f0ed7598a8
> Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>

I think I agree with Toshiaki here.  There is no reason why the
rollback_registered() path of register_netdevice() should behave
differently from the normal control flow.

Any code path that invokes ->ndo_uninit() should probably also
invoke the priv destructor.

The question is why does the err_uninit: label of register_netdevice
behave differently from rollback_registered()?  If there is a reason,
it should be documented in a comment or similar.  If it is wrong,
it should be corrected.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0B9A137ABE
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 01:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727756AbgAKAqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 19:46:52 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42658 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727724AbgAKAqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 19:46:52 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1204415858B82;
        Fri, 10 Jan 2020 16:46:51 -0800 (PST)
Date:   Fri, 10 Jan 2020 16:46:50 -0800 (PST)
Message-Id: <20200110.164650.1251401325755435922.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com,
        jakub.kicinski@netronome.com, dvyukov@google.com,
        alexve@mellanox.com, mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net] devlink: Wait longer before warning about unset
 port type
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200109175741.293670-1-idosch@idosch.org>
References: <20200109175741.293670-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 Jan 2020 16:46:51 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Thu,  9 Jan 2020 19:57:41 +0200

> From: Ido Schimmel <idosch@mellanox.com>
> 
> The commit cited below causes devlink to emit a warning if a type was
> not set on a devlink port for longer than 30 seconds to "prevent
> misbehavior of drivers". This proved to be problematic when
> unregistering the backing netdev. The flow is always:
> 
> devlink_port_type_clear()	// schedules the warning
> unregister_netdev()		// blocking
> devlink_port_unregister()	// cancels the warning
> 
> The call to unregister_netdev() can block for long periods of time for
> various reasons: RTNL lock is contended, large amounts of configuration
> to unroll following dismantle of the netdev, etc. This results in
> devlink emitting a warning despite the driver behaving correctly.
> 
> In emulated environments (of future hardware) which are usually very
> slow, the warning can also be emitted during port creation as more than
> 30 seconds can pass between the time the devlink port is registered and
> when its type is set.
> 
> In addition, syzbot has hit this warning [1] 1974 times since 07/11/19
> without being able to produce a reproducer. Probably because
> reproduction depends on the load or other bugs (e.g., RTNL not being
> released).
> 
> To prevent bogus warnings, increase the timeout to 1 hour.
> 
> [1] https://syzkaller.appspot.com/bug?id=e99b59e9c024a666c9f7450dc162a4b74d09d9cb
> 
> Fixes: 136bf27fc0e9 ("devlink: add warning in case driver does not set port type")
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Reported-by: syzbot+b0a18ed7b08b735d2f41@syzkaller.appspotmail.com
> Reported-by: Alex Veber <alexve@mellanox.com>
> Tested-by: Alex Veber <alexve@mellanox.com>
> Acked-by: Jiri Pirko <jiri@mellanox.com>

Applied and queued up for v5.3+ -stable, thanks.

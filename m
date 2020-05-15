Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7F71D57B9
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 19:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgEORZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 13:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726295AbgEORZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 13:25:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD4CC061A0C
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 10:25:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BCB3F14CE21A4;
        Fri, 15 May 2020 10:25:17 -0700 (PDT)
Date:   Fri, 15 May 2020 10:25:16 -0700 (PDT)
Message-Id: <20200515.102516.536157145939265174.davem@davemloft.net>
To:     vladbu@mellanox.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, dcaratti@redhat.com, marcelo.leitner@gmail.com,
        kuba@kernel.org
Subject: Re: [PATCH net-next v2 0/4] Implement classifier-action terse dump
 mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200515114014.3135-1-vladbu@mellanox.com>
References: <20200515114014.3135-1-vladbu@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 15 May 2020 10:25:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>
Date: Fri, 15 May 2020 14:40:10 +0300

> Output rate of current upstream kernel TC filter dump implementation if
> relatively low (~100k rules/sec depending on configuration). This
> constraint impacts performance of software switch implementation that
> rely on TC for their datapath implementation and periodically call TC
> filter dump to update rules stats. Moreover, TC filter dump output a lot
> of static data that don't change during the filter lifecycle (filter
> key, specific action details, etc.) which constitutes significant
> portion of payload on resulting netlink packets and increases amount of
> syscalls necessary to dump all filters on particular Qdisc. In order to
> significantly improve filter dump rate this patch sets implement new
> mode of TC filter dump operation named "terse dump" mode. In this mode
> only parameters necessary to identify the filter (handle, action cookie,
> etc.) and data that can change during filter lifecycle (filter flags,
> action stats, etc.) are preserved in dump output while everything else
> is omitted.
> 
> Userspace API is implemented using new TCA_DUMP_FLAGS tlv with only
> available flag value TCA_DUMP_FLAGS_TERSE. Internally, new API requires
> individual classifier support (new tcf_proto_ops->terse_dump()
> callback). Support for action terse dump is implemented in act API and
> don't require changing individual action implementations.
 ...

This looks fine, so series applied.

But really if people just want an efficient stats dump there is probably
a better way to efficiently encode just the IDs and STATs.  Maybe even
put the stats in pages that userland can mmap() and avoid all of this
system call overhead and locking altogether.


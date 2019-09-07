Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACCDAC783
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 18:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394787AbfIGQGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 12:06:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46572 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391808AbfIGQGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 12:06:32 -0400
Received: from localhost (unknown [88.214.184.0])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2430515288A36;
        Sat,  7 Sep 2019 09:06:29 -0700 (PDT)
Date:   Sat, 07 Sep 2019 18:06:28 +0200 (CEST)
Message-Id: <20190907.180628.1861058336902638682.davem@davemloft.net>
To:     simon.horman@netronome.com
Cc:     jakub.kicinski@netronome.com, netdev@vger.kernel.org,
        oss-drivers@netronome.com, frederik.lotter@netronome.com
Subject: Re: [PATCH net] nfp: flower: cmsg rtnl locks can timeout reify
 messages
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190906172941.25136-1-simon.horman@netronome.com>
References: <20190906172941.25136-1-simon.horman@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 07 Sep 2019 09:06:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Simon Horman <simon.horman@netronome.com>
Date: Fri,  6 Sep 2019 19:29:41 +0200

> From: Fred Lotter <frederik.lotter@netronome.com>
> 
> Flower control message replies are handled in different locations. The truly
> high priority replies are handled in the BH (tasklet) context, while the
> remaining replies are handled in a predefined Linux work queue. The work
> queue handler orders replies into high and low priority groups, and always
> start servicing the high priority replies within the received batch first.
> 
> Reply Type:			Rtnl Lock:	Handler:
 ...
> A subset of control messages can block waiting for an rtnl lock (from both
> work queue priority groups). The rtnl lock is heavily contended for by
> external processes such as systemd-udevd, systemd-network and libvirtd,
> especially during netdev creation, such as when flower VFs and representors
> are instantiated.
> 
> Kernel netlink instrumentation shows that external processes (such as
> systemd-udevd) often use successive rtnl_trylock() sequences, which can result
> in an rtnl_lock() blocked control message to starve for longer periods of time
> during rtnl lock contention, i.e. netdev creation.
> 
> In the current design a single blocked control message will block the entire
> work queue (both priorities), and introduce a latency which is
> nondeterministic and dependent on system wide rtnl lock usage.
> 
> In some extreme cases, one blocked control message at exactly the wrong time,
> just before the maximum number of VFs are instantiated, can block the work
> queue for long enough to prevent VF representor REIFY replies from getting
> handled in time for the 40ms timeout.
> 
> The firmware will deliver the total maximum number of REIFY message replies in
> around 300us.
> 
> Only REIFY and MTU update messages require replies within a timeout period (of
> 40ms). The MTU-only updates are already done directly in the BH (tasklet)
> handler.
> 
> Move the REIFY handler down into the BH (tasklet) in order to resolve timeouts
> caused by a blocked work queue waiting on rtnl locks.
> 
> Signed-off-by: Fred Lotter <frederik.lotter@netronome.com>
> Signed-off-by: Simon Horman <simon.horman@netronome.com>

Applied.

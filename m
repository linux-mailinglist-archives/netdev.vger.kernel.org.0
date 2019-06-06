Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1F1437C4E
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 20:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbfFFSc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 14:32:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55504 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726837AbfFFSc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 14:32:28 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E91F514DE2303;
        Thu,  6 Jun 2019 11:32:27 -0700 (PDT)
Date:   Thu, 06 Jun 2019 11:32:27 -0700 (PDT)
Message-Id: <20190606.113227.492005574306351502.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, mcroce@redhat.com
Subject: Re: [PATCH net v2] pktgen: do not sleep with the thread lock held.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <011e3de13ea55a66d55024b5555cefd9dd8ec4c3.1559828069.git.pabeni@redhat.com>
References: <011e3de13ea55a66d55024b5555cefd9dd8ec4c3.1559828069.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Jun 2019 11:32:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Thu,  6 Jun 2019 15:45:03 +0200

> Currently, the process issuing a "start" command on the pktgen procfs
> interface, acquires the pktgen thread lock and never release it, until
> all pktgen threads are completed. The above can blocks indefinitely any
> other pktgen command and any (even unrelated) netdevice removal - as
> the pktgen netdev notifier acquires the same lock.
> 
> The issue is demonstrated by the following script, reported by Matteo:
> 
> ip -b - <<'EOF'
> 	link add type dummy
> 	link add type veth
> 	link set dummy0 up
> EOF
> modprobe pktgen
> echo reset >/proc/net/pktgen/pgctrl
> {
> 	echo rem_device_all
> 	echo add_device dummy0
> } >/proc/net/pktgen/kpktgend_0
> echo count 0 >/proc/net/pktgen/dummy0
> echo start >/proc/net/pktgen/pgctrl &
> sleep 1
> rmmod veth
> 
> Fix the above releasing the thread lock around the sleep call.
> 
> Additionally we must prevent racing with forcefull rmmod - as the
> thread lock no more protects from them. Instead, acquire a self-reference
> before waiting for any thread. As a side effect, running
> 
> rmmod pktgen
> 
> while some thread is running now fails with "module in use" error,
> before this patch such command hanged indefinitely.
> 
> Note: the issue predates the commit reported in the fixes tag, but
> this fix can't be applied before the mentioned commit.
> 
> v1 -> v2:
>  - no need to check for thread existence after flipping the lock,
>    pktgen threads are freed only at net exit time
>  -
> 
> Fixes: 6146e6a43b35 ("[PKTGEN]: Removes thread_{un,}lock() macros.")
> Reported-and-tested-by: Matteo Croce <mcroce@redhat.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

This looks a lot simpler.

Applied and queued up for -stable, thanks.

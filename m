Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD1FAE9446
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 01:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbfJ3A4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 20:56:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33822 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfJ3A4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 20:56:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2F202140CF89D;
        Tue, 29 Oct 2019 17:56:09 -0700 (PDT)
Date:   Tue, 29 Oct 2019 17:56:08 -0700 (PDT)
Message-Id: <20191029.175608.1379858155054625910.davem@davemloft.net>
To:     hoang.h.le@dektech.com.au
Cc:     tipc-discussion@lists.sourceforge.net, jon.maloy@ericsson.com,
        maloy@donjonn.com, eric.dumazet@gmail.com, ying.xue@windriver.com,
        netdev@vger.kernel.org
Subject: Re: [net-next v2] tipc: improve throughput between nodes in netns
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191029005121.18680-1-hoang.h.le@dektech.com.au>
References: <20191029005121.18680-1-hoang.h.le@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Oct 2019 17:56:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hoang Le <hoang.h.le@dektech.com.au>
Date: Tue, 29 Oct 2019 07:51:21 +0700

> Currently, TIPC transports intra-node user data messages directly
> socket to socket, hence shortcutting all the lower layers of the
> communication stack. This gives TIPC very good intra node performance,
> both regarding throughput and latency.
> 
> We now introduce a similar mechanism for TIPC data traffic across
> network namespaces located in the same kernel. On the send path, the
> call chain is as always accompanied by the sending node's network name
> space pointer. However, once we have reliably established that the
> receiving node is represented by a namespace on the same host, we just
> replace the namespace pointer with the receiving node/namespace's
> ditto, and follow the regular socket receive patch though the receiving
> node. This technique gives us a throughput similar to the node internal
> throughput, several times larger than if we let the traffic go though
> the full network stacks. As a comparison, max throughput for 64k
> messages is four times larger than TCP throughput for the same type of
> traffic.
> 
> To meet any security concerns, the following should be noted.
 ...
> Regarding traceability, we should notice that since commit 6c9081a3915d
> ("tipc: add loopback device tracking") it is possible to follow the node
> internal packet flow by just activating tcpdump on the loopback
> interface. This will be true even for this mechanism; by activating
> tcpdump on the involved nodes' loopback interfaces their inter-name
> space messaging can easily be tracked.
> 
> v2:
> - update 'net' pointer when node left/rejoined
> v3:
> - grab read/write lock when using node ref obj
> v4:
> - clone traffics between netns to loopback
> 
> Suggested-by: Jon Maloy <jon.maloy@ericsson.com>
> Acked-by: Jon Maloy <jon.maloy@ericsson.com>
> Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>

Applied to net-next.

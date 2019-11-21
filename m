Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E12DF105CFE
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 00:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfKUXE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 18:04:58 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55054 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfKUXE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 18:04:56 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 46557150AD820;
        Thu, 21 Nov 2019 15:04:56 -0800 (PST)
Date:   Thu, 21 Nov 2019 15:04:55 -0800 (PST)
Message-Id: <20191121.150455.995586643384214573.davem@davemloft.net>
To:     tuong.t.lien@dektech.com.au
Cc:     jon.maloy@ericsson.com, maloy@donjonn.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [net-next v3] tipc: support in-order name publication events
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191121083458.19096-1-tuong.t.lien@dektech.com.au>
References: <20191121083458.19096-1-tuong.t.lien@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 Nov 2019 15:04:56 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tuong Lien <tuong.t.lien@dektech.com.au>
Date: Thu, 21 Nov 2019 15:34:58 +0700

> It is observed that TIPC service binding order will not be kept in the
> publication event report to user if the service is subscribed after the
> bindings.
> 
> For example, services are bound by application in the following order:
> 
> Server: bound port A to {18888,66,66} scope 2
> Server: bound port A to {18888,33,33} scope 2
> 
> Now, if a client subscribes to the service range (e.g. {18888, 0-100}),
> it will get the 'TIPC_PUBLISHED' events in that binding order only when
> the subscription is started before the bindings.
> Otherwise, if started after the bindings, the events will arrive in the
> opposite order:
> 
> Client: received event for published {18888,33,33}
> Client: received event for published {18888,66,66}
> 
> For the latter case, it is clear that the bindings have existed in the
> name table already, so when reported, the events' order will follow the
> order of the rbtree binding nodes (- a node with lesser 'lower'/'upper'
> range value will be first).
> 
> This is correct as we provide the tracking on a specific service status
> (available or not), not the relationship between multiple services.
> However, some users expect to see the same order of arriving events
> irrespective of when the subscription is issued. This turns out to be
> easy to fix. We now add functionality to ensure that publication events
> always are issued in the same temporal order as the corresponding
> bindings were performed.
> 
> v2: replace the unnecessary macro - 'publication_after()' with inline
> function.
> v3: reuse 'time_after32()' instead of reinventing the same exact code.
> 
> Acked-by: Jon Maloy <jon.maloy@ericsson.com>
> Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>

Applied, thanks.

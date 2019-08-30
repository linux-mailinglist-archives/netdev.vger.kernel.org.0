Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12FB9A3F9C
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 23:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbfH3VWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 17:22:04 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42146 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728067AbfH3VWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 17:22:04 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 71B5B154FEC76;
        Fri, 30 Aug 2019 14:22:03 -0700 (PDT)
Date:   Fri, 30 Aug 2019 14:22:02 -0700 (PDT)
Message-Id: <20190830.142202.1082989152863915040.davem@davemloft.net>
To:     subashab@codeaurora.org
Cc:     netdev@vger.kernel.org, stranche@codeaurora.org
Subject: Re: [PATCH net-next] net: Fail explicit bind to local reserved
 ports
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1567049214-19804-1-git-send-email-subashab@codeaurora.org>
References: <1567049214-19804-1-git-send-email-subashab@codeaurora.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 30 Aug 2019 14:22:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Date: Wed, 28 Aug 2019 21:26:54 -0600

> Reserved ports may have some special use cases which are not suitable
> for use by general userspace applications. Currently, ports specified
> in ip_local_reserved_ports will not be returned only in case of
> automatic port assignment.
> 
> In some cases, it maybe required to prevent the host from assigning
> the ports even in case of explicit binds. Consider the case of a
> transparent proxy where packets are being redirected. In case a socket
> matches this connection, packets from this application would be
> incorrectly sent to one of the endpoints.
> 
> Add a boolean sysctl flag 'reserved_port_bind'. Default value is 1
> which preserves the existing behavior. Setting the value to 0 will
> prevent userspace applications from binding to these ports even when
> they are explicitly requested.
> 
> Cc: Sean Tranchetti <stranche@codeaurora.org>
> Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>

I don't know how happy I am about this.  Whatever sets up the transparent
proxy business can block any attempt to communicate over these ports.

Also, protocols like SCTP need the new handling too.

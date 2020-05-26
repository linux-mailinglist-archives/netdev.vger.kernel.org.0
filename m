Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DAB71E23D0
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 16:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729101AbgEZOQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 10:16:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49646 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726809AbgEZOQ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 10:16:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZEZ1+yG3T0vEd58X58pERPcfzN4dbTvcTqCMRc8b9RQ=; b=mwjDL+wWgCxatP4XIvGOhsucBR
        sYYetvGOeYtDiCDaYnPMf19gGi5la/8GEIhcC3Me4+QEzKqUEPzQ8E2INyTB3j6c8qBAew7S/s4g3
        Yr6FjMBwCT5Re5vMGbX/NZ4MqVfNEmWtY8VJFGpTnXQwMYyiIMn+3pRNonmA+TDQxhQI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jdaNB-003HxR-V6; Tue, 26 May 2020 16:16:05 +0200
Date:   Tue, 26 May 2020 16:16:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>
Cc:     kvm@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Emanuele Giuseppe Esposito <e.emanuelegiuseppe@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Jonathan Adams <jwadams@google.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 7/7] [not for merge] netstats: example use of stats_fs
 API
Message-ID: <20200526141605.GJ768009@lunn.ch>
References: <20200526110318.69006-1-eesposit@redhat.com>
 <20200526110318.69006-8-eesposit@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526110318.69006-8-eesposit@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 01:03:17PM +0200, Emanuele Giuseppe Esposito wrote:
> Apply stats_fs on the networking statistics subsystem.
> 
> Currently it only works with disabled network namespace
> (CONFIG_NET_NS=n), because multiple namespaces will have the same
> device name under the same root source that will cause a conflict in
> stats_fs.

Hi Emanuele

How do you atomically get and display a group of statistics?

If you look at how the netlink socket works, you will see code like:

                do {
                        start = u64_stats_fetch_begin_irq(&cpu_stats->syncp);
                        rx_packets = cpu_stats->rx_packets;
                        rx_bytes = cpu_stats->rx_bytes;
			....
                } while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));

It will ensure that rx_packets and rx_bytes are consistent with each
other. If the value of the sequence counter changes while inside the
loop, the loop so repeated until it does not change.

In general, hardware counters in NICs are the same.  You tell it to
take a snapshot of the statistics counters, and then read them all
back, to give a consistent view across all the statistics.

I've not looked at this new code in detail, but it looks like you have
one file per statistic, and assume each statistic is independent of
every other statistic. This independence can limit how you use the
values, particularly when debugging. The netlink interface we use does
not have this limitation.

	     Andrew

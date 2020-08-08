Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D20FE23F5E4
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 04:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgHHCGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 22:06:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47030 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726262AbgHHCGV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Aug 2020 22:06:21 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k4EFV-008g5y-NR; Sat, 08 Aug 2020 04:06:17 +0200
Date:   Sat, 8 Aug 2020 04:06:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jonathan Adams <jwadams@google.com>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [RFC PATCH 0/7] metricfs metric file system and examples
Message-ID: <20200808020617.GD2028541@lunn.ch>
References: <20200807212916.2883031-1-jwadams@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200807212916.2883031-1-jwadams@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> net/dev/stats/tx_bytes/annotations
>   DESCRIPTION net\ device\ transmited\ bytes\ count
>   CUMULATIVE
> net/dev/stats/tx_bytes/fields
>   interface value
>   str int
> net/dev/stats/tx_bytes/values
>   lo 4394430608
>   eth0 33353183843
>   eth1 16228847091

This is a rather small system. Have you tested it at scale? An
Ethernet switch with 64 physical interfaces, and say 32 VLAN
interfaces stack on top. So this one file will contain 2048 entries?

And generally, you are not interested in one statistic, but many
statistics. So you will need to cat each file, not just one file. And
the way this is implemented:

+static void dev_stats_emit(struct metric_emitter *e,
+                          struct net_device *dev,
+                          struct metric_def *metricd)
+{
+       struct rtnl_link_stats64 temp;
+       const struct rtnl_link_stats64 *stats = dev_get_stats(dev, &temp);
+
+       if (stats) {
+               __u8 *ptr = (((__u8 *)stats) + metricd->off);
+
+               METRIC_EMIT_INT(e, *(__u64 *)ptr, dev->name, NULL);
+       }
+}

means you are going to be calling dev_get_stats() for each file, and
there are 23 files if i counted correctly. So dev_get_stats() will be
called 47104 times, in this made up example. And this is not always
cheap, these counts can be atomic.

So i personally don't think netdev statistics is a good idea, i doubt
it scales.

I also think you are looking at the wrong set of netdev counters. I
would be more interested in ethtool -S counters. But it appears you
make the assumption that each object you are collecting metrics for
has the same set of counters. This is untrue for network interfaces,
where each driver can export whatever counters it wants, and they can
be dynamic.

	Andrew

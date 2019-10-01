Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64CC1C2F4E
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 10:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733230AbfJAIxG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 1 Oct 2019 04:53:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54828 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726672AbfJAIxG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 04:53:06 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A965D10C0933;
        Tue,  1 Oct 2019 08:53:05 +0000 (UTC)
Received: from [10.36.116.181] (ovpn-116-181.ams2.redhat.com [10.36.116.181])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D29D5C219;
        Tue,  1 Oct 2019 08:53:04 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     xiangxia.m.yue@gmail.com, "ovs dev" <dev@openvswitch.org>
Cc:     gvrose8192@gmail.com, pshelar@ovn.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/9] optimize openvswitch flow looking up
Date:   Tue, 01 Oct 2019 10:53:02 +0200
Message-ID: <12EAB90C-827E-4BC5-8CED-08DA510CF566@redhat.com>
In-Reply-To: <1569777006-7435-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1569777006-7435-1-git-send-email-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Tue, 01 Oct 2019 08:53:05 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Interesting performance gain, copied in the OVS development mailing 
list.

//Eelco

On 29 Sep 2019, at 19:09, xiangxia.m.yue@gmail.com wrote:

> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> This series patch optimize openvswitch.
>
> Patch 1, 2, 4: Port Pravin B Shelar patches to
> linux upstream with little changes.
>
> Patch 5, 6, 7: Optimize the flow looking up and
> simplify the flow hash.
>
> Patch 8: is a bugfix.
>
> The performance test is on Intel Xeon E5-2630 v4.
> The test topology is show as below:
>
> +-----------------------------------+
> |   +---------------------------+   |
> |   | eth0   ovs-switch    eth1 |   | Host0
> |   +---------------------------+   |
> +-----------------------------------+
>       ^                       |
>       |                       |
>       |                       |
>       |                       |
>       |                       v
> +-----+----+             +----+-----+
> | netperf  | Host1       | netserver| Host2
> +----------+             +----------+
>
> We use netperf send the 64B frame, and insert 255+ flow-mask:
> $ ovs-dpctl add-flow ovs-switch 
> "in_port(1),eth(dst=00:01:00:00:00:00/ff:ff:ff:ff:ff:01),eth_type(0x0800),ipv4(frag=no)" 
> 2
> ...
> $ ovs-dpctl add-flow ovs-switch 
> "in_port(1),eth(dst=00:ff:00:00:00:00/ff:ff:ff:ff:ff:ff),eth_type(0x0800),ipv4(frag=no)" 
> 2
> $ netperf -t UDP_STREAM -H 2.2.2.200 -l 40 -- -m 18
>
> * Without series patch, throughput 8.28Mbps
> * With series patch, throughput 46.05Mbps
>
> Tonghao Zhang (9):
>   net: openvswitch: add flow-mask cache for performance
>   net: openvswitch: convert mask list in mask array
>   net: openvswitch: shrink the mask array if necessary
>   net: openvswitch: optimize flow mask cache hash collision
>   net: openvswitch: optimize flow-mask looking up
>   net: openvswitch: simplify the flow_hash
>   net: openvswitch: add likely in flow_lookup
>   net: openvswitch: fix possible memleak on destroy flow table
>   net: openvswitch: simplify the ovs_dp_cmd_new
>
>  net/openvswitch/datapath.c   |  63 +++++----
>  net/openvswitch/flow.h       |   1 -
>  net/openvswitch/flow_table.c | 318 
> +++++++++++++++++++++++++++++++++++++------
>  net/openvswitch/flow_table.h |  19 ++-
>  4 files changed, 330 insertions(+), 71 deletions(-)
>
> -- 
> 1.8.3.1

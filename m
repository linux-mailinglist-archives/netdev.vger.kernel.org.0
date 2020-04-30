Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4566D1BF915
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 15:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgD3NSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 09:18:22 -0400
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:62689 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726842AbgD3NSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 09:18:21 -0400
Received: (qmail 29538 invoked from network); 30 Apr 2020 15:18:19 +0200
X-Fcrdns: No
Received: from phoffice.de-nserver.de (HELO [10.242.2.21]) (185.39.223.5)
  (smtp-auth username hostmaster@profihost.com, mechanism plain)
  by cloud1-vm154.de-nserver.de (qpsmtpd/0.92) with (ECDHE-RSA-AES256-GCM-SHA384 encrypted) ESMTPSA; Thu, 30 Apr 2020 15:18:19 +0200
X-GeoIP-Country: DE
Subject: Re: BUG: soft lockup while deleting tap interface from vlan aware
 bridge
To:     Ido Schimmel <idosch@idosch.org>
Cc:     roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        davem@davemloft.net,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>, netdev@vger.kernel.org
References: <85b1e301-8189-540b-b4bf-d0902e74becc@profihost.ag>
 <20200430105551.GA4068275@splinter>
From:   Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <8be48925-4e09-fe9c-6d8c-8675ede5fce7@profihost.ag>
Date:   Thu, 30 Apr 2020 15:18:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200430105551.GA4068275@splinter>
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by hostmaster@profihost.com through 185.39.223.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

uck (Vorsitzender)

Am 30.04.20 um 12:55 schrieb Ido Schimmel:
> On Wed, Apr 29, 2020 at 10:52:35PM +0200, Stefan Priebe - Profihost AG wrote:
>> Hello,
>>
>> while running a stable vanilla kernel 4.19.115 i'm reproducably get this
>> one:
>>
>> watchdog: BUG: soft lockup - CPU#38 stuck for 22s! [bridge:3570653]
>>
>> ...
>>
>> Call
>> Trace:nbp_vlan_delete+0x59/0xa0br_vlan_info+0x66/0xd0br_afspec+0x18c/0x1d0br_dellink+0x74/0xd0rtnl_bridge_dellink+0x110/0x220rtnetlink_rcv_msg+0x283/0x360
> 
> Nik, Stefan,
> 
> My theory is that 4K VLANs are deleted in a batch and preemption is
> disabled (please confirm). For each VLAN the kernel needs to go over the
> entire FDB and delete affected entries. If the FDB is very large or the
> FDB lock is contended this can cause the kernel to loop for more than 20
> seconds without calling schedule().
> 
> To reproduce I added mdelay(100) in br_fdb_delete_by_port() and ran
> this:
> 
> ip link add name br10 up type bridge vlan_filtering 1
> ip link add name dummy10 up type dummy
> ip link set dev dummy10 master br10
> bridge vlan add vid 1-4094 dev dummy10 master
> bridge vlan del vid 1-4094 dev dummy10 master
> 
> Got a similar trace to Stefan's. Seems to be fixed by attached:
> 
> diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
> index a774e19c41bb..240e260e3461 100644
> --- a/net/bridge/br_netlink.c
> +++ b/net/bridge/br_netlink.c
> @@ -615,6 +615,7 @@ int br_process_vlan_info(struct net_bridge *br,
>                                                v - 1, rtm_cmd);
>                                 v_change_start = 0;
>                         }
> +                       cond_resched();
>                 }
>                 /* v_change_start is set only if the last/whole range changed */
>                 if (v_change_start)
> 
> WDYT?

Great! This indeed solves the problem.

Stefan


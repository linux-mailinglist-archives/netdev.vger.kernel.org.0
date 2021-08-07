Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2FCE3E376F
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 00:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbhHGWmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 18:42:35 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:33120
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229537AbhHGWme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 18:42:34 -0400
Received: from famine.localdomain (1.general.jvosburgh.us.vpn [10.172.68.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id E0A7A3F043;
        Sat,  7 Aug 2021 22:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1628376136;
        bh=G9duVisYT1xEcW17Z4N6y/MIlXkHahKN2T7r/8xAxHg=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=IoyX9VPYzhDyXMBcKeLSoqGC+GtiqqnhgRacncza7TxLNsLP4Ttxcwk47qF+01sRS
         ZoPFBbBgWBnL0rOggSWGX0bIjwGWeTKnw1d3Kac8e25q4BOqo9veGopEJrta2/sApj
         MSfcTSCD6ZWtiq4if8XxQ1OtNAx4z8mngWtV06ItXVZ/hOMTWDEVBoGg3FiBWUx7h4
         qCltsWChCv7u/uI477bkmtilZvz+tltbn/dUfzgeBeelXrfvv+vTNC0QG3gTdSb4Ir
         5eB323XFMX+aSRKfo9w3w36ZHJRK9lhlgyxCfsOL+QKQ1z6xAfmU7AQXUYFXT5Cg2o
         iRHEafqhloMdw==
Received: by famine.localdomain (Postfix, from userid 1000)
        id 35F8A5FDD5; Sat,  7 Aug 2021 15:42:14 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 2D0E59FAC3;
        Sat,  7 Aug 2021 15:42:14 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: bonding: link state question
In-reply-to: <020577f3-763d-48fd-73ce-db38c3c7fdf9@redhat.com>
References: <020577f3-763d-48fd-73ce-db38c3c7fdf9@redhat.com>
Comments: In-reply-to Jonathan Toppins <jtoppins@redhat.com>
   message dated "Sat, 07 Aug 2021 17:26:34 -0400."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <22625.1628376134.1@famine>
Date:   Sat, 07 Aug 2021 15:42:14 -0700
Message-ID: <22626.1628376134@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonathan Toppins <jtoppins@redhat.com> wrote:

>Is there any reason why bonding should have an operstate of up when none
>of its slaves are in an up state? In this particular scenario it seems
>like the bonding device should at least assert NO-CARRIER, thoughts?
>
>$ ip -o -d link show | grep "bond5"
>2: enp0s31f6: <NO-CARRIER,BROADCAST,MULTICAST,SLAVE,UP> mtu 1500 qdisc
>fq_codel master bond5 state DOWN mode DEFAULT group default qlen 1000\
>link/ether 8c:8c:aa:f8:62:16 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 68
>maxmtu 9000 \    bond_slave state ACTIVE mii_status UP link_failure_count
>0 perm_hwaddr 8c:8c:aa:f8:62:16 queue_id 0 numtxqueues 1 numrxqueues 1
>gso_max_size 65536 gso_max_segs 65535
>41: bond5: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue
>state UP mode DEFAULT group default qlen 1000\    link/ether
>8c:8c:aa:f8:62:16 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 68 maxmtu
>65535 \    bond mode balance-xor miimon 0 updelay 0 downdelay 0
>peer_notify_delay 0 use_carrier 1 arp_interval 0 arp_validate none

	I'm going to speculate that your problem is that miimon and
arp_interval are both 0, and the bond then doesn't have any active
mechanism to monitor the link state of its interfaces.  There might be a
warning in dmesg to this effect.

	Do you see what you'd consider to be correct behavior if miimon
is set to 100?

	-J
	
>arp_all_targets any primary_reselect always fail_over_mac none
>xmit_hash_policy layer2 resend_igmp 1 num_grat_arp 1 all_slaves_active 0
>min_links 0 lp_interval 1 packets_per_slave 1 lacp_rate slow ad_select
>stable tlb_dynamic_lb 1 numtxqueues 16 numrxqueues 16 gso_max_size 65536
>gso_max_segs 65535
>
>$ cat /sys/class/net/enp0s31f6/operstate
>down
>
>$ cat /sys/class/net/bond5/operstate
>up
>
>This is an older kernel (4.18.0-305.7.1.el8_4.x86_64) but I do not see any
>changes upstream that would indicate a change in this operation.
>
>Thanks,
>-Jon

---
	-Jay Vosburgh, jay.vosburgh@canonical.com

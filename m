Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3A541D9A71
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 16:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728968AbgESOx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 10:53:57 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:56546 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727904AbgESOx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 10:53:56 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04JErjRj129496;
        Tue, 19 May 2020 09:53:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1589900025;
        bh=Xp+6mRG+txeiaoUM/vnEKlmryO/oJiJW2WfO1OB1hXk=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=IQFtqNmiW9FQxRieiH0ZXdTwjv13TPVC0+o/0MH8Bz9chOV07zz9RIK4emPXDdgGD
         5pefySVpNc5MgTc8Y7IERePvDBaFPykUmGvGoTgcpt0anKwnzt0GcSH7igRqv9vNVs
         VMO0xc2w6qizWdm6wMENJScEDyYURF1gDK/oPQKY=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04JErjB5082138
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 May 2020 09:53:45 -0500
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 19
 May 2020 09:53:44 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 19 May 2020 09:53:45 -0500
Received: from [10.250.74.234] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04JErhip050463;
        Tue, 19 May 2020 09:53:43 -0500
Subject: Re: [next-queue RFC 0/4] ethtool: Add support for frame preemption
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        <intel-wired-lan@lists.osuosl.org>
CC:     <jeffrey.t.kirsher@intel.com>, <netdev@vger.kernel.org>,
        <vladimir.oltean@nxp.com>, <po.liu@nxp.com>,
        <Jose.Abreu@synopsys.com>
References: <20200516012948.3173993-1-vinicius.gomes@intel.com>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <b33e582f-e0e6-467a-636a-674322108855@ti.com>
Date:   Tue, 19 May 2020 10:53:42 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200516012948.3173993-1-vinicius.gomes@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinicius,

On 5/15/20 9:29 PM, Vinicius Costa Gomes wrote:
> Hi,
> 
> This series adds support for configuring frame preemption, as defined
> by IEEE 802.1Q-2018 (previously IEEE 802.1Qbu) and IEEE 802.3br.
> 
> Frame preemption allows a packet from a higher priority queue marked
> as "express" to preempt a packet from lower priority queue marked as
> "preemptible". The idea is that this can help reduce the latency for
> higher priority traffic.
> 
> Previously, the proposed interface for configuring these features was
> using the qdisc layer. But as this is very hardware dependent and all
> that qdisc did was pass the information to the driver, it makes sense
> to have this in ethtool.
> 
> One example, for retrieving and setting the configuration:
> 
> $ ethtool $ sudo ./ethtool --show-frame-preemption enp3s0
> Frame preemption settings for enp3s0:
> 	support: supported
> 	active: active
> 	supported queues: 0xf

I assume this is will be in sync with ethtool -L output which indicates
how many tx h/w queues present? I mean if there are 8 h/w queues,
supported queues will show 0xff.

> 	supported queues: 0xe
 From the command below, it appears this is the preemptible queue mask.
bit 0  is Q0, bit 1 Q1 and so forth. Right? In that case isn't it more
clear to display
         preemptible queues : 0xef

In the above Q7 is express queue and Q6-Q0 are preemptible.

Also there is a handshake called verify that happens which initiated
by the h/w to check the capability of peer. It looks like
not all vendor's hardware supports it and good to have it displayed
something like

         Verify supported/{not supported}

If Verify is supported, FPE is enabled only if it succeeds. So may be
good to show a status of Verify if it is supported something like
         Verify success/Failed

> 	minimum fragment size: 68
> 
> 
> $ ethtool --set-frame-preemption enp3s0 fp on min-frag-size 68 preemptible-queues-mask 0xe
> 
> This is a RFC because I wanted to have feedback on some points:
> 
>    - The parameters added are enough for the hardware I have, is it
>      enough in general?

As described above, it would be good to add an optional parameter for
verify

ethtool --set-frame-preemption enp3s0 fp on min-frag-size 68 
preemptible-queues-mask 0xe verify on

> 
>    - even with the ethtool via netlink effort, I chose to keep the
>      ioctl() way, in case someone wants to backport this to an older
>      kernel, is there a problem with this?
> 
>    - Some space for bikeshedding the names and location (for example,
>      does it make sense for these settings to be per-queue?), as I am
>      not quite happy with them, one example, is the use of preemptible
>      vs. preemptable;
> 
> 
> About the patches, should be quite straightforward:
> 
> Patch 1, adds the ETHTOOL_GFP and ETHOOL_SFP commands and the
> associated data structures;
> 
> Patch 2, adds the ETHTOOL_MSG_PREEMPT_GET and ETHTOOL_MSG_PREEMPT_SET
> netlink messages and the associated attributes;
> 
> Patch 3, is the example implementation for the igc driver, the catch
> here is that frame preemption in igc is dependent on the TSN "mode"
> being enabled;
> 
> Patch 4, adds some registers that helped during implementation.
> 
> Another thing is that because igc is still under development, to avoid
> conflicts, I think it might be easier for the PATCH version of this
> series to go through Jeff Kirsher's tree.
> 
> Vinicius Costa Gomes (4):
>    ethtool: Add support for configuring frame preemption
>    ethtool: Add support for configuring frame preemption via netlink
>    igc: Add support for configuring frame preemption
>    igc: Add support for exposing frame preemption stats registers
> 
>   drivers/net/ethernet/intel/igc/igc.h         |   3 +
>   drivers/net/ethernet/intel/igc/igc_defines.h |   6 +
>   drivers/net/ethernet/intel/igc/igc_ethtool.c |  77 ++++++++
>   drivers/net/ethernet/intel/igc/igc_regs.h    |  10 +
>   drivers/net/ethernet/intel/igc/igc_tsn.c     |  46 ++++-
>   include/linux/ethtool.h                      |   6 +
>   include/uapi/linux/ethtool.h                 |  25 +++
>   include/uapi/linux/ethtool_netlink.h         |  19 ++
>   net/ethtool/Makefile                         |   3 +-
>   net/ethtool/ioctl.c                          |  36 ++++
>   net/ethtool/netlink.c                        |  15 ++
>   net/ethtool/netlink.h                        |   2 +
>   net/ethtool/preempt.c                        | 181 +++++++++++++++++++
>   13 files changed, 423 insertions(+), 6 deletions(-)
>   create mode 100644 net/ethtool/preempt.c
> 

-- 
Murali Karicheri
Texas Instruments

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D844B67D549
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 20:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231989AbjAZTVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 14:21:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231774AbjAZTVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 14:21:19 -0500
Received: from mx14lb.world4you.com (mx14lb.world4you.com [81.19.149.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC0954209
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 11:21:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ejEeaq8gImJUBi3su+p7gUGjJ36IATdYZqLQuwvqY2A=; b=AWYEEvaLh1JyLc//ZoPsxsg6qb
        eIuLnVrfwoFZSHtlnaG6TddX5d1LqKvZhGMKM1eT2CetXua8EzaeuyQNm0FEJmGe0x2F25jDrtY9V
        tXzF1yTBKP+5B7L6jMmoGuKqu9IHcEGGKRSicA8PUNNTGuPSmLYsDs6EF8+jQJ6sfTXE=;
Received: from [88.117.49.184] (helo=[10.0.0.160])
        by mx14lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pL7oC-0002gj-4m; Thu, 26 Jan 2023 20:21:16 +0100
Message-ID: <448dd952-be53-6930-c7fb-fc3474ce17f7@engleder-embedded.com>
Date:   Thu, 26 Jan 2023 20:21:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 net-next 15/15] net/sched: taprio: only calculate gate
 mask per TXQ for igc, stmmac and tsnep
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Roger Quadros <rogerq@kernel.org>
References: <20230126125308.1199404-1-vladimir.oltean@nxp.com>
 <20230126125308.1199404-16-vladimir.oltean@nxp.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <20230126125308.1199404-16-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.01.23 13:53, Vladimir Oltean wrote:
> There are 2 classes of in-tree drivers currently:
> 
> - those who act upon struct tc_taprio_sched_entry :: gate_mask as if it
>    holds a bit mask of TXQs
> 
> - those who act upon the gate_mask as if it holds a bit mask of TCs
> 
> When it comes to the standard, IEEE 802.1Q-2018 does say this in the
> second paragraph of section 8.6.8.4 Enhancements for scheduled traffic:
> 
> | A gate control list associated with each Port contains an ordered list
> | of gate operations. Each gate operation changes the transmission gate
> | state for the gate associated with each of the Port's traffic class
> | queues and allows associated control operations to be scheduled.
> 
> In typically obtuse language, it refers to a "traffic class queue"
> rather than a "traffic class" or a "queue". But careful reading of
> 802.1Q clarifies that "traffic class" and "queue" are in fact
> synonymous (see 8.6.6 Queuing frames):
> 
> | A queue in this context is not necessarily a single FIFO data structure.
> | A queue is a record of all frames of a given traffic class awaiting
> | transmission on a given Bridge Port. The structure of this record is not
> | specified.
> 
> i.o.w. their definition of "queue" isn't the Linux TX queue.
> 
> The gate_mask really is input into taprio via its UAPI as a mask of
> traffic classes, but taprio_sched_to_offload() converts it into a TXQ
> mask.
> 
> The breakdown of drivers which handle TC_SETUP_QDISC_TAPRIO is:
> 
> - hellcreek, felix, sja1105: these are DSA switches, it's not even very
>    clear what TXQs correspond to, other than purely software constructs.
>    For felix and sja1105, I can confirm that only the mqprio
>    configuration with 8 TCs and 1 TXQ per TC makes sense. So it's fine to
>    convert these to a gate mask per TC.
> 
> - enetc: I have the hardware and can confirm that the gate mask is per
>    TC, and affects all TXQs (BD rings) configured for that priority.
> 
> - igc: in igc_save_qbv_schedule(), the gate_mask is clearly interpreted
>    to be per-TXQ.
> 
> - tsnep: Gerhard Engleder clarifies that even though this hardware
>    supports at most 1 TXQ per TC, the TXQ indices may be different from
>    the TC values themselves, and it is the TXQ indices that matter to
>    this hardware. So keep it per-TXQ as well.
> 
> - stmmac: I have a GMAC datasheet, and in the EST section it does
>    specify that the gate events are per TXQ rather than per TC.
> 
> - lan966x: again, this is a switch, and while not a DSA one, the way in
>    which it implements lan966x_mqprio_add() - by only allowing num_tc ==
>    NUM_PRIO_QUEUES (8) - makes it clear to me that TXQs are a purely
>    software construct here as well. They seem to map 1:1 with TCs.
> 
> - am65_cpsw: from looking at am65_cpsw_est_set_sched_cmds(), I get the
>    impression that the fetch_allow variable is treated like a prio_mask.
>    I haven't studied this driver's interpretation of the prio_tc_map, but
>    that definitely sounds closer to a per-TC gate mask rather than a
>    per-TXQ one.
> 
> Based on this breakdown, we have 6 drivers with a gate mask per TC and
> 3 with a gate mask per TXQ. So let's make the gate mask per TXQ the
> opt-in and the gate mask per TC the default.
> 
> Benefit from the TC_QUERY_CAPS feature that Jakub suggested we add, and
> query the device driver before calling the proper ndo_setup_tc(), and
> figure out if it expects one or the other format.
> 
> Cc: Gerhard Engleder <gerhard@engleder-embedded.com>
> Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
> Cc: Siddharth Vadapalli <s-vadapalli@ti.com>
> Cc: Roger Quadros <rogerq@kernel.org>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> v1->v2:
> - rewrite commit message
> - also opt in stmmac and tsnep
> 
>   drivers/net/ethernet/engleder/tsnep_tc.c      | 21 +++++++++++++++++
>   drivers/net/ethernet/intel/igc/igc_main.c     | 23 +++++++++++++++++++
>   drivers/net/ethernet/stmicro/stmmac/hwif.h    |  5 ++++
>   .../net/ethernet/stmicro/stmmac/stmmac_main.c |  2 ++
>   .../net/ethernet/stmicro/stmmac/stmmac_tc.c   | 20 ++++++++++++++++
>   include/net/pkt_sched.h                       |  1 +
>   net/sched/sch_taprio.c                        | 11 ++++++---
>   7 files changed, 80 insertions(+), 3 deletions(-)

Reviewed-by: Gerhard Engleder <gerhard@engleder-embedded.com>

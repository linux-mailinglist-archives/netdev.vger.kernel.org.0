Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3B1117BE12
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 14:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbgCFNQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 08:16:52 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:40086 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727420AbgCFNQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 08:16:51 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id B5E11B40066;
        Fri,  6 Mar 2020 13:16:49 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 6 Mar 2020
 13:16:43 +0000
Subject: Re: [PATCH net-next ct-offload 03/13] net/sched: act_ct: Support
 restoring conntrack info on skbs
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "Oz Shlomo" <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
References: <1583422468-8456-1-git-send-email-paulb@mellanox.com>
 <1583422468-8456-4-git-send-email-paulb@mellanox.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <7b4bb63d-45f5-b28b-f866-a097d20ae743@solarflare.com>
Date:   Fri, 6 Mar 2020 13:16:39 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1583422468-8456-4-git-send-email-paulb@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25272.003
X-TM-AS-Result: No-4.498200-8.000000-10
X-TMASE-MatchedRID: cgbqQT5W8hfmLzc6AOD8DfHkpkyUphL9KVrLOZD1BXTalJpeFb3A2AFK
        sDvaUiE9eQ8wqj0st8gnLbsRZ9x5rbSE7PNgMH4zboe6sMfg+k9MkOX0UoduudMgOgDPfBRBOCm
        WTd46rCtfZFtAHjMlfeWhkySRNzxeGPamHQPn1a/iHyvyXeXh5kN+63YtzViHbU3ap6VxJeO5eO
        bVN4lfLOfOVcxjDhcwPcCXjNqUmkVYF3qW3Je6+2j6dlbIi2G8FnITci13gkdVjcJV4lXN0CMnn
        NI51KsVJXg3j5wkMr8Om+MSnqRnQ5cNsbVzy/MQlUtYtenA9AUSIT+2UK/v6OLKSdg00bhSwnkJ
        dHfng2NiAByU1U+JwyIWVLG977WGvjDNqsQ/AWV+3BndfXUhXQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.498200-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25272.003
X-MDID: 1583500610-ta6tpq2V8uKU
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/03/2020 15:34, Paul Blakey wrote:
> Provide an API to restore the ct state pointer.
>
> This may be used by drivers to restore the ct state if they
> miss in tc chain after they already did the hardware connection
> tracking action (ct_metadata action).
>
> For example, consider the following rule on chain 0 that is in_hw,
> however chain 1 is not_in_hw:
>
> $ tc filter add dev ... chain 0 ... \
>   flower ... action ct pipe action goto chain 1
>
> Packets of a flow offloaded (via nf flow table offload) by the driver
> hit this rule in hardware, will be marked with the ct metadata action
> (mark, label, zone) that does the equivalent of the software ct action,
> and when the packet jumps to hardware chain 1, there would be a miss.
>
> CT was already processed in hardware. Therefore, the driver's miss
> handling should restore the ct state on the skb, using the provided API,
> and continue the packet processing in chain 1.
IMNSHO this demonstrates why hardware should do all-or-nothingoffload,
 in the cases where it can't perform the whole filtering it should
 provide the unmodified packet so that SW can start over from a clean
 state.
But as long as these epicycles don't affect drivers for such HW, I guess
 I can't object too hard to them being added.

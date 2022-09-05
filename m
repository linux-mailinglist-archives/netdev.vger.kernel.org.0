Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 212065ACCF4
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 09:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236737AbiIEHal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 03:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235747AbiIEHa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 03:30:28 -0400
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F20EAE01E;
        Mon,  5 Sep 2022 00:29:47 -0700 (PDT)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 0A9AF20E7;
        Mon,  5 Sep 2022 09:29:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1662362985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mt2TCABaZbctvCsgPB/Zw6wsSOx4LeE3rO4QM7vyWRY=;
        b=UlnuYzusGTpCpPqquL4ehfEGFzpjMcfUhtoM0KhmiSr70aYXP/V+ahAMEzN3YZxw5/+q9c
        o3ubtmMyIHnBb3bv/JlT7H2Sr4sB4N9XAFJe7BXmACET9iF9xGfsTk5sSUrAu7N+3s5Qtw
        rBoxbYIYgzzyyVP+yfbeMyVmGv9q3VpthBGUToyG7jLsbc2SeJORrhCAuTNtlLk6/1rnoN
        yycPlQgObLBeEYY38HKFRrAXox3iuKqlSP2JB6nwqSCW6n1EqNoabAvwGxPn5VkfQ/HOoV
        h+Q6gT8eMSslpTTrpU787Yr2D+3m+PFMNSp1Is68mLLEBwb3S4C6fVJJtzih5g==
MIME-Version: 1.0
Date:   Mon, 05 Sep 2022 09:29:44 +0200
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/3] net: dsa: felix: allow small tc-taprio windows to
 send at least some packets
In-Reply-To: <20220902215702.3895073-2-vladimir.oltean@nxp.com>
References: <20220902215702.3895073-1-vladimir.oltean@nxp.com>
 <20220902215702.3895073-2-vladimir.oltean@nxp.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <3fc12b67842d87a2fb8a5941c899c529@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Am 2022-09-02 23:57, schrieb Vladimir Oltean:
> The blamed commit broke tc-taprio schedules such as this one:
> 
> tc qdisc replace dev $swp1 root taprio \
> 	num_tc 8 \
> 	map 0 1 2 3 4 5 6 7 \
> 	queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
> 	base-time 0 \
> 	sched-entry S 0x7f 990000 \
> 	sched-entry S 0x80  10000 \
> 	flags 0x2
> 
> because the gate entry for TC 7 (S 0x80 10000 ns) now has a static 
> guard
> band added earlier than its 'gate close' event, such that packet
> overruns won't occur in the worst case of the largest packet possible.
> 
> Since guard bands are statically determined based on the per-tc
> QSYS_QMAXSDU_CFG_* with a fallback on the port-based QSYS_PORT_MAX_SDU,
> we need to discuss depending on kernel version, since the driver, prior
> to commit 55a515b1f5a9 ("net: dsa: felix: drop oversized frames with
> tc-taprio instead of hanging the port"), did not touch
> QSYS_QMAXSDU_CFG_*, and therefore relied on QSYS_PORT_MAX_SDU.
> 
> 1 (before vsc9959_tas_guard_bands_update): QSYS_PORT_MAX_SDU defaults 
> to
>   1518, and at gigabit this introduces a static guard band (independent
>   of packet sizes) of 12144 ns. But this is larger than the time window
>   itself, of 10000 ns. So, the queue system never considers a frame 
> with
>   TC 7 as eligible for transmission, since the gate practically never
>   opens, and these frames are forever stuck in the TX queues and hang
>   the port.

IIRC we deliberately ignored that problem back then, because we couldn't
set the maxsdu.

> 2 (after vsc9959_tas_guard_bands_update): We make an effort to set
>   QSYS_QMAXSDU_CFG_7 to 1230 bytes, and this enables oversized frame
>   dropping for everything larger than that. But QSYS_QMAXSDU_CFG_7 
> plays
>   2 roles. One is oversized frame dropping, the other is the per-tc
>   static guard band. When we calculated QSYS_QMAXSDU_CFG_7 to be 1230,
>   we considered no guard band at all, and the entire time window
>   available for transmission, which is not the case. The larger
>   QSYS_QMAXSDU_CFG_7 is, the larger the static guard band for the tc 
> is,
>   too.
> 
> In both cases, frames with any size (even 60 bytes sans FCS) are stuck
> on egress rather than being considered for scheduling on TC 7, even if
> they fit. This is because the static guard band is way too large.
> Considering the current situation, with 
> vsc9959_tas_guard_bands_update(),
> frames between 60 octets and 1230 octets in size are not eligible for
> oversized dropping (because they are smaller than QSYS_QMAXSDU_CFG_7),
> but won't be considered as eligible for scheduling either, because the
> min_gate_len[7] (10000 ns) - the guard band determined by
> QSYS_QMAXSDU_CFG_7 (1230 octets * 8 ns per octet == 9840 ns) is smaller
> than their transmit time.
> 
> A solution that is quite outrageous is to limit the minimum valid gate
> interval acceptable through tc-taprio, such that intervals, when
> transformed into L1 frame bit times, are never smaller than twice the
> MTU of the interface. However, the tc-taprio UAPI operates in ns, and
> the link speed can change at runtime (to 10 Mbps, where the 
> transmission
> time of 1 octet is 800 ns). And since the max MTU is around 9000, we'd
> have to limit the tc-taprio intervals to be no smaller than 14.4 ms on
> the premise that it is possible for the link to renegotiate to 10 Mbps,
> which is astonishingly limiting for real use cases, where the entire
> *cycle* (here we're talking about a single interval) must be 100 us or
> lower.
> 
> The solution is to modify vsc9959_tas_guard_bands_update() to take into
> account that the static per-tc guard bands consume time out of our time
> window too, not just packet transmission. The unknown which needs to be
> determined is the max admissible frame size. Both the useful bit time
> and the guard band size will depend on this unknown variable, so
> dividing the available 10000 ns into 2 halves sounds like the ideal
> strategy. In this case, we will program QSYS_QMAXSDU_CFG_7 with a
> maximum frame length (and guard band size) of 605 octets (this includes
> FCS but not IPG and preamble/SFD). With this value, everything of L2
> size 601 (sans FCS) and higher is considered as oversized, and the 
> guard
> band is low enough (605 + HSCH_MISC.FRM_ADJ, at 1Gbps => 5000 ns) in
> order to not disturb the scheduling of any frame smaller than L2 size 
> 601.

So one drawback with this is that you limit the maxsdu to match a
frame half of the gate open time, right?

The switch just schedule the *start* event of the frame. So even if
the guard band takes 99% of the gate open time, it should be able
to send a frame regardless of it's length during the first 1% of
the period (and it doesn't limit the maxsdu by half). IIRC the guard
band is exactly for that, that is that you don't know the frame
length and you can still schedule the frame. I know of switches
which don't use a guard band but know the exact length and the
closing time of the queue and deduce by that if the frame can
still be queued.

Actually, I'd expect it to work after your 
vsc9959_tas_guard_bands_update.
Hmm.

To quote from you above:
> min_gate_len[7] (10000 ns) - the guard band determined by
> QSYS_QMAXSDU_CFG_7 (1230 octets * 8 ns per octet == 9840 ns) is smaller
> than their transmit time.

Are you sure this is the case? There should be 160ns time to
schedule the start of the frame. Maybe the 160ns is just too
small.

-michael

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A46665ADB8D
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 00:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231868AbiIEWxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 18:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiIEWxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 18:53:23 -0400
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD74696FE;
        Mon,  5 Sep 2022 15:53:22 -0700 (PDT)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 9A0AF1237;
        Tue,  6 Sep 2022 00:53:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1662418400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/By73UdS4I5mXEc+O0lv8vgBFlHY3Pw70xtrxrWK0x0=;
        b=uqIwMHV5QXcnmwPSQQFAGiGSIpvCewYSE95VUUm7vli6FaCVmqoEBkzLaStZ5E3ssMoXN8
        gUFNsTKZEOTasqeL8B4aU/0DlQZtZ4JrTi1ikPo8SxJc+htVmrzHQ2p4KZwHKOySw5NEXg
        UK+hs34g6mR+b9JXAGvGADxYDTW8w4CnyIf/9z9qg1WnLzPG2u+YCPxXhIw9uSvflOCeuP
        IRbHF68NE8ZRfndEEzwt+AtPdoqoMmIpv3i9IgXeSAVHOUP5jjtIcGmVTMVTpEPqIa99eS
        /MOJR8km43shSZE4wCpD6ErddsvLdbtdDhVEhOGlkWst8R+wMIKNCeVoNhSFNQ==
MIME-Version: 1.0
Date:   Tue, 06 Sep 2022 00:53:20 +0200
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
Subject: Re: [PATCH v2 net 1/3] net: dsa: felix: tc-taprio intervals smaller
 than MTU should send at least one packet
In-Reply-To: <20220905170125.1269498-2-vladimir.oltean@nxp.com>
References: <20220905170125.1269498-1-vladimir.oltean@nxp.com>
 <20220905170125.1269498-2-vladimir.oltean@nxp.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <d50be0e224c70453e1a4a7d690cfdf1b@walle.cc>
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

Am 2022-09-05 19:01, schrieb Vladimir Oltean:
> The blamed commit broke tc-taprio schedules such as this one:
> 
> tc qdisc replace dev $swp1 root taprio \
>         num_tc 8 \
>         map 0 1 2 3 4 5 6 7 \
>         queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
>         base-time 0 \
>         sched-entry S 0x7f 990000 \
>         sched-entry S 0x80  10000 \
>         flags 0x2
> 
> because the gate entry for TC 7 (S 0x80 10000 ns) now has a static 
> guard
> band added earlier than its 'gate close' event, such that packet
> overruns won't occur in the worst case of the largest packet possible.
> 
> Since guard bands are statically determined based on the per-tc
> QSYS_QMAXSDU_CFG_* with a fallback on the port-based QSYS_PORT_MAX_SDU,
> we need to discuss what happens with TC 7 depending on kernel version,
> since the driver, prior to commit 55a515b1f5a9 ("net: dsa: felix: drop
> oversized frames with tc-taprio instead of hanging the port"), did not
> touch QSYS_QMAXSDU_CFG_*, and therefore relied on QSYS_PORT_MAX_SDU.
> 
> 1 (before vsc9959_tas_guard_bands_update): QSYS_PORT_MAX_SDU defaults 
> to
>   1518, and at gigabit this introduces a static guard band (independent
>   of packet sizes) of 12144 ns, plus QSYS::HSCH_MISC_CFG.FRM_ADJ (bit
>   time of 20 octets => 160 ns). But this is larger than the time window
>   itself, of 10000 ns. So, the queue system never considers a frame 
> with
>   TC 7 as eligible for transmission, since the gate practically never
>   opens, and these frames are forever stuck in the TX queues and hang
>   the port.
> 
> 2 (after vsc9959_tas_guard_bands_update): Under the sole goal of
>   enabling oversized frame dropping, we make an effort to set
>   QSYS_QMAXSDU_CFG_7 to 1230 bytes. But QSYS_QMAXSDU_CFG_7 plays
>   one more role, which we did not take into account: per-tc static 
> guard
>   band, expressed in L2 byte time (auto-adjusted for FCS and L1 
> overhead).
>   There is a discrepancy between what the driver thinks (that there is
>   no guard band, and 100% of min_gate_len[tc] is available for egress
>   scheduling) and what the hardware actually does (crops the equivalent
>   of QSYS_QMAXSDU_CFG_7 ns out of min_gate_len[tc]). In practice, this
>   means that the hardware thinks it has exactly 0 ns for scheduling tc 
> 7.
> 
> In both cases, even minimum sized Ethernet frames are stuck on egress
> rather than being considered for scheduling on TC 7, even if they would
> fit given a proper configuration. Considering the current situation,
> with vsc9959_tas_guard_bands_update(), frames between 60 octets and 
> 1230
> octets in size are not eligible for oversized dropping (because they 
> are
> smaller than QSYS_QMAXSDU_CFG_7), but won't be considered as eligible
> for scheduling either, because the min_gate_len[7] (10000 ns) minus the
> guard band determined by QSYS_QMAXSDU_CFG_7 (1230 octets * 8 ns per
> octet == 9840 ns) minus the guard band auto-added for L1 overhead by
> QSYS::HSCH_MISC_CFG.FRM_ADJ (20 octets * 8 ns per octet == 160 octets)
> leaves 0 ns for scheduling in the queue system proper.
> 
> Investigating the hardware behavior, it becomes apparent that the queue
> system needs precisely 33 ns of 'gate open' time in order to consider a
> frame as eligible for scheduling to a tc. So the solution to this
> problem is to amend vsc9959_tas_guard_bands_update(), by giving the
> per-tc guard bands less space by exactly 33 ns, just enough for one
> frame to be scheduled in that interval. This allows the queue system to
> make forward progress for that port-tc, and prevents it from hanging.
> 
> Fixes: 297c4de6f780 ("net: dsa: felix: re-enable TAS guard band mode")
> Reported-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

I haven't looked at the overall code, but the solution described
above sounds good.

FWIW, I don't think such a schedule, where exactly one frame
can be sent, is very likely in the wild though. Imagine a piece
of software is generating one frame per cycle. It might happen
that during one (hardware) cycle there is no frame ready (because
it is software and it jitters), but then in the next cycle, there
are now two frames ready. In that case you'll always lag one frame
behind and you'll never recover from it.

Either I'd make sure I can send at two frames in one cycle, or
my software would only send a frame every other cycle.

Thanks for taking care of this!

-michael

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBD863C2CD
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 15:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235740AbiK2OjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 09:39:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234350AbiK2OjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 09:39:16 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73CF131ECC;
        Tue, 29 Nov 2022 06:39:15 -0800 (PST)
Received: from [IPV6:2003:e9:d724:11f3:6a8a:fec:d223:2c22] (p200300e9d72411f36a8a0fecd2232c22.dip0.t-ipconnect.de [IPv6:2003:e9:d724:11f3:6a8a:fec:d223:2c22])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 521C8C057B;
        Tue, 29 Nov 2022 15:39:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1669732753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vi+BCc3epThewqbv7ZyWexyjDCAHINiW4A+/6dOUFEg=;
        b=H8BxjRCeDjG2Jc9QMhYVDB8ucWbeHUPvNDF59Pdg8sVJ+WtgIQNQ/wmIjUpDSHjgV9o0Kh
        wxxJ67JND63opPw2FtkCb7XyUrVsIIdPQotwUKQ8idVqWVe1Ymil4FpvwxlWLCIdenIPvw
        hLCR1KrA4uVa0/JqGQb63AwYoWYBW4pMijJfc55tctvdThBfQ2dULbLqZJW0SoZEcH/ehf
        nVyZqivXCmxsV9lDiOrUJe2gnOU7+akR7gr0/q7Gmt3weTNYM6XWabCIOBYwCmJiwyGKnU
        hOhVwaLF2CZQfXX67/B55e/u0hx10csXihblAc7AzOu0zgwaWe1WbVRnAM5xrg==
Message-ID: <04f7bc30-618d-db22-4b8f-8753f60d26b9@datenfreihafen.org>
Date:   Tue, 29 Nov 2022 15:39:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH wpan-next v3 0/2] IEEE 802.15.4 PAN discovery handling
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <alex.aring@gmail.com>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <20221129135535.532513-1-miquel.raynal@bootlin.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20221129135535.532513-1-miquel.raynal@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 29.11.22 14:55, Miquel Raynal wrote:
> Hello,
> 
>>>> Just a resent of the v2, rebased <<<
> 
> Last preparation step before the introduction of the scanning feature
> (really): generic helpers to handle PAN discovery upon beacon
> reception. We need to tell user space about the discoveries.
> 
> In all the past, current and future submissions, David and Romuald from
> Qorvo are credited in various ways (main author, co-author,
> suggested-by) depending of the amount of rework that was involved on
> each patch, reflecting as much as possible the open-source guidelines we
> follow in the kernel. All this effort is made possible thanks to Qorvo
> Inc which is pushing towards a featureful upstream WPAN support.
> 
> Cheers,
> Miquèl
> 
> Changes in v3:
> * Rebased on wpan-next/master.
> 
> Changes in v2:
> * Dropped all the logic around the knowledge of PANs: we forward all
>    beacons received to userspace and let the user decide whether or not
>    the coordinator is new or not.
> * Changed the coordinator descriptor address member to a proper
>    structure (not a pointer).
> 
> David Girault (1):
>    mac802154: Trace the registration of new PANs
> 
> Miquel Raynal (1):
>    ieee802154: Advertize coordinators discovery
> 
>   include/net/cfg802154.h   |  18 +++++++
>   include/net/nl802154.h    |  43 ++++++++++++++++
>   net/ieee802154/nl802154.c | 103 ++++++++++++++++++++++++++++++++++++++
>   net/ieee802154/nl802154.h |   2 +
>   net/mac802154/trace.h     |  25 +++++++++
>   5 files changed, 191 insertions(+)
> 

These patches have been applied to the wpan-next tree and will be
part of the next pull request to net-next. Thanks!

regards
Stefan Schmidt

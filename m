Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8685D524039
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 00:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239486AbiEKW1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 18:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234567AbiEKW1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 18:27:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA064644D0
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 15:27:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8E3661D09
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 22:27:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C52D2C34114;
        Wed, 11 May 2022 22:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652308062;
        bh=byYd0hrdu7uYm/nEhE0yjeXm28kpUSb/dr5wsim7rB0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uwk3IF6esx4Evd5RjBb5U2hX8FLLCzB1EnGEq4yIh+BzHVwwfjd675tCi1npndUuK
         cBgn2Ax3Nzs6ncviPblTmHdnAmLVBsfNlmFq0i0opRD6yE8oMq/mZyPhwgb7ffZGE/
         Pjtzp60DLgVZ0kNh04Z9ESisjdO9lYaPyi4/9NTWFGTWkJXDvWpBAyzBDP6x16gBQQ
         GUIoGbTJrDVKfdek3Ke7AmM/YJmRqTcV8pgk/GA8NLjOJr1xF+XQFLXVGc2m7HIfmW
         qvOCJ6nGg5Li86Sn7rE4ktG7a5wtLUs4hmAKyf6kMsEANEOao6wa/umCD+u/YQzK7M
         QICSFfrv1EbaA==
Date:   Wed, 11 May 2022 15:27:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Michael Walle <michael@walle.cc>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Po Liu <Po.Liu@nxp.com>
Subject: Re: [PATCH net-next 2/2] net: enetc: count the tc-taprio window
 drops
Message-ID: <20220511152740.63883ddf@kernel.org>
In-Reply-To: <20220510163615.6096-3-vladimir.oltean@nxp.com>
References: <20220510163615.6096-1-vladimir.oltean@nxp.com>
        <20220510163615.6096-3-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 May 2022 19:36:15 +0300 Vladimir Oltean wrote:
> From: Po Liu <Po.Liu@nxp.com>
> 
> The enetc scheduler for IEEE 802.1Qbv has 2 options (depending on
> PTGCR[TG_DROP_DISABLE]) when we attempt to send an oversized packet
> which will never fit in its allotted time slot for its traffic class:
> either block the entire port due to head-of-line blocking, or drop the
> packet and set a bit in the writeback format of the transmit buffer
> descriptor, allowing other packets to be sent.
> 
> We obviously choose the second option in the driver, but we do not
> detect the drop condition, so from the perspective of the network stack,
> the packet is sent and no error counter is incremented.
> 
> This change checks the writeback of the TX BD when tc-taprio is enabled,
> and increments a specific ethtool statistics counter and a generic
> "tx_dropped" counter in ndo_get_stats64.

Is there no MIB attribute in the standard for such drops?

The semantics seem petty implementation-independent can we put it into
some structured ethtool stats instead?

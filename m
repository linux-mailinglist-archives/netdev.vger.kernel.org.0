Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5415B524098
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 01:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349055AbiEKXNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 19:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349052AbiEKXNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 19:13:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C8A16A13F
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 16:13:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B35EE61D09
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 23:13:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5FAC340EE;
        Wed, 11 May 2022 23:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652310828;
        bh=ITNAiv8IdA8a84cE/FmKC4aNzN/6/x/QD/ZRDRF8uoY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=r3ySlPZe1oV21xHguXzGPXQvN/k6QCG1lRblTeXHJtsWVAchI97Pwe+VoEFuzj6xo
         jptFTjWnYo6Qxu9TzAHplnrRK3gtfXTlSFUpc8wZ1pDc0xvuDg74NVv0EMbPlLlGVY
         pMVwBwrUhPtIrqYQpARliS98o+C8lRupPEKfq27DdRFQdHzA6DeOqjTe4IyT0KR84D
         qgvbDC/3IBwklhC5OfQGZuYHeg5XLHeZlMhuqk33DI11ayvXyfH7IHZ0lBrNyAU0NW
         cR3OxrWqXxs7WQP0LT46bIQYhqjeAlFg1ME9hfb5UPbzu9gszajr9iz6ega4TbW8Po
         /mCLUBQb53+Qg==
Date:   Wed, 11 May 2022 16:13:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Michael Walle <michael@walle.cc>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Po Liu <po.liu@nxp.com>
Subject: Re: [PATCH net-next 2/2] net: enetc: count the tc-taprio window
 drops
Message-ID: <20220511161346.69c76869@kernel.org>
In-Reply-To: <20220511225745.xgrhiaghckrcxdaj@skbuf>
References: <20220510163615.6096-1-vladimir.oltean@nxp.com>
        <20220510163615.6096-3-vladimir.oltean@nxp.com>
        <20220511152740.63883ddf@kernel.org>
        <20220511225745.xgrhiaghckrcxdaj@skbuf>
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

On Wed, 11 May 2022 22:57:46 +0000 Vladimir Oltean wrote:
> The only entry that is a counter in the Scheduled Traffic MIB is TransmissionOverrun,
> but that isn't what this is. Instead, this would be a TransmissionOverrunAvoidedByDropping,
> for which there appears to be no standardization.

TransmissionOversized? There's no standardization in terms of IEEE but
the semantics seem pretty clear right? The packet is longer than the
entire window so it can never go out?

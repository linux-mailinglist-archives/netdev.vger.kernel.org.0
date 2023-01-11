Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33A83666336
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 20:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235050AbjAKTBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 14:01:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235903AbjAKTAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 14:00:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52F183D1C7
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 11:00:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 123FCB81CB3
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 19:00:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A77C433F0;
        Wed, 11 Jan 2023 19:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673463644;
        bh=PKnov8yyRtlq3RP9jQyS44w79W6cmPQDxUR0IYs0Y7M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=I3m+zcYegsjJz7rYa9g5itSywfapotStVtIISd5lbPSxyWOSfuUEy6x0aptwa6cWE
         vNhUMjnpIEnJTN7VsPneTgCS9K+BrfFKtPjMzMUqut396Tu6eLIouw5JMQqkAsjEdM
         uLoEQZawvXz8UafEOFW7bPukehRamDWoJICLrpSRMN5Tjw7LRc+SMJqoOj2OPaZ9XT
         V6cpfhPzZ3JgdtRjrMVBbHBdjyfkuvaBq3c4BCHrtTdjAm+uma/GR0bUYHBTnUjEX/
         DmpqOARn/Q9xW+FZVU2BxQvXGxt6HXRiqSNW1sSQE8hnrsduZOaSowLfU8LFBJqVEn
         vQErQgl2/J1hg==
Date:   Wed, 11 Jan 2023 11:00:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Arinzon, David" <darinzon@amazon.com>
Cc:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: Re: [PATCH V1 net-next 0/5] Add devlink support to ena
Message-ID: <20230111110043.036409d0@kernel.org>
In-Reply-To: <865255fd30cd4339966425ea1b1bd8f9@amazon.com>
References: <20230108103533.10104-1-darinzon@amazon.com>
        <20230109164500.7801c017@kernel.org>
        <574f532839dd4e93834dbfc776059245@amazon.com>
        <20230110124418.76f4b1f8@kernel.org>
        <865255fd30cd4339966425ea1b1bd8f9@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Jan 2023 08:58:46 +0000 Arinzon, David wrote:
> > I read it again - and I still don't know what you're doing.
> > I sounds like inline header length configuration yet you also use LLQ all
> > over the place. And LLQ for ENA is documented as basically tx_push:
> > 
> >   - **Low Latency Queue (LLQ) mode or "push-mode":**
> > 
> > Please explain this in a way which assumes zero Amazon-specific
> > knowledge :(
> 
> Low Latency Queues (LLQ) is a mode of operation where the packet headers
> (up to a defined length) are being written directly to the device memory.
> Therefore, you are right, the description is similar to tx_push. However,
> This is not a configurable option while ETHTOOL_A_RINGS_TX_PUSH
> configures whether to work in a mode or not.
> If I'm understanding the intent behind ETHTOOL_A_RINGS_TX_PUSH
> and the implementation in the driver that introduced the feature, it
> refers to a push of the packet and not just the headers, which is not what
> the ena driver does.
> 
> In this patchset, we allow the configuration of an extended size of the
> Low Latency Queue, meaning, allow enabled another, larger, pre-defined
> size to be used as a max size of the packet header to be pushed directly to
> device memory. It is not configurable in value, therefore, it was defined as
> large LLQ.
> 
> I hope this provides more clarification, if not, I'll be happy to elaborate further.

Thanks, the large missing piece in my understanding is still what 
the user visible impact of this change is. Without increasing 
the LLQ entry size, a user who sends packet with long headers will:
 a) see higher latency thru the NIC, but everything else is the same
 b) see higher latency and lower overall throughput in terms of PPS
 c) will have limited access to offloads, because the device requires
    full access to headers via LLQ for some offloads

which one of the three is the closest?

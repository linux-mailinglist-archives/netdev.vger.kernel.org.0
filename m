Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF9985ED165
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 02:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbiI1AJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 20:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiI1AJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 20:09:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47EB1D8E0F
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 17:09:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03A34B81E3B
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 00:09:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E724C433C1;
        Wed, 28 Sep 2022 00:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664323760;
        bh=V7xGibmhoDUypWhgYRCEBWbRO9g/ZzfvhIAtZIlUBvU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qT0T5WjrjDD3Wup4CamyKgTnj6SzasnDN/XGmJ3LWLWPto3Tqm1+Vi4dzmPgz8n87
         wMCh7OZNgn6QL++4kA7BYFJhRbheZnIRIg892NZhakihbiCNQnZFezJPin6CZaZVt4
         /JJi0cUpemq45WHU6FKgmpuWjpwNf4WoWz5vS9EVhdl9Kk73J90nClxfVjcXzFlp2q
         M+lMFJ1jK1hhqW1co08R1mqzn+HlpBJDOFBx8nbbh2ZKPLkC+bvpYpKCmRho7V6SyL
         UK17Pi+S5q9olJ/ZV28+nOv/iWUmsCLLCY8otRtqH8KVxudBBEMOrHCC0/9Ne9GxMg
         nvtilvYY/E38Q==
Date:   Tue, 27 Sep 2022 17:09:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Cc:     intel-wired-lan@osuosl.org, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, vinicius.gomes@intel.com,
        aravindhan.gunasekaran@intel.com,
        noor.azura.ahmad.tarmizi@intel.com,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH v1 0/4] Add support for DMA timestamp for non-PTP
 packets
Message-ID: <20220927170919.3a1dbcc3@kernel.org>
In-Reply-To: <20220927130656.32567-1-muhammad.husaini.zulkifli@intel.com>
References: <20220927130656.32567-1-muhammad.husaini.zulkifli@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Sep 2022 21:06:52 +0800 Muhammad Husaini Zulkifli wrote:
> The HW TX timestamps created by the NIC via socket options can be
> requested using the current network timestamps generation capability of
> SOF_TIMESTAMPING_TX_HARDWARE. The most common users of this socket flag
> is PTP, however other packet applications that require tx timestamps might
> also ask for it.
> 
> The problem is that, when there is a lot of traffic, there is a high chance
> that the timestamps for a PTP packet will be lost if both PTP and Non-PTP
> packets use the same SOF TIMESTAMPING TX HARDWARE causing the tx timeout.
> 
> DMA timestamps through socket options are not currently available to
> the user. Because if the user wants to, they can configure the hwtstamp
> config option to use the new introduced DMA Time Stamp flag through the
> setsockopt().
> 
> With these additional socket options, users can continue to utilise
> HW timestamps for PTP while specifying non-PTP packets to use DMA
> timestamps if the NIC can support them.
> 
> Any socket application can be use to verify this.
> TSN Ref SW application is been used for testing by changing as below:

Very glad to see this being worked on!

High level tho, are we assuming that the existing HW timestamps are
always PTP-quality, i.e. captured when SFD crosses the RS layer, or
whatnot? I'm afraid some NICs already report PCI stamps as the HW ones.
So the existing HW stamps are conceptually of "any" type, if we want to
be 100% sure NIC actually stamps at the PHY we'd need another tx_type
to express that.

Same story on the Rx - what do you plan to do there? We'll need to
configure the filters per type, but that's likely to mean two new
filters, because the current one gives no guarantee.

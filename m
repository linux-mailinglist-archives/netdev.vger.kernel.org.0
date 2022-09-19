Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4C55BD636
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 23:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbiISVRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 17:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbiISVRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 17:17:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 750684C62F
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 14:17:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07D21B81CBF
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 21:17:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6270FC433D6;
        Mon, 19 Sep 2022 21:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663622257;
        bh=wObiOUPCPaX64xlw0uP2WYp+IFkFgUGBPdk/k7+L6II=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AYWxPG3Na0Atjvc43UlraA7Y9IagSHtDL3eP+kwnJ3BCWPaFuzMf9H2e8m/LJklHV
         alNKkVBNAyDd4DRDPqvCouBYqSy7Iap1RXyAnRdPGCN+EzNn2eQEW1G6Gn98lEjiAY
         0jP7ZSE5JlT674G2kBOqI1932duArpfLCJ7UCH+A3i4e9Ht2EW9dD3xv0/ANTbLjBn
         42gTMK6g4ZE3dOIGkqU2Cuh7vY4D4HFcGa/S19ydU95tKIXRcetjtWFN1qfKSI1h34
         D05JqTGggZFJeiQY16npPwrp8a9Vz28bL+5NjdMi5YRfLz8yv58Rf3r3UYeasy3z92
         h89kvilsCxgYQ==
Date:   Mon, 19 Sep 2022 14:17:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Thompson <davthompson@nvidia.com>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <cai.huoqing@linux.dev>, <brgl@bgdev.pl>,
        <limings@nvidia.com>, Asmaa Mnebhi <asmaa@nvidia.com>
Subject: Re: [PATCH net v1] mlxbf_gige: fix receive packet race condition
Message-ID: <20220919141736.53155bb2@kernel.org>
In-Reply-To: <20220908202853.21725-1-davthompson@nvidia.com>
References: <20220908202853.21725-1-davthompson@nvidia.com>
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

On Thu, 8 Sep 2022 16:28:53 -0400 David Thompson wrote:
> Under heavy traffic, the BF2 Gigabit interface can
> become unresponsive for periods of time (several minutes)
> before eventually recovering.  This is due to a possible
> race condition in the mlxbf_gige_rx_packet function, where
> the function exits with producer and consumer indices equal
> but there are remaining packet(s) to be processed. In order
> to prevent this situation, disable receive DMA during the
> processing of received packets.

Pausing Rx DMA seems a little drastic, is the capacity of the NIC
buffer large enough to sink the traffic while the stack drains 
the ring?

Could you provide a little more detail on what the HW issue is? 
There is no less intrusive way we can fix it?

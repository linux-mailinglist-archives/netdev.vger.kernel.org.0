Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 081FB60D3BA
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 20:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbiJYSl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 14:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232518AbiJYSlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 14:41:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9986C108DFB
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 11:41:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10444B8171E
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 18:41:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88900C433D6;
        Tue, 25 Oct 2022 18:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666723311;
        bh=7NKoevC5iyxfqncmaGc1Od/SqDSvHchSLeOZFM0zPQE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BtL16ConxBa4RHJlAS6OQDfsuqizt74H7WZd9xrqSkFFGcAls1RkKyH6t82TphwYs
         EUQT/hGVteeafnb4BItJ6DRyNajTUSjJmbOKimlwwhADlO3FexZUSfwfmRXMsyO6KA
         fia0HQz3DKti+frtSxBZGQluHq/MVk0xgZUert5iHNs2hJ+oTRllfEPlblnfS6AP4l
         acIKPM75Ti6e64D/bSdtE/2jmXOVYjLW5gOHu+pdZROTC8Lkhq0mJOw3tvm/pv160w
         MPSIned6OOS29z3Qd9VGII0kEMVisrSiN0llyCqnXmwPcyQm5SyXMb33EIH/qiqgrC
         /NabhYIJSsbrA==
Date:   Tue, 25 Oct 2022 11:41:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nick Child <nnac123@linux.ibm.com>
Cc:     netdev@vger.kernel.org, nick.child@ibm.com, dave.taht@gmail.com
Subject: Re: [RFC PATCH net-next 0/1] ibmveth: Implement BQL
Message-ID: <20221025114148.1bcf194b@kernel.org>
In-Reply-To: <20221024213828.320219-1-nnac123@linux.ibm.com>
References: <20221024213828.320219-1-nnac123@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Oct 2022 16:38:27 -0500 Nick Child wrote:
> Labeled as RFC because I am unsure if adding Byte Queue Limits (BQL) is
> positively effecting the ibmveth driver. BQL is common among network
> drivers so I would like to incorporate it into the virtual ethernet
> driver, ibmveth. But I am having trouble measuring its effects.
> 
> From my understanding (and please correct me if I am wrong), BQL will 
> use the number of packets sent to the NIC to approximate the minimum
> number of packets to enqueue to a netdev_queue without starving the NIC.
> As a result, bufferbloat in the networking queues are minimized which
> may allow for smaller latencies.
> 
> After performing various netperf tests under differing loads and
> priorities, I do not see any performance effect when comparing the
> driver with and without BQL. The ibmveth driver is a virtual driver
> which has an abstracted view of the NIC so I am comfortable without
> seeing any performance deltas. That being said, I would like to know if
> BQL is actually being enforced in some way. In other words, I would
> like to observe a change in the number of queued bytes during BQL
> implementations. Does anyone know of a mechanism to measure the length
> of a netdev_queue?
> 
> I tried creating a BPF script[1] to track the bytes in a netdev_queue
> but again am not seeing any difference with and without BQL. I do not
> believe anything is wrong with BQL (it is more likely that my tracing
> is bad) but I would like to have some evidence of BQL having a
> positive effect on the device. Any recommendations or advice would be
> greatly appreciated.

What qdisc are you using and what "netperf tests" are you running?

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8307B62C99D
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 21:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbiKPUJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 15:09:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232804AbiKPUJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 15:09:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB9D627FE;
        Wed, 16 Nov 2022 12:09:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E027B81D80;
        Wed, 16 Nov 2022 20:09:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058F5C433C1;
        Wed, 16 Nov 2022 20:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668629382;
        bh=i3qMamg1MCRCzeZi7pLK6qAH3/XpIXsR5L7QAJr2ICQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tgRm0C9CB8Nj6O8Inf7ruu03IgfZOo/s7u10Nc/LD7axiFC7cVbMP+ZyxHgC5ZorR
         kbEgkM3kh43Ny+jfyTQMXb6dnpPm+6xBwSea9ctopLmqLNO5kXZz9gMqNbxJmhDvcD
         Jp0o+qSOFFehvpQQp1rEsIKsk5wpxAXeQCBWptfbStp5qbqEib9u9LNbM/pT9kzro8
         xkZ7rs2r3tLzCu8Ex6aOxvINt39bM8ur+EkK0u2wLNkofMhhP7+AA5LDXthghTmhOI
         ZaqYZAK9Erj0TMSffWTBoMEuRtkwpEd2Lf+jlKKEtmVZ8s+RWTqKWMzId7fjfPGpbw
         uN5aWTZFzulYA==
Date:   Wed, 16 Nov 2022 12:09:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Stefan Roesch <shr@devkernel.io>, kernel-team@fb.com,
        olivier@trillion01.com, netdev@vger.kernel.org,
        io-uring@vger.kernel.org
Subject: Re: [RFC PATCH v3 0/3] io_uring: add napi busy polling support
Message-ID: <20221116120941.2d7cffcd@kernel.org>
In-Reply-To: <44c2f431-6fd0-13c7-7b53-59237e24380a@kernel.dk>
References: <20221115070900.1788837-1-shr@devkernel.io>
        <20221116103117.6b82e982@kernel.org>
        <44c2f431-6fd0-13c7-7b53-59237e24380a@kernel.dk>
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

On Wed, 16 Nov 2022 11:44:38 -0700 Jens Axboe wrote:
> Thanks Jakub! Question on the need for patch 3, which I think came about
> because of comments from you. Can you expand on why we need both an
> enable and timeout setting? Are there cases where timeout == 0 and
> enabled == true make sense?

The enable is for the "prefer busy poll" mode, rather that just busy
polling.

The prefer busy poll mode disables interrupts and arms a (hopefully
long enough) fail safe timer, and expects user to come back and busy
poll before the timer fires. The timer length is set thru sysfs params
for NAPI/queue.

Because the Rx traffic is fully async and not in control of the local
app, this gives the local app the ability to postpone the Rx IRQ.
No interruptions means lower response latency. 
With the expectation that the app will read/"busy poll" next batch of
packets once its done servicing the previous batch.

We don't have to implement this bit from the start, "normal" busy poll
is already functional with patches 1 and 2.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63FA967C01A
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 23:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235227AbjAYWn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 17:43:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbjAYWn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 17:43:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F03113D7
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 14:43:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31C26B8198A
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 22:43:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88548C4339B;
        Wed, 25 Jan 2023 22:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674686632;
        bh=2F5hvi2/hjNfSA0NThfZi4R04+7Sm822rKAHU3ILOgY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HNgngqVNXa59lIxYzH2t2c+fBwfOEp/6FE/qNfdlkkuzdH6Hc6otlS+LBOeTWCfRC
         WOS2wD/FOYSUCRxqJMJLhX2J30VuqYBDhyFTNwaSYZEVxJ7v4SkB6zGrt0MFC7qwWi
         hztnjWTW1DL8ZjfxkgPnx/TH/wy1shTQKkbVCbDxAXmPuevnU86oMM8Z7dlqi8r0hw
         QbQQX5067/mDLSc6vEzwp01P9rh4eCwTlLd2rO80EgL8C1K5JIXKl4XGkU8DhZwflb
         2UV2qgx328RJobcs/tS4Z06TLIkqQG2Bid7Btn9HReG+USqbHXedjq3vboIWbNbH3m
         OEqPMoDxxNduQ==
Date:   Wed, 25 Jan 2023 14:43:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simo Sorce <simo@redhat.com>
Cc:     Apoorv Kothari <apoorvko@amazon.com>, sd@queasysnail.net,
        borisp@nvidia.com, dueno@redhat.com, fkrenzel@redhat.com,
        gal@nvidia.com, netdev@vger.kernel.org, tariqt@nvidia.com
Subject: Re: [PATCH net-next 0/5] tls: implement key updates for TLS1.3
Message-ID: <20230125144351.30d1d5ab@kernel.org>
In-Reply-To: <3e9dc325734760fc563661066cd42b813991e7ce.camel@redhat.com>
References: <Y8//pypyM3HAu+cf@hog>
        <20230125184720.56498-1-apoorvko@amazon.com>
        <20230125105743.16d7d4c6@kernel.org>
        <3e9dc325734760fc563661066cd42b813991e7ce.camel@redhat.com>
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

On Wed, 25 Jan 2023 16:17:26 -0500 Simo Sorce wrote:
> > We're talking about the Tx direction, the packets are queued to the
> > lower layers of the stack unencrypted, and get encrypted by the NIC.
> > Until TCP gets acks for all the data awaiting offloaded crypto - we
> > must hold onto the keys.  
> 
> Is this because the NIC does not cache the already encrypted outgoing
> packets?

NIC can't cache outgoing packets, there's too many and NIC is supposed
to only do crypto. TCP stack is responsible for handing rtx.

> If that is the case is it _guaranteed_ that the re-encrypted packets
> are exactly identical to the previously sent ones?

In terms of payload, yes. Modulo zero-copy cases we don't need to get
into.

> If it is not guaranteed, are you blocking use of AES GCM and any other
> block cipher that may have very bad failure modes in a situation like
> this (in the case of AES GCM I am thinking of IV reuse) ?

I don't know what you mean.

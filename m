Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9F6F5E57B4
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 03:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiIVBB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 21:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiIVBB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 21:01:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3417686710;
        Wed, 21 Sep 2022 18:01:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1008B8337F;
        Thu, 22 Sep 2022 01:01:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D280C433D6;
        Thu, 22 Sep 2022 01:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663808513;
        bh=mt6Efzdk+la/shXr+HkzyhobECVNYxpLZbiK6qvyBDE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z1lnH4+zrROmy34woIUSIwutdzO5u3p06eqOflbF0mlCH3DpRXjNIRNK49zV4yMKh
         MIsSsK82iSCmCjMuJ9lY7pdmHF4F8XAc+3fd39aj2Z1XGizr0Ly7s/rXkjeFsVunkk
         uiVdeIdd+kUyrWbEXo38qw1CmdGzJhql0f1+jfeQjxDsBLQ/V3Y5wGCmHVGi2CMYSY
         XR73fLqmQeP5gg1YFbH6WtxQpx11Ce5QZ18ijstMParmdlwmkqoRjygQjXfP+uSGnA
         BI0r6XmtSOn6F7kEYDqNNCx290YZ4o0x0JcojfpyVk29tn4GUVkxd8HPTSFWqtApnT
         i72PCTbOmSTJA==
Date:   Wed, 21 Sep 2022 18:01:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     davem@davemloft.net, robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 7/7] tsnep: Rework RX buffer allocation
Message-ID: <20220921180152.002dea73@kernel.org>
In-Reply-To: <20220915203638.42917-8-gerhard@engleder-embedded.com>
References: <20220915203638.42917-1-gerhard@engleder-embedded.com>
        <20220915203638.42917-8-gerhard@engleder-embedded.com>
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

On Thu, 15 Sep 2022 22:36:37 +0200 Gerhard Engleder wrote:
> Try to refill RX queue continously instead of dropping frames if
> allocation fails. This seems to be the more common pattern for network
> drivers and makes future XDP support simpler.

Is there anything preventing the queue from becoming completely empty
and potentially never getting refilled?

The lazy refill usually comes with some form of a watchdog / periodic
depletion check.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB5A66DA76D
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 04:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240278AbjDGCHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 22:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240090AbjDGCGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 22:06:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF265BB83;
        Thu,  6 Apr 2023 19:05:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3969664E57;
        Fri,  7 Apr 2023 02:05:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B21DC433EF;
        Fri,  7 Apr 2023 02:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680833114;
        bh=QU1vy2LiKyHh9Cb84d1U1hFqmDDMmNx6/NGpZHkgQxQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OWABEbn4oBit82D9+BjaNIyX5jyB7/g08QRLJaAgDq2P4z13wmuYs/d65aKCPA/5q
         xJhYY5iX7AImOs5Qrk/4kyvaUi5eqzqjXKKuJ+vusgXBTrArzrwVJnVgrnuzJCfc0p
         QoqPZEcrHf24djIS3FExU3Ep+6r5bIDEODy8qx54NTEl5J1/n2FIp5GBSE5BrsASXv
         N2F6OrUnZos6RbTifp0SwesDVGfdxHuXk+FgIgv6mPvks4StAsweO4oBKPEEDGlobX
         RUPuV371raD9F79u0LtEXaLfuFJXCy6pB2AS4VOx5rU/qihje+jH2KL/Wtk/B+DPIg
         rugXDEu61+C/Q==
Date:   Thu, 6 Apr 2023 19:05:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Felix Huettner <felix.huettner@mail.schwarz>,
        netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com,
        edumazet@google.com, pshelar@ovn.org, davem@davemloft.net,
        luca.czesla@mail.schwarz
Subject: Re: [PATCH net v3] net: openvswitch: fix race on port output
Message-ID: <20230406190513.7d783d6d@kernel.org>
In-Reply-To: <ZC0pBXBAgh7c76CA@kernel-bug-kernel-bug>
References: <ZC0pBXBAgh7c76CA@kernel-bug-kernel-bug>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 Apr 2023 07:53:41 +0000 Felix Huettner wrote:
> assume the following setup on a single machine:
> 1. An openvswitch instance with one bridge and default flows
> 2. two network namespaces "server" and "client"
> 3. two ovs interfaces "server" and "client" on the bridge
> 4. for each ovs interface a veth pair with a matching name and 32 rx and
>    tx queues
> 5. move the ends of the veth pairs to the respective network namespaces
> 6. assign ip addresses to each of the veth ends in the namespaces (needs
>    to be the same subnet)
> 7. start some http server on the server network namespace
> 8. test if a client in the client namespace can reach the http server

Hi Simon, looks good?

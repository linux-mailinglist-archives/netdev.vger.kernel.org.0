Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDF766C8A9B
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 04:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbjCYDT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 23:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjCYDTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 23:19:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F037BDEF;
        Fri, 24 Mar 2023 20:19:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 927AF62D1D;
        Sat, 25 Mar 2023 03:19:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BDBFC433EF;
        Sat, 25 Mar 2023 03:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679714393;
        bh=d23nvSOJc744ejl12OeHq0eftBnWlz8O/pBXnLBn3fA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oWS0Cam7J3f/odv+g/GiiJEfwnIRPL57QfLCGxusvohO5Jd6M2Q4yf75m1N83wc7d
         LspKJj9HVw0UqS6BNcyq0q/Cyn0dzsQsUDme5tPa5ROgvNKF8eOf4KX0T1vGghydn2
         oVOPs9jJ7NNqQUvrWEwa8s3RT8j4ZhGiFhUn4ju4I5k9fre4ixmoHKax7b57Rfhzlp
         tD5dPdleXcMRVk41F+Kln5WwcLtdVkalpYlOVCKjrkmX6Ku6RdWlo+BdGmX0f9IBG6
         Oa13cOLYgaY3gy0lXGBtfRBNS90U6sZzM/sHXcnR56pgpLjZu7ZsCRFDjE2S7rdOLn
         RXZmGy7ZMtpmw==
Date:   Fri, 24 Mar 2023 20:19:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net/core: add optional threading for backlog
 processing
Message-ID: <20230324201951.75eabe1f@kernel.org>
In-Reply-To: <f59ee83f-7267-04df-7286-f7ea147b5b49@nbd.name>
References: <20230324171314.73537-1-nbd@nbd.name>
        <20230324102038.7d91355c@kernel.org>
        <2d251879-1cf4-237d-8e62-c42bb4feb047@nbd.name>
        <20230324104733.571466bc@kernel.org>
        <f59ee83f-7267-04df-7286-f7ea147b5b49@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Mar 2023 18:57:03 +0100 Felix Fietkau wrote:
> >> It can basically be used to make RPS a bit more dynamic and 
> >> configurable, because you can assign multiple backlog threads to a set 
> >> of CPUs and selectively steer packets from specific devices / rx queues   
> > 
> > Can you give an example?
> > 
> > With the 4 CPU example, in case 2 queues are very busy - you're trying
> > to make sure that the RPS does not end up landing on the same CPU as
> > the other busy queue?  
> 
> In this part I'm thinking about bigger systems where you want to have a
> group of CPUs dedicated to dealing with network traffic without
> assigning a fixed function (e.g. NAPI processing or RPS target) to each
> one, allowing for more dynamic processing.

I tried the threaded NAPI on larger systems and helped others try,
and so far it's not been beneficial :( Even the load balancing
improvements are not significant enough to use it, and there 
is a large risk of scheduler making the wrong decision.

Hence my questioning - I'm trying to understand what you're doing
differently.

> >> to them and allow the scheduler to take care of the rest.  
> > 
> > You trust the scheduler much more than I do, I think :)  
> 
> In my tests it brings down latency (both avg and p99) considerably in
> some cases. I posted some numbers here:
> https://lore.kernel.org/netdev/e317d5bc-cc26-8b1b-ca4b-66b5328683c4@nbd.name/

Could you provide the full configuration for this test?
In non-threaded mode the RPS is enabled to spread over remaining 
3 cores?

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E52F6C83AC
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 18:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbjCXRss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 13:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232022AbjCXRsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 13:48:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094081ADE9;
        Fri, 24 Mar 2023 10:47:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3337AB825B3;
        Fri, 24 Mar 2023 17:47:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B00C4339B;
        Fri, 24 Mar 2023 17:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679680055;
        bh=9mpW5nNH33HBdDHmPpaf/9jlnUTMEX+hMt5i4zry0pw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n5yKzIM2cIpqO1pDr29Y3lp2qP6pEI0q2CIQgbUmp1z80QEfCUQecxV+5dRyeXs0R
         DRnENjI7Bp75+XSua74l6eSX3FVJw0FKRJ9xXs8+Z+KvG70o3twUeLbLYsUzXY8IZX
         C/mtKd+BFVKS6mCbviJNd2I/8Mj/oQgcbEnsOk+q/o9TVJwXqjNVrKDO3dsrM3IQ16
         ZKUMTbbMdeABtcoIxS0p+l5OKdCrgP5AQiGK0jeXgQ9ijUS8qPHOhCcBCM91vDA0yx
         fW/+gQS3urEDcMe4xqULPyRhou8OHsQP+n5UQe5ZfzsPYYkjsbJrw1CSe457V0nCG3
         AXjkh9rssLP3A==
Date:   Fri, 24 Mar 2023 10:47:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net/core: add optional threading for backlog
 processing
Message-ID: <20230324104733.571466bc@kernel.org>
In-Reply-To: <2d251879-1cf4-237d-8e62-c42bb4feb047@nbd.name>
References: <20230324171314.73537-1-nbd@nbd.name>
        <20230324102038.7d91355c@kernel.org>
        <2d251879-1cf4-237d-8e62-c42bb4feb047@nbd.name>
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

On Fri, 24 Mar 2023 18:35:00 +0100 Felix Fietkau wrote:
> I'm primarily testing this on routers with 2 or 4 CPUs and limited 
> processing power, handling routing/NAT. RPS is typically needed to 
> properly distribute the load across all available CPUs. When there is 
> only a small number of flows that are pushing a lot of traffic, a static 
> RPS assignment often leaves some CPUs idle, whereas others become a 
> bottleneck by being fully loaded. Threaded NAPI reduces this a bit, but 
> CPUs can become bottlenecked and fully loaded by a NAPI thread alone.

The NAPI thread becomes a bottleneck with RPS enabled?

> Making backlog processing threaded helps split up the processing work 
> even more and distribute it onto remaining idle CPUs.

You'd want to have both threaded NAPI and threaded backlog enabled?

> It can basically be used to make RPS a bit more dynamic and 
> configurable, because you can assign multiple backlog threads to a set 
> of CPUs and selectively steer packets from specific devices / rx queues 

Can you give an example?

With the 4 CPU example, in case 2 queues are very busy - you're trying
to make sure that the RPS does not end up landing on the same CPU as
the other busy queue?

> to them and allow the scheduler to take care of the rest.

You trust the scheduler much more than I do, I think :)

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3C650ACA1
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 02:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354866AbiDVAFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 20:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiDVAFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 20:05:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 665CD47382;
        Thu, 21 Apr 2022 17:02:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 277E0B821CA;
        Fri, 22 Apr 2022 00:02:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FEECC385A7;
        Fri, 22 Apr 2022 00:02:26 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="U1g8W4w5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1650585744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s9YJ+AxOvCGo+608yNkBuz6fniGjDnN27/vTN4qozqQ=;
        b=U1g8W4w5mXPOSzp02yDVyUOJq3OHK6F9LOhkjdvSk/1MX063a58lwwKfrPDj2Y/UZx+loo
        Xl7bK2lV1BkP7iJYsjq9sNzhJ57z5tVGLY5eAZpvDF5S/QviE4shKPxlmkmyp5JR9LxTyZ
        c5LFRt48T/pkfculMStrb+EsyJSr7VI=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id eaac2843 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 22 Apr 2022 00:02:24 +0000 (UTC)
Date:   Fri, 22 Apr 2022 02:02:21 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Charles-Francois Natali <cf.natali@gmail.com>
Cc:     wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH] WireGuard: restrict packet handling to non-isolated CPUs.
Message-ID: <YmHwjdfZJJ2DeLTK@zx2c4.com>
References: <20220405212129.2270-1-cf.natali@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220405212129.2270-1-cf.natali@gmail.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netdev@ - Original thread is at
https://lore.kernel.org/wireguard/20220405212129.2270-1-cf.natali@gmail.com/

Hi Charles-François,

On Tue, Apr 05, 2022 at 10:21:29PM +0100, Charles-Francois Natali wrote:
> WireGuard currently uses round-robin to dispatch the handling of
> packets, handling them on all online CPUs, including isolated ones
> (isolcpus).
> 
> This is unfortunate because it causes significant latency on isolated
> CPUs - see e.g. below over 240 usec:
> 
> kworker/47:1-2373323 [047] 243644.756405: funcgraph_entry: |
> process_one_work() { kworker/47:1-2373323 [047] 243644.756406:
> funcgraph_entry: | wg_packet_decrypt_worker() { [...]
> kworker/47:1-2373323 [047] 243644.756647: funcgraph_exit: 0.591 us | }
> kworker/47:1-2373323 [047] 243644.756647: funcgraph_exit: ! 242.655 us
> | }
> 
> Instead, restrict to non-isolated CPUs.

Huh, interesting... I haven't seen this feature before. What's the
intended use case? To never run _anything_ on those cores except
processes you choose? To run some things but not intensive things? Is it
sort of a RT-lite?

I took a look in padata/pcrypt and it doesn't look like they're
examining the housekeeping mask at all. Grepping for
housekeeping_cpumask doesn't appear to show many results in things like
workqueues, but rather in core scheduling stuff. So I'm not quite sure
what to make of this patch.

I suspect the thing to do might be to patch both wireguard and padata,
and send a patch series to me, the padata people, and
netdev@vger.kernel.org, and we can all hash this out together.

Regarding your patch, is there a way to make that a bit more succinct,
without introducing all of those helper functions? It seems awfully
verbose for something that seems like a matter of replacing the online
mask with the housekeeping mask.

Jason

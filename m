Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B56B515664
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 23:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232812AbiD2VMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 17:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235478AbiD2VLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 17:11:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A8A90CD6;
        Fri, 29 Apr 2022 14:07:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FDD6621A2;
        Fri, 29 Apr 2022 21:07:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D2C1C385A7;
        Fri, 29 Apr 2022 21:07:51 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="gp22e6Ab"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1651266469;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T3WSFHl/zsaHB//X+4QZBZP56RvEC9a5K3oHLJtCsc4=;
        b=gp22e6Ab0KJvPS8oSKXwN/w3bZ1NeJiHKqYTYmSjpz6QDnx/CjYIllGvYCqoSa+dzuSWuX
        LAuXmS00gQ/Dmjm8JPOlw48mlwmV/F3C/KH3oxI5dtjb/sOChPQvdPULQcHnkyblPeqYZu
        dTPeTg4krxWSmUL95/3lA1ZbL9QpN5w=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 20977a27 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 29 Apr 2022 21:07:49 +0000 (UTC)
Date:   Fri, 29 Apr 2022 23:07:47 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kuba@kernel.org,
        hannes@stressinduktion.org, edumazet@google.com
Subject: Re: Routing loops & TTL tracking with tunnel devices
Message-ID: <YmxTo2hVwcwhdvjO@zx2c4.com>
References: <CAHmME9r_DbZWe4FsfebHSSf_iPctSe5S-w9bU3o8BN43raeURg@mail.gmail.com>
 <20151116203709.GA27178@oracle.com>
 <CAHmME9pNCqbcoqbOnx6p8poehAntyyy1jQhy=0_HjkJ8nvMQdw@mail.gmail.com>
 <1447712932.22599.77.camel@edumazet-glaptop2.roam.corp.google.com>
 <CAHmME9oTU7HwP5=qo=aFWe0YXv5EPGoREpF2k-QY7qTmkDeXEA@mail.gmail.com>
 <YmszSXueTxYOC41G@zx2c4.com>
 <04f72c85-557f-d67c-c751-85be65cb015a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <04f72c85-557f-d67c-c751-85be65cb015a@gmail.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On Fri, Apr 29, 2022 at 01:54:27PM -0700, Eric Dumazet wrote:
> > Anyway, it'd be nice if there were a free u8 somewhere in sk_buff that I
> > could use for tracking times through the stack. Other kernels have this
> > but afaict Linux still does not. I looked into trying to overload some
> > existing fields -- tstamp/skb_mstamp_ns or queue_mapping -- which I was
> > thinking might be totally unused on TX?
> 
> 
> if skbs are stored in some internal wireguard queue, can not you use 
> skb->cb[],
> 
> like many other layers do ?

This isn't for some internal wireguard queue. The packets get sent out
of udp_tunnel_xmit_skb(), so they leave wireguard's queues.

Jason

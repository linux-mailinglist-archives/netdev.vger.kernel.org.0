Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C60F64A8C9F
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 20:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349129AbiBCTj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 14:39:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242407AbiBCTj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 14:39:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47301C061714;
        Thu,  3 Feb 2022 11:39:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DAC20619B0;
        Thu,  3 Feb 2022 19:39:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54D1C340E8;
        Thu,  3 Feb 2022 19:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643917165;
        bh=8wgcfcT97A17mO/FY8bT734mipRs/NkUDSjyemgdkJ8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UulR/6DVbEt5oqVOmDl3lFwXn8jjB5MG6Gj6FKlDJay18FtwU+Rot7RpOWJ8Xc0qg
         isR5fohCVIw8JJZilc++0WgYz2/0Biz2E4xrTC0sWYrrSC2vClYaMmcghqhfO5jq1D
         nqQE672QaGyK9vMzPC7HTvnNrojb/VhQ39e+f6ltE/2nxWvzUk5Fu24UWdj/QlTw7W
         g0SpiQnKZ6YZpC/40UyUGsKVQqf6s+hTsu2aMMGb2SAsK5GWc4bTnTMxzRx9hDCoAl
         McJZDSdBMvTcFArr0mUwAUdw5Iq53tdV73nRV8RBA+5z4BLSKlI0/PgDyryhhpo04F
         hkh6ROAzE0tvg==
Date:   Thu, 3 Feb 2022 11:39:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next v2 4/4] net: dev: Make rps_lock() disable
 interrupts.
Message-ID: <20220203113924.3bf8e0b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YfwFunubdlRK/8IZ@linutronix.de>
References: <20220202122848.647635-1-bigeasy@linutronix.de>
        <20220202122848.647635-5-bigeasy@linutronix.de>
        <20220202084735.126397eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YfwFunubdlRK/8IZ@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Feb 2022 17:41:30 +0100 Sebastian Andrzej Siewior wrote:
> > I think you can re-jig this a little more - rps_ipi_queued() only return
> > 0 if sd is "local" so maybe we can call __napi_schedule_irqoff()
> > instead which already has the if () for PREEMPT_RT?
> > 
> > Maybe moving the ____napi_schedule() into rps_ipi_queued() and
> > renaming it to napi_schedule_backlog() or napi_schedule_rps() 
> > would make the code easier to follow in that case?  
> 
> Something like this then?

Exactly!

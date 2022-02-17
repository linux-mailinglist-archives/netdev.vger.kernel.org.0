Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAAD94BA2E1
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 15:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241846AbiBQOWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 09:22:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241819AbiBQOWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 09:22:08 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB3E294132;
        Thu, 17 Feb 2022 06:21:53 -0800 (PST)
Date:   Thu, 17 Feb 2022 15:21:49 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1645107711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gYqMzMEmnyZNlVwlJpaYK81pkaPzlE57O2DCGW97rmM=;
        b=lIKgrIfcN65xgSBXszCEgKClfdyMa4xAG9AbFAJEDFdI/V9wg4maXYP7AhVYXuOFPqfjBw
        irn+Jx0RukBH5tzFMhIvLRvzw/FWYmMvEkh+yErJRuIGdydSqGfLhtayq4ZN8HHpg0HNpA
        9qaoAizNy+zk4LayMd+5aIX5Ukn+MbxoqjkqAoL/+HLYuXCLFOXPNGK13KE26SU+m1g2ML
        jpmNWI23zMkYH3ajQTBYba+hk69VA6VArH0YSn2pzQqj4Qs9hfnsYnBd6IEeT3tonZRcoW
        TlUFVx933u4397db0Pecb0GZBiUhc+rZf8zpLKpvkyzgpw/7uWdUEa1JXwXLjg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1645107711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gYqMzMEmnyZNlVwlJpaYK81pkaPzlE57O2DCGW97rmM=;
        b=KHcQE34LtofoIxc8iwkJWG3IY2ALg9PlggROFJoqZlgKQRZmTHuxzAxRvacYFnVAFCIK+D
        ccfVAJ83TteFhJDw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH net-next] net: Correct wrong BH disable in hard-interrupt.
Message-ID: <Yg5Z/bpn/CBJXAqf@linutronix.de>
References: <CGME20220216175054eucas1p2d8aef6c75806dcdab18b37a4e317dd08@eucas1p2.samsung.com>
 <Yg05duINKBqvnxUc@linutronix.de>
 <ce67e9c9-966e-3a08-e571-b7f1dacb3814@samsung.com>
 <c2a64979-73d1-2c22-e048-c275c9f81558@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c2a64979-73d1-2c22-e048-c275c9f81558@samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-02-17 15:08:55 [+0100], Marek Szyprowski wrote:
> Hi All,
Hi,

> I've just noticed that there is one more issue left to fix (the $subject 
> patch is already applied) - this one comes from threaded irq (if I got 
> the stack trace right):

This is not `threadirqs' on the command line, right?

Sebastian

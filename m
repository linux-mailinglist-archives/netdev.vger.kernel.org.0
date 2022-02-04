Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF4264A9D18
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 17:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376621AbiBDQmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 11:42:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233928AbiBDQmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 11:42:54 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6D9C061714;
        Fri,  4 Feb 2022 08:42:54 -0800 (PST)
Date:   Fri, 4 Feb 2022 17:42:50 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643992971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4XZTU4wmWUWLDFUjoz8D2nbE2MCYqnI9+bmek8EHaps=;
        b=fJ4Y+5Gulp4wtblwtIbUQ3w4LklYJ5+E4Uga4E2Pv47lOeKF5xjLfRo536GHqJGFAn/HnR
        qi00pPi+MuejRFb/QnIj9N3G5svjBqNc+YM9cHpxmr4UGGnyGAY4j/clTFVRCRw+7DEXfk
        auBk80pXCKhdz2AjI2vqaBLOjqVN0hsnOIVnd7mul2DVfF3nL0EGvjowqYAb6V3P3Pv2hQ
        y9o2tXN3VkSwkWyG35nXHBd0EBe6QrbUCMVXY8nscf0LjHg1wkLi0QNDuWyhFlZJ9S3CrY
        IYHOkJFxCkjWzJyyjhapJi/t1YQdR2rAA45oUXOKEUaUK2duh1LhO0WwsminrQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643992971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4XZTU4wmWUWLDFUjoz8D2nbE2MCYqnI9+bmek8EHaps=;
        b=TGokyNjwxU9Z3Aa2lvdSdFlZYBU9og67bnyHawo2iJkwWOsb2XjflNkRwI9wjdibp90mrR
        HP7i10T+BkCXguCQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Eric Dumazet <edumazet@google.com>, bpf <bpf@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next v2 1/4] net: dev: Remove preempt_disable() and
 get_cpu() in netif_rx_internal().
Message-ID: <Yf1XiuPUY2TY/6yP@linutronix.de>
References: <20220202122848.647635-1-bigeasy@linutronix.de>
 <20220202122848.647635-2-bigeasy@linutronix.de>
 <CANn89iJm9krQ-kjVBxFzxh0nG46O5RWDg=QyXhiq1nA3Erf9KQ@mail.gmail.com>
 <87v8xwb1o9.fsf@toke.dk>
 <YfvH9YpKTIU4EByk@linutronix.de>
 <87leysazrq.fsf@toke.dk>
 <Yf1EWFgPtjIq3Hzw@linutronix.de>
 <20220204083107.02dbf3d5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220204083107.02dbf3d5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-02-04 08:31:07 [-0800], Jakub Kicinski wrote:
> On Fri, 4 Feb 2022 16:20:56 +0100 Sebastian Andrzej Siewior wrote:
> > Subject: [PATCH net-next v2 1/4] net: dev: Remove preempt_disable() and  get_cpu() in netif_rx_internal().
> 
> FWIW, you'll need to repost the full series for it to be applied at 
> the end. It'd be useful to add RFC in the subject of the one-off update
> patches, maybe, so that I know that you know and patchwork knows that
> we both know that a full repost will come. A little circle of knowing.

Sure, will remember the RFC part.

Sebastian

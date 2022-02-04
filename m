Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFED4A9E90
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 19:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377331AbiBDSDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 13:03:35 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:33178 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377324AbiBDSDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 13:03:34 -0500
Date:   Fri, 4 Feb 2022 19:03:31 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643997812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MuZKvwXxtgF4yhlP6xlS6MNzJOgTYYPbqVVA6uTQ5GI=;
        b=zgPeP54OsL6V+6g5+nh1dOp1wdVfR+13fRA/w7S9XoSmW8Rs76NLfCBGU24hvuzp/IBB9Y
        e61TTkd9yXwW2DWQP5vLyemKXZHbJ1WvzSsYQAVAvYDeUJjzQgnqsJiD3SBadY/HIr+EQT
        Yd6DXtzulkrZ3A0ar34OXnRio7jT3w0br+VwLGxVjjz/evmg9Ve/RNQx827aA2MQL/A3SR
        LP8AdZW35Oj/se/y82iSey+fn5xO5TTra3KdS5a6vOIHXlSjRqrKAXMTiIjWGjrFmhctnB
        nNQoWZ9YOjg32rjA9YILV8t8x7QJodYcRDLsvd98Cr6OinxRhBe54hzm7ADcjg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643997812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MuZKvwXxtgF4yhlP6xlS6MNzJOgTYYPbqVVA6uTQ5GI=;
        b=migV9KOYgLvnHfCiZ2OwYCoT0nnuwmGB3Q0VowIWxFaVKBReXmiKuuTLgFcQsWW0liHREw
        Az8PfRUyX4gUShCg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Yannick Vignon <yannick.vignon@oss.nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Paolo Abeni <pabeni@redhat.com>, Wei Wang <weiwan@google.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, mingkai.hu@nxp.com,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@nxp.com, Yannick Vignon <yannick.vignon@nxp.com>
Subject: Re: [PATCH net-next 1/2] net: napi: wake up ksoftirqd if needed
 after scheduling NAPI
Message-ID: <Yf1qc7R5rFoALsCo@linutronix.de>
References: <20220203184031.1074008-1-yannick.vignon@oss.nxp.com>
 <CANn89iKn20yuortKnqKV99s=Pb9HHXbX8e0=58f_szkTWnQbCQ@mail.gmail.com>
 <0ad1a438-8e29-4613-df46-f913e76a1770@oss.nxp.com>
 <20220203170901.52ccfd09@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YfzhioY0Mj3M1v4S@linutronix.de>
 <20220204074317.4a8be6d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <078bffa8-6feb-9637-e874-254b6d4b188e@oss.nxp.com>
 <20220204094522.4a233a2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220204094522.4a233a2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-02-04 09:45:22 [-0800], Jakub Kicinski wrote:
> Coincidentally, I believe the threaded NAPI wake up is buggy - 
> we assume the thread is only woken up when NAPI gets scheduled,
> but IIUC signal delivery and other rare paths may wake up kthreads,
> randomly.

I had to look into NAPI-threads for some reason.
What I dislike is that after enabling it via sysfs I have to:
- adjust task priority manual so it is preferred over other threads.
  This is usually important on RT. But then there is no overload
  protection.

- set an affinity-mask for the thread so it does not migrate from one
  CPU to the other. This is worse for a RT task where the scheduler
  tries to keep the task running.

Wouldn't it work to utilize the threaded-IRQ API and use that instead
the custom thread? Basically the primary handler would what it already
does (disable the interrupt) and the threaded handler would feed packets
into the stack. In the overload case one would need to lower the
thread-priority.

Sebastian

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F41E94A9E3C
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 18:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377161AbiBDRqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 12:46:32 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:58656 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377129AbiBDRp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 12:45:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 61892CE23E1
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 17:45:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D41DC36AEC;
        Fri,  4 Feb 2022 17:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643996724;
        bh=zMVshGyD8JwMKZoTuTdinjV/3Y+ayAfHr9RmVffMalY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lLXCAWLCE36wIbZo7t4b0Bi6rJjcYorXXe7i9Z0DAHvhJaHKkQHlnXY3ozz0iZttV
         XbwNaioScXwe4iMpPLyRdZiZy7Y+VfWYWerueVNzrIIKWqUv7wHbBX7oMgzIqejIi6
         QNEHdg1gnMdNaPpr07Rpd8QaFXoi0pT4qDiBtU26gDUYXfFuF+ejtITIwN1l2sy/rb
         iXOz9ORoqtk3RGJKmHxvOgQAcsfV32f3pfZUA9RzT/J7CJx62Seg3BCSYMUa/v3ujl
         S4b2I3704i+8035xMiGxlm1uRSNait0jw8wJ169awzcxCgdijTj6BiHwT6pa93wtB8
         87qI8YQZtl/Uw==
Date:   Fri, 4 Feb 2022 09:45:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yannick Vignon <yannick.vignon@oss.nxp.com>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
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
Message-ID: <20220204094522.4a233a2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <078bffa8-6feb-9637-e874-254b6d4b188e@oss.nxp.com>
References: <20220203184031.1074008-1-yannick.vignon@oss.nxp.com>
        <CANn89iKn20yuortKnqKV99s=Pb9HHXbX8e0=58f_szkTWnQbCQ@mail.gmail.com>
        <0ad1a438-8e29-4613-df46-f913e76a1770@oss.nxp.com>
        <20220203170901.52ccfd09@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YfzhioY0Mj3M1v4S@linutronix.de>
        <20220204074317.4a8be6d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <078bffa8-6feb-9637-e874-254b6d4b188e@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Feb 2022 18:15:40 +0100 Yannick Vignon wrote:
> > I see, what I was getting at is on PREEMPT_RT IRQs are already threaded
> > so I thought the patch was only targeting non-RT, I didn't think that
> > explicitly threading IRQ is advantageous also on RT.
> 
> Something I forgot to mention is that the final use case I care about 
> uses threaded NAPI (because of the improvement it gives when processing 
> latency-sensitive network streams). And in that case, __napi_schedule is 
> simply waking up the NAPI thread, no softirq is needed, and my 
> controversial change isn't even needed for the whole system to work 
> properly.

Coincidentally, I believe the threaded NAPI wake up is buggy - 
we assume the thread is only woken up when NAPI gets scheduled,
but IIUC signal delivery and other rare paths may wake up kthreads,
randomly.

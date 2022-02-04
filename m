Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59D7F4A9F84
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 19:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377763AbiBDSwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 13:52:33 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:32768 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347727AbiBDSwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 13:52:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 199FCB8370E
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 18:52:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A7BC004E1;
        Fri,  4 Feb 2022 18:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644000749;
        bh=6fY052q9T4GJ2u/3jVBW5iskLvXkM0ciuhqL/D2X/Q8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qPbVQ1V9ROrmHZ+rLIPpZ8FsgTw7grNF/YCLQUyK9TIOfjvWYQ4DQU3Vzmgv6Kzd2
         LiwhwVhiZGw8PDsX3jLmYNDEQpD07ioTh4OYuvveROT5UKb8W7d+06N5bYp7nRSK4X
         gHviosmGhGC2jXbK8AYKJkgoed1sk7FirJTYLW1CKUTudXSVqz/rfb4G0lTnadokJb
         hAmqhL7BKTWDMAdF7/Z8VU10/FxwEM7VLm1y3SzDyWBDKwjcc7WGdH7KTB6OQs31rM
         I+MUNh4eIA1g9oHdc1zKtiuhTuZgR8XTSadQlZHeQetGoT2QDeJUsJY7cAjes9MsZ8
         qkASm002CL84g==
Date:   Fri, 4 Feb 2022 10:52:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
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
Message-ID: <20220204105227.32d9a1f2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220204105035.4e207e9c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220203184031.1074008-1-yannick.vignon@oss.nxp.com>
        <CANn89iKn20yuortKnqKV99s=Pb9HHXbX8e0=58f_szkTWnQbCQ@mail.gmail.com>
        <0ad1a438-8e29-4613-df46-f913e76a1770@oss.nxp.com>
        <20220203170901.52ccfd09@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YfzhioY0Mj3M1v4S@linutronix.de>
        <20220204074317.4a8be6d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <078bffa8-6feb-9637-e874-254b6d4b188e@oss.nxp.com>
        <20220204094522.4a233a2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <Yf1qc7R5rFoALsCo@linutronix.de>
        <20220204105035.4e207e9c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Feb 2022 10:50:35 -0800 Jakub Kicinski wrote:
> To be clear -- are you suggesting that drivers just switch to threaded
> NAPI,

s/NAPI/IRQs/

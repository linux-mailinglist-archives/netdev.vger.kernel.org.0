Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2F9D4AE099
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 19:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353333AbiBHSV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 13:21:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbiBHSV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 13:21:57 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D13FC061578
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 10:21:56 -0800 (PST)
Date:   Tue, 8 Feb 2022 19:21:50 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1644344512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PNUJvwxkXvuL7PBal3v6ermE6pCkemV/xZDJ3tugatM=;
        b=n6NGNbXKCvinFg0H5ZMNAx0IEOkFFhVJJHD4x1jVeHPyhv4BbH6d+iwIIN5MoQwU3zDlJG
        4zzYK5kHuBhXdzua99Vbzs7sDHf4cAmoWsGy0xa8u4RfzZB8pEVF2vYYm/+BXGZO+ouIlw
        7trH1yLghHhOLrU5GgeiBWL40tZ3Dawr/Z96ofVgxxXQqSSP/UgkYDuOKkbdF+ef+ACsB0
        gM7Qw7coOKfLOuR2y17i0FZcDm6NqNfEiPpVSG5d06BWTQa1P/p8i/xgE4uQQA8WEg9GwE
        +1nAvs1E08GVEuCsFAsL0wf76WcczukIwRiWDJdO81raI684gWvZHtBUH0BU2g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1644344512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PNUJvwxkXvuL7PBal3v6ermE6pCkemV/xZDJ3tugatM=;
        b=rHx9dIEziQx6gSWAdohOzoyvmSDQI5VARDc9o6JP/GeXoIk4X+rXyScKzutBRoLM00EKwT
        TcLagkKaVTcYN3DQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Yannick Vignon <yannick.vignon@oss.nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Wei Wang <weiwan@google.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, mingkai.hu@nxp.com,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@nxp.com, Yannick Vignon <yannick.vignon@nxp.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next 1/2] net: napi: wake up ksoftirqd if needed
 after scheduling NAPI
Message-ID: <YgK0vi8Zs37LdoK4@linutronix.de>
References: <0ad1a438-8e29-4613-df46-f913e76a1770@oss.nxp.com>
 <20220203170901.52ccfd09@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YfzhioY0Mj3M1v4S@linutronix.de>
 <20220204074317.4a8be6d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <078bffa8-6feb-9637-e874-254b6d4b188e@oss.nxp.com>
 <20220204094522.4a233a2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <Yf1qc7R5rFoALsCo@linutronix.de>
 <20220204105035.4e207e9c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YgJZK42urDmKQfgf@linutronix.de>
 <8b5010f2e6730ad0af0b9d8949cf34bc17681b12.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <8b5010f2e6730ad0af0b9d8949cf34bc17681b12.camel@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-02-08 16:57:59 [+0100], Paolo Abeni wrote:
> just for historic reference:
>=20
> https://lkml.org/lkml/2016/6/15/460

that is
  https://lore.kernel.org/all/cover.1465996447.git.pabeni@redhat.com

let me digest that later=E2=80=A6

> I think that running the thread performing the NAPI loop with
> SCHED_FIFO would be dangerous WRT DDOS. Even the affinity setting can
> give mixed results depending on the workload - unless you do good
> static CPUs allocation pinning each process manually, not really a
> generic setup.

The DDoS part is where I meant we need figure out the details. Since it
is a threaded-interrupt we could do msleep() as a break which is similar
to what softirq does. Detecting such a case might be difficult since the
budget is per-thread only and does not involve other NAPI-structs on the
same CPU like backlog.

The performance is usually best if the IRQ and threaded handler are
running on the same CPU. The win with the NAPI thread seems to be that
if two NAPIs fire on the same CPU then the scheduler will see two tasks
which will be moved (at some point) to different CPUs. And in a DDoS
like situation they can constantly push new skbs into the stack and
SCHED_OTHER ensures that the user can still do something. Without napi
threads, both NAPIs would be processed on the same CPU (in order) and
eventually moved to ksoftirqd where it will take a break under high
load.

> Cheers,
>=20
> Paolo

Sebastian

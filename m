Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB7D66E87F4
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 04:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbjDTC02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 22:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbjDTC01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 22:26:27 -0400
X-Greylist: delayed 541 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 19 Apr 2023 19:26:25 PDT
Received: from out-50.mta0.migadu.com (out-50.mta0.migadu.com [91.218.175.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DFE4448A
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 19:26:25 -0700 (PDT)
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1681957042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lOy66Q/DbugBr5ItDpBNMFTk1EVu6PPve3atEJp0Woo=;
        b=NBjvRaBa39+JvSSPoZZ8wI8AmTLPHcxvUIZIMgonNx03V6syHNyVa7agG5JP1oVDOnhql/
        5Rx5UP0iI7hJbV7QVVrqJhHVl7JYKDoak4BjLMZ69eFm6YuJnjUYo5OVEwmPj/rt90L79z
        OBheRL1ezDGj2OocsRd118y6To4jKEw=
Date:   Thu, 20 Apr 2023 02:17:21 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   "Yajun Deng" <yajun.deng@linux.dev>
Message-ID: <acb95e0283e0720979f67f8321c3cdbe@linux.dev>
Subject: Re: [PATCH] net: sched: print jiffies when transmit queue time
 out
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20230419182713.2cd1f81b@kernel.org>
References: <20230419182713.2cd1f81b@kernel.org>
 <20230419115632.738730-1-yajun.deng@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

April 20, 2023 9:27 AM, "Jakub Kicinski" <kuba@kernel.org> wrote:=0A=0A> =
On Wed, 19 Apr 2023 19:56:32 +0800 Yajun Deng wrote:=0A> =0A>> Although t=
here is watchdog_timeo to let users know when the transmit queue=0A>> beg=
in stall, but dev_watchdog() is called with an interval. The jiffies=0A>>=
 will always be greater than watchdog_timeo.=0A>> =0A>> To let users know=
 the exact time the stall started, print jiffies when=0A>> the transmit q=
ueue time out.=0A> =0A> Please add an explanation of how this information=
 is useful in practice.=0A=0AWe found some cases with several warnings. W=
e want to confirm which happened first. =0A=0AFirst warning:=0A16:37:57 k=
ernel: [ 7100.097547] ------------[ cut here ]------------=0A16:37:57 ker=
nel: [ 7100.097550] NETDEV WATCHDOG: eno2 (i40e): transmit queue 8 timed =
out=0A16:37:57 kernel: [ 7100.097571] WARNING: CPU: 8 PID: 0 at net/sched=
/sch_generic.c:467 dev_watchdog+0x260/0x270=0A...=0A=0ASecond warning:=0A=
16:38:44 kernel: [ 7147.756952] rcu: INFO: rcu_preempt self-detected stal=
l on CPU=0A16:38:44 kernel: [ 7147.756958] rcu:   24-....: (59999 ticks t=
his GP) idle=3D546/1/0x4000000000000000 softirq=3D367      3137/3673146 f=
qs=3D13844=0A16:38:44 kernel: [ 7147.756960]        (t=3D60001 jiffies g=
=3D4322709 q=3D133381)=0A16:38:44 kernel: [ 7147.756962] NMI backtrace fo=
r cpu 24=0A...=0A=0AAs we can see, the transmit queue start stall should =
be before 16:37:52, the rcu start stall is 16:37:44.=0AThese two times ar=
e closer, we want to confirm which happened first.

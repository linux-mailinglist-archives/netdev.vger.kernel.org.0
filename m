Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47D2F4BB68D
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 11:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233947AbiBRKNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 05:13:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233358AbiBRKNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 05:13:31 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC545D653;
        Fri, 18 Feb 2022 02:13:14 -0800 (PST)
Date:   Fri, 18 Feb 2022 11:13:11 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1645179192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5CTtnPIKV/WgERZtU+EmiMrPJMj2EWK/MS5N5srOidY=;
        b=onjtIKX1v1S89cgWbUsmJWZMQyW9G45n/qJZLIaJkvwruPxs6rokl4N2tMvPt/7iamdkXQ
        jQisazSP0CasjtA8jJz9CNkwjxWDAvDBMUUB0a5gw+Bk6iOaOxFlXpbiIPOe+ul1xeld0V
        v37ZeFNiS43Yvjuplzo/qKIuUMeXYAJaUKgziKUiyV0StwAeYJ/nJNb1Ng2GV0wQD7b6KL
        esae1J906ycv4/BUUn7hVWwg4iEUy3UrGdceXYI0MeiHW96PaadoapYBxZRkFLaBLUY1vz
        fl1DwjrQFHwJZy2iWP1k6NZCLoAQ/wpTba2//yPIYH4GKHROYFQ/Gli31Fq05g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1645179192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5CTtnPIKV/WgERZtU+EmiMrPJMj2EWK/MS5N5srOidY=;
        b=YDgmSTJ1p9Uowt19cRjuOLc33ZRHcIUmg9yH5/RvJNa+tMWnMOAJVOw6kJbA3KTZn8LDDg
        SWUGATwLVDqS54BA==
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
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next] net: Correct wrong BH disable in hard-interrupt.
Message-ID: <Yg9xN5e3zyjKTfJw@linutronix.de>
References: <CGME20220216175054eucas1p2d8aef6c75806dcdab18b37a4e317dd08@eucas1p2.samsung.com>
 <Yg05duINKBqvnxUc@linutronix.de>
 <ce67e9c9-966e-3a08-e571-b7f1dacb3814@samsung.com>
 <c2a64979-73d1-2c22-e048-c275c9f81558@samsung.com>
 <Yg9oNlF+YCot6WcO@linutronix.de>
 <2dc85036-c5a8-d79b-71b5-9288d0a53c37@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2dc85036-c5a8-d79b-71b5-9288d0a53c37@samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-02-18 11:02:35 [+0100], Marek Szyprowski wrote:
> Hi,
Hi,

> > Marek, could you please give it a try?
> 
> Yes. The above change fixes the issue.

Awesome. I will make a patch and send today.

> I've also tried to revert the mentioned commit e5f68b4a3e7b, but this 
> gives me the following lockdep warning:

Oh oh. Thank you for that splat.

Sebastian

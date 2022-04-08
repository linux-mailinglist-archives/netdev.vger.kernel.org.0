Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFE614F8C49
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 05:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbiDHBA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 21:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233290AbiDHBAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 21:00:46 -0400
X-Greylist: delayed 915 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 07 Apr 2022 17:58:40 PDT
Received: from m12-11.163.com (m12-11.163.com [220.181.12.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 23E6F30CB90;
        Thu,  7 Apr 2022 17:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=31tFs
        14/hmEFriPL+huf8+43YyXdMqfNdNECql3AeLY=; b=GvVZnnvs2HPhWoZWaBWRO
        gMLwwmYNGA7v2djsGWoUK7aBqwQhFNpRZuTXNuRQTjj9cHMV2TGc3L9FIK5xCERF
        B+g9xKWszjLFK3DJNjgxbDGW1fBXZL+/osmJiXZI83wercjflJE8ZCapN2RKxEpW
        nZpCIYpuAnPdl7ksK/1Reg=
Received: from localhost.localdomain (unknown [101.86.109.27])
        by smtp7 (Coremail) with SMTP id C8CowAAnnmHphE9i3wPwAA--.23557S2;
        Fri, 08 Apr 2022 08:42:19 +0800 (CST)
From:   jackygam2001 <jacky_gam_2001@163.com>
To:     edumazet@google.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        rostedt@goodmis.org, mingo@redhat.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yhs@fb.com, ping.gan@dell.com
Subject: Re: [PATCH net-next] tcp: Add tracepoint for tcp_set_ca_state
Date:   Fri,  8 Apr 2022 08:40:49 +0800
Message-Id: <20220408004050.27292-1-jacky_gam_2001@163.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <CANn89iKXK6m45eBDCDw8Pij1H=iybZTTi2Yf9DFYu96KDpnyPA@mail.gmail.com>
References: <CANn89iKXK6m45eBDCDw8Pij1H=iybZTTi2Yf9DFYu96KDpnyPA@mail.gmail.com>
Reply-To: edumazet@google.com
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: C8CowAAnnmHphE9i3wPwAA--.23557S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKrW5Aw45JF17uF48ArW7XFb_yoW3AFcE9F
        WIvr1kJrs8Jry8Xan3AryxXrn7GayvgF98Aw17tryFva42yFW8XFnrWrs5urZxW3WxWry3
        uwn3Jan0y342gjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUUNzV5UUUUU==
X-Originating-IP: [101.86.109.27]
X-CM-SenderInfo: 5mdfy55bjdzsisqqiqqrwthudrp/xS2BdAPbKVgi1hfy0AABsd
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SCC_BODY_URI_ONLY,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At 2022-04-07 14:05:42, "Eric Dumazet" <edumazet@google.com> wrote:
> On Tue, Apr 5, 2022 at 6:12 PM jackygam2001 <jacky_gam_2001@163.com> wrote:
> >
> > From: Ping Gan <jacky_gam_2001@163.com>
> >
> > The congestion status of a tcp flow may be updated since there
> > is congestion between tcp sender and receiver. It makes sense to
> > add tracepoint for congestion status set function to summate cc
> > status duration and evaluate the performance of network
> > and congestion algorithm. the backgound of this patch is below.
> >
> > Link: https://github.com/iovisor/bcc/pull/3899
> >
> > Signed-off-by: Ping Gan <jacky_gam_2001@163.com>
> > ---
>
> This seems good to me, thanks.
>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
Thanks for you comment and review!



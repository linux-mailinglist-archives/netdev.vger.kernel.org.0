Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94CF36BA5EA
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 05:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjCOEKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 00:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjCOEKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 00:10:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BCD13E631;
        Tue, 14 Mar 2023 21:10:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32480B81BC1;
        Wed, 15 Mar 2023 04:10:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0195C433D2;
        Wed, 15 Mar 2023 04:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678853429;
        bh=ntjkd5ecWuLKH9Sa/6T6Lz65wiAmBbJRc4QFXD440lA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nzJS2fTD3ItSldIrXvK1bybRMUC8QxOQMHHiviZkAM0QoS3MkXwMfRY6m7F6H37lj
         N7UVRJK+ZYOibo9+MsVYRk9CWyrwnnevTlwZhdf/omL4y+6Zynz6xpfWf7ACnZi/SE
         KWCCpsoh48g/AlJO7Mshs0OM0SNtZdEvoBGTVxkrlTPOMPq8w0tZ593Wi1Xe/U9yjF
         CWKOWoIYq9H6kW3yRxaQryMf5bMj/MxldO+PZp9AESvh78iLd7woWv3mrOztle/GE8
         kRwqCap6r0Hyb983hnUQIm8wYDEvE+lOwHM0vllCX+2J2j+BNaQmSym8EAbv9rsNuH
         lTQWRJ0AtRr7w==
Date:   Tue, 14 Mar 2023 21:10:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zheng Hacker <hackerzheng666@gmail.com>
Cc:     Zheng Wang <zyytlz.wz@163.com>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, 1395428693sheep@gmail.com,
        alex000young@gmail.com
Subject: Re: [PATCH net] net: ethernet: fix use after free bug in
 ns83820_remove_one due to race condition
Message-ID: <20230314211028.6e9cbbcf@kernel.org>
In-Reply-To: <CAJedcCxBn=GE_pQ4xzpnvUmMA6rDuwn_AiE7S7d1EqGF9cHkNw@mail.gmail.com>
References: <20230309094231.3808770-1-zyytlz.wz@163.com>
        <20230313162630.225f6a86@kernel.org>
        <CAJedcCxBn=GE_pQ4xzpnvUmMA6rDuwn_AiE7S7d1EqGF9cHkNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Mar 2023 09:59:09 +0800 Zheng Hacker wrote:
> Jakub Kicinski <kuba@kernel.org> =E4=BA=8E2023=E5=B9=B43=E6=9C=8814=E6=97=
=A5=E5=91=A8=E4=BA=8C 07:26=E5=86=99=E9=81=93=EF=BC=9A
> > On Thu,  9 Mar 2023 17:42:31 +0800 Zheng Wang wrote: =20
> > > +     cancel_work_sync(&dev->tq_refill);
> > >       ns83820_disable_interrupts(dev); /* paranoia */
> > >
> > >       unregister_netdev(ndev); =20
> >
> > Canceling the work before unregister can't work.
> > Please take a closer look, the work to refill a ring should be
> > canceled when the ring itself is dismantled. =20
>=20
> Hi Jakub,
>=20
> Thanks for your review! After seeing code again, I found when handling
> IRQ request, it will finally call ns83820_irq->ns83820_do_isr->
> ns83820_rx_kick->schedule_work to start work. So I think we should
> move the code after free_irq. What do you think?

Sorry, we have over 300 patches which need reviews. I don't have=20
the time to help you. Perhaps someone else will.

Please make sure you work on a single networking fix at a time.
All the patches you posted had the same issues.

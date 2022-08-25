Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B41145A1637
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 17:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242295AbiHYP7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 11:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242451AbiHYP7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 11:59:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 991F2895EB;
        Thu, 25 Aug 2022 08:59:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 570D5B82A39;
        Thu, 25 Aug 2022 15:59:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01C5C433C1;
        Thu, 25 Aug 2022 15:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661443148;
        bh=ZfeKWeixSO0jSL608lHkwjyEVMv1W3X2t4lL2j2+rPU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XaMI0D9+XksYktJaqp2eD9dyLP+zDC1k91BgXn8/rqPwLGoPa/pED4w4qOYLd4QeL
         /w+R3XnPZUHYCCgsbErOu8MAnJNnVk/uFvssZ4r/72KafijyAKBcHELbB9tUvdKRdY
         JIPJ2WXxUYvNYYybtGtpgmE4kO5pQOlzWAsWgX/IAG4LM6owe4ZRKgalrRhenr4yLn
         Kq840obUMTic2UqPZqN60ADk84aw6/Yzu2M8SH6cqdT35StBczyxZQjCDeoyxzZhme
         7NCqAQrgJkHwc02hNdXgvMJzs1WVunpjJrk229J9CZPa1l9/rfPo+szS+rbC7k8RoU
         tz0SwdCk8G/ZQ==
Date:   Thu, 25 Aug 2022 08:59:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "wanghai (M)" <wanghai38@huawei.com>
Cc:     <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <brouer@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net/sched: fix netdevice reference leaks in
 attach_one_default_qdisc()
Message-ID: <20220825085906.35704ce5@kernel.org>
In-Reply-To: <fc76cc5d-e1ee-e84e-c47b-8daa4dea43a0@huawei.com>
References: <20220817104646.22861-1-wanghai38@huawei.com>
        <20220818105642.6d58e9d4@kernel.org>
        <d1463bc2-6abd-7b01-5aac-8b7780b94cca@huawei.com>
        <fc76cc5d-e1ee-e84e-c47b-8daa4dea43a0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Aug 2022 20:29:21 +0800 wanghai (M) wrote:
> =E5=9C=A8 2022/8/19 23:58, wanghai (M) =E5=86=99=E9=81=93:
> > Here are the details of the failure. Do I need to do cleanup under the=
=20
> > failed path?
> >
> > If a dev has multiple queues and queue 0 fails to attach qdisc
> > because there is no memory in attach_one_default_qdisc(). Then
> > dev->qdisc will be noop_qdisc by default. But the other queues
> > may be able to successfully attach to default qdisc.
> >
> > In this case, the fallback to noqueue process will be triggered
> >
> > static void attach_default_qdiscs(struct net_device *dev)
> > {
> > =C2=A0=C2=A0 =C2=A0...
> > =C2=A0=C2=A0 =C2=A0if (!netif_is_multiqueue(dev) ||
> > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0 dev->priv_flags & IFF_NO_QUEUE) {
> > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 ...
> > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 netdev_for_eac=
h_tx_queue(dev, attach_one_default_qdisc,=20
> > NULL); // queue 0 attach failed because -ENOBUFS, but the other queues=
=20
> > attach successfully
> > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 qdisc =3D txq-=
>qdisc_sleeping;
> > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 rcu_assign_poi=
nter(dev->qdisc, qdisc); // dev->qdisc =3D=20
> > &noop_qdisc
> > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 ...
> > =C2=A0=C2=A0 =C2=A0}
> > =C2=A0=C2=A0 =C2=A0...
> > =C2=A0=C2=A0 =C2=A0if (qdisc =3D=3D &noop_qdisc) {
> > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0 ...
> > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0 netdev_for_each_tx_queue(dev, att=
ach_one_default_qdisc, NULL);=20
> > // Re-attach, but not release the previously created qdisc
> > =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0 ...
> > =C2=A0=C2=A0 =C2=A0}
> > }
>
> Do you have any other suggestions for this patch? Any replies would be=20
> appreciated.

Sorry for the silence and thanks for a solid explanation!

Can we do a:

netdev_for_each_tx_queue(dev, shutdown_scheduler_queue, &noop_qdisc);

before trying to re-attach, to clear out any non-noop qdisc that may
have gotten assigned?

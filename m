Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC2866AB933
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 10:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbjCFJDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 04:03:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbjCFJDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 04:03:50 -0500
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB34AD12;
        Mon,  6 Mar 2023 01:03:39 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VdDPc-._1678093416;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VdDPc-._1678093416)
          by smtp.aliyun-inc.com;
          Mon, 06 Mar 2023 17:03:37 +0800
Message-ID: <1678092272.631299-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v3] virtio-net: Fix probe of virtio-net on kvmtool
Date:   Mon, 6 Mar 2023 16:44:32 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rbradford@rivosinc.com, virtualization@lists.linux-foundation.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20230223-virtio-net-kvmtool-v3-1-e038660624de@rivosinc.com>
 <20230301093054-mutt-send-email-mst@kernel.org>
 <CACGkMEsG10CWigz+S6JgSVK8XfbpT=L=30hZ8LDvohtaanAiZQ@mail.gmail.com>
 <20230302044806-mutt-send-email-mst@kernel.org>
 <20230303164603.7b35a76f@kernel.org>
 <20230305045249-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230305045249-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 5 Mar 2023 04:53:58 -0500, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Fri, Mar 03, 2023 at 04:46:03PM -0800, Jakub Kicinski wrote:
> > On Thu, 2 Mar 2023 04:48:38 -0500 Michael S. Tsirkin wrote:
> > > > Looks not the core can try to enable and disable features according to
> > > > the diff between features and hw_features
> > > >
> > > > static inline netdev_features_t netdev_get_wanted_features(
> > > >         struct net_device *dev)
> > > > {
> > > >         return (dev->features & ~dev->hw_features) | dev->wanted_features;
> > > > }
> > >
> > > yes what we do work according to code.  So the documentation is wrong then?
> >
> > It's definitely incomplete but which part are you saying is wrong?
>
> So it says:
>   2. netdev->features set contains features which are currently enabled
>      for a device.
>
> ok so far.
> But this part:
>
>   This should be changed only by network core or in
>      error paths of ndo_set_features callback.
>
> seems to say virtio should not touch netdev->features, no?


I think the "changed" here refers to the user's opening or closing a function
by network core.

If the features contain a certain function, but hw_features does not include it
means that this function cannot be modified by user.


 *	struct net_device - The DEVICE structure.
 *   [....]
 *	@features:	Currently active device features
 *	@hw_features:	User-changeable features

Thanks.


>
> --
> MST
>
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization

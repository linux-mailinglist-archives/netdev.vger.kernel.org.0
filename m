Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5620B62B174
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 03:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbiKPCor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 21:44:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbiKPCoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 21:44:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8CA11C41F;
        Tue, 15 Nov 2022 18:44:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7157861843;
        Wed, 16 Nov 2022 02:44:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62CD0C433D6;
        Wed, 16 Nov 2022 02:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668566683;
        bh=/++rVgvIq2fiB1hShSRzWBW48QNbuvdmn/4eTcyeZlY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Dabsw+YB9lfb96T1sAp8Ek5iCMRfxI78BA8VVukZZcLe4812RdsnhClvocAnwQfKJ
         DcAfvIz9LejNakoQlk0gIA1MOeYZkcgsIYUxIWSUatbyX4J0MccBzX8f5JLwgBy6Vm
         oEk8y06U3gD/4D2HY0razMuVxPDf//B4nFnaQb798bpFflF83IlihjPnTm5RVl0LIt
         w0msH1+Am+YDe3a1dg6/Crkt63qW9WqdhNfwx1tjE42AqzHwkWm5nPS/wNPHl//ZGl
         drf1b7vjMXozj/Z8kdtw8Mh+YFEoluqXizRdgfF6hRet+MfFqP/pb1djRUlOzdXDTR
         0BII3WyziCSRA==
Date:   Tue, 15 Nov 2022 18:44:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Hawkins Jiawei <yin31149@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, 18801353760@163.com,
        syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: sched: fix memory leak in tcindex_set_parms
Message-ID: <20221115184442.272b6ea8@kernel.org>
In-Reply-To: <bc4616002932b25973533c39c07f48ea57afa3dc.camel@redhat.com>
References: <20221113170507.8205-1-yin31149@gmail.com>
        <20221115090237.5d5988bb@kernel.org>
        <bc4616002932b25973533c39c07f48ea57afa3dc.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Nov 2022 19:57:10 +0100 Paolo Abeni wrote:
> This code confuses me more than a bit, and I don't follow ?!?=20

It's very confusing :S

For starters I don't know when r !=3D old_r. I mean now it triggers
randomly after the RCU-ification, but in the original code when
it was just a memset(). When would old_r ever not be null and yet
point to a different entry?

> it looks like that at this point:
>=20
> * the data path could access 'old_r->exts' contents via 'p' just before
> the previous 'tcindex_filter_result_init(old_r, cp, net);' but still
> potentially within the same RCU grace period
>=20
> * 'tcindex_filter_result_init(old_r, cp, net);' has 'unlinked' the old
> exts from 'p'  so that will not be freed by later
> tcindex_partial_destroy_work()=C2=A0
>=20
> Overall it looks to me that we need some somewhat wait for the RCU
> grace period,=20

Isn't it better to make @cp a deeper copy of @p ?
I thought it already is but we don't seem to be cloning p->h.
Also the cloning of p->perfect looks quite lossy.

> Somewhat side question: it looks like that the 'perfect hashing' usage
> is the root cause of the issue addressed here, and very likely is
> afflicted by other problems, e.g. the data curruption in 'err =3D
> tcindex_filter_result_init(old_r, cp, net);'.
>=20
> AFAICS 'perfect hashing' usage is a sort of optimization that the user-
> space may trigger with some combination of the tcindex arguments. I'm
> wondering if we could drop all perfect hashing related code?

The thought of "how much of this can we delete" did cross my mind :)

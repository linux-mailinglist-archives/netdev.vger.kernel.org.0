Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDF6403C46
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 17:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349476AbhIHPJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 11:09:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349248AbhIHPJx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 11:09:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 548E6611C6;
        Wed,  8 Sep 2021 15:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631113725;
        bh=EcFdlIlPuXpuvXGjbL2rGt+KIE0grzuBurK1IY0GYXE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FYD6C6nflF/20yxECHrnoZBf29DPDeGsA08BuRUaUu4zoq4SOfCTCCObhS79xN04O
         2lfsy/eWmi8YES3m73WjP50fWo+g5qb6V9xSMuuv/0BBpt/0uD25K4v/3m8FBZFq90
         Yj7GtcWbEP280yCS1oBb9nGKyPL6s26OtKm0V0flqnG8x4oW2DA/8OTmsyocIi6xkx
         3shuPnOlles6AsM3pZdgn0gpdv8mZhbrRKFsLtclrBzJTQSd0FgNRgGHxdl9jT0RFl
         lZkB6myOLN0wFmMx45AzmDE9OHkm1kJMz6eyv02SQCQJj9cdLZElUSFxT345pI/97o
         oZoseWoFvIdgw==
Date:   Wed, 8 Sep 2021 08:08:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     moyufeng <moyufeng@huawei.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>, <davem@davemloft.net>,
        <alexander.duyck@gmail.com>, <linux@armlinux.org.uk>,
        <mw@semihalf.com>, <linuxarm@openeuler.org>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <thomas.petazzoni@bootlin.com>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <john.fastabend@gmail.com>,
        <akpm@linux-foundation.org>, <peterz@infradead.org>,
        <will@kernel.org>, <willy@infradead.org>, <vbabka@suse.cz>,
        <fenghua.yu@intel.com>, <guro@fb.com>, <peterx@redhat.com>,
        <feng.tang@intel.com>, <jgg@ziepe.ca>, <mcroce@microsoft.com>,
        <hughd@google.com>, <jonathan.lemon@gmail.com>, <alobakin@pm.me>,
        <willemb@google.com>, <wenxu@ucloud.cn>, <cong.wang@bytedance.com>,
        <haokexin@gmail.com>, <nogikh@google.com>, <elver@google.com>,
        <yhs@fb.com>, <kpsingh@kernel.org>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <chenhao288@hisilicon.com>
Subject: Re: [PATCH net-next v2 4/4] net: hns3: support skb's frag page
 recycling based on page pool
Message-ID: <20210908080843.2051c58d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <2b75d66b-a3bf-2490-2f46-fef5731ed7ad@huawei.com>
References: <1628217982-53533-1-git-send-email-linyunsheng@huawei.com>
        <1628217982-53533-5-git-send-email-linyunsheng@huawei.com>
        <2b75d66b-a3bf-2490-2f46-fef5731ed7ad@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Sep 2021 16:31:40 +0800 moyufeng wrote:
>     After adding page pool to hns3 receiving package process,
> we want to add some debug info. Such as below:
>=20
> 1. count of page pool allocate and free page, which is defined
> for pages_state_hold_cnt and pages_state_release_cnt in page
> pool framework.
>=20
> 2. pool size=E3=80=81order=E3=80=81nid=E3=80=81dev=E3=80=81max_len, which=
 is setted for
> each rx ring in hns3 driver.
>=20
> In this regard, we consider two ways to show these info=EF=BC=9A
>=20
> 1. Add it to queue statistics and query it by ethtool -S.
>=20
> 2. Add a file node "page_pool_info" for debugfs, then cat this
> file node, print as below:
>=20
> queue_id  allocate_cnt  free_cnt  pool_size  order  nid  dev  max_len
> 000		   xxx       xxx        xxx    xxx  xxx  xxx      xxx
> 001
> 002
> .
> .
> =09
> Which one is more acceptable, or would you have some other suggestion?

Normally I'd say put the stats in ethtool -S and the rest in debugfs
but I'm not sure if exposing pages_state_hold_cnt and
pages_state_release_cnt directly. Those are short counters, and will
very likely wrap. They are primarily meaningful for calculating
page_pool_inflight(). Given this I think their semantics may be too
confusing for an average ethtool -S user.

Putting all the information in debugfs seems like a better idea.

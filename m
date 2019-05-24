Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E19129880
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 15:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391582AbfEXNGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 09:06:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33892 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391045AbfEXNGb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 09:06:31 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C75D2C062EC4;
        Fri, 24 May 2019 13:06:30 +0000 (UTC)
Received: from [10.72.12.217] (ovpn-12-217.pek2.redhat.com [10.72.12.217])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED9E55B2E6;
        Fri, 24 May 2019 13:06:25 +0000 (UTC)
Subject: Re: [PATCH v3 2/2] net: core: support XDP generic on stacked devices.
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20190523175429.13302-1-sthemmin@microsoft.com>
 <20190523175429.13302-3-sthemmin@microsoft.com>
 <3dbe4e29bf1ec71809e9dd2b32ec16272957a4cd.camel@mellanox.com>
 <ebf12468-504c-fae7-b62d-2b6db47391f9@redhat.com>
 <20190524120715.6f1c13bd@carbon>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <183e6a98-032d-2184-6962-202210bfe4ce@redhat.com>
Date:   Fri, 24 May 2019 21:06:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190524120715.6f1c13bd@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Fri, 24 May 2019 13:06:30 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/5/24 下午6:07, Jesper Dangaard Brouer wrote:
> On Fri, 24 May 2019 12:17:27 +0800
> Jason Wang <jasowang@redhat.com> wrote:
>
>>> Maybe this is acceptable, but it should be documented, as the current
>>> assumption dictates: XDP program runs on the core where the XDP
>>> frame/SKB was first seen.
>>
>> At lest for TUN, this is not true. XDP frames were built by vhost_net
>> and passed to TUN. There's no guarantee that vhost_net kthread won't
>> move to another core.
> This sound a little scary, as we depend on per-CPU variables (e.g.
> bpf_redirect_info).  Can the vhost_net kthread move between CPUs
> within/during the NAPI-poll?


The RX of TUN will not go for NAPI usually. What we did is:

1) Vhost kthread prepares an array of XDP frames and pass them to TUN 
through sendmsg

2) TUN will disable bh and run XDP for each frames then enable bh

So kthread can move to another CPU before 2) but we guarantee that the 
per-CPU dependency of XDP work in 2).

TUN indeed has a NAPI mode which is mainly used for hardening, and XDP 
was not implemented on that path (this could be fixed in the future).

Thanks


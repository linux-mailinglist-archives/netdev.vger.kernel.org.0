Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 651CA56B3BD
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 09:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237532AbiGHHnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 03:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237486AbiGHHnD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 03:43:03 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357DF7D1DB;
        Fri,  8 Jul 2022 00:43:02 -0700 (PDT)
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1657266180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2chcDZoP7VrhRaGcDfWRBGm+iWZ2br0eyitmpkg5ZNw=;
        b=rDkOZpIMyEqSoRiLqkPHm9aJq5WIe1t7nwclPV6ZODTLZQ47QIfFFm9J+zC5n2mF/N3KPl
        EYZayuolQxFdpCOCJgBjeCpuWBN/8bEWAhynSJpDYesKQ9HoYVgms8rcVh39uP3RnzABcC
        2lAYep+cYz8AWEmIDe410lTxFf1DGWI=
Date:   Fri, 08 Jul 2022 07:43:00 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   "Yajun Deng" <yajun.deng@linux.dev>
Message-ID: <889ac4e3230740beb6acae5fd48cbc0f@linux.dev>
Subject: Re: [PATCH net-next] net: rtnetlink: add rx_otherhost_dropped for
 struct rtnl_link_stats
To:     "Eric Dumazet" <edumazet@google.com>
Cc:     "David Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "netdev" <netdev@vger.kernel.org>,
        "LKML" <linux-kernel@vger.kernel.org>,
        "Jeffrey Ji" <jeffreyji@google.com>
In-Reply-To: <CANn89iKuTLb15AMxXY8Q7FHF__f7kfRuDQFSkK1SwUR5m4fn+A@mail.gmail.com>
References: <CANn89iKuTLb15AMxXY8Q7FHF__f7kfRuDQFSkK1SwUR5m4fn+A@mail.gmail.com>
 <20220708063257.1192311-1-yajun.deng@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

July 8, 2022 3:03 PM, "Eric Dumazet" <edumazet@google.com> wrote:=0A=0A> =
On Fri, Jul 8, 2022 at 8:33 AM Yajun Deng <yajun.deng@linux.dev> wrote:=
=0A> =0A>> The commit 794c24e9921f ("net-core: rx_otherhost_dropped to co=
re_stats")=0A>> introduce rx_otherhost_dropped, add rx_otherhost_dropped =
for struct=0A>> rtnl_link_stats to keep sync with struct rtnl_link_stats6=
4.=0A>> =0A>> As the same time, add BUILD_BUG_ON() in copy_rtnl_link_stat=
s().=0A> =0A> Any reason you chose to not cc the original patch author ?=
=0A> =0ASorry for that, I'll do it later.=0A=0A> If I remember well, not =
adding fields into legacy 'struct=0A> rtnl_link_stats' was a conscious de=
cision.=0A> =0A> There is no requirement to keep rtnl_link_stats & rtnl_l=
ink_stats64 in sync.=0A> rtnl_link_stats is deprecated, user space really=
 wants to use=0A> rtnl_link_stats64 instead,=0A> if they need access to n=
ew fields added in recent kernels.=0A> =0AGot it. Thanks.=0A=0A> Thank yo=
u.=0A> =0A> [1]=0A> commit 9256645af09807bc52fa8b2e66ecd28ab25318c4=0A> A=
uthor: Jarod Wilson <jarod@redhat.com>=0A> Date: Mon Feb 1 18:51:04 2016 =
-0500=0A> =0A> net/core: relax BUILD_BUG_ON in netdev_stats_to_stats64=0A=
> =0A> The netdev_stats_to_stats64 function copies the deprecated=0A> net=
_device_stats format stats into rtnl_link_stats64 for legacy support=0A> =
purposes, but with the BUILD_BUG_ON as it was, it wasn't possible to=0A> =
extend rtnl_link_stats64 without also extending net_device_stats. Relax=
=0A> the BUILD_BUG_ON to only require that rtnl_link_stats64 is larger, a=
nd=0A> zero out all the stat counters that aren't present in net_device_s=
tats.=0A> =0A> CC: Eric Dumazet <edumazet@google.com>=0A> CC: netdev@vger=
.kernel.org=0A> Signed-off-by: Jarod Wilson <jarod@redhat.com>=0A> Signed=
-off-by: David S. Miller <davem@davemloft.net>=0A> =0A>> Signed-off-by: Y=
ajun Deng <yajun.deng@linux.dev>=0A>> ---=0A>> include/uapi/linux/if_link=
.h | 1 +=0A>> net/core/rtnetlink.c | 36 +++++++--------------------------=
---=0A>> 2 files changed, 8 insertions(+), 29 deletions(-)=0A>> =0A>> dif=
f --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h=0A>=
> index e36d9d2c65a7..fd6776d665c8 100644=0A>> --- a/include/uapi/linux/i=
f_link.h=0A>> +++ b/include/uapi/linux/if_link.h=0A>> @@ -37,6 +37,7 @@ s=
truct rtnl_link_stats {=0A>> __u32 tx_compressed;=0A>> =0A>> __u32 rx_noh=
andler;=0A>> + __u32 rx_otherhost_dropped;=0A>> };=0A>> =0A>> /**=0A>> di=
ff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c=0A>> index ac45328=
607f7..818649850b2c 100644=0A>> --- a/net/core/rtnetlink.c=0A>> +++ b/net=
/core/rtnetlink.c=0A>> @@ -908,35 +908,13 @@ static unsigned int rtnl_dev=
_combine_flags(const struct net_device *dev,=0A>> static void copy_rtnl_l=
ink_stats(struct rtnl_link_stats *a,=0A>> const struct rtnl_link_stats64 =
*b)=0A>> {=0A>> - a->rx_packets =3D b->rx_packets;=0A>> - a->tx_packets =
=3D b->tx_packets;=0A>> - a->rx_bytes =3D b->rx_bytes;=0A>> - a->tx_bytes=
 =3D b->tx_bytes;=0A>> - a->rx_errors =3D b->rx_errors;=0A>> - a->tx_erro=
rs =3D b->tx_errors;=0A>> - a->rx_dropped =3D b->rx_dropped;=0A>> - a->tx=
_dropped =3D b->tx_dropped;=0A>> -=0A>> - a->multicast =3D b->multicast;=
=0A>> - a->collisions =3D b->collisions;=0A>> -=0A>> - a->rx_length_error=
s =3D b->rx_length_errors;=0A>> - a->rx_over_errors =3D b->rx_over_errors=
;=0A>> - a->rx_crc_errors =3D b->rx_crc_errors;=0A>> - a->rx_frame_errors=
 =3D b->rx_frame_errors;=0A>> - a->rx_fifo_errors =3D b->rx_fifo_errors;=
=0A>> - a->rx_missed_errors =3D b->rx_missed_errors;=0A>> -=0A>> - a->tx_=
aborted_errors =3D b->tx_aborted_errors;=0A>> - a->tx_carrier_errors =3D =
b->tx_carrier_errors;=0A>> - a->tx_fifo_errors =3D b->tx_fifo_errors;=0A>=
> - a->tx_heartbeat_errors =3D b->tx_heartbeat_errors;=0A>> - a->tx_windo=
w_errors =3D b->tx_window_errors;=0A>> -=0A>> - a->rx_compressed =3D b->r=
x_compressed;=0A>> - a->tx_compressed =3D b->tx_compressed;=0A>> -=0A>> -=
 a->rx_nohandler =3D b->rx_nohandler;=0A>> + size_t i, n =3D sizeof(*b) /=
 sizeof(u64);=0A>> + const u64 *src =3D (const u64 *)b;=0A>> + u32 *dst =
=3D (u32 *)a;=0A>> +=0A>> + BUILD_BUG_ON(n !=3D sizeof(*a) / sizeof(u32))=
;=0A>> + for (i =3D 0; i < n; i++)=0A>> + dst[i] =3D src[i];=0A>> }=0A>> =
=0A>> /* All VF info */=0A>> --=0A>> 2.25.1

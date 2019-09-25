Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE5E3BD6F6
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 06:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633875AbfIYEI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 00:08:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39974 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387842AbfIYEI1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Sep 2019 00:08:27 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 178DA308A98C;
        Wed, 25 Sep 2019 04:08:27 +0000 (UTC)
Received: from [10.72.12.148] (ovpn-12-148.pek2.redhat.com [10.72.12.148])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8BE1F19C58;
        Wed, 25 Sep 2019 04:08:13 +0000 (UTC)
Subject: Re: [PATCH net-next] tuntap: Fallback to automq on TUNSETSTEERINGEBPF
 prog negative return
To:     Matt Cover <werekraken@gmail.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com,
        Eric Dumazet <edumazet@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Matthew Cover <matthew.cover@stackpath.com>,
        mail@timurcelik.de, pabeni@redhat.com,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        wangli39@baidu.com, lifei.shirley@bytedance.com,
        tglx@linutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <20190920185843.4096-1-matthew.cover@stackpath.com>
 <20190922080326-mutt-send-email-mst@kernel.org>
 <CAGyo_hqGbFdt1PoDrmo=S5iTO8TwbrbtOJtbvGT1WrFFMLwk-Q@mail.gmail.com>
 <20190922162546-mutt-send-email-mst@kernel.org>
 <CAGyo_hr+_oSwVSKSqKTXaouaMK-6b8+NVLTxWmZD3vn07GEGWA@mail.gmail.com>
 <f2e5b3d5-f38c-40e7-dda9-e1ed737a0135@redhat.com>
 <CAGyo_hohbFP+=eu3jWL954hrOgqu4upaw6HTH2=1qC9jcENWxQ@mail.gmail.com>
 <7d3abb5d-c5a7-9fbd-f82e-88b4bf717a0b@redhat.com>
 <CAGyo_hondiOXi8GtqZg-YNV3A+COV=5PMHoNKaHbBjnTRTUe9Q@mail.gmail.com>
 <b96ecf36-8f13-4a52-5355-7d88ec9e4a98@redhat.com>
 <CAGyo_hq2fyVOOJ9ktDoM9M4umAonb0ofhP6puTz91UHEp=ojDA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <76a19f4a-90de-3904-28e2-653dfb6da495@redhat.com>
Date:   Wed, 25 Sep 2019 12:08:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAGyo_hq2fyVOOJ9ktDoM9M4umAonb0ofhP6puTz91UHEp=ojDA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Wed, 25 Sep 2019 04:08:27 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/9/24 上午12:31, Matt Cover wrote:
>> I think it's better to safe to just drop the packet instead of trying to
>> workaround it.
>>
> This patch aside, dropping the packet here
> seems like the wrong choice. Loading a
> prog at this hookpoint "configures"
> steering. The action of configuring
> steering should not result in dropped
> packets.
>
> Suboptimal delivery is generally preferable
> to no delivery. Leaving the behavior as-is
> (i.e. relying on netdev_cap_txqueue()) or
> making any return which doesn't fit in a
> u16 simply use queue 0 would be highly
> preferable to dropping the packet.
>
>> Thanks


It leaves a choice for steering ebpf program to drop the packet that it 
can't classify. But consider we have already had socket filter, it 
probably not a big problem since we can drop packets there.

Thanks


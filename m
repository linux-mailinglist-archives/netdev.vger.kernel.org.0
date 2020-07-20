Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C55225A89
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 10:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727949AbgGTIzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 04:55:37 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:36232 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726601AbgGTIzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 04:55:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595235334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UzR9l21YOuN3ikEPzc8GrzbgrODXjbPXreiywMK7+XE=;
        b=gSS+dIRs4A+BXSTl0cT/9/SJ3+8ZLnNnPQhht/DZYdDT2wNh61QVnefTKcnVgE/bSrA7BM
        +dHmoTHbb2x+uTpTUDVLUH/KVRMF3fu4dGqpWAa9Hnsf3Fq+E47hYZQjXS4ty3bColUaC4
        FXxblusQJ1hayAb/WktIB2TfUzj5DCc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-tqdoLv4dPYC4cfAHA3ofZw-1; Mon, 20 Jul 2020 04:55:31 -0400
X-MC-Unique: tqdoLv4dPYC4cfAHA3ofZw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 46A1C1932488;
        Mon, 20 Jul 2020 08:55:30 +0000 (UTC)
Received: from [10.72.12.53] (ovpn-12-53.pek2.redhat.com [10.72.12.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5CD54619C4;
        Mon, 20 Jul 2020 08:55:22 +0000 (UTC)
Subject: Re: [PATCH RFC v8 02/11] vhost: use batched get_vq_desc version
To:     Eugenio Perez Martin <eperezma@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20200622122546-mutt-send-email-mst@kernel.org>
 <CAJaqyWfbouY4kEXkc6sYsbdCAEk0UNsS5xjqEdHTD7bcTn40Ow@mail.gmail.com>
 <CAJaqyWefMHPguj8ZGCuccTn0uyKxF9ZTEi2ASLtDSjGNb1Vwsg@mail.gmail.com>
 <419cc689-adae-7ba4-fe22-577b3986688c@redhat.com>
 <CAJaqyWedEg9TBkH1MxGP1AecYHD-e-=ugJ6XUN+CWb=rQGf49g@mail.gmail.com>
 <0a83aa03-8e3c-1271-82f5-4c07931edea3@redhat.com>
 <CAJaqyWeqF-KjFnXDWXJ2M3Hw3eQeCEE2-7p1KMLmMetMTm22DQ@mail.gmail.com>
 <20200709133438-mutt-send-email-mst@kernel.org>
 <7dec8cc2-152c-83f4-aa45-8ef9c6aca56d@redhat.com>
 <CAJaqyWdLOH2EceTUduKYXCQUUNo1XQ1tLgjYHTBGhtdhBPHn_Q@mail.gmail.com>
 <20200710015615-mutt-send-email-mst@kernel.org>
 <CAJaqyWf1skGxrjuT9GLr6dtgd-433y-rCkbtStLHaAs2W2jYXA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <595d4cf3-2b15-8900-e714-f3ebd8d8ca2e@redhat.com>
Date:   Mon, 20 Jul 2020 16:55:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAJaqyWf1skGxrjuT9GLr6dtgd-433y-rCkbtStLHaAs2W2jYXA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/7/17 上午1:16, Eugenio Perez Martin wrote:
> On Fri, Jul 10, 2020 at 7:58 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>> On Fri, Jul 10, 2020 at 07:39:26AM +0200, Eugenio Perez Martin wrote:
>>>>> How about playing with the batch size? Make it a mod parameter instead
>>>>> of the hard coded 64, and measure for all values 1 to 64 ...
>>>>
>>>> Right, according to the test result, 64 seems to be too aggressive in
>>>> the case of TX.
>>>>
>>> Got it, thanks both!
>> In particular I wonder whether with batch size 1
>> we get same performance as without batching
>> (would indicate 64 is too aggressive)
>> or not (would indicate one of the code changes
>> affects performance in an unexpected way).
>>
>> --
>> MST
>>
> Hi!
>
> Varying batch_size as drivers/vhost/net.c:VHOST_NET_BATCH,


Did you mean varying the value of VHOST_NET_BATCH itself or the number 
of batched descriptors?


> and testing
> the pps as previous mail says. This means that we have either only
> vhost_net batching (in base testing, like previously to apply this
> patch) or both batching sizes the same.
>
> I've checked that vhost process (and pktgen) goes 100% cpu also.
>
> For tx: Batching decrements always the performance, in all cases. Not
> sure why bufapi made things better the last time.
>
> Batching makes improvements until 64 bufs, I see increments of pps but like 1%.
>
> For rx: Batching always improves performance. It seems that if we
> batch little, bufapi decreases performance, but beyond 64, bufapi is
> much better. The bufapi version keeps improving until I set a batching
> of 1024. So I guess it is super good to have a bunch of buffers to
> receive.
>
> Since with this test I cannot disable event_idx or things like that,
> what would be the next step for testing?
>
> Thanks!
>
> --
> Results:
> # Buf size: 1,16,32,64,128,256,512
>
> # Tx
> # ===
> # Base
> 2293304.308,3396057.769,3540860.615,3636056.077,3332950.846,3694276.154,3689820


What's the meaning of buf size in the context of "base"?

And I wonder maybe perf diff can help.

Thanks


> # Batch
> 2286723.857,3307191.643,3400346.571,3452527.786,3460766.857,3431042.5,3440722.286
> # Batch + Bufapi
> 2257970.769,3151268.385,3260150.538,3379383.846,3424028.846,3433384.308,3385635.231,3406554.538
>
> # Rx
> # ==
> # pktgen results (pps)
> 1223275,1668868,1728794,1769261,1808574,1837252,1846436
> 1456924,1797901,1831234,1868746,1877508,1931598,1936402
> 1368923,1719716,1794373,1865170,1884803,1916021,1975160
>
> # Testpmd pps results
> 1222698.143,1670604,1731040.6,1769218,1811206,1839308.75,1848478.75
> 1450140.5,1799985.75,1834089.75,1871290,1880005.5,1934147.25,1939034
> 1370621,1721858,1796287.75,1866618.5,1885466.5,1918670.75,1976173.5,1988760.75,1978316
>
> pktgen was run again for rx with 1024 and 2048 buf size, giving
> 1988760.75 and 1978316 pps. Testpmd goes the same way.
>


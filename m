Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D22F2210B1E
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 14:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730554AbgGAMkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 08:40:05 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42307 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730448AbgGAMkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 08:40:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593607202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rDoDyGkJGsZ638vn9DjgrnMCysPvmzBivywkj+/t4v4=;
        b=b4jpKkyrSd5GW0DyqfqWId3FKTD/r5vmTVgXMW/6k6rv3MvD87CdTgPWIVLcJCgF9whJPy
        rp2hcXKeXb+UOp5nOZpXE2jYyIe28AZsS2k+ZUaFrSVEZfs+w9ePbBYIIXd0KI+wMHiIcj
        894b8RxUHgvRMSHDWi2k4owXV8pRlPE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-gXijiZa0PLK1hcSaUWwlYw-1; Wed, 01 Jul 2020 08:39:59 -0400
X-MC-Unique: gXijiZa0PLK1hcSaUWwlYw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D272C800D5C;
        Wed,  1 Jul 2020 12:39:57 +0000 (UTC)
Received: from [10.72.13.177] (ovpn-13-177.pek2.redhat.com [10.72.13.177])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E62B7169B;
        Wed,  1 Jul 2020 12:39:52 +0000 (UTC)
Subject: Re: [PATCH RFC v8 02/11] vhost: use batched get_vq_desc version
To:     Eugenio Perez Martin <eperezma@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20200611113404.17810-1-mst@redhat.com>
 <20200611113404.17810-3-mst@redhat.com>
 <20200611152257.GA1798@char.us.oracle.com>
 <CAJaqyWdwXMX0JGhmz6soH2ZLNdaH6HEdpBM8ozZzX9WUu8jGoQ@mail.gmail.com>
 <CAJaqyWdwgy0fmReOgLfL4dAv-E+5k_7z3d9M+vHqt0aO2SmOFg@mail.gmail.com>
 <20200622114622-mutt-send-email-mst@kernel.org>
 <CAJaqyWfrf94Gc-DMaXO+f=xC8eD3DVCD9i+x1dOm5W2vUwOcGQ@mail.gmail.com>
 <20200622122546-mutt-send-email-mst@kernel.org>
 <CAJaqyWfbouY4kEXkc6sYsbdCAEk0UNsS5xjqEdHTD7bcTn40Ow@mail.gmail.com>
 <CAJaqyWefMHPguj8ZGCuccTn0uyKxF9ZTEi2ASLtDSjGNb1Vwsg@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <419cc689-adae-7ba4-fe22-577b3986688c@redhat.com>
Date:   Wed, 1 Jul 2020 20:39:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAJaqyWefMHPguj8ZGCuccTn0uyKxF9ZTEi2ASLtDSjGNb1Vwsg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/7/1 下午6:43, Eugenio Perez Martin wrote:
> On Tue, Jun 23, 2020 at 6:15 PM Eugenio Perez Martin
> <eperezma@redhat.com> wrote:
>> On Mon, Jun 22, 2020 at 6:29 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>>> On Mon, Jun 22, 2020 at 06:11:21PM +0200, Eugenio Perez Martin wrote:
>>>> On Mon, Jun 22, 2020 at 5:55 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>>>>> On Fri, Jun 19, 2020 at 08:07:57PM +0200, Eugenio Perez Martin wrote:
>>>>>> On Mon, Jun 15, 2020 at 2:28 PM Eugenio Perez Martin
>>>>>> <eperezma@redhat.com> wrote:
>>>>>>> On Thu, Jun 11, 2020 at 5:22 PM Konrad Rzeszutek Wilk
>>>>>>> <konrad.wilk@oracle.com> wrote:
>>>>>>>> On Thu, Jun 11, 2020 at 07:34:19AM -0400, Michael S. Tsirkin wrote:
>>>>>>>>> As testing shows no performance change, switch to that now.
>>>>>>>> What kind of testing? 100GiB? Low latency?
>>>>>>>>
>>>>>>> Hi Konrad.
>>>>>>>
>>>>>>> I tested this version of the patch:
>>>>>>> https://lkml.org/lkml/2019/10/13/42
>>>>>>>
>>>>>>> It was tested for throughput with DPDK's testpmd (as described in
>>>>>>> http://doc.dpdk.org/guides/howto/virtio_user_as_exceptional_path.html)
>>>>>>> and kernel pktgen. No latency tests were performed by me. Maybe it is
>>>>>>> interesting to perform a latency test or just a different set of tests
>>>>>>> over a recent version.
>>>>>>>
>>>>>>> Thanks!
>>>>>> I have repeated the tests with v9, and results are a little bit different:
>>>>>> * If I test opening it with testpmd, I see no change between versions
>>>>>
>>>>> OK that is testpmd on guest, right? And vhost-net on the host?
>>>>>
>>>> Hi Michael.
>>>>
>>>> No, sorry, as described in
>>>> http://doc.dpdk.org/guides/howto/virtio_user_as_exceptional_path.html.
>>>> But I could add to test it in the guest too.
>>>>
>>>> These kinds of raw packets "bursts" do not show performance
>>>> differences, but I could test deeper if you think it would be worth
>>>> it.
>>> Oh ok, so this is without guest, with virtio-user.
>>> It might be worth checking dpdk within guest too just
>>> as another data point.
>>>
>> Ok, I will do it!
>>
>>>>>> * If I forward packets between two vhost-net interfaces in the guest
>>>>>> using a linux bridge in the host:
>>>>> And here I guess you mean virtio-net in the guest kernel?
>>>> Yes, sorry: Two virtio-net interfaces connected with a linux bridge in
>>>> the host. More precisely:
>>>> * Adding one of the interfaces to another namespace, assigning it an
>>>> IP, and starting netserver there.
>>>> * Assign another IP in the range manually to the other virtual net
>>>> interface, and start the desired test there.
>>>>
>>>> If you think it would be better to perform then differently please let me know.
>>>
>>> Not sure why you bother with namespaces since you said you are
>>> using L2 bridging. I guess it's unimportant.
>>>
>> Sorry, I think I should have provided more context about that.
>>
>> The only reason to use namespaces is to force the traffic of these
>> netperf tests to go through the external bridge. To test netperf
>> different possibilities than the testpmd (or pktgen or others "blast
>> of frames unconditionally" tests).
>>
>> This way, I make sure that is the same version of everything in the
>> guest, and is a little bit easier to manage cpu affinity, start and
>> stop testing...
>>
>> I could use a different VM for sending and receiving, but I find this
>> way a faster one and it should not introduce a lot of noise. I can
>> test with two VM if you think that this use of network namespace
>> introduces too much noise.
>>
>> Thanks!
>>
>>>>>>    - netperf UDP_STREAM shows a performance increase of 1.8, almost
>>>>>> doubling performance. This gets lower as frame size increase.
> Regarding UDP_STREAM:
> * with event_idx=on: The performance difference is reduced a lot if
> applied affinity properly (manually assigning CPU on host/guest and
> setting IRQs on guest), making them perform equally with and without
> the patch again. Maybe the batching makes the scheduler perform
> better.


Note that for UDP_STREAM, the result is pretty trick to be analyzed. E.g 
setting a sndbuf for TAP may help for the performance (reduce the drop).


>
>>>>>>    - rests of the test goes noticeably worse: UDP_RR goes from ~6347
>>>>>> transactions/sec to 5830
> * Regarding UDP_RR, TCP_STREAM, and TCP_RR, proper CPU pinning makes
> them perform similarly again, only a very small performance drop
> observed. It could be just noise.
> ** All of them perform better than vanilla if event_idx=off, not sure
> why. I can try to repeat them if you suspect that can be a test
> failure.
>
> * With testpmd and event_idx=off, if I send from the VM to host, I see
> a performance increment especially in small packets. The buf api also
> increases performance compared with only batching: Sending the minimum
> packet size in testpmd makes pps go from 356kpps to 473 kpps.


What's your setup for this. The number looks rather low. I'd expected 
1-2 Mpps at least.


> Sending
> 1024 length UDP-PDU makes it go from 570kpps to 64 kpps.
>
> Something strange I observe in these tests: I get more pps the bigger
> the transmitted buffer size is. Not sure why.
>
> ** Sending from the host to the VM does not make a big change with the
> patches in small packets scenario (minimum, 64 bytes, about 645
> without the patch, ~625 with batch and batch+buf api). If the packets
> are bigger, I can see a performance increase: with 256 bits,


I think you meant bytes?


>   it goes
> from 590kpps to about 600kpps, and in case of 1500 bytes payload it
> gets from 348kpps to 528kpps, so it is clearly an improvement.
>
> * with testpmd and event_idx=on, batching+buf api perform similarly in
> both directions.
>
> All of testpmd tests were performed with no linux bridge, just a
> host's tap interface (<interface type='ethernet'> in xml),


What DPDK driver did you use in the test (AF_PACKET?).


> with a
> testpmd txonly and another in rxonly forward mode, and using the
> receiving side packets/bytes data. Guest's rps, xps and interrupts,
> and host's vhost threads affinity were also tuned in each test to
> schedule both testpmd and vhost in different processors.


My feeling is that if we start from simple setup, it would be more 
easier as a start. E.g start without an VM.

1) TX: testpmd(txonly) -> virtio-user -> vhost_net -> XDP_DROP on TAP
2) RX: pkgetn -> TAP -> vhost_net -> testpmd(rxonly)

Thanks


>
> I will send the v10 RFC with the small changes requested by Stefan and Jason.
>
> Thanks!
>
>
>
>
>
>
>
>>>>> OK so it seems plausible that we still have a bug where an interrupt
>>>>> is delayed. That is the main difference between pmd and virtio.
>>>>> Let's try disabling event index, and see what happens - that's
>>>>> the trickiest part of interrupts.
>>>>>
>>>> Got it, will get back with the results.
>>>>
>>>> Thank you very much!
>>>>
>>>>>
>>>>>>    - TCP_STREAM goes from ~10.7 gbps to ~7Gbps
>>>>>>    - TCP_RR from 6223.64 transactions/sec to 5739.44


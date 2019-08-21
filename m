Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7240297B35
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 15:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728932AbfHUNq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 09:46:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59092 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728608AbfHUNq2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 09:46:28 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9E6E26412B;
        Wed, 21 Aug 2019 13:46:27 +0000 (UTC)
Received: from [10.36.116.152] (ovpn-116-152.ams2.redhat.com [10.36.116.152])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DF8685C21A;
        Wed, 21 Aug 2019 13:46:25 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Magnus Karlsson" <magnus.karlsson@gmail.com>
Cc:     "Network Development" <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Martin KaFai Lau" <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, "Yonghong Song" <yhs@fb.com>,
        "Andrii Nakryiko" <andrii.nakryiko@gmail.com>
Subject: Re: [PATCH bpf-next v4] libbpf: add xsk_ring_prod__nb_free() function
Date:   Wed, 21 Aug 2019 15:46:23 +0200
Message-ID: <BC1D077F-1601-451D-A396-1C129B185DD3@redhat.com>
In-Reply-To: <CAJ8uoz3MszznV7McpttcVauQ5vgSiOpfT7J=63BNbruVwjFQBQ@mail.gmail.com>
References: <d1773613833e2824f95c3adbe46bff757280c16e.1565790591.git.echaudro@redhat.com>
 <CAJ8uoz3MszznV7McpttcVauQ5vgSiOpfT7J=63BNbruVwjFQBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Wed, 21 Aug 2019 13:46:27 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21 Aug 2019, at 15:11, Magnus Karlsson wrote:

> On Wed, Aug 14, 2019 at 3:51 PM Eelco Chaudron <echaudro@redhat.com> 
> wrote:
>>
>> When an AF_XDP application received X packets, it does not mean X
>> frames can be stuffed into the producer ring. To make it easier for
>> AF_XDP applications this API allows them to check how many frames can
>> be added into the ring.
>>
>> The patch below looks like a name change only, but the xsk_prod__
>> prefix denotes that this API is exposed to be used by applications.
>>
>> Besides, if you set the nb value to the size of the ring, you will
>> get the exact amount of slots available, at the cost of performance
>> (you touch shared state for sure). nb is there to limit the
>> touching of the shared state.
>>
>> Also the example xdpsock application has been modified to use this
>> new API, so it's also able to process flows at a 1pps rate on veth
>> interfaces.
>
> My apologies for the late reply and thank you for working on this. So
> what kind of performance difference do you see with your modified
> xdpsock application on a regular NIC for txpush and l2fwd? If there is
> basically no difference or it is faster, we can go ahead and accept
> this. But if the difference is large, we might consider to have two
> versions of txpush and l2fwd as the regular NICs do not need this. Or
> we optimize your code so that it becomes as fast as the previous
> version.

For both operation modes, I ran 5 test with and without the changes 
applied using an iexgb connecting to a XENA tester. The throughput 
numbers were within the standard deviation, so no noticeable performance 
gain or drop.

Let me know if this is enough, if not I can rebuild the setup and do 
some more tests.

> /Magnus
>
>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>> ---
>>
>> v3 -> v4
>>   - Cleanedup commit message
>>   - Updated AF_XDP sample application to use this new API
>>
>> v2 -> v3
>>   - Removed cache by pass option
>>
>> v1 -> v2
>>   - Renamed xsk_ring_prod__free() to xsk_ring_prod__nb_free()
>>   - Add caching so it will only touch global state when needed
>>
>>  samples/bpf/xdpsock_user.c | 109 
>> ++++++++++++++++++++++++++++---------
>>  tools/lib/bpf/xsk.h        |   4 +-
>>  2 files changed, 86 insertions(+), 27 deletions(-)
>>
>> diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
>> index 93eaaf7239b2..87115e233b54 100644
>> --- a/samples/bpf/xdpsock_user.c
>> +++ b/samples/bpf/xdpsock_user.c
>> @@ -461,9 +461,13 @@ static void kick_tx(struct xsk_socket_info *xsk)
>>
>>  static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk)
>>  {
>> -       u32 idx_cq = 0, idx_fq = 0;
>> -       unsigned int rcvd;
>> +       static u64 free_frames[NUM_FRAMES];
>> +       static size_t nr_free_frames;
>> +
>> +       u32 idx_cq = 0, idx_fq = 0, free_slots;
>> +       unsigned int rcvd, i;
>>         size_t ndescs;
>> +       int ret;
>>
>>         if (!xsk->outstanding_tx)
>>                 return;
>> @@ -474,27 +478,52 @@ static inline void complete_tx_l2fwd(struct 
>> xsk_socket_info *xsk)
>>
>>         /* re-add completed Tx buffers */
>>         rcvd = xsk_ring_cons__peek(&xsk->umem->cq, ndescs, &idx_cq);
>> -       if (rcvd > 0) {
>> -               unsigned int i;
>> -               int ret;
>> +       if (!rcvd)
>> +               return;
>>
>> -               ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, 
>> &idx_fq);
>> -               while (ret != rcvd) {
>> -                       if (ret < 0)
>> -                               exit_with_error(-ret);
>> -                       ret = xsk_ring_prod__reserve(&xsk->umem->fq, 
>> rcvd,
>> -                                                    &idx_fq);
>> -               }
>> -               for (i = 0; i < rcvd; i++)
>> +       /* When xsk_ring_cons__peek() for example returns that 5 
>> packets
>> +        * have been received, it does not automatically mean that
>> +        * xsk_ring_prod__reserve() will have 5 slots available. You 
>> will
>> +        * see this, for example, when using a veth interface due to 
>> the
>> +        * RX_BATCH_SIZE used by the generic driver.
>> +        *
>> +        * In this example we store unused buffers and try to 
>> re-stock
>> +        * them the next iteration.
>> +        */
>> +
>> +       free_slots = xsk_prod__nb_free(&xsk->umem->fq, rcvd + 
>> nr_free_frames);
>> +       if (free_slots > rcvd + nr_free_frames)
>> +               free_slots = rcvd + nr_free_frames;
>> +
>> +       ret = xsk_ring_prod__reserve(&xsk->umem->fq, free_slots, 
>> &idx_fq);
>> +       while (ret != free_slots) {
>> +               if (ret < 0)
>> +                       exit_with_error(-ret);
>> +               ret = xsk_ring_prod__reserve(&xsk->umem->fq, 
>> free_slots,
>> +                                            &idx_fq);
>> +       }
>> +       for (i = 0; i < rcvd; i++) {
>> +               u64 addr = *xsk_ring_cons__comp_addr(&xsk->umem->cq, 
>> idx_cq++);
>> +
>> +               if (i < free_slots)
>>                         *xsk_ring_prod__fill_addr(&xsk->umem->fq, 
>> idx_fq++) =
>> -                               
>> *xsk_ring_cons__comp_addr(&xsk->umem->cq,
>> -                                                         idx_cq++);
>> +                               addr;
>> +               else
>> +                       free_frames[nr_free_frames++] = addr;
>> +       }
>>
>> -               xsk_ring_prod__submit(&xsk->umem->fq, rcvd);
>> -               xsk_ring_cons__release(&xsk->umem->cq, rcvd);
>> -               xsk->outstanding_tx -= rcvd;
>> -               xsk->tx_npkts += rcvd;
>> +       if (free_slots > rcvd) {
>> +               for (i = 0; i < (free_slots - rcvd); i++) {
>> +                       u64 addr = free_frames[--nr_free_frames];
>> +                       *xsk_ring_prod__fill_addr(&xsk->umem->fq, 
>> idx_fq++) =
>> +                               addr;
>> +               }
>>         }
>> +
>> +       xsk_ring_prod__submit(&xsk->umem->fq, free_slots);
>> +       xsk_ring_cons__release(&xsk->umem->cq, rcvd);
>> +       xsk->outstanding_tx -= rcvd;
>> +       xsk->tx_npkts += rcvd;
>>  }
>>
>>  static inline void complete_tx_only(struct xsk_socket_info *xsk)
>> @@ -517,19 +546,37 @@ static inline void complete_tx_only(struct 
>> xsk_socket_info *xsk)
>>
>>  static void rx_drop(struct xsk_socket_info *xsk)
>>  {
>> +       static u64 free_frames[NUM_FRAMES];
>> +       static size_t nr_free_frames;
>> +
>>         unsigned int rcvd, i;
>> -       u32 idx_rx = 0, idx_fq = 0;
>> +       u32 idx_rx = 0, idx_fq = 0, free_slots;
>>         int ret;
>>
>>         rcvd = xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE, &idx_rx);
>>         if (!rcvd)
>>                 return;
>>
>> -       ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq);
>> -       while (ret != rcvd) {
>> +       /* When xsk_ring_cons__peek() for example returns that 5 
>> packets
>> +        * have been received, it does not automatically mean that
>> +        * xsk_ring_prod__reserve() will have 5 slots available. You 
>> will
>> +        * see this, for example, when using a veth interface due to 
>> the
>> +        * RX_BATCH_SIZE used by the generic driver.
>> +        *
>> +        * In this example we store unused buffers and try to 
>> re-stock
>> +        * them the next iteration.
>> +        */
>> +
>> +       free_slots = xsk_prod__nb_free(&xsk->umem->fq, rcvd + 
>> nr_free_frames);
>> +       if (free_slots > rcvd + nr_free_frames)
>> +               free_slots = rcvd + nr_free_frames;
>> +
>> +       ret = xsk_ring_prod__reserve(&xsk->umem->fq, free_slots, 
>> &idx_fq);
>> +       while (ret != free_slots) {
>>                 if (ret < 0)
>>                         exit_with_error(-ret);
>> -               ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, 
>> &idx_fq);
>> +               ret = xsk_ring_prod__reserve(&xsk->umem->fq, 
>> free_slots,
>> +                                            &idx_fq);
>>         }
>>
>>         for (i = 0; i < rcvd; i++) {
>> @@ -538,10 +585,22 @@ static void rx_drop(struct xsk_socket_info 
>> *xsk)
>>                 char *pkt = xsk_umem__get_data(xsk->umem->buffer, 
>> addr);
>>
>>                 hex_dump(pkt, len, addr);
>> -               *xsk_ring_prod__fill_addr(&xsk->umem->fq, idx_fq++) = 
>> addr;
>> +               if (i < free_slots)
>> +                       *xsk_ring_prod__fill_addr(&xsk->umem->fq, 
>> idx_fq++) =
>> +                               addr;
>> +               else
>> +                       free_frames[nr_free_frames++] = addr;
>> +       }
>> +
>> +       if (free_slots > rcvd) {
>> +               for (i = 0; i < (free_slots - rcvd); i++) {
>> +                       u64 addr = free_frames[--nr_free_frames];
>> +                       *xsk_ring_prod__fill_addr(&xsk->umem->fq, 
>> idx_fq++) =
>> +                               addr;
>> +               }
>>         }
>>
>> -       xsk_ring_prod__submit(&xsk->umem->fq, rcvd);
>> +       xsk_ring_prod__submit(&xsk->umem->fq, free_slots);
>>         xsk_ring_cons__release(&xsk->rx, rcvd);
>>         xsk->rx_npkts += rcvd;
>>  }
>> diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
>> index 833a6e60d065..cae506ab3f3c 100644
>> --- a/tools/lib/bpf/xsk.h
>> +++ b/tools/lib/bpf/xsk.h
>> @@ -76,7 +76,7 @@ xsk_ring_cons__rx_desc(const struct xsk_ring_cons 
>> *rx, __u32 idx)
>>         return &descs[idx & rx->mask];
>>  }
>>
>> -static inline __u32 xsk_prod_nb_free(struct xsk_ring_prod *r, __u32 
>> nb)
>> +static inline __u32 xsk_prod__nb_free(struct xsk_ring_prod *r, __u32 
>> nb)
>>  {
>>         __u32 free_entries = r->cached_cons - r->cached_prod;
>>
>> @@ -110,7 +110,7 @@ static inline __u32 xsk_cons_nb_avail(struct 
>> xsk_ring_cons *r, __u32 nb)
>>  static inline size_t xsk_ring_prod__reserve(struct xsk_ring_prod 
>> *prod,
>>                                             size_t nb, __u32 *idx)
>>  {
>> -       if (xsk_prod_nb_free(prod, nb) < nb)
>> +       if (xsk_prod__nb_free(prod, nb) < nb)
>>                 return 0;
>>
>>         *idx = prod->cached_prod;
>> --
>> 2.18.1
>>

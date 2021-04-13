Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3FBD35E27A
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 17:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345886AbhDMPQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 11:16:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27716 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229666AbhDMPQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 11:16:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618326988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zxkHuVBPU2TZ5Y4bM0w8YVbxOzhVQ8vYtYh12M9QPEY=;
        b=OzXY6fjOhiu8/+w2jjUhrviWtzqdKGFN6H7WoJ8/HJPZUuNvvLAu/aCEzV1CWlI5UUKi43
        5yd5Le7bgreOMVDpTfUk9gkPUty7Zo9Nz2Wqkb8QfBKOAyMO8C7g1jlwQ0VvRVBwdFoblv
        yaOx+PN9akDs/aQoaDz8krRiS3Td0Zk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-oMsr0OkHOBmMIwz_DYWDyA-1; Tue, 13 Apr 2021 11:16:23 -0400
X-MC-Unique: oMsr0OkHOBmMIwz_DYWDyA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 63CB46D259;
        Tue, 13 Apr 2021 15:16:21 +0000 (UTC)
Received: from [10.36.112.88] (ovpn-112-88.ams2.redhat.com [10.36.112.88])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D6ADE1975E;
        Tue, 13 Apr 2021 15:16:02 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "John Fastabend" <john.fastabend@gmail.com>
Cc:     "Lorenzo Bianconi" <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, sameehj@amazon.com,
        dsahern@kernel.org, brouer@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com
Subject: Re: [PATCH v8 bpf-next 00/14] mvneta: introduce XDP multi-buffer
 support
Date:   Tue, 13 Apr 2021 17:16:00 +0200
Message-ID: <FD3E6E08-DE78-4FBA-96F6-646C93E88631@redhat.com>
In-Reply-To: <606fa62f6fe99_c8b920884@john-XPS-13-9370.notmuch>
References: <cover.1617885385.git.lorenzo@kernel.org>
 <606fa62f6fe99_c8b920884@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9 Apr 2021, at 2:56, John Fastabend wrote:

> Lorenzo Bianconi wrote:
>> This series introduce XDP multi-buffer support. The mvneta driver is
>> the first to support these new "non-linear" xdp_{buff,frame}. 
>> Reviewers
>> please focus on how these new types of xdp_{buff,frame} packets
>> traverse the different layers and the layout design. It is on purpose
>> that BPF-helpers are kept simple, as we don't want to expose the
>> internal layout to allow later changes.
>>
>> For now, to keep the design simple and to maintain performance, the 
>> XDP
>> BPF-prog (still) only have access to the first-buffer. It is left for
>> later (another patchset) to add payload access across multiple 
>> buffers.
>> This patchset should still allow for these future extensions. The 
>> goal
>> is to lift the XDP MTU restriction that comes with XDP, but maintain
>> same performance as before.
>>
>> The main idea for the new multi-buffer layout is to reuse the same
>> layout used for non-linear SKB. We introduced a "xdp_shared_info" 
>> data
>> structure at the end of the first buffer to link together subsequent 
>> buffers.
>> xdp_shared_info will alias skb_shared_info allowing to keep most of 
>> the frags
>> in the same cache-line (while with skb_shared_info only the first 
>> fragment will
>> be placed in the first "shared_info" cache-line). Moreover we 
>> introduced some
>> xdp_shared_info helpers aligned to skb_frag* ones.
>> Converting xdp_frame to SKB and deliver it to the network stack is 
>> shown in
>> patch 07/14. Building the SKB, the xdp_shared_info structure will be 
>> converted
>> in a skb_shared_info one.
>>
>> A multi-buffer bit (mb) has been introduced in xdp_{buff,frame} 
>> structure
>> to notify the bpf/network layer if this is a xdp multi-buffer frame 
>> (mb = 1)
>> or not (mb = 0).
>> The mb bit will be set by a xdp multi-buffer capable driver only for
>> non-linear frames maintaining the capability to receive linear frames
>> without any extra cost since the xdp_shared_info structure at the end
>> of the first buffer will be initialized only if mb is set.
>>
>> Typical use cases for this series are:
>> - Jumbo-frames
>> - Packet header split (please see Google���s use-case @ 
>> NetDevConf 0x14, [0])
>> - TSO
>>
>> A new frame_length field has been introduce in XDP ctx in order to 
>> notify the
>> eBPF layer about the total frame size (linear + paged parts).
>>
>> bpf_xdp_adjust_tail and bpf_xdp_copy helpers have been modified to 
>> take into
>> account xdp multi-buff frames.
>
> I just read the commit messages for v8 so far. But, I'm still 
> wondering how
> to handle use cases where we want to put extra bytes at the end of the
> packet, or really anywhere in the general case. We can extend tail 
> with above
> is there anyway to then write into that extra space?
>
> I think most use cases will only want headers so we can likely make it
> a callout to a helper. Could we add something like, 
> xdp_get_bytes(start, end)
> to pull in the bytes?
>
> My dumb pseudoprogram being something like,
>
>   trailer[16] = {0,1,2,3,4,5,6,7,8,9,a,b,c,d,e}
>   trailer_size = 16;
>   old_end = xdp->length;
>   new_end = xdp->length + trailer_size;
>
>   err = bpf_xdp_adjust_tail(xdp, trailer_size)
>   if (err) return err;
>
>   err = xdp_get_bytes(xdp, old_end, new_end);
>   if (err) return err;
>
>   memcpy(xdp->data, trailer, trailer_size);
>
> Do you think that could work if we code up xdp_get_bytes()? Does the 
> driver
> have enough context to adjust xdp to map to my get_bytes() call? I 
> think
> so but we should check.
>

I was thinking of doing something like the below, but I have no cycles 
to work on it:

void *bpf_xdp_access_bytes(struct xdp_buff *xdp_md, u32 offset, int 
*len, void *buffer)
      Description
              This function returns a pointer to the packet data, which 
can be
              accessed linearly for a maximum of *len* bytes.

              *offset* marks the starting point in the packet for which 
you
              would like to get a data pointer.

              *len* point to an initialized integer which tells the 
helper
              how many bytes from *offset* you would like to access. 
Supplying
              a value of 0 or less will tell the helper to report back 
how
              many bytes are available linearly from the offset (in this 
case
              the value of *buffer* is ignored). On return, the helper 
will
              update this value with the length available to access
              linearly at the address returned.

              *buffer* point to an optional buffer which MUST be the 
same size
              as *\*len* and will be used to copy in the data if it's 
not
              available linearly.

      Return
              Returns a pointer to the packet data requested accessible 
with
              a maximum length of *\*len*. NULL is returned on failure.

              Note that if a *buffer* is supplied and the data is not 
available
              linearly, the content is copied. In this case a pointer to
              *buffer* is returned.


int bpf_xdp_store_bytes(struct xdp_buff *xdp_md, u32 offset, const void 
*from, u32 len)
      Description
              Store *len* bytes from address *from* into the packet 
associated
              to *xdp_md*, at *offset*. This function will take care of 
copying
              data to multi-buffer XDP packets.

              A call to this helper is susceptible to change the 
underlying
              packet buffer. Therefore, at load time, all checks on 
pointers
              previously done by the verifier are invalidated and must 
be
              performed again, if the helper is used in combination with
              direct packet access.

      Return
              0 on success, or a negative error in case of failure.

>>
>> More info about the main idea behind this approach can be found here 
>> [1][2].
>
> Thanks for working on this!


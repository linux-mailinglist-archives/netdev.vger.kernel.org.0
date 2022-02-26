Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE7F4C584C
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 22:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiBZVcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 16:32:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiBZVcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 16:32:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 29F4A583B2
        for <netdev@vger.kernel.org>; Sat, 26 Feb 2022 13:32:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645911126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nK0PVAC4y+xiFwMO8Vk7u/GCZxcWQNhJP8dZSYh/Vc4=;
        b=RxV5AUVhKwz0FJ0co5aDVcNc/iUW0Vtd0V+WsxcA5/JzqIvCQIcOAQUy178mWiswx7X4GX
        3Ad7AE5ehGiJnxAdMeWjTHQIILhdoC2GPsNubH7EZFbBr6ViPzdiCNaqtM5dniGQepEPYI
        qjOTkBum/HTw05bmGpItdmaocQZSU6w=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-INx6oAn2P7uIOpFzhdT9Ig-1; Sat, 26 Feb 2022 16:32:04 -0500
X-MC-Unique: INx6oAn2P7uIOpFzhdT9Ig-1
Received: by mail-ed1-f70.google.com with SMTP id eg48-20020a05640228b000b00413041cd917so3388047edb.12
        for <netdev@vger.kernel.org>; Sat, 26 Feb 2022 13:32:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=nK0PVAC4y+xiFwMO8Vk7u/GCZxcWQNhJP8dZSYh/Vc4=;
        b=fPu08MwNzv80L9kHupVIGa9nSZNq3eW6taA9AoDacYBTTLNqU3z8u4UTAOYl85vMTq
         vdladD+3sTe9nnWmh5qJLkJLiucdmwKJ8fNuVwhfcVsC0D+vjDlftrPIDVXHSWgwSDmA
         X+KBmRRDtRG9DlhdcN3jWCZ09GDvCGpA5G5i52JYDk4JbVhzS1jWU2/xFsPZ2dj+35Ni
         +1BSHkcq20ifdxq6N/fR9TlMd9kgAJVx6A0ZDqt3Hp7RcGnfTmX+UZLgTGWWzTFAnkNw
         FvkSH9kNuvJr+iS7moGc1HeeTKW0Bz7umy2oOsapDH2us+DRiZVIQNtam/GJswTR0tMR
         9lBQ==
X-Gm-Message-State: AOAM530aQ6S1FaVB2bJqBklAYH4JGZTECl4xBc0Go6OTFynt39TFRBqZ
        WfwJRoqxTXYUBM2TXaCAX+DI3bvoxGhGCA/lMJnurAiqsurQuT6cbq9DD34qdiHo3whmo2/7UrO
        97R4ow+HgUQGhWi3r
X-Received: by 2002:a17:906:4ad6:b0:6b8:33e5:c3a1 with SMTP id u22-20020a1709064ad600b006b833e5c3a1mr10400087ejt.472.1645911123553;
        Sat, 26 Feb 2022 13:32:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxEljZLRVtBTXEAe1NQIb725EdQdUWhZA+Ki0dAr06/KvUxNPZPmGrD2t5VyS5x2NAGeKUdiw==
X-Received: by 2002:a17:906:4ad6:b0:6b8:33e5:c3a1 with SMTP id u22-20020a1709064ad600b006b833e5c3a1mr10400062ejt.472.1645911123129;
        Sat, 26 Feb 2022 13:32:03 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id u10-20020a50d94a000000b004131aa2525esm3471782edj.49.2022.02.26.13.32.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Feb 2022 13:32:02 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id EBEB2130DD6; Sat, 26 Feb 2022 22:32:00 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v8 5/5] selftests/bpf: Add selftest for
 XDP_REDIRECT in BPF_PROG_RUN
In-Reply-To: <20220224011949.7mt4pluj4apqr44h@kafai-mbp.dhcp.thefacebook.com>
References: <20220218175029.330224-1-toke@redhat.com>
 <20220218175029.330224-6-toke@redhat.com>
 <20220224011949.7mt4pluj4apqr44h@kafai-mbp.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 26 Feb 2022 22:32:00 +0100
Message-ID: <87a6eduxf3.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau <kafai@fb.com> writes:

> On Fri, Feb 18, 2022 at 06:50:29PM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
> [ .. ]
>
>> diff --git a/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c b/=
tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
>> new file mode 100644
>> index 000000000000..af3cffccc794
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
>> @@ -0,0 +1,85 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +#include <vmlinux.h>
>> +#include <bpf/bpf_helpers.h>
>> +
>> +#define ETH_ALEN 6
>> +const volatile int ifindex_out;
>> +const volatile int ifindex_in;
>> +const volatile __u8 expect_dst[ETH_ALEN];
>> +volatile int pkts_seen_xdp =3D 0;
>> +volatile int pkts_seen_tc =3D 0;
>> +volatile int retcode =3D XDP_REDIRECT;
>> +
>> +SEC("xdp")
>> +int xdp_redirect(struct xdp_md *xdp)
>> +{
>> +	__u32 *metadata =3D (void *)(long)xdp->data_meta;
>> +	void *data =3D (void *)(long)xdp->data;
>> +	int ret =3D retcode;
>> +
>> +	if (xdp->ingress_ifindex !=3D ifindex_in)
>> +		return XDP_ABORTED;
>> +
>> +	if (metadata + 1 > data)
>> +		return XDP_ABORTED;
>> +
>> +	if (*metadata !=3D 0x42)
>> +		return XDP_ABORTED;
>> +
>> +	if (bpf_xdp_adjust_meta(xdp, 4))
>> +		return XDP_ABORTED;
>> +
>> +	if (retcode > XDP_PASS)
>> +		retcode--;
>> +
>> +	if (ret =3D=3D XDP_REDIRECT)
>> +		return bpf_redirect(ifindex_out, 0);
>> +
>> +	return ret;
>> +}
>> +
>> +static bool check_pkt(void *data, void *data_end)
>> +{
>> +	struct ethhdr *eth =3D data;
>> +	struct ipv6hdr *iph =3D (void *)(eth + 1);
>> +	struct udphdr *udp =3D (void *)(iph + 1);
>> +	__u8 *payload =3D (void *)(udp + 1);
>> +
>> +	if (payload + 1 > data_end)
>> +		return false;
>> +
>> +	if (iph->nexthdr !=3D IPPROTO_UDP || *payload !=3D 0x42)
>> +		return false;
>> +
>> +	/* reset the payload so the same packet doesn't get counted twice when
>> +	 * it cycles back through the kernel path and out the dst veth
>> +	 */
>> +	*payload =3D 0;
>> +	return true;
>> +}
>> +
>> +SEC("xdp")
>> +int xdp_count_pkts(struct xdp_md *xdp)
>> +{
>> +	void *data =3D (void *)(long)xdp->data;
>> +	void *data_end =3D (void *)(long)xdp->data_end;
>> +
>> +	if (check_pkt(data, data_end))
>> +		pkts_seen_xdp++;
>> +
>> +	return XDP_PASS;
> If it is XDP_DROP here (@veth-ingress), the packet will be put back to
> the page pool with zero-ed payload and that will be closer to the real
> scenario when xmit-ing out of a real NIC instead of veth? Just to
> ensure I understand the recycling and pkt rewrite description in patch
> 2 correctly because it seems the test always getting a data init-ed
> page.

Ah, yeah, good point, we do end up releasing all the pages on the other
end of the veth, so they don't get recycled. I'll change to XDP_DROP the
packets, and change the xdp_redirect() function to explicitly set the
payload instead of expecting it to come from userspace.

> Regarding to the tcp trafficgen in the xdptool repo,
> do you have thoughts on how to handle retransmit (e.g. after seeing
> SACK or dupack)?  Is it possible for the regular xdp receiver (i.e.
> not test_run) to directly retransmit it after seeing SACK if it knows
> the tcp payload?

Hmm, that's an interesting idea. Yeah, I think it should be possible for
the XDP program on the interface to reply with the missing packet
directly: it can just resize the ACK coming in, rewrite the TCP header,
fill it out with the payload, and return XDP_TX. However, this will
obviously only work if every SACK can be fulfilled with a single
re-transmission, which I don't think we can assume in the general case?
So I think some more state needs to be kept; however, such direct reply
hole-filling could potentially be a nice optimisation to have on top in
any case, so thank you for the idea!

> An off topic question, I expect the test_run approach is faster.
> Mostly curious, do you have a rough guess on what may be the perf
> difference with doing it in xsk?

Good question. There certainly exists very high performance DPDK-based
traffic generators; and AFAIK, XSK can more or less match DPDK
performance in zero-copy mode, so in this case I think it should be
possible to match the test_run in raw performance. Not sure about copy
mode; and of course in both cases it comes with the usual limitation of
having to dedicate a suitably configured NIC queue, whereas the
in-kernel trafficgen can run without interfering with other traffic
(except for taking up the link capacity, of course).

-Toke


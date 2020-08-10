Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2B75240703
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 15:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbgHJNzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 09:55:04 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:59415 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726687AbgHJNzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 09:55:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597067702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+HGVMIgGobN+GYYWAdJh2FOAbmEWexuoFUEbn2rh+Gg=;
        b=acZvONCYPX4k1VqrDBRm55ZyrVXjaxKl1oDoT7vg6+1tlwMSDIJVhg1aHawkxIARfZIkug
        vfFC0VQfuxVdRTNgUuahU7LFvvLX4xulb0vLUxS0DiBgrDs5naa3SYJpbmqX8w00HlEgQl
        ycBvGguW5hLIeGYB3XT2gCPHyWxkOos=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-k3uQ8c1gO1KY3bCeMycarA-1; Mon, 10 Aug 2020 09:54:57 -0400
X-MC-Unique: k3uQ8c1gO1KY3bCeMycarA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3FD8780183C;
        Mon, 10 Aug 2020 13:54:56 +0000 (UTC)
Received: from krava (unknown [10.40.195.90])
        by smtp.corp.redhat.com (Postfix) with SMTP id CC8A410013C2;
        Mon, 10 Aug 2020 13:54:52 +0000 (UTC)
Date:   Mon, 10 Aug 2020 15:54:51 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [RFC] bpf: verifier check for dead branch
Message-ID: <20200810135451.GA699846@krava>
References: <20200807173045.GC561444@krava>
 <f13fde40-0c07-ff73-eeb3-3c59c5694f74@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f13fde40-0c07-ff73-eeb3-3c59c5694f74@fb.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 09, 2020 at 06:21:01PM -0700, Yonghong Song wrote:
> 
> 
> On 8/7/20 10:30 AM, Jiri Olsa wrote:
> > hi,
> > we have a customer facing some odd verifier fails on following
> > sk_skb program:
> > 
> >     0. r2 = *(u32 *)(r1 + data_end)
> >     1. r4 = *(u32 *)(r1 + data)
> >     2. r3 = r4
> >     3. r3 += 42
> >     4. r1 = 0
> >     5. if r3 > r2 goto 8
> >     6. r4 += 14
> >     7. r1 = r4
> >     8. if r3 > r2 goto 10
> >     9. r2 = *(u8 *)(r1 + 9)
> >    10. r0 = 0
> >    11. exit
> > 
> > The code checks if the skb data is big enough (5) and if it is,
> > it prepares pointer in r1 (7), then there's again size check (8)
> > and finally data load from r1 (9).
> > 
> > It's and odd code, but apparently this is something that can
> > get produced by clang.
> 
> Could you provide a test case where clang generates the above code?
> I would like to see whether clang can do a better job to avoid
> such codes.

I get that code genrated by using recent enough upstream clang
on the attached source.

	/opt/clang/bin/clang --version
	clang version 11.0.0 (https://github.com/llvm/llvm-project.git 4cbfb98eb362b0629d5d1cd113af4427e2904763)
	Target: x86_64-unknown-linux-gnu
	Thread model: posix
	InstalledDir: /opt/clang/bin

	$ llvm-objdump -d verifier-cond-repro.o 

	verifier-cond-repro.o:  file format ELF64-BPF

	Disassembly of section .text:

	0000000000000000 my_prog:
	       0:       61 12 50 00 00 00 00 00 r2 = *(u32 *)(r1 + 80)
	       1:       61 14 4c 00 00 00 00 00 r4 = *(u32 *)(r1 + 76)
	       2:       bf 43 00 00 00 00 00 00 r3 = r4
	       3:       07 03 00 00 2a 00 00 00 r3 += 42
	       4:       b7 01 00 00 00 00 00 00 r1 = 0
	       5:       2d 23 02 00 00 00 00 00 if r3 > r2 goto +2 <LBB0_2>
	       6:       07 04 00 00 0e 00 00 00 r4 += 14
	       7:       bf 41 00 00 00 00 00 00 r1 = r4

	0000000000000040 LBB0_2:
	       8:       2d 23 05 00 00 00 00 00 if r3 > r2 goto +5 <LBB0_5>
	       9:       71 12 09 00 00 00 00 00 r2 = *(u8 *)(r1 + 9)
	      10:       56 02 03 00 11 00 00 00 if w2 != 17 goto +3 <LBB0_5>
	      11:       b4 00 00 00 d2 04 00 00 w0 = 1234
	      12:       69 11 16 00 00 00 00 00 r1 = *(u16 *)(r1 + 22)
	      13:       16 01 01 00 d2 04 00 00 if w1 == 1234 goto +1 <LBB0_6>

	0000000000000070 LBB0_5:
	      14:       b4 00 00 00 ff ff ff ff w0 = -1

	0000000000000078 LBB0_6:
	      15:       95 00 00 00 00 00 00 00 exit


thanks,
jirka


---
// Copyright (c) 2019 Tigera, Inc. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include <stddef.h>
#include <string.h>
#include <linux/bpf.h>
#include <linux/if_ether.h>
#include <linux/if_packet.h>
#include <linux/ip.h>
#include <linux/ipv6.h>
#include <linux/in.h>
#include <linux/udp.h>
#include <linux/tcp.h>
#include <linux/pkt_cls.h>
#include <sys/socket.h>
#include <bpf/bpf_helpers.h>
#include <bpf/bpf_endian.h>

#include <stddef.h>

#define INLINE inline __attribute__((always_inline))

#define skb_shorter(skb, len) ((void *)(long)(skb)->data + (len) > (void *)(long)skb->data_end)

#define ETH_IPV4_UDP_SIZE (14+20+8)

static INLINE struct iphdr *get_iphdr (struct __sk_buff *skb)
{
	struct iphdr *ip = NULL;
	struct ethhdr *eth;

	if (skb_shorter(skb, ETH_IPV4_UDP_SIZE))
		goto out;

	eth = (void *)(long)skb->data;
	ip = (void *)(eth + 1);

out:
	return ip;
}

int my_prog(struct __sk_buff *skb)
{
	struct iphdr *ip = NULL;
	struct udphdr *udp;
	__u8 proto = 0;

	if (!(ip = get_iphdr(skb)))
		goto out;

	proto = ip->protocol;

	if (proto != IPPROTO_UDP)
		goto out;

	udp = (void*)(ip + 1);

	if (udp->dest != 1234)
		goto out;

	if (!udp)
		goto out;

	return udp->dest;

out:
	return -1;
}


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1F836D03B
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 03:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235423AbhD1BW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 21:22:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26563 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230425AbhD1BWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 21:22:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619572931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XbLyFvrjSQz5/gF7VPmuPuvoiHTk2IYn/Ev/WHTHBYQ=;
        b=euZHaneLrzGBQe/QDax5dQFTwPGB+T9a405tS9Gobc02s72QIkuh73koJr3iDEUfU3Epe7
        Y5J/7k9kocG3cIOvnq1FzCdJz0MVg+QBvXyVJaQ3VAXrsq3aBNemTzESiFzEBDdUAPFlMH
        U3JeVIHESMIo2B39eawHKpMxFRIj/0w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-jeoyZHpOMtOeTZPv_7ZbPg-1; Tue, 27 Apr 2021 21:22:09 -0400
X-MC-Unique: jeoyZHpOMtOeTZPv_7ZbPg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BAD1C802950;
        Wed, 28 Apr 2021 01:22:07 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-64.pek2.redhat.com [10.72.13.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1C49069FD0;
        Wed, 28 Apr 2021 01:21:59 +0000 (UTC)
Subject: Re: [PATCH net-next v3] virtio-net: page_to_skb() use build_skb when
 there's sufficient tailroom
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
References: <1619491565.7682261-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <2d6b1c0b-7a3f-dbf4-785a-9af3c6000f98@redhat.com>
Date:   Wed, 28 Apr 2021 09:21:58 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <1619491565.7682261-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/4/27 ÉÏÎç10:46, Xuan Zhuo Ð´µÀ:
> On Tue, 20 Apr 2021 10:41:03 +0800, Jason Wang <jasowang@redhat.com> wrote:
>>
>> Btw, since the patch modifies a critical path of virtio-net I suggest to
>> test the following cases:
>>
>> 1) netperf TCP stream
>> 2) netperf UDP with packet size from 64 to PAGE_SIZE
>> 3) XDP_PASS with 1)
>> 4) XDP_PASS with 2)
>> 5) XDP metadata with 1)
>> 6) XDP metadata with 2)
> I have completed the above test on the latest net-next branch. The tested script
> and xdp code are as follows. The kernel is with KCOV and everything is normal
> without exception.
>
> Thanks.


Looks good.

Thanks for the testing.


>
> ## test script:
> 	#!/usr/bin/env sh
>
>
> 	for s in $(seq 64 4096)
> 	do
> 	    netperf -H 192.168.122.202  -t UDP_STREAM -- -m $s
> 	done
>
> 	for s in $(seq 64 4096)
> 	do
> 	    netperf -H 192.168.122.202  -t TCP_STREAM -- -m $s
> 	done
>
> ## xdp pass:
>
> 	#define KBUILD_MODNAME "foo"
> 	#include <linux/bpf.h>
> 	#include <linux/in.h>
> 	#include <linux/if_ether.h>
> 	#include <linux/if_packet.h>
> 	#include <linux/if_vlan.h>
> 	#include <linux/ip.h>
> 	#include <linux/icmp.h>
>
> 	#define DEFAULT_TTL 64
> 	#define MAX_PCKT_SIZE 600
> 	#define ICMP_TOOBIG_SIZE 98
> 	#define ICMP_TOOBIG_PAYLOAD_SIZE 92
>
>
> 	#define SEC(NAME) __attribute__((section(NAME), used))
>
>
> 	SEC("xdp")
> 	int _xdp(struct xdp_md *xdp)
> 	{
> 	        return XDP_PASS;
> 	}
>
> 	char _license[] SEC("license") = "GPL";
>
> ## xdp metadata:
>
> 	#define KBUILD_MODNAME "foo"
> 	#include <linux/bpf.h>
> 	#include <linux/in.h>
> 	#include <linux/if_ether.h>
> 	#include <linux/if_packet.h>
> 	#include <linux/if_vlan.h>
> 	#include <linux/ip.h>
> 	#include <linux/icmp.h>
>
> 	static long (*bpf_xdp_adjust_meta)(struct xdp_md *xdp_md, int delta) = (void *) 54;
>
>
> 	#define SEC(NAME) __attribute__((section(NAME), used))
>
> 	struct meta_info {
> 	        __u32 mark;
> 	} __attribute__((aligned(4)));
>
> 	SEC("xdp_mark")
> 	int _xdp_mark(struct xdp_md *ctx)
> 	{
> 	        struct meta_info *meta;
> 	        void *data, *data_end;
> 	        int ret;
>
> 	        /* Reserve space in-front of data pointer for our meta info.
> 	         * (Notice drivers not supporting data_meta will fail here!)
> 	         */
> 	        ret = bpf_xdp_adjust_meta(ctx, -(int)sizeof(*meta));
> 	        if (ret < 0)
> 	                return XDP_ABORTED;
>
> 	        /* Notice: Kernel-side verifier requires that loading of
> 	         * ctx->data MUST happen _after_ helper bpf_xdp_adjust_meta(),
> 	         * as pkt-data pointers are invalidated.  Helpers that require
> 	         * this are determined/marked by bpf_helper_changes_pkt_data()
> 	         */
> 	        data = (void *)(unsigned long)ctx->data;
>
> 	        /* Check data_meta have room for meta_info struct */
> 	        meta = (void *)(unsigned long)ctx->data_meta;
> 	        if ((void *)(meta + 1) > data)
> 	                return XDP_ABORTED;
>
> 	        meta->mark = 42;
>
> 	        return XDP_PASS;
> 	}
>
>
> 	char _license[] SEC("license") = "GPL";
>


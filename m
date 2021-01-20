Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECEF2FC86E
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 04:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389396AbhATDEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 22:04:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51458 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388061AbhATDDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 22:03:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611111702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZodmnXn4xAMstumzC/OBLSYq3RcxDLukButfIEIAT2Y=;
        b=R6jhdz8kjMaMI3az+PxEM7iYoGTja6Gc8GezHQqUnv2BWWB7XIYiCZzbhBa7zReqnd0A1E
        1D7NDmULhVSzD0Gxg1auFqCjEyGD89dnGP8zhf20jxUIZIsP6KJDj+18/MqMG/vetWC6Md
        uspBVY1y+sbuoq3oPHahEW6u2YHYY0w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-RfqNDkrNMjyVLRuQG31F_g-1; Tue, 19 Jan 2021 22:01:37 -0500
X-MC-Unique: RfqNDkrNMjyVLRuQG31F_g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 105C0E743;
        Wed, 20 Jan 2021 03:01:35 +0000 (UTC)
Received: from [10.72.13.124] (ovpn-13-124.pek2.redhat.com [10.72.13.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 02EC172171;
        Wed, 20 Jan 2021 03:01:25 +0000 (UTC)
Subject: Re: [PATCH bpf-next v2 1/3] net: add priv_flags for allow tx skb
 without linear
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
References: <cover.1611048724.git.xuanzhuo@linux.alibaba.com>
 <30ae1c94b5c26919bd90bb251761c526edfbaf56.1611048724.git.xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <13d2ceda-16d1-488c-d131-55cca813b224@redhat.com>
Date:   Wed, 20 Jan 2021 11:01:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <30ae1c94b5c26919bd90bb251761c526edfbaf56.1611048724.git.xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/19 下午5:45, Xuan Zhuo wrote:
> In some cases, we hope to construct skb directly based on the existing
> memory without copying data. In this case, the page will be placed
> directly in the skb, and the linear space of skb is empty. But
> unfortunately, many the network card does not support this operation.
> For example Mellanox Technologies MT27710 Family [ConnectX-4 Lx] will
> get the following error message:
>
>      mlx5_core 0000:3b:00.1 eth1: Error cqe on cqn 0x817, ci 0x8, qn 0x1dbb, opcode 0xd, syndrome 0x1, vendor syndrome 0x68
>      00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>      00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>      00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>      00000030: 00 00 00 00 60 10 68 01 0a 00 1d bb 00 0f 9f d2
>      WQE DUMP: WQ size 1024 WQ cur size 0, WQE index 0xf, len: 64
>      00000000: 00 00 0f 0a 00 1d bb 03 00 00 00 08 00 00 00 00
>      00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>      00000020: 00 00 00 2b 00 08 00 00 00 00 00 05 9e e3 08 00
>      00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>      mlx5_core 0000:3b:00.1 eth1: ERR CQE on SQ: 0x1dbb
>
> So a priv_flag is added here to indicate whether the network card
> supports this feature.


I don't see Mellanox engineers are copied. I wonder if we need their 
confirmation on whether it's a bug or hardware limitation.

Thanks


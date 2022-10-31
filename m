Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB02613BC4
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 17:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbiJaQxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 12:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231902AbiJaQxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 12:53:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77062A46D
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 09:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667235136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PvS4jZUIuDA5HwDTER4Hkyb6olzQD3iHpphKUESWfcg=;
        b=asHNUaSS5vu4YlqHVh8IbqiBqtNJXIC5KamhpXfSRHcfipV03u25bytvxxFnN4P69pyyPy
        xtW2eaU0yKxAeKkmiEAYOjsXscyj3IkRYL0loZjMRvw1Y2MlIgZ1MyxiAaTk79FIvgLFa8
        mAGxCU9m5OJmYrpoXX7ODQsSWxuJtpQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-225-ehYD_4jJNpCY2FvEZ7oeRw-1; Mon, 31 Oct 2022 12:52:10 -0400
X-MC-Unique: ehYD_4jJNpCY2FvEZ7oeRw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4465A3802B89;
        Mon, 31 Oct 2022 16:52:10 +0000 (UTC)
Received: from griffin (ovpn-208-21.brq.redhat.com [10.40.208.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 69CC0C2C8C8;
        Mon, 31 Oct 2022 16:52:08 +0000 (UTC)
Date:   Mon, 31 Oct 2022 17:52:06 +0100
From:   Jiri Benc <jbenc@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Tomas Hruby <tomas@tigera.io>,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        alexanderduyck@meta.com, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net] net: gso: fix panic on frag_list with mixed head
 alloc types
Message-ID: <20221031175206.50a54083@griffin>
In-Reply-To: <CA+FuTSdkOMBahoeLsXV8wnGdqNtmUHHDu-9xn9JX6zY3M4VmVw@mail.gmail.com>
References: <559cea869928e169240d74c386735f3f95beca32.1666858629.git.jbenc@redhat.com>
        <20221029104131.07fbc6cf@blondie>
        <CA+FuTSdkOMBahoeLsXV8wnGdqNtmUHHDu-9xn9JX6zY3M4VmVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 29 Oct 2022 10:10:03 -0400, Willem de Bruijn wrote:
> If a device has different allocation strategies depending on packet
> size, and GRO coalesces those using a list, then indeed this does not
> have to hold. GRO requires the same packet size and thus allocation
> strategy to coalesce -- except for the last segment.

That's exactly what I saw: the last segment was different.

However, I don't see anything in the GRO code that enforces that. It
appears that currently, it just usually happens that way. When there's
a burst of packets for the given flow on the wire, only the last
segment is small (and thus malloced) and there's no immediate packet
following for the same flow. What would happen if (for whatever reason)
there was such packet following?

> I don't see any allocation in vmxnet3 that uses a head frag, though.
> There is a small packet path (rxDataRingUsed), but both small and
> large allocate using a kmalloc-backed skb->data as far as I can tell.

I believe the logic is that for rxDataRingUsed,
netdev_alloc_skb_ip_align is called to alloc skb to copy data into,
passing to it the actual packet length. If it's small enough,
__netdev_alloc_skb will kmalloc the data. However, for !rxDataRingUsed,
the skb for dma buffer is allocated with a larger length and
__netdev_alloc_skb will use page_frag_alloc.

I admit I've not spend that much time understanding the logic in the
driver. I was satisfied when the perceived logic matched what I saw in
the kernel memory dump. I may have easily missed something, such as
Jakub's point that it's not actually the driver deciding on the
allocation strategy but rather __netdev_alloc_skb on its own. But the
outcome still seems to be that small packets are kmalloced, while
larger packets are page backed. Am I wrong?

> In any case, iterating over all frags is more robust. This is an edge
> case, fine to incur the cost there.

Thanks! We might get a minor speedup if we check only the last segment;
but first, I'd like to be proven wrong about GRO not enforcing this.
Plus, I wonder whether the speedup would be measurable if we have to
iterate through the list to find the last segment anyway.

Unless there are objections or clarifications (and unless I'm wrong
above), I'll send a v2 with the commit message corrected and with the
same code.

Thanks to all!

 Jiri


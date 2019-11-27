Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4456E10B4BF
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 18:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbfK0RuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 12:50:19 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39401 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726990AbfK0RuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 12:50:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574877017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+MB6N9uP3ORAGIaepwpg/1bmdyKasKWZBIfVHjugW8k=;
        b=I2JndIzL5W8rKGE+au/M4Hw07CSzq5+ZCGdCalYKbyQ3LwmAkeXHW5WCdi+VxDvxK3sFhm
        rtFYTBRVmFoLfyQyPeKUbZFCIuARyxh37rtNIz8CzyFRUFSo4wVcDg3G1PxoJnmfOKbWnl
        oxWedz40OXSZiuYnVNvJsk16kdMERyU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-138-WxIffqC8PO-3iffa3IjJpw-1; Wed, 27 Nov 2019 12:50:13 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89C75800D5A;
        Wed, 27 Nov 2019 17:50:12 +0000 (UTC)
Received: from ovpn-118-152.ams2.redhat.com (unknown [10.36.118.152])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 755345C28D;
        Wed, 27 Nov 2019 17:50:03 +0000 (UTC)
Message-ID: <26e9b84bef24d46da9504aae2ca444d0d258c621.camel@redhat.com>
Subject: Re: epoll_wait() performance
From:   Paolo Abeni <pabeni@redhat.com>
To:     David Laight <David.Laight@ACULAB.COM>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     'Marek Majkowski' <marek@cloudflare.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        network dev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Date:   Wed, 27 Nov 2019 18:50:02 +0100
In-Reply-To: <2f1635d9300a4bec8a0422e9e9518751@AcuMS.aculab.com>
References: <bc84e68c0980466096b0d2f6aec95747@AcuMS.aculab.com>
         <CAJPywTJYDxGQtDWLferh8ObjGp3JsvOn1om1dCiTOtY6S3qyVg@mail.gmail.com>
         <5f4028c48a1a4673bd3b38728e8ade07@AcuMS.aculab.com>
         <20191127164821.1c41deff@carbon>
         <0b8d7447e129539aec559fa797c07047f5a6a1b2.camel@redhat.com>
         <2f1635d9300a4bec8a0422e9e9518751@AcuMS.aculab.com>
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: WxIffqC8PO-3iffa3IjJpw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thanks for the additional details.

On Wed, 2019-11-27 at 17:30 +0000, David Laight wrote:
> From: Paolo Abeni
> > Sent: 27 November 2019 16:27
> ...
> > @David: If I read your message correctly, the pkt rate you are dealing
> > with is quite low... are we talking about tput or latency? I guess
> > latency could be measurably higher with recvmmsg() in respect to other
> > syscall. How do you measure the releative performances of recvmmsg()
> > and recv() ? with micro-benchmark/rdtsc()? Am I right that you are
> > usually getting a single packet per recvmmsg() call?
> 
> The packet rate per socket is low, typically one packet every 20ms.
> This is RTP, so telephony audio.
> However we have a lot of audio channels and hence a lot of sockets.
> So there are can be 1000s of sockets we need to receive the data from.
> The test system I'm using has 16 E1 TDM links each of which can handle
> 31 audio channels.
> Forwarding all these to/from RTP (one of the things it might do) is 496
> audio channels - so 496 RTP sockets and 496 RTCP ones.
> Although the test I'm doing is pure RTP and doesn't use TDM.

Oks, I think this is not exactly the preferred recvmmsg() use case ;)

> What I'm measuring is the total time taken to receive all the packets
> (on all the sockets) that are available to be read every 10ms.
> So poll + recv + add_to_queue.
> (The data processing is done by other threads.)
> I use the time difference (actually CLOCK_MONOTONIC - from rdtsc)
> to generate a 64 entry (self scaling) histogram of the elapsed times.
> Then look for the histograms peak value.
> (I need to work on the max value, but that is a different (more important!) problem.)
> Depending on the poll/recv method used this takes 1.5 to 2ms
> in each 10ms period.
> (It is faster if I run the cpu at full speed, but it usually idles along
> at 800MHz.)
> 
> If I use recvmmsg() I only expect to see one packet because there
> is (almost always) only one packet on each socket every 20ms.
> However there might be more than one, and if there is they
> all need to be read (well at least 2 of them) in that block of receives.

I would wild guess that recvmmsg() would be faster than 2 recv() when
there are exactly 2 pkts to read and the user-space provides exactly 2
msg entries, but likely non very relevant for the overall scenario.

Sorry, I don't have any good suggestion here.

Cheers,

Paolo


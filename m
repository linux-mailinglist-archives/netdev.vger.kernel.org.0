Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 670F637F589
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 12:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbhEMKX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 06:23:28 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:59711 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232615AbhEMKWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 06:22:48 -0400
X-Originating-IP: 78.45.89.65
Received: from [192.168.1.23] (ip-78-45-89-65.net.upcbroadband.cz [78.45.89.65])
        (Authenticated sender: i.maximets@ovn.org)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 66E12E0002;
        Thu, 13 May 2021 10:21:32 +0000 (UTC)
Subject: Re: [ovs-dev] [PATCH net] openvswitch: meter: fix race when getting
 now_ms.
To:     Tao Liu <thomas.liu@ucloud.cn>, pshelar@ovn.org
Cc:     dev@openvswitch.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, i.maximets@ovn.org,
        jean.tourrilhes@hpe.com, kuba@kernel.org, davem@davemloft.net,
        Eelco Chaudron <echaudro@redhat.com>
References: <20210513100300.22735-1-thomas.liu@ucloud.cn>
From:   Ilya Maximets <i.maximets@ovn.org>
Message-ID: <801322d2-5b39-2497-bf0a-1ec08122a5c7@ovn.org>
Date:   Thu, 13 May 2021 12:21:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210513100300.22735-1-thomas.liu@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/13/21 12:03 PM, Tao Liu wrote:
> We have observed meters working unexpected if traffic is 3+Gbit/s
> with multiple connections.
> 
> now_ms is not pretected by meter->lock, we may get a negative
> long_delta_ms when another cpu updated meter->used, then:
>     delta_ms = (u32)long_delta_ms;
> which will be a large value.
> 
>     band->bucket += delta_ms * band->rate;
> then we get a wrong band->bucket.
> 
> Fixes: 96fbc13d7e77 ("openvswitch: Add meter infrastructure")
> Signed-off-by: Tao Liu <thomas.liu@ucloud.cn>
> ---

Hi.  Thanks for the patch!
We fixed the same issue in userspace datapath some time ago and
we did that a bit differently by just setting negative long_delta_ms
to zero in assumption that all threads received their packets at
the same millisecond (which is most likely true if we have this
kind of race).  This should be also cheaper from form the performance
point of view to not have an extra call and a division under the
spinlock.   What do you think?

It's also a good thing to have more or less similar implementation
for all datapaths.

Here is a userspace patch:

commit acc5df0e3cb036524d49891fdb9ba89b609dd26a
Author: Ilya Maximets <i.maximets@ovn.org>
Date:   Thu Oct 24 15:15:07 2019 +0200

    dpif-netdev: Fix time delta overflow in case of race for meter lock.
    
    There is a race window between getting the time and getting the meter
    lock.  This could lead to situation where the thread with larger
    current time (this thread called time_{um}sec() later than others)
    will acquire meter lock first and update meter->used to the large
    value.  Next threads will try to calculate time delta by subtracting
    the large meter->used from their lower time getting the negative value
    which will be converted to a big unsigned delta.
    
    Fix that by assuming that all these threads received packets in the
    same time in this case, i.e. dropping negative delta to 0.
    
    CC: Jarno Rajahalme <jarno@ovn.org>
    Fixes: 4b27db644a8c ("dpif-netdev: Simple DROP meter implementation.")
    Reported-at: https://mail.openvswitch.org/pipermail/ovs-dev/2019-September/363126.html
    Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
    Acked-by: William Tu <u9012063@gmail.com>

diff --git a/lib/dpif-netdev.c b/lib/dpif-netdev.c
index c09b8fd95..4720ba1ab 100644
--- a/lib/dpif-netdev.c
+++ b/lib/dpif-netdev.c
@@ -5646,6 +5646,14 @@ dp_netdev_run_meter(struct dp_netdev *dp, struct dp_packet_batch *packets_,
     /* All packets will hit the meter at the same time. */
     long_delta_t = now / 1000 - meter->used / 1000; /* msec */
 
+    if (long_delta_t < 0) {
+        /* This condition means that we have several threads fighting for a
+           meter lock, and the one who received the packets a bit later wins.
+           Assuming that all racing threads received packets at the same time
+           to avoid overflow. */
+        long_delta_t = 0;
+    }
+
     /* Make sure delta_t will not be too large, so that bucket will not
      * wrap around below. */
     delta_t = (long_delta_t > (long long int)meter->max_delta_t)
---

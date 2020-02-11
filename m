Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACDE15924D
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 15:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730275AbgBKOwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 09:52:46 -0500
Received: from www62.your-server.de ([213.133.104.62]:51152 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729831AbgBKOwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 09:52:46 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j1Wtz-0004W3-2W; Tue, 11 Feb 2020 15:52:39 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j1Wty-000OYm-Nh; Tue, 11 Feb 2020 15:52:38 +0100
Subject: Re: [PATCH bpf] xsk: publish global consumer pointers when NAPI is
 finished
To:     Magnus Karlsson <magnus.karlsson@intel.com>, maximmi@mellanox.com,
        bjorn.topel@intel.com, ast@kernel.org, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     rgoodfel@isi.edu, bpf@vger.kernel.org,
        maciejromanfijalkowski@gmail.com
References: <1581348432-6747-1-git-send-email-magnus.karlsson@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e4702dd2-3968-4740-aa50-9f7cda3bb13e@iogearbox.net>
Date:   Tue, 11 Feb 2020 15:52:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1581348432-6747-1-git-send-email-magnus.karlsson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.1/25720/Mon Feb 10 12:53:41 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/10/20 4:27 PM, Magnus Karlsson wrote:
> The commit 4b638f13bab4 ("xsk: Eliminate the RX batch size")
> introduced a much more lazy way of updating the global consumer
> pointers from the kernel side, by only doing so when running out of
> entries in the fill or Tx rings (the rings consumed by the
> kernel). This can result in a deadlock with the user application if
> the kernel requires more than one entry to proceed and the application
> cannot put these entries in the fill ring because the kernel has not
> updated the global consumer pointer since the ring is not empty.
> 
> Fix this by publishing the local kernel side consumer pointer whenever
> we have completed Rx or Tx processing in the kernel. This way, user
> space will have an up-to-date view of the consumer pointers whenever it
> gets to execute in the one core case (application and driver on the
> same core), or after a certain number of packets have been processed
> in the two core case (application and driver on different cores).
> 
> A side effect of this patch is that the one core case gets better
> performance, but the two core case gets worse. The reason that the one
> core case improves is that updating the global consumer pointer is
> relatively cheap since the application by definition is not running
> when the kernel is (they are on the same core) and it is beneficial
> for the application, once it gets to run, to have pointers that are
> as up to date as possible since it then can operate on more packets
> and buffers. In the two core case, the most important performance
> aspect is to minimize the number of accesses to the global pointers
> since they are shared between two cores and bounces between the caches
> of those cores. This patch results in more updates to global state,
> which means lower performance in the two core case.
> 
> Fixes: 4b638f13bab4 ("xsk: Eliminate the RX batch size")
> Reported-by: Ryan Goodfellow <rgoodfel@isi.edu>
> Reported-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Applied, thanks!

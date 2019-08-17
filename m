Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE2391345
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 23:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfHQV2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 17:28:09 -0400
Received: from www62.your-server.de ([213.133.104.62]:56324 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfHQV2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 17:28:09 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hz6F4-0001ZX-Az; Sat, 17 Aug 2019 23:28:06 +0200
Received: from [178.193.45.231] (helo=pc-63.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hz6F4-000DWa-5N; Sat, 17 Aug 2019 23:28:06 +0200
Subject: Re: [PATCH bpf-next v5 0/2] net: xdp: XSKMAP improvements
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, netdev@vger.kernel.org
Cc:     magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        bjorn.topel@intel.com, bruce.richardson@intel.com,
        songliubraving@fb.com, bpf@vger.kernel.org
References: <20190815093014.31174-1-bjorn.topel@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c9f62b8e-34e1-3331-8a23-95d064aa4f87@iogearbox.net>
Date:   Sat, 17 Aug 2019 23:28:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190815093014.31174-1-bjorn.topel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25544/Sat Aug 17 10:24:01 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/15/19 11:30 AM, Björn Töpel wrote:
> This series (v5 and counting) add two improvements for the XSKMAP,
> used by AF_XDP sockets.
> 
> 1. Automatic cleanup when an AF_XDP socket goes out of scope/is
>     released. Instead of require that the user manually clears the
>     "released" state socket from the map, this is done
>     automatically. Each socket tracks which maps it resides in, and
>     remove itself from those maps at relase. A notable implementation
>     change, is that the sockets references the map, instead of the map
>     referencing the sockets. Which implies that when the XSKMAP is
>     freed, it is by definition cleared of sockets.
> 
> 2. The XSKMAP did not honor the BPF_EXIST/BPF_NOEXIST flag on insert,
>     which this patch addresses.
> 
> 
> Thanks,
> Björn
> 
> v1->v2: Fixed deadlock and broken cleanup. (Daniel)
> v2->v3: Rebased onto bpf-next
> v3->v4: {READ, WRITE}_ONCE consistency. (Daniel)
>          Socket release/map update race. (Daniel)
> v4->v5: Avoid use-after-free on XSKMAP self-assignment [1]. (Daniel)
>          Removed redundant assignment in xsk_map_update_elem().
>          Variable name consistency; Use map_entry everywhere.
> 
> [1] https://lore.kernel.org/bpf/20190802081154.30962-1-bjorn.topel@gmail.com/T/#mc68439e97bc07fa301dad9fc4850ed5aa392f385
> 
> Björn Töpel (2):
>    xsk: remove AF_XDP socket from map when the socket is released
>    xsk: support BPF_EXIST and BPF_NOEXIST flags in XSKMAP
> 
>   include/net/xdp_sock.h |  18 ++++++
>   kernel/bpf/xskmap.c    | 133 ++++++++++++++++++++++++++++++++++-------
>   net/xdp/xsk.c          |  50 ++++++++++++++++
>   3 files changed, 179 insertions(+), 22 deletions(-)
> 

Looks better, applied thanks!

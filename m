Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFAD69134A
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 23:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbfHQVaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 17:30:02 -0400
Received: from www62.your-server.de ([213.133.104.62]:56814 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbfHQVaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 17:30:02 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hz6Gs-0001eY-6i; Sat, 17 Aug 2019 23:29:58 +0200
Received: from [178.193.45.231] (helo=pc-63.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hz6Gs-000OK8-0M; Sat, 17 Aug 2019 23:29:58 +0200
Subject: Re: [PATCH bpf-next v2] net: Don't call XDP_SETUP_PROG when nothing
 is changed
To:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
References: <5b123e9a-095f-1db4-da6e-5af6552430e1@iogearbox.net>
 <20190814143352.3759-1-maximmi@mellanox.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a6a1ad31-9570-2b04-b105-155c879429fc@iogearbox.net>
Date:   Sat, 17 Aug 2019 23:29:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190814143352.3759-1-maximmi@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25544/Sat Aug 17 10:24:01 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/14/19 4:34 PM, Maxim Mikityanskiy wrote:
> Don't uninstall an XDP program when none is installed, and don't install
> an XDP program that has the same ID as the one already installed.
> 
> dev_change_xdp_fd doesn't perform any checks in case it uninstalls an
> XDP program. It means that the driver's ndo_bpf can be called with
> XDP_SETUP_PROG asking to set it to NULL even if it's already NULL. This
> case happens if the user runs `ip link set eth0 xdp off` when there is
> no XDP program attached.
> 
> The symmetrical case is possible when the user tries to set the program
> that is already set.
> 
> The drivers typically perform some heavy operations on XDP_SETUP_PROG,
> so they all have to handle these cases internally to return early if
> they happen. This patch puts this check into the kernel code, so that
> all drivers will benefit from it.
> 
> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>

Applied, thanks!

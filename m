Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABA21BAE7E
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 21:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgD0TwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 15:52:03 -0400
Received: from www62.your-server.de ([213.133.104.62]:59490 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgD0TwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 15:52:03 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jT9nE-0000wD-CR; Mon, 27 Apr 2020 21:51:52 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jT9nD-000VkW-Oy; Mon, 27 Apr 2020 21:51:51 +0200
Subject: Re: [PATCH net-next 23/33] ixgbe: add XDP frame size to driver
To:     Jesper Dangaard Brouer <brouer@redhat.com>, sameehj@amazon.com
Cc:     intel-wired-lan@lists.osuosl.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, zorik@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        steffen.klassert@secunet.com
References: <158757160439.1370371.13213378122947426220.stgit@firesoul>
 <158757175790.1370371.16071055208561239272.stgit@firesoul>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <69e05693-c3df-8f48-7a08-03bf4d58cb07@iogearbox.net>
Date:   Mon, 27 Apr 2020 21:51:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <158757175790.1370371.16071055208561239272.stgit@firesoul>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25795/Mon Apr 27 14:00:10 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/22/20 6:09 PM, Jesper Dangaard Brouer wrote:
> This driver uses different memory models depending on PAGE_SIZE at
> compile time. For PAGE_SIZE 4K it uses page splitting, meaning for
> normal MTU frame size is 2048 bytes (and headroom 192 bytes). For
> larger MTUs the driver still use page splitting, by allocating
> order-1 pages (8192 bytes) for RX frames. For PAGE_SIZE larger than
> 4K, driver instead advance its rx_buffer->page_offset with the frame
> size "truesize".
> 
> For XDP frame size calculations, this mean that in PAGE_SIZE larger
> than 4K mode the frame_sz change on a per packet basis. For the page
> split 4K PAGE_SIZE mode, xdp.frame_sz is more constant and can be
> updated once outside the main NAPI loop.
> 
> The default setting in the driver uses build_skb(), which provides
> the necessary headroom and tailroom for XDP-redirect in RX-frame
> (in both modes).
> 
> There is one complication, which is legacy-rx mode (configurable via
> ethtool priv-flags). There are zero headroom in this mode, which is a
> requirement for XDP-redirect to work. The conversion to xdp_frame
> (convert_to_xdp_frame) will detect this insufficient space, and
> xdp_do_redirect() call will fail. This is deemed acceptable, as it
> allows other XDP actions to still work in legacy-mode. In
> legacy-mode + larger PAGE_SIZE due to lacking tailroom, we also
> accept that xdp_adjust_tail shrink doesn't work.
> 
> Cc: intel-wired-lan@lists.osuosl.org
> Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Cc: Alexander Duyck <alexander.duyck@gmail.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Alexander/Jeff, in case the ixgbe/i40e/ice changes look good to you,
please ack.

Thanks,
Daniel

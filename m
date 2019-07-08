Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E67B062CBB
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 01:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfGHXki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 19:40:38 -0400
Received: from www62.your-server.de ([213.133.104.62]:45374 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbfGHXki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 19:40:38 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hkdFI-0005Rv-Lr; Tue, 09 Jul 2019 01:40:32 +0200
Received: from [178.193.45.231] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hkdFI-000VD0-Du; Tue, 09 Jul 2019 01:40:32 +0200
Subject: Re: [PATCH bpf-next v3 1/6] xsk: replace ndo_xsk_async_xmit with
 ndo_xsk_wakeup
To:     Magnus Karlsson <magnus.karlsson@intel.com>, bjorn.topel@intel.com,
        ast@kernel.org, netdev@vger.kernel.org, brouer@redhat.com
Cc:     bpf@vger.kernel.org, bruce.richardson@intel.com,
        ciara.loftus@intel.com, jakub.kicinski@netronome.com,
        xiaolong.ye@intel.com, qi.z.zhang@intel.com, maximmi@mellanox.com,
        sridhar.samudrala@intel.com, kevin.laatz@intel.com,
        ilias.apalodimas@linaro.org, kiran.patil@intel.com,
        axboe@kernel.dk, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org
References: <1562244134-19069-1-git-send-email-magnus.karlsson@intel.com>
 <1562244134-19069-2-git-send-email-magnus.karlsson@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <57e022b7-ac0e-6a9c-5078-c44988fd9fe6@iogearbox.net>
Date:   Tue, 9 Jul 2019 01:40:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <1562244134-19069-2-git-send-email-magnus.karlsson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25504/Mon Jul  8 10:05:57 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/04/2019 02:42 PM, Magnus Karlsson wrote:
> This commit replaces ndo_xsk_async_xmit with ndo_xsk_wakeup. This new
> ndo provides the same functionality as before but with the addition of
> a new flags field that is used to specifiy if Rx, Tx or both should be
> woken up. The previous ndo only woke up Tx, as implied by the
> name. The i40e and ixgbe drivers (which are all the supported ones)
> are updated with this new interface.
> 
> This new ndo will be used by the new need_wakeup functionality of XDP
> sockets that need to be able to wake up both Rx and Tx driver
> processing.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_main.c          |  5 +++--
>  drivers/net/ethernet/intel/i40e/i40e_xsk.c           |  7 ++++---
>  drivers/net/ethernet/intel/i40e/i40e_xsk.h           |  2 +-
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c        |  5 +++--
>  drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h |  2 +-
>  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c         |  4 ++--
>  drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c  |  2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h  |  2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en_main.c    |  2 +-
>  include/linux/netdevice.h                            | 14 ++++++++++++--
>  net/xdp/xdp_umem.c                                   |  3 +--
>  net/xdp/xsk.c                                        |  3 ++-
>  12 files changed, 32 insertions(+), 19 deletions(-)

Looks good, but given driver changes to support the AF_XDP need_wakeup
feature are quite trivial, is there a reason that you updated mlx5 here
but not for the actual support such that all three in-tree drivers are
supported?

Thanks,
Daniel

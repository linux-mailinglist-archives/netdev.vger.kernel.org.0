Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D76550EFC
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 16:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729395AbfFXOsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 10:48:23 -0400
Received: from www62.your-server.de ([213.133.104.62]:58502 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727385AbfFXOsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 10:48:22 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hfQGR-0004JD-03; Mon, 24 Jun 2019 16:48:11 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hfQGQ-000NBz-Nx; Mon, 24 Jun 2019 16:48:10 +0200
Subject: Re: [PATCH bpf-next v5 00/16] AF_XDP infrastructure improvements and
 mlx5e support
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
References: <20190618120024.16788-1-maximmi@mellanox.com>
 <CAJ+HfNia-vUv7Eumfs8aMYGGkxPbbUQ++F+BQ=9C1NtP0Jt3hA@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2f85cd4c-462f-8418-a4d1-a87782656c40@iogearbox.net>
Date:   Mon, 24 Jun 2019 16:48:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <CAJ+HfNia-vUv7Eumfs8aMYGGkxPbbUQ++F+BQ=9C1NtP0Jt3hA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25490/Mon Jun 24 10:02:14 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/20/2019 11:13 AM, Björn Töpel wrote:
> On Tue, 18 Jun 2019 at 14:00, Maxim Mikityanskiy <maximmi@mellanox.com> wrote:
>>
>> This series contains improvements to the AF_XDP kernel infrastructure
>> and AF_XDP support in mlx5e. The infrastructure improvements are
>> required for mlx5e, but also some of them benefit to all drivers, and
>> some can be useful for other drivers that want to implement AF_XDP.
>>
>> The performance testing was performed on a machine with the following
>> configuration:
>>
>> - 24 cores of Intel Xeon E5-2620 v3 @ 2.40 GHz
>> - Mellanox ConnectX-5 Ex with 100 Gbit/s link
>>
>> The results with retpoline disabled, single stream:
>>
>> txonly: 33.3 Mpps (21.5 Mpps with queue and app pinned to the same CPU)
>> rxdrop: 12.2 Mpps
>> l2fwd: 9.4 Mpps
>>
>> The results with retpoline enabled, single stream:
>>
>> txonly: 21.3 Mpps (14.1 Mpps with queue and app pinned to the same CPU)
>> rxdrop: 9.9 Mpps
>> l2fwd: 6.8 Mpps
>>
>> v2 changes:
>>
>> Added patches for mlx5e and addressed the comments for v1. Rebased for
>> bpf-next.
>>
>> v3 changes:
>>
>> Rebased for the newer bpf-next, resolved conflicts in libbpf. Addressed
>> Björn's comments for coding style. Fixed a bug in error handling flow in
>> mlx5e_open_xsk.
>>
>> v4 changes:
>>
>> UAPI is not changed, XSK RX queues are exposed to the kernel. The lower
>> half of the available amount of RX queues are regular queues, and the
>> upper half are XSK RX queues. The patch "xsk: Extend channels to support
>> combined XSK/non-XSK traffic" was dropped. The final patch was reworked
>> accordingly.
>>
>> Added "net/mlx5e: Attach/detach XDP program safely", as the changes
>> introduced in the XSK patch base on the stuff from this one.
>>
>> Added "libbpf: Support drivers with non-combined channels", which aligns
>> the condition in libbpf with the condition in the kernel.
>>
>> Rebased over the newer bpf-next.
>>
>> v5 changes:
>>
>> In v4, ethtool reports the number of channels as 'combined' and the
>> number of XSK RX queues as 'rx' for mlx5e. It was changed, so that 'rx'
>> is 0, and 'combined' reports the double amount of channels if there is
>> an active UMEM - to make libbpf happy.
>>
>> The patch for libbpf was dropped. Although it's still useful and fixes
>> things, it raises some disagreement, so I'm dropping it - it's no longer
>> useful for mlx5e anymore after the change above.
> 
> Just a heads-up: There are some checkpatch warnings (>80 chars/line)
> for the mlnx5 driver parts, and the series didn't apply cleanly on
> bpf-next for me.
> 
> I haven't been able to test the mlnx5 parts.
> 
> Parts of the series are unrelated/orthogonal, and could be submitted
> as separate series, e.g. patches {1,7} and patches {3,4}. No blockers
> for me, though.
> 
> Thanks for the hard work!

+1

> For the series:
> Acked-by: Björn Töpel <bjorn.topel@intel.com>

Looks good to me, but as Björn already indicated, there's one last rebase
needed since it doesn't apply cleanly in the last one that adds the actual
AF_XDP support, please take a look and rebase:

[...]
Applying: net/mlx5e: Attach/detach XDP program safely
Applying: xsk: Add API to check for available entries in FQ
Applying: xsk: Add getsockopt XDP_OPTIONS
Applying: libbpf: Support getsockopt XDP_OPTIONS
Applying: xsk: Change the default frame size to 4096 and allow controlling it
Applying: xsk: Return the whole xdp_desc from xsk_umem_consume_tx
Using index info to reconstruct a base tree...
M	drivers/net/ethernet/intel/i40e/i40e_xsk.c
M	drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
Auto-merging drivers/net/ethernet/intel/i40e/i40e_xsk.c
Applying: net/mlx5e: Replace deprecated PCI_DMA_TODEVICE
Applying: net/mlx5e: Calculate linear RX frag size considering XSK
Applying: net/mlx5e: Allow ICO SQ to be used by multiple RQs
Applying: net/mlx5e: Refactor struct mlx5e_xdp_info
Applying: net/mlx5e: Share the XDP SQ for XDP_TX between RQs
Applying: net/mlx5e: XDP_TX from UMEM support
Applying: net/mlx5e: Consider XSK in XDP MTU limit calculation
Applying: net/mlx5e: Encapsulate open/close queues into a function
Applying: net/mlx5e: Move queue param structs to en/params.h
Applying: net/mlx5e: Add XSK zero-copy support
fatal: sha1 information is lacking or useless (drivers/net/ethernet/mellanox/mlx5/core/en.h).
error: could not build fake ancestor
Patch failed at 0016 net/mlx5e: Add XSK zero-copy support

Thanks,
Daniel

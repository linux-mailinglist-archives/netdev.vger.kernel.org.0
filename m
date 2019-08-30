Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D55EA4109
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 01:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbfH3X3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 19:29:43 -0400
Received: from www62.your-server.de ([213.133.104.62]:59818 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728248AbfH3X3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 19:29:43 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1i3qKp-0004bm-2Q; Sat, 31 Aug 2019 01:29:39 +0200
Received: from [178.197.249.19] (helo=pc-63.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1i3qKo-000KDR-QF; Sat, 31 Aug 2019 01:29:38 +0200
Subject: Re: [PATCH bpf-next v6 00/12] XDP unaligned chunk placement support
To:     Kevin Laatz <kevin.laatz@intel.com>, netdev@vger.kernel.org,
        ast@kernel.org, bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jakub.kicinski@netronome.com, jonathan.lemon@gmail.com,
        saeedm@mellanox.com, maximmi@mellanox.com,
        stephen@networkplumber.org
Cc:     bruce.richardson@intel.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org
References: <20190822014427.49800-1-kevin.laatz@intel.com>
 <20190827022531.15060-1-kevin.laatz@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <4b3f1e4c-7db6-d658-aba1-40237b9aa053@iogearbox.net>
Date:   Sat, 31 Aug 2019 01:29:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190827022531.15060-1-kevin.laatz@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25557/Fri Aug 30 10:30:29 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/27/19 4:25 AM, Kevin Laatz wrote:
> This patch set adds the ability to use unaligned chunks in the XDP umem.
> 
> Currently, all chunk addresses passed to the umem are masked to be chunk
> size aligned (max is PAGE_SIZE). This limits where we can place chunks
> within the umem as well as limiting the packet sizes that are supported.
> 
> The changes in this patch set removes these restrictions, allowing XDP to
> be more flexible in where it can place a chunk within a umem. By relaxing
> where the chunks can be placed, it allows us to use an arbitrary buffer
> size and place that wherever we have a free address in the umem. These
> changes add the ability to support arbitrary frame sizes up to 4k
> (PAGE_SIZE) and make it easy to integrate with other existing frameworks
> that have their own memory management systems, such as DPDK.
> In DPDK, for example, there is already support for AF_XDP with zero-copy.
> However, with this patch set the integration will be much more seamless.
> You can find the DPDK AF_XDP driver at:
> https://git.dpdk.org/dpdk/tree/drivers/net/af_xdp
> 
> Since we are now dealing with arbitrary frame sizes, we need also need to
> update how we pass around addresses. Currently, the addresses can simply be
> masked to 2k to get back to the original address. This becomes less trivial
> when using frame sizes that are not a 'power of 2' size. This patch set
> modifies the Rx/Tx descriptor format to use the upper 16-bits of the addr
> field for an offset value, leaving the lower 48-bits for the address (this
> leaves us with 256 Terabytes, which should be enough!). We only need to use
> the upper 16-bits to store the offset when running in unaligned mode.
> Rather than adding the offset (headroom etc) to the address, we will store
> it in the upper 16-bits of the address field. This way, we can easily add
> the offset to the address where we need it, using some bit manipulation and
> addition, and we can also easily get the original address wherever we need
> it (for example in i40e_zca_free) by simply masking to get the lower
> 48-bits of the address field.
> 
> The patch set was tested with the following set up:
>    - Intel(R) Xeon(R) Gold 6140 CPU @ 2.30GHz
>    - Intel Corporation Ethernet Controller XXV710 for 25GbE SFP28 (rev 02)
>    - Driver: i40e
>    - Application: xdpsock with l2fwd (single interface)
>    - Turbo disabled in BIOS
> 
> There are no changes to performance before and after these patches for SKB
> mode and Copy mode. Zero-copy mode saw a performance degradation of ~1.5%.
> 
> This patch set has been applied against
> commit 0bb52b0dfc88 ("tools: bpftool: add 'bpftool map freeze' subcommand")
> 
> Structure of the patch set:
> Patch 1:
>    - Remove unnecessary masking and headroom addition during zero-copy Rx
>      buffer recycling in i40e. This change is required in order for the
>      buffer recycling to work in the unaligned chunk mode.
> 
> Patch 2:
>    - Remove unnecessary masking and headroom addition during
>      zero-copy Rx buffer recycling in ixgbe. This change is required in
>      order for the  buffer recycling to work in the unaligned chunk mode.
> 
> Patch 3:
>    - Add infrastructure for unaligned chunks. Since we are dealing with
>      unaligned chunks that could potentially cross a physical page boundary,
>      we add checks to keep track of that information. We can later use this
>      information to correctly handle buffers that are placed at an address
>      where they cross a page boundary.  This patch also modifies the
>      existing Rx and Tx functions to use the new descriptor format. To
>      handle addresses correctly, we need to mask appropriately based on
>      whether we are in aligned or unaligned mode.
> 
> Patch 4:
>    - This patch updates the i40e driver to make use of the new descriptor
>      format.
> 
> Patch 5:
>    - This patch updates the ixgbe driver to make use of the new descriptor
>      format.
> 
> Patch 6:
>    - This patch updates the mlx5e driver to make use of the new descriptor
>      format. These changes are required to handle the new descriptor format
>      and for unaligned chunks support.
> 
> Patch 7:
>    - This patch allows XSK frames smaller than page size in the mlx5e
>      driver. Relax the requirements to the XSK frame size to allow it to be
>      smaller than a page and even not a power of two. The current
>      implementation can work in this mode, both with Striding RQ and without
>      it.
> 
> Patch 8:
>    - Add flags for umem configuration to libbpf. Since we increase the size
>      of the struct by adding flags, we also need to add the ABI versioning
>      in this patch.
> 
> Patch 9:
>    - Modify xdpsock application to add a command line option for
>      unaligned chunks
> 
> Patch 10:
>    - Since we can now run the application in unaligned chunk mode, we need
>      to make sure we recycle the buffers appropriately.
> 
> Patch 11:
>    - Adds hugepage support to the xdpsock application
> 
> Patch 12:
>    - Documentation update to include the unaligned chunk scenario. We need
>      to explicitly state that the incoming addresses are only masked in the
>      aligned chunk mode and not the unaligned chunk mode.
> 
> ---
> v2:
>    - fixed checkpatch issues
>    - fixed Rx buffer recycling for unaligned chunks in xdpsock
>    - removed unused defines
>    - fixed how chunk_size is calculated in xsk_diag.c
>    - added some performance numbers to cover letter
>    - modified descriptor format to make it easier to retrieve original
>      address
>    - removed patch adding off_t off to the zero copy allocator. This is no
>      longer needed with the new descriptor format.
> 
> v3:
>    - added patch for mlx5 driver changes needed for unaligned chunks
>    - moved offset handling to new helper function
>    - changed value used for the umem chunk_mask. Now using the new
>      descriptor format to save us doing the calculations in a number of
>      places meaning more of the code is left unchanged while adding
>      unaligned chunk support.
> 
> v4:
>    - reworked the next_pg_contig field in the xdp_umem_page struct. We now
>      use the low 12 bits of the addr for flags rather than adding an extra
>      field in the struct.
>    - modified unaligned chunks flag define
>    - fixed page_start calculation in __xsk_rcv_memcpy().
>    - move offset handling to the xdp_umem_get_* functions
>    - modified the len field in xdp_umem_reg struct. We now use 16 bits from
>      this for the flags field.
>    - fixed headroom addition to handle in the mlx5e driver
>    - other minor changes based on review comments
> 
> v5:
>    - Added ABI versioning in the libbpf patch
>    - Removed bitfields in the xdp_umem_reg struct. Adding new flags field.
>    - Added accessors for getting addr and offset.
>    - Added helper function for adding the offset to the addr.
>    - Fixed conflicts with 'bpf-af-xdp-wakeup' which was merged recently.
>    - Fixed typo in mlx driver patch.
>    - Moved libbpf patch to later in the set (7/11, just before the sample
>      app changes)
> 
> v6:
>    - Added support for XSK frames smaller than page in mlx5e driver (Maxim
>      Mikityanskiy <maximmi@mellanox.com).
>    - Fixed offset handling in xsk_generic_rcv.
>    - Added check for base address in xskq_is_valid_addr_unaligned.
> 
> Kevin Laatz (11):
>    i40e: simplify Rx buffer recycle
>    ixgbe: simplify Rx buffer recycle
>    xsk: add support to allow unaligned chunk placement
>    i40e: modify driver for handling offsets
>    ixgbe: modify driver for handling offsets
>    mlx5e: modify driver for handling offsets
>    libbpf: add flags to umem config
>    samples/bpf: add unaligned chunks mode support to xdpsock
>    samples/bpf: add buffer recycling for unaligned chunks to xdpsock
>    samples/bpf: use hugepages in xdpsock app
>    doc/af_xdp: include unaligned chunk case
> 
> Maxim Mikityanskiy (1):
>    net/mlx5e: Allow XSK frames smaller than a page
> 
>   Documentation/networking/af_xdp.rst           | 10 +-
>   drivers/net/ethernet/intel/i40e/i40e_xsk.c    | 26 +++--
>   drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 26 +++--
>   .../ethernet/mellanox/mlx5/core/en/params.c   | 23 ++++-
>   .../ethernet/mellanox/mlx5/core/en/params.h   |  2 +
>   .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  8 +-
>   .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   |  5 +-
>   .../mellanox/mlx5/core/en/xsk/setup.c         | 15 ++-
>   include/net/xdp_sock.h                        | 75 ++++++++++++++-
>   include/uapi/linux/if_xdp.h                   |  9 ++
>   net/xdp/xdp_umem.c                            | 19 +++-
>   net/xdp/xsk.c                                 | 94 +++++++++++++++----
>   net/xdp/xsk_diag.c                            |  2 +-
>   net/xdp/xsk_queue.h                           | 70 ++++++++++++--
>   samples/bpf/xdpsock_user.c                    | 61 ++++++++----
>   tools/include/uapi/linux/if_xdp.h             |  9 ++
>   tools/lib/bpf/Makefile                        |  5 +-
>   tools/lib/bpf/libbpf.map                      |  1 +
>   tools/lib/bpf/xsk.c                           | 33 ++++++-
>   tools/lib/bpf/xsk.h                           | 27 ++++++
>   20 files changed, 417 insertions(+), 103 deletions(-)
> 

Applied, thanks!

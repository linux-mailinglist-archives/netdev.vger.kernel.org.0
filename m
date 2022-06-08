Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF1A543839
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 17:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244716AbiFHP4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 11:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244672AbiFHP4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 11:56:15 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E84275FE;
        Wed,  8 Jun 2022 08:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654703773; x=1686239773;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TPy6InE6jWXR7bBkkkd/r5A9Hqxrd2aUIPyHv9iXLXA=;
  b=eNTw0jx6jlSJgn+wZSTyhBtugueO4/cZoeuwv916bhsD7FYgQYsEkqnv
   o9K4UV4DMeGOEuLNJBLTK9Lr3fS0bntXj/Jf1c6EXgvrmLa/q/9ABGIwx
   HZmdKf+WMFrQ7Fv+Sbmst4PXpaPtgrBQPzR8sltCkw7TSTESRIwCEEWzx
   qF4HMdoh6iiievxQkKirfgtrereF6ljm3xZEv27uI1RMXoQLiVuaR2z8t
   IThfDpNM6Vo2I4/0nRSiNqTu7M4eWds2ucBHeaBWl9+A+0/c7ZyOLnecW
   QXkgpuoxqrxe/q07wv3wor5oDSiErQo9j0VFGJ2YDqPDA81N8R1kLkDhj
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10372"; a="363273484"
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="363273484"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 08:55:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="584967098"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.132])
  by fmsmga007.fm.intel.com with ESMTP; 08 Jun 2022 08:55:55 -0700
Date:   Wed, 8 Jun 2022 23:59:41 +0800
From:   Zhao Liu <zhao1.liu@linux.intel.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     "linux-kernel-AT-vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm-AT-vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization-AT-lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev-AT-vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        Zhao Liu <zhao1.liu@linux.intel.com>
Subject: Re: [RFC PATCH v2 0/8] virtio/vsock: experimental zerocopy receive
Message-ID: <20220608155941.GA34797@liuzhao-OptiPlex-7080>
References: <e37fdf9b-be80-35e1-ae7b-c9dfeae3e3db@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e37fdf9b-be80-35e1-ae7b-c9dfeae3e3db@sberdevices.ru>
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 03, 2022 at 05:27:56AM +0000, Arseniy Krasnov wrote:
> Date:   Fri, 3 Jun 2022 05:27:56 +0000
> From: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
> Subject: [RFC PATCH v2 0/8] virtio/vsock: experimental zerocopy receive
> 
>                               INTRODUCTION
> 
> 	Hello, this is experimental implementation of virtio vsock zerocopy
> receive. It was inspired by TCP zerocopy receive by Eric Dumazet. This API uses
> same idea: call 'mmap()' on socket's descriptor, then every 'getsockopt()' will
> fill provided vma area with pages of virtio RX buffers. After received data was
> processed by user, pages must be freed by 'madvise()'  call with MADV_DONTNEED
> flag set(if user won't call 'madvise()', next 'getsockopt()' will fail).
> 
>                                  DETAILS
> 
> 	Here is how mapping with mapped pages looks exactly: first page mapping
> contains array of trimmed virtio vsock packet headers (in contains only length
> of data on the corresponding page and 'flags' field):
> 
> 	struct virtio_vsock_usr_hdr {
> 		uint32_t length;
> 		uint32_t flags;
> 		uint32_t copy_len;
> 	};
> 
> Field  'length' allows user to know exact size of payload within each sequence
> of pages and 'flags' allows user to handle SOCK_SEQPACKET flags(such as message
> bounds or record bounds). Field 'copy_len' is described below in 'v1->v2' part.
> All other pages are data pages from RX queue.
> 
>              Page 0      Page 1      Page N
> 
> 	[ hdr1 .. hdrN ][ data ] .. [ data ]
>            |        |       ^           ^
>            |        |       |           |
>            |        *-------------------*
>            |                |
>            |                |
>            *----------------*
> 
> 	Of course, single header could represent array of pages (when packet's
> buffer is bigger than one page).So here is example of detailed mapping layout
> for some set of packages. Lets consider that we have the following sequence  of
> packages: 56 bytes, 4096 bytes and 8200 bytes. All pages: 0,1,2,3,4 and 5 will
> be inserted to user's vma(vma is large enough).
> 
> 	Page 0: [[ hdr0 ][ hdr 1 ][ hdr 2 ][ hdr 3 ] ... ]

Hi Arseniy, what about adding a `header` for `virtio_vsock_usr_hdr` in Page 0?

Page 0 can be like this:

	Page 0: [[ header for hdrs ][ hdr0 ][ hdr 1 ][ hdr 2 ][ hdr 3 ] ... ]

We can store the header numbers/page numbers in this first general header:

	struct virtio_vsock_general_hdr {
		uint32_t usr_hdr_num;
	};

This usr_hdr_num represents how many pages we used here.
At most 256 pages will be used here, and this kind of statistical information is
useful.
> 	Page 1: [ 56 ]
> 	Page 2: [ 4096 ]
> 	Page 3: [ 4096 ]
> 	Page 4: [ 4096 ]
> 	Page 5: [ 8 ]
> 
> 	Page 0 contains only array of headers:
> 	'hdr0' has 56 in length field.
> 	'hdr1' has 4096 in length field.
> 	'hdr2' has 8200 in length field.
> 	'hdr3' has 0 in length field(this is end of data marker).
> 
> 	Page 1 corresponds to 'hdr0' and has only 56 bytes of data.
> 	Page 2 corresponds to 'hdr1' and filled with data.
> 	Page 3 corresponds to 'hdr2' and filled with data.
> 	Page 4 corresponds to 'hdr2' and filled with data.
> 	Page 5 corresponds to 'hdr2' and has only 8 bytes of data.
> 
> 	This patchset also changes packets allocation way: today implementation
> uses only 'kmalloc()' to create data buffer. Problem happens when we try to map
> such buffers to user's vma - kernel forbids to map slab pages to user's vma(as
> pages of "not large" 'kmalloc()' allocations are marked with PageSlab flag and
> "not large" could be bigger than one page). So to avoid this, data buffers now
> allocated using 'alloc_pages()' call.
> 
>                                    TESTS
> 
> 	This patchset updates 'vsock_test' utility: two tests for new feature
> were added. First test covers invalid cases. Second checks valid transmission
> case.
> 
>                                 BENCHMARKING
> 
> 	For benchmakring I've added small utility 'rx_zerocopy'. It works in
> client/server mode. When client connects to server, server starts sending exact
> amount of data to client(amount is set as input argument).Client reads data and
> waits for next portion of it. Client works in two modes: copy and zero-copy. In
> copy mode client uses 'read()' call while in zerocopy mode sequence of 'mmap()'
> /'getsockopt()'/'madvise()' are used. Smaller amount of time for transmission 
> is better. For server, we can set size of tx buffer and for client we can set
> size of rx buffer or rx mapping size(in zerocopy mode). Usage of this utility
> is quiet simple:
> 
> For client mode:
> 
> ./rx_zerocopy --mode client [--zerocopy] [--rx]
> 
> For server mode:
> 
> ./rx_zerocopy --mode server [--mb] [--tx]
> 
> [--mb] sets number of megabytes to transfer.
> [--rx] sets size of receive buffer/mapping in pages.
> [--tx] sets size of transmit buffer in pages.
> 
> I checked for transmission of 4000mb of data. Here are some results:
> 
>                            size of rx/tx buffers in pages
>                *---------------------------------------------------*
>                |    8   |    32    |    64   |   256    |   512    |
> *--------------*--------*----------*---------*----------*----------*
> |   zerocopy   |   24   |   10.6   |  12.2   |   23.6   |    21    | secs to
> *--------------*---------------------------------------------------- process
> | non-zerocopy |   13   |   16.4   |  24.7   |   27.2   |   23.9   | 4000 mb
> *--------------*----------------------------------------------------
> 
> Result in first column(where non-zerocopy works better than zerocopy) happens
> because time, spent in 'read()' system call is smaller that time in 'getsockopt'
> + 'madvise'. I've checked that.
> 
> I think, that results are not so impressive, but at least it is not worse than
> copy mode and there is no need to allocate memory for processing date.
> 
>                                  PROBLEMS
> 
> 	Updated packet's allocation logic creates some problem: when host gets
> data from guest(in vhost-vsock), it allocates at least one page for each packet
> (even if packet has 1 byte payload). I think this could be resolved in several
> ways:
> 	1) Make zerocopy rx mode disabled by default, so if user didn't enable
> it, current 'kmalloc()' way will be used. <<<<<<< (IMPLEMENTED IN V2)
> 	2) Use 'kmalloc()' for "small" packets, else call page allocator. But
> in this case, we have mix of packets, allocated in two different ways thus
> during zerocopying to user(e.g. mapping pages to vma), such small packets will
> be handled in some stupid way: we need to allocate one page for user, copy data
> to it and then insert page to user's vma.
> 
> v1 -> v2:
>  1) Zerocopy receive mode could be enabled/disabled(disabled by default). I
>     didn't use generic SO_ZEROCOPY flag, because in virtio-vsock case this
>     feature depends on transport support. Instead of SO_ZEROCOPY, AF_VSOCK
>     layer flag was added: SO_VM_SOCKETS_ZEROCOPY, while previous meaning of
>     SO_VM_SOCKETS_ZEROCOPY(insert receive buffers to user's vm area) now
>     renamed to SO_VM_SOCKETS_MAP_RX.
>  2) Packet header which is exported to user now get new field: 'copy_len'.
>     This field handles special case:  user reads data from socket in non
>     zerocopy way(with disabled zerocopy) and then enables zerocopy feature.
>     In this case vhost part will switch data buffer allocation logic from
>     'kmalloc()' to direct calls for buddy allocator. But, there could be
>     some pending 'kmalloc()' allocated packets in socket's rx list, and then
>     user tries to read such packets in zerocopy way, dequeue will fail,
>     because SLAB pages could not be inserted to user's vm area. So when such
>     packet is found during zerocopy dequeue, dequeue loop will break and
>     'copy_len' will show size of such "bad" packet. After user detects this
>     case, it must use 'read()/recv()' calls to dequeue such packet.
>  3) Also may be move this features under config option?
> 
> Arseniy Krasnov(8)
>  virtio/vsock: rework packet allocation logic
>  vhost/vsock: rework packet allocation logic
>  af_vsock: add zerocopy receive logic
>  virtio/vsock: add transport zerocopy callback
>  vhost/vsock: enable zerocopy callback
>  virtio/vsock: enable zerocopy callback
>  test/vsock: add receive zerocopy tests
>  test/vsock: vsock rx zerocopy utility
> 
>  drivers/vhost/vsock.c                   | 121 +++++++++--
>  include/linux/virtio_vsock.h            |   5 +
>  include/net/af_vsock.h                  |   7 +
>  include/uapi/linux/virtio_vsock.h       |   6 +
>  include/uapi/linux/vm_sockets.h         |   3 +
>  net/vmw_vsock/af_vsock.c                | 100 +++++++++
>  net/vmw_vsock/virtio_transport.c        |  51 ++++-
>  net/vmw_vsock/virtio_transport_common.c | 211 ++++++++++++++++++-
>  tools/include/uapi/linux/virtio_vsock.h |  11 +
>  tools/include/uapi/linux/vm_sockets.h   |   8 +
>  tools/testing/vsock/Makefile            |   1 +
>  tools/testing/vsock/control.c           |  34 +++
>  tools/testing/vsock/control.h           |   2 +
>  tools/testing/vsock/rx_zerocopy.c       | 356 ++++++++++++++++++++++++++++++++
>  tools/testing/vsock/vsock_test.c        | 295 ++++++++++++++++++++++++++
>  15 files changed, 1196 insertions(+), 15 deletions(-)
> 
> -- 
> 2.25.1

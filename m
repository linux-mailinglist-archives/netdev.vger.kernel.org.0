Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6AEC4629CE
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 02:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236462AbhK3Bhm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 29 Nov 2021 20:37:42 -0500
Received: from mga02.intel.com ([134.134.136.20]:2931 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236373AbhK3Bhl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Nov 2021 20:37:41 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10183"; a="223342545"
X-IronPort-AV: E=Sophos;i="5.87,273,1631602800"; 
   d="scan'208";a="223342545"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2021 17:34:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,273,1631602800"; 
   d="scan'208";a="676605092"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 29 Nov 2021 17:34:23 -0800
Received: from shsmsx604.ccr.corp.intel.com (10.109.6.214) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 17:34:22 -0800
Received: from shsmsx601.ccr.corp.intel.com (10.109.6.141) by
 SHSMSX604.ccr.corp.intel.com (10.109.6.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 30 Nov 2021 09:34:20 +0800
Received: from shsmsx601.ccr.corp.intel.com ([10.109.6.141]) by
 SHSMSX601.ccr.corp.intel.com ([10.109.6.141]) with mapi id 15.01.2308.020;
 Tue, 30 Nov 2021 09:34:20 +0800
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     "mst@redhat.com" <mst@redhat.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2] virtio/vsock: fix the transport to work with
 VMADDR_CID_ANY
Thread-Topic: [PATCH v2] virtio/vsock: fix the transport to work with
 VMADDR_CID_ANY
Thread-Index: AQHX4m3Zj4b3Qhf8bE+JSA6gud1FyqwU+0CAgAZQX3A=
Date:   Tue, 30 Nov 2021 01:34:20 +0000
Message-ID: <2853d4c373aa4cf0961a256622014eed@intel.com>
References: <20211126011823.1760-1-wei.w.wang@intel.com>
 <20211126085341.wiab2frkcbmkg4ca@steredhat>
In-Reply-To: <20211126085341.wiab2frkcbmkg4ca@steredhat>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.200.16
x-originating-ip: [10.239.127.36]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

Do you plan to merge this patch through your tree?
If not, I'll resend to have it applied to the net tree.

Thanks,
Wei

On Friday, November 26, 2021 4:54 PM, Stefano Garzarella wrote:
> On Thu, Nov 25, 2021 at 08:18:23PM -0500, Wei Wang wrote:
> >The VMADDR_CID_ANY flag used by a socket means that the socket isn't
> >bound to any specific CID. For example, a host vsock server may want to
> >be bound with VMADDR_CID_ANY, so that a guest vsock client can connect
> >to the host server with CID=VMADDR_CID_HOST (i.e. 2), and meanwhile, a
> >host vsock client can connect to the same local server with
> >CID=VMADDR_CID_LOCAL (i.e. 1).
> >
> >The current implementation sets the destination socket's svm_cid to a
> >fixed CID value after the first client's connection, which isn't an
> >expected operation. For example, if the guest client first connects to
> >the host server, the server's svm_cid gets set to VMADDR_CID_HOST, then
> >other host clients won't be able to connect to the server anymore.
> >
> >Reproduce steps:
> >1. Run the host server:
> >   socat VSOCK-LISTEN:1234,fork -
> >2. Run a guest client to connect to the host server:
> >   socat - VSOCK-CONNECT:2:1234
> >3. Run a host client to connect to the host server:
> >   socat - VSOCK-CONNECT:1:1234
> >
> >Without this patch, step 3. above fails to connect, and socat complains
> >"socat[1720] E connect(5, AF=40 cid:1 port:1234, 16): Connection reset
> >by peer".
> >With this patch, the above works well.
> >
> >Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
> >Signed-off-by: Wei Wang <wei.w.wang@intel.com>
> >---
> > net/vmw_vsock/virtio_transport_common.c | 3 ++-
> > 1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Usually fixes for net/vmw_vsock/* are applied through the net tree
> (netdev@vger.kernel.org) that seems not CCed. Please
> use ./scripts/get_maintainer.pl next time.
> 
> Maybe this one can be queued by Michael, let's wait a bit, otherwise please
> resend CCing netdev and using "net" tag.
> 
> Anyway the patch LGTM:
> 
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17CED34CB61
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 10:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234983AbhC2Iqh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 29 Mar 2021 04:46:37 -0400
Received: from mga03.intel.com ([134.134.136.65]:35073 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235248AbhC2Ime (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 04:42:34 -0400
IronPort-SDR: vk5IvlhRwNLCqsurIeioaZOJkI/hyBjFg1XUaqo/zECSfpRNUIT4ViLDVOd0OflJ1sMVMoOwi3
 2ZxpXcyCvufA==
X-IronPort-AV: E=McAfee;i="6000,8403,9937"; a="191534952"
X-IronPort-AV: E=Sophos;i="5.81,287,1610438400"; 
   d="scan'208";a="191534952"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2021 01:41:32 -0700
IronPort-SDR: qCpEOheK42IdvbwkINi1ISulfr7bopDHfnNL1fBKxsUq6onFujJu9h0pWsr/+KlD6KxLbgGEW5
 Ka5BUxiKysfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,287,1610438400"; 
   d="scan'208";a="415338588"
Received: from irsmsx602.ger.corp.intel.com ([163.33.146.8])
  by orsmga007.jf.intel.com with ESMTP; 29 Mar 2021 01:41:30 -0700
Received: from irsmsx604.ger.corp.intel.com (163.33.146.137) by
 irsmsx602.ger.corp.intel.com (163.33.146.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 29 Mar 2021 09:41:29 +0100
Received: from irsmsx604.ger.corp.intel.com ([163.33.146.137]) by
 IRSMSX604.ger.corp.intel.com ([163.33.146.137]) with mapi id 15.01.2106.013;
 Mon, 29 Mar 2021 09:41:29 +0100
From:   "Loftus, Ciara" <ciara.loftus@intel.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "magnus.karlsson@gmail.com" <magnus.karlsson@gmail.com>
Subject: RE: [PATCH v2 bpf 3/3] libbpf: ignore return values of setsockopt for
 XDP rings.
Thread-Topic: [PATCH v2 bpf 3/3] libbpf: ignore return values of setsockopt
 for XDP rings.
Thread-Index: AQHXIlDjJrZQMtFJm0i7O3jDxgJtSaqXHNWAgAOK00A=
Date:   Mon, 29 Mar 2021 08:41:29 +0000
Message-ID: <bc1d9e861d27499da5f5a84bc6d22177@intel.com>
References: <20210326142946.5263-1-ciara.loftus@intel.com>
 <20210326142946.5263-4-ciara.loftus@intel.com>
 <20210327022729.cgizt5xnhkerbrmy@ast-mbp>
In-Reply-To: <20210327022729.cgizt5xnhkerbrmy@ast-mbp>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [163.33.253.164]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 
> On Fri, Mar 26, 2021 at 02:29:46PM +0000, Ciara Loftus wrote:
> > During xsk_socket__create the XDP_RX_RING and XDP_TX_RING
> setsockopts
> > are called to create the rx and tx rings for the AF_XDP socket. If the ring
> > has already been set up, the setsockopt will return an error. However,
> > in the event of a failure during xsk_socket__create(_shared) after the
> > rings have been set up, the user may wish to retry the socket creation
> > using these pre-existing rings. In this case we can ignore the error
> > returned by the setsockopts. If there is a true error, the subsequent
> > call to mmap() will catch it.
> >
> > Fixes: 1cad07884239 ("libbpf: add support for using AF_XDP sockets")
> >
> > Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
> > ---
> >  tools/lib/bpf/xsk.c | 34 ++++++++++++++++------------------
> >  1 file changed, 16 insertions(+), 18 deletions(-)
> >
> > diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> > index d4991ddff05a..cfc4abf505c3 100644
> > --- a/tools/lib/bpf/xsk.c
> > +++ b/tools/lib/bpf/xsk.c
> > @@ -900,24 +900,22 @@ int xsk_socket__create_shared(struct xsk_socket
> **xsk_ptr,
> >  	}
> >  	xsk->ctx = ctx;
> >
> > -	if (rx) {
> > -		err = setsockopt(xsk->fd, SOL_XDP, XDP_RX_RING,
> > -				 &xsk->config.rx_size,
> > -				 sizeof(xsk->config.rx_size));
> > -		if (err) {
> > -			err = -errno;
> > -			goto out_put_ctx;
> > -		}
> > -	}
> > -	if (tx) {
> > -		err = setsockopt(xsk->fd, SOL_XDP, XDP_TX_RING,
> > -				 &xsk->config.tx_size,
> > -				 sizeof(xsk->config.tx_size));
> > -		if (err) {
> > -			err = -errno;
> > -			goto out_put_ctx;
> > -		}
> > -	}
> > +	/* The return values of these setsockopt calls are intentionally not
> checked.
> > +	 * If the ring has already been set up setsockopt will return an error.
> However,
> > +	 * this scenario is acceptable as the user may be retrying the socket
> creation
> > +	 * with rings which were set up in a previous but ultimately
> unsuccessful call
> > +	 * to xsk_socket__create(_shared). The call later to mmap() will fail if
> there
> > +	 * is a real issue and we handle that return value appropriately there.
> > +	 */
> > +	if (rx)
> > +		setsockopt(xsk->fd, SOL_XDP, XDP_RX_RING,
> > +			   &xsk->config.rx_size,
> > +			   sizeof(xsk->config.rx_size));
> > +
> > +	if (tx)
> > +		setsockopt(xsk->fd, SOL_XDP, XDP_TX_RING,
> > +			   &xsk->config.tx_size,
> > +			   sizeof(xsk->config.tx_size));
> 
> Instead of ignoring the error can you remember that setsockopt was done
> in struct xsk_socket and don't do it the second time?

Ideally we don't have to ignore the error. However in the event of failure struct xsk_socket is freed at the end of xsk_socket__create so we can't use it to remember state between subsequent calls to __create(). 

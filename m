Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 359F345F135
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 17:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354173AbhKZQE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 11:04:26 -0500
Received: from mga14.intel.com ([192.55.52.115]:1580 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354276AbhKZQC0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 11:02:26 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10180"; a="235920619"
X-IronPort-AV: E=Sophos;i="5.87,266,1631602800"; 
   d="scan'208";a="235920619"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2021 07:54:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,266,1631602800"; 
   d="scan'208";a="539280176"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga001.jf.intel.com with ESMTP; 26 Nov 2021 07:54:51 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1AQFsn7W000916;
        Fri, 26 Nov 2021 15:54:49 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        brouer@redhat.com, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, bjorn@kernel.org,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>, magnus.karlsson@intel.com
Subject: Re: [Intel-wired-lan] [PATCH net-next 1/2] igc: AF_XDP zero-copy metadata adjust breaks SKBs on XDP_PASS
Date:   Fri, 26 Nov 2021 16:54:08 +0100
Message-Id: <20211126155408.147211-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <66f62ef7-f4c6-08df-a8e1-dbbe34b9b125@redhat.com>
References: <163700856423.565980.10162564921347693758.stgit@firesoul> <163700858579.565980.15265721798644582439.stgit@firesoul> <YaD8UHOxHasBkqEW@boxer> <66f62ef7-f4c6-08df-a8e1-dbbe34b9b125@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <jbrouer@redhat.com>
Date: Fri, 26 Nov 2021 16:32:47 +0100

> On 26/11/2021 16.25, Maciej Fijalkowski wrote:
> > On Mon, Nov 15, 2021 at 09:36:25PM +0100, Jesper Dangaard Brouer wrote:
> >> Driver already implicitly supports XDP metadata access in AF_XDP
> >> zero-copy mode, as xsk_buff_pool's xp_alloc() naturally set xdp_buff
> >> data_meta equal data.
> >>
> >> This works fine for XDP and AF_XDP, but if a BPF-prog adjust via
> >> bpf_xdp_adjust_meta() and choose to call XDP_PASS, then igc function
> >> igc_construct_skb_zc() will construct an invalid SKB packet. The
> >> function correctly include the xdp->data_meta area in the memcpy, but
> >> forgot to pull header to take metasize into account.
> >>
> >> Fixes: fc9df2a0b520 ("igc: Enable RX via AF_XDP zero-copy")
> >> Signed-off-by: Jesper Dangaard Brouer<brouer@redhat.com>
> > Acked-by: Maciej Fijalkowski<maciej.fijalkowski@intel.com>
> > 
> > Great catch. Will take a look at other ZC enabled Intel drivers if they
> > are affected as well.

They are. We'll cover them in a separate series, much thanks for
revealing that (:

> Thanks a lot for taking this task!!! :-)
> --Jesper

Al

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31DBA451C99
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 01:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345094AbhKPAVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 19:21:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36237 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347193AbhKOUja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 15:39:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637008593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p4Qgk9BqdfmLLByf7+qq+OORA7tMlVVgID7iwPx2sJg=;
        b=QBWy+AvKCwI9SMYEypaT8Jyot/Ed1BseaiChfXLhtMh6RR3TFk3a/mxLROtf4ktfmxROXe
        7NcuMnz3wTFtlZUl/qw+nAnU8EFcJ+FWkIwWyRjX6zoE3t+eWPPTjyHaxfXT940OORYWHw
        9UdBCflmEVMBTMTDIza72bPINgrVSyY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-7jjdhSTtPnine07XcaEjUQ-1; Mon, 15 Nov 2021 15:36:32 -0500
X-MC-Unique: 7jjdhSTtPnine07XcaEjUQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD9231006AA1;
        Mon, 15 Nov 2021 20:36:30 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA3A367847;
        Mon, 15 Nov 2021 20:36:26 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id D23F33247FDD7;
        Mon, 15 Nov 2021 21:36:25 +0100 (CET)
Subject: [PATCH net-next 1/2] igc: AF_XDP zero-copy metadata adjust breaks
 SKBs on XDP_PASS
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        anthony.l.nguyen@intel.com, jesse.brandeburg@intel.com,
        intel-wired-lan@lists.osuosl.org, magnus.karlsson@intel.com,
        bjorn@kernel.org
Date:   Mon, 15 Nov 2021 21:36:25 +0100
Message-ID: <163700858579.565980.15265721798644582439.stgit@firesoul>
In-Reply-To: <163700856423.565980.10162564921347693758.stgit@firesoul>
References: <163700856423.565980.10162564921347693758.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Driver already implicitly supports XDP metadata access in AF_XDP
zero-copy mode, as xsk_buff_pool's xp_alloc() naturally set xdp_buff
data_meta equal data.

This works fine for XDP and AF_XDP, but if a BPF-prog adjust via
bpf_xdp_adjust_meta() and choose to call XDP_PASS, then igc function
igc_construct_skb_zc() will construct an invalid SKB packet. The
function correctly include the xdp->data_meta area in the memcpy, but
forgot to pull header to take metasize into account.

Fixes: fc9df2a0b520 ("igc: Enable RX via AF_XDP zero-copy")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 8e448288ee26..76b0a7311369 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2448,8 +2448,10 @@ static struct sk_buff *igc_construct_skb_zc(struct igc_ring *ring,
 
 	skb_reserve(skb, xdp->data_meta - xdp->data_hard_start);
 	memcpy(__skb_put(skb, totalsize), xdp->data_meta, totalsize);
-	if (metasize)
+	if (metasize) {
 		skb_metadata_set(skb, metasize);
+		__skb_pull(skb, metasize);
+	}
 
 	return skb;
 }



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC471A2063
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 13:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbgDHLxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 07:53:13 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:25461 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727930AbgDHLxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 07:53:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586346791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S2+VTa1Cw98eK1vc+y3YoYS/rC5X/5D1agCiZcqwi0k=;
        b=jEJc87cHPiy8YJ//3IKQOhPvsvo2vEFTXHZcqgu3UkeO2IpAHdwC3xvj3415ZuXtTM+Pd8
        x4xDQLIHk31gv/f7NQSiRO5nHQXFswPBFOuNqSIzgepFVFBZhk+4IkhyXDEsD3FqsjLqoj
        w2SQ250Z27BFTRaKP6BlBEiM/EymkXI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-1lufJyPHNIWGJjM0beFkZw-1; Wed, 08 Apr 2020 07:53:05 -0400
X-MC-Unique: 1lufJyPHNIWGJjM0beFkZw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 23C781005509;
        Wed,  8 Apr 2020 11:53:03 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 83B9E19C70;
        Wed,  8 Apr 2020 11:52:57 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id A89F7300020FA;
        Wed,  8 Apr 2020 13:52:56 +0200 (CEST)
Subject: [PATCH RFC v2 28/33] xdp: for Intel AF_XDP drivers add XDP frame_sz
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     intel-wired-lan@lists.osuosl.org,
        =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, zorik@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Date:   Wed, 08 Apr 2020 13:52:56 +0200
Message-ID: <158634677661.707275.17823370564281193008.stgit@firesoul>
In-Reply-To: <158634658714.707275.7903484085370879864.stgit@firesoul>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Intel drivers implement native AF_XDP zerocopy in separate C-files,
that have its own invocation of bpf_prog_run_xdp(). The setup of
xdp_buff is also handled in separately from normal code path.

This patch update XDP frame_sz for AF_XDP zerocopy drivers i40e, ice
and ixgbe, as the code changes needed are very similar.  Introduce a
helper function xsk_umem_xdp_frame_sz() for calculating frame size.

Cc: intel-wired-lan@lists.osuosl.org
Cc: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
Cc: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c   |    2 ++
 drivers/net/ethernet/intel/ice/ice_xsk.c     |    2 ++
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c |    2 ++
 include/net/xdp_sock.h                       |   11 +++++++++++
 4 files changed, 17 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/eth=
ernet/intel/i40e/i40e_xsk.c
index 0b7d29192b2c..2b9184aead5f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -531,12 +531,14 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring,=
 int budget)
 {
 	unsigned int total_rx_bytes =3D 0, total_rx_packets =3D 0;
 	u16 cleaned_count =3D I40E_DESC_UNUSED(rx_ring);
+	struct xdp_umem *umem =3D rx_ring->xsk_umem;
 	unsigned int xdp_res, xdp_xmit =3D 0;
 	bool failure =3D false;
 	struct sk_buff *skb;
 	struct xdp_buff xdp;
=20
 	xdp.rxq =3D &rx_ring->xdp_rxq;
+	xdp.frame_sz =3D xsk_umem_xdp_frame_sz(umem);
=20
 	while (likely(total_rx_packets < (unsigned int)budget)) {
 		struct i40e_rx_buffer *bi;
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ether=
net/intel/ice/ice_xsk.c
index 8279db15e870..23e5515d4527 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -840,11 +840,13 @@ int ice_clean_rx_irq_zc(struct ice_ring *rx_ring, i=
nt budget)
 {
 	unsigned int total_rx_bytes =3D 0, total_rx_packets =3D 0;
 	u16 cleaned_count =3D ICE_DESC_UNUSED(rx_ring);
+	struct xdp_umem *umem =3D rx_ring->xsk_umem;
 	unsigned int xdp_xmit =3D 0;
 	bool failure =3D false;
 	struct xdp_buff xdp;
=20
 	xdp.rxq =3D &rx_ring->xdp_rxq;
+	xdp.frame_sz =3D xsk_umem_xdp_frame_sz(umem);
=20
 	while (likely(total_rx_packets < (unsigned int)budget)) {
 		union ice_32b_rx_flex_desc *rx_desc;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/e=
thernet/intel/ixgbe/ixgbe_xsk.c
index 74b540ebb3dc..a656ee9a1fae 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -431,12 +431,14 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_=
vector,
 	unsigned int total_rx_bytes =3D 0, total_rx_packets =3D 0;
 	struct ixgbe_adapter *adapter =3D q_vector->adapter;
 	u16 cleaned_count =3D ixgbe_desc_unused(rx_ring);
+	struct xdp_umem *umem =3D rx_ring->xsk_umem;
 	unsigned int xdp_res, xdp_xmit =3D 0;
 	bool failure =3D false;
 	struct sk_buff *skb;
 	struct xdp_buff xdp;
=20
 	xdp.rxq =3D &rx_ring->xdp_rxq;
+	xdp.frame_sz =3D xsk_umem_xdp_frame_sz(umem);
=20
 	while (likely(total_rx_packets < budget)) {
 		union ixgbe_adv_rx_desc *rx_desc;
diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index e86ec48ef627..1cd1ec3cea97 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -237,6 +237,12 @@ static inline u64 xsk_umem_adjust_offset(struct xdp_=
umem *umem, u64 address,
 	else
 		return address + offset;
 }
+
+static inline u32 xsk_umem_xdp_frame_sz(struct xdp_umem *umem)
+{
+	return umem->chunk_size_nohr + umem->headroom;
+}
+
 #else
 static inline int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *=
xdp)
 {
@@ -367,6 +373,11 @@ static inline u64 xsk_umem_adjust_offset(struct xdp_=
umem *umem, u64 handle,
 	return 0;
 }
=20
+static inline u32 xsk_umem_xdp_frame_sz(struct xdp_umem *umem)
+{
+	return 0;
+}
+
 static inline int __xsk_map_redirect(struct xdp_sock *xs, struct xdp_buf=
f *xdp)
 {
 	return -EOPNOTSUPP;



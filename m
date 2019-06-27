Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE57C57991
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 04:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbfF0Cey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 22:34:54 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37227 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbfF0Cey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 22:34:54 -0400
Received: by mail-pl1-f195.google.com with SMTP id bh12so408040plb.4
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 19:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CgsMysEIlX/j8P65SV2h8Nto0HfL8PyGOlJeyFecrks=;
        b=eGBnhJeR52AN1DFbrbrof5+jn6sYUtt19Uq9OGmWzykk8UH36oWtCz3LfVJmrC1KY1
         ZDsBxd/yQhnOvrtcKoZmXJ58102Y4SH1VfYfPz826eHGrEOk1qJHBoBdrzeiFhW3joOF
         geXIR4GUn++fx7pA/FhIEUF1mzpa9NOs36qMYFKsvC9qfee0xIYc+nt8XEozCPV35dZt
         y8r9+TrW/ZozirMDk6cK+Yljo3i90lCpqR/Hp9uQgqt0l3qjLM5VMssfui+0SGJRF4aQ
         Ua1X0QagSBeNxfoky67payHduzi6TghXgfFwzbo/oxpdy82H6CeSR56Re07mcTOMOKAz
         r30w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CgsMysEIlX/j8P65SV2h8Nto0HfL8PyGOlJeyFecrks=;
        b=I3ppYuXvOvS//OxB8dRn/bYiTIwEN20SYhltB01MQmoXQo0JUIg1jr7xiBEoc/nZCN
         MRjrGWExDyH7orOqqY2gBG+d58gxvnOpftxo8schMgOQAsNr4SrMje1K3dl29E3KTxcH
         3bK6E51YCMuRxEwGY9f0DqH/xWGExyHDwl+DEPdsDqKPrBmb6RN6je1xUhQ09cMIN1/g
         /Rs1x+ggNAEGH5ZfuxfSKrseiHbMtuS+eq7HEtTA+HAKOnNhcn4it4OCiCmHVJks0ILj
         xAByAOARh03y/CfPm2+urTbsHR1mWmSTwOJ9mBa1xWnimYEXQFCtXfSrej+WYLIM8iLh
         R0Mg==
X-Gm-Message-State: APjAAAUf5RvNCmM4KxTCdODSX6nmHEy3LER22Cm9s15N75XvJkdpGeg8
        ncZEd8NuwXKo+CLmTqzhN48=
X-Google-Smtp-Source: APXvYqyIciS0Y6owFeAXZf5SAiucGz2ONm1szexTvREi6qq87gCHhzEpbJJor07UHFYOGXxIHkGUtQ==
X-Received: by 2002:a17:902:4183:: with SMTP id f3mr1631926pld.336.1561602893324;
        Wed, 26 Jun 2019 19:34:53 -0700 (PDT)
Received: from localhost.localdomain (osnfw.sakura.ad.jp. [210.224.179.167])
        by smtp.gmail.com with ESMTPSA id x128sm653284pfd.17.2019.06.26.19.34.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 26 Jun 2019 19:34:52 -0700 (PDT)
From:   Yuya Kusakabe <yuya.kusakabe@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, Yuya Kusakabe <yuya.kusakabe@gmail.com>
Subject: [PATCH bpf-next] virtio_net: add XDP meta data support in receive_small()
Date:   Thu, 27 Jun 2019 11:33:32 +0900
Message-Id: <20190627023332.8557-1-yuya.kusakabe@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds XDP meta data support to the code path receive_small().

mrg_rxbuf=off is required on qemu, because receive_mergeable() still
doesn't support XDP meta data.

Fixes: de8f3a83b0a0 ("bpf: add meta pointer for direct access")
Signed-off-by: Yuya Kusakabe <yuya.kusakabe@gmail.com>
---
 drivers/net/virtio_net.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 4f3de0ac8b0b..14165c5edb7d 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -644,6 +644,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
 	unsigned int delta = 0;
 	struct page *xdp_page;
 	int err;
+	unsigned int metasize = 0;
 
 	len -= vi->hdr_len;
 	stats->bytes += len;
@@ -683,8 +684,8 @@ static struct sk_buff *receive_small(struct net_device *dev,
 
 		xdp.data_hard_start = buf + VIRTNET_RX_PAD + vi->hdr_len;
 		xdp.data = xdp.data_hard_start + xdp_headroom;
-		xdp_set_data_meta_invalid(&xdp);
 		xdp.data_end = xdp.data + len;
+		xdp.data_meta = xdp.data;
 		xdp.rxq = &rq->xdp_rxq;
 		orig_data = xdp.data;
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
@@ -695,9 +696,11 @@ static struct sk_buff *receive_small(struct net_device *dev,
 			/* Recalculate length in case bpf program changed it */
 			delta = orig_data - xdp.data;
 			len = xdp.data_end - xdp.data;
+			metasize = xdp.data - xdp.data_meta;
 			break;
 		case XDP_TX:
 			stats->xdp_tx++;
+			xdp.data_meta = xdp.data;
 			xdpf = convert_to_xdp_frame(&xdp);
 			if (unlikely(!xdpf))
 				goto err_xdp;
@@ -735,11 +738,14 @@ static struct sk_buff *receive_small(struct net_device *dev,
 	}
 	skb_reserve(skb, headroom - delta);
 	skb_put(skb, len);
-	if (!delta) {
+	if (!delta && !metasize) {
 		buf += header_offset;
 		memcpy(skb_vnet_hdr(skb), buf, vi->hdr_len);
 	} /* keep zeroed vnet hdr since packet was changed by bpf */
 
+	if (metasize)
+		skb_metadata_set(skb, metasize);
+
 err:
 	return skb;
 
-- 
2.20.1


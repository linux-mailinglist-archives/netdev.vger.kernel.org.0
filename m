Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B21E65223A
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 15:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233892AbiLTOPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 09:15:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233857AbiLTOPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 09:15:04 -0500
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC997E4F;
        Tue, 20 Dec 2022 06:15:02 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VXlgNFe_1671545699;
Received: from localhost(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VXlgNFe_1671545699)
          by smtp.aliyun-inc.com;
          Tue, 20 Dec 2022 22:15:00 +0800
From:   Heng Qi <hengqi@linux.alibaba.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: [PATCH v2 9/9] virtio_net: support multi-buffer xdp
Date:   Tue, 20 Dec 2022 22:14:49 +0800
Message-Id: <20221220141449.115918-10-hengqi@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20221220141449.115918-1-hengqi@linux.alibaba.com>
References: <20221220141449.115918-1-hengqi@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Driver can pass the skb to stack by build_skb_from_xdp_buff().

Driver forwards multi-buffer packets using the send queue
when XDP_TX and XDP_REDIRECT, and clears the reference of multi
pages when XDP_DROP.

Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 65 ++++++----------------------------------
 1 file changed, 9 insertions(+), 56 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 398ffe2a5084..daa380b9d1cc 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1074,7 +1074,6 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	struct bpf_prog *xdp_prog;
 	unsigned int truesize = mergeable_ctx_to_truesize(ctx);
 	unsigned int headroom = mergeable_ctx_to_headroom(ctx);
-	unsigned int metasize = 0;
 	unsigned int frame_sz;
 	int err;
 
@@ -1165,63 +1164,22 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 
 		switch (act) {
 		case XDP_PASS:
-			metasize = xdp.data - xdp.data_meta;
-
-			/* recalculate offset to account for any header
-			 * adjustments and minus the metasize to copy the
-			 * metadata in page_to_skb(). Note other cases do not
-			 * build an skb and avoid using offset
-			 */
-			offset = xdp.data - page_address(xdp_page) -
-				 vi->hdr_len - metasize;
-
-			/* recalculate len if xdp.data, xdp.data_end or
-			 * xdp.data_meta were adjusted
-			 */
-			len = xdp.data_end - xdp.data + vi->hdr_len + metasize;
-
-			/* recalculate headroom if xdp.data or xdp_data_meta
-			 * were adjusted, note that offset should always point
-			 * to the start of the reserved bytes for virtio_net
-			 * header which are followed by xdp.data, that means
-			 * that offset is equal to the headroom (when buf is
-			 * starting at the beginning of the page, otherwise
-			 * there is a base offset inside the page) but it's used
-			 * with a different starting point (buf start) than
-			 * xdp.data (buf start + vnet hdr size). If xdp.data or
-			 * data_meta were adjusted by the xdp prog then the
-			 * headroom size has changed and so has the offset, we
-			 * can use data_hard_start, which points at buf start +
-			 * vnet hdr size, to calculate the new headroom and use
-			 * it later to compute buf start in page_to_skb()
-			 */
-			headroom = xdp.data - xdp.data_hard_start - metasize;
-
-			/* We can only create skb based on xdp_page. */
-			if (unlikely(xdp_page != page)) {
-				rcu_read_unlock();
-				put_page(page);
-				head_skb = page_to_skb(vi, rq, xdp_page, offset,
-						       len, PAGE_SIZE);
-				return head_skb;
-			}
-			break;
+			head_skb = build_skb_from_xdp_buff(dev, vi, &xdp, xdp_frags_truesz);
+			rcu_read_unlock();
+			return head_skb;
 		case XDP_TX:
 			stats->xdp_tx++;
 			xdpf = xdp_convert_buff_to_frame(&xdp);
 			if (unlikely(!xdpf)) {
-				if (unlikely(xdp_page != page))
-					put_page(xdp_page);
-				goto err_xdp;
+				netdev_dbg(dev, "convert buff to frame failed for xdp\n");
+				goto err_xdp_frags;
 			}
 			err = virtnet_xdp_xmit(dev, 1, &xdpf, 0);
 			if (unlikely(!err)) {
 				xdp_return_frame_rx_napi(xdpf);
 			} else if (unlikely(err < 0)) {
 				trace_xdp_exception(vi->dev, xdp_prog, act);
-				if (unlikely(xdp_page != page))
-					put_page(xdp_page);
-				goto err_xdp;
+				goto err_xdp_frags;
 			}
 			*xdp_xmit |= VIRTIO_XDP_TX;
 			if (unlikely(xdp_page != page))
@@ -1231,11 +1189,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		case XDP_REDIRECT:
 			stats->xdp_redirects++;
 			err = xdp_do_redirect(dev, &xdp, xdp_prog);
-			if (err) {
-				if (unlikely(xdp_page != page))
-					put_page(xdp_page);
-				goto err_xdp;
-			}
+			if (err)
+				goto err_xdp_frags;
 			*xdp_xmit |= VIRTIO_XDP_REDIR;
 			if (unlikely(xdp_page != page))
 				put_page(page);
@@ -1248,9 +1203,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 			trace_xdp_exception(vi->dev, xdp_prog, act);
 			fallthrough;
 		case XDP_DROP:
-			if (unlikely(xdp_page != page))
-				__free_pages(xdp_page, 0);
-			goto err_xdp;
+			goto err_xdp_frags;
 		}
 err_xdp_frags:
 		shinfo = xdp_get_shared_info_from_buff(&xdp);
-- 
2.19.1.6.gb485710b


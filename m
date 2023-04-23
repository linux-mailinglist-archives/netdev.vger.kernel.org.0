Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57C436EBEE8
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 12:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbjDWK6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 06:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjDWK56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 06:57:58 -0400
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFAC510E6;
        Sun, 23 Apr 2023 03:57:50 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VgjhMFI_1682247465;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VgjhMFI_1682247465)
          by smtp.aliyun-inc.com;
          Sun, 23 Apr 2023 18:57:46 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: [PATCH net-next v3 07/15] virtio_net: auto release xdp shinfo
Date:   Sun, 23 Apr 2023 18:57:28 +0800
Message-Id: <20230423105736.56918-8-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20230423105736.56918-1-xuanzhuo@linux.alibaba.com>
References: <20230423105736.56918-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: 3bb17d92efad
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

virtnet_build_xdp_buff_mrg() and virtnet_xdp_handler() auto
release xdp shinfo then the caller no need to careful the xdp shinfo.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 5f37a1cef61e..c6bf425e8844 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -825,7 +825,7 @@ static int virtnet_xdp_handler(struct bpf_prog *xdp_prog, struct xdp_buff *xdp,
 		xdpf = xdp_convert_buff_to_frame(xdp);
 		if (unlikely(!xdpf)) {
 			netdev_dbg(dev, "convert buff to frame failed for xdp\n");
-			return XDP_DROP;
+			goto drop;
 		}
 
 		err = virtnet_xdp_xmit(dev, 1, &xdpf, 0);
@@ -833,7 +833,7 @@ static int virtnet_xdp_handler(struct bpf_prog *xdp_prog, struct xdp_buff *xdp,
 			xdp_return_frame_rx_napi(xdpf);
 		} else if (unlikely(err < 0)) {
 			trace_xdp_exception(dev, xdp_prog, act);
-			return XDP_DROP;
+			goto drop;
 		}
 		*xdp_xmit |= VIRTIO_XDP_TX;
 		return act;
@@ -842,7 +842,7 @@ static int virtnet_xdp_handler(struct bpf_prog *xdp_prog, struct xdp_buff *xdp,
 		stats->xdp_redirects++;
 		err = xdp_do_redirect(dev, xdp, xdp_prog);
 		if (err)
-			return XDP_DROP;
+			goto drop;
 
 		*xdp_xmit |= VIRTIO_XDP_REDIR;
 		return act;
@@ -854,8 +854,12 @@ static int virtnet_xdp_handler(struct bpf_prog *xdp_prog, struct xdp_buff *xdp,
 		trace_xdp_exception(dev, xdp_prog, act);
 		fallthrough;
 	case XDP_DROP:
-		return XDP_DROP;
+		break;
 	}
+
+drop:
+	put_xdp_frags(xdp);
+	return XDP_DROP;
 }
 
 static unsigned int virtnet_get_headroom(struct virtnet_info *vi)
@@ -1190,7 +1194,7 @@ static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
 				 dev->name, *num_buf,
 				 virtio16_to_cpu(vi->vdev, hdr->num_buffers));
 			dev->stats.rx_length_errors++;
-			return -EINVAL;
+			goto err;
 		}
 
 		stats->bytes += len;
@@ -1209,7 +1213,7 @@ static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
 			pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
 				 dev->name, len, (unsigned long)(truesize - room));
 			dev->stats.rx_length_errors++;
-			return -EINVAL;
+			goto err;
 		}
 
 		frag = &shinfo->frags[shinfo->nr_frags++];
@@ -1224,6 +1228,10 @@ static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
 
 	*xdp_frags_truesize = xdp_frags_truesz;
 	return 0;
+
+err:
+	put_xdp_frags(xdp);
+	return -EINVAL;
 }
 
 static void *mergeable_xdp_get_buf(struct virtnet_info *vi,
@@ -1353,7 +1361,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		err = virtnet_build_xdp_buff_mrg(dev, vi, rq, &xdp, data, len, frame_sz,
 						 &num_buf, &xdp_frags_truesz, stats);
 		if (unlikely(err))
-			goto err_xdp_frags;
+			goto err_xdp;
 
 		act = virtnet_xdp_handler(xdp_prog, &xdp, dev, xdp_xmit, stats);
 
@@ -1361,7 +1369,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		case XDP_PASS:
 			head_skb = build_skb_from_xdp_buff(dev, vi, &xdp, xdp_frags_truesz);
 			if (unlikely(!head_skb))
-				goto err_xdp_frags;
+				goto err_xdp;
 
 			rcu_read_unlock();
 			return head_skb;
@@ -1370,11 +1378,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 			rcu_read_unlock();
 			goto xdp_xmit;
 		default:
-			break;
+			goto err_xdp;
 		}
-err_xdp_frags:
-		put_xdp_frags(&xdp);
-		goto err_xdp;
 	}
 	rcu_read_unlock();
 
-- 
2.32.0.3.g01195cf9f


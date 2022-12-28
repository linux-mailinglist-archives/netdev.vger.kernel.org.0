Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28FE86573DF
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 09:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiL1IXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 03:23:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiL1IXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 03:23:08 -0500
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB40E24;
        Wed, 28 Dec 2022 00:23:06 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R821e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VYGgrWv_1672215781;
Received: from localhost(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VYGgrWv_1672215781)
          by smtp.aliyun-inc.com;
          Wed, 28 Dec 2022 16:23:02 +0800
Date:   Wed, 28 Dec 2022 16:23:01 +0800
From:   Heng Qi <hengqi@linux.alibaba.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v2 5/9] virtio_net: construct multi-buffer xdp in
 mergeable
Message-ID: <20221228082301.GA18313@h68b04307.sqa.eu95>
References: <20221220141449.115918-1-hengqi@linux.alibaba.com>
 <20221220141449.115918-6-hengqi@linux.alibaba.com>
 <5a03364e-c09e-63ff-7e73-1efec1ed8ca8@redhat.com>
 <83dc59b1-99f6-58fe-56b5-de5158bcc3cd@linux.alibaba.com>
 <bfc3f1d0-b656-8d2b-c85d-f20a23f2e976@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bfc3f1d0-b656-8d2b-c85d-f20a23f2e976@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 28, 2022 at 02:24:22PM +0800, Jason Wang wrote:
> 
> 在 2022/12/27 17:31, Heng Qi 写道:
> >
> >
> >在 2022/12/27 下午3:01, Jason Wang 写道:
> >>
> >>在 2022/12/20 22:14, Heng Qi 写道:
> >>>Build multi-buffer xdp using virtnet_build_xdp_buff_mrg().
> >>>
> >>>For the prefilled buffer before xdp is set, we will probably use
> >>>vq reset in the future. At the same time, virtio net currently
> >>>uses comp pages, and bpf_xdp_frags_increase_tail() needs to calculate
> >>>the tailroom of the last frag, which will involve the offset of the
> >>>corresponding page and cause a negative value, so we disable tail
> >>>increase by not setting xdp_rxq->frag_size.
> >>>
> >>>Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
> >>>Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> >>>---
> >>>  drivers/net/virtio_net.c | 60
> >>>+++++++++++++++++++++++++++++-----------
> >>>  1 file changed, 44 insertions(+), 16 deletions(-)
> >>>
> >>>diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> >>>index 8fc3b1841d92..40bc58fa57f5 100644
> >>>--- a/drivers/net/virtio_net.c
> >>>+++ b/drivers/net/virtio_net.c
> >>>@@ -1018,6 +1018,7 @@ static struct sk_buff
> >>>*receive_mergeable(struct net_device *dev,
> >>>                       unsigned int *xdp_xmit,
> >>>                       struct virtnet_rq_stats *stats)
> >>>  {
> >>>+    unsigned int tailroom = SKB_DATA_ALIGN(sizeof(struct
> >>>skb_shared_info));
> >>>      struct virtio_net_hdr_mrg_rxbuf *hdr = buf;
> >>>      u16 num_buf = virtio16_to_cpu(vi->vdev, hdr->num_buffers);
> >>>      struct page *page = virt_to_head_page(buf);
> >>>@@ -1048,11 +1049,14 @@ static struct sk_buff
> >>>*receive_mergeable(struct net_device *dev,
> >>>      rcu_read_lock();
> >>>      xdp_prog = rcu_dereference(rq->xdp_prog);
> >>>      if (xdp_prog) {
> >>>+        unsigned int xdp_frags_truesz = 0;
> >>>+        struct skb_shared_info *shinfo;
> >>>          struct xdp_frame *xdpf;
> >>>          struct page *xdp_page;
> >>>          struct xdp_buff xdp;
> >>>          void *data;
> >>>          u32 act;
> >>>+        int i;
> >>>            /* Transient failure which in theory could occur if
> >>>           * in-flight packets from before XDP was enabled reach
> >>>@@ -1061,19 +1065,23 @@ static struct sk_buff
> >>>*receive_mergeable(struct net_device *dev,
> >>>          if (unlikely(hdr->hdr.gso_type))
> >>>              goto err_xdp;
> >>>  -        /* Buffers with headroom use PAGE_SIZE as alloc size,
> >>>-         * see add_recvbuf_mergeable() + get_mergeable_buf_len()
> >>>+        /* Now XDP core assumes frag size is PAGE_SIZE, but buffers
> >>>+         * with headroom may add hole in truesize, which
> >>>+         * make their length exceed PAGE_SIZE. So we disabled the
> >>>+         * hole mechanism for xdp. See add_recvbuf_mergeable().
> >>>           */
> >>>          frame_sz = headroom ? PAGE_SIZE : truesize;
> >>>  -        /* This happens when rx buffer size is underestimated
> >>>-         * or headroom is not enough because of the buffer
> >>>-         * was refilled before XDP is set. This should only
> >>>-         * happen for the first several packets, so we don't
> >>>-         * care much about its performance.
> >>>+        /* This happens when headroom is not enough because
> >>>+         * of the buffer was prefilled before XDP is set.
> >>>+         * This should only happen for the first several packets.
> >>>+         * In fact, vq reset can be used here to help us clean up
> >>>+         * the prefilled buffers, but many existing devices do not
> >>>+         * support it, and we don't want to bother users who are
> >>>+         * using xdp normally.
> >>>           */
> >>>-        if (unlikely(num_buf > 1 ||
> >>>-                 headroom < virtnet_get_headroom(vi))) {
> >>>+        if (!xdp_prog->aux->xdp_has_frags &&
> >>>+            (num_buf > 1 || headroom < virtnet_get_headroom(vi))) {
> >>>              /* linearize data for XDP */
> >>>              xdp_page = xdp_linearize_page(rq, &num_buf,
> >>>                                page, offset,
> >>>@@ -1084,17 +1092,26 @@ static struct sk_buff
> >>>*receive_mergeable(struct net_device *dev,
> >>>              if (!xdp_page)
> >>>                  goto err_xdp;
> >>>              offset = VIRTIO_XDP_HEADROOM;
> >>>+        } else if (unlikely(headroom < virtnet_get_headroom(vi))) {
> >>
> >>
> >>I believe we need to check xdp_prog->aux->xdp_has_frags at least
> >>since this may not work if it needs more than one frags?
> >
> >Sorry Jason, I didn't understand you, I'll try to answer. For
> >multi-buffer xdp programs, if the first buffer is a pre-filled
> >buffer (no headroom),
> >we need to copy it out and use the subsequent buffers of this
> >packet as its frags (this is done in
> >virtnet_build_xdp_buff_mrg()), therefore,
> >it seems that there is no need to check
> >'xdp_prog->aux->xdp_has_frags' to mark multi-buffer xdp (of course
> >I can add it),
> >
> >+ } else if (unlikely(headroom < virtnet_get_headroom(vi))) {
> >
> >Because the linearization of single-buffer xdp has all been done
> >before, the subsequent situation can only be applied to
> >multi-buffer xdp:
> >+ if (!xdp_prog->aux->xdp_has_frags &&
> >+ (num_buf > 1 || headroom < virtnet_get_headroom(vi))) {
> 
> 
> I basically meant what happens if
> 
> !xdp_prog->aux->xdp_has_frags && num_buf > 2 && headroom <
> virtnet_get_headroom(vi)
> 
> In this case the current code seems to leave the second buffer in
> the frags. This is the case of the buffer size underestimation that
> is mentioned in the comment before (I'd like to keep that).

If I'm not wrong, this case is still directly into the first 'if' loop.

-               if (unlikely(num_buf > 1 ||
-                            headroom < virtnet_get_headroom(vi))) {
+               if (!xdp_prog->aux->xdp_has_frags &&
+                   (num_buf > 1 || headroom < virtnet_get_headroom(vi))) {

Thanks.

> 
> (And that's why I'm asking to use linearizge_page())
> 
> Thanks
> 
> 
> >
> >>
> >>Btw, I don't see a reason why we can't reuse
> >>xdp_linearize_page(), (we probably don't need error is the
> >>buffer exceeds PAGE_SIZE).
> >
> >For multi-buffer xdp, we only need to copy out the pre-filled
> >first buffer, and use the remaining buffers of this packet as
> >frags in virtnet_build_xdp_buff_mrg().
> >
> >Thanks.
> >
> >>
> >>Other looks good.
> >>
> >>Thanks
> >>
> >>
> >>>+            if ((VIRTIO_XDP_HEADROOM + len + tailroom) > PAGE_SIZE)
> >>>+                goto err_xdp;
> >>>+
> >>>+            xdp_page = alloc_page(GFP_ATOMIC);
> >>>+            if (!xdp_page)
> >>>+                goto err_xdp;
> >>>+
> >>>+            memcpy(page_address(xdp_page) + VIRTIO_XDP_HEADROOM,
> >>>+                   page_address(page) + offset, len);
> >>>+            frame_sz = PAGE_SIZE;
> >>>+            offset = VIRTIO_XDP_HEADROOM;
> >>>          } else {
> >>>              xdp_page = page;
> >>>          }
> >>>-
> >>>-        /* Allow consuming headroom but reserve enough space to push
> >>>-         * the descriptor on if we get an XDP_TX return code.
> >>>-         */
> >>>          data = page_address(xdp_page) + offset;
> >>>-        xdp_init_buff(&xdp, frame_sz - vi->hdr_len, &rq->xdp_rxq);
> >>>-        xdp_prepare_buff(&xdp, data - VIRTIO_XDP_HEADROOM +
> >>>vi->hdr_len,
> >>>-                 VIRTIO_XDP_HEADROOM, len - vi->hdr_len, true);
> >>>+        err = virtnet_build_xdp_buff_mrg(dev, vi, rq, &xdp,
> >>>data, len, frame_sz,
> >>>+                         &num_buf, &xdp_frags_truesz, stats);
> >>>+        if (unlikely(err))
> >>>+            goto err_xdp_frags;
> >>>            act = bpf_prog_run_xdp(xdp_prog, &xdp);
> >>>          stats->xdp_packets++;
> >>>@@ -1190,6 +1207,17 @@ static struct sk_buff
> >>>*receive_mergeable(struct net_device *dev,
> >>>                  __free_pages(xdp_page, 0);
> >>>              goto err_xdp;
> >>>          }
> >>>+err_xdp_frags:
> >>>+        shinfo = xdp_get_shared_info_from_buff(&xdp);
> >>>+
> >>>+        if (unlikely(xdp_page != page))
> >>>+            __free_pages(xdp_page, 0);
> >>>+
> >>>+        for (i = 0; i < shinfo->nr_frags; i++) {
> >>>+            xdp_page = skb_frag_page(&shinfo->frags[i]);
> >>>+            put_page(xdp_page);
> >>>+        }
> >>>+        goto err_xdp;
> >>>      }
> >>>      rcu_read_unlock();
> >

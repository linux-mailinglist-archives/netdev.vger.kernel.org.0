Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F11C646A8F
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 09:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbiLHIbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 03:31:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiLHIbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 03:31:09 -0500
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFEB061507;
        Thu,  8 Dec 2022 00:31:07 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=hengqi@linux.alibaba.com;NM=0;PH=DS;RN=11;SR=0;TI=SMTPD_---0VWpWPoe_1670488203;
Received: from 30.221.147.145(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VWpWPoe_1670488203)
          by smtp.aliyun-inc.com;
          Thu, 08 Dec 2022 16:31:05 +0800
Message-ID: <8b3589ad-d071-fe07-268f-8eaa97e25f2c@linux.alibaba.com>
Date:   Thu, 8 Dec 2022 16:31:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:108.0)
 Gecko/20100101 Thunderbird/108.0
Subject: Re: [RFC PATCH 9/9] virtio_net: support multi-buffer xdp
To:     Jason Wang <jasowang@redhat.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>
References: <20221122074348.88601-1-hengqi@linux.alibaba.com>
 <20221122074348.88601-10-hengqi@linux.alibaba.com>
 <CACGkMEsd75VYCeSSQo_H6+0reNxQsAMSamNr-_k3ndJ-ToJHHQ@mail.gmail.com>
From:   Heng Qi <hengqi@linux.alibaba.com>
In-Reply-To: <CACGkMEsd75VYCeSSQo_H6+0reNxQsAMSamNr-_k3ndJ-ToJHHQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-10.2 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/12/6 下午2:42, Jason Wang 写道:
> On Tue, Nov 22, 2022 at 3:44 PM Heng Qi <hengqi@linux.alibaba.com> wrote:
>> Driver can pass the skb to stack by build_skb_from_xdp_buff().
>>
>> Driver forwards multi-buffer packets using the send queue
>> when XDP_TX and XDP_REDIRECT, and clears the reference of multi
>> pages when XDP_DROP.
>>
>> Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
>> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>> ---
>>   drivers/net/virtio_net.c | 65 ++++++----------------------------------
>>   1 file changed, 9 insertions(+), 56 deletions(-)
>>
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> index 431f2126a2b5..bbd5cd9bfd47 100644
>> --- a/drivers/net/virtio_net.c
>> +++ b/drivers/net/virtio_net.c
>> @@ -1065,7 +1065,6 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>>          struct bpf_prog *xdp_prog;
>>          unsigned int truesize = mergeable_ctx_to_truesize(ctx);
>>          unsigned int headroom = mergeable_ctx_to_headroom(ctx);
>> -       unsigned int metasize = 0;
>>          unsigned int frame_sz;
>>          int err;
>>
>> @@ -1137,63 +1136,22 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>>
>>                  switch (act) {
>>                  case XDP_PASS:
>> -                       metasize = xdp.data - xdp.data_meta;
>> -
>> -                       /* recalculate offset to account for any header
>> -                        * adjustments and minus the metasize to copy the
>> -                        * metadata in page_to_skb(). Note other cases do not
>> -                        * build an skb and avoid using offset
>> -                        */
>> -                       offset = xdp.data - page_address(xdp_page) -
>> -                                vi->hdr_len - metasize;
>> -
>> -                       /* recalculate len if xdp.data, xdp.data_end or
>> -                        * xdp.data_meta were adjusted
>> -                        */
>> -                       len = xdp.data_end - xdp.data + vi->hdr_len + metasize;
>> -
>> -                       /* recalculate headroom if xdp.data or xdp_data_meta
>> -                        * were adjusted, note that offset should always point
>> -                        * to the start of the reserved bytes for virtio_net
>> -                        * header which are followed by xdp.data, that means
>> -                        * that offset is equal to the headroom (when buf is
>> -                        * starting at the beginning of the page, otherwise
>> -                        * there is a base offset inside the page) but it's used
>> -                        * with a different starting point (buf start) than
>> -                        * xdp.data (buf start + vnet hdr size). If xdp.data or
>> -                        * data_meta were adjusted by the xdp prog then the
>> -                        * headroom size has changed and so has the offset, we
>> -                        * can use data_hard_start, which points at buf start +
>> -                        * vnet hdr size, to calculate the new headroom and use
>> -                        * it later to compute buf start in page_to_skb()
>> -                        */
>> -                       headroom = xdp.data - xdp.data_hard_start - metasize;
>> -
>> -                       /* We can only create skb based on xdp_page. */
>> -                       if (unlikely(xdp_page != page)) {
>> -                               rcu_read_unlock();
>> -                               put_page(page);
>> -                               head_skb = page_to_skb(vi, rq, xdp_page, offset,
>> -                                                      len, PAGE_SIZE);
>> -                               return head_skb;
>> -                       }
>> -                       break;
>> +                       head_skb = build_skb_from_xdp_buff(dev, vi, &xdp, xdp_frags_truesz);
>> +                       rcu_read_unlock();
>> +                       return head_skb;
>>                  case XDP_TX:
>>                          stats->xdp_tx++;
>>                          xdpf = xdp_convert_buff_to_frame(&xdp);
>>                          if (unlikely(!xdpf)) {
>> -                               if (unlikely(xdp_page != page))
>> -                                       put_page(xdp_page);
>> -                               goto err_xdp;
>> +                               pr_debug("%s: convert buff to frame failed for xdp\n", dev->name);
> netdev_dbg()?

Yes, I will fix it in the next version.

Thanks.

>
> Thanks
>
>> +                               goto err_xdp_frags;
>>                          }
>>                          err = virtnet_xdp_xmit(dev, 1, &xdpf, 0);
>>                          if (unlikely(!err)) {
>>                                  xdp_return_frame_rx_napi(xdpf);
>>                          } else if (unlikely(err < 0)) {
>>                                  trace_xdp_exception(vi->dev, xdp_prog, act);
>> -                               if (unlikely(xdp_page != page))
>> -                                       put_page(xdp_page);
>> -                               goto err_xdp;
>> +                               goto err_xdp_frags;
>>                          }
>>                          *xdp_xmit |= VIRTIO_XDP_TX;
>>                          if (unlikely(xdp_page != page))
>> @@ -1203,11 +1161,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>>                  case XDP_REDIRECT:
>>                          stats->xdp_redirects++;
>>                          err = xdp_do_redirect(dev, &xdp, xdp_prog);
>> -                       if (err) {
>> -                               if (unlikely(xdp_page != page))
>> -                                       put_page(xdp_page);
>> -                               goto err_xdp;
>> -                       }
>> +                       if (err)
>> +                               goto err_xdp_frags;
>>                          *xdp_xmit |= VIRTIO_XDP_REDIR;
>>                          if (unlikely(xdp_page != page))
>>                                  put_page(page);
>> @@ -1220,9 +1175,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>>                          trace_xdp_exception(vi->dev, xdp_prog, act);
>>                          fallthrough;
>>                  case XDP_DROP:
>> -                       if (unlikely(xdp_page != page))
>> -                               __free_pages(xdp_page, 0);
>> -                       goto err_xdp;
>> +                       goto err_xdp_frags;
>>                  }
>>   err_xdp_frags:
>>                  shinfo = xdp_get_shared_info_from_buff(&xdp);
>> --
>> 2.19.1.6.gb485710b
>>


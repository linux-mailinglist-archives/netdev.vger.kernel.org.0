Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2801232EF4
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 10:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729051AbgG3Ixa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 04:53:30 -0400
Received: from mail-proxy25223.qiye.163.com ([103.129.252.23]:14438 "EHLO
        mail-proxy25223.qiye.163.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726273AbgG3Ixa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 04:53:30 -0400
Received: from [192.168.188.14] (unknown [106.75.220.2])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 1324C5C1784;
        Thu, 30 Jul 2020 16:53:27 +0800 (CST)
Subject: Re: [PATCH net] net/sched: act_ct: fix miss set mru for ovs after
 defrag in act_ct
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <1596019270-7437-1-git-send-email-wenxu@ucloud.cn>
 <CAM_iQpX89EE+zAc_hR9f=mw1bew5cMVMp1sC7i_fryUjegshnA@mail.gmail.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <12ad0f21-a689-b889-237a-6441c3d0a194@ucloud.cn>
Date:   Thu, 30 Jul 2020 16:53:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpX89EE+zAc_hR9f=mw1bew5cMVMp1sC7i_fryUjegshnA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZTBkeQ08YTxoaHUpMVkpOQk1LQkJJS0xJSUxVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVKS0tZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NDY6FAw6Qj5JETccMjchMxNN
        DiowC0hVSlVKTkJNS0JCSUtMT0pCVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLTVVM
        TlVJSUtVSVlXWQgBWUFPQ09MNwY+
X-HM-Tid: 0a739eed1fdf2087kuqy1324c5c1784
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/30/2020 2:03 PM, Cong Wang wrote:
> On Wed, Jul 29, 2020 at 3:41 AM <wenxu@ucloud.cn> wrote:
>> diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
>> index c510b03..45401d5 100644
>> --- a/include/net/sch_generic.h
>> +++ b/include/net/sch_generic.h
>> @@ -384,6 +384,7 @@ struct qdisc_skb_cb {
>>         };
>>  #define QDISC_CB_PRIV_LEN 20
>>         unsigned char           data[QDISC_CB_PRIV_LEN];
>> +       u16                     mru;
>>  };
> Hmm, can you put it in the anonymous struct before 'data'?
>
> We validate this cb size and data size like blow:
>
> static inline void qdisc_cb_private_validate(const struct sk_buff *skb, int sz)
> {
>         struct qdisc_skb_cb *qcb;
>
>         BUILD_BUG_ON(sizeof(skb->cb) < offsetof(struct qdisc_skb_cb,
> data) + sz);
>         BUILD_BUG_ON(sizeof(qcb->data) < sz);
> }
>
> It _kinda_ expects ->data at the end.

It seems the data offsetof data should be align with szieof(u64)?

If I  modify it as following

@@ -383,6 +383,9 @@ struct qdisc_skb_cb {
                unsigned int            pkt_len;
                u16                     slave_dev_queue_mapping;
                u16                     tc_classid;
+               u16                     mru;
        };
 #define QDISC_CB_PRIV_LEN 20
        unsigned char           data[QDISC_CB_PRIV_LEN];

compile fail:

net/core/filter.c:7625:3: note: in expansion of macro ‘BUILD_BUG_ON’
   BUILD_BUG_ON((offsetof(struct sk_buff, cb) +

inn the file:  net/core/filter.c

case offsetof(struct __sk_buff, cb[0]) ...

             offsetofend(struct __sk_buff, cb[4]) - 1:
                BUILD_BUG_ON(sizeof_field(struct qdisc_skb_cb, data) < 20);
                BUILD_BUG_ON((offsetof(struct sk_buff, cb) +
                              offsetof(struct qdisc_skb_cb, data)) %
                             sizeof(__u64));


If I  modify it as following

@@ -383,6 +383,9 @@ struct qdisc_skb_cb {
                unsigned int            pkt_len;
                u16                     slave_dev_queue_mapping;
                u16                     tc_classid;
+               u16                     mru;
+               u16                     _pad1;
+               u32                     _pad2;
        };
 #define QDISC_CB_PRIV_LEN 20
        unsigned char           data[QDISC_CB_PRIV_LEN];


compile fail:

./include/linux/filter.h:633:2: note: in expansion of macro ‘BUILD_BUG_ON’
  BUILD_BUG_ON(sizeof(*cb) > sizeof_field(struct sk_buff, cb));


static inline void bpf_compute_data_pointers(struct sk_buff *skb)
{
        struct bpf_skb_data_end *cb = (struct bpf_skb_data_end *)skb->cb;

        BUILD_BUG_ON(sizeof(*cb) > sizeof_field(struct sk_buff, cb));
        cb->data_meta = skb->data - skb_metadata_len(skb);
        cb->data_end  = skb->data + skb_headlen(skb);
}


It seems no space for new value add before 'data'?


BR

wenxu



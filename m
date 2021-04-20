Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC6A365567
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 11:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbhDTJbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 05:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbhDTJbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 05:31:34 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE84C06174A
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 02:31:02 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id n4-20020a05600c4f84b029013151278decso8355060wmq.4
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 02:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3eMeySocPdmCCpHyXNhX2uxxdNhE7kYSZAhLehXPS/w=;
        b=QKSjtgliU0PzwkoWT+pgYQwzcGOp5lneWROcslOFl2TbbvIZytKmGvatfC35el/JDN
         ZuLIto33aZJ6n07UcOM5dtPIKOa9d+YSUJ8HovIBBrZLXBczpZzbZc97J4k2YxXBxu4B
         r4XF/4ekO95nJEDpuNgxNgd+fypyEBbIk8fQ2oXdSCzOVMYuEWQNu67SXYC/N/ZcZSn3
         TJSD8QN23muXWTgo8RytFBZVfnADiLhwHnn8W94+kLLUzxaLAtI27hJMcDOXIP8hHxsy
         Zjkp/TI5VOnM+cHfRt+07bUz8EruEcqZ4ORuHmYfw1hqv0lwIqTrjrB7nssc2A5Voo/H
         do5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3eMeySocPdmCCpHyXNhX2uxxdNhE7kYSZAhLehXPS/w=;
        b=mm8AySti62VVTdoN/UdCEy0ArSP8VKMT052trtjiS5nVSSu10r2notaLoRRDEeS9jJ
         kNDpJX9t6jJU6RJ7qdZk6/KwfOyHCQnNwJ+zBV4g2M18Ca4NZyD26knu2wZGJXiwixXr
         EjZbQN9vb7wbpY4/9SoHnjd07jxkmITTBXvPt17Qc6QIvq4X1iSXtk+oFmemWz9oqFv1
         sBIMzovWzHgP70ael8UcLYhphwZ5chCwToOBrOKUnuyjD7S7lGKf4QZWegqn1mp31cxX
         hdNM4vVF7KbiJznrhJrfxp7keAhEfIfki7oarTdEKScKjzfE4g0j9SgqLEhk8UfOln1E
         btvw==
X-Gm-Message-State: AOAM531c1P+yIc9ENLZhAUXthYxUW/b4SCdUmLSLC1LxCwB+GwD9PVl2
        2fWTSV3W8hwkeVPNc/I6Fh8=
X-Google-Smtp-Source: ABdhPJzral342IkT/x7imIvqKH1TaTtjY+p6qcO5oadQfemYtW5jskGnAUjVUsVGqa8+qFP7KCgq/g==
X-Received: by 2002:a1c:2785:: with SMTP id n127mr3462010wmn.52.1618911061527;
        Tue, 20 Apr 2021 02:31:01 -0700 (PDT)
Received: from [192.168.156.98] (114.199.23.93.rev.sfr.net. [93.23.199.114])
        by smtp.gmail.com with ESMTPSA id l13sm2604369wmj.3.2021.04.20.02.31.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 02:31:00 -0700 (PDT)
Subject: Re: [net-next, v2] virtio-net: page_to_skb() use build_skb when
 there's sufficient tailroom
To:     Guenter Roeck <linux@roeck-us.net>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org
References: <20210414015221.87554-1-xuanzhuo@linux.alibaba.com>
 <20210420044655.GA144160@roeck-us.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <0948122e-5698-ad09-7a00-558d0b5b12ab@gmail.com>
Date:   Tue, 20 Apr 2021 11:30:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210420044655.GA144160@roeck-us.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/20/21 6:46 AM, Guenter Roeck wrote:
> On Wed, Apr 14, 2021 at 09:52:21AM +0800, Xuan Zhuo wrote:
>> In page_to_skb(), if we have enough tailroom to save skb_shared_info, we
>> can use build_skb to create skb directly. No need to alloc for
>> additional space. And it can save a 'frags slot', which is very friendly
>> to GRO.
>>
>> Here, if the payload of the received package is too small (less than
>> GOOD_COPY_LEN), we still choose to copy it directly to the space got by
>> napi_alloc_skb. So we can reuse these pages.
>>
>> Testing Machine:
>>     The four queues of the network card are bound to the cpu1.
>>
>> Test command:
>>     for ((i=0;i<5;++i)); do sockperf tp --ip 192.168.122.64 -m 1000 -t 150& done
>>
>> The size of the udp package is 1000, so in the case of this patch, there
>> will always be enough tailroom to use build_skb. The sent udp packet
>> will be discarded because there is no port to receive it. The irqsoftd
>> of the machine is 100%, we observe the received quantity displayed by
>> sar -n DEV 1:
>>
>> no build_skb:  956864.00 rxpck/s
>> build_skb:    1158465.00 rxpck/s
>>
>> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>> Suggested-by: Jason Wang <jasowang@redhat.com>
> 
> Booting qemu-system-alpha with virtio-net interface instantiated results in:
> 
> udhcpc: sending discover
> Unable to handle kernel paging request at virtual address 0000000000000004
> udhcpc(169): Oops -1
> pc = [<0000000000000004>]  ra = [<fffffc0000b8c588>]  ps = 0000    Not tainted
> pc is at 0x4
> ra is at napi_gro_receive+0x68/0x150
> v0 = 0000000000000000  t0 = 0000000000000008  t1 = 0000000000000000
> t2 = 0000000000000000  t3 = 000000000000000e  t4 = 0000000000000038
> t5 = 000000000000ffff  t6 = fffffc00002f220a  t7 = fffffc0002cd0000
> s0 = fffffc00010b3ca0  s1 = 0000000000000000  s2 = fffffc00011267e0
> s3 = 0000000000000000  s4 = fffffc00025f2008  s5 = fffffc00002f21c0
> s6 = fffffc00025f2040
> a0 = fffffc00025f2008  a1 = fffffc00002f21c0  a2 = fffffc0002cc800c
> a3 = fffffc00000250d0  a4 = 0000000effff0008  a5 = 0000000000000000
> t8 = fffffc00010b3c80  t9 = fffffc0002cc84cc  t10= 0000000000000000
> t11= 00000000000004c0  pv = fffffc0000b8bc10  at = 0000000000000000
> gp = fffffc00010f9fb8  sp = 00000000aefe3f8a
> Disabling lock debugging due to kernel taint
> Trace:
> [<fffffc0000b8c588>] napi_gro_receive+0x68/0x150
> [<fffffc00009b406c>] receive_buf+0x50c/0x1b80
> [<fffffc00009b5888>] virtnet_poll+0x1a8/0x5b0
> [<fffffc00009b58bc>] virtnet_poll+0x1dc/0x5b0
> [<fffffc0000b8d14c>] __napi_poll+0x4c/0x270
> [<fffffc0000b8d640>] net_rx_action+0x130/0x2c0
> [<fffffc0000bd6f00>] __qdisc_run+0x90/0x6c0
> [<fffffc0000337b64>] do_softirq+0xa4/0xd0
> [<fffffc0000337ca4>] __local_bh_enable_ip+0x114/0x120
> [<fffffc0000b89524>] __dev_queue_xmit+0x484/0xa60
> [<fffffc0000cd06fc>] packet_sendmsg+0xe7c/0x1ba0
> [<fffffc0000b53308>] __sys_sendto+0xf8/0x170
> [<fffffc0000461440>] __d_alloc+0x40/0x270
> [<fffffc0000ccdc4c>] packet_create+0x17c/0x3c0
> [<fffffc0000b5218c>] move_addr_to_kernel+0x3c/0x60
> [<fffffc0000b532b4>] __sys_sendto+0xa4/0x170
> [<fffffc0000b533a4>] sys_sendto+0x24/0x40
> [<fffffc0000b52840>] sys_bind+0x20/0x40
> [<fffffc0000311514>] entSys+0xa4/0xc0
> 
> Bisect log attached.
> 
> Guenter
> 
> ---
> # bad: [50b8b1d699ac313c0a07a3c185ffb23aecab8abb] Add linux-next specific files for 20210419
> # good: [bf05bf16c76bb44ab5156223e1e58e26dfe30a88] Linux 5.12-rc8
> git bisect start 'HEAD' 'v5.12-rc8'
> # bad: [c4bb91fc07e59241cde97f913d7a2fbedc248f0d] Merge remote-tracking branch 'crypto/master'
> git bisect bad c4bb91fc07e59241cde97f913d7a2fbedc248f0d
> # good: [499f739ad70f2a58aac985dceb25ca7666da88be] Merge remote-tracking branch 'jc_docs/docs-next'
> git bisect good 499f739ad70f2a58aac985dceb25ca7666da88be
> # good: [17e1be342d46eb0b7c3df4c7e623493483080b63] bnxt_en: Treat health register value 0 as valid in bnxt_try_reover_fw().
> git bisect good 17e1be342d46eb0b7c3df4c7e623493483080b63
> # good: [cf6d6925625755029cdf4bb0d0028f0b6e713242] Merge remote-tracking branch 'rdma/for-next'
> git bisect good cf6d6925625755029cdf4bb0d0028f0b6e713242
> # good: [fb8517f4fade44fa5e42e29ca4d6e4a7ed50b512] rtw88: 8822c: add CFO tracking
> git bisect good fb8517f4fade44fa5e42e29ca4d6e4a7ed50b512
> # bad: [d168b61fb769d10306b6118ec7623d2911d45690] Merge remote-tracking branch 'gfs2/for-next'
> git bisect bad d168b61fb769d10306b6118ec7623d2911d45690
> # bad: [ee3e875f10fca68fb7478c23c75b553e56da319c] net: enetc: increase TX ring size
> git bisect bad ee3e875f10fca68fb7478c23c75b553e56da319c
> # good: [4a51b0e8a0143b0e83d51d9c58c6416c3818a9f2] r8152: support PHY firmware for RTL8156 series
> git bisect good 4a51b0e8a0143b0e83d51d9c58c6416c3818a9f2
> # bad: [03e481e88b194296defdff3600b2fcebb04bd6cf] Merge tag 'mlx5-updates-2021-04-16' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
> git bisect bad 03e481e88b194296defdff3600b2fcebb04bd6cf
> # bad: [70c183759b2cece2f9ba82e63e38fa32bebc9db2] Merge branch 'gianfar-mq-polling'
> git bisect bad 70c183759b2cece2f9ba82e63e38fa32bebc9db2
> # bad: [d8604b209e9b3762280b8321162f0f64219d51c9] dt-bindings: net: qcom,ipa: add firmware-name property
> git bisect bad d8604b209e9b3762280b8321162f0f64219d51c9
> # good: [4ad29b1a484e0c58acfffdcd87172ed17f35c1dd] net: mvpp2: Add parsing support for different IPv4 IHL values
> git bisect good 4ad29b1a484e0c58acfffdcd87172ed17f35c1dd
> # good: [fa588eba632df14d296436995e6bbea0c146ae77] net: Add Qcom WWAN control driver
> git bisect good fa588eba632df14d296436995e6bbea0c146ae77
> # bad: [fb32856b16ad9d5bcd75b76a274e2c515ac7b9d7] virtio-net: page_to_skb() use build_skb when there's sufficient tailroom
> git bisect bad fb32856b16ad9d5bcd75b76a274e2c515ac7b9d7
> # first bad commit: [fb32856b16ad9d5bcd75b76a274e2c515ac7b9d7] virtio-net: page_to_skb() use build_skb when there's sufficient tailroom
> 


Yes, KASAN reported the same.

Can you try

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 8cd76037c72481200ea3e8429e9fdfec005dad85..2e28c04aa6351d2b4016f7d277ce104c4970069d 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -385,6 +385,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
        struct sk_buff *skb;
        struct virtio_net_hdr_mrg_rxbuf *hdr;
        unsigned int copy, hdr_len, hdr_padded_len;
+       struct page *page_to_free = NULL;
        int tailroom, shinfo_size;
        char *p, *hdr_p;
 
@@ -445,7 +446,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
                if (len)
                        skb_add_rx_frag(skb, 0, page, offset, len, truesize);
                else
-                       put_page(page);
+                       page_to_free = page;
                goto ok;
        }
 
@@ -479,6 +480,8 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
                hdr = skb_vnet_hdr(skb);
                memcpy(hdr, hdr_p, hdr_len);
        }
+       if (page_to_free)
+               put_page(page_to_free);
 
        if (metasize) {
                __skb_pull(skb, metasize);


Yep

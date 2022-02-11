Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 399054B1D48
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 05:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242501AbiBKEM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 23:12:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbiBKEM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 23:12:27 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA325F97;
        Thu, 10 Feb 2022 20:12:26 -0800 (PST)
X-UUID: 79bd38c002254a2183f9557e5681a346-20220211
X-UUID: 79bd38c002254a2183f9557e5681a346-20220211
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
        (envelope-from <lina.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 327661395; Fri, 11 Feb 2022 12:12:21 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Fri, 11 Feb 2022 12:12:19 +0800
Received: from mbjsdccf07.mediatek.inc (10.15.20.246) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 11 Feb 2022 12:12:18 +0800
From:   Lina Wang <lina.wang@mediatek.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andrii@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, <maze@google.com>,
        <willemb@google.com>, <edumazet@google.com>,
        <zhuoliang.zhang@mediatek.com>, <chao.song@mediatek.com>
Subject: Re: [PATCH] net: fix wrong network header length
Date:   Fri, 11 Feb 2022 12:06:29 +0800
Message-ID: <20220211040629.23703-1-lina.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <d5dd3f10c144f7150ec508fa8e6d7a78ceabfc10.camel@redhat.com>
References: <d5dd3f10c144f7150ec508fa8e6d7a78ceabfc10.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-02-10 at 17:02 +0100, Paolo Abeni wrote:

> > @@ -3682,6 +3682,7 @@ struct sk_buff *skb_segment_list(struct
> > sk_buff *skb,
> >  	struct sk_buff *tail = NULL;
> >  	struct sk_buff *nskb, *tmp;
> >  	int err;
> > +	unsigned int len_diff = 0;
> 
> Mintor nit: please respect the reverse x-mas tree order.
> 

Yes,v2 has change unsigned int to int

> >  
> >  	skb_push(skb, -skb_network_offset(skb) + offset);
> > @@ -3721,9 +3722,11 @@ struct sk_buff *skb_segment_list(struct
> > sk_buff *skb,
> >  		skb_push(nskb, -skb_network_offset(nskb) + offset);
> >  
> >  		skb_release_head_state(nskb);
> > +		len_diff = skb_network_header_len(nskb) -
> > skb_network_header_len(skb);
> >  		 __copy_skb_header(nskb, skb);
> >  
> >  		skb_headers_offset_update(nskb, skb_headroom(nskb) -
> > skb_headroom(skb));
> > +		nskb->transport_header += len_diff;
> 
> This does not look correct ?!? the network hdr position for nskb will
> still be uncorrect?!? and even the mac hdr likely?!? possibly you
> need
> to change the offset in skb_headers_offset_update().
> 

Network hdr position and mac hdr are both right, because bpf processing & 
skb_headers_offset_update have updated them to right position. After bpf
loading, the first skb's network header&mac_header became 44, transport
header still is 64. After skb_headers_offset_update, fraglist skb's mac
header and network header are still 24, the same with original packet.
Just fraglist skb's transport header became 44, as original is 64. 
Only transport header cannot be easily updated the same offset, because 
6to4 has different network header.

Actually,at the beginning, I want to change skb_headers_offset_update, but 
it has been called also in other place, maybe a new function should be 
needed here.
 
Skb_headers_offset_update has other wrong part in my scenary, 
inner_transport_header\inner_network_header\inner_mac_header shouldnot be 
changed, but they are been updated because of different headroom. They are
not used later, so wrong value didnot affect anything.

> Paolo
>

Thanks! 

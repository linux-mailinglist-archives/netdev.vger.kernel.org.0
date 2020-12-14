Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70EFC2D920F
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 04:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438345AbgLNDcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 22:32:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45965 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2438331AbgLNDcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 22:32:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607916647;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lJ/f1p/jWo6LX+lLq8as51T0CjWuBGu+ntgy1aiNUVU=;
        b=Zbq1o4F7tl6zozTrfMm//8elcfJ24OSN5grie+LAGF6/vjDA/un0dPr6JniJX7lKgEYE+1
        zERh73enjqsCTxWH6PJCSMQVVVWKZ0GvqW1JWiNcqsWIFpj9D2nrSbG0eVnUChMWReGh/4
        mzrxDydIwe5S2298pK/hNquHrP3SEMI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-r5g-zVk8NN656j8-kn3CsQ-1; Sun, 13 Dec 2020 22:30:43 -0500
X-MC-Unique: r5g-zVk8NN656j8-kn3CsQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D5A33107ACF7;
        Mon, 14 Dec 2020 03:30:41 +0000 (UTC)
Received: from [10.72.13.213] (ovpn-13-213.pek2.redhat.com [10.72.13.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DFDC9277BE;
        Mon, 14 Dec 2020 03:30:34 +0000 (UTC)
Subject: Re: [PATCH net v2] tun: fix ubuf refcount incorrectly on error path
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        wangyunjian <wangyunjian@huawei.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        "Lilijun (Jerry)" <jerry.lilijun@huawei.com>,
        chenchanghu <chenchanghu@huawei.com>,
        xudingke <xudingke@huawei.com>,
        "huangbin (J)" <brian.huangbin@huawei.com>,
        Willem de Bruijn <willemb@google.com>
References: <1606982459-41752-1-git-send-email-wangyunjian@huawei.com>
 <1607517703-18472-1-git-send-email-wangyunjian@huawei.com>
 <CA+FuTSfQoDr0jd76xBXSvchhyihQaL2UQXeCR6frJ7hyXxbmVA@mail.gmail.com>
 <34EFBCA9F01B0748BEB6B629CE643AE60DB6E3B3@dggemm513-mbx.china.huawei.com>
 <CA+FuTSdVJa4JQzzybZ17WDcfokA2RZ043kh5++Zgy5aNNebj0A@mail.gmail.com>
 <CAF=yD-LF+j1vpzKDtBVUi22ZkTCEnMAXgfLfoQTBO+95D6RGRA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <75c625df-3ac8-79ba-d1c5-3b6d1f9b108b@redhat.com>
Date:   Mon, 14 Dec 2020 11:30:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAF=yD-LF+j1vpzKDtBVUi22ZkTCEnMAXgfLfoQTBO+95D6RGRA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/14 上午9:32, Willem de Bruijn wrote:
> On Sat, Dec 12, 2020 at 7:18 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
>>>>> afterwards, the error handling in vhost handle_tx() will try to
>>>>> decrease the same refcount again. This is wrong and fix this by delay
>>>>> copying ubuf_info until we're sure there's no errors.
>>>> I think the right approach is to address this in the error paths, rather than
>>>> complicate the normal datapath.
>>>>
>>>> Is it sufficient to suppress the call to vhost_net_ubuf_put in the handle_tx
>>>> sendmsg error path, given that vhost_zerocopy_callback will be called on
>>>> kfree_skb?
>>> We can not call kfree_skb() until the skb was created.
>>>
>>>> Or alternatively clear the destructor in drop:
>>> The uarg->callback() is called immediately after we decide do datacopy
>>> even if caller want to do zerocopy. If another error occurs later, the vhost
>>> handle_tx() will try to decrease it again.
>> Oh right, I missed the else branch in this path:
>>
>>          /* copy skb_ubuf_info for callback when skb has no error */
>>          if (zerocopy) {
>>                  skb_shinfo(skb)->destructor_arg = msg_control;
>>                  skb_shinfo(skb)->tx_flags |= SKBTX_DEV_ZEROCOPY;
>>                  skb_shinfo(skb)->tx_flags |= SKBTX_SHARED_FRAG;
>>          } else if (msg_control) {
>>                  struct ubuf_info *uarg = msg_control;
>>                  uarg->callback(uarg, false);
>>          }
>>
>> So if handle_tx_zerocopy calls tun_sendmsg with ubuf_info (and thus a
>> reference to release), there are these five options:
>>
>> 1. tun_sendmsg succeeds, ubuf_info is associated with skb.
>>       reference released from kfree_skb calling vhost_zerocopy_callback later
>>
>> 2. tun_sendmsg succeeds, ubuf_info is released immediately, as skb is
>> not zerocopy.
>>
>> 3. tun_sendmsg fails before creating skb, handle_tx_zerocopy correctly
>> cleans up on receiving error from tun_sendmsg.
>>
>> 4. tun_sendmsg fails after creating skb, but with copying: decremented
>> at branch shown above + again in handle_tx_zerocopy
>>
>> 5. tun_sendmsg fails after creating skb, with zerocopy: decremented at
>> kfree_skb in drop: + again in handle_tx_zerocopy
>>
>> Since handle_tx_zerocopy has no idea whether on error 3, 4 or 5
>> occurred,
> Actually, it does. If sendmsg returns an error, it can test whether
> vq->heads[nvq->upend_idx].len != VHOST_DMA_IN_PROGRESS.


Just to make sure I understand this. Any reason for it can't be 
VHOST_DMA_IN_PROGRESS here?

Thanks


>
>> either all decrement-on-error cases must be handled by
>> handle_tx_zerocopy or none.
>>
>> Your patch chooses the latter. Makes sense.
>>
>> But can this still go wrong if the xdp path is taken, but no program
>> exists or the program returns XDP_PASS. And then the packet hits an
>> error path, such as ! IFF_UP?


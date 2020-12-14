Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 435F52D9235
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 05:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438538AbgLNEIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 23:08:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53577 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726666AbgLNEI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 23:08:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607918819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uzyNprWQhpXB2BvhFP0QM0DQai4ecWHKhpNZSzP1Ytw=;
        b=N8JRsVmY/W5yjweXQdEoGsoUkb4rvO+W4p2fQbuOejjyiWKf0eAqkEGOJ/+91BQqvpdsAT
        zGKBg/AAemTLlGUMr0UacX1jJGWSy4GtnFAjyrGsvL2aZgag/k5P2w7st7lc++aQuuamUP
        8RaEM2799WIboEZKGz56ioNt0zjcv7M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-KDGZE9q7M4SWJoaOppEwiQ-1; Sun, 13 Dec 2020 23:06:57 -0500
X-MC-Unique: KDGZE9q7M4SWJoaOppEwiQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C63510054FF;
        Mon, 14 Dec 2020 04:06:56 +0000 (UTC)
Received: from [10.72.13.213] (ovpn-13-213.pek2.redhat.com [10.72.13.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6564370472;
        Mon, 14 Dec 2020 04:06:49 +0000 (UTC)
Subject: Re: [PATCH net v2] tun: fix ubuf refcount incorrectly on error path
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     wangyunjian <wangyunjian@huawei.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
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
 <75c625df-3ac8-79ba-d1c5-3b6d1f9b108b@redhat.com>
 <CAF=yD-+Hcg8cNo2qMfpGOWRORJskZR3cPPEE61neg7xFWkVh8w@mail.gmail.com>
 <CAF=yD-JHO3SaxaHAZJ8nZ1jy8Zp4hMt1EhP3abutA5zczgTv5g@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <3cfbcd25-f9ae-ea9b-fc10-80a44a614276@redhat.com>
Date:   Mon, 14 Dec 2020 12:06:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAF=yD-JHO3SaxaHAZJ8nZ1jy8Zp4hMt1EhP3abutA5zczgTv5g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/14 上午11:56, Willem de Bruijn wrote:
> On Sun, Dec 13, 2020 at 10:54 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
>> On Sun, Dec 13, 2020 at 10:30 PM Jason Wang <jasowang@redhat.com> wrote:
>>>
>>> On 2020/12/14 上午9:32, Willem de Bruijn wrote:
>>>> On Sat, Dec 12, 2020 at 7:18 PM Willem de Bruijn
>>>> <willemdebruijn.kernel@gmail.com> wrote:
>>>>>>>> afterwards, the error handling in vhost handle_tx() will try to
>>>>>>>> decrease the same refcount again. This is wrong and fix this by delay
>>>>>>>> copying ubuf_info until we're sure there's no errors.
>>>>>>> I think the right approach is to address this in the error paths, rather than
>>>>>>> complicate the normal datapath.
>>>>>>>
>>>>>>> Is it sufficient to suppress the call to vhost_net_ubuf_put in the handle_tx
>>>>>>> sendmsg error path, given that vhost_zerocopy_callback will be called on
>>>>>>> kfree_skb?
>>>>>> We can not call kfree_skb() until the skb was created.
>>>>>>
>>>>>>> Or alternatively clear the destructor in drop:
>>>>>> The uarg->callback() is called immediately after we decide do datacopy
>>>>>> even if caller want to do zerocopy. If another error occurs later, the vhost
>>>>>> handle_tx() will try to decrease it again.
>>>>> Oh right, I missed the else branch in this path:
>>>>>
>>>>>           /* copy skb_ubuf_info for callback when skb has no error */
>>>>>           if (zerocopy) {
>>>>>                   skb_shinfo(skb)->destructor_arg = msg_control;
>>>>>                   skb_shinfo(skb)->tx_flags |= SKBTX_DEV_ZEROCOPY;
>>>>>                   skb_shinfo(skb)->tx_flags |= SKBTX_SHARED_FRAG;
>>>>>           } else if (msg_control) {
>>>>>                   struct ubuf_info *uarg = msg_control;
>>>>>                   uarg->callback(uarg, false);
>>>>>           }
>>>>>
>>>>> So if handle_tx_zerocopy calls tun_sendmsg with ubuf_info (and thus a
>>>>> reference to release), there are these five options:
>>>>>
>>>>> 1. tun_sendmsg succeeds, ubuf_info is associated with skb.
>>>>>        reference released from kfree_skb calling vhost_zerocopy_callback later
>>>>>
>>>>> 2. tun_sendmsg succeeds, ubuf_info is released immediately, as skb is
>>>>> not zerocopy.
>>>>>
>>>>> 3. tun_sendmsg fails before creating skb, handle_tx_zerocopy correctly
>>>>> cleans up on receiving error from tun_sendmsg.
>>>>>
>>>>> 4. tun_sendmsg fails after creating skb, but with copying: decremented
>>>>> at branch shown above + again in handle_tx_zerocopy
>>>>>
>>>>> 5. tun_sendmsg fails after creating skb, with zerocopy: decremented at
>>>>> kfree_skb in drop: + again in handle_tx_zerocopy
>>>>>
>>>>> Since handle_tx_zerocopy has no idea whether on error 3, 4 or 5
>>>>> occurred,
>>>> Actually, it does. If sendmsg returns an error, it can test whether
>>>> vq->heads[nvq->upend_idx].len != VHOST_DMA_IN_PROGRESS.
>>>
>>> Just to make sure I understand this. Any reason for it can't be
>>> VHOST_DMA_IN_PROGRESS here?
>> It can be, and it will be if tun_sendmsg returns EINVAL before
>> assigning the skb destructor.
> I meant returns an error, not necessarily only EINVAL.
>
>> Only if tun_sendmsg released the zerocopy state through
>> kfree_skb->vhost_zerocopy_callback will it have been updated to
>> VHOST_DMA_DONE_LEN. And only then must the caller not try to release
>> the state again.
> 	


I see. So I tend to fix this in vhost instead of tun to be consistent 
with the current error handling in handle_tx_zerocopy().

Thanks


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEA37169CE0
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 05:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbgBXEFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 23:05:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43917 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727210AbgBXEFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 23:05:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582517138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ck2F+6cD49f2gEgyPZQSffHDwNaJETMKxaLFkFQbIo0=;
        b=OOgjdznkZERYaDipj646rRb4lV5OIYvshQQyVA23RjA9vRQmVlKGL7PXR/N3BesxKmKwr0
        gNXIxr+bHG2x8HbLMhojCPhZlmEwEn4aIuHY8uS4fWj9HzEli8YMh6gdjEaobO0RtNFHsT
        cFgm4rV/ZX1Xzanj0eiA1pB+0QnSwYw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-jSJDtafsMACAytqWFxq-gw-1; Sun, 23 Feb 2020 23:05:29 -0500
X-MC-Unique: jSJDtafsMACAytqWFxq-gw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BDEF018A6EC0;
        Mon, 24 Feb 2020 04:05:26 +0000 (UTC)
Received: from [10.72.13.147] (ovpn-13-147.pek2.redhat.com [10.72.13.147])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C153660BF4;
        Mon, 24 Feb 2020 04:05:18 +0000 (UTC)
Subject: Re: [PATCH bpf-next v5] virtio_net: add XDP meta data support
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Yuya Kusakabe <yuya.kusakabe@gmail.com>
Cc:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, yhs@fb.com
References: <0c5eaba2-dd5a-fc3f-0e8f-154f7ad52881@redhat.com>
 <20200220085549.269795-1-yuya.kusakabe@gmail.com>
 <5bf11065-6b85-8253-8548-683c01c98ac1@redhat.com>
 <8fafd23d-4c80-539d-9f74-bc5cda0d5575@gmail.com>
 <20200223031314-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <7272077b-4cf9-b81b-22b5-22a2b0aceeb6@redhat.com>
Date:   Mon, 24 Feb 2020 12:05:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200223031314-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/23 =E4=B8=8B=E5=8D=884:14, Michael S. Tsirkin wrote:
> On Fri, Feb 21, 2020 at 05:36:08PM +0900, Yuya Kusakabe wrote:
>> On 2/21/20 1:23 PM, Jason Wang wrote:
>>> On 2020/2/20 =E4=B8=8B=E5=8D=884:55, Yuya Kusakabe wrote:
>>>> Implement support for transferring XDP meta data into skb for
>>>> virtio_net driver; before calling into the program, xdp.data_meta po=
ints
>>>> to xdp.data, where on program return with pass verdict, we call
>>>> into skb_metadata_set().
>>>>
>>>> Tested with the script at
>>>> https://github.com/higebu/virtio_net-xdp-metadata-test.
>>>>
>>>> Fixes: de8f3a83b0a0 ("bpf: add meta pointer for direct access")
>>> I'm not sure this is correct since virtio-net claims to not support m=
etadata by calling xdp_set_data_meta_invalid()?
>> virtio_net doesn't support by calling xdp_set_data_meta_invalid() for =
now.
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/=
drivers/net/virtio_net.c?id=3De42da4c62abb547d9c9138e0e7fcd1f36057b5e8#n6=
86
>> https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/=
drivers/net/virtio_net.c?id=3De42da4c62abb547d9c9138e0e7fcd1f36057b5e8#n8=
42
>>
>> And xdp_set_data_meta_invalid() are added by de8f3a83b0a0.
>>
>> $ git blame ./drivers/net/virtio_net.c | grep xdp_set_data_meta_invali=
d
>> de8f3a83b0a0f (Daniel Borkmann           2017-09-25 02:25:51 +0200  68=
6)                xdp_set_data_meta_invalid(&xdp);
>> de8f3a83b0a0f (Daniel Borkmann           2017-09-25 02:25:51 +0200  84=
2)                xdp_set_data_meta_invalid(&xdp);
>>
>> So I added `Fixes: de8f3a83b0a0 ("bpf: add meta pointer for direct acc=
ess")` to the comment.
>>
>>>> Signed-off-by: Yuya Kusakabe<yuya.kusakabe@gmail.com>
>>>> ---
>>>> v5:
>>>>  =C2=A0 - page_to_skb(): copy vnet header if hdr_valid without check=
ing metasize.
>>>>  =C2=A0 - receive_small(): do not copy vnet header if xdp_prog is av=
ailavle.
>>>>  =C2=A0 - __virtnet_xdp_xmit_one(): remove the xdp_set_data_meta_inv=
alid().
>>>>  =C2=A0 - improve comments.
>>>> v4:
>>>>  =C2=A0 - improve commit message
>>>> v3:
>>>>  =C2=A0 - fix preserve the vnet header in receive_small().
>>>> v2:
>>>>  =C2=A0 - keep copy untouched in page_to_skb().
>>>>  =C2=A0 - preserve the vnet header in receive_small().
>>>>  =C2=A0 - fix indentation.
>>>> ---
>>>>  =C2=A0 drivers/net/virtio_net.c | 54 ++++++++++++++++++++++++------=
----------
>>>>  =C2=A0 1 file changed, 33 insertions(+), 21 deletions(-)
>>>>
>>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>>> index 2fe7a3188282..4ea0ae60c000 100644
>>>> --- a/drivers/net/virtio_net.c
>>>> +++ b/drivers/net/virtio_net.c
>>>> @@ -371,7 +371,7 @@ static struct sk_buff *page_to_skb(struct virtne=
t_info *vi,
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct receive_queue =
*rq,
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct page *page, un=
signed int offset,
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int len, uns=
igned int truesize,
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool hdr_valid)
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool hdr_valid, unsigned int meta=
size)
>>>>  =C2=A0 {
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct sk_buff *skb;
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct virtio_net_hdr_mrg_rxbuf *hdr=
;
>>>> @@ -393,6 +393,7 @@ static struct sk_buff *page_to_skb(struct virtne=
t_info *vi,
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hdr_padded_l=
en =3D sizeof(struct padded_vnet_hdr);
>>>>  =C2=A0 +=C2=A0=C2=A0=C2=A0 /* hdr_valid means no XDP, so we can cop=
y the vnet header */
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (hdr_valid)
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 memcpy(hdr, =
p, hdr_len);
>>>>  =C2=A0 @@ -405,6 +406,11 @@ static struct sk_buff *page_to_skb(stru=
ct virtnet_info *vi,
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 copy =3D skb=
_tailroom(skb);
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 skb_put_data(skb, p, copy);
>>>>  =C2=A0 +=C2=A0=C2=A0=C2=A0 if (metasize) {
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __skb_pull(skb, metasize=
);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 skb_metadata_set(skb, me=
tasize);
>>>> +=C2=A0=C2=A0=C2=A0 }
>>>> +
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 len -=3D copy;
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 offset +=3D copy;
>>>>  =C2=A0 @@ -450,10 +456,6 @@ static int __virtnet_xdp_xmit_one(struc=
t virtnet_info *vi,
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct virtio_net_hdr_mrg_rxbuf *hdr=
;
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int err;
>>>>  =C2=A0 -=C2=A0=C2=A0=C2=A0 /* virtqueue want to use data area in-fr=
ont of packet */
>>>> -=C2=A0=C2=A0=C2=A0 if (unlikely(xdpf->metasize > 0))
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EOPNOTSUPP;
>>>> -
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (unlikely(xdpf->headroom < vi->hd=
r_len))
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EOVE=
RFLOW;
>>>>  =C2=A0 @@ -644,6 +646,7 @@ static struct sk_buff *receive_small(str=
uct net_device *dev,
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int delta =3D 0;
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct page *xdp_page;
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int err;
>>>> +=C2=A0=C2=A0=C2=A0 unsigned int metasize =3D 0;
>>>>  =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 len -=3D vi->hdr_len;
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 stats->bytes +=3D len;
>>>> @@ -683,8 +686,8 @@ static struct sk_buff *receive_small(struct net_=
device *dev,
>>>>  =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 xdp.d=
ata_hard_start =3D buf + VIRTNET_RX_PAD + vi->hdr_len;
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 xdp.data =3D=
 xdp.data_hard_start + xdp_headroom;
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 xdp_set_data_meta_invali=
d(&xdp);
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 xdp.data_end=
 =3D xdp.data + len;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 xdp.data_meta =3D xdp.da=
ta;
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 xdp.rxq =3D =
&rq->xdp_rxq;
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 orig_data =3D=
 xdp.data;
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 act =3D bpf_=
prog_run_xdp(xdp_prog, &xdp);
>>>> @@ -695,6 +698,7 @@ static struct sk_buff *receive_small(struct net_=
device *dev,
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 /* Recalculate length in case bpf program changed it */
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 delta =3D orig_data - xdp.data;
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 len =3D xdp.data_end - xdp.data;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
metasize =3D xdp.data - xdp.data_meta;
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 break;
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case XDP_TX:
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 stats->xdp_tx++;
>>>> @@ -735,11 +739,14 @@ static struct sk_buff *receive_small(struct ne=
t_device *dev,
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 skb_reserve(skb, headroom - delta);
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 skb_put(skb, len);
>>>> -=C2=A0=C2=A0=C2=A0 if (!delta) {
>>>> +=C2=A0=C2=A0=C2=A0 if (!xdp_prog) {
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 buf +=3D hea=
der_offset;
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 memcpy(skb_v=
net_hdr(skb), buf, vi->hdr_len);
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } /* keep zeroed vnet hdr since pack=
et was changed by bpf */
>>> I prefer to make this an independent patch and cc stable.
>>>
>>> Other looks good.
>>>
>>> Thanks
>> I see. So I need to revert to delta from xdp_prog?
>>
>> Thank you.
> So maybe send a 2 patch series: 1/2 is this chunk with the appropriate
> description. Actually for netdev David prefers that people do not
> cc stable directly, just include Fixes tag and mention in the
> commit log it's also needed for stable. Patch 2/2 is the rest
> handling metadata.


+1

Thanks



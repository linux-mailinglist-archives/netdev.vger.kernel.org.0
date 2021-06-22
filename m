Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCB43AFED0
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 10:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhFVIMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 04:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbhFVIMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 04:12:25 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B1E6C061574
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 01:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Message-ID:From:CC:To:Subject:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:
        Date:Sender:Reply-To:Content-ID:Content-Description;
        bh=Cc7LQ7jSAcxuYcgvWf6vgv5jBWzHgg6x8vcly+JmJwY=; b=h5Hjt9XMtX9eg55gw97m7f1rWo
        ISPvNaZUyEY5YnfJC4Focuj4uRkEwr+npRIBHb/JQOMz9uyPQuHj9uEyq2efrSa37FCI/ZGKoWEjg
        blH7DSBu5q8ekOiXwWDvD8WjxAgnKrq4m/VnfbkbKxadXTpYzmZnvs1sZbf5uyvy71C/+EeMQ5bcC
        Jd1B4VT/kzoIvrNIdusf2OPFKTFdYqt2QOrdamhkWOwG+jQZpjZW30W70hScetN429BYMXNwC/OEz
        zhz0KkuTMNDpCQF7n4Dc8M2OG4PTKNSvddRMrcAWHlqKWK7H1vOQUmjOAQAd+Wpf/G9Jwb4haeNFS
        GmWGwImg==;
Received: from [2a01:4c8:1076:65cf:7d30:f50d:492:ba62]
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lvbTs-00AX5k-F1; Tue, 22 Jun 2021 08:10:07 +0000
Date:   Tue, 22 Jun 2021 09:10:03 +0100
User-Agent: K-9 Mail for Android
In-Reply-To: <ca2e6445-2ac7-7de1-bf3c-af000cb1739a@redhat.com>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org> <e832b356-ffc2-8bca-f5d9-75e8b98cfcf2@redhat.com> <2cbe878845eb2a1e3803b3340263ea14436fe053.camel@infradead.org> <2433592d2b26deec33336dd3e83acfd273b0cf30.camel@infradead.org> <c93c7357e9fa8a6ce89c0fc53328eeb4f3eb68d5.camel@infradead.org> <d26bbeb7-d184-9bda-55c3-2273f743b139@redhat.com> <f35b7857cba18aa6d187723624b57c8bb9b533e8.camel@infradead.org> <ca2e6445-2ac7-7de1-bf3c-af000cb1739a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] net: tun: fix tun_xdp_one() for IFF_TUN mode
To:     Jason Wang <jasowang@redhat.com>, netdev <netdev@vger.kernel.org>
CC:     =?ISO-8859-1?Q?Eugenio_P=E9rez?= <eperezma@redhat.com>
From:   David Woodhouse <dwmw2@infradead.org>
Message-ID: <C196C9BC-7D51-4FE4-8E68-3C9958C5A858@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22 June 2021 08:51:43 BST, Jason Wang <jasowang@redhat=2Ecom> wrote:
>
>=E5=9C=A8 2021/6/22 =E4=B8=8B=E5=8D=883:24, David Woodhouse =E5=86=99=E9=
=81=93:
>> On Tue, 2021-06-22 at 12:52 +0800, Jason Wang wrote:
>>>
>>> I cook two patches=2E Please see and check if they fix the problem=2E
>>> (compile test only for me)=2E
>> I did the second one slightly differently (below) but those are what
>I
>> came up with too, which seems to be working=2E
>>
>> @@ -2331,7 +2344,7 @@ static int tun_xdp_one(struct tun_struct *tun,
>>   {
>>          unsigned int datasize =3D xdp->data_end - xdp->data;
>>          struct tun_xdp_hdr *hdr =3D xdp->data_hard_start;
>> -       struct virtio_net_hdr *gso =3D &hdr->gso;
>> +       struct virtio_net_hdr *gso =3D NULL;
>>          struct bpf_prog *xdp_prog;
>>          struct sk_buff *skb =3D NULL;
>>          u32 rxhash =3D 0, act;
>> @@ -2340,9 +2353,12 @@ static int tun_xdp_one(struct tun_struct *tun,
>>          bool skb_xdp =3D false;
>>          struct page *page;
>>  =20
>> +       if (tun->flags & IFF_VNET_HDR)
>> +               gso =3D &hdr->gso;
>> +
>>          xdp_prog =3D rcu_dereference(tun->xdp_prog);
>>          if (xdp_prog) {
>> -               if (gso->gso_type) {
>> +               if (gso && gso->gso_type) {
>>                          skb_xdp =3D true;
>>                          goto build;
>>                  }
>> @@ -2388,14 +2406,18 @@ static int tun_xdp_one(struct tun_struct
>*tun,
>>          skb_reserve(skb, xdp->data - xdp->data_hard_start);
>>          skb_put(skb, xdp->data_end - xdp->data);
>>  =20
>> -       if (virtio_net_hdr_to_skb(skb, gso,
>tun_is_little_endian(tun))) {
>> +       if (!gso)
>> +               skb_reset_mac_header(skb);
>> +       else if (virtio_net_hdr_to_skb(skb, gso,
>tun_is_little_endian(tun))) {
>>                  atomic_long_inc(&tun->rx_frame_errors);
>>                  kfree_skb(skb);
>
>
>This should work as well=2E

I'll rip out the rest of my debugging hacks and check that these two are s=
ufficient, and that I hadn't accidentally papered over something else as I =
debugged it=2E

Then I'll look at the case of having no virtio_net_hdr on either side, and=
 also different sized headers on the tun device (why does it even support t=
hat?)=2E

And the test case, of course=2E=20

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E

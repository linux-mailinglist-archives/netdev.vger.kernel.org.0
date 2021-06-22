Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9643AFC3F
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 06:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhFVEy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 00:54:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39713 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229752AbhFVEy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 00:54:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624337562;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Atyt1+cSJGxIDTuhYClDV19GU9l/MfXJf0Ylpee1EbA=;
        b=dm8gEWY0Q5ke/BTByrbGdB10fltPyZT6gmprAtfmOIyv0rrrubqJeOG4I6CEocb22n162q
        cbYseQHl53vIohF8/RABl20j0Y63bRlk+l6+XfeKijkLtiZFdzDmkRcS8ppcWSJ3Ycp8Od
        ijU9unPbhGxzB+OugM/kE/Ma19oulAI=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-enqilrjxNoWfUvXXeKNvLQ-1; Tue, 22 Jun 2021 00:52:38 -0400
X-MC-Unique: enqilrjxNoWfUvXXeKNvLQ-1
Received: by mail-pg1-f200.google.com with SMTP id f24-20020a631f180000b0290222eb79d493so10945214pgf.8
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 21:52:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=Atyt1+cSJGxIDTuhYClDV19GU9l/MfXJf0Ylpee1EbA=;
        b=OSycNHcAJwmqDtU3fNj1lw5uiBZ1nyyB87zyhoWNUzORRIHWVZY9hOEhRwTRs82JBQ
         jL/d8WuHMQdjtqLue9qD6XHoTip1oy/sgY9t1/bS8P9pY44jFIxi+D4f02v6IsG8UrAf
         7gclWdJBoX/qfmMgQ5wyrl/xsKsTJfxOU3HXs9FsQyElHKNzCv5HhjGlfPiiLQ6aM+pF
         Ze7eFHQJYsKOK5UxI+FtehYa0b6JoCvLDVb6vEStaQEW/kPGzQ+l9R155Gka39NP1e4Q
         Npt6fLHWo3mOKhcYCbJp44lLL9sgQuTQaOdrU5qPzSAU/bmfvG2RPZobMWokv6b54lLN
         ahfw==
X-Gm-Message-State: AOAM530mLWd/NGzgyOl98SpM7wFSJMiEMk5MYZqYMA9bdaz6e56TLjkF
        g46P7mdfkHJ2B32RY0vvjPSBZeKEUiErLnn+qCMlije/KqDAT+HSub+2qssMnnenG2J8to6+H3M
        9RI3b6t3eTUI9Lbul
X-Received: by 2002:a65:67c8:: with SMTP id b8mr1925468pgs.109.1624337557479;
        Mon, 21 Jun 2021 21:52:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwHgovhbb8iXHgjflVp6w5zsyzSlwmzClpJVhgiyjTV+j1E/gAtLCG6YIEvXtduWlzdlN0ODA==
X-Received: by 2002:a65:67c8:: with SMTP id b8mr1925444pgs.109.1624337557219;
        Mon, 21 Jun 2021 21:52:37 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n23sm17692619pgv.76.2021.06.21.21.52.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 21:52:36 -0700 (PDT)
Subject: Re: [PATCH] net: tun: fix tun_xdp_one() for IFF_TUN mode
To:     David Woodhouse <dwmw2@infradead.org>,
        netdev <netdev@vger.kernel.org>
Cc:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
 <e832b356-ffc2-8bca-f5d9-75e8b98cfcf2@redhat.com>
 <2cbe878845eb2a1e3803b3340263ea14436fe053.camel@infradead.org>
 <2433592d2b26deec33336dd3e83acfd273b0cf30.camel@infradead.org>
 <c93c7357e9fa8a6ce89c0fc53328eeb4f3eb68d5.camel@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d26bbeb7-d184-9bda-55c3-2273f743b139@redhat.com>
Date:   Tue, 22 Jun 2021 12:52:29 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <c93c7357e9fa8a6ce89c0fc53328eeb4f3eb68d5.camel@infradead.org>
Content-Type: multipart/mixed;
 boundary="------------AE6A664F681FA24A414B9D6B"
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------AE6A664F681FA24A414B9D6B
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2021/6/22 上午4:43, David Woodhouse 写道:
> On Mon, 2021-06-21 at 15:50 +0100, David Woodhouse wrote:
>> On Mon, 2021-06-21 at 11:52 +0100, David Woodhouse wrote:
>>> Firstly, I don't think I can set IFF_VNET_HDR on the tun device after
>>> opening it. So my model of "open the tun device, then *see* if we can
>>> use vhost to accelerate it" doesn't work.
>>>
>>> I tried setting VHOST_NET_F_VIRTIO_NET_HDR in the vhost features
>>> instead, but that gives me a weird failure mode where it drops around
>>> half the incoming packets, and I haven't yet worked out why.
>> FWIW that problem also goes away if I set TUNSNDBUF and avoid the XDP
>> data path.
> Looks like there are two problems there.
>
> Firstly, vhost_net_build_xdp() doesn't cope well with sock_hlen being
> zero. It reads those zero bytes into its buffer, then points 'gso' at
> the buffer with no valid data in it, and checks gso->flags for the
> NEEDS_CSUM flag.
>
> Secondly, tun_xdp_one() doesn't cope with receiving packets without the
> virtio header either. While tun_get_user() correctly checks
> IFF_VNET_HDR, tun_xdp_one() does not, and treats the start of my IP
> packets as if they were a virtio_net_hdr.
>
> I'll look at turning my code into a test case for kernel selftests.


I cook two patches. Please see and check if they fix the problem. 
(compile test only for me).

Thanks


>
>

--------------AE6A664F681FA24A414B9D6B
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="0001-vhost_net-validate-gso-metadata-only-if-socket-has-v.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="0001-vhost_net-validate-gso-metadata-only-if-socket-has-v.pa";
 filename*1="tch"

RnJvbSA1ZDc4NTAyN2RhODdlNDAxMzg0MDdkNzY4NDFmNWNkZDY0OTE0NTQxIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKYXNvbiBXYW5nIDxqYXNvd2FuZ0ByZWRoYXQuY29t
PgpEYXRlOiBUdWUsIDIyIEp1biAyMDIxIDEyOjA3OjU5ICswODAwClN1YmplY3Q6IFtQQVRD
SCAxLzJdIHZob3N0X25ldDogdmFsaWRhdGUgZ3NvIG1ldGFkYXRhIG9ubHkgaWYgc29ja2V0
IGhhcyB2bmV0CiBoZWFkZXIKCldoZW4gc29ja19obGVuIGlzIHplcm8sIHRoZXJlJ3Mgbm8g
bmVlZCB0byB2YWxpZGF0ZSB0aGUgc29ja2V0IHZuZXQKaGVhZGVyIHNpbmNlIGl0IGRvZXNu
J3Qgc3VwcG9ydCB0aGF0LgoKU2lnbmVkLW9mZi1ieTogSmFzb24gV2FuZyA8amFzb3dhbmdA
cmVkaGF0LmNvbT4KLS0tCiBkcml2ZXJzL3Zob3N0L25ldC5jIHwgMiArLQogMSBmaWxlIGNo
YW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZHJp
dmVycy92aG9zdC9uZXQuYyBiL2RyaXZlcnMvdmhvc3QvbmV0LmMKaW5kZXggZGY4MmIxMjQx
NzBlLi41MDM0YzQ5NDliYzQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvdmhvc3QvbmV0LmMKKysr
IGIvZHJpdmVycy92aG9zdC9uZXQuYwpAQCAtNzI1LDcgKzcyNSw3IEBAIHN0YXRpYyBpbnQg
dmhvc3RfbmV0X2J1aWxkX3hkcChzdHJ1Y3Qgdmhvc3RfbmV0X3ZpcnRxdWV1ZSAqbnZxLAog
CWhkciA9IGJ1ZjsKIAlnc28gPSAmaGRyLT5nc287CiAKLQlpZiAoKGdzby0+ZmxhZ3MgJiBW
SVJUSU9fTkVUX0hEUl9GX05FRURTX0NTVU0pICYmCisJaWYgKG52cS0+c29ja19obGVuICYm
IChnc28tPmZsYWdzICYgVklSVElPX05FVF9IRFJfRl9ORUVEU19DU1VNKSAmJgogCSAgICB2
aG9zdDE2X3RvX2NwdSh2cSwgZ3NvLT5jc3VtX3N0YXJ0KSArCiAJICAgIHZob3N0MTZfdG9f
Y3B1KHZxLCBnc28tPmNzdW1fb2Zmc2V0KSArIDIgPgogCSAgICB2aG9zdDE2X3RvX2NwdSh2
cSwgZ3NvLT5oZHJfbGVuKSkgewotLSAKMi4yNS4xCgo=
--------------AE6A664F681FA24A414B9D6B
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="0002-tun-use-vnet-header-only-when-IFF_VNET_HDR-in-tun_xd.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="0002-tun-use-vnet-header-only-when-IFF_VNET_HDR-in-tun_xd.pa";
 filename*1="tch"

RnJvbSBkNWYzNmY3M2JlMDVlZTQyNWVjYTczYjYzYjM3ZDVhMjBiMjI4MzdhIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKYXNvbiBXYW5nIDxqYXNvd2FuZ0ByZWRoYXQuY29t
PgpEYXRlOiBUdWUsIDIyIEp1biAyMDIxIDEyOjM0OjU4ICswODAwClN1YmplY3Q6IFtQQVRD
SCAyLzJdIHR1bjogdXNlIHZuZXQgaGVhZGVyIG9ubHkgd2hlbiBJRkZfVk5FVF9IRFIgaW4K
IHR1bl94ZHBfb25lKCkKCldlIHNob3VsZCBub3QgdHJ5IHRvIHJlYWQgdm5ldCBoZWFkZXIg
ZnJvbSB0aGUgeGRwIGJ1ZmZlciBpZgpJRkZfVk5FVF9IRFIgaXMgbm90IHNldCwgb3RoZXJ3
aXNlIHdlIGJyZWFrIHRoZSBzZW1hbnRpYyBvZgpJRkZfVk5FVF9IRFIuCgpTaWduZWQtb2Zm
LWJ5OiBKYXNvbiBXYW5nIDxqYXNvd2FuZ0ByZWRoYXQuY29tPgotLS0KIGRyaXZlcnMvbmV0
L3R1bi5jIHwgMTAgKysrKysrKy0tLQogMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygr
KSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC90dW4uYyBiL2Ry
aXZlcnMvbmV0L3R1bi5jCmluZGV4IDg0ZjgzMjgwNjMxMy4uNzBjNGJiMjJlZjc4IDEwMDY0
NAotLS0gYS9kcml2ZXJzL25ldC90dW4uYworKysgYi9kcml2ZXJzL25ldC90dW4uYwpAQCAt
MjMzNCwxOCArMjMzNCwyMiBAQCBzdGF0aWMgaW50IHR1bl94ZHBfb25lKHN0cnVjdCB0dW5f
c3RydWN0ICp0dW4sCiB7CiAJdW5zaWduZWQgaW50IGRhdGFzaXplID0geGRwLT5kYXRhX2Vu
ZCAtIHhkcC0+ZGF0YTsKIAlzdHJ1Y3QgdHVuX3hkcF9oZHIgKmhkciA9IHhkcC0+ZGF0YV9o
YXJkX3N0YXJ0OwotCXN0cnVjdCB2aXJ0aW9fbmV0X2hkciAqZ3NvID0gJmhkci0+Z3NvOwor
CXN0cnVjdCB2aXJ0aW9fbmV0X2hkciBnc28gPSB7IDAgfTsKIAlzdHJ1Y3QgYnBmX3Byb2cg
KnhkcF9wcm9nOwogCXN0cnVjdCBza19idWZmICpza2IgPSBOVUxMOwogCXUzMiByeGhhc2gg
PSAwLCBhY3Q7CiAJaW50IGJ1ZmxlbiA9IGhkci0+YnVmbGVuOworCWJvb2wgdm5ldF9oZHIg
PSB0dW4tPmZsYWdzICYgSUZGX1ZORVRfSERSOwogCWludCBlcnIgPSAwOwogCWJvb2wgc2ti
X3hkcCA9IGZhbHNlOwogCXN0cnVjdCBwYWdlICpwYWdlOwogCisJaWYgKHZuZXRfaGRyKQor
CQltZW1jcHkoJmdzbywgJmhkci0+Z3NvLCBzaXplb2YoZ3NvKSk7CisKIAl4ZHBfcHJvZyA9
IHJjdV9kZXJlZmVyZW5jZSh0dW4tPnhkcF9wcm9nKTsKIAlpZiAoeGRwX3Byb2cpIHsKLQkJ
aWYgKGdzby0+Z3NvX3R5cGUpIHsKKwkJaWYgKGdzby5nc29fdHlwZSkgewogCQkJc2tiX3hk
cCA9IHRydWU7CiAJCQlnb3RvIGJ1aWxkOwogCQl9CkBAIC0yMzkxLDcgKzIzOTUsNyBAQCBz
dGF0aWMgaW50IHR1bl94ZHBfb25lKHN0cnVjdCB0dW5fc3RydWN0ICp0dW4sCiAJc2tiX3Jl
c2VydmUoc2tiLCB4ZHAtPmRhdGEgLSB4ZHAtPmRhdGFfaGFyZF9zdGFydCk7CiAJc2tiX3B1
dChza2IsIHhkcC0+ZGF0YV9lbmQgLSB4ZHAtPmRhdGEpOwogCi0JaWYgKHZpcnRpb19uZXRf
aGRyX3RvX3NrYihza2IsIGdzbywgdHVuX2lzX2xpdHRsZV9lbmRpYW4odHVuKSkpIHsKKwlp
ZiAodmlydGlvX25ldF9oZHJfdG9fc2tiKHNrYiwgJmdzbywgdHVuX2lzX2xpdHRsZV9lbmRp
YW4odHVuKSkpIHsKIAkJYXRvbWljX2xvbmdfaW5jKCZ0dW4tPnJ4X2ZyYW1lX2Vycm9ycyk7
CiAJCWtmcmVlX3NrYihza2IpOwogCQllcnIgPSAtRUlOVkFMOwotLSAKMi4yNS4xCgo=
--------------AE6A664F681FA24A414B9D6B--


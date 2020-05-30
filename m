Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50FBD1E915E
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 15:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbgE3NDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 09:03:50 -0400
Received: from mout.web.de ([212.227.15.3]:38029 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727947AbgE3NDt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 May 2020 09:03:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1590843810;
        bh=wapouwcxMosz61SFFitq+Qad2mwYl6vVb9jzMnZabcY=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=YYbNhnPDDQdp/TIycbs0htAsH1GIdowVfb0MKMmpwvMo+6BERg5LahIJ/zoeZmaAR
         unpB1i5iPF9EEhCc7SMeB7KqdYP1eeT3MYTUOT4VcL3eEAbUzPiCNpQ5G8NCdXQDk0
         d5mbWStu6y6TD7yWVJ2au/OnkNLwx5BBJEv+f9Cw=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.133.149.250]) by smtp.web.de (mrweb004
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MBp3P-1jogJZ1O3L-00Alxt; Sat, 30
 May 2020 15:03:30 +0200
Subject: Re: [PATCH v5] virtio_vsock: Fix race condition in
 virtio_transport_recv_pkt()
To:     Jia He <justin.he@arm.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Asias He <asias@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Kaly Xin <Kaly.Xin@arm.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
References: <20200530123206.63335-1-justin.he@arm.com>
 <20200530123936.63480-1-justin.he@arm.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <7972c279-19a7-3573-647c-749122c90b81@web.de>
Date:   Sat, 30 May 2020 15:03:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200530123936.63480-1-justin.he@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:NlxBKWTFVYuRgZpUwxUGFnLZ36v+rYc4eyjfgYGnEOLvORQHHZQ
 Gpmc9kOlz6s5nmD9SJEJ7+8d88LE+6FnssfXhNR/Qj1EJRJk3cmdNI9LEtIGgwcABj2+2M2
 pS5NHAyd6poffd7at9NY6V51dChewCsXIkZpDOUBWV9IzQj6bB0NscMt+FzICZ7r6daQmSi
 KdQHuMRjV6pFEKh64OlcA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:+pmAXm5XTq0=:xjndtBSr+oay+6LA9zRNoE
 MEOKUK89Lk9KP1n/awYyMrPuMrzIC1+sEkONFDG+I88bGPypot0+HtEocTH7e/pIZ7imEn5M2
 1YvTGBcoZD95cpHcebCAKxP/raElGUkrGLDOgLLCg791t2y2itpheXNQMPj3PSbPU7LEc36Jn
 VcHPvbNrHq5lLV3bIkItZBjVhmP1sxD6iphPpRnKPhNKUapbijTPNJ4ZhQKOiebe7VN83ARf5
 3XGpXQRO8+0ERUa5wzqwb/8G1EHOKOxNoH7DqnsS/XD+QIb3/quRt+DS0vQud3pB3jOweg7gn
 A+Ion2ZpB/m9NqyPlccdk8+oTfG87oWuqH7CdgO9pWzOHFZmjT64OYZtcCz+LoP89XE1z1nyG
 syGia7g0JtZgVcvLVVy8IhcrOs5MyhyJMzBOtxU5uZD0CMoLWHnqJi1il8tLmE+bWeZjWM7pd
 r7krdWlloiX/9kbE8Mk7TE4SObk7ib0IsOegpPRsDeGO5lQjzHokws28jRRKgPTU03PzSLqWL
 KMq0ylbJPEgLPyfqUt9gZlZZJsj1O5kcj/mKQelfmOfIoMfK/ism0Cu+LyFsHvH/avi9nhsUI
 O21JFR1cDoLorGnzYVJOhRrvKXu6C7ytuLIqbyNJlizeswXdiCAVfz6InZl7+y2xcLKvXy/EG
 Pf9ohfU90TxICrd0kmwVJUUmt00aGJRfLDGhLqTUU1gllebB9A6+TXWiFWuuPvLXrPUr7okNF
 OIBpQEecVc3EFlDOFJVTV3V46UeQDRoTProt9sGbr/YIGNXCvMenEMAyTseLXxXT3+jUFGxsg
 ekfc+fhbBReAupyaNVaD9joLqZHqOltdvqCSyaCrA/9XhggvkkJf7pQolskaqIXVswW4u5FAW
 B7jHESEKxj6GJWfW4tNbzOOgSEYuuGKFBDCKJ0dabfHatnxcu9AmFMMJIqet4UC23w+g1fDFU
 7wxixSjRZMSAxIupWuDyIgEBkjAAY31NzsMmvUv7OCV3jc6XSFD1qdT2r392xvFntienDcWka
 9YPhuIkLVxym2BKTQ0HJGjR2T0D0rcMpp5qJ2lb1PoSfIkpqLVDJ6GyDGDiTpyqzTY38mM/ZR
 6U/JN/lV/8xfq593RvfqBDL8cYWGOvu/RT6zJv+4v94sCKzzn18CqW+jXni5AuwdoHNXGudgG
 Qg1tVFD6mTlFcXwbhpySz3+I+mc+Wt1tfXrnt9yqT48MJXIj5ce8aDMmFVBcs1iCXL23FRqb7
 b3MIJDbL4PXu1UENE
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> ---
> v5: sorry, MIME type in the previous commit message
>
>  net/vmw_vsock/virtio_transport_common.c | 8 ++++++++

Is it helpful to keep the patch version information complete here?
(Will another fine-tuning follow for the proposed change?)

Regards,
Markus

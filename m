Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16B001E909E
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 12:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728887AbgE3KlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 06:41:07 -0400
Received: from mout.web.de ([212.227.15.4]:47069 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725813AbgE3KlE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 May 2020 06:41:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1590835246;
        bh=pIzrs1rz1M8vZd8UCEokoQaFe9Auvegq60l/XQ8H+SQ=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=a3mGJiXJCcizIhcgM0g7bHEBgRSSyKmQfdPGcLSeNsBioSuel/kwUj+cto3mT9xX3
         hpJx9UrgQ9u8hV0G+8NX7fZFdeJynVTvD5MGQheNeQoG3ejSMQUaXkrZ2utuFWFNWU
         OAEXtPrDSV6iIpudw8IZahNqFqCmxJaxcfAQTVMQ=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.133.149.250]) by smtp.web.de (mrweb004
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MK6mD-1jgMUl0vsD-001O4R; Sat, 30
 May 2020 12:40:46 +0200
To:     Jia He <justin.he@arm.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Kaly Xin <Kaly.Xin@arm.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: Re: [PATCH v3] virtio_vsock: Fix race condition in
 virtio_transport_recv_pkt()
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <7edeff0b-2dd8-aeae-aa96-73c98d581ece@web.de>
Date:   Sat, 30 May 2020 12:40:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:nD5ouyr/fmbjPnHYL4wSUZ7lewNoF9EfF2TP0d4Gf/HQXmeAsjf
 7ao0M6TPFMSR0+KMmDtJKMMV6Xn7fmw86ygzKGKCgqNdGuas1UCPt3WOrq0551ue/2W3WaC
 8ZVW26p4FHcAiDGWZWs0nfkJI/Z9p9FDft89OKXyLKqSK97+LuI6idqSm/3IEakWjCxO2ed
 MwZ1iObR9Wb+9zYQzPzCw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:NQruA8wl3NE=:063eetOcXpQYNzcE2CAvHs
 sezhmHpdGEuJmr99asV9/PmgJrjSyrbLKc88I9VjdfQgT/uCeBXLCCzWY3YbKVHafInqMwIPk
 wqueqC90xolmKc3V6zye3X4heKf50s8UK9VoAxzAtxnT4YEJ5WhBYfWQQ0HuOykRBnF+DYLSh
 lxbSikqBZfaImNfV0pLbaRo8IhSwzn0dlajwWwYtE0GnMoYsK9E8ar3Qt+snd12xcJ5/u1VOX
 M0Mvo67vWNAjNaMJd8gZncu46dLZcvbM9SqWQyKMOTng1DYE4fJ8zCcHIMoceCKLt9DAHZFuK
 Rszv7dChOQObA463JDoI6e29uizdWhmdM02c4dbUktttP50kPZItcX5+bDaIgtX2pIOp9RQNo
 dvhtmQ8EqT4uadDNulyg+Y8eYaIadpnBsVjXLr2U8xUhjWUlhk4YPbNkAC3ibxkcF/WsRfCw9
 HKEQ5+G36G/zFya0qSfmxzsnkJXBd5wUTTfcq2Rnu3a2gltX3sLGSh5fLS3NLM+jrqgc/TvtY
 Ak5Grz6sRf9Q8N7NLIaxs3nijAKOjB4M299Bdc3i5bG1Y58oNujt6fXXDvVA2OwTmRs75wV2e
 YTE6l/xIJmTzxxcX+XO5DbEG4xbBtLVJFzi/rqR18/lcxbL2HwecgPIUBzdvJa2Y9oKPIIDI5
 NY+xaNCiBsD6IXbo00Pn0KDtRjQJoztVH1hsiSzRGmck2UKOf6ufeDQ6XX2qOExZbyplDy0Wv
 B1+XwOyi81lF8NTeSyHotCXv4dEhZ3nq4mPbrxMH9IEA4coyTMkCtoy/AUETpEB7AsdrdvN42
 ZGM+/Sty7d03lg3aU4dHtG7MplnBOAT1etk6XqCOFKaobkWnirDHpg9J6kpPyeLpQLoT5PenG
 SAO8CQ3JhB/z/CcZ9VvmTmvPWoqMHri5Z1XdjRlLyV08uVORRSP0L9e8K+xANOqcLCVxwNWKX
 ixKSDvGU4ZmUE7BDE4CWMRK08UogwpaY14XhepluMACKkyIZm0VbVKVtA+zTzhJSf2afNd95Q
 uwbGdgBqNrgTSKFqN77WC69+s+68mAaOsgwTT+F3IIxw8q9xJUGmATmaL+3m1u/zcFrJhn2fA
 7Msyr0UFDzNCXvLWho9D6UnXHmFnkQ2RMHc0idYmk8DKvE0EKUfg648NmQJZLxOGXBpMvpLIt
 uFYsw5Xs2SB7ip4kUbGJiqgtjvf+3ayHrh54QfG+a/LnjwToUp4me6z04BvaGU8WOGY05IdsS
 10YcmoXuqgcy1fos4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This fixes it by checking sk->sk_shutdown(suggested by Stefano) after
> lock_sock since sk->sk_shutdown is set to SHUTDOWN_MASK under the
> protection of lock_sock_nested.

How do you think about a wording variant like the following?

  Thus check the data structure member =E2=80=9Csk_shutdown=E2=80=9D (sugg=
ested by Stefano)
  after a call of the function =E2=80=9Clock_sock=E2=80=9D since this fiel=
d is set to
  =E2=80=9CSHUTDOWN_MASK=E2=80=9D under the protection of =E2=80=9Clock_so=
ck_nested=E2=80=9D.


Would you like to add the tag =E2=80=9CFixes=E2=80=9D to the commit messag=
e?

Regards,
Markus

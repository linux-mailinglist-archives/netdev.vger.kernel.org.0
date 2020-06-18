Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3BB51FFB6B
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 21:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729071AbgFRTA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 15:00:56 -0400
Received: from mout.web.de ([212.227.15.14]:46495 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726882AbgFRTAz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 15:00:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1592506838;
        bh=2ktWjX+z4AuhVxP3y0/uIcFy2A6HcWihvn1RCfDK71o=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=GnSGVZ7DQ1cAas+OHmT66mS1RjNYWbBqoZECyCCgOu4yJ4F1RYKUWAhLPWQ6oI3M7
         X23ExQ1eiMklaDJLK4vbXmlajXQDY56pc1PD/nalEBuTJMNseUcdy0gZs8Sld19vn0
         yCqJ29zk7gxKn7Qg7+9zDg6O8nYXavmKBZjpmRNo=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.244.102.18]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1N2BMA-1ikdxY0VIM-013aEj; Thu, 18
 Jun 2020 21:00:38 +0200
To:     Zheng Bin <zhengbin13@huawei.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Braun <michael-dev@fami-braun.de>,
        Yi Zhang <yi.zhang@huawei.com>
Subject: Re: [PATCH] macvlan: Fix memory leak in macvlan_changelink_sources()
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <5e4396d5-7e89-da5b-f9a3-b995d0f0a7c3@web.de>
Date:   Thu, 18 Jun 2020 21:00:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:4ieuEG8s9pM727CybJ6ILngZ81nBYhJ3PMBrsaUwsI6ydYBPEru
 92bZiAAR74P3JKbs5X+hzHwAYtiVJvEzkCDV8PIBWkU0MAyQvhAdgDK3y5X/IDNAo0EiIJ0
 cLCLIEAnRbYxbpLtXDveio/UNCYLp7DCltLcCsZznWMsOW8jmsXMoZSZJrvktDqQ4PMZdid
 eGX6QecfufG8aOsNKeFNA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:OFOq0rR8Fwo=:x0NJX2K39x7xFZ3Ax4Mumo
 PxoDeCiFmFzSKjywIYWf7L98qb7KQpLkUd9eV/ghdsD1Srv+KBirKyYRLhrrcJGHfrzj79mjJ
 j7Cp8Uent3zFbfDc3/dIpiPKNPXWif/Pngc9bvFZwPT210oTVoO+zGGhU9hHO28RBYl8zGrvx
 X7zeVZmDtPBYbPLG98Z176sXoMj/TUcgEoyLGYhHUTkwkqRdNV1ptJwwTFvFeDaHlpR78n91p
 +kp/8ayWWe4juYQuPxeU/3VvCYu1VoWW0u/Kz8+RN32y/A3VgCayZXyk0I13SKOV3tUVhXERS
 MzUDKlHnkuEVfUTZwKHMtPLQfT/L5Y+LzHDc3R975aivSlIoNjpip43/nXbbHF/oD/33bYO6M
 5rYKZS44ytP19BD2rjlKW9Z8e7awKcLSPtjGZwS1qgbB6vkPNzkYGQsPcReL6YL5J2fF0f5Op
 3An/erWNtVtrF4i8zuw7Ad6sP0ZZRtbahlEKE01sY6Vao6KLv5Uq5ykH3iWpym1dwGvjz1JKR
 bN0/LeETF8nSfDfM5pUYs3d6/vAJfLJXKHsOszfecOv5ReFV5revsZBSJ8Wa0UgEEU6r1cS+P
 TtPr5HSmeHPS+ypYw9KtCwNa/V5EYsVi3PafNKUGIIsphKRta/ji66QDABLmOshuLlOwYVGHo
 L5I3nCpg68kjN9nti3TDPGn3njlDXXVh0LCHao3auDcxSFyCwPn8LtiwpizDmJmTqJcu6yzjj
 qtjLXM17hQL20UbQugt1ymnPEVWlu4KLxQ8jwEondlSKRTSLHp8yuKuziIFqFon56uB5wnglT
 GpHuTnu60kDIBR7e/lolZ7tfYwJQCSc4+hDWOgh7VtLiSIbpRKVJMcQ/ArMbaStAx+1LZY4pC
 5VGIV+sueFPi6zZabv37EOlzZC3kdxhy7Hrsfb66ot6dtVzgaDcQ+1zjMJp0374/6R97jXXPw
 8RQ8+saYeevjyHbP2/wcuoT9OqyqYjsjHau7AOxfkMu4N5A4Y/uBR0j5zkniNdNi06ltkifYd
 rtEZ3iaWw6xNpnFUv+BncKkGgk/jw41kp7FkMXLmwMrZOvrG+GP4/0lHNRNc6P0KETbOhTq6A
 f3PKuxNF2KMUB4PALuvGWyJrzbKo3iArWANSgOAqQK9q8Ayht+64DiiPq9BugJtGWCTWLzm6u
 kdgyITDOYUB+kpDUw8dHXMAl2PIEbvfW0MnMOXiIgdoE6J0QwRJENmW3A0Yqp+dgiIXWAOYDn
 ZHmoZg32dbXCe5moq
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>     -->If fail, need to free previous malloc memory

I suggest to improve this change description.
How does the proposed addition of the function call =E2=80=9Cmacvlan_flush=
_sources=E2=80=9D
fit to this information?

Regards,
Markus

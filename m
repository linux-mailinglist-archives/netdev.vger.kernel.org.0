Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBB79221C8C
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 08:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbgGPGVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 02:21:05 -0400
Received: from mout.web.de ([217.72.192.78]:54115 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725921AbgGPGVE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 02:21:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1594880435;
        bh=hdCH7SaYt62vrtpJuP5NTSPx6/mox19FQ0HXVHVNdtQ=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=ZsndZeOcLo1zzUG50uv79Bqc5GYXqsrV8btnP29PVoj9XhDNkoBjDRREjLA/1DJ+l
         eUZtJg6xeWjBhv8WjsFYlw43mcb5FI5inujf5IIM0SVOnQ4O4jIWyVnpndhuQflLzI
         KLko6cFrWPMaIU3XxcABn+Zbxv+Gf5vx15Mf/ulk=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.48.165.142]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MLifq-1kDU8p0Tia-00I2hU; Thu, 16
 Jul 2020 08:20:35 +0200
Subject: Re: [PATCH] net: smc91x: Fix possible memory leak in smc_drv_probe()
To:     Wang Hai <wanghai38@huawei.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Wang Hai <wanghai26@huawei.com>,
        Shannon Nelson <snelson@pensando.io>,
        Nicolas Pitre <nico@fluxnic.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20200716035038.19207-1-wanghai38@huawei.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <0f8fec15-aba1-17a6-88a2-971872e2f6f3@web.de>
Date:   Thu, 16 Jul 2020 08:20:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200716035038.19207-1-wanghai38@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:aWw+EZzL4cffL+TmU10ndQWQ29E4T47JD9B4c5K5vunq48TIEal
 +bZk9XHGx0QJHbEqdr3SjD9Y+8TZ2k1HkUpT3ET7/L/nPF95oLppWpmIunZS+pzs+IU9CJL
 3yUf0qPOiG1vLAWZzD0tL6nxDwbvcYCZ4yCosBWctGNIP10VjLPJttHLWGuzktTNjedJ3ZM
 tvi56RQlbkdQy4fNgxz0g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:1y1aZ+IOhOs=:uFQILoHvRsCx57/YIWiHDD
 oWkXUJ/PbnJx0UX+nHSklDrVTjakjJptQP3/W4ukaqJfJweed5V7rGprrUQY6hPdcXP7772gP
 EXQV4NKfQMmkKBwqg+xx9xbIAXaKkgInCCAWNDg9GJEjfhRWCyhEHCIwmdJMvOvP2EHOBaCjj
 rEKlcCmw3T1bMTTnpNF5Ul4ZAM2IG1QRIdAAhTN1opPtS4DWPebu5K8drkZGACbPUFKkTDHCA
 I1jRjg9T+B5H1zu1DDfErXTVv/VIECdvfuKOtLVy3dxof8DCuRv0bLzzFC2NNLNDVgpnr7PjF
 h1mWNaUgzXGz01cbPrmdY4DHB0zhVofc19u2nxhb6NkrgXLypvZAQW4zAYiLjDJm3nemmERAx
 HL2gUN3zLD4eW8lgg2FsgpRr2iN+HioIT1TPWmYQaz1QagnShbTuQtMYZK4vzQ1V6kESGWKQh
 BskMC/KVwSAaDVFdQmXT0v3Zl1rfU2NRbMxqup/RFsaIy1d/Te04XtQsCcmQdQEfOo51dXhZ/
 cq+e589cD52uPYWSWZTpC4SO6yWVjoeVl7AWvJlT5c+XVN7s/KWeEj61M6K94WoVyKYekoOug
 AKxYqwx+PUTZynU3djFgbAYOivOMsg9VZ7UpzgozkbwB+F2xF0yRvv+ARpdOQ9+WD/wM+WEkx
 RHOJHKLw+sX7o5z7NDL96cy6l5WqpMHKbLwZn2qhm3Qey7eUVQPCnrn0uk4+6cFjBLRP2Fh7j
 /YfcOUbP+X1VOOYy3C/J9crEVmecGT4rl5SmxtwhhZS6AhDJ6Bx23wzeSMoOFaz2O1G2HLj1n
 OBvptt+vXe3paFneD3qNMmE4fccYTRP9hD7xjb0mw6W11rpsP0qsxFiHP7c/1QHQDN61ta0Ew
 39rkI6Pq1/pk8xrMeXybKsiDgJSjLpflYnMyDXMtyDuhiwYv9/9/u99pDJ2/SubD74GJyStmU
 AXL8ONPlAMKYIHhANhTuwiwZQVLXQQiY8Km1Co3samb/XPATHqkZuDppLhWuA6MUZlvq9g18F
 Vb8JqgwrApp8NCjVhAdJsjmKS/7SQ13AK/RzepnzATWY+vAWpU/tcb3ozTaW6gfLEqIse6xJg
 vBpW5buzml7FIJ/sjlq0/zJELtRawvwlLnrOX2STBiIjwhyz88qLzOhAqi8YSgfn1R1sLx6FJ
 mlHyT6SYEr4yREloFt+hSPxZyM0NRr9qIjKJn+5l7ZbefDonsqLir+WFbG24wK8iEc2YAWlYp
 qKfxQscsPO8dg5gjUNVUJjpTeCxVd94lLIiOGpw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> If try_toggle_control_gpio() failed in smc_drv_probe(), free_netdev(ndev=
)
> should be called to free the ndev created earlier. Otherwise, a memleak
> will occur.

* Will it be nicer to use the term =E2=80=9Cmemory leak=E2=80=9D also in t=
his change description?

* Would another imperative wording be preferred for the commit message?
  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/=
Documentation/process/submitting-patches.rst?id=3Df8456690ba8eb18ea4714e68=
554e242a04f65cff#n151

Regards,
Markus

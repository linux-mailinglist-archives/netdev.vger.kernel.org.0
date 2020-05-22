Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E81D1DE006
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 08:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728234AbgEVGgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 02:36:40 -0400
Received: from mout.web.de ([212.227.15.4]:57183 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728125AbgEVGgj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 02:36:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1590129373;
        bh=TTFsG8SgLaQVd1eKAWGA0N4CAmOJ8fhqNtjh5AXvU9E=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:References:Date:In-Reply-To;
        b=g9xfwbQSgloCLRYJvCYqenpiQ+6ukDtIRnJBpJpusXJsnOD6YzU54PY16HCwfgs+x
         4cUdlstHc/TjiwO74p0p51JZDPH7rAbY3Hyb8BwQ1Cuci+qOjMe4z4TDVF/mydbMLU
         BsW9J5zeCDldpWVs2SxUn+t+EURFI+eldyD6HCsU=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.48.165.155]) by smtp.web.de (mrweb002
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MS1xS-1jUm0s3eeo-00TBXi; Fri, 22
 May 2020 08:36:12 +0200
Subject: Re: [PATCH] rxrpc: Fix a memory leak in rxkad_verify_response()
From:   Markus Elfring <Markus.Elfring@web.de>
To:     Qiushi Wu <wu000273@umn.edu>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Kangjie Lu <kjlu@umn.edu>
References: <262bd413-9be4-3abe-9565-ac37a2e2e719@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <a19d0395-c3d4-af1f-55bf-bc130e1ebadb@web.de>
Date:   Fri, 22 May 2020 08:36:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <262bd413-9be4-3abe-9565-ac37a2e2e719@web.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:uDRaIi+45NtDoxvNVJ0gnIqt/HWV8xQa6W6/R7923HhKFr4vqnC
 WWYOE0VnJ159ID/eW8EGJymHm4gh6pMJFVcSYHClS5wQJNwm2t71jwF896QteGC7mJ05lhT
 WKoZRuvZm0OCvEgA2fQybB9fT40yZ6+cIkd43pFUdigWAIbz1q1H4E1j1m9KT5YFFBb6iIg
 mGkZwWCva3UNos1H4q/ng==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:2dai1olasGA=:qUNYJ7qx87fAFTHD6CkFRx
 W7UjFjQZJivS/OoFXh5swu0qKwHyKUtTQaVDLt/5MH3NarrikXjV1qvAzLf7ZC1Mkzug5luFw
 uoYY6i7HMKXxAjlmD37H7+jK9on0O4Ve5siN0T8hgI9m9MVk03YpwJyBGi6YqQYFoB1av4hNt
 QY/UVnPCU6tB0yg/n43ssKeHHb0jmnh/xOWBvnxKtxIuKs0tzqVXNExwnBqovfOUmuZ1lH4OX
 nSqMigTmH9NBGsCiEQSRRYdHp8f5mzb/AkYkbAPo2iBLNbO94/NzNpmU85iTv3hAA5nRxfeFM
 Deio5+YqHI9x9JUNIFRwG8rK6gSXI9qMGU6RaTdduznN/7+T+7PnhWWwwVQm1HLnTbcozfEPr
 lxLhFE7TnjVgO+/Oq5y+amYG7STz4GKhplvyjmXJT5EOOk7uxuSUVdx15uRyj9hh4HuX+q2bA
 nHKeXyCbKlTuzwLKFiKht9fGf5ZZEITPScyL69cAO94ylsgu8avdzb8yXLgwCdAHBcArCVDJk
 bV9FqWwQkrzMfRWOJpvVybOX7VGXm4nx56/UMllAiRJzl1jKaD6qMa9/PDNgvwULZ5w9UGzMy
 Ax2fE4yeaAFRhzfCkhVcrfbh8CzeW/iDVCU/N7MzsWmNFW7VgZEIyDcE0n/P6oBUiGRIDhikL
 vW/8YkLRXOXowIQB6B/Tk5gfxpiRPGaYPyjxDmeu3x+JKYeFZFQWpjFo3Wv12UXSOXdaGztbE
 fy/JaqZQu7gxXpoqskn1t5QaXpn2FVjwEHXkAK53JeNdxmgE2Sv4LQOT4TesMDkxnzqZnUGJN
 mYlufKKI+pmGcvQic3pc28myL2nBPF9GDEA5ezqx0RrlwSHxlXpd0WE6wAL62bGdNHBScSfzh
 8b9fBMrmVzcD/HqB/xuSYX67E69UYwFFJQvUV4foQZ2nxSS/O7bmVuc5Vv2F40EOcyrCMZ7h8
 eZ2+eyZLCyxdWSi2pPbq1R9PYsTBw/79vu5RPn3HBGEUCiSUWCWjw0jVbIRJHftHi4Q08Xj6x
 dO2N+91c+hur1SD8n2IF0ZCpKIzX+WAME9tgm0zgfQuO6cK7S11W/JtzeWfciAOp0a4CKDPoy
 ipnMP51tCSsaxtMtmBoM+x0BBC1Y0xgFBQxdpEr1Nn9l1iMnIm6iK38TAwCVV0rEDQFL2EVXF
 23GeGdBhdan8QNtgDU1Sw4SWSvewbsBYISse//l5bMtSW91NUSJ7+ZTJsXRvutQ3rkKnvBBqd
 38Q4BlbbaHZoZJL9q
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> How do you think about a wording variant like the following?
>
>    A ticket was not released after a call of the function =E2=80=9Cplatf=
orm_get_irq=E2=80=9D failed.

I should have specified an other function name here.

   A ticket was not released after a call of the function =E2=80=9Crxkad_d=
ecrypt_ticket=E2=80=9D failed.


Regards,
Markus

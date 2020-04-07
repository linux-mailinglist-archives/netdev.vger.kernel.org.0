Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D67901A1077
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 17:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbgDGPoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 11:44:06 -0400
Received: from mout.web.de ([212.227.17.12]:46759 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726760AbgDGPoF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Apr 2020 11:44:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1586274192;
        bh=r1jnwzyblYdoTJn4uj4aC8lYZJHJpofVyJNK1Ely/vA=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=WsMcC7kKyK45MgoysQLEVVjJBPRSJ3XymgoZNiD8BPH9Mas6rgpw8EJWYpC7B6kab
         oP76oKWOgGHClqHPEL7iEyEPqhgPD5+OsYfLhEryQrcKnRfmS+dvK71/z5tLY5Tf96
         yQH1rmPY0ZrCEiaiydv3ORgaEk/gmP+vaBow/3Fo=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.3] ([78.49.5.104]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MZDKy-1jaCOp3jJM-00Kwzv; Tue, 07
 Apr 2020 17:43:12 +0200
To:     Levi Yun <ppbuk5246@gmail.com>, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Guillaume Nault <gnault@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Li Rongqing <lirongqing@baidu.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netns: Fix dangling pointer on netns bind mount point
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <e27e25cb-738b-1260-4be6-99728acdbc8e@web.de>
Date:   Tue, 7 Apr 2020 17:43:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:r3XvxNrDQh0NbXtROKGOmlyZghQJOH1Z9rPxmjeC1zwUkPcCecu
 MiMASVW+gYj4nCnPNUAQ2L/B+PBwlAyRYpAd2saUODLSfNCpG67641h20WBL8jO6fDI5ZaU
 LCn/hnMqyNAobgkxde3oniuKiaAlKMDZttH/ch+bFt69lgIkr961CpBNTlQ7uzWiokZpmYa
 aF+J/jmyjWdSU5IhLtjlg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:tb46XnomZLw=:a/X6/D4+kxmu7PSSxrwh2M
 uC5cxRLWRjx3Q4aSb7gTi48CoTL1EZ72bHz1Txpd6mXMarOMUerE8vNNtXQ8qV6QJkNW+p8Qg
 DmMlQC85sfo9NN0KhsvUD7W/EmJtCXzTmH59mOdMAOpBM0fl6GuQBd2PFBlUi6WDksWbcn6/4
 UDm7AYfji/y9W6X0P1l5Xxf0RDo/dEU4kGpjyqCeULPz0qXkVTih7XLzm6n8EmFl2cU+6Hxf8
 n98mbllOYIkxr8n8Y6hjZCqSJHeGyUb8MrcnS55JD6Vvi36vHK43WuoV+LOxndfa9YHJsrYmM
 K2YW/bY0IWIiwnG9bLVvJeT8Q2UGeS+N1G+0wS7bPJNoXVLyw+bSYg9DFbNjLGUXNlAXiMbK6
 i7UMqaRvCTPd9IMgYLFxNs/ZxkT/rqvF9sDUMeqZWPTQNZZqSVfpiKmpn5sCaoaLT6sinZsQa
 q9QjF9wfK+9WIMGq23qv5WNIWDhLgnMzBufaDNiS1wgtbjQLb9QbC7PMTDFwr7gbIYsVmuulZ
 lCYPpiP3fqmzsxqZIzBWtKE5RjU+mVfWG8bzSpELBKqgoEsBrUGJ4kK+QrvzmvFM77Hb0jU1M
 UdcRaR8uv7AsLRHH9LJyCTw+hAkFmwBqoRwIg7E2/8KgILyF89UBMZUdAd2nb1xSF+lKIX1Kj
 LiQoRmyofo7wSZaE/Flachjjb+g84OIa+ADOmNsMXE2UIR535ttp14cZ+NBL0f5p6tk4OGriM
 Bdu65aOw9ALIsUsIZ2UOYHhRcslgyeaV9YhXDDHukgEkwBMbvBs4KOJWnFNZ+56/MsXJbeE6S
 YTuBv1xod4Yvz50MB+ECBOgtTfBh0QrC3V3vUVOH3BvsRGz5ysrU2IbSQMnv68i3gE5IB0oGe
 ok2l2KJVzw4HLe4V5JUOUlXghJHEHDg3gkzqZh4BggjQSUyO9bHI/3XSGX4z6JFF+X0rNb/Yc
 it4iTb3XfeKO9hTV7D7j8gFJ5TpYRSjNRhjMEHcTO4AkfTUd10EUMIZEWwB+VYhzoVncEaxMp
 mZoRsq3PC3B3rkTgEdcSXRWar/JsOJQ75XACaSuzDcXid5nKEMVd+oxz2ludhKqqoDFdurY+/
 tj3M6d4WLEutfkNtxpG0ESj2Ksy8KUkZ2ZxUEa28WkKHMVDEjzAj1te6ZoqQI+jY7Hh8Fu1jZ
 5YaMpunNxiQci8rQze38pBb9OYR1tLtNvQK2gWoAaJY1sZ2eMvPtWKAveC/Hle4EfixBxOXFA
 IUrGht0Y9ZPh2OmhL
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This patch fix the above scenario by increaseing reference count.

I suggest to improve also this commit message.

* Wording alternative:
  Correct the above scenario by increasing the reference counter.

* Would you like to add the tag =E2=80=9CFixes=E2=80=9D?

Regards,
Markus

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16E311B8896
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 20:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgDYSrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 14:47:25 -0400
Received: from mout.web.de ([212.227.15.3]:45125 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726145AbgDYSrY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Apr 2020 14:47:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1587840405;
        bh=VaUeqgskQKZh+Qzi1V4x/TGdG1hRY8f7eZKK49+h1OM=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=DNFJyLtsacNsyacwtLtT5VWMg0d3PQDPyr6avRaltLOLsuUlZUWe1jVRuyn8vr51N
         KB4ECopkN/dfwHfWlW/atatQ1/O8oJs6n8fRbnsso7dS3JP+JULN1al1V5vkgE6ODi
         7L/ncpYoQFYZx7wFmaDXo7tNQLSnR/1G6x4B78tM=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.49.160.204]) by smtp.web.de (mrweb002
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LfidG-1irUa71Z98-00pMzi; Sat, 25
 Apr 2020 20:46:45 +0200
To:     Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Kangjie Lu <kjlu@umn.edu>, KP Singh <kpsingh@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Yuan Zhang <yuanxzhang@fudan.edu.cn>
Subject: Re: [PATCH] net/tls: Fix sk_psock refcnt leak in
 bpf_exec_tx_verdict()
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <4be4da0b-1b1e-44a5-0f18-70fe9af842d2@web.de>
Date:   Sat, 25 Apr 2020 20:46:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:I0axnWx3yGHCaEbrUUrqguH3lGNp7/MOmFZon6TNWiV6roDuoLd
 qx0rdvS3tf8VvfTa28GQgGKtOXbUTJluFwj1HlVl9WaQOIkkrvwaKPGH8FhhgoTrUGjZqZ7
 /ptR7Yj9hwZf3PZrgbVoousSwdC7su7UiA8jOisJlbUj1b9WRIbGHzXE3uEv6nwGKJ8RHp8
 O2c8VTeicF87IpSf2JsRA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:k2DSoT5urf4=:50Eto6VVvTGVnI1KCjhoN7
 AASuFYqGolNeuOVuodr/OLXXSlGtpraT46Xe8k4SXxEBP0ezJ40YpAYSC3X+a5JDQrjQjMvZq
 RQ/4Aq9n0KSXqjmMClOyahOTPt8XipWDEnGlAV38bKI9bFkE7jRZcXEEhWuLLVvibqz0Rdc1x
 q1MDGv3raUrpNmXNBFCCEBt6eudV9Ee6Sni1xDkIxPbT8V2QsuQS0Qm+0FJl2i1qDFceNCQp1
 upbBkGa1WThBbMF0X4BsD/61Wtg1ut9cuxeVvXQ79zx19F5LN7PB8MxcZUHCS12i9f/SccErW
 7wpMopE0y1dRBRDCDcdFiS7jgA7TMVJC+lWkmc2WXUzZqy6haMMNxmdYEzRx0zpgNq4ByE6MU
 fYHtpHhWOG63LwzDhTZQ1ivjAzlmQf+r7tdpVN/T8Dk+njOBjmEKcPXnsz6NE/4JynQ+3UYxC
 s7+NhLy5mLlQayGqJIrOJl02aSsuahhbKhOHn8jbxl9zrYEkhDmgMTvbbZFbZfh5y3oq9U1V5
 Wvx8MEzTJFVs/AyS/x7LFlj8mjotqdsTpxg2bcO1sd86zAoFT0A64cfVbqJmYUVYTFHNrdMal
 Lg1sx4ME+WEjNJEVqrmnt8P+lHYg6fRBikNJ4A05WKEBan5PE8nSTbGgftdrt2zAEplGieaVn
 eJL/6kF5eYtK0YxdHphnzcJc44gN3gEAjRspen1UoVasLfjRVVbiNlYxJ09lkSy8IwCwM4BTW
 zLtxDa4lXP8NWNUYr4yQZIJdCLejJVw+REvZf+5zeZ8b+rPBAcmnRVgKz60hifv5te3CwfFPB
 DDxi/Vq07/hhTqSvrFawIPunafEZsOlotaHftJpJojYzGcvX1fMSqdAGMD2hPgwdlVv8duiWr
 4z6fdlltsI9ADVnkBoQ84sF4UiyARAAytt/bucxe7UD9GOwj33qMQuViBuhmDNAW/fcnDusY3
 XdiLKBQG7Ef0xfG04aC99krv2FAoqTfnOq990hZTW+PgoeGWE4uRrjnvAi+HW8HNWHGxB83BP
 Z+pkSoeAU6TF3vqrZEve5dLXuYPTQGY2s/AmmrTcuIzeKaYA6jpSmwrpgg0RM3yq6bfZ2MN1A
 UFgkkPk206lBlH2ELG5mwR/KTlc93Xtpb8heopeoznFy8FJaOQKP2unMMXSTSiSa15Hsm5QWE
 7JZ548h+XcwMsk9WgkVKUbhfnnqJQa3PMLvvwDc+GLW1PYUWpiMHFW2t2plHRtGUPFD2Dm61H
 +n/DdQAyF8N5QLzYx
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> When bpf_exec_tx_verdict() returns, local variable "psock" becomes
> invalid, so the refcount should be decreased to keep refcount balanced.

How do you think about to mention the term =E2=80=9Creference counting=E2=
=80=9D in
the commit message?

Would you like to add the tag =E2=80=9CFixes=E2=80=9D to the change descri=
ption?

Regards,
Markus

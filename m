Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1056F1F8146
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 08:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbgFMG0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jun 2020 02:26:46 -0400
Received: from mout.web.de ([212.227.15.4]:53359 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbgFMG0o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 13 Jun 2020 02:26:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1592029578;
        bh=k2s8eb/2vmpIhCxWfTUYQO1d5bc6ZGIHEINUn8mcBYQ=;
        h=X-UI-Sender-Class:Cc:Subject:To:From:Date;
        b=pwf4Gy1ouTee0XHXCHwbw69wX4wC8rDPUX9+p1GbVlnAWHRtLcJHeUJQiQvQ97k3F
         EWJwhqHTz/eiZvlzFms/pKo7wvKlUCLYD0YTELqb8OnikDqu9qeNknHlb6UDoXitI4
         UA5+ZMj1C3cdEq9hfitpcAgaD6KIS3Sn0hHEBjyg=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.132.51.155]) by smtp.web.de (mrweb002
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MGzK6-1jg5sp3duU-00DohX; Sat, 13
 Jun 2020 08:26:18 +0200
Cc:     linux-kernel@vger.kernel.org, Allison Randal <allison@lohutok.net>,
        Andrew Lunn <andrew@lunn.ch>, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Kangjie Lu <kjlu@umn.edu>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Qiushi Wu <wu000273@umn.edu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] ethernet: Fix memory leak in ethoc_probe()
To:     Aditya Pakki <pakki001@umn.edu>, netdev@vger.kernel.org
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <2a13092a-53ed-bfab-0a99-08196ad22f59@web.de>
Date:   Sat, 13 Jun 2020 08:26:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:1vvjpuo4KjUv3OJpsfh+xNe8zatBcNeqekGMOmId6Ghuq+fZafm
 98rdcmd3K0k9lMBL+p7KZ1M9j/UjG8D2MMtVN3nSNIy9HmZHTWJv/tL6c/0V1yD+D1I5Mw5
 sb7iimFgxpk1rYecMRzva9hcQ1RmMIzHfKloDiMr87Ee//xaDukO8pZlZRvbRF/3JjO3qUZ
 rdVjuYfdHHOJ/2KJQ/O+g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:p4UWuv8jf5w=:NZL3lzsVFd9Xuuoev6YIdC
 xdVRzGuAQJWLC9RhTdJ3h1P97Q538fn9KZmljwvN4MFDGAjuSrguUTNXOCwtDCLg1UPCToHLB
 +puyyJU6LHhsdSIuP1sCjL6CX/1Z7D0ZJZU53EIBFy+CiEsgnzlUsY3I8E+se4R9mSsmkPIMb
 TKQGrCcBc3nXJEiTMDstlxlRT7cbmcU5jfzl746cjRf0G2FVafirbOhO2MxQKUvn8NeDxDrZG
 vtOsnKNAOFcjftvg+zlrbZZAbMfp4SyJccl+jmD3mmQBzUm2YUR2y7CW0WgS43RdaCWsdIzAq
 UcONW80qWpSRL20PYJNrwBTw4ttdmWINm/fZSS/CQi5iwhZNyCyGR2ycRd2FIjz6OdZfagHxA
 GgvFQITS+3PV2hsfo02jDqWLzNDaobT7Pn42XyIRFdxSPxIX1bYMe7B9a/ADliCKDjsb/VvmN
 Iok25w+uMsSkkMdvZd4EUrmzC0+lbFMTA3k8oiQQ6HHdtL4VJalxx8/IOfratm/iWZgPJz3m4
 P3JVeItVgyTLCKqYRtzVx/2Wjgskp0P5Ix8JUelaLe+F3WD8Ovzkg8+Mr2trx4/feXY0j4qw1
 3xZ8lPOmb08l/nbODrvqMgShstR3iXo8XRqseqrE/U6DEQwjiDmPhGPeOPinKsqNXnxJ/aM0G
 lSGZbuLQuB7Sxdhs0xOH6p73h+inwjH0fY2atPGHpvUVCpZLhthau9kJAOetoHV9fwkE00Vxe
 e2uPbowZJY70Xpz4SZ46VUnNBVmLugxQF04nnYcpIh5jJI+RTFodI5Vto14ade1FCBraWnL/+
 q1iK0ejJ1QW15Ue/i30Ydhxh6PbdwZk/ZzWKcM2C3aZ7LHolb5iFMxLlE7H5wncUUmJToCd7f
 uGCQjhUrqWQLW2OlBbvTZomUJIAl/e6QP/A4SmPlidCa1z572xlVTp5Rzv0yxhNLfgTo+BxKE
 4cG1Tm1qzSZwoaJuq7rXwrOUWM4vb/Ya9D6Ud7+E+G/Rerz+a3Ec8xx3SdHwZWiuZRxiiUQiN
 7Dfga/IDd5KcyaTieqSpDCCsfPkVEnla6UzrQWlbspaLiLT+OEP69qFX/Lu0MMCvvasdC+fbP
 oS1z1nxq9NdUOJDrS2hyS5FAihPz6pJXThXiKhlTqyGAPxBZ+rjqRtCRDzLv07EDDGWsffthj
 lCo/n6m5LNRAlSqjLi0wDbf4jjvWRMg+2k7rbEqtieal0sKPkqFGxz7UkYXDk5uS1EmsHEnCm
 Bxqt/H6Bzi+tquqrj
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> =E2=80=A6 The patch fixes this issue.

I propose to replace this information by the tag =E2=80=9CFixes=E2=80=9D.
Please choose another imperative wording for your change description.

Regards,
Markus

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E41A311FA88
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 19:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbfLOSuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 13:50:23 -0500
Received: from mout.web.de ([212.227.17.12]:57993 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726146AbfLOSuW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Dec 2019 13:50:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1576435804;
        bh=cCv7sJXfJnO1QQcnZn3J3mtAlYRbJz8IbfwwjzYhvZE=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=kZybwPg+QqeD2tv7u1JbSm9gtaXFGDV7VXY0l3++CfAKzV+ge5DCdxHHRD4ZQhEyC
         TvnDCzNoxRsLpDzmtnWQC6icwB0yoq6GiFbF17d7srjzUbvD3P/4AE1OjCFsNv0E8h
         uwV5kvQaUkJODE2wDO0dZYDK7njL1kfEkUb3sgrQ=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.3] ([2.243.76.50]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0M9GJ0-1iYMZG1bdm-00CjXr; Sun, 15
 Dec 2019 19:50:04 +0100
Subject: Re: [PATCH] hdlcdrv: replace assertion with recovery code
To:     Aditya Pakki <pakki001@umn.edu>, netdev@vger.kernel.org
Cc:     Kangjie Lu <kjlu@umn.edu>, "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Richard Fontana <rfontana@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
References: <20191215175842.30767-1-pakki001@umn.edu>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <e43a4b92-c236-8f79-ffbb-60bd4bbcb065@web.de>
Date:   Sun, 15 Dec 2019 19:50:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191215175842.30767-1-pakki001@umn.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:LTLaqZLehBwVqcibF/rrsH9IaHsL1Y0SiF58MechtcVR9LbsXBx
 cV5++VyOuoaPqdPBQEnlu/xAhP+S+f4n1yjOwyPeQBQpdssbXXtyb0y6Y164Fgw7Cuw/rxX
 NavtM46eBfPZidlLjlU63LZLSKXYTqklPR5m8u2ql9989c5XqJy4iaa+oCG7vf7HzTPnz7c
 TAzQ3rfUgqFx3wFx/oWng==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:5xiAHMmbqUQ=:WsezQUDEglUue+evouMb1j
 rxeldg/ju4Fgyds+xC/wbB6qMglz9y+O8wLFFj/kB7F27NnuSR2WvfNki8jaUkxqNgELof/lr
 zU4QBpeMLt1VWSlYMOz3pjiCWJq3uhLesB7fmVEwOiH5Mbqvnc6Eiy/FoPeaRP3VZP4kMucKi
 Rm8zhV9im7xNEJzODU3F3ZU4a1OE+FuIo1bzdkM16DfcQGLwlvgk+E9mjRZ7oLs3xOuK+3t/J
 DJsy7lY4zbuUr9NzJr2j13JnwGPDbWlcqy0ctSBIK+uFmruSGKrub0qpjaeahRqgME3ih6RyO
 mNBxYSuMPGMQ5dEOLLl9WP32mhN7VTpa8F/1Wwq0/RYv7+RsdXiovh7by5Wf5vMXc+CkZh6+n
 vRYbHINFtXYif+y9SsJ1Fn4NjPH1EE0cDRa99JmvFgb+wSbscErDIzg5GegX69ISE1PtRU6Us
 yy1rsitn9tqyYzeNm63T9tkNqbhn3W75CKA+5adSccwBqcJ2Bxz/MqLMTZ7ma9GFMZXsW/fJh
 FcK5ETGhv721hWAW0LVyxtAUH6WfMkjB1//Oojbt0vvP5g5CwVZUspVb0BtyNPhn7uuXLmCF1
 YPFKWHVx4Rv2trPI2FuoXtY6/CcEiWVcOBN6f0CsiPaM9QVnoSXVaOaqm7WvtA7V3LizP4wIs
 UTP4iNSs0exbTCrnvlyupFuwx8xomiEO65Y3+eNv6v2Li6P7NWKkLiZ5NVRbPrfyn1jC2LsGf
 /hH1WfIEOBMmAOTqrCKYOa+cnX4REuZJuLU+s+z90NlXet+7UXGXASNij+5oQGbNTw9+j1I8T
 wEDYMrV8V5s7O729PGE51jRzop3OfT7KlViFccx3XQk991i3Fm8LQPqdkW+iQbINwIoAQWJyC
 47COMet9JXHpIaXI+iGQH4JWBuCtECuDzNri1a60QRjwDuUc3/bHN2w0yWtREUpis2J5nYZjA
 s83LYcpXS3knwvoZirthSMUZvA4mFs13p8xW+52fC4xpkIzozvCi+JZ+4AbvGnizbYOrdaHwd
 oWgvOGbKwrSVcf3V4sqnSipPwAsT9U7iHdaOaK3MRMBRqW69eFueqLtpRA6X+wVYNisoGl9Vs
 AWPjFy0qdUkDffMIdGE5wJZP8EtYEmwgnEMv7rM+e/3P/Vfs96m6ziiuPjp67ehJPBnBteY2O
 ARrzp0QKAPPLCFG841wuVw2Ca47AdpJXV7NbSlEhfYAMT4LTi7TF0fFAvOEqG6+ikRVma2Hpt
 YkAPyNHW+iHW4q94MCZbNfz/Lfmb8ToA+J7mPGvOHR2Ljg9e8leZALHOYeJE=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> However, by returning the error to the caller in case ops is NULL
> can avoid the crash.

I suggest to improve this change description by choosing also
a more imperative wording.


> The patch fixes this issue.
Please replace this sentence by the tag =E2=80=9CFixes=E2=80=9D.

Regards,
Markus

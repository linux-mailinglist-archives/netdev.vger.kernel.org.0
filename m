Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD6531075A
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 10:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbhBEJJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 04:09:38 -0500
Received: from mout.gmx.net ([212.227.17.21]:46547 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229684AbhBEJG5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 04:06:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1612515907;
        bh=pbDogMlDk5cmbqfTE02IuFTpUZE8rtRNRszs3+XSHgw=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Z375y+J6Q11mWoKTph37RAz1w6bnWW3sGDGq65h+vMxo+6hGA5rwq1a9UHXBJlvjp
         OGdRwiyFa222kpBUhljISSLBNlWyYLyw+HZ0A8da7k7NZixVy4vc4eTjRrY938YsLh
         7xm8nt/HRvnM1vWhkgBIBbPxm9eQJQXdw1ybGsFU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [87.123.206.138] ([87.123.206.138]) by web-mail.gmx.net
 (3c-app-gmx-bs43.server.lan [172.19.170.95]) (via HTTP); Fri, 5 Feb 2021
 10:05:07 +0100
MIME-Version: 1.0
Message-ID: <trinity-bdbd75a0-df3a-4b34-a8ca-b812c83eb6ad-1612515906996@3c-app-gmx-bs43>
From:   Norbert Slusarek <nslusarek@gmx.net>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, alex.popov@linux.com,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net/vmw_vsock: fix NULL pointer deref and improve
 locking
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 5 Feb 2021 10:05:07 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <20210205082038.ziaouef3v6hhmjow@steredhat>
References: <trinity-64b93de7-52ac-4127-a29a-1a6dbbb7aeb6-1612474127915@3c-app-gmx-bap39>
 <d801ab6a-639d-579f-2292-9a7a557a593f@gmail.com>
 <trinity-efe6011b-4e34-4b7e-960f-bb78a3e44abd-1612477362851@3c-app-gmx-bap39>
 <20210205082038.ziaouef3v6hhmjow@steredhat>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:QEtbj1JPVhELlrjx3DQWWKug5Z+4WXkd73wOJweQJphseTs3nFMJxlf0jadR1TxTode9k
 VNCZR5S6+EA7+JeD26A+solHPsteG4PGclXF8jAYJflxAOMpm8xv5vVIWkz2wy3plxUTVoPeWR5k
 ZD2hPjT8lN0HOzH0Q4BGdIs6a82MhIAMnu3GbJ2tFNjA1j4SFUzX/+8NVMjyQYUhtefIjf11e5oi
 ryDFAvyWsmmFIfduql0pzYqGw4TJ6fQRbCu7/7cx5QDzrhea21mmhVjuD+gjOTzIKofp+ahL0Thg
 B0=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:k2nr5xMBWqw=:LdTdE0izsxdvvZ7WcZU8cA
 hcjDdMxKx60ilIe4rfKsYokYPX/BAjFuiZMqvSVtneRGVNCuUDh6/U0COsxMYS9zBx7zU/FZV
 viiCkaTfKnmyIRHpDG1u+pziIqnpLY4gAlgiBRIIqPbAq1EcX5zVWqUGLsLzaOJ8axMenpWHF
 KBTCkFUFeTTmRZK+PdfozZgW23E+Dc/o0SjgB70VXm0VgBETnwDegfhepJ9wPuwNQge4r3irc
 dQqzyfaRu08dKXOluyVCbtc+jHy1Ysod8DilJy+W1VPC+loLss4V41Lavvi6dPEy2zxqnP09t
 aRaRoqD97XzH2iyB/Bl8xyiYxxwu2DPPM91YNAAM08x9HXIczPu13tjPjcTeLqnehVjuQ57sD
 81o6s5nbCPOkEfA4IcCs6JcznYH4L//esQAXSOgybKUMxy7PEA/kVunE+4q4VdUxtF/cU5ddN
 +kTMWoX9ROK36VyxFAnkVnUsvG6M0MnQa7Hl/N506DkbS3pk/Q7EGYPfkDvozLQgU7ZzUz4wN
 w/L68gx/RCvw2P6VMXwZG429tdKCMwFMcEPBthYzcBKHWLkTkIkdAsYzalcR6G+C+ZLxaV6ze
 WJY1xUOKQoewo=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> As I suggested, I think is better to split this patch in two patches
> since we are fixing two issues. This should also simplify to attach the
> proper 'Fixes' tag.

> Splitting also allows to put the reporter in the right issue he
> reported.

I agree it makes sense to split it. I will send separate patches in a few hours.

Norbert

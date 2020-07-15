Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E930522147C
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 20:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726941AbgGOSoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 14:44:39 -0400
Received: from mout.web.de ([212.227.15.14]:38197 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726354AbgGOSoj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 14:44:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1594838637;
        bh=8Ci8b/F3b3a9B5srIUO2+DS4WNXDQJU4PdLdQTSSiyU=;
        h=X-UI-Sender-Class:Cc:Subject:To:From:Date;
        b=Er8ZL3yLQQIgW18mzom3kT2tcj3LN2KaJbIdywLVUReAgh8znYOzl/dlHoJ7f84TE
         44VIH0Xeklwq/jZx09kyMbPQQyM4JqzWgc5zscoRPHPc5LjqXQ1UFZJDBidJJT9Pz2
         WI5XUapE28cSBf/jsBQ3RFncrb9ZIPaf71lbVjos=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.133.102.166]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1N8Vsr-1kzcbt3bA9-014QIG; Wed, 15
 Jul 2020 20:43:56 +0200
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Tuong Lien <tuong.t.lien@dektech.com.au>,
        Ying Xue <ying.xue@windriver.com>
Subject: Re: [PATCH v2] tipc: Don't using smp_processor_id() in preemptible
 code
To:     Zhang Qiang <qiang.zhang@windriver.com>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <bedc4dad-c7e9-2100-9133-e72c40894a9d@web.de>
Date:   Wed, 15 Jul 2020 20:43:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
X-Provags-ID: V03:K1:l2QZm4ctJL7PE9EH1e0iHpynfqbkQBKyh0fLNPfAMD6GeCY6VBg
 hGF6L/R71su6tQOb5mDe+hZ39f1gQuOCop7D5QSqY71bGHJspR1E7XL9OwT5jTI0bLABhPg
 +AhJAQT0qM2sPcVzZsJmuswY04FQn3A73DXDU2NCbGd2XKQW4Sptn72txzUbpwsaixeyI6H
 h88ndeBXfkiJshdj2cBDA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:heAufnYgSlU=:Si4Xu2TUJ2CScKWFey2v6T
 oy5NSiCVRWtUMcxLxqw0NhhO4UZ5BJiTxTJxdCXIUpMmNpgMIZugJjSLpUK/LkGqK9dHn8+Qw
 AQmdodsXtp3tFRIVfswvswSe116RT1dzBsJHtqog/GzDSOkbrmlNU7mLOg4eb0OA+t+3TlqjN
 SIrAjnAgcaDvztLsHVAuaFevxT3LPFeCdzLAjtcgU9EdXDkkbupRmMcZNeWq+oI8lLYtPfKNJ
 ger1cWZTpnnHu5OjwAm7AXGanbjTYrvCgPUts5yPHSP3KRyX+UG5EJpoB9zrNig5FJeY4PKVL
 Z1vW2x15aflxZJVWkcCm8MJ8JDDeSqRGX1QVIhg0UOAV+FUkidQfjEjGZHKxws+fnmS3sd7yQ
 8T6xPXNkiDEKbXun0eMXE4/DwIQV0BbkBcDK3GASsW1IkN9++tTH8HAkJNka2bfXGr06Zb88C
 MzxC+WFIwjxkzxosolvvuj5yE4sCMnAjEajQJ+COS68SMAAlJst+aofzJVNu+8XD26iO9PZEJ
 tTOKmc+rLHSpH25LgGlNGt4F9rq0AYEuYx5NPxx9MdeZs7iBvOjvqxoY0hswqqKMHRj4xinOQ
 PXTlKwE74Blxujw3LZcj9ZIt3Qe9ClSh7OuCD3vKPJoAG/ZC0is/qD0d8wa4mGPWQxR427S/o
 0nlDI0ut9hI+/i0Yqcbyv5nlbTiE16L4TWY8Y9FBR3qiZixPaMG1gsFpUa/58aabfzlWS4SeT
 dsXqqkGuppHSdyw8bO8mx0ktRPNIFBQ6CCbtlYSsS4e+c+0H70Cy6TyOIGQJZXiYNjUMN/LG+
 suxUdLBTXVcTTVwZHTEAq1qftvHKh6kZLnH7tgs0fXZ/1BvgHviv/t9aRYRrtilKfEzFaf79R
 rHPLJNHhgzbNMvhEHUCkaGyPcHp0HHvblrHFdBRrmRias6sMmmlDbBNee239xSYkmHU+iwSHb
 F60MA42tKgh2OmUDQSVCv/HyIbR7MgjacZLBpTRz3CMUZlVPB8FgO+uL+o7Lcst+DF8x1zv64
 sJ+tJIfwUuYOvmxN4PBo/qP+DmUNvPlihK4lAVN07IaYL9WMD0ikcsBUrVtsNynpR850Y8RjG
 Fgq9JkgXVKlsIF+XAjs+ehoNbPAo2ZeslUTTDpqj94f9IPwnn+RKZUkZwuTAmuqypPJSKOUC0
 xywEpwstQ4CsS4Epxm/a5U75jLb5SWDp2xoAUOYyfRmsbDfGqIFKi180aL6sq6LJIx83MC3F5
 7g/fr1U1SYDGiVguVoDbGSNO564ZjlOUxAmbffw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* I find the patch subject improvable.

* Please add a change description for the desired commit.

Regards,
Markus

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C4D3D35AC
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 09:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234163AbhGWHHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 03:07:22 -0400
Received: from mout.gmx.net ([212.227.17.21]:44701 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233934AbhGWHHV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 03:07:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1627026462;
        bh=/fEJDVuM73ewPFXlL4ozclwhCtYyATgSRFCVmakUf5E=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=baJo2WSCtcDVzfAVVAp/wl5k808pdAHPtU3A8EkYXpniNVP/QYHboQS1wxJoujZPa
         a73M6jsI7IeaHcCL3hKx2EzxuuogU+FgyhyrWVjIGJfMJe3eKjLLFK5BlUvuzp7DLP
         11Lf1q2yf2WQ60AyriNMiHk5iwQmXbEEtY0JFOOk=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.51] ([149.172.237.67]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MSt8Q-1legwl3bKQ-00UJDg; Fri, 23
 Jul 2021 09:47:41 +0200
Subject: Re: [PATCH v2 1/2] net: dsa: ensure linearized SKBs in case of tail
 taggers
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210721215642.19866-1-LinoSanfilippo@gmx.de>
 <20210721215642.19866-2-LinoSanfilippo@gmx.de>
 <20210721233549.mhqlrt3l2bbyaawr@skbuf>
 <8460fa10-6db7-273c-a2c2-9b54cc660d9a@gmail.com> <YPl9UX52nfvLzIFy@lunn.ch>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
Message-ID: <7b99c47a-1a3e-662d-edcd-8c91ccb3911e@gmx.de>
Date:   Fri, 23 Jul 2021 09:47:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YPl9UX52nfvLzIFy@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:2EvYZgsYjImG+QnpsHG/lb36VH45qLyHwqi2rB+REkSpL5TmFJE
 BwZGL22QU9MBQLCJoSTBWC8+xgq6K0LEjXWLB89ISRGQQHN1hax4SHpAwbK1spf1HzTZTeS
 km+xwrPVb3RX88WvkYIZz6qluOKBuJ+wZuVRC9N3AKsQ3rfWNuJ+k+dke9rDHun34KDnFVA
 yR/W8/PkQJgQd3b3x/KEQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:SFRsrWPQqUI=:sYwdGNWS2MRNewN6GQ9Mql
 rRdPHV4xsW82Kd6VlGdss+oXTKTtVH8b/eut9sGQGjB5F/CSpYp0ILcYyRQLuFW2WpKK2G2ge
 lLG6YTlewTlNbP2krPhfUSQH/emJwcxRtkvqQ7AKkKtXVmyx+tXZA/+ZgE9ewTifkVbePQZnn
 7Q2qauOU+Lp3l7Le0E45IJg0HCTH+s7FHgaW8MG52W2URXxWIYaV/tYDJzCikrRVpb0aCxwPI
 ZI14As4Plr9sBmzg0Iv1vlJh1xgYp5Y5XwlWO/9QATVkRwHvqHpmRD21SUbA17D7eLPwgIAPH
 Gj1zFnEX7gj0L87hbpSUqzkOwkivcHxipZUieyPxsyZAcTTr0ENMqOFJaJHcQ0rcXtirIABA4
 ScWR6WQ/KxiJxs+kqspMH0HJ4vu6DG7eywrboFdLfFSE0V6XvhUUXO1O5HlT2cZCeqT7Wjtlo
 4DJ7nB7xSNTIb2KC94mKwpxDPxDxH0YchVRz8eEnC6kHVxh76f2k6rEtEyfH1ACrpr1sDb8NC
 GMAxK1ERv0Pa+3g+ZTLol7s9R67EUKuEVBkNa6clsIz1rXlbkP8pWg5LYr5SY40JFpMjhO97V
 Ksdlf/qBcJ6Zj59lOq76qBWvDcqWyyZJSm8uvCmOPq8QIyUabDsj2rsntpTqBg55vTi72kleE
 NwU8cLZtpLtALMpXLveX86jWb8i/6jXJFyv21T6hDDowEKLmBOKCBAEmthLlOtkIjhhHLtdqZ
 k6gZGGQljYiNZucE+3oq2cW5lDSMQnwDbZegKLi7W8502FxkToIKGUCwZZGxLJ0hdQUb1CT9P
 0O49mB13bjqoG5+mjIv8+li4duN4RYXtW3heA2l/PdzU0sxKX97jNrsfLcVveovImiW+NdB7+
 Wg8AreXQvY6u9zS+vbo6czlnTXgUHMnqfTbvyY/0SbW5snZZ58+FzvPso6XqDZG9hOmcEyvN5
 t9pfZNEbm8D1dyNKmZh9Cuj6ASli/7EAFSyCA9XLxBeYreZ9WJRGS5e+GoXZn1LJ9P//mItC3
 b3G4hmBf4LgM7ZCFl9tEEv8XwsajI3HshOGSgUZ3uJl8bGV3sBGllJPcL863XhTVScJkmxwy4
 FyAcwHsGIHxTdVJQiA26njarc0rrSGb9zYI0jli6IdQ89dsrBhGKjzqHA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.07.21 at 16:14, Andrew Lunn wrote:
>> Agreed, with those fixed:
>>
>> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>
> Hi Florian, Vladimir
>
> I would suggest stop adding Reviewed-by: when you actual want changes
> made. The bot does not seem to be reading the actual emails, it just
> looks for tags. And when there are sufficient tags, it merges,
> independent of requests for change, open questions, etc.
>
> 	    Andrew
>

Hi,

since I got a message that the patches have already been applied to netdev=
/net.git.
How should I proceed if I want to send a new version of the series? Just i=
gnore the
merge to netdev and send the patches nevertheless?

Regards,
Lino

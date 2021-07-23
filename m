Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06FD23D3B53
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 15:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235283AbhGWNBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 09:01:06 -0400
Received: from mout.gmx.net ([212.227.17.20]:39913 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233486AbhGWNBE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 09:01:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1627047682;
        bh=LaTL2iNrZOppNwoRX/A0sZoQfAeM0sYpNYrF9YslHt8=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=QD35GZSH+vafo8Iulhbo3gkuQvKp/5Rsy0yrcbLNHI05u/wTc/D5dr1cHHuVEqDP/
         Vpa6L1G+xYDUquVKxpyraAKR6a8gKEEhypkCCj0DHKZJ4Rch00rPou4IcR9WesLyXu
         mKUFsncx8cs8yvzqtCsx6n8QDCK0HqPV1BM7iW+w=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.51] ([149.172.237.67]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MEUz4-1lr2CW3C4g-00G4CU; Fri, 23
 Jul 2021 15:41:22 +0200
Subject: Re: [PATCH v2 1/2] net: dsa: ensure linearized SKBs in case of tail
 taggers
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210721215642.19866-1-LinoSanfilippo@gmx.de>
 <20210721215642.19866-2-LinoSanfilippo@gmx.de>
 <20210721233549.mhqlrt3l2bbyaawr@skbuf>
 <8460fa10-6db7-273c-a2c2-9b54cc660d9a@gmail.com> <YPl9UX52nfvLzIFy@lunn.ch>
 <7b99c47a-1a3e-662d-edcd-8c91ccb3911e@gmx.de>
 <20210723122213.fvhudwyk36u7pw52@skbuf>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
Message-ID: <e5438617-8dc5-b9c8-7176-91075ca1fc36@gmx.de>
Date:   Fri, 23 Jul 2021 15:41:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210723122213.fvhudwyk36u7pw52@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:eORuWqFC1LqZeP5vatnZ0e0ZXIxGitqetBp4/u7C1gUzPTtle/f
 tQkEbWoOQcuh3RW39mfmxE5t8Sqn1LWHyjB2gTnZ6k7zrH3MxuW4sT8Bue5bbpXayaKRIKd
 GIo06CYJV4gxIsVr3Hsw2rmmhCR/dX1+vLAWMfxy1V87Q9d0bK/jrXbSr0AMEfZ4jFq7p47
 jqC8QU/BX9AtQoTKTVDWg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:32GnEuQFGiI=:u4jqjWjqCpGE7+9A6H0Grz
 TbrAWpvyWL24a0nGupeTUGJAe4iJMofzgHHKV6DZLE3aU798wLUEUzoA5PapTDLezBa5HGMjO
 jFWRKj2OQUXXpc/1h+XnYkuOlg/94UKG4DeVEey/yhbDi1dF/Vou81JCkU4RDg+Mk+/C20+HX
 FjjByOTUKhnoZSvEFu5zhPlTZHjFsgmbTD81W7c78M+Asjw1crwfzCH9pMYz/uHLYfI9JeduG
 GE7PLw3TlXWm070mNur8hP7baSJOp3P5larHuFN9HDjRAjAtIgsuUvKPUboxKuPqQn86AxW3j
 4vn8f4uJZrLa9DelcWWEC/cbD7qa/N5daii2RAhlJAEKiV3ARNCjVQfb+AJ3VS6KLrKVkZAy0
 WqO4jn2OS40OqWgPs+KVLDaL1rZwPAEOMa6orBqZy9F43C2089Tk/A/pCO6X0j2p5MWYr2Ruq
 rMCtUO0k8dUn3Y0Vor8eTkoKDA/Uwbn6SlKEEYtQJugG8MPv9mGncdPj2aakZYxWTiuAIWKeq
 wlhEeRM/MsxzMYuqr3uiHI6yCEa0+wVOJcdzHSvZ1kVXsYXkSQYlHZtATXVVciJPGgE+Hqa9h
 aK9R4tmrFfB+uPcCW0qtHRIJBnr/vPsL1zr2+EtE8GscgKHsqnboXxhpotS6MrTUmsjWRMuoC
 tfuv5QJJx5+xlA5W5yCIWLhfyENGZsnq8YW4LmIyhSkLVAVtWtSzHdEG+75fA72pR0CgUL9qP
 QZPb/DhTZqULW1w+IH5xLFmepZuaFUPunuice19oqnLLLbUey4vHsjwxBZsoSvozu4XrO4c6n
 u4XqnkG7ITyIa7Nmap9+YnNKlOueyHC71bRC9T7G1R6nz7F2d+0Dhr+QbyGnYZO47AeVvc2fW
 U50hFZrLvWa8oKhWgU1RekfzYHdn2fV7KqbsKZgp7YOWCYzitKLAvQqyX0ub6eF7+BffMBGJO
 /ihNsTNINtPZRNW+J1IGv1r+iAO+5MEXb1xFKQw9lk4G0sWE29Yl5D0MOY6KzqUk247eXOXoL
 VyyaNnqR7PeQ/ZL4zirlC+lFgf3zjcg1beMeiElW3uO/K40kBPA9UojeNg9OQTWRxhlYtjVB2
 DZmwcqo17NT2CSlhllzjk1ejIWyQZQC3/Zdc2ht9gjqJKeRq/fW78xlwA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Vladimir,

On 23.07.21 at 14:22, Vladimir Oltean wrote:
> On Fri, Jul 23, 2021 at 09:47:39AM +0200, Lino Sanfilippo wrote:
>> since I got a message that the patches have already been applied to net=
dev/net.git.
>> How should I proceed if I want to send a new version of the series? Jus=
t ignore the
>> merge to netdev and send the patches nevertheless?
>
> Since the git history is immutable you need to work with what is already
> in the current net/master branch. What do you want to change, just
> address the feedback I gave? If that is all, just don't bother, I intend
> to look at adding a framework through which the DSA master can declare
> what features it supports in conjunction with specific DSA tagging proto=
cols.
> That is material for net-next, and Dave took your patch at the last
> minute for the "net" pull request towards Linus' tree. If you send
> another patch on "net" in that area now, we'd have to wait for another
> week or two until "net" will be merged again into "net-next". Not sure
> if it's worth it. The only thing that was of concern to me is that you
> assign the DSA interface's slave->vlan_features =3D master->vlan_feature=
s.
> So even though you clear the NETIF_F_SG feature for the DSA slave
> interface, VLAN uppers on top of DSA interfaces will still have NETIF_F_=
SG.
> However, those skbs will be linearized during the dev_queue_xmit call
> done by the 8021q driver towards DSA, so in the end, the way in which
> you restructured the code may not be cosmetically ideal, but also
> appears to not be functionally problematic.
> Anyway, your patch will probably conflict with the stable trees (the
> tag_ops->needed_tailroom was introduced very recently), so we will have
> another chance to fix it up when Greg sends the email that the patch
> failed to apply.
>

Yes, I just wanted to address your feedback concerning the feature assignm=
ent
in a new patch version. But as you explained this is not needed and would =
make
things just unnecessary complicated. So lets wait and see if there are any
conflicts with Gregs stable tree. Thanks for the explanation.

Best Regards,
Lino

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B94BB1C9807
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 19:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbgEGRjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 13:39:44 -0400
Received: from mout.web.de ([212.227.15.4]:59175 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727117AbgEGRjm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 13:39:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1588873161;
        bh=it578jaaV4ZIrsHlqKP14QyEAmbJNdbtULPP6XwtYEE=;
        h=X-UI-Sender-Class:Cc:Subject:To:From:Date;
        b=aRxiMNsa4dh9j3LLSyD6UXB5LPLoe+NunN16UrTHgpq3nX1CjiSLWU30HVkkxHeHz
         okjT4ADPwquv/9Aeab36Zikpt7dpTCFM9YZahuzDLWgvr5cBHjvWYPLc5mwyHKxhrV
         ZeoLDSSnLcnEfNtnFd13vBlLrcBpd6WVojAY6NFY=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.132.29.220]) by smtp.web.de (mrweb003
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LiUF2-1iynBN0ZfI-00ciMO; Thu, 07
 May 2020 19:39:21 +0200
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH] wcn36xx: Fix error handling path in wcn36xx_probe()
To:     Christophe Jaillet <christophe.jaillet@wanadoo.fr>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        wcn36xx@lists.infradead.org
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <5345c72b-8d18-74ba-a6fa-bdc0f7dfb4c3@web.de>
Date:   Thu, 7 May 2020 19:39:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:XrySkeNw0LfVGUlxT/TTsIiPCNu/OLu0Fw0c9LMhXPt8vOlzJWH
 oIIABP35ohAGOHuYyu69btX7s2279g9+FJLyAI7/G0OXz2kEGRiY10oZVOSPDCMcZVxO1KK
 cOc780AJXwkiUX5vasmDLDAbjo5qzhS7Di2L9qsIcBKVKUbSVu1GJR3mCMyxNoWngAWS9Vh
 2GdpNqEkiPqWabRxMsyWA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:gR7kmyRf5+I=:hbV6RdveU7focBUXqKuWwO
 GnrWOx6Nc1j+PSImVeQ/w/EOo8lXebp36Yzz1oxPDnzws/xE7qSaK15K22ATei7Lwi5JcKlTX
 7JijR3JFO27OgBgmGQ9a9l4uhXNhb8YRKnpvvw8m3vQgjf7kP70DJ5erdnny5q0fXE5djlzOy
 xPBeqkHYblMwwpLIHdVUVt2+xhpUjPNXo30xY1JhmIXqw+g3PIgFgKdDo56o3MbSKAt/geuGg
 a8NKEr3t2CMsk6DKYZ255jscASk26RvD4SbUIW1CG+gKSCk/GAwXABzVQJOvXoTddctecNT1C
 smNHujA89sdaomkRmegd0kNkmH9QJspfuZai2UeBVlD3Dgjq6IZDyqSV7hOnVzOBTKNuZll8+
 PvpjtBBYS8FThzYxc3vJY2zYhf76cr6NQGef149PHPpL6QF7gq4qhdUAZtiUSHpLRsVvBXQHU
 qRHq9hTz9yK5ieozJXuAPTIOaLMu3E9dRrkaAG7auY56zIlMB7JoWH4xSTYjC8gcdwP/eFTtU
 R207cXj5ahX1pBPoiOjQbRvxvXd6GFcQ8lTBZ2Yb6EJiLwBFKqYNqxRAgq/kd6VUk5NJpQBhv
 vQRoYRmc0feRYQKNWUorBFapVTxC5aaCVEoAsU62CsJYZzYuwUSP2/Uxhh4vsbrDB6uO+tU67
 eZs4d8cOvCrndhwgZPyX1+MlXE4O58h6Y+ffwRHkiNvhTBd1W9iIaZ6vO5/m885+CblmDVUIj
 tP5UGQ2iwOKsU4MKBIL7i2RIpyV5caqC82DH036Ldg0L8OcgphyoXpYbYhHDS5QbhOAlNQQo1
 5CSG7ehRw0jI2q8uEIZu08G9KBUMbdGdvveJ2/ubxGjJUk5k7CmUmq73aWqxDqwKgIY3J4dOg
 J5fUu+ApJtq13L2s3wGqpscXPjtq3hSuoh9zlZeTtNx5/Iu5vo5q9hjr5H0ZxDtbbeLx511u1
 j+CG3yO7S71SeO8WldbkFJG7+6+nTmZb7ztd8w53FGlh6E3TSIZnmS5IdwOqBE5aCJcjqFkLG
 jYz4a3Qyc00X85ljULrAHg44vNYMB3cVIL830fpTtgSHlZgN0gVKsCHXcMZCEKwV/iRSiG7DQ
 COhOiXZ48RVS0bu3GrT9buQCmVSbmtOQ+BfXy4WnKrMVUhOQOg+dFofWMgbxA1aeh5n1FX0Aq
 bQ6sX4lVxrLksR+hMWyqZ3iFqsI0R6zzkrcep9HcRD02ydNVb2nyIHuwJx9cmxeUVrzGlG6Ny
 ZikmEfV382rLuvUcp
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=E2=80=A6
> +++ b/drivers/net/wireless/ath/wcn36xx/main.c
=E2=80=A6
> @@ -1359,6 +1359,8 @@ static int wcn36xx_probe(struct platform_device *p=
dev)
>  out_unmap:
>  	iounmap(wcn->ccu_base);
>  	iounmap(wcn->dxe_base);
> +out_channel:
> +	rpmsg_destroy_ept(wcn->smd_channel);
>  out_wq:
>  	ieee80211_free_hw(hw);
>  out_err:

How do you think about to use the label =E2=80=9Cout_destroy_ept=E2=80=9D?

Regards,
Markus

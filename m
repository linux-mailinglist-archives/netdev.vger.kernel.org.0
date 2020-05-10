Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 914761CC9A6
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 11:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728786AbgEJJHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 05:07:43 -0400
Received: from mout.web.de ([212.227.17.11]:39841 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725833AbgEJJHm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 May 2020 05:07:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1589101641;
        bh=4GbuQyEtR+gvm8iGl3qLYfG/5nQH9qggKEPBZ9K128Y=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=cmijcPAFRSqYvMPIl5DBRk1BMRYK1Xfxa8q+fIv1E8uLv5fehceAthfOZ2cLXGMz4
         uD/B9y+XOx5yzjj+6OMf56Kk+vHehh993rBeCsn3mSarvgcwXtiYSFCxOIcSlJza9r
         0a3oVvqSi1UC2DG2Ce8KqG0JpmlA0R6bLbNQ8jcQ=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.244.31.72]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1M9ISr-1jROoA2JWR-006SBF; Sun, 10
 May 2020 11:07:21 +0200
Subject: Re: net/sonic: Fix some resource leaks in error handling paths
To:     Finn Thain <fthain@telegraphics.com.au>,
        Christophe Jaillet <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <b7651b26-ac1e-6281-efb2-7eff0018b158@web.de>
 <alpine.LNX.2.22.394.2005100922240.11@nippy.intranet>
 <9d279f21-6172-5318-4e29-061277e82157@web.de>
 <alpine.LNX.2.22.394.2005101738510.11@nippy.intranet>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <bc70e24c-dd31-75b7-6ece-2ad31982641e@web.de>
Date:   Sun, 10 May 2020 11:07:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.22.394.2005101738510.11@nippy.intranet>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:pkmm0tEJ6Uvf0/63tzWKAQ/XltEOWFsBIQyKr8oggmxvVJHcuG2
 5KvznoDaCGqwDj7EBKfEJR8bT4nj1lW00bU4e7fFurtEPZVJX4exCi3/X8Z9KeCnqm87lKr
 HsREoj0CGYBGcObWutfYH6qyieNW2QYcvNxuop0qmQ2gEj86Rdb5FDxFlym51qzKJcSB1gF
 AqsxFUAZBhAXmMcLtnRvw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:yC4r+r9Jh4Y=:RVTo9dE9EH/dKgRgaPueic
 jr0cyTb7/bsvywM9WkIGuzEpLb6bez6zp29gmvNH451YBs/YmTUmegk2ySvywJ4ibCuT8h1+O
 jBM7s3K8Qa+WFGaxM0gTgEbDkPbBeMcaGrElM7Oh7/vvLNkYC2uld90HXD15u96lshh+I6EjR
 HCiPHeKJfvQ7cxC3DL10SlwEllL09kiUOKF54juvAIlor//k16AOp5s9CUSIPzACBIuzfhHH8
 ykRB1bY8ghNUYAj/mCgW6J/bhsJLn8pWiAeo1bwYRsQJSTR4btaRzh1mJ9RgDdwFDH6tbxR+Z
 nckn2I4/aN26pRcsiqkQQJtAYRQcMGsZr5PXRKMS6WstnzGEA4SnpzLrcVGTtBwkRWVLPDVEx
 wv2lY0hrU+NZWQC6cxw17rp8aQX3jSTSvS1Iniv051Jf0qgj88XPmUAzt2urH9QE/IjxWUSX5
 odymtuNCRnT990rEzNczGyCHxwWJKZZYEVUrOB2tM+xqvU2iC2w75GeOBdwU/2iPseIKbBpvX
 VqVwD+YG0Hq34g3cmhpXdasBzDDJEg7cXzoMzy5U3yIV80tpSKJiPRhnGJ2WV+OGtfma1R2JL
 7Tfyxpz3iaKwNhz9bp+8XhusGPU9sJWyBbv7vkRGv+vnqgFXXA1ZB5hq5lU6/YXRN4I1aGs4I
 c9LtdqLSo7s898N/b10C43dnOei3un4xcY+Z5K88XGMX2I2/eM22qxnKvfljiblx442SyQLcO
 wlIB7pXQWzk5NdMLbdbyICDcMHbZ28VUqQSCnpgPpWszp4YAeIdrA8VLO+e6RWBYCdqH9MI/v
 1/sjkeTXVZDaXRSl5nJU6WFWBvIoKY4DDDzWD1Q7kYDJLqp08d9qWkx0pYin9GcMNy2SMeFcE
 yX6LrtlnKPdDKrAGWukTBga0lKHXyX5r19AYYpHn2SYxYGZoeOlfvtjYkQHLmHd1Sk4XJKrmS
 xnUa4wmo4+ImhwqciKFRuPK7sHii9TPqZYNHaQXZV8Bs5xDWgIw8buuErQFQuu5aSDtmXBHOE
 N4zupa1AJTSC0LWzioLiGoE4v0zO3vsapqwfVBwA7hPCCtiylAlroQYdc0atH5XrymMQFELgg
 ouxtxLlcyo1D8j9fYTLlx1W5tSPFguF3/wkOjFvd3MqWfGENeUQChD2pm6Kn/U3FflULk5g7Q
 czgfeK2h8R9ugZLTwq/3ftEKhhig/k9Gs8+js1g5Usn+ZbC98jl9qEMvBHjS9aXgFZHLV07iv
 mQNPXU+1VQDZT5GFB
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> https://lore.kernel.org/lkml/20200427061803.53857-1-christophe.jaillet@=
wanadoo.fr/
>
> Do you know when these bugs were introduced?

I suggest to take another look at a provided tag =E2=80=9CFixes=E2=80=9D.
To which commit would you like to refer to for the proposed adjustment of
the function =E2=80=9Cmac_sonic_platform_probe=E2=80=9D?


> Naming goto labels is just painting another bikeshed. Yes, some
> alternatives are preferable but it takes too long to identify them and
> finding consensus is unlikely anyway, as it's a matter of taste.

Would you find numbered labels unwanted according to a possible interpreta=
tion
related to =E2=80=9CGW-BASIC=E2=80=9D identifier selection?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/coding-style.rst?id=3De99332e7b4cda6e60f5b5916cf9943a7=
9dbef902#n460

Can programming preferences evolve into the direction of =E2=80=9Csay what=
 the goto does=E2=80=9D?

Regards,
Markus

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86EF61CD352
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 09:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728353AbgEKHzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 03:55:15 -0400
Received: from mout.web.de ([212.227.15.3]:42175 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726173AbgEKHzO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 03:55:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1589183699;
        bh=SxeoKwHdTMYDV8yc9DyM1v9iJ5uFpRGYEyppCZGeAl4=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=syD/a49EMTKAxLjoWfwplmkIFY1zwg83Pw4XPlmLlrem40cGJu2Vh/R6Rnp5jM+M9
         T5xXCmUt+M0HyQx7CeKK31S8GctjWC9sR3BkglqqMD5QMCsOkzfgZQf67YEyhkZkuX
         Ew2/eYSkZ7E6Uu/rC/Jq1Yk18K9nCwhA/k85V83Q=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.243.185.130]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0M5fhI-1jA5Ix1oL2-00xYi1; Mon, 11
 May 2020 09:54:59 +0200
Subject: Re: [PATCH v2] net/sonic: Fix some resource leaks in error handling
 paths
To:     Finn Thain <fthain@telegraphics.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Christophe Jaillet <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?Q?Thomas_Bogend=c3=b6rfer?= <tsbogend@alpha.franken.de>,
        Chris Zankel <chris@zankel.net>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <3eaa58c16dcf313ff7cb873dcff21659b0ea037d.1589158098.git.fthain@telegraphics.com.au>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <f9a2c71b-e001-d546-64cd-8a904ae881ca@web.de>
Date:   Mon, 11 May 2020 09:54:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <3eaa58c16dcf313ff7cb873dcff21659b0ea037d.1589158098.git.fthain@telegraphics.com.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:lMX6L/xPU+LnOvXWYWppgvBITGxbf53w7sXD13Jjbsx5KoiLCxp
 TyLb+HiD8bjqTt/Ur/hTAPsYZp3xYJmsg7OJrHgppvPlLYsrfT4RaIKBIX1R47A3V3FvpiL
 MK0SKbLdHTDsv5hmzjZ+71U6ZyvtdO7YkAl+duD9eo94sJpGpf8dCuc15I1zg/extljc8uU
 lM7vkHkVIMJyt76NA9V5Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:hk7Te1kuLBs=:HLdD4ujWZ/rIGYBtVDdHcD
 9+3/Z2o9cjUJh6q5wpDVKJnUIP36u5BdfuK/UQlWUbe5JapHlh8N4XTha/QLZowdMLbPZCET4
 Dq2dTsZS4i2+nyMcda2ERHrKHc1kNM2tFbksYSEVtzqNz1hkxa5lfrJVI86/hxZ7T+76v7WEF
 tgVDyAIM4YGmMk2KTN5cjTF9/GUM/WZ9Aj4ZTHzgw4wPmur0hsQtJJeme1+1xIDoSWhsQpIDh
 Ho7d7lo2LVoYxmSA/TWcYyITpcWCVpkhqIaoOE6xUDvOy/a5QVsy+UzMn9soUC2ey2DzhT9cK
 kiqf1Focdq67K4F46CFNmbfbpvcjDn6+HAXBWYyG/YMZoxylTXVj2hR0C9uUpuhd16G9Yp6x8
 N7sftqvQR752Hm7sQqGE6gQ++X0Y2ns8nJz/FbF4QKH7CkSsjAB9GpN4zTv/ZRU5ExPPoLW+e
 Yicw8xCxERaZiJgpD+xukqRPhmi2OefLUcsqpkBOKy1JcZXM/p5TOzcSTJ0zUYUNKxUxdI9/u
 RrwfhU6sDqYlctNjYf67gRChwiuQYg22GN2oCSEGunvfluqo94Iy6PaxzWCcC9myQygHwVJUU
 Ne0u/ZACd/QEBZ2z/tZVx186pnRNF/ZXA4l5OlwmKr5Z2CkIS+tjrIguXKLMQr3XSgN5Lq512
 8dAIGCqd0a2ScdRy/85dt2BKD6xNBsbPkDKZJHFjCdoskWHLnpiJbMhOABtFStR6esU1T35Qa
 pfncNYxnW6AkNzaueou7MDP2DWkcKVm2kp///yeo6u/IbAh+nlDSkncG7oT8n+19qDIYAYoT8
 Fio2uVEZHhYHC7s0UUe2laCulUrFI9CRjzR/+kBRIILiQ7KzAgucmiIOHojC+vA1XP35DSM3j
 yJ8JyaxOfFBDMZddXBddaRzkfnfJlvywM9VmRZqwUWLDh4BH2qMrrI/Y17eBSPB5/gltRmMf0
 LaG92417BnJlg0JTTlzKbxYK5+YiBoO8qMps8qnu0swHLBDpS3zk6g3mr2kEgg7vtXaun8nn5
 v3nHDPEE+ADMW6AtoyNDdGB5yB70SLob5IRUU3tpM7g3HGt1n64ZVAwn7TSrCpbq+nds6Y4Cp
 7ZplnvtOkFjCAn/oR6CEcaKJ9Y4ht7itjIhwmA83RWHDfDpenYzf6/SvlmPq6RzWFM6b2W/uD
 qr/BD3sfrw9eWMm1GMzPgIQPLTYmaJOLyTscGge8b4PmKx1MYAbjEUmimXfrKpkyK8xqAuwhe
 jJdeBu/vNh3pBs/3E
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Changed since v1:
>  - Improved commit log slightly.
>  - Changed 'undo_probe1' to 'undo_probe' where appropriate.

I find this response interesting.


> ---

I suggest to replace these triple dashes by a blank line.


>  drivers/net/ethernet/natsemi/macsonic.c | 17 +++++++++++++----
>  drivers/net/ethernet/natsemi/xtsonic.c  |  7 +++++--

I imagine that this change combination will need further clarification
because David Miller provided the information =E2=80=9CApplied, thanks.=E2=
=80=9D on 2020-04-27.

net/sonic: Fix a resource leak in an error handling path in 'jazz_sonic_pr=
obe()'
https://lore.kernel.org/patchwork/comment/1426045/
https://lkml.org/lkml/2020/4/27/1014


=E2=80=A6
> +++ b/drivers/net/ethernet/natsemi/xtsonic.c
> @@ -229,11 +229,14 @@ int xtsonic_probe(struct platform_device *pdev)
>  	sonic_msg_init(dev);
>
>  	if ((err =3D register_netdev(dev)))
> -		goto out1;
> +		goto undo_probe1;
>
>  	return 0;
>
> -out1:
> +undo_probe1:
> +	dma_free_coherent(lp->device,
> +			  SIZEOF_SONIC_DESC * SONIC_BUS_SCALE(lp->dma_bitmode),
> +			  lp->descriptors, lp->descriptors_laddr);
>  	release_region(dev->base_addr, SONIC_MEM_SIZE);
>  out:
=E2=80=A6

Can it be nicer to use the label =E2=80=9Cfree_dma=E2=80=9D?

Regards,
Markus

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6D111F87C9
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 10:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726919AbgFNI4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 04:56:30 -0400
Received: from mout.web.de ([212.227.17.11]:39239 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725265AbgFNI4a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Jun 2020 04:56:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1592124976;
        bh=1XKwjy46DP0XP1BezOttDjslx/1Fvlxmazm0SmzeslA=;
        h=X-UI-Sender-Class:Cc:Subject:From:To:Date;
        b=NF9ccStdhdx4YYSPvH7fUAoH9YmOBXDbZpLo5nye251d5UFGudDBTFlZxHwyi6cjy
         L/Q5AiaTJ4F57zLojdCngm9EDAKLrcenKG1Kw7UHZK3OJdH6gBBGOYsffTtW+jYLzf
         oGWg5ITNIZ5fJiMPpjr/lLgv07/IfJqiC/WVVzs8=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.131.103.145]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MBTQo-1jb0Eg0S2w-00AUxb; Sun, 14
 Jun 2020 10:56:16 +0200
Cc:     Navid Emamdoost <emamd001@umn.edu>, Kangjie Lu <kjlu@umn.edu>,
        Stephen McCamant <smccaman@umn.edu>,
        Qiushi Wu <wu000273@umn.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: macb: fix ref count leaking via pm_runtime_get_sync
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
To:     Navid Emamdoost <navid.emamdoost@gmail.com>, netdev@vger.kernel.org
Message-ID: <c145121b-3d69-a02a-17f5-f0eb2f166663@web.de>
Date:   Sun, 14 Jun 2020 10:56:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:YIGYcO6P89/n84JoJbJS+s6UtPxuIxy1TvrfeYMMdZk/xJySr6U
 59SvoFNUi7DB9aitWb7SwqJ3Bcawfo23Cvz1cIgzzX6Ih/dX9RgspQqpaRjtaQb/tA096T6
 IRYipq5I3UDCCCuMnfHiXuviBWRK/+UUl5XAjJuB8sXsyVzwACthBX9XhHOtK3/zgkcpEw0
 WuimbHrvGvebXWdOzUcww==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:eg7k3wsso20=:lcbrm8SQgQoTD/1/qEfMDy
 cRuzbj3YLhaX0fCxLlo1QhztDSvpEFIElnQsBIZ8UZZFZecqQjOreWKnLedrid+XYIf0q/XBz
 txTDAql446R4zGCDaRNl5zinbqVfgcLBEFY07FehG0da802LC4FlbWUiKwOQUJrF81DhgS0ZY
 JgYeDynhn0xFYingk1o0xAr2hWARvSAz+ogeSX1QuZOZ4CJRXy3NlyVC7jwNvIN7tQWBkVSDg
 LigGeg9YhOhBujOBJ9N7PjgXpZrfF5TFIxCWMGBF/Q6rAYoC/x80YIm40kgVp5CNwvDSJRk6x
 B9IYYvkHEOYnn45Qn2/azW5K4bbgR3Rjt89bijkfTx0vauNI7J3865MXia1d0g+VdfmwNG/ey
 rQqUb8IEaPXH2UoAUdySiGO6oNe0PYM/HlC/0oexMO85bu+8MrXUSz3BJYaEt8aDTxhhUVfmj
 ra4fz+lhq2WMSyrkE2NWBTTIhhURrK3hs9Co2aEAZGaKyF3Njrii2qUeW1SsRMQjosvGn2Khy
 Ein4fOgUojW4mzXoc9Q3Sz6NS/q6lJBZVXjDHLcwv8rFALX63D+MvW73w/m2ZWB8/laZG/CvJ
 AuUcvrWg9CdFsYNkBFzmXyxrJQl2KM3XtTHnbjmuhAYO47D+w61jawcp5q0FO1WHKbyTzlaHU
 ExqjGdmo7O4PQWdMBM7uyKBY4mTAxgxrD3oUQbU3FtlTcT2eZ0YeyDaQVw8xmXddidDuKh7/2
 +alcdV8sT0XlXDL/P6Iaopia5uydBVjYGCCZvFROaiDgF97wIS8kiBZ1mvYckA/TORsUbk3cT
 TtFlm2KiLE74qHlov5NAzEnoYtkt66dsveJ09/eMd/nW97hl0kklErQ/4IuF3JDxoBtIbRi+t
 JL7PMBe/uX3B2gSvovxFb/LkXVT/Tizx3mb8gXi96aRKUX4MU2LbaB4rPTudQT0x7dQWA06Ip
 SvaGEUBtQpkQ4tUx3Uneuo1F9cmEUhkfZApCYZB64TFIw408Z6jowscRxpGJquUsxHD6sz/Eu
 zP2cB4X/z2sQx0p/p/P38136i3uaNM0+iajD1NKunSjH0S9rZyCPhFs+czsmVW6HAqAXBIda1
 pTtgIR/QdSCuuEx0m10yPsE40K3sDUt4JJdKEaM2Yaf2kfMbFqI3GWMu6pmA5QoDZZQDe51w8
 urEiH9d39zhiRF3C9119zfb90UZ0nTjrQucUrsdkOLCjTDzo38Fx2L4YctEQ49gbKtQquPpwd
 x/uE/wqekthK8LF8h
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> in macb_mdio_write, =E2=80=A6

* Will a desire evolve to improve also this commit message?

* Will the tag =E2=80=9CFixes=E2=80=9D become helpful?


=E2=80=A6
> +++ b/drivers/net/ethernet/cadence/macb_main.c
=E2=80=A6
> @@ -3840,11 +3842,14 @@  static int at91ether_open(struct net_device *de=
v)
>
>  	ret =3D macb_phylink_connect(lp);
>  	if (ret)
> -		return ret;
> +		goto out;
>
>  	netif_start_queue(dev);
>
>  	return 0;
> +out:
> +	pm_runtime_put(&lp->pdev->dev);
> +	return ret;
>  }
=E2=80=A6

Perhaps use the label =E2=80=9Cput_runtime=E2=80=9D instead?

Regards,
Markus

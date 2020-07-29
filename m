Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43ECE232346
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 19:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgG2RRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 13:17:44 -0400
Received: from mout.web.de ([212.227.15.3]:37071 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726365AbgG2RRn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 13:17:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1596043020;
        bh=RKOWU4KnTFnmgAVqc36bMgqqFzdhsWbGy0mCh3maaGE=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=NYB/oLSk3EpyoHBrmXfzACnYCjQDyLql4xaQJSExVErhR+wROKFxMgoMJ8DjP06oE
         CwWhZ6jZr3Bi4sl5Ogh1bpy5Ztc0DIyGIv+Gob31nLdSXsRORAbph5w4RbOUY8+kxO
         JzOmDGU5XhCM5LUzp0TQ4Bwb0tjAggxCpzmY061U=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.243.175.129]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LuMER-1kk5xz0Ptn-011fSy; Wed, 29
 Jul 2020 19:17:00 +0200
To:     Xin Xiong <xiongx18@fudan.edu.cn>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Chas Williams <3chas3@gmail.com>,
        Yuan Zhang <yuanxzhang@fudan.edu.cn>
Subject: Re: [PATCH] atm: Fix atm_dev reference count leaks in
 atmtcp_remove_persistent()
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 mQINBFg2+xABEADBJW2hoUoFXVFWTeKbqqif8VjszdMkriilx90WB5c0ddWQX14h6w5bT/A8
 +v43YoGpDNyhgA0w9CEhuwfZrE91GocMtjLO67TAc2i2nxMc/FJRDI0OemO4VJ9RwID6ltwt
 mpVJgXGKkNJ1ey+QOXouzlErVvE2fRh+KXXN1Q7fSmTJlAW9XJYHS3BDHb0uRpymRSX3O+E2
 lA87C7R8qAigPDZi6Z7UmwIA83ZMKXQ5stA0lhPyYgQcM7fh7V4ZYhnR0I5/qkUoxKpqaYLp
 YHBczVP+Zx/zHOM0KQphOMbU7X3c1pmMruoe6ti9uZzqZSLsF+NKXFEPBS665tQr66HJvZvY
 GMDlntZFAZ6xQvCC1r3MGoxEC1tuEa24vPCC9RZ9wk2sY5Csbva0WwYv3WKRZZBv8eIhGMxs
 rcpeGShRFyZ/0BYO53wZAPV1pEhGLLxd8eLN/nEWjJE0ejakPC1H/mt5F+yQBJAzz9JzbToU
 5jKLu0SugNI18MspJut8AiA1M44CIWrNHXvWsQ+nnBKHDHHYZu7MoXlOmB32ndsfPthR3GSv
 jN7YD4Ad724H8fhRijmC1+RpuSce7w2JLj5cYj4MlccmNb8YUxsE8brY2WkXQYS8Ivse39MX
 BE66MQN0r5DQ6oqgoJ4gHIVBUv/ZwgcmUNS5gQkNCFA0dWXznQARAQABtCZNYXJrdXMgRWxm
 cmluZyA8TWFya3VzLkVsZnJpbmdAd2ViLmRlPokCVAQTAQgAPhYhBHDP0hzibeXjwQ/ITuU9
 Figxg9azBQJYNvsQAhsjBQkJZgGABQsJCAcCBhUICQoLAgQWAgMBAh4BAheAAAoJEOU9Figx
 g9azcyMP/iVihZkZ4VyH3/wlV3nRiXvSreqg+pGPI3c8J6DjP9zvz7QHN35zWM++1yNek7Ar
 OVXwuKBo18ASlYzZPTFJZwQQdkZSV+atwIzG3US50ZZ4p7VyUuDuQQVVqFlaf6qZOkwHSnk+
 CeGxlDz1POSHY17VbJG2CzPuqMfgBtqIU1dODFLpFq4oIAwEOG6fxRa59qbsTLXxyw+PzRaR
 LIjVOit28raM83Efk07JKow8URb4u1n7k9RGAcnsM5/WMLRbDYjWTx0lJ2WO9zYwPgRykhn2
 sOyJVXk9xVESGTwEPbTtfHM+4x0n0gC6GzfTMvwvZ9G6xoM0S4/+lgbaaa9t5tT/PrsvJiob
 kfqDrPbmSwr2G5mHnSM9M7B+w8odjmQFOwAjfcxoVIHxC4Cl/GAAKsX3KNKTspCHR0Yag78w
 i8duH/eEd4tB8twcqCi3aCgWoIrhjNS0myusmuA89kAWFFW5z26qNCOefovCx8drdMXQfMYv
 g5lRk821ZCNBosfRUvcMXoY6lTwHLIDrEfkJQtjxfdTlWQdwr0mM5ye7vd83AManSQwutgpI
 q+wE8CNY2VN9xAlE7OhcmWXlnAw3MJLW863SXdGlnkA3N+U4BoKQSIToGuXARQ14IMNvfeKX
 NphLPpUUnUNdfxAHu/S3tPTc/E/oePbHo794dnEm57LuuQINBFg2+xABEADZg/T+4o5qj4cw
 nd0G5pFy7ACxk28mSrLuva9tyzqPgRZ2bdPiwNXJUvBg1es2u81urekeUvGvnERB/TKekp25
 4wU3I2lEhIXj5NVdLc6eU5czZQs4YEZbu1U5iqhhZmKhlLrhLlZv2whLOXRlLwi4jAzXIZAu
 76mT813jbczl2dwxFxcT8XRzk9+dwzNTdOg75683uinMgskiiul+dzd6sumdOhRZR7YBT+xC
 wzfykOgBKnzfFscMwKR0iuHNB+VdEnZw80XGZi4N1ku81DHxmo2HG3icg7CwO1ih2jx8ik0r
 riIyMhJrTXgR1hF6kQnX7p2mXe6K0s8tQFK0ZZmYpZuGYYsV05OvU8yqrRVL/GYvy4Xgplm3
 DuMuC7/A9/BfmxZVEPAS1gW6QQ8vSO4zf60zREKoSNYeiv+tURM2KOEj8tCMZN3k3sNASfoG
 fMvTvOjT0yzMbJsI1jwLwy5uA2JVdSLoWzBD8awZ2X/eCU9YDZeGuWmxzIHvkuMj8FfX8cK/
 2m437UA877eqmcgiEy/3B7XeHUipOL83gjfq4ETzVmxVswkVvZvR6j2blQVr+MhCZPq83Ota
 xNB7QptPxJuNRZ49gtT6uQkyGI+2daXqkj/Mot5tKxNKtM1Vbr/3b+AEMA7qLz7QjhgGJcie
 qp4b0gELjY1Oe9dBAXMiDwARAQABiQI8BBgBCAAmFiEEcM/SHOJt5ePBD8hO5T0WKDGD1rMF
 Alg2+xACGwwFCQlmAYAACgkQ5T0WKDGD1rOYSw/+P6fYSZjTJDAl9XNfXRjRRyJSfaw6N1pA
 Ahuu0MIa3djFRuFCrAHUaaFZf5V2iW5xhGnrhDwE1Ksf7tlstSne/G0a+Ef7vhUyeTn6U/0m
 +/BrsCsBUXhqeNuraGUtaleatQijXfuemUwgB+mE3B0SobE601XLo6MYIhPh8MG32MKO5kOY
 hB5jzyor7WoN3ETVNQoGgMzPVWIRElwpcXr+yGoTLAOpG7nkAUBBj9n9TPpSdt/npfok9ZfL
 /Q+ranrxb2Cy4tvOPxeVfR58XveX85ICrW9VHPVq9sJf/a24bMm6+qEg1V/G7u/AM3fM8U2m
 tdrTqOrfxklZ7beppGKzC1/WLrcr072vrdiN0icyOHQlfWmaPv0pUnW3AwtiMYngT96BevfA
 qlwaymjPTvH+cTXScnbydfOQW8220JQwykUe+sHRZfAF5TS2YCkQvsyf7vIpSqo/ttDk4+xc
 Z/wsLiWTgKlih2QYULvW61XU+mWsK8+ZlYUrRMpkauN4CJ5yTpvp+Orcz5KixHQmc5tbkLWf
 x0n1QFc1xxJhbzN+r9djSGGN/5IBDfUqSANC8cWzHpWaHmSuU3JSAMB/N+yQjIad2ztTckZY
 pwT6oxng29LzZspTYUEzMz3wK2jQHw+U66qBFk8whA7B2uAU1QdGyPgahLYSOa4XAEGb6wbI FEE=
Message-ID: <444f9cec-db06-c3b1-eadc-14b11260a4ec@web.de>
Date:   Wed, 29 Jul 2020 19:16:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:DwWHRbDtrBGH1idtyQUY7BlxMNsJhg58nZahHAbWideycf9caWH
 ww9N+Hgl1F8yvlQL4B/rh+rJJ2Ckb1PihTCpUFrDZ6tfhhuzlcz6WAIchm1ix15TH2HcgG5
 wHG2huel/NW32+rFz2fkwiaJdak1xiLAokXpwTBKw9KkQTyJyUBUdKPG7SnzCKjmfBikHF3
 KTtCjc7+5z+hUuejDqq9g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:tX5pEz0tZi4=:0yRs8JcDOcmAuFK7pxzMgZ
 0kMV9V360etoBkV2bWLFoWEZTPYz3u+IhPGPCEugihkxFdV3+PqrjOE7oM/OLWmJGCJubmLSY
 7OMYiZ2MQvfY8MlJ3dnEU3PARuenT6ngmVrgMGJ2vxYa67tlqAGHS5KhqhtFq3agNIaHhGYRO
 ajG78UDct+rlx7HNK/5WH0WWPJpss2k5GtGz/lZrQO3M1zxufY7Few7/RRZ2pJcDUR8cEidGe
 6TcSD3RvPI/6pdpcwPfu6B4p3GZJSITSCohiMZFzzhJKE3CNQcOJVhmw2GZ139JkeyHJlXP9M
 kcIqTGW0T9Q+4IUr0XK8DBgvAIvP1im/ctHyV+Mimc2ummJapheFlZpCvFlIuwo5Tmm3xU9Xr
 u9hrdnPqTS2jIK9TcJAG+j/cjRR0Q5xYmA9bltc65xrCbqu1qXFSP3mpuMajeSOqAFKroBPqS
 C3f2lMvkk8h9QhgPtT28v7BtXXiluDiC1K8GCvF4cRsHTTRmw3bdJ0NS+7mpBZIXM1NwJgCV9
 SgVlccfx3X0qJjQKTNyVO4zjH1C8Cso6OrzzzRI1tmUWOgcC2Qe0J1R7OpUow3Cr+Tg7l7Rld
 BiE08lHqCZYFcBYZO00SVIQLCAfG2HzxIZ8qzyWS4i9Mo7vz1euzdDLr2PPWlLryMfIdBzlJy
 T8KpWmi7pkG3cnuhq4n6TVkvKNYypxtwfXyF5UHGPICMu9zwQNZP8e5RclCRyRxSt7gsQsF3i
 g0L1EPR+9BeqYpddk/fra9tC7F4ISqAXE0gBdP6U18t41SwOofSmBlxbUvRHP0n0L4oGwlo+K
 0chsRv7YXok2EQ70lhVl/vDlDlC5Je1Csq14fMTcif1xqV0jk5+TSUPpXpLkTQuYB80tZG8o5
 bFL7OdGYzHqK0ZUaf7OVLgAcJYsgKnBrns7cbD7EIT7cbTjsv44XYAmgd11Yrm/HHqv/VKw5h
 OonviGHwbhqqfE5unrbs8Ax7NUKv+g+ZpmDHBTjySElQwTHd4fOwgQpMpTF1x4juFeSnxN6Zv
 dKF3Czf63ehsicHtjnuq0OPYbJw+q4THEbYzfuOxjvGQrEAEgfPAJXY3YP5c9kCYjXqLQmYYg
 lCy6m5dIG2CMNF+rh9Ppbbu5VYac7yrcVlfD/haUtIvvTkTLBdjSo8BGT0O3j04wtzZjQwxBk
 jkVlTE9l0EOSE79EsCtrDAoeX6moct9x4TxgZ1rGcm7Q6rnZUWNWIxzD5j6GAttBsp4mFnHkT
 xjCBMYXxu5MI5PFlfXwttKAlDUooSfdRorvHMQQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=E2=80=A6
> The refcount leaks issues occur in two error handling paths.

Can it be nicer to use the term =E2=80=9Creference count=E2=80=9D for the =
commit message?


> Fix the issue by =E2=80=A6

I suggest to replace this wording by the tag =E2=80=9CFixes=E2=80=9D.


=E2=80=A6
> +++ b/drivers/atm/atmtcp.c
> @@ -433,9 +433,15 @@  static int atmtcp_remove_persistent(int itf)
>  		return -EMEDIUMTYPE;
>  	}
>  	dev_data =3D PRIV(dev);
> -	if (!dev_data->persist) return 0;
> +	if (!dev_data->persist) {
> +		atm_dev_put(dev);
> +		return 0;
> +	}
=E2=80=A6

I propose to add a jump target for the desired exception handling
in this function implementation.

+	if (!dev_data->persist)
+		goto put_device;


Regards,
Markus

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF84C1F9212
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 10:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729174AbgFOIqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 04:46:02 -0400
Received: from mout.web.de ([212.227.15.3]:37459 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728496AbgFOIqB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jun 2020 04:46:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1592210742;
        bh=JGcaxb9uC8/GIXTkKSm8CjGX2H5RAr1V3fXLz/6gII8=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=MAChBveDvgIxdveper6xK699rebLGSM1vP26RWeOgE4gkK1NH7guBldP+nx1bZ29T
         CjrG7riRpFOFPQSMVMfpbvv3Ibrdc25/lviZ0nbC3Cq31ID2d97Eu0bxweewIbUTgZ
         cJfurKYntfdYHuXyeLI2LVlCtoogC+jgODz/TW1s=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.49.107.236]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MCXVX-1jb5xl0rx5-009hnV; Mon, 15
 Jun 2020 10:45:42 +0200
Subject: Re: [PATCH v3 1/2] perf tools: Fix potential memory leaks in perf
 events parser
To:     Cheng Jian <cj.chengjian@huawei.com>,
        Chen Wandun <chenwandun@huawei.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <20200615013614.8646-1-chenwandun@huawei.com>
 <20200615013614.8646-2-chenwandun@huawei.com>
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
Message-ID: <507a2266-39cd-0887-1b6b-59764fddd153@web.de>
Date:   Mon, 15 Jun 2020 10:45:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200615013614.8646-2-chenwandun@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:U53p0p61XPkAW6db9bX187NL4fIf0KOAD3ZHpaj+OoBBJhJ9svS
 X1icW9Wa3mdjP6C6+redUYsiVI/LlgBwnuHHhlRkWiruKSdeFmhmYhgNeiN1qtod2vdM2sU
 Yq2cywBaw/4MsZ7nVcjqtuCU0H3nSgUsAymNuxCTbUB9uXUZTvVzMJroJ/u8rpTR6ZcGyDm
 nO625yzktKzWBxKlc9pFw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:qm6Zvz9obEQ=:Zw5ZSSSrUoh5rWUE2HBh99
 BAA+rTn+bJ36V2YAL1drp3EHw+O+uIBk1B5gd/b7Ym8AybV6LaNhMEGbCdCYWkJuO9FrWBgKW
 v0j5rI8wzhtVD0j4vedjU7rNbeATWZl2NsRoDj77bFDlZOB7ZyXpClXPJ3bZ6yr6n8SbM0D3e
 Z4XFFdOW+EpdyPSM/TDJyPWFV5NQvuZzEAZ8wqla1IC4d65dwhClHxPzm+wh4r79YTLflHxjF
 +/eW8imI+/UuwtDAZywbsArM4eGXYxQUtR8NvkrRPRPeY/SiCn22TaOCriyM2uVcehR8wmGB6
 giLDkDqiBVJII06AJEoEh2Viq3v9g7khJ9KEI5ft6OMGE34uYwGXONci+UMbxYLd2IOrJQVlu
 KZ6bk2OF6MEx+oOHHUaybvouTH6ETJmv7T9GAa3Duz0LqPENEOn9I+7O2FriToMfwozkW+GtY
 RdElwhzZRE0DvhDH7DbUeBlt1eyS6BKEhrIgz+l+8OCGlfFfXItgYTJeGTDOJ2eC3ULrPpuof
 OSgCM3GozpEGzRgYjiTIiePkUvndaJ3HKCkbpBN2tT+qQZkVxOWycrDsgN/WVtDvqtqtk46mX
 nKIx2xV+qT1AqSfKf9rpVDDhPHPxkqN4034L0/oQtE8fkIYsF8JphPGMDgRB+xrIt9YGyQEz+
 HuVPRjcX/bX9htCxFdKQ9W4ZlrT/JJokA3UMzdINmTffLr2dLKXn2xB39kcJbnAb7AxgV+UqS
 epQJzTiUN4/+q5b2o/YjPENrFquLNZZjUnLJ/nITXicL7UbdOpT4JDM+9AtfCT05+EeaQldHB
 ckHdiddNSZ4KDpmVsDScUlyxqUS4odIC6gy2exh96a1af6sc0jc1pa8fcHgcp9rX2kImDCc5R
 uTDbBHSKX0XGbolOGxUEJ1N+2gTykw6aG2BEem7rxl8oGyfNdJjnJJZakXhSfCyv42p/0R6WK
 d3tQP5VR3k0UERCUO4ohX7JHXFYQuNxgWoUpO/wGZVlG/18fCBYdHV2TGJdWo0WiapvlS7H4W
 Q/wI0oRg1t5qeMr5/4WxkgrMqR2zbrOw6Yedexaa3rlCBeM7Mw3EyLD9/iCVgaZdxXVOJ5JnY
 QN/bCwzXJCZDEDIRHWOGZ7+gqgfIpFPZ3CRuOEUaV7X+xisQ0vJXnDywWQaquG/YkCahm5JQ1
 zhtEpX5C3RVuC64OFSk369eCTdC8ARAxxFotWk8qkIog98Mvg8Eg1UgHwLPsR4F2uIL4Zbh07
 m2qJRvXWqTuHcXeIh
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Fix memory leak of in function parse_events_term__sym_hw()
> and parse_events_term__clone() when string duplication failed.

Can a wording like =E2=80=9CFix memory leaks in =E2=80=A6=E2=80=9D be more=
 appropriate for
the final commit message?
Would you find any other description variant more pleasing?

Regards,
Markus

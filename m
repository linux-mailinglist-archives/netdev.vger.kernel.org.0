Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAC1552521C
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 18:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356043AbiELQJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 12:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356019AbiELQJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 12:09:17 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764A5266C8C;
        Thu, 12 May 2022 09:09:16 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id t25so7110024ljd.6;
        Thu, 12 May 2022 09:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to;
        bh=q7HVl+Utpg1SyMvAWZN6OnIK4mbZ1eVpTUJ6pJovLcE=;
        b=OBqdcsDBk+kcAKGXC1nZg0aATlSM/88AxbkEe9ntiMnWfeDtzBkYLrTJbvEWwUqc2D
         6HV3kHE8tuesP1AK/hCjTDKo0gq5qDoVPfNlAwElUMn8fbA/jNb9tVN1mQ43fWuBmigA
         rsjJODCeX9kJspK6LL6ICV7dhjl5DGH4WAwlIcE1UqkK5S6w3pdHn7i/TkKfMypadOuB
         dwv1h6mbpqiF3ktbiEYS2gCJwMmoQ0wbhCK1TKwBrJ4mDYFISGuywMLrfEf0p3kI0DrC
         jVrNjptkCSFrIHudGxUFWegU/m6NqrT76xcnixD9SskPNkZSss/f0+aisnYbijEOSMFf
         cgxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to;
        bh=q7HVl+Utpg1SyMvAWZN6OnIK4mbZ1eVpTUJ6pJovLcE=;
        b=gxaJ0jwkjMd9YmjajT3DCfNFOuLlbPyKDyVo2R+ByN9CMXooKtr8CIgxR97dVi15Hx
         0QwOApugTV7F7vaVqeKoWpvOViQEqtfcyF7M36fmwaUCzfg85Sc6X1914YsabRQXT/r6
         CXsjit9HtVQ/Xyedg1UcpEjEjB7ZhQSWYDr+9LNt53ivOadYXUWze0vU3LDBE/QK89jv
         ec7MIgX2Igc8ftFwqFRjE8hVr9o0+iQjrjC8nSPusaGhPt1XZrcQgIdyI5xlOr3NrNei
         u3xISf6LvufLlwE85veGDQONYsv2r4QT2PLmz6SLCN7vrZLCv9yh0EFaSkALCNr34eOV
         A/+g==
X-Gm-Message-State: AOAM532xONiyxfIcpvtMzt+7EYFQkpyC65gKRlxBujzLv8dhQdk29keN
        NbiBf1lcIvma71M8PjlHC0Q=
X-Google-Smtp-Source: ABdhPJy81TMx3aN1urlNOKVhb1nwGm9zpqK9JHGLQADFcS01Wx2lV6Lup8GM9bGeGjQbIYrRSD7wrw==
X-Received: by 2002:a2e:93d0:0:b0:24f:255d:4bb1 with SMTP id p16-20020a2e93d0000000b0024f255d4bb1mr415847ljh.525.1652371754612;
        Thu, 12 May 2022 09:09:14 -0700 (PDT)
Received: from [192.168.1.11] ([217.117.245.216])
        by smtp.gmail.com with ESMTPSA id h13-20020a2e9ecd000000b0024f3d1daee2sm912260ljk.106.2022.05.12.09.09.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 09:09:13 -0700 (PDT)
Message-ID: <2d0f70e2-947f-62ff-b5e5-31e78123b07a@gmail.com>
Date:   Thu, 12 May 2022 19:09:12 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 1/2] ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
Content-Language: en-US
To:     Jeff Johnson <quic_jjohnson@quicinc.com>,
        ath9k-devel@qca.qualcomm.com, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, toke@toke.dk,
        linville@tuxdriver.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+03110230a11411024147@syzkaller.appspotmail.com,
        syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
References: <80962aae265995d1cdb724f5362c556d494c7566.1644265120.git.paskripkin@gmail.com>
 <fa713d4a-a3ef-2837-d220-857ed1e5538c@quicinc.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <fa713d4a-a3ef-2837-d220-857ed1e5538c@quicinc.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------FbSSUQGk3h5hwARZTDS5doC2"
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------FbSSUQGk3h5hwARZTDS5doC2
Content-Type: multipart/mixed; boundary="------------syyuxWf8nyyz7ywzlMgWOBQB";
 protected-headers="v1"
From: Pavel Skripkin <paskripkin@gmail.com>
To: Jeff Johnson <quic_jjohnson@quicinc.com>, ath9k-devel@qca.qualcomm.com,
 kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org, toke@toke.dk,
 linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzbot+03110230a11411024147@syzkaller.appspotmail.com,
 syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
Message-ID: <2d0f70e2-947f-62ff-b5e5-31e78123b07a@gmail.com>
Subject: Re: [PATCH v3 1/2] ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
References: <80962aae265995d1cdb724f5362c556d494c7566.1644265120.git.paskripkin@gmail.com>
 <fa713d4a-a3ef-2837-d220-857ed1e5538c@quicinc.com>
In-Reply-To: <fa713d4a-a3ef-2837-d220-857ed1e5538c@quicinc.com>

--------------syyuxWf8nyyz7ywzlMgWOBQB
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgSmVmZiwNCg0KT24gNS8xMi8yMiAxOTowNSwgSmVmZiBKb2huc29uIHdyb3RlOg0KPiBP
biAyLzcvMjAyMiAxMjoyNCBQTSwgUGF2ZWwgU2tyaXBraW4gd3JvdGU6DQo+IFsuLi5zbmlw
Li4uXQ0KPj4gICANCj4+ICAgI2lmZGVmIENPTkZJR19BVEg5S19IVENfREVCVUdGUw0KPj4g
LQ0KPj4gLSNkZWZpbmUgVFhfU1RBVF9JTkMoYykgKGhpZl9kZXYtPmh0Y19oYW5kbGUtPmRy
dl9wcml2LT5kZWJ1Zy50eF9zdGF0cy5jKyspDQo+PiAtI2RlZmluZSBUWF9TVEFUX0FERChj
LCBhKSAoaGlmX2Rldi0+aHRjX2hhbmRsZS0+ZHJ2X3ByaXYtPmRlYnVnLnR4X3N0YXRzLmMg
Kz0gYSkNCj4+IC0jZGVmaW5lIFJYX1NUQVRfSU5DKGMpIChoaWZfZGV2LT5odGNfaGFuZGxl
LT5kcnZfcHJpdi0+ZGVidWcuc2ticnhfc3RhdHMuYysrKQ0KPj4gLSNkZWZpbmUgUlhfU1RB
VF9BREQoYywgYSkgKGhpZl9kZXYtPmh0Y19oYW5kbGUtPmRydl9wcml2LT5kZWJ1Zy5za2Jy
eF9zdGF0cy5jICs9IGEpDQo+PiArI2RlZmluZSBfX1NUQVRfU0FWRShleHByKSAoaGlmX2Rl
di0+aHRjX2hhbmRsZS0+ZHJ2X3ByaXYgPyAoZXhwcikgOiAwKQ0KPj4gKyNkZWZpbmUgVFhf
U1RBVF9JTkMoYykgX19TVEFUX1NBVkUoaGlmX2Rldi0+aHRjX2hhbmRsZS0+ZHJ2X3ByaXYt
PmRlYnVnLnR4X3N0YXRzLmMrKykNCj4+ICsjZGVmaW5lIFRYX1NUQVRfQUREKGMsIGEpIF9f
U1RBVF9TQVZFKGhpZl9kZXYtPmh0Y19oYW5kbGUtPmRydl9wcml2LT5kZWJ1Zy50eF9zdGF0
cy5jICs9IGEpDQo+PiArI2RlZmluZSBSWF9TVEFUX0lOQyhjKSBfX1NUQVRfU0FWRShoaWZf
ZGV2LT5odGNfaGFuZGxlLT5kcnZfcHJpdi0+ZGVidWcuc2ticnhfc3RhdHMuYysrKQ0KPj4g
KyNkZWZpbmUgUlhfU1RBVF9BREQoYywgYSkgX19TVEFUX1NBVkUoaGlmX2Rldi0+aHRjX2hh
bmRsZS0+ZHJ2X3ByaXYtPmRlYnVnLnNrYnJ4X3N0YXRzLmMgKz0gYSkNCj4gDQo+IGl0IGlz
IHVuZm9ydHVuYXRlIHRoYXQgdGhlIGV4aXN0aW5nIG1hY3JvcyBkb24ndCBhYmlkZSBieSB0
aGUgY29kaW5nIHN0eWxlOg0KPiAJVGhpbmdzIHRvIGF2b2lkIHdoZW4gdXNpbmcgbWFjcm9z
Og0KPiAJbWFjcm9zIHRoYXQgZGVwZW5kIG9uIGhhdmluZyBhIGxvY2FsIHZhcmlhYmxlIHdp
dGggYSBtYWdpYyBuYW1lDQo+IA0KPiB0aGUgY29tcGFuaW9uIG1hY3JvcyBpbiBhdGg5ay9k
ZWJ1Zy5oIGRvIHRoZSByaWdodCB0aGluZw0KPiANCj4gcGVyaGFwcyB0aGlzIGNvdWxkIGJl
IGdpdmVuIHRvIEtlcm5lbCBKYW5pdG9ycyBmb3Igc3Vic2VxdWVudCBjbGVhbnVwPw0KDQpU
aGFua3MgZm9yIHBvaW50aW5nIHRoYXQgb3V0IQ0KDQpJIHdpbGwgY2xlYW4gdGhlbSB1cCBp
biBuZXh0IHZlcnNpb24uIEkgdGhpbmssIGl0IHdpbGwgYmUgbXVjaCBlYXNpZXIgDQp0aGFu
IHByb3Bvc2luZyB0aGlzIHRhc2sgdG8gS2VybmVsIEphbml0b3JzLg0KDQoNCg0KDQpXaXRo
IHJlZ2FyZHMsDQpQYXZlbCBTa3JpcGtpbg0K

--------------syyuxWf8nyyz7ywzlMgWOBQB--

--------------FbSSUQGk3h5hwARZTDS5doC2
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEER3XL3TplLQE8Qi40bk1w61LbBA0FAmJ9MSgFAwAAAAAACgkQbk1w61LbBA2L
Vw/7BqiVrZrr6FJjuJLk7/VjIxnUDfogD9V/hfdJLB+ojqKI4jAr491Cy4n4pwzhJo1QZr9N/r9k
K7XXOqEyteQ3P3HfA0H4NmfRtYY02ybvqJuOrle0SU+NNCug2tYUZXo9wGlHwl7fF8zRGtUnI8ds
3n+mOfjFnrGDi+y8s7qMnnrz4nV7NR1QF+g5WEq2W5fN5ZdlfXnIov/Ccnzr3DJU3152IpL5RjTE
yW/5NHYZxLrCgzyWgnascigOBQuFdqEWvWUrDdMOCx1qCaFlMXcpKlGUxlrbBdmmvRLQrTRIPEMl
XZO79M+OJiBXiKORe9WPJgoanSXz6Cq5cX1BgTVmCRe1GpzZLPBakNrcJUilGm6RSEZ86wyKByCf
Fa0HnR26ir8NHL1RDJgcPHnCU5cgzBY8TLXbGU5H8jRAx2/mWNq4SsMhAvxDxxE1h3k2luGkFB5U
oehS7ah+iW/E8qDM5V+3y2izC9Bs2B/AsRJU5OCFh5g+yaaGBQWN4OMSzdsc2Gkq1NpfjWjFnSbK
fux2rTZvLQm9A/PvkzjDqQ5nnjRqhdJsVlkTx1lu+MEB44M1zd5tAO7gfuSB39TbUl4eY00zzRru
+bus6qfu5HXcGZNZ/fpky33TD8gI6tQHRBYhzfe2V9rZFK/7K33vsSzIP4KtvYGrOvBLFvU1Au8C
fCE=
=wQOx
-----END PGP SIGNATURE-----

--------------FbSSUQGk3h5hwARZTDS5doC2--

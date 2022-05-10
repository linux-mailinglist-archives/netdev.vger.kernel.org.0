Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D73985224B9
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 21:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233804AbiEJT0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 15:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbiEJT0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 15:26:45 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF13275FE;
        Tue, 10 May 2022 12:26:43 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id bx33so11173173ljb.12;
        Tue, 10 May 2022 12:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to;
        bh=IUXybCQUFThKdCNEqN5u9zMW6VV3o+zaDhphqPVtzo8=;
        b=GJiUDAVFBm8/v4Pn2aadjp0NPycBhyOo0ctyC1pNS0SOqCZWjjhr5LiNTZcdd98w2S
         XNBHrFj2ET0d6jxaxK4enAkRMMAK7Lc+mhaqdZlPHoQAGdXR2/M2NUqcv6ghQGYUcuB8
         JzOZ8iMiYPTBZNGchii4do93tDHOpVyX4G91WihBMkVjlMRmISkOPT/+9Tp+7AUZSKuf
         yIMPiNJ/8D2dde3YSIXnnHvqxduwyy0gjuuqsC42BkvbdNUccjuKm3lnR3k/JucJ5BCA
         nLHQmwaZ/waN/y4EpTPMr5NOWX8ys/2+QZNba/T/XoXj3F6MxhfkhMRLIpPaE0cHB8C9
         YOLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to;
        bh=IUXybCQUFThKdCNEqN5u9zMW6VV3o+zaDhphqPVtzo8=;
        b=CEUVaB7VNaX6gun3fDXZddEa7lH2DoxURQayUUzVUJz/AoFYkhYCS47VXhkDOETD5E
         M8l+cqd6knBqpiXPYUMLRKHWW6FWsZDRwULB/c/2IwseWoOrOwaFUBeWW7rtEjhKY4pW
         MoSlROFAmua7R/zc1gaY8ZS/CkRd+jC8nqmReVlQPkhMuJYtm9G7/D+Ds51jR++sD3mm
         1xA2M8OKPMhKlJK/YmNWSe8GQlWqapjZQVqbQcV6Gps5RjMgkrZFSpU03qQKjTRgqDEs
         KsSQNm+Y3LOLowr1ShXWFRwDcqyQ2ZfPwvp4jxmjQim9O1LBfev7CKJCVy7E+rx1riij
         X9oA==
X-Gm-Message-State: AOAM532Rpa36G44CfyH+6la8q4e/B/5mr2ePla7aT63MomN/iKYy7HTU
        jGhS5OUwMTYpBYP+UGWBKbI=
X-Google-Smtp-Source: ABdhPJxr2WAYgRg0U2eGs1fFi6+EcLHo41RGad+yO9G8CudIIkNazwG/Ix2borZTefQxXlS0V5VpyQ==
X-Received: by 2002:a2e:a7cd:0:b0:24f:548f:e20a with SMTP id x13-20020a2ea7cd000000b0024f548fe20amr15275783ljp.227.1652210801501;
        Tue, 10 May 2022 12:26:41 -0700 (PDT)
Received: from [192.168.1.11] ([217.117.245.216])
        by smtp.gmail.com with ESMTPSA id bu37-20020a05651216a500b0047255d210f0sm2383061lfb.31.2022.05.10.12.26.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 12:26:40 -0700 (PDT)
Message-ID: <426f6965-152c-6d59-90e0-34fe3cd208ee@gmail.com>
Date:   Tue, 10 May 2022 22:26:38 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 1/2] ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
Content-Language: en-US
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        ath9k-devel@qca.qualcomm.com, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, linville@tuxdriver.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+03110230a11411024147@syzkaller.appspotmail.com,
        syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
References: <80962aae265995d1cdb724f5362c556d494c7566.1644265120.git.paskripkin@gmail.com>
 <87h799a007.fsf@toke.dk> <6f0615da-aa0b-df8e-589c-f5caf09d3449@gmail.com>
 <5fd22dda-01d6-cfae-3458-cb3fa23eb84d@I-love.SAKURA.ne.jp>
 <3cb712d9-c6be-94b7-6135-10b0eabba341@gmail.com>
 <d9e6cf88-4f19-bd50-3d73-e2aee1caefa4@I-love.SAKURA.ne.jp>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <d9e6cf88-4f19-bd50-3d73-e2aee1caefa4@I-love.SAKURA.ne.jp>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------BATau5CkBXWcUclrZmbO8r5K"
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------BATau5CkBXWcUclrZmbO8r5K
Content-Type: multipart/mixed; boundary="------------k6UaX4vPIZFyDG04TTJwV9Li";
 protected-headers="v1"
From: Pavel Skripkin <paskripkin@gmail.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
 ath9k-devel@qca.qualcomm.com, kvalo@kernel.org, davem@davemloft.net,
 kuba@kernel.org, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzbot+03110230a11411024147@syzkaller.appspotmail.com,
 syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
Message-ID: <426f6965-152c-6d59-90e0-34fe3cd208ee@gmail.com>
Subject: Re: [PATCH v3 1/2] ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
References: <80962aae265995d1cdb724f5362c556d494c7566.1644265120.git.paskripkin@gmail.com>
 <87h799a007.fsf@toke.dk> <6f0615da-aa0b-df8e-589c-f5caf09d3449@gmail.com>
 <5fd22dda-01d6-cfae-3458-cb3fa23eb84d@I-love.SAKURA.ne.jp>
 <3cb712d9-c6be-94b7-6135-10b0eabba341@gmail.com>
 <d9e6cf88-4f19-bd50-3d73-e2aee1caefa4@I-love.SAKURA.ne.jp>
In-Reply-To: <d9e6cf88-4f19-bd50-3d73-e2aee1caefa4@I-love.SAKURA.ne.jp>

--------------k6UaX4vPIZFyDG04TTJwV9Li
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgVGV0c3VvLA0KDQpPbiA1LzYvMjIgMDI6MzEsIFRldHN1byBIYW5kYSB3cm90ZToNCj4g
T24gMjAyMi8wNS8wNiA0OjA5LCBQYXZlbCBTa3JpcGtpbiB3cm90ZToNCj4+Pj4gQW5kIHdl
IGNhbiBtZWV0IE5VTEwgZGVmZXIgZXZlbiBpZiB3ZSBsZWF2ZSBkcnZfcHJpdiA9IHByaXYg
aW5pdGlhbGl6YXRpb24NCj4+Pj4gb24gaXQncyBwbGFjZS4NCj4+Pg0KPj4+IEkgZGlkbid0
IGNhdGNoIHRoZSBsb2NhdGlvbi4gQXMgbG9uZyBhcyAiaHRjX2hhbmRsZS0+ZHJ2X3ByaXYg
PSBwcml2OyIgaXMgZG9uZQ0KPj4+IGJlZm9yZSBjb21wbGV0ZV9hbGwoJmhpZl9kZXYtPmZ3
X2RvbmUpIGlzIGRvbmUsIGlzIHNvbWV0aGluZyB3cm9uZz8NCj4+Pg0KPj4gDQo+PiBJIGRv
bid0IHJlYWxseSByZW1lbWJlciB3aHkgSSBzYWlkIHRoYXQsIGJ1dCBsb29rcyBsaWtlIEkg
anVzdCBoYXZlbid0IG9wZW5lZCBjYWxsYmFja3MnIGNvZGUuDQo+IA0KPiBPSy4gVGhlbiwg
d2h5IG5vdCBhY2NlcHQgUGF2ZWwncyBwYXRjaD8NCg0KQXMgeW91IG1pZ2h0IGV4cGVjdCwg
SSBoYXZlIHNhbWUgcXVlc3Rpb24uIFRoaXMgc2VyaWVzIGlzIHVuZGVyIHJldmlldyANCmZv
ciBsaWtlIDctOCBtb250aHMuDQoNCkkgaGF2ZSBubyBhdGg5IGRldmljZSwgc28gSSBjYW4n
dCB0ZXN0IGl0IG9uIHJlYWwgaHcsIHNvIHNvbWVib2R5IGVsc2UgDQpzaG91bGQgZG8gaXQg
Zm9yIG1lLiBJdCdzIHJlcXVpcmVtZW50IHRvIGdldCBwYXRjaCBhY2NlcHRlZC4NCg0KDQoN
CldpdGggcmVnYXJkcywNClBhdmVsIFNrcmlwa2luDQo=

--------------k6UaX4vPIZFyDG04TTJwV9Li--

--------------BATau5CkBXWcUclrZmbO8r5K
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEER3XL3TplLQE8Qi40bk1w61LbBA0FAmJ6vG4FAwAAAAAACgkQbk1w61LbBA1E
Zg/8CwLw9k6BaW1V2yplq/GbSphq8z/IO+Wruh6yhU8dlBbKlPVi/kAMyH73nDfPMRaSvd8ddbYP
AawqoZ5DdMKuSAHAu0Ttsq3QNoeXM6j0cEGp2QaWeVGLzP1tUSr0/rZ/ISCQ9AgMT4wu5w5DFZgp
7yoBesT+SxvBPN82ldOiUvOt46IBSRGx2rNhVeHLTClerjtEnjYAUEB44GyiMj614sdYHrcMld7B
qjUTo0gMAPaUM6wZfxJZgHHDt+o+57+YEaWYfm+UvY/jSTVI/c+1j5CgZ2cyH/4yp0hEhvVCW6KT
yLGJJgvv4elspCi6YQ5YRO3SrCZMHHzjO2FQLhHNtApJU6xbpottVeeGhWNct/7Ry1jujcZ/gblh
tP9dSZcjIvjErtFIiTvcmY7oot9dKlpuEnz/ygDbikR6kOl97LVtQ1tbsJn2IvcGowuTm90nNw+P
Lbkiq+A2Kmy6jjgYdTipHAMjTufvzMS7AvzyqKZy/4iTRqBHghF3VYUhAjQ4T+SxgKhjYn94eF3p
9vBVxm4dh3gIZTSN6g+BVlHd5y86eHJivJ2HrEx8S/7SVbP58c6a34ABVc9Yo370XqB5m83TS+Oa
ePp4OmoiA4amCKsMLt/hyxIv6x1xT+o1IIkGUQKwEpDVE0+P31+mogoSdw/CA2ZkD8ptF3PlgnAg
JJE=
=ZEPX
-----END PGP SIGNATURE-----

--------------BATau5CkBXWcUclrZmbO8r5K--

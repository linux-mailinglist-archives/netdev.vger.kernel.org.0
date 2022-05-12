Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32036524D98
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 14:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353934AbiELM4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 08:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354028AbiELM4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 08:56:05 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328A4F04;
        Thu, 12 May 2022 05:56:03 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id t25so6384679ljd.6;
        Thu, 12 May 2022 05:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to;
        bh=6F3vstYH1qrxly4uqkQ8KYscVOMCcKCsii+O/J10edk=;
        b=NDAG2eelqf1EyzdBNRR6Kk0YOQP6DFhC61pBHXBY6voTrbHtPOqtizgcJ8MPgFm5eo
         zv4jAl2wwcM9zNibjIacmj/lkyuUwgB15d4+xhwUFAPLCUk6PltUbC9NkOVY/TJ7orD/
         svqccNCxpPfGawGDBCWcsGa7aDRpoEqwHpqJNaZrsyaMaXXG9yTCTPKSyhqj2++7BXxF
         iBAHwmiDSUAy+EDT1IKpJx2/vryRz3ZglMQU1aQ+cxn/jx/Iu5J2PpGXJzEZpbOAgqqx
         1Zj2Q6G4P77pNBnI5n8DvwHcJomOPbVzSW/+CnlTuuOL9XfO/QSX8WNc3/xx9L4Bo8qN
         mihA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to;
        bh=6F3vstYH1qrxly4uqkQ8KYscVOMCcKCsii+O/J10edk=;
        b=0nDKRMQYizAHd45GAbGdIYeeKDGrThAvL5EVOYbaFTs5f9FQyeIptznIzo1dlEHLUP
         jYzxS32sS50uRtDvs/s6+GkC7CCQvNYor6n7MuXfv4De7Q3UEA2VmnARAOOt0hnR6ZBY
         Z1MsCfoJoM6N07jeaz94DV46bUBr8MgNT5TT14egcTS6TXRk3V2VG2UpRB+u9J3kbJJF
         9FFOJbJS0DX7nS9Xmtb8P65y+Zmw30RhqMp+5qv//7HlN21BGtX5YEHoSk/yKyrJk9go
         IgVseanSN7UQgBh4i5tkhZYdMdJjRIrgYCBOaGj9B72lQJJC0/1Eua7zdQZ38NZfBUoA
         WKfQ==
X-Gm-Message-State: AOAM533k6ClCiKwrHJOVjkTRDLpMFygjUSIITcrtuCjoCFcJ0Y+ovXgN
        QvbqMxZP/mLlzl8lJT0m7PuhHHpebqFc2Q==
X-Google-Smtp-Source: ABdhPJyRre5QMLd+Ga0VNRH72Af7u7LsDP3No1B3Yfuw/QryIGCWpB0VVLLq3iykzXtVeBcYRSD6ag==
X-Received: by 2002:a2e:3112:0:b0:24f:132a:fd71 with SMTP id x18-20020a2e3112000000b0024f132afd71mr20532837ljx.522.1652360161321;
        Thu, 12 May 2022 05:56:01 -0700 (PDT)
Received: from [192.168.1.11] ([217.117.245.216])
        by smtp.gmail.com with ESMTPSA id u21-20020a056512129500b0047255d21101sm780303lfs.48.2022.05.12.05.56.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 05:56:00 -0700 (PDT)
Message-ID: <246ba9d2-2afd-c6c0-9cc2-9e5598407c70@gmail.com>
Date:   Thu, 12 May 2022 15:55:59 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 1/2] ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
Content-Language: en-US
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        ath9k-devel@qca.qualcomm.com, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, linville@tuxdriver.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+03110230a11411024147@syzkaller.appspotmail.com,
        syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
References: <80962aae265995d1cdb724f5362c556d494c7566.1644265120.git.paskripkin@gmail.com>
 <87r14yhq4q.fsf@toke.dk>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <87r14yhq4q.fsf@toke.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------qmsVdKFyQ3xxn1GcjvlTyxNY"
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
--------------qmsVdKFyQ3xxn1GcjvlTyxNY
Content-Type: multipart/mixed; boundary="------------k4xKEdDh2mAtqI0UES6kmKGa";
 protected-headers="v1"
From: Pavel Skripkin <paskripkin@gmail.com>
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
 ath9k-devel@qca.qualcomm.com, kvalo@kernel.org, davem@davemloft.net,
 kuba@kernel.org, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzbot+03110230a11411024147@syzkaller.appspotmail.com,
 syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
Message-ID: <246ba9d2-2afd-c6c0-9cc2-9e5598407c70@gmail.com>
Subject: Re: [PATCH v3 1/2] ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
References: <80962aae265995d1cdb724f5362c556d494c7566.1644265120.git.paskripkin@gmail.com>
 <87r14yhq4q.fsf@toke.dk>
In-Reply-To: <87r14yhq4q.fsf@toke.dk>

--------------k4xKEdDh2mAtqI0UES6kmKGa
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgVG9rZSwNCg0KT24gNS8xMi8yMiAxNTo0OSwgVG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu
IHdyb3RlOg0KPiBQYXZlbCBTa3JpcGtpbiA8cGFza3JpcGtpbkBnbWFpbC5jb20+IHdyaXRl
czoNCj4gDQo+PiBTeXpib3QgcmVwb3J0ZWQgdXNlLWFmdGVyLWZyZWUgUmVhZCBpbiBhdGg5
a19oaWZfdXNiX3J4X2NiKCkuIFRoZQ0KPj4gcHJvYmxlbSB3YXMgaW4gaW5jb3JyZWN0IGh0
Y19oYW5kbGUtPmRydl9wcml2IGluaXRpYWxpemF0aW9uLg0KPj4NCj4+IFByb2JhYmxlIGNh
bGwgdHJhY2Ugd2hpY2ggY2FuIHRyaWdnZXIgdXNlLWFmdGVyLWZyZWU6DQo+Pg0KPj4gYXRo
OWtfaHRjX3Byb2JlX2RldmljZSgpDQo+PiAgIC8qIGh0Y19oYW5kbGUtPmRydl9wcml2ID0g
cHJpdjsgKi8NCj4+ICAgYXRoOWtfaHRjX3dhaXRfZm9yX3RhcmdldCgpICAgICAgPC0tLSBG
YWlsZWQNCj4+ICAgaWVlZTgwMjExX2ZyZWVfaHcoKQkJICAgPC0tLSBwcml2IHBvaW50ZXIg
aXMgZnJlZWQNCj4+DQo+PiA8SVJRPg0KPj4gLi4uDQo+PiBhdGg5a19oaWZfdXNiX3J4X2Ni
KCkNCj4+ICAgYXRoOWtfaGlmX3VzYl9yeF9zdHJlYW0oKQ0KPj4gICAgUlhfU1RBVF9JTkMo
KQkJPC0tLSBodGNfaGFuZGxlLT5kcnZfcHJpdiBhY2Nlc3MNCj4+DQo+PiBJbiBvcmRlciB0
byBub3QgYWRkIGZhbmN5IHByb3RlY3Rpb24gZm9yIGRydl9wcml2IHdlIGNhbiBtb3ZlDQo+
PiBodGNfaGFuZGxlLT5kcnZfcHJpdiBpbml0aWFsaXphdGlvbiBhdCB0aGUgZW5kIG9mIHRo
ZQ0KPj4gYXRoOWtfaHRjX3Byb2JlX2RldmljZSgpIGFuZCBhZGQgaGVscGVyIG1hY3JvIHRv
IG1ha2UNCj4+IGFsbCAqX1NUQVRfKiBtYWNyb3MgTlVMTCBzYXZlLg0KPj4NCj4+IEZpeGVz
OiBmYjk5ODdkMGY3NDggKCJhdGg5a19odGM6IFN1cHBvcnQgZm9yIEFSOTI3MSBjaGlwc2V0
LiIpDQo+PiBSZXBvcnRlZC1hbmQtdGVzdGVkLWJ5OiBzeXpib3QrMDMxMTAyMzBhMTE0MTEw
MjQxNDdAc3l6a2FsbGVyLmFwcHNwb3RtYWlsLmNvbQ0KPj4gUmVwb3J0ZWQtYW5kLXRlc3Rl
ZC1ieTogc3l6Ym90K2M2ZGRlMWY2OTBiNjBlMGI5ZmJlQHN5emthbGxlci5hcHBzcG90bWFp
bC5jb20NCj4+IFNpZ25lZC1vZmYtYnk6IFBhdmVsIFNrcmlwa2luIDxwYXNrcmlwa2luQGdt
YWlsLmNvbT4NCj4gDQo+IENvdWxkIHlvdSBsaW5rIHRoZSBvcmlnaW5hbCBzeXpib3QgcmVw
b3J0IGluIHRoZSBjb21taXQgbWVzc2FnZSBhcyB3ZWxsLA0KDQpTdXJlISBTZWUgbGlua3Mg
YmVsb3cNCg0KdXNlLWFmdGVyLWZyZWUgYnVnOg0KaHR0cHM6Ly9zeXprYWxsZXIuYXBwc3Bv
dC5jb20vYnVnP2lkPTZlYWQ0NGUzN2FmYjY4NjZhYzBjN2RkMTIxYjRjZTA3Y2I2NjVmNjAN
Cg0KTlVMTCBkZXJlZiBidWc6DQpodHRwczovL3N5emthbGxlci5hcHBzcG90LmNvbS9idWc/
aWQ9YjgxMDFmZmNlYzEwN2MwNTY3YTBjZDhhY2JiYWNlYzkxZTllZThkZQ0KDQpJIGNhbiBh
ZGQgdGhlbSBpbiBjb21taXQgbWVzc2FnZSBpZiB5b3Ugd2FudCA6KQ0KDQo+IHBsZWFzZT8g
QWxzbyB0aGF0ICd0ZXN0ZWQtYnknIGltcGxpZXMgdGhhdCBzeXpib3QgcnVuLXRlc3RlZCB0
aGlzPyBIb3cNCj4gZG9lcyBpdCBkbyB0aGF0OyBkb2VzIGl0IGhhdmUgYXRoOWtfaHRjIGhh
cmR3YXJlPw0KPiANCg0KTm8sIGl0IHVzZXMgQ09ORklHX1VTQl9SQVdfR0FER0VUIGFuZCBD
T05GSUdfVVNCX0RVTU1ZX0hDRCBmb3IgZ2FkZ2V0cyANCmZvciBlbXVsYXRpbmcgdXNiIGRl
dmljZXMuDQoNCkJhc2ljYWxseSB0aGVzZSB0aGluZ3MgImNvbm5lY3QiIGZha2UgVVNCIGRl
dmljZSB3aXRoIHJhbmRvbSB1c2IgaWRzIA0KZnJvbSBoYXJkY29kZWQgdGFibGUgYW5kIHRy
eSB0byBkbyB2YXJpb3VzIHRoaW5ncyB3aXRoIHVzYiBkcml2ZXINCg0KPj4gLS0tDQoNCltz
bmlwXQ0KDQo+PiAtI2RlZmluZSBUWF9TVEFUX0lOQyhjKSAoaGlmX2Rldi0+aHRjX2hhbmRs
ZS0+ZHJ2X3ByaXYtPmRlYnVnLnR4X3N0YXRzLmMrKykNCj4+IC0jZGVmaW5lIFRYX1NUQVRf
QUREKGMsIGEpIChoaWZfZGV2LT5odGNfaGFuZGxlLT5kcnZfcHJpdi0+ZGVidWcudHhfc3Rh
dHMuYyArPSBhKQ0KPj4gLSNkZWZpbmUgUlhfU1RBVF9JTkMoYykgKGhpZl9kZXYtPmh0Y19o
YW5kbGUtPmRydl9wcml2LT5kZWJ1Zy5za2JyeF9zdGF0cy5jKyspDQo+PiAtI2RlZmluZSBS
WF9TVEFUX0FERChjLCBhKSAoaGlmX2Rldi0+aHRjX2hhbmRsZS0+ZHJ2X3ByaXYtPmRlYnVn
LnNrYnJ4X3N0YXRzLmMgKz0gYSkNCj4+ICsjZGVmaW5lIF9fU1RBVF9TQVZFKGV4cHIpICho
aWZfZGV2LT5odGNfaGFuZGxlLT5kcnZfcHJpdiA/IChleHByKSA6IDApDQo+PiArI2RlZmlu
ZSBUWF9TVEFUX0lOQyhjKSBfX1NUQVRfU0FWRShoaWZfZGV2LT5odGNfaGFuZGxlLT5kcnZf
cHJpdi0+ZGVidWcudHhfc3RhdHMuYysrKQ0KPj4gKyNkZWZpbmUgVFhfU1RBVF9BREQoYywg
YSkgX19TVEFUX1NBVkUoaGlmX2Rldi0+aHRjX2hhbmRsZS0+ZHJ2X3ByaXYtPmRlYnVnLnR4
X3N0YXRzLmMgKz0gYSkNCj4+ICsjZGVmaW5lIFJYX1NUQVRfSU5DKGMpIF9fU1RBVF9TQVZF
KGhpZl9kZXYtPmh0Y19oYW5kbGUtPmRydl9wcml2LT5kZWJ1Zy5za2JyeF9zdGF0cy5jKysp
DQo+PiArI2RlZmluZSBSWF9TVEFUX0FERChjLCBhKSBfX1NUQVRfU0FWRShoaWZfZGV2LT5o
dGNfaGFuZGxlLT5kcnZfcHJpdi0+ZGVidWcuc2ticnhfc3RhdHMuYyArPSBhKQ0KPj4gICNk
ZWZpbmUgQ0FCX1NUQVRfSU5DICAgcHJpdi0+ZGVidWcudHhfc3RhdHMuY2FiX3F1ZXVlZCsr
DQo+IA0KPiBzL1NBVkUvU0FGRS8gaGVyZSBhbmQgaW4gdGhlIG5leHQgcGF0Y2ggKGFuZCB0
aGUgY29tbWl0IG1lc3NhZ2UpLg0KPiANCg0KT2gsIHNvcnJ5IGFib3V0IHRoYXQhIFdpbGwg
dXBkYXRlIGluIG5leHQgdmVyc2lvbg0KDQoNCg0KDQpXaXRoIHJlZ2FyZHMsDQpQYXZlbCBT
a3JpcGtpbg0K

--------------k4xKEdDh2mAtqI0UES6kmKGa--

--------------qmsVdKFyQ3xxn1GcjvlTyxNY
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEER3XL3TplLQE8Qi40bk1w61LbBA0FAmJ9A98FAwAAAAAACgkQbk1w61LbBA05
URAAgK/v0sp/LmTtW56WbXPIEz7EuTb7eZjK3lbo/yPI4U4ste/23UaZQot+euSxwVhD9wi7JwXh
VTUBTpCKyuCT7lIEAGmhgP4ZWdCjuQX/xX/6jmt5kMZwCHFYt5w3AXiOg7vSItQomSmEpa/iH2i/
qnJKnxHAtIr/60qnNV5ZD8dsVM7DDiFJJsfksM7oPdJBINUBp4kPZ49/9XkDDUc4GIlZCQ73J/ub
m7wLBUNuIpRX5pfRuCf6y4FDatQjp71hepTYMrKomk3U7TP/GlF39E3b+XZnqz/mluGrXDf3uFqw
Si13IozmdiCw+jrJi+wVStVOnusPuRdfOu8qN9I0Z+txthQCORCreoTyIevnZnVlfGPTZ9kNtGGi
mxMjAvfhc1ShAj15Ojf7LXiyZEUppgOdQdvn5L2zCwbr1shmmAM8quLmPVPkreahSDtJb2jyT43M
VHYPrOrhJ22QUE5hEY27d44gNuDgywsEX8xPJaatuI1oqgDPQfavfYFlpccoyr3HJzaBcRQipGEn
aSFa9egu6wD2lGb98aop//qKKTSSaVJ3QFq1XlPGeoKRF1Eyl53GnpWDAPWxM3uKBr92ogHAqoN2
J1Lf1dihSYaQ3jEVRWUwOvaaY9TP8L80EM/7jP7kt+e9k6C59k5KY3x31yLrM3ydhbNTlgpcVnB7
HQs=
=wmR3
-----END PGP SIGNATURE-----

--------------qmsVdKFyQ3xxn1GcjvlTyxNY--

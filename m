Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E160734F86B
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 07:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233620AbhCaF6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 01:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbhCaF6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 01:58:21 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 550ADC061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 22:58:20 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id x189so19956191ybg.5
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 22:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WundDXzAmJFV1KNeY2mYJnKhRj3v/BA2w/7thkTi7IQ=;
        b=PMrjsK6CBGb3FkaCIwkWV7A8Bcjm2V9RqFuis6ZWJmUYoGQbqQsNDXBAtA74N3Z5sM
         CkqgOFL5fdzUDoZGvClDeoVOS3ZPFFF2QbVXQ1bGTGJorBopc0TEY1H8nyqHfJ/nwQ24
         kWOv5Vxant03AF9kUGy6Gp1vTwmQ4SH6gRB4kVvcvBEFbDmG967dWkapcfA7U75a+Rm8
         Q7aTA5jW3rU25pFZ4pITCMc9zg8OFTrgVzVpKG91yj9TBkOQOW1t7hlXPmzKjZvrfeKp
         P+9tzXXF4fcXOvgVdkUa8dyYeRQcL1TSgz0l/vyBcyXK+gzlqmDhThk7WTBgGXdPMiEz
         Tucg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WundDXzAmJFV1KNeY2mYJnKhRj3v/BA2w/7thkTi7IQ=;
        b=dzhH4jnYmWoBEzb6qspeIsJLgZq0cNu++uNSWccRmOW/p77v1CVEeKlwIEAKzyRded
         H/G/FxDWa4x27YLMmV2QXQabNwpQvWEWPPFTAHMhXkqpqS+2zlC069g3lv5n/L0pO/+p
         iNlV/1Jii5MMyW7jUo48X4kw76TNjMacCvGFRECeEpEjdLoev4DAIfPbp33Y03E/5sdD
         PwYX382B8DZAZ2hToBye+sX/X/FBUoFbaVeLzo9soujiGeoVUdCgIT3ZGOSCg8EXnf4c
         WzRlfjBTiizdUywUSWjSXlAZvPDpu9BR0fXOs9BSl2ElZ+ZO1gxQhrZ7EIZkPNK9/j5S
         48YA==
X-Gm-Message-State: AOAM530hG+4RqO+NGz/ny9ZlxLbL09wOcb/l9RDIj1+Wq/HYulobO0bk
        3sAsmtX5/M0V+GZI3PRlTZXD6on08Y72Ldb8G4mwiQ==
X-Google-Smtp-Source: ABdhPJxZKZcwLe/niUBYaJQ1prlTeI0PgVZw64w+YLHHkapqZYG8ay1Bxg/VGlktjzI23ro4HlVvpZlBt+t5R+STFEg=
X-Received: by 2002:a25:6a88:: with SMTP id f130mr2468915ybc.234.1617170299189;
 Tue, 30 Mar 2021 22:58:19 -0700 (PDT)
MIME-Version: 1.0
References: <BYAPR11MB2870B0910C71BDDFD328B339AB7C9@BYAPR11MB2870.namprd11.prod.outlook.com>
In-Reply-To: <BYAPR11MB2870B0910C71BDDFD328B339AB7C9@BYAPR11MB2870.namprd11.prod.outlook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 31 Mar 2021 07:58:07 +0200
Message-ID: <CANn89iLnzN6n--tF_7_d0Y1tD6sv3Yx=3H+U_iYbeC21=-r92w@mail.gmail.com>
Subject: Re: [PATCH net-next] sit: proper dev_{hold|put} in ndo_[un]init methods
To:     "Wong, Vee Khee" <vee.khee.wong@intel.com>
Cc:     "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>,
        "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>
Content-Type: multipart/mixed; boundary="00000000000039fb6705bececd8e"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000039fb6705bececd8e
Content-Type: text/plain; charset="UTF-8"

On Wed, Mar 31, 2021 at 2:01 AM Wong, Vee Khee <vee.khee.wong@intel.com> wrote:
>
> Hi all,
>
>
>
> This patch introduced the following massive warnings printouts on a
>
> Intel x86 Alderlake platform with STMMAC MAC and Marvell 88E2110 PHY.
>
>
>
> [  149.674232] unregister_netdevice: waiting for sit0 to become free. Usage count = 2
>
> [  159.930310] unregister_netdevice: waiting for sit0 to become free. Usage count = 2
>
> [  170.186205] unregister_netdevice: waiting for sit0 to become free. Usage count = 2
>
> [  180.434311] unregister_netdevice: waiting for sit0 to become free. Usage count = 2
>
> [  190.682309] unregister_netdevice: waiting for sit0 to become free. Usage count = 2
>
> [  200.690176] unregister_netdevice: waiting for sit0 to become free. Usage count = 2
>
> [  210.938310] unregister_netdevice: waiting for sit0 to become free. Usage count = 2
>
> [  221.186311] unregister_netdevice: waiting for sit0 to become free. Usage count = 2
>
> [  231.442311] unregister_netdevice: waiting for sit0 to become free. Usage count = 2
>
> [  241.690186] unregister_netdevice: waiting for sit0 to become free. Usage count = 2
>
> [  251.698288] unregister_netdevice: waiting for sit0 to become free. Usage count = 2
>
> [  261.946311] unregister_netdevice: waiting for sit0 to become free. Usage count = 2
>
> [  272.194181] unregister_netdevice: waiting for sit0 to become free. Usage count = 2
>
> [  282.442311] unregister_netdevice: waiting for sit0 to become free. Usage count = 2
>
> [  292.690310] unregister_netdevice: waiting for sit0 to become free. Usage count = 2
>
> [  302.938313] unregister_netdevice: waiting for sit0 to become free. Usage count = 2
>
> [  313.186255] unregister_netdevice: waiting for sit0 to become free. Usage count = 2
>
> [  323.442329] unregister_netdevice: waiting for sit0 to become free. Usage count = 2
>
> [  333.698309] unregister_netdevice: waiting for sit0 to become free. Usage count = 2
>
> [  343.946310] unregister_netdevice: waiting for sit0 to become free. Usage count = 2
>
> [  354.202166] unregister_netdevice: waiting for sit0 to become free. Usage count = 2
>
> [  364.450190] unregister_netdevice: waiting for sit0 to become free. Usage count = 2
>
> [  374.706314] unregister_netdevice: waiting for sit0 to become free. Usage count = 2
>
>
>
> Is this an expected behavior?
>
>
>
> Thanks,
>
> VK

Same answer than the other thread :

Nope, I already have a fix, but it depends on a pending patch.

https://patchwork.kernel.org/project/netdevbpf/patch/20210330064551.545964-1-eric.dumazet@gmail.com/

(I need the patch being merged to add a corresponding Fixes: tag)

You can try the attached patch :

--00000000000039fb6705bececd8e
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-ipv6-remove-extra-dev_hold-for-fallback-tunnels.patch"
Content-Disposition: attachment; 
	filename="0001-ipv6-remove-extra-dev_hold-for-fallback-tunnels.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kmx1fly80>
X-Attachment-Id: f_kmx1fly80

RnJvbSAyYzljY2UwNjdhOWExYWVjMzJiMzIzZWY4MDE3OWIxODU2Yzc5NmFmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBFcmljIER1bWF6ZXQgPGVkdW1hemV0QGdvb2dsZS5jb20+CkRh
dGU6IFR1ZSwgMzAgTWFyIDIwMjEgMTM6Mjk6MDggLTA3MDAKU3ViamVjdDogW1BBVENIIG5ldC1u
ZXh0XSBpcHY2OiByZW1vdmUgZXh0cmEgZGV2X2hvbGQoKSBmb3IgZmFsbGJhY2sgdHVubmVscwoK
TXkgcHJldmlvdXMgY29tbWl0cyBhZGRlZCBhIGRldl9ob2xkKCkgaW4gdHVubmVscyBuZG9faW5p
dCgpLApidXQgZm9yZ290IHRvIHJlbW92ZSBpdCBmcm9tIHNwZWNpYWwgZnVuY3Rpb25zIHNldHRp
bmcgdXAgZmFsbGJhY2sgdHVubmVscy4KCkZhbGxiYWNrIHR1bm5lbHMgZG8gY2FsbCB0aGVpciBy
ZXNwZWN0aXZlIG5kb19pbml0KCkKClRoaXMgbGVhZHMgdG8gdmFyaW91cyByZXBvcnRzIGxpa2Ug
OgoKdW5yZWdpc3Rlcl9uZXRkZXZpY2U6IHdhaXRpbmcgZm9yIGlwNmdyZTAgdG8gYmVjb21lIGZy
ZWUuIFVzYWdlIGNvdW50ID0gMgoKRml4ZXM6IGYyMWViMDE5NTY2MiAoImlwNl90dW5uZWw6IHNp
dDogcHJvcGVyIGRldl97aG9sZHxwdXR9IGluIG5kb19bdW5daW5pdCBtZXRob2RzIikKRml4ZXM6
IDYyODlhOThmMDgxNyAoInNpdDogcHJvcGVyIGRldl97aG9sZHxwdXR9IGluIG5kb19bdW5daW5p
dCBtZXRob2RzIikKRml4ZXM6IDQwY2I4ODFiNWFhYSAoImlwNl92dGk6IHByb3BlciBkZXZfe2hv
bGR8cHV0fSBpbiBuZG9fW3VuXWluaXQgbWV0aG9kcyIpCkZpeGVzOiA3ZjcwMDMzNGJlOWEgKCJp
cDZfZ3JlOiBwcm9wZXIgZGV2X3tob2xkfHB1dH0gaW4gbmRvX1t1bl1pbml0IG1ldGhvZHMiKQpT
aWduZWQtb2ZmLWJ5OiBFcmljIER1bWF6ZXQgPGVkdW1hemV0QGdvb2dsZS5jb20+ClJlcG9ydGVk
LWJ5OiBzeXpib3QgPHN5emthbGxlckBnb29nbGVncm91cHMuY29tPgotLS0KIG5ldC9pcHY2L2lw
Nl9ncmUuYyAgICB8IDMgLS0tCiBuZXQvaXB2Ni9pcDZfdHVubmVsLmMgfCAxIC0KIG5ldC9pcHY2
L2lwNl92dGkuYyAgICB8IDEgLQogbmV0L2lwdjYvc2l0LmMgICAgICAgIHwgMSAtCiA0IGZpbGVz
IGNoYW5nZWQsIDYgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvbmV0L2lwdjYvaXA2X2dyZS5j
IGIvbmV0L2lwdjYvaXA2X2dyZS5jCmluZGV4IDk2ODliZjlmNDZmMzQ3NTYyMzMwYTRkODYzMGMw
YjBiMTNhNDExZmMuLmJjMjI0ZjkxN2JiZDUzYmViOWI4YWY1YmRlZjNmYjk3OTRiOGVlNDQgMTAw
NjQ0Ci0tLSBhL25ldC9pcHY2L2lwNl9ncmUuYworKysgYi9uZXQvaXB2Ni9pcDZfZ3JlLmMKQEAg
LTM4Nyw3ICszODcsNiBAQCBzdGF0aWMgc3RydWN0IGlwNl90bmwgKmlwNmdyZV90dW5uZWxfbG9j
YXRlKHN0cnVjdCBuZXQgKm5ldCwKIAlpZiAoIShudC0+cGFybXMub19mbGFncyAmIFRVTk5FTF9T
RVEpKQogCQlkZXYtPmZlYXR1cmVzIHw9IE5FVElGX0ZfTExUWDsKIAotCWRldl9ob2xkKGRldik7
CiAJaXA2Z3JlX3R1bm5lbF9saW5rKGlnbiwgbnQpOwogCXJldHVybiBudDsKIApAQCAtMTUzOSw4
ICsxNTM4LDYgQEAgc3RhdGljIHZvaWQgaXA2Z3JlX2ZiX3R1bm5lbF9pbml0KHN0cnVjdCBuZXRf
ZGV2aWNlICpkZXYpCiAJc3RyY3B5KHR1bm5lbC0+cGFybXMubmFtZSwgZGV2LT5uYW1lKTsKIAog
CXR1bm5lbC0+aGxlbgkJPSBzaXplb2Yoc3RydWN0IGlwdjZoZHIpICsgNDsKLQotCWRldl9ob2xk
KGRldik7CiB9CiAKIHN0YXRpYyBzdHJ1Y3QgaW5ldDZfcHJvdG9jb2wgaXA2Z3JlX3Byb3RvY29s
IF9fcmVhZF9tb3N0bHkgPSB7CmRpZmYgLS1naXQgYS9uZXQvaXB2Ni9pcDZfdHVubmVsLmMgYi9u
ZXQvaXB2Ni9pcDZfdHVubmVsLmMKaW5kZXggNjdlZTlkNThlYzVlZmNjODFlOGIyNzQwNmJkNGY1
N2EwY2FlYTcwYi4uMDdhMGEwNmE5YjUyYmM5OTc0ZTJmMzZiMTQ3N2MzNDFjOTUyZjk0YSAxMDA2
NDQKLS0tIGEvbmV0L2lwdjYvaXA2X3R1bm5lbC5jCisrKyBiL25ldC9pcHY2L2lwNl90dW5uZWwu
YwpAQCAtMTkyNSw3ICsxOTI1LDYgQEAgc3RhdGljIGludCBfX25ldF9pbml0IGlwNl9mYl90bmxf
ZGV2X2luaXQoc3RydWN0IG5ldF9kZXZpY2UgKmRldikKIAlzdHJ1Y3QgaXA2X3RubF9uZXQgKmlw
Nm4gPSBuZXRfZ2VuZXJpYyhuZXQsIGlwNl90bmxfbmV0X2lkKTsKIAogCXQtPnBhcm1zLnByb3Rv
ID0gSVBQUk9UT19JUFY2OwotCWRldl9ob2xkKGRldik7CiAKIAlyY3VfYXNzaWduX3BvaW50ZXIo
aXA2bi0+dG5sc193Y1swXSwgdCk7CiAJcmV0dXJuIDA7CmRpZmYgLS1naXQgYS9uZXQvaXB2Ni9p
cDZfdnRpLmMgYi9uZXQvaXB2Ni9pcDZfdnRpLmMKaW5kZXggYTAxOGFmZGIzZTA2MmM5ZTY2NGQ0
Y2E0MjQxNzZhODU5ZjBhMzMyYy4uODU2ZTQ2YWQwODk1YjQ3YjU4ODk2ODUyYWZlZTNkNGEzOThi
MTM5ZSAxMDA2NDQKLS0tIGEvbmV0L2lwdjYvaXA2X3Z0aS5jCisrKyBiL25ldC9pcHY2L2lwNl92
dGkuYwpAQCAtOTYzLDcgKzk2Myw2IEBAIHN0YXRpYyBpbnQgX19uZXRfaW5pdCB2dGk2X2ZiX3Ru
bF9kZXZfaW5pdChzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KQogCXN0cnVjdCB2dGk2X25ldCAqaXA2
biA9IG5ldF9nZW5lcmljKG5ldCwgdnRpNl9uZXRfaWQpOwogCiAJdC0+cGFybXMucHJvdG8gPSBJ
UFBST1RPX0lQVjY7Ci0JZGV2X2hvbGQoZGV2KTsKIAogCXJjdV9hc3NpZ25fcG9pbnRlcihpcDZu
LT50bmxzX3djWzBdLCB0KTsKIAlyZXR1cm4gMDsKZGlmZiAtLWdpdCBhL25ldC9pcHY2L3NpdC5j
IGIvbmV0L2lwdjYvc2l0LmMKaW5kZXggNDg4ZDMxODFhZWMzYTU1NThkYmVmYjYxNDU0MDA2Mjc1
MzVkZjc2MS4uZmYyY2EyZTdjN2Y1MDQ1NjYzMDY5ZWE1NzI1NjBkNThhYmVlMjk3MCAxMDA2NDQK
LS0tIGEvbmV0L2lwdjYvc2l0LmMKKysrIGIvbmV0L2lwdjYvc2l0LmMKQEAgLTE0NzAsNyArMTQ3
MCw2IEBAIHN0YXRpYyB2b2lkIF9fbmV0X2luaXQgaXBpcDZfZmJfdHVubmVsX2luaXQoc3RydWN0
IG5ldF9kZXZpY2UgKmRldikKIAlpcGgtPmlobAkJPSA1OwogCWlwaC0+dHRsCQk9IDY0OwogCi0J
ZGV2X2hvbGQoZGV2KTsKIAlyY3VfYXNzaWduX3BvaW50ZXIoc2l0bi0+dHVubmVsc193Y1swXSwg
dHVubmVsKTsKIH0KIAotLSAKMi4zMS4wLjI5MS5nNTc2YmE5ZGNkYWYtZ29vZwoK
--00000000000039fb6705bececd8e--

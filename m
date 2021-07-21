Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFDF13D1A8D
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 01:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbhGUXPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 19:15:30 -0400
Received: from mout.gmx.net ([212.227.17.22]:48009 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229561AbhGUXP1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 19:15:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1626911757;
        bh=8zeB9SdYIGad3GftpPhXNeuDOVvPqv+DJPqmbH0vpUQ=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=QiGRi6Jh6eLwK2syCOZSMxr/vMGhbW0PcxujKeJiLdENYtFHJWxW1GlKwaX+k7zs8
         daDUVIDIWJKUpqc7Zm9QLtlJ9ywdhhFAZD75vV19gOOpQIzF0PE2K7Y6lrCPSBNoIO
         /3r9IdZy3IrsfJgFpRWN5x8TP6ThBHTge97YHClQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from Venus.fritz.box ([149.172.237.67]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MfpSb-1lQdo20hKL-00gIod; Wed, 21
 Jul 2021 23:56:51 +0200
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
To:     woojung.huh@microchip.com, olteanv@gmail.com
Cc:     UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH v2 1/2] net: dsa: ensure linearized SKBs in case of tail taggers
Date:   Wed, 21 Jul 2021 23:56:41 +0200
Message-Id: <20210721215642.19866-2-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210721215642.19866-1-LinoSanfilippo@gmx.de>
References: <20210721215642.19866-1-LinoSanfilippo@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
X-Provags-ID: V03:K1:mUIOwjeXZDD68etj9mBr6MrnFG4lg1jEYtOkP3DA14joz2fY37k
 1zgYb4+R0rj65ECSE3yX1R7l8ydwDDZsFEE/om+kwVbBW1iwDH/iK7qaqCe8/127jpdqp/9
 2i7XiJSX5N3neJyaM6wUWAVTgxASajUarjFiwRpGG2VEAdmAGq3W3lUu+QvPe0T9KMjC2xS
 rUlm6+0F/PZnud5mT8zjw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:vDn73y4plaM=:+5o4aSgaIj/zyUSbyjJhFb
 MEG6LF2GXoh00HXel2z0Mb8jtmhNbNE4FIqfFN1Fa3w7IZ0eGpSSY2g0lE//srUa196jzceGo
 T8JuJ8J7UPTccSGLwJ8uUM37FyVK206USKCKe4aLjlf7qVXNJay8BVh6hCqwXbUtUlMtk5Jr7
 lLN26DchTNxw78Db0MSmLpdG9DCg9EE/Vh67BuNixdLZIjhvxXWWkBvKYqklRKSTdEzf2vC2P
 zJ4JraMAC79EjKXR9/joziu4c0DFXOBR/mM7SxnRCCGg/jFShZBQZ8SaXFgRhGYWm23cspVmE
 dIRixll1VjJUlJ1GMjE01ml4UIIK1bRAzly8xJOqV+rpZ7jio0qk0WAnlsWPtpYIaIK5ckByr
 IK9H7OO8s0u//7aODOZUzlfXC+28hdpMo6nxWVYP4r2ybT64QctPxB/BD0s3VQN3w4LR1v2w3
 TYHrq+2Co1+MtQf92944i0nhZIh9bnenuCbpIZF4+IZIbukLj2vqCeSuuFsLBQfw+VxyU8Dia
 BJtsWz17UWDHF3DLwnCzBo+SmGuoeOF8EfZv8/19kKlpyzZQQH547shWq727HJdCGPt30+U1v
 YjOQ9V91hf/79OeF42upEsJu1749oBmofJDqY2BIMAAl7JA16aNpTWnZGF+kVBNXtQN7V7WyV
 28YIEKlhgA0EncssHwMOoZDmer7v4sbdncYJNFCDvHl/U5pYrfbpNj4+paw4s6UMK/JzotQGf
 vjEY1IUevtpSRDyXj8lCz1Obs8x/lVqzLxnpBUwfHNi3kP1yUkVzSMhdzMLEkFydvPYeBU1Ng
 b6HS6GR/HZYj9D2BPLxAD1UJtvOS6v9kjhG9HZn5Lz5N29bMzg+bDIQRmY6TgAu0AAt07LE5g
 HvBcvMNX9Ljau5acsi2U+/ZOJDH7ZCQVz4EBh6QSyymMYwpd7Nj2h5cpICuYFUxRrdcw5jFnl
 up6p6xM3GCY9eRtPkNp3WYFXPiBON/kRDQCeRBWNddImU6tkzHcwKeliOG0fdxYkSVMCBSvfY
 SG7QYz4NAn/0COIYPdre2wkYrJ+fPH0z5/83GJ1XUt+J0I5rDSV3AMRAJeYvVvRomhov+8EUg
 qCDcqaifgfC9xqUnvODdSr90nmVjPrQ9dw8CMlPPkP190qBTDr1nShoEg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlIGZ1bmN0aW9uIHNrYl9wdXQoKSB0aGF0IGlzIHVzZWQgYnkgdGFpbCB0YWdnZXJzIHRvIG1h
a2Ugcm9vbSBmb3IgdGhlCkRTQSB0YWcgbXVzdCBvbmx5IGJlIGNhbGxlZCBmb3IgbGluZWFyaXpl
ZCBTS0JTLiBIb3dldmVyIGluIGNhc2UgdGhhdCB0aGUKc2xhdmUgZGV2aWNlIGluaGVyaXRlZCBm
ZWF0dXJlcyBsaWtlIE5FVElGX0ZfSFdfU0cgb3IgTkVUSUZfRl9GUkFHTElTVCB0aGUKU0tCIHBh
c3NlZCB0byB0aGUgc2xhdmVzIHRyYW5zbWl0IGZ1bmN0aW9uIG1heSBub3QgYmUgbGluZWFyaXpl
ZC4KQXZvaWQgdGhvc2UgU0tCcyBieSBjbGVhcmluZyB0aGUgTkVUSUZfRl9IV19TRyBhbmQgTkVU
SUZfRl9GUkFHTElTVCBmbGFncwpmb3IgdGFpbCB0YWdnZXJzLgpGdXJ0aGVybW9yZSBzaW5jZSB0
aGUgdGFnZ2luZyBwcm90b2NvbCBjYW4gYmUgY2hhbmdlZCBhdCBydW50aW1lIG1vdmUgdGhlCmNv
ZGUgZm9yIHNldHRpbmcgdXAgdGhlIHNsYXZlcyBmZWF0dXJlcyBpbnRvIGRzYV9zbGF2ZV9zZXR1
cF90YWdnZXIoKS4KClN1Z2dlc3RlZC1ieTogVmxhZGltaXIgT2x0ZWFuIDxvbHRlYW52QGdtYWls
LmNvbT4KU2lnbmVkLW9mZi1ieTogTGlubyBTYW5maWxpcHBvIDxMaW5vU2FuZmlsaXBwb0BnbXgu
ZGU+Ci0tLQogbmV0L2RzYS9zbGF2ZS5jIHwgMTQgKysrKysrKysrLS0tLS0KIDEgZmlsZSBjaGFu
Z2VkLCA5IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvbmV0L2Rz
YS9zbGF2ZS5jIGIvbmV0L2RzYS9zbGF2ZS5jCmluZGV4IDIyY2UxMWNkNzcwZS4uYWUyYTY0OGVk
OWJlIDEwMDY0NAotLS0gYS9uZXQvZHNhL3NsYXZlLmMKKysrIGIvbmV0L2RzYS9zbGF2ZS5jCkBA
IC0xODA4LDYgKzE4MDgsNyBAQCB2b2lkIGRzYV9zbGF2ZV9zZXR1cF90YWdnZXIoc3RydWN0IG5l
dF9kZXZpY2UgKnNsYXZlKQogCXN0cnVjdCBkc2Ffc2xhdmVfcHJpdiAqcCA9IG5ldGRldl9wcml2
KHNsYXZlKTsKIAljb25zdCBzdHJ1Y3QgZHNhX3BvcnQgKmNwdV9kcCA9IGRwLT5jcHVfZHA7CiAJ
c3RydWN0IG5ldF9kZXZpY2UgKm1hc3RlciA9IGNwdV9kcC0+bWFzdGVyOworCWNvbnN0IHN0cnVj
dCBkc2Ffc3dpdGNoICpkcyA9IGRwLT5kczsKIAogCXNsYXZlLT5uZWVkZWRfaGVhZHJvb20gPSBj
cHVfZHAtPnRhZ19vcHMtPm5lZWRlZF9oZWFkcm9vbTsKIAlzbGF2ZS0+bmVlZGVkX3RhaWxyb29t
ID0gY3B1X2RwLT50YWdfb3BzLT5uZWVkZWRfdGFpbHJvb207CkBAIC0xODE5LDYgKzE4MjAsMTQg
QEAgdm9pZCBkc2Ffc2xhdmVfc2V0dXBfdGFnZ2VyKHN0cnVjdCBuZXRfZGV2aWNlICpzbGF2ZSkK
IAlzbGF2ZS0+bmVlZGVkX3RhaWxyb29tICs9IG1hc3Rlci0+bmVlZGVkX3RhaWxyb29tOwogCiAJ
cC0+eG1pdCA9IGNwdV9kcC0+dGFnX29wcy0+eG1pdDsKKworCXNsYXZlLT5mZWF0dXJlcyA9IG1h
c3Rlci0+dmxhbl9mZWF0dXJlcyB8IE5FVElGX0ZfSFdfVEM7CisJaWYgKGRzLT5vcHMtPnBvcnRf
dmxhbl9hZGQgJiYgZHMtPm9wcy0+cG9ydF92bGFuX2RlbCkKKwkJc2xhdmUtPmZlYXR1cmVzIHw9
IE5FVElGX0ZfSFdfVkxBTl9DVEFHX0ZJTFRFUjsKKwlzbGF2ZS0+aHdfZmVhdHVyZXMgfD0gTkVU
SUZfRl9IV19UQzsKKwlzbGF2ZS0+ZmVhdHVyZXMgfD0gTkVUSUZfRl9MTFRYOworCWlmIChzbGF2
ZS0+bmVlZGVkX3RhaWxyb29tKQorCQlzbGF2ZS0+ZmVhdHVyZXMgJj0gfihORVRJRl9GX1NHIHwg
TkVUSUZfRl9GUkFHTElTVCk7CiB9CiAKIHN0YXRpYyBzdHJ1Y3QgbG9ja19jbGFzc19rZXkgZHNh
X3NsYXZlX25ldGRldl94bWl0X2xvY2tfa2V5OwpAQCAtMTg4MSwxMSArMTg5MCw2IEBAIGludCBk
c2Ffc2xhdmVfY3JlYXRlKHN0cnVjdCBkc2FfcG9ydCAqcG9ydCkKIAlpZiAoc2xhdmVfZGV2ID09
IE5VTEwpCiAJCXJldHVybiAtRU5PTUVNOwogCi0Jc2xhdmVfZGV2LT5mZWF0dXJlcyA9IG1hc3Rl
ci0+dmxhbl9mZWF0dXJlcyB8IE5FVElGX0ZfSFdfVEM7Ci0JaWYgKGRzLT5vcHMtPnBvcnRfdmxh
bl9hZGQgJiYgZHMtPm9wcy0+cG9ydF92bGFuX2RlbCkKLQkJc2xhdmVfZGV2LT5mZWF0dXJlcyB8
PSBORVRJRl9GX0hXX1ZMQU5fQ1RBR19GSUxURVI7Ci0Jc2xhdmVfZGV2LT5od19mZWF0dXJlcyB8
PSBORVRJRl9GX0hXX1RDOwotCXNsYXZlX2Rldi0+ZmVhdHVyZXMgfD0gTkVUSUZfRl9MTFRYOwog
CXNsYXZlX2Rldi0+ZXRodG9vbF9vcHMgPSAmZHNhX3NsYXZlX2V0aHRvb2xfb3BzOwogCWlmICgh
aXNfemVyb19ldGhlcl9hZGRyKHBvcnQtPm1hYykpCiAJCWV0aGVyX2FkZHJfY29weShzbGF2ZV9k
ZXYtPmRldl9hZGRyLCBwb3J0LT5tYWMpOwotLSAKMi4zMi4wCgo=

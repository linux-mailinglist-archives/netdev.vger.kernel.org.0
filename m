Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E483C8B7F
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 21:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240083AbhGNTVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 15:21:12 -0400
Received: from mout.gmx.net ([212.227.15.15]:33871 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230139AbhGNTVL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Jul 2021 15:21:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1626290287;
        bh=1NBRlTgjfqUeCWVZMGYnD8k80BqYbSqvVSZtm5STHYw=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=iwjHP7qUtqKnQKBWIxYUHizE+HCQt/zk9Eow4mRTslk5m+/3Kr8ZAjtyJ589s02Tw
         ZrHnROogL083TTqUcFTDJ94tUZNI5ur8x6Mrvym4b1dmzC0dQ4MdCbWt+3/RtC3iua
         fnKIOmTV3nhYZ1XKhXqbfW9IJ/chSdxOeKXeG2gs=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from Venus.fritz.box ([149.172.237.67]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Mq2nA-1lPgk9046k-00n8DO; Wed, 14
 Jul 2021 21:18:07 +0200
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
To:     woojung.huh@microchip.com
Cc:     UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH 1/2] net: dsa: tag_ksz: linearize SKB before adding DSA tag
Date:   Wed, 14 Jul 2021 21:17:22 +0200
Message-Id: <20210714191723.31294-2-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210714191723.31294-1-LinoSanfilippo@gmx.de>
References: <20210714191723.31294-1-LinoSanfilippo@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
X-Provags-ID: V03:K1:zG9W3k55wS/h0OdIs+SlIeLtet69YyCpxgFOl5IYJvy4b/Nigpi
 HFDEIoFeEx/5nfNXKJwgyEyt9p/fzo2c06lbL3Mns/iyo3g2C77QW9br1evxgLVAdfwyosn
 6LR5E4HhR1kH2u1cqEhZVqf0gcNE/uWQQFbE3wQlTeyZoamC9vKKteEMBX31l5dBBNuRGFW
 OLexEsVIsFCaxg0LHegXw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Ylk+XbVU5vY=:hTz0CNh5cPeJvElCX4T9Xi
 KqnxY0hlGQvK6WKNlAj27HEb8+LLnwnY2RJ+4rvR37WMjTTtfJJuyicysYGcyMsUui6F4AoiI
 2jUjOMSxO8MUDR9gCaMqf/aUgOqXk+7i+uUlOpdDrWDto/WWw2QQ3lNrdctSYbjtQzzhgBa3c
 dEdPOmNwiWBn4QMr3W8+RbyJyb0EgnqXSBlrmDNBCpcf1UFVSCcIbnNeaSkZFiwrtIix+78vs
 jr+PU7hp477mMrmzzbkwqkbRL59u6daS0JxPDFDbCqPan0HTNU5D55BZ1HR4/i5iHizv1dcyI
 NP6dSGF/12+esVHBmLSdayRqmdwebZwfEXHnrUTi1sfSzq17mYR8yBKs570GPXQT6FbNlDgab
 ep2fEA/4nf3Gp6C6ophWmOslaHcHmhgoCSrg6rJzkxbg8prjSW526hURcibibwyckPfRG0CXo
 GWJA/7/b/3/dHtRyDDkPBiPS0K/Fav/Mzrl7fqgx7LLzrJkelEcki2rdof+3Ci3OSEUjtwwRr
 Jsec/gTGzMHwtnDL5FS275csKJP45nn9pbwPoFWYNXjys93mzSCe/YfdJpvUMtXlw482Z5ky0
 QiHIBkuWUpQcMl9/DR7LdLROeQR7fxWpPv2EuAphWIr7fAazv318XVnwZlCSJ2One2jQQgwhN
 BY4x6yrImXMTvfpJgcF6Wc1g6xORGUfBbxzVbsRtvPCU7wbP7dlu/AKQWneZt+DvkQgUBWLoE
 14U104iZ1MH5G/7u9UEUPU6mlEGvu2LjkZxyKJXN0TUBImQG5+MQ8Ee8eOHFhqu0VNA83p2R1
 lNvXxXxs+Eh5F7Qzn/lUcfviZNDGaFC7ggtRLC5BuuOfy9wlW2cko4Hs1J0PQz0/o/hdfnyO+
 9lliX1sY7qR2t+OPDQ/kzBakzH4I3WgibQQ+soYHhl3yPGGX7qgkxo1VqqNZrXM/JOcjB27eI
 Ts83rIincMFfqU3ZuZTxypwJ40EOChHGdzzs9rOkMZZ2x4PmTt2j/ix5Qb2ICztkCFY5A1OwO
 q/bxTRcZ0fLxIL639Ov6VObXggg4QBXWUHz3eFBNwNnJiAE3guEbUSpzQTVtxOw23YOUuYq1u
 dToMamxLde9ugNG+gmcK6kfIvN7w2oFunnQ5vy/NPc6reAqLbfEffStRQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SW4ga3N6OTQ3N194bWl0KCkgc2tiX3B1dCgpIGlzIHVzZWQgdG8gYWRkIHRoZSBEU0EgdGFnIHRv
IHRoZSBwYXNzZWQgU0tCLgpIb3dldmVyIHNrYl9wdXQoKSBtdXN0IG9ubHkgYmUgY2FsbGVkIGZv
ciBsaW5lYXIgU0tCcyB3aGljaCBtYXkgbm90IGJlIHRoZQpjYXNlIGlmIHRoZSBEU0Egc2xhdmUg
ZGV2aWNlIGluaGVyaXRlZCBORVRJRl9GX1NHIGZyb20gdGhlIG1hc3RlciBkZXZpY2UuClNvIG1h
a2Ugc3VyZSB0aGUgU0tCIGlzIGFsd2F5cyBsaW5lYXJpemVkLgoKU2lnbmVkLW9mZi1ieTogTGlu
byBTYW5maWxpcHBvIDxMaW5vU2FuZmlsaXBwb0BnbXguZGU+Ci0tLQogbmV0L2RzYS90YWdfa3N6
LmMgfCA5ICsrKysrKysrKwogMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKQoKZGlmZiAt
LWdpdCBhL25ldC9kc2EvdGFnX2tzei5jIGIvbmV0L2RzYS90YWdfa3N6LmMKaW5kZXggNTM1NjVm
NDg5MzRjLi4zNjRmNTA5ZDdjZDcgMTAwNjQ0Ci0tLSBhL25ldC9kc2EvdGFnX2tzei5jCisrKyBi
L25ldC9kc2EvdGFnX2tzei5jCkBAIC01Myw2ICs1Myw5IEBAIHN0YXRpYyBzdHJ1Y3Qgc2tfYnVm
ZiAqa3N6ODc5NV94bWl0KHN0cnVjdCBza19idWZmICpza2IsIHN0cnVjdCBuZXRfZGV2aWNlICpk
ZXYpCiAJdTggKnRhZzsKIAl1OCAqYWRkcjsKIAorCWlmIChza2JfbGluZWFyaXplKHNrYikpCisJ
CXJldHVybiBOVUxMOworCiAJLyogVGFnIGVuY29kaW5nICovCiAJdGFnID0gc2tiX3B1dChza2Is
IEtTWl9JTkdSRVNTX1RBR19MRU4pOwogCWFkZHIgPSBza2JfbWFjX2hlYWRlcihza2IpOwpAQCAt
MTE0LDYgKzExNyw5IEBAIHN0YXRpYyBzdHJ1Y3Qgc2tfYnVmZiAqa3N6OTQ3N194bWl0KHN0cnVj
dCBza19idWZmICpza2IsCiAJdTggKmFkZHI7CiAJdTE2IHZhbDsKIAorCWlmIChza2JfbGluZWFy
aXplKHNrYikpCisJCXJldHVybiBOVUxMOworCiAJLyogVGFnIGVuY29kaW5nICovCiAJdGFnID0g
c2tiX3B1dChza2IsIEtTWjk0NzdfSU5HUkVTU19UQUdfTEVOKTsKIAlhZGRyID0gc2tiX21hY19o
ZWFkZXIoc2tiKTsKQEAgLTE2NCw2ICsxNzAsOSBAQCBzdGF0aWMgc3RydWN0IHNrX2J1ZmYgKmtz
ejk4OTNfeG1pdChzdHJ1Y3Qgc2tfYnVmZiAqc2tiLAogCXU4ICphZGRyOwogCXU4ICp0YWc7CiAK
KwlpZiAoc2tiX2xpbmVhcml6ZShza2IpKQorCQlyZXR1cm4gTlVMTDsKKwogCS8qIFRhZyBlbmNv
ZGluZyAqLwogCXRhZyA9IHNrYl9wdXQoc2tiLCBLU1pfSU5HUkVTU19UQUdfTEVOKTsKIAlhZGRy
ID0gc2tiX21hY19oZWFkZXIoc2tiKTsKLS0gCjIuMzIuMAoK

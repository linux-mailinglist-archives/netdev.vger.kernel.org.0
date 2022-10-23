Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AAAF60935F
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 15:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbiJWNLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 09:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbiJWNLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 09:11:49 -0400
X-Greylist: delayed 216 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 23 Oct 2022 06:11:32 PDT
Received: from jari.cn (unknown [218.92.28.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E4D08625D2;
        Sun, 23 Oct 2022 06:11:31 -0700 (PDT)
Received: by ajax-webmail-localhost.localdomain (Coremail) ; Sun, 23 Oct
 2022 21:07:00 +0800 (GMT+08:00)
X-Originating-IP: [182.148.15.254]
Date:   Sun, 23 Oct 2022 21:07:00 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   "KaiLong Wang" <wangkailong@jari.cn>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: replace ternary operator with min()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT6.0.1 build 20210329(c53f3fee)
 Copyright (c) 2002-2022 www.mailtech.cn
 mispb-4e503810-ca60-4ec8-a188-7102c18937cf-zhkzyfz.cn
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <4e5c1182.347.18404f42721.Coremail.wangkailong@jari.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: AQAAfwAXIW90PFVjtuVoAA--.1430W
X-CM-SenderInfo: 5zdqwypdlo00nj6mt2flof0/1tbiAQAIB2FEYxtOnAACsD
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
X-Spam-Status: No, score=2.2 required=5.0 tests=BAYES_00,RCVD_IN_PBL,RDNS_NONE,
        T_SPF_HELO_PERMERROR,T_SPF_PERMERROR,XPRIO autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rml4IHRoZSBmb2xsb3dpbmcgY29jY2ljaGVjayB3YXJuaW5nOgoKbmV0L2lwdjQvaWdtcC5jOjI2
MjE6IFdBUk5JTkcgb3Bwb3J0dW5pdHkgZm9yIG1pbigpCm5ldC9pcHY0L2lnbXAuYzoyNTc0OiBX
QVJOSU5HIG9wcG9ydHVuaXR5IGZvciBtaW4oKQpuZXQvaXB2NC9pcF9zb2NrZ2x1ZS5jOjI4NTog
V0FSTklORyBvcHBvcnR1bml0eSBmb3IgbWluKCkKClNpZ25lZC1vZmYtYnk6IEthaUxvbmcgV2Fu
ZyA8d2FuZ2thaWxvbmdAamFyaS5jbj4KLS0tCiBuZXQvaXB2NC9pZ21wLmMgICAgICAgIHwgNCAr
Ky0tCiBuZXQvaXB2NC9pcF9zb2NrZ2x1ZS5jIHwgMiArLQogMiBmaWxlcyBjaGFuZ2VkLCAzIGlu
c2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvbmV0L2lwdjQvaWdtcC5j
IGIvbmV0L2lwdjQvaWdtcC5jCmluZGV4IDgxYmUzZTBmMGU3MC4uNzkzOWQ4ZmViYjJiIDEwMDY0
NAotLS0gYS9uZXQvaXB2NC9pZ21wLmMKKysrIGIvbmV0L2lwdjQvaWdtcC5jCkBAIC0yNTcxLDcg
KzI1NzEsNyBAQCBpbnQgaXBfbWNfbXNmZ2V0KHN0cnVjdCBzb2NrICpzaywgc3RydWN0IGlwX21z
ZmlsdGVyICptc2YsCiAJfSBlbHNlIHsKIAkJY291bnQgPSBwc2wtPnNsX2NvdW50OwogCX0KLQlj
b3B5Y291bnQgPSBjb3VudCA8IG1zZi0+aW1zZl9udW1zcmMgPyBjb3VudCA6IG1zZi0+aW1zZl9u
dW1zcmM7CisJY29weWNvdW50ID0gbWluKGNvdW50LCBtc2YtPmltc2ZfbnVtc3JjKTsKIAlsZW4g
PSBmbGV4X2FycmF5X3NpemUocHNsLCBzbF9hZGRyLCBjb3B5Y291bnQpOwogCW1zZi0+aW1zZl9u
dW1zcmMgPSBjb3VudDsKIAltc2Zfc2l6ZSA9IElQX01TRklMVEVSX1NJWkUoY29weWNvdW50KTsK
QEAgLTI2MTgsNyArMjYxOCw3IEBAIGludCBpcF9tY19nc2ZnZXQoc3RydWN0IHNvY2sgKnNrLCBz
dHJ1Y3QgZ3JvdXBfZmlsdGVyICpnc2YsCiAJZ3NmLT5nZl9mbW9kZSA9IHBtYy0+c2Ztb2RlOwog
CXBzbCA9IHJ0bmxfZGVyZWZlcmVuY2UocG1jLT5zZmxpc3QpOwogCWNvdW50ID0gcHNsID8gcHNs
LT5zbF9jb3VudCA6IDA7Ci0JY29weWNvdW50ID0gY291bnQgPCBnc2YtPmdmX251bXNyYyA/IGNv
dW50IDogZ3NmLT5nZl9udW1zcmM7CisJY29weWNvdW50ID0gbWluKGNvdW50LCBnc2YtPmdmX251
bXNyYyk7CiAJZ3NmLT5nZl9udW1zcmMgPSBjb3VudDsKIAlmb3IgKGkgPSAwOyBpIDwgY29weWNv
dW50OyBpKyspIHsKIAkJc3RydWN0IHNvY2thZGRyX3N0b3JhZ2Ugc3M7CmRpZmYgLS1naXQgYS9u
ZXQvaXB2NC9pcF9zb2NrZ2x1ZS5jIGIvbmV0L2lwdjQvaXBfc29ja2dsdWUuYwppbmRleCA2ZTE5
Y2FkMTU0ZjUuLjE5YWQzNzg5NzIyNyAxMDA2NDQKLS0tIGEvbmV0L2lwdjQvaXBfc29ja2dsdWUu
YworKysgYi9uZXQvaXB2NC9pcF9zb2NrZ2x1ZS5jCkBAIC0yODIsNyArMjgyLDcgQEAgaW50IGlw
X2Ntc2dfc2VuZChzdHJ1Y3Qgc29jayAqc2ssIHN0cnVjdCBtc2doZHIgKm1zZywgc3RydWN0IGlw
Y21fY29va2llICppcGMsCiAJCQkvKiBPdXIgY2FsbGVyIGlzIHJlc3BvbnNpYmxlIGZvciBmcmVl
aW5nIGlwYy0+b3B0ICovCiAJCQllcnIgPSBpcF9vcHRpb25zX2dldChuZXQsICZpcGMtPm9wdCwK
IAkJCQkJICAgICBLRVJORUxfU09DS1BUUihDTVNHX0RBVEEoY21zZykpLAotCQkJCQkgICAgIGVy
ciA8IDQwID8gZXJyIDogNDApOworCQkJCQkgICAgIG1pbihlcnIsIDQwKSk7CiAJCQlpZiAoZXJy
KQogCQkJCXJldHVybiBlcnI7CiAJCQlicmVhazsKLS0gCjIuMjUuMQo=

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 022145705A4
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 16:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbiGKOdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 10:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbiGKOdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 10:33:37 -0400
Received: from jari.cn (unknown [218.92.28.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 962CC25D2;
        Mon, 11 Jul 2022 07:33:33 -0700 (PDT)
Received: by ajax-webmail-localhost.localdomain (Coremail) ; Mon, 11 Jul
 2022 22:27:58 +0800 (GMT+08:00)
X-Originating-IP: [182.148.15.109]
Date:   Mon, 11 Jul 2022 22:27:58 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   "XueBing Chen" <chenxuebing@jari.cn>
To:     johannes@sipsolutions.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] wireless: use strscpy to replace strlcpy
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT6.0.1 build 20210329(c53f3fee)
 Copyright (c) 2002-2022 www.mailtech.cn
 mispb-4e503810-ca60-4ec8-a188-7102c18937cf-zhkzyfz.cn
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <2d2fcbf7.e33.181eda8e70e.Coremail.chenxuebing@jari.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: AQAAfwAXIW9uM8xi5uRIAA--.894W
X-CM-SenderInfo: hfkh05pxhex0nj6mt2flof0/1tbiAQAECmFEYxs0ZwAFsE
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VW5Jw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
X-Spam-Status: No, score=2.2 required=5.0 tests=BAYES_00,RCVD_IN_PBL,RDNS_NONE,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_PERMERROR,T_SPF_PERMERROR,XPRIO
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ClRoZSBzdHJsY3B5IHNob3VsZCBub3QgYmUgdXNlZCBiZWNhdXNlIGl0IGRvZXNuJ3QgbGltaXQg
dGhlIHNvdXJjZQpsZW5ndGguIFByZWZlcnJlZCBpcyBzdHJzY3B5LgoKU2lnbmVkLW9mZi1ieTog
WHVlQmluZyBDaGVuIDxjaGVueHVlYmluZ0BqYXJpLmNuPgotLS0KIG5ldC93aXJlbGVzcy9ldGh0
b29sLmMgfCAxMiArKysrKystLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyks
IDYgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvbmV0L3dpcmVsZXNzL2V0aHRvb2wuYyBiL25l
dC93aXJlbGVzcy9ldGh0b29sLmMKaW5kZXggMjRlMTg0MDVjZGI0Li4yNjEzZDZhYzBmZGEgMTAw
NjQ0Ci0tLSBhL25ldC93aXJlbGVzcy9ldGh0b29sLmMKKysrIGIvbmV0L3dpcmVsZXNzL2V0aHRv
b2wuYwpAQCAtMTAsMjAgKzEwLDIwIEBAIHZvaWQgY2ZnODAyMTFfZ2V0X2RydmluZm8oc3RydWN0
IG5ldF9kZXZpY2UgKmRldiwgc3RydWN0IGV0aHRvb2xfZHJ2aW5mbyAqaW5mbykKIAlzdHJ1Y3Qg
ZGV2aWNlICpwZGV2ID0gd2lwaHlfZGV2KHdkZXYtPndpcGh5KTsKIAogCWlmIChwZGV2LT5kcml2
ZXIpCi0JCXN0cmxjcHkoaW5mby0+ZHJpdmVyLCBwZGV2LT5kcml2ZXItPm5hbWUsCisJCXN0cnNj
cHkoaW5mby0+ZHJpdmVyLCBwZGV2LT5kcml2ZXItPm5hbWUsCiAJCQlzaXplb2YoaW5mby0+ZHJp
dmVyKSk7CiAJZWxzZQotCQlzdHJsY3B5KGluZm8tPmRyaXZlciwgIk4vQSIsIHNpemVvZihpbmZv
LT5kcml2ZXIpKTsKKwkJc3Ryc2NweShpbmZvLT5kcml2ZXIsICJOL0EiLCBzaXplb2YoaW5mby0+
ZHJpdmVyKSk7CiAKLQlzdHJsY3B5KGluZm8tPnZlcnNpb24sIGluaXRfdXRzbmFtZSgpLT5yZWxl
YXNlLCBzaXplb2YoaW5mby0+dmVyc2lvbikpOworCXN0cnNjcHkoaW5mby0+dmVyc2lvbiwgaW5p
dF91dHNuYW1lKCktPnJlbGVhc2UsIHNpemVvZihpbmZvLT52ZXJzaW9uKSk7CiAKIAlpZiAod2Rl
di0+d2lwaHktPmZ3X3ZlcnNpb25bMF0pCi0JCXN0cmxjcHkoaW5mby0+ZndfdmVyc2lvbiwgd2Rl
di0+d2lwaHktPmZ3X3ZlcnNpb24sCisJCXN0cnNjcHkoaW5mby0+ZndfdmVyc2lvbiwgd2Rldi0+
d2lwaHktPmZ3X3ZlcnNpb24sCiAJCQlzaXplb2YoaW5mby0+ZndfdmVyc2lvbikpOwogCWVsc2UK
LQkJc3RybGNweShpbmZvLT5md192ZXJzaW9uLCAiTi9BIiwgc2l6ZW9mKGluZm8tPmZ3X3ZlcnNp
b24pKTsKKwkJc3Ryc2NweShpbmZvLT5md192ZXJzaW9uLCAiTi9BIiwgc2l6ZW9mKGluZm8tPmZ3
X3ZlcnNpb24pKTsKIAotCXN0cmxjcHkoaW5mby0+YnVzX2luZm8sIGRldl9uYW1lKHdpcGh5X2Rl
dih3ZGV2LT53aXBoeSkpLAorCXN0cnNjcHkoaW5mby0+YnVzX2luZm8sIGRldl9uYW1lKHdpcGh5
X2Rldih3ZGV2LT53aXBoeSkpLAogCQlzaXplb2YoaW5mby0+YnVzX2luZm8pKTsKIH0KIEVYUE9S
VF9TWU1CT0woY2ZnODAyMTFfZ2V0X2RydmluZm8pOwotLSAKMi4yNS4xCg==

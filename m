Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95FCE5704E3
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 16:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbiGKOBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 10:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiGKOBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 10:01:31 -0400
Received: from jari.cn (unknown [218.92.28.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BEAD6627E;
        Mon, 11 Jul 2022 07:01:26 -0700 (PDT)
Received: by ajax-webmail-localhost.localdomain (Coremail) ; Mon, 11 Jul
 2022 21:55:37 +0800 (GMT+08:00)
X-Originating-IP: [182.148.15.109]
Date:   Mon, 11 Jul 2022 21:55:37 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   "XueBing Chen" <chenxuebing@jari.cn>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: ip_tunnel: use strscpy to replace strlcpy
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT6.0.1 build 20210329(c53f3fee)
 Copyright (c) 2002-2022 www.mailtech.cn
 mispb-4e503810-ca60-4ec8-a188-7102c18937cf-zhkzyfz.cn
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <2a08f6c1.e30.181ed8b49ad.Coremail.chenxuebing@jari.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: AQAAfwD3AG_ZK8xiSORIAA--.923W
X-CM-SenderInfo: hfkh05pxhex0nj6mt2flof0/1tbiAQAOCmFEYxsxegANse
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
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
WHVlQmluZyBDaGVuIDxjaGVueHVlYmluZ0BqYXJpLmNuPgotLS0KIG5ldC9pcHY0L2lwX3R1bm5l
bC5jIHwgNCArKy0tCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL25ldC9pcHY0L2lwX3R1bm5lbC5jIGIvbmV0L2lwdjQvaXBfdHVu
bmVsLmMKaW5kZXggOTQwMTdhOGMzOTk0Li40Njg4ZjAwYTQ1NGMgMTAwNjQ0Ci0tLSBhL25ldC9p
cHY0L2lwX3R1bm5lbC5jCisrKyBiL25ldC9pcHY0L2lwX3R1bm5lbC5jCkBAIC0yNDIsNyArMjQy
LDcgQEAgc3RhdGljIHN0cnVjdCBuZXRfZGV2aWNlICpfX2lwX3R1bm5lbF9jcmVhdGUoc3RydWN0
IG5ldCAqbmV0LAogCWlmIChwYXJtcy0+bmFtZVswXSkgewogCQlpZiAoIWRldl92YWxpZF9uYW1l
KHBhcm1zLT5uYW1lKSkKIAkJCWdvdG8gZmFpbGVkOwotCQlzdHJsY3B5KG5hbWUsIHBhcm1zLT5u
YW1lLCBJRk5BTVNJWik7CisJCXN0cnNjcHkobmFtZSwgcGFybXMtPm5hbWUsIElGTkFNU0laKTsK
IAl9IGVsc2UgewogCQlpZiAoc3RybGVuKG9wcy0+a2luZCkgPiAoSUZOQU1TSVogLSAzKSkKIAkJ
CWdvdG8gZmFpbGVkOwpAQCAtMTA2NSw3ICsxMDY1LDcgQEAgaW50IGlwX3R1bm5lbF9pbml0X25l
dChzdHJ1Y3QgbmV0ICpuZXQsIHVuc2lnbmVkIGludCBpcF90bmxfbmV0X2lkLAogCiAJbWVtc2V0
KCZwYXJtcywgMCwgc2l6ZW9mKHBhcm1zKSk7CiAJaWYgKGRldm5hbWUpCi0JCXN0cmxjcHkocGFy
bXMubmFtZSwgZGV2bmFtZSwgSUZOQU1TSVopOworCQlzdHJzY3B5KHBhcm1zLm5hbWUsIGRldm5h
bWUsIElGTkFNU0laKTsKIAogCXJ0bmxfbG9jaygpOwogCWl0bi0+ZmJfdHVubmVsX2RldiA9IF9f
aXBfdHVubmVsX2NyZWF0ZShuZXQsIG9wcywgJnBhcm1zKTsKLS0gCjIuMjUuMQoKCg==

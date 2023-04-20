Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F28B26E9D5F
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 22:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232389AbjDTUoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 16:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbjDTUoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 16:44:15 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 140E5E4A;
        Thu, 20 Apr 2023 13:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net; s=s31663417;
        t=1682023402; i=ps.report@gmx.net;
        bh=C+061R1HoJpAZeX1ZsK7Ci+mbPs2jE+mZarLFcSv9vY=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=gZKqXaVTvl0Td9b0f+3UCFnKWzqpk2DVdskmg05j0buJBN0P7j01hBQkvF1ZzNQue
         r8zg9ul9f9e6/CcdhWbi/ITEQ/WdPcSGaL++0eJhO6G3SVkcr5ApB8uSd+6T1SBogm
         oIw9Cbzbf5hlVTkcMf52bZ+MX1FneCghrJATOmOxJNXbhtwDPf6+jpY+VawvYn8Z+F
         qfGBEgsc/DSwoTyUO2aVkSgdadLYPnNnAefYapEpNEfaCXwr7wkkAXnkbNq73uS1p3
         4LQSM1U9+b16tr+OTRGWy+S57trob68x4oWPhu+enHDBDlOOgOnwaRlOYxOqVOmQY2
         MFC0lc6Cysehg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from localhost.fritz.box ([62.216.208.48]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MfpOT-1qV0U72w7F-00gDlZ; Thu, 20
 Apr 2023 22:43:22 +0200
From:   Peter Seiderer <ps.report@gmx.net>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W . Linville" <linville@tuxdriver.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gregg Wonderly <greggwonderly@seqtechllc.com>,
        Peter Seiderer <ps.report@gmx.net>
Subject: [PATCH v1] wifi: ath9k: fix AR9003 mac hardware hang check register offset calculation
Date:   Thu, 20 Apr 2023 22:43:16 +0200
Message-Id: <20230420204316.30475-1-ps.report@gmx.net>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: base64
X-Provags-ID: V03:K1:qbxDUYy2HT2lVywzRqeDIDHBOcKPyc7C1KzpcnC5mDO5osG7Cfm
 45MAJYVxLFm+ROYvJ3Fm+evefwfu/LnQIxuagr+ebkiHNdMpMn3//8TFui08iu/KBVQcROV
 zk/PqBqaA2xIp60vUAdn4pwATEWP7qan11ImVeUXbdOAP5WRLtYTTpr39rmUOeFw8AO/Lv/
 EpKEX5FPLtlcBRZGVuICQ==
UI-OutboundReport: notjunk:1;M01:P0:NC3rj3VezgU=;R55SEyp/FcrkGkkBS2y7+2zCeK+
 JWmM1UNHmwYU9YyLdBRxiwx8rDWnPQoWWSVtRlp7FAcYT3mBC1lEqmg3MBzZk3OExuswDOars
 9BgXIwF2gJZuAUHmiZtNjV+fZi4jHr1r5kgTRGmz7YZ1Sl7BmcjcRJ0m7wq03YW6XiVQN76mu
 ms+FwNLJvmKEdv+O5Eum2W4f6tNQnkiMG+vQ/PH1NYSoMQ2wKTiWVNhL7p3SKuxqLVlX5hQZS
 +GINxPynfm+q/nAMD1/aLFKiyp60KqkAltXT8vJJHDPqzsymYGGhTv1uNrpzZW1uM/uC/7kqV
 xM4IiL5ewh9wmMgman9Y58h/QFKZWvQYM3AFFqIWjiQv/gevh48ZGgzPASp6YNTdyXO9qtkoa
 RWpQLooiPVUr47yPJxB5nLTFvJKo1YGV2tKlCu6bYpmQYzoQk1AbWevHy0sXG73aA1cxXrVDS
 SULgHO1DV0u4uaQoAnxwnlMUw1rKM/J4Mel0/cw4J1SkvlwX0B3NxoeHw8pf50EuIqdW2sH0w
 a0nCbpRkR1OfLjPARQPlKzvUWaLDTTj3BlPW10mvWbOIKuVYrIV/6ovOGzstpa0116oJUGHEF
 /neoz4H1rp5n8KqvDLkvfkIvNtdr2K93sNgN8ZU3PVvNsXeGiqT/tQMaNwZVTmCYYnxXseibv
 5LHDHHoGwWYZed+4niO7QhYq5h9CBk1MDwSxWDlqI+JKwRfOtVt4l8IEu7gtLTA5X6VMpmgNa
 PRhc+pZldlaINvkOMxOVyvl1Yx08xAwz4XFbv7hjrgU9xulwcx/R9Mf+Dl3Db/9++ASoO068i
 VeCp7WeqHk7vQSkPnyOzr4ku4Q60GaX3NI/q9scHFEXFLQVXIu/W+pQ016cWQQKz47aOzl3/+
 MFhwwUkdQtqbrYJrq33UMOXfbh51v6lOwF2yx1BcfzViql3DKQGY8bnirTh3Te7W4jd4wFyvE
 WqCJZG+48nX8HI0syfsL5pVhy5k=
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,MIME_BASE64_TEXT,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rml4IGF0aDlrX2h3X3ZlcmlmeV9oYW5nKCkvYXI5MDAzX2h3X2RldGVjdF9tYWNfaGFuZygpIHJl
Z2lzdGVyIG9mZnNldApjYWxjdWxhdGlvbiAoZG8gbm90IG92ZXJmbG93IHRoZSBzaGlmdCBmb3Ig
dGhlIHNlY29uZCByZWdpc3Rlci9xdWV1ZXMKYWJvdmUgZml2ZSwgdXNlIHRoZSByZWdpc3RlciBs
YXlvdXQgZGVzY3JpYmVkIGluIHRoZSBjb21tZW50cyBhYm92ZQphdGg5a19od192ZXJpZnlfaGFu
ZygpIGluc3RlYWQpLgoKRml4ZXM6IDIyMmUwNDgzMGZmMCAoImF0aDlrOiBGaXggTUFDIEhXIGhh
bmcgY2hlY2sgZm9yIEFSOTAwMyIpCgpSZXBvcnRlZC1ieTogR3JlZ2cgV29uZGVybHkgPGdyZWdn
d29uZGVybHlAc2VxdGVjaGxsYy5jb20+Ckxpbms6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xp
bnV4LXdpcmVsZXNzL0UzQTlDMzU0LTBDQjctNDIwQy1BREVGLUYwMTc3RkI3MjJGNEBzZXF0ZWNo
bGxjLmNvbS8KU2lnbmVkLW9mZi1ieTogUGV0ZXIgU2VpZGVyZXIgPHBzLnJlcG9ydEBnbXgubmV0
PgotLS0KTm90ZXM6CiAgLSB0ZXN0ZWQgd2l0aCBNaWtyb1RpayBSMTFlLTVIbkQvQXRoZXJvcyBB
UjkzMDAgUmV2OjQgKGxzcGNpOiAxNjhjOjAwMzMKICAgIFF1YWxjb21tIEF0aGVyb3MgQVI5NTh4
IDgwMi4xMWFiZ24gV2lyZWxlc3MgTmV0d29yayBBZGFwdGVyIChyZXYgMDEpKQogICAgY2FyZAot
LS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9hcjkwMDNfaHcuYyB8IDI3ICsrKysr
KysrKysrKysrLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxOCBpbnNlcnRpb25zKCspLCA5IGRl
bGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9h
cjkwMDNfaHcuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9hcjkwMDNfaHcuYwpp
bmRleCA0ZjI3YTlmYjE0ODIuLjBjY2YxM2EzNWZiNCAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQv
d2lyZWxlc3MvYXRoL2F0aDlrL2FyOTAwM19ody5jCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L2F0aC9hdGg5ay9hcjkwMDNfaHcuYwpAQCAtMTA5OSwxNyArMTA5OSwyMiBAQCBzdGF0aWMgYm9v
bCBhdGg5a19od192ZXJpZnlfaGFuZyhzdHJ1Y3QgYXRoX2h3ICphaCwgdW5zaWduZWQgaW50IHF1
ZXVlKQogewogCXUzMiBkbWFfZGJnX2NoYWluLCBkbWFfZGJnX2NvbXBsZXRlOwogCXU4IGRjdV9j
aGFpbl9zdGF0ZSwgZGN1X2NvbXBsZXRlX3N0YXRlOworCXVuc2lnbmVkIGludCBkYmdfcmVnLCBy
ZWdfb2Zmc2V0OwogCWludCBpOwogCi0JZm9yIChpID0gMDsgaSA8IE5VTV9TVEFUVVNfUkVBRFM7
IGkrKykgewotCQlpZiAocXVldWUgPCA2KQotCQkJZG1hX2RiZ19jaGFpbiA9IFJFR19SRUFEKGFo
LCBBUl9ETUFEQkdfNCk7Ci0JCWVsc2UKLQkJCWRtYV9kYmdfY2hhaW4gPSBSRUdfUkVBRChhaCwg
QVJfRE1BREJHXzUpOworCWlmIChxdWV1ZSA8IDYpIHsKKwkJZGJnX3JlZyA9IEFSX0RNQURCR180
OworCQlyZWdfb2Zmc2V0ID0gaSAqIDU7CisJfSBlbHNlIHsKKwkJZGJnX3JlZyA9IEFSX0RNQURC
R181OworCQlyZWdfb2Zmc2V0ID0gKGkgLSA2KSAqIDU7CisJfQogCisJZm9yIChpID0gMDsgaSA8
IE5VTV9TVEFUVVNfUkVBRFM7IGkrKykgeworCQlkbWFfZGJnX2NoYWluID0gUkVHX1JFQUQoYWgs
IGRiZ19yZWcpOwogCQlkbWFfZGJnX2NvbXBsZXRlID0gUkVHX1JFQUQoYWgsIEFSX0RNQURCR182
KTsKIAotCQlkY3VfY2hhaW5fc3RhdGUgPSAoZG1hX2RiZ19jaGFpbiA+PiAoNSAqIHF1ZXVlKSkg
JiAweDFmOworCQlkY3VfY2hhaW5fc3RhdGUgPSAoZG1hX2RiZ19jaGFpbiA+PiByZWdfb2Zmc2V0
KSAmIDB4MWY7CiAJCWRjdV9jb21wbGV0ZV9zdGF0ZSA9IGRtYV9kYmdfY29tcGxldGUgJiAweDM7
CiAKIAkJaWYgKChkY3VfY2hhaW5fc3RhdGUgIT0gMHg2KSB8fCAoZGN1X2NvbXBsZXRlX3N0YXRl
ICE9IDB4MSkpCkBAIC0xMTI4LDYgKzExMzMsNyBAQCBzdGF0aWMgYm9vbCBhcjkwMDNfaHdfZGV0
ZWN0X21hY19oYW5nKHN0cnVjdCBhdGhfaHcgKmFoKQogCXU4IGRjdV9jaGFpbl9zdGF0ZSwgZGN1
X2NvbXBsZXRlX3N0YXRlOwogCWJvb2wgZGN1X3dhaXRfZnJkb25lID0gZmFsc2U7CiAJdW5zaWdu
ZWQgbG9uZyBjaGtfZGN1ID0gMDsKKwl1bnNpZ25lZCBpbnQgcmVnX29mZnNldDsKIAl1bnNpZ25l
ZCBpbnQgaSA9IDA7CiAKIAlkbWFfZGJnXzQgPSBSRUdfUkVBRChhaCwgQVJfRE1BREJHXzQpOwpA
QCAtMTEzOSwxMiArMTE0NSwxNSBAQCBzdGF0aWMgYm9vbCBhcjkwMDNfaHdfZGV0ZWN0X21hY19o
YW5nKHN0cnVjdCBhdGhfaHcgKmFoKQogCQlnb3RvIGV4aXQ7CiAKIAlmb3IgKGkgPSAwOyBpIDwg
QVRIOUtfTlVNX1RYX1FVRVVFUzsgaSsrKSB7Ci0JCWlmIChpIDwgNikKKwkJaWYgKGkgPCA2KSB7
CiAJCQljaGtfZGJnID0gZG1hX2RiZ180OwotCQllbHNlCisJCQlyZWdfb2Zmc2V0ID0gaSAqIDU7
CisJCX0gZWxzZSB7CiAJCQljaGtfZGJnID0gZG1hX2RiZ181OworCQkJcmVnX29mZnNldCA9IChp
IC0gNikgKiA1OworCQl9CiAKLQkJZGN1X2NoYWluX3N0YXRlID0gKGNoa19kYmcgPj4gKDUgKiBp
KSkgJiAweDFmOworCQlkY3VfY2hhaW5fc3RhdGUgPSAoY2hrX2RiZyA+PiByZWdfb2Zmc2V0KSAm
IDB4MWY7CiAJCWlmIChkY3VfY2hhaW5fc3RhdGUgPT0gMHg2KSB7CiAJCQlkY3Vfd2FpdF9mcmRv
bmUgPSB0cnVlOwogCQkJY2hrX2RjdSB8PSBCSVQoaSk7Ci0tIAoyLjQwLjAKCg==

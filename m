Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A774752968C
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 03:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbiEQBKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 21:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiEQBKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 21:10:20 -0400
X-Greylist: delayed 53473 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 16 May 2022 18:10:17 PDT
Received: from azure-sdnproxy-2.icoremail.net (azure-sdnproxy.icoremail.net [52.175.55.52])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 28A8E403F4;
        Mon, 16 May 2022 18:10:16 -0700 (PDT)
Received: by ajax-webmail-mail-app4 (Coremail) ; Tue, 17 May 2022 09:10:04
 +0800 (GMT+08:00)
X-Originating-IP: [124.236.130.193]
Date:   Tue, 17 May 2022 09:10:04 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, krzysztof.kozlowski@linaro.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, gregkh@linuxfoundation.org,
        alexander.deucher@amd.com, broonie@kernel.org
Subject: Re: Re: [PATCH net] NFC: nci: fix sleep in atomic context bugs
 caused by nci_skb_alloc
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <20220516130705.2d51a6cf@kernel.org>
References: <20220513133355.113222-1-duoming@zju.edu.cn>
 <20220516130705.2d51a6cf@kernel.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <72ac1467.16e1f.180cf90a3b6.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cS_KCgC3COHs9YJibPJTAA--.5665W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgUNAVZdtZtnRQAAsM
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sCgpPbiBNb24sIDE2IE1heSAyMDIyIDEzOjA3OjA1IC0wNzAwIEpha3ViIEtpY2luc2tp
IHdyb3RlOgoKPiBPbiBGcmksIDEzIE1heSAyMDIyIDIxOjMzOjU1ICswODAwIER1b21pbmcgWmhv
dSB3cm90ZToKPiA+IEZpeGVzOiA2YTI5NjhhYWY1MGMgKCJORkM6IGJhc2ljIE5DSSBwcm90b2Nv
bCBpbXBsZW1lbnRhdGlvbiAiKQo+ID4gRml4ZXM6IDExZjU0ZjIyODY0MyAoIk5GQzogbmNpOiBB
ZGQgSENJIG92ZXIgTkNJIHByb3RvY29sIHN1cHBvcnQiKQo+IAo+IEFyZSB0aGVyZSBtb3JlIGJh
ZCBjYWxsZXJzPyBJZiBzdF9uY2lfc2Vfd3RfdGltZW91dCBpcyB0aGUgb25seSBzb3VyY2UKPiBv
ZiB0cm91YmxlIHRoZW4gdGhlIGZpeGVzIHRhZyBzaG91bGQgcG9pbnQgdG8gd2hlbiBpdCB3YXMg
YWRkZWQsIHJhdGhlcgo+IHRoYW4gd2hlbiB0aGUgY2FsbGVlIHdhcyBhZGRlZC4KClRoZSBzdF9u
Y2lfc2Vfd3RfdGltZW91dCBpcyB0aGUgb25seSBzb3VyY2Ugb2YgdHJvdWJsZSwgaXQgd2FzIGFk
ZGVkIGluCmVkMDZhZWVmZGFjMyAoIm5mYzogc3QtbmNpOiBSZW5hbWUgc3QyMW5mY2IgdG8gc3Qt
bmNpIikuIEkgd2lsbCBzZW5kCnBhdGNoIHYyLgoKQmVzdCByZWdhcmRzLApEdW9taW5nIFpob3U=


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 814635809DE
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 05:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbiGZDUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 23:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbiGZDUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 23:20:52 -0400
Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id E2DA727CE4;
        Mon, 25 Jul 2022 20:20:46 -0700 (PDT)
Received: by ajax-webmail-mail-app2 (Coremail) ; Tue, 26 Jul 2022 11:20:25
 +0800 (GMT+08:00)
X-Originating-IP: [218.12.17.60]
Date:   Tue, 26 Jul 2022 11:20:25 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     linux-hams@vger.kernel.org, ralf@linux-mips.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] netrom: fix sleep in atomic context bugs in timer
 handlers
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <20220725194930.44ca1518@kernel.org>
References: <20220723035646.29857-1-duoming@zju.edu.cn>
 <20220725194930.44ca1518@kernel.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <14bac17c.5d665.182388522da.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: by_KCgCHz1t6Xd9iXENnAQ--.25193W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgMDAVZdta05LAABsE
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sCgpPbiBNb24sIDI1IEp1bCAyMDIyIDE5OjQ5OjMwIC0wNzAwIEpha3ViIEtpY2luc2tp
IHdyb3RlOgoKPiBPbiBTYXQsIDIzIEp1bCAyMDIyIDExOjU2OjQ2ICswODAwIER1b21pbmcgWmhv
dSB3cm90ZToKPiA+IEZpeGVzOiBlYWZmZjg2ZDNiZDggKCJbTkVUUk9NXTogVXNlIGttZW1kdXAi
KQo+IAo+IFRoYXQncyBub3QgYSBjb3JyZWN0IEZpeGVzIHRhZywgYWNtZSBqdXN0IHN3YXBwZWQg
a21hbGxvYyBmb3Iga21lbWR1cCgpLgo+IFRoZSBhbGxvY2F0ZSBmbGFncyBkaWQgbm90IGNoYW5n
ZS4KClRoYW5rcyBmb3IgeW91ciB0aW1lIGFuZCByZXBseSEKClRoZSBjb3JyZWN0IEZpeGVzIHRh
ZyBpcyAiRml4ZXM6IDFkYTE3N2U0YzNmNCAoIkxpbnV4LTIuNi4xMi1yYzIiKSIuClRoZSBmb2xs
b3dpbmcgaXMgdGhlIGNvZGU6CgpodHRwczovL2VsaXhpci5ib290bGluLmNvbS9saW51eC92Mi42
LjEyLXJjMi9zb3VyY2UvbmV0L25ldHJvbS9ucl9yb3V0ZS5jI0wxNTgKCi4uLgppZiAoKG5yX25l
aWdoLT5kaWdpcGVhdCA9IGttYWxsb2Moc2l6ZW9mKCpheDI1X2RpZ2kpLCBHRlBfS0VSTkVMKSkg
PT0gTlVMTCkgewouLi4KCkJlc3QgcmVnYXJkcywKRHVvbWluZyBaaG91CgoK

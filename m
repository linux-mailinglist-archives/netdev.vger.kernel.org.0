Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92B3D53FEA5
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 14:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243724AbiFGMWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 08:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243725AbiFGMVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 08:21:46 -0400
Received: from zg8tmja5ljk3lje4ms43mwaa.icoremail.net (zg8tmja5ljk3lje4ms43mwaa.icoremail.net [209.97.181.73])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id D1D30F74B0;
        Tue,  7 Jun 2022 05:21:05 -0700 (PDT)
Received: by ajax-webmail-mail-app4 (Coremail) ; Tue, 7 Jun 2022 20:20:35
 +0800 (GMT+08:00)
X-Originating-IP: [106.117.78.144]
Date:   Tue, 7 Jun 2022 20:20:35 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Eric Dumazet" <edumazet@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, jreuter@yaina.de,
        "Ralf Baechle" <ralf@linux-mips.org>,
        "David Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, netdev <netdev@vger.kernel.org>,
        linux-hams@vger.kernel.org, thomas@osterried.de
Subject: Re: [PATCH net-next] ax25: Fix deadlock caused by skb_recv_datagram
 in ax25_recvmsg
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <CANn89i+HbdWS4JU0odCbRApuCTGFAt9_NSUoCSFo-b4-z0uWCQ@mail.gmail.com>
References: <20220606162138.81505-1-duoming@zju.edu.cn>
 <CANn89i+HbdWS4JU0odCbRApuCTGFAt9_NSUoCSFo-b4-z0uWCQ@mail.gmail.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <17d6464d.57350.1813e1c1082.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cS_KCgC3PiGUQp9iNr1mAQ--.34665W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgEOAVZdtaFt3AACsg
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sCgpPbiBNb24sIDYgSnVuIDIwMjIgMTA6MzE6NDkgLTA3MDAgRXJpYyBEdW1hemV0IHdy
b3RlOgoKPiBPbiBNb24sIEp1biA2LCAyMDIyIGF0IDk6MjEgQU0gRHVvbWluZyBaaG91IDxkdW9t
aW5nQHpqdS5lZHUuY24+IHdyb3RlOgo+ID4KPiA+IFRoZSBza2JfcmVjdl9kYXRhZ3JhbSgpIGlu
IGF4MjVfcmVjdm1zZygpIHdpbGwgaG9sZCBsb2NrX3NvY2sKPiA+IGFuZCBibG9jayB1bnRpbCBp
dCByZWNlaXZlcyBhIHBhY2tldCBmcm9tIHRoZSByZW1vdGUuIElmIHRoZSBjbGllbnQKPiA+IGRv
ZXNuYHQgY29ubmVjdCB0byBzZXJ2ZXIgYW5kIGNhbGxzIHJlYWQoKSBkaXJlY3RseSwgaXQgd2ls
bCBub3QKPiA+IHJlY2VpdmUgYW55IHBhY2tldHMgZm9yZXZlci4gQXMgYSByZXN1bHQsIHRoZSBk
ZWFkbG9jayB3aWxsIGhhcHBlbi4KPiA+Cj4gPiBUaGUgZmFpbCBsb2cgY2F1c2VkIGJ5IGRlYWRs
b2NrIGlzIHNob3duIGJlbG93Ogo+ID4KPiA+IFsgIDg2MS4xMjI2MTJdIElORk86IHRhc2sgYXgy
NV9kZWFkbG9jazoxNDggYmxvY2tlZCBmb3IgbW9yZSB0aGFuIDczNyBzZWNvbmRzLgo+ID4gWyAg
ODYxLjEyNDU0M10gImVjaG8gMCA+IC9wcm9jL3N5cy9rZXJuZWwvaHVuZ190YXNrX3RpbWVvdXRf
c2VjcyIgZGlzYWJsZXMgdGhpcyBtZXNzYWdlLgo+ID4gWyAgODYxLjEyNzc2NF0gQ2FsbCBUcmFj
ZToKPiA+IFsgIDg2MS4xMjk2ODhdICA8VEFTSz4KPiA+IFsgIDg2MS4xMzA3NDNdICBfX3NjaGVk
dWxlKzB4MmY5LzB4YjIwCj4gPiBbICA4NjEuMTMxNTI2XSAgc2NoZWR1bGUrMHg0OS8weGIwCj4g
PiBbICA4NjEuMTMxNjQwXSAgX19sb2NrX3NvY2srMHg5Mi8weDEwMAo+ID4gWyAgODYxLjEzMTY0
MF0gID8gZGVzdHJveV9zY2hlZF9kb21haW5zX3JjdSsweDIwLzB4MjAKPiA+IFsgIDg2MS4xMzE2
NDBdICBsb2NrX3NvY2tfbmVzdGVkKzB4NmUvMHg3MAo+ID4gWyAgODYxLjEzMTY0MF0gIGF4MjVf
c2VuZG1zZysweDQ2LzB4NDIwCj4gPiBbICA4NjEuMTM0MzgzXSAgPyBheDI1X3JlY3Ztc2crMHgx
ZTAvMHgxZTAKPiA+IFsgIDg2MS4xMzU2NThdICBzb2NrX3NlbmRtc2crMHg1OS8weDYwCj4gPiBb
ICA4NjEuMTM2NzkxXSAgX19zeXNfc2VuZHRvKzB4ZTkvMHgxNTAKPiA+IFsgIDg2MS4xMzcyMTJd
ICA/IF9fc2NoZWR1bGUrMHgzMDEvMHhiMjAKPiA+IFsgIDg2MS4xMzc3MTBdICA/IF9fZG9fc29m
dGlycSsweDRhMi8weDRmZAo+ID4gWyAgODYxLjEzOTE1M10gIF9feDY0X3N5c19zZW5kdG8rMHgy
MC8weDMwCj4gPiBbICA4NjEuMTQwMzMwXSAgZG9fc3lzY2FsbF82NCsweDNiLzB4OTAKPiA+IFsg
IDg2MS4xNDA3MzFdICBlbnRyeV9TWVNDQUxMXzY0X2FmdGVyX2h3ZnJhbWUrMHg0Ni8weGIwCj4g
PiBbICA4NjEuMTQxMjQ5XSBSSVA6IDAwMzM6MHg3ZmRmMDVlZTRmNjQKPiA+IFsgIDg2MS4xNDEy
NDldIFJTUDogMDAyYjowMDAwN2ZmZTk1NzcyZmMwIEVGTEFHUzogMDAwMDAyNDYgT1JJR19SQVg6
IDAwMDAwMDAwMDAwMDAwMmMKPiA+IFsgIDg2MS4xNDEyNDldIFJBWDogZmZmZmZmZmZmZmZmZmZk
YSBSQlg6IDAwMDA1NjUzMDNhMDEzZjAgUkNYOiAwMDAwN2ZkZjA1ZWU0ZjY0Cj4gPiBbICA4NjEu
MTQxMjQ5XSBSRFg6IDAwMDAwMDAwMDAwMDAwMDUgUlNJOiAwMDAwNTY1MzAzYTAxNjc4IFJESTog
MDAwMDAwMDAwMDAwMDAwNQo+ID4gWyAgODYxLjE0MTI0OV0gUkJQOiAwMDAwMDAwMDAwMDAwMDAw
IFIwODogMDAwMDAwMDAwMDAwMDAwMCBSMDk6IDAwMDAwMDAwMDAwMDAwMDAKPiA+IFsgIDg2MS4x
NDEyNDldIFIxMDogMDAwMDAwMDAwMDAwMDAwMCBSMTE6IDAwMDAwMDAwMDAwMDAyNDYgUjEyOiAw
MDAwNTY1MzAzYTAwY2YwCj4gPiBbICA4NjEuMTQxMjQ5XSBSMTM6IDAwMDA3ZmZlOTU3NzMwZTAg
UjE0OiAwMDAwMDAwMDAwMDAwMDAwIFIxNTogMDAwMDAwMDAwMDAwMDAwMAo+ID4KPiA+IFRoaXMg
cGF0Y2ggbW92ZXMgdGhlIHNrYl9yZWN2X2RhdGFncmFtKCkgYmVmb3JlIGxvY2tfc29jaygpIGlu
IG9yZGVyCj4gPiB0aGF0IG90aGVyIGZ1bmN0aW9ucyB0aGF0IG5lZWQgbG9ja19zb2NrIGNvdWxk
IGJlIGV4ZWN1dGVkLgo+ID4KPiAKPiAKPiBXaHkgaXMgdGhpcyB0YXJnZXRpbmcgbmV0LW5leHQg
dHJlZSA/Cj4gCj4gMSkgQSBmaXggc2hvdWxkIHRhcmdldCBuZXQgdHJlZQo+IDIpIEl0IHNob3Vs
ZCBpbmNsdWRlIGEgRml4ZXM6IHRhZwoKVGhhbmsgeW91IGZvciB5b3VyIHRpbWUgYW5kIHN1Z2dl
c3Rpb25zIQpJIHdpbGwgY2hhbmdlIHRoZSB0YXJnZXQgdHJlZSB0byBuZXQgYW5kIGFkZCBhIEZp
eGVzOiB0YWcuCgo+IEFsc286Cj4gLSB0aGlzIHBhdGNoIGJ5cGFzc2VzIHRlc3RzIGluIGF4MjVf
cmVjdm1zZygpCj4gLSBUaGlzIG1pZ2h0IGJyZWFrIGFwcGxpY2F0aW9ucyBkZXBlbmRpbmcgb24g
YmxvY2tpbmcgcmVhZCgpIG9wZXJhdGlvbnMuCj4gCj4gSSBmZWVsIGEgcmVhbCBmaXggaXMgZ29p
bmcgdG8gYmUgc2xpZ2h0bHkgbW9yZSBkaWZmaWN1bHQgdGhhbiB0aGF0LgoKSSB0aGluayBtb3Zp
bmcgc2tiX3JlY3ZfZGF0YWdyYW0oKSBiZWZvcmUgbG9ja19zb2NrKCkgaXMgb2ssIGJlY2F1c2Ug
aXQgZG9lcyBub3QKaG9sZCBsb2NrX3NvY2soKSBhbmQgd2lsbCBub3QgaW5mbHVlbmNlIG90aGVy
IG9wZXJhdGlvbnMuIFRoZSBhcHBsaWNhdGlvbnMgd291bGQgbm90CmJyZWFrLiBXaGF0YHMgbW9y
ZSwgaXQgaXMgc2FmZSB0byBtb3ZlIHNrYl9yZWN2X2RhdGFncmFtKCkgYmVmb3JlIGxvY2tfc29j
aygpLgoKVGhlIGNoZWNrICJpZiAoc2stPnNrX3R5cGUgPT0gU09DS19TRVFQQUNLRVQgJiYgc2st
PnNrX3N0YXRlICE9IFRDUF9FU1RBQkxJU0hFRCkiCmhhdmUgdG8gYmUgcHJvdGVjdGVkIGJ5IGxv
Y2tfc29jaygpLCBiZWNhdXNlIHNrLT5za19zdGF0ZSBtYXkgYmUgY2hhbmdlZCBieQpheDI1X2Rp
c2Nvbm5lY3QoKSBpbiBheDI1X2tpbGxfYnlfZGV2aWNlKCkuIAoKQmVzdCByZWdhcmRzLApEdW9t
aW5nIFpob3UK

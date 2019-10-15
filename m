Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EACCD7018
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 09:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbfJOH0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 03:26:53 -0400
Received: from thsbbfxrt02p.thalesgroup.com ([192.93.158.29]:54656 "EHLO
        thsbbfxrt02p.thalesgroup.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725710AbfJOH0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 03:26:53 -0400
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Oct 2019 03:26:52 EDT
Received: from thsbbfxrt02p.thalesgroup.com (localhost [127.0.0.1])
        by localhost (Postfix) with SMTP id 46sn1422T2zJv83;
        Tue, 15 Oct 2019 09:21:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=thalesgroup.com;
        s=xrt20181201; t=1571124104;
        bh=e7ZdgwbK4zLEEWsyLPkAAm9Y800MLgadyEqmXXg46g8=;
        h=From:To:Subject:Date:Message-ID:Content-Transfer-Encoding:
         MIME-Version:From;
        b=b3isKKVgPOvWWuDze5Lo4URBQLTbn+e49AkNP0tYEEd2A4jMNN2HAjnGKa4q6pQ9h
         yIAJdvqrThZ39qI2KxSe3IZgIPSUZW7vM1LvbSH+OHo91iOqah2EkJovw4DECDszYJ
         1KRaytGclAE6i6nWFYcqc4b0VDrs4VFWTcPrCICID656WINCT00Ls9KUnEzzgtZsyz
         qD0CG5Yq8UxD2posZu/B0yd2mr8VcHc/XY+l4jOxd2XK03szqFWo3Q6oJawJgNVSSC
         6eu2D3MeZmw1wi2DUhuV890MEuQJuOY5T5/Bj6fOlPYYm+5zRKsuz6ioE/c1WfyY6e
         6Hk/aLllQj8cg==
From:   JABLONSKY Jan <Jan.JABLONSKY@thalesgroup.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Trond Myklebust <trond.myklebust@primarydata.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        "Jeff Layton" <jlayton@poochiereds.net>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        Jan Stancek <jstancek@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net] sunrpc: fix UDP memory accounting for v4.4 kernel
Thread-Topic: [PATCH net] sunrpc: fix UDP memory accounting for v4.4 kernel
Thread-Index: AQHVgykwG4NF6Q3nKk+Y9JJzJaI8uQ==
Date:   Tue, 15 Oct 2019 07:21:41 +0000
Message-ID: <e5070c6d6157290c2a3f627a50d951ca141973b1.camel@thalesgroup.com>
Accept-Language: en-US, fr-FR
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.1-2 
x-pmwin-version: 4.0.3, Antivirus-Engine: 3.74.1, Antivirus-Data: 5.68
Content-Type: text/plain; charset="utf-8"
Content-ID: <41DCB7FCFABCFD4ABF5EC486755F2DDE@iris.infra.thales>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlIHNhbWUgd2FybmluZ3MgcmVwb3J0ZWQgYnkgSmFuIFN0YW5jZWsgbWF5IGFwcGVhciBhbHNv
IG9uIDQuNA0KQmFzZWQgb24gUGFvbG8gQWJlbmkncyB3b3JrLg0KDQpXQVJOSU5HOiBhdCBuZXQv
aXB2NC9hZl9pbmV0LmM6MTU1DQpDUFU6IDEgUElEOiAyMTQgQ29tbToga3dvcmtlci8xOjFIIE5v
dCB0YWludGVkIDQuNC4xNjYgIzENCldvcmtxdWV1ZTogcnBjaW9kIC54cHJ0X2F1dG9jbG9zZQ0K
dGFzazogYzAwMDAwMDAzNjZmNTdjMCB0aTogYzAwMDAwMDAzNDEzNDAwMCB0YXNrLnRpOiBjMDAw
MDAwMDM0MTM0MDAwDQpOSVAgW2MwMDAwMDAwMDA2NjIyNjhdIC5pbmV0X3NvY2tfZGVzdHJ1Y3Qr
MHgxNTgvMHgyMDANCg0KQmFzZWQgb246ICJbbmV0XSBzdW5ycGM6IGZpeCBVRFAgbWVtb3J5IGFj
Y291bnRpbmciDQoNClNpZ25lZC1vZmYtYnk6IEphbiBKYWJsb25za3kgPGphbi5qYWJsb25za3lA
dGhhbGVzZ3JvdXAuY29tPg0KU2lnbmVkLW9mZi1ieTogUGFvbG8gQWJlbmkgPHBhYmVuaUByZWRo
YXQuY29tPg0KQ2M6IEphbiBTdGFuY2VrIDxqc3RhbmNla0ByZWRoYXQuY29tPg0KLS0tDQogbmV0
L3N1bnJwYy94cHJ0c29jay5jIHwgMiArLQ0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigr
KSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvbmV0L3N1bnJwYy94cHJ0c29jay5jIGIv
bmV0L3N1bnJwYy94cHJ0c29jay5jDQppbmRleCBjOWMwOTc2ZDNiYmIuLjcyMjc3Y2I5Nzg1ZSAx
MDA2NDQNCi0tLSBhL25ldC9zdW5ycGMveHBydHNvY2suYw0KKysrIGIvbmV0L3N1bnJwYy94cHJ0
c29jay5jDQpAQCAtMTA1Niw3ICsxMDU2LDcgQEAgc3RhdGljIHZvaWQgeHNfdWRwX2RhdGFfcmVj
ZWl2ZShzdHJ1Y3Qgc29ja194cHJ0ICp0cmFuc3BvcnQpDQogCQlpZiAoc2tiID09IE5VTEwpDQog
CQkJYnJlYWs7DQogCQl4c191ZHBfZGF0YV9yZWFkX3NrYigmdHJhbnNwb3J0LT54cHJ0LCBzaywg
c2tiKTsNCi0JCXNrYl9mcmVlX2RhdGFncmFtKHNrLCBza2IpOw0KKwkJc2tiX2ZyZWVfZGF0YWdy
YW1fbG9ja2VkKHNrLCBza2IpOw0KIAl9DQogb3V0Og0KIAltdXRleF91bmxvY2soJnRyYW5zcG9y
dC0+cmVjdl9tdXRleCk7

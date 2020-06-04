Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA521EEDDB
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 00:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbgFDWkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 18:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbgFDWkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 18:40:22 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39986C08C5C0;
        Thu,  4 Jun 2020 15:40:22 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2874511F5F8D1;
        Thu,  4 Jun 2020 15:40:21 -0700 (PDT)
Date:   Thu, 04 Jun 2020 15:40:20 -0700 (PDT)
Message-Id: <20200604.154020.1609247845922031946.davem@davemloft.net>
To:     ahabdels@gmail.com
Cc:     kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, yuehaibing@huawei.com, eric.dumazet@gmail.com,
        david.lebrun@uclouvain.be
Subject: Re: [net] seg6: fix seg6_validate_srh() to avoid slab-out-of-bounds
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200603065442.2745-1-ahabdels@gmail.com>
References: <20200603065442.2745-1-ahabdels@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 04 Jun 2020 15:40:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQWhtZWQgQWJkZWxzYWxhbSA8YWhhYmRlbHNAZ21haWwuY29tPg0KRGF0ZTogV2VkLCAg
MyBKdW4gMjAyMCAwNjo1NDo0MiArMDAwMA0KDQo+IFRoZSBzZWc2X3ZhbGlkYXRlX3NyaCgpIGlz
IHVzZWQgdG8gdmFsaWRhdGUgU1JIIGZvciB0aHJlZSBjYXNlczoNCj4gDQo+IGNhc2UxOiBTUkgg
b2YgZGF0YS1wbGFuZSBTUnY2IHBhY2tldHMgdG8gYmUgcHJvY2Vzc2VkIGJ5IHRoZSBMaW51eCBr
ZXJuZWwuDQo+IENhc2UyOiBTUkggb2YgdGhlIG5ldGxpbmsgbWVzc2FnZSByZWNlaXZlZCAgZnJv
bSB1c2VyLXNwYWNlIChpcHJvdXRlMikNCj4gQ2FzZTM6IFNSSCBpbmplY3RlZCBpbnRvIHBhY2tl
dHMgdGhyb3VnaCBzZXRzb2Nrb3B0DQo+IA0KPiBJbiBjYXNlMSwgdGhlIFNSSCBjYW4gYmUgZW5j
b2RlZCBpbiB0aGUgUmVkdWNlZCB3YXkgKGkuZS4sIGZpcnN0IFNJRCBpcw0KPiBjYXJyaWVkIGlu
IERBIG9ubHkgYW5kIG5vdCByZXByZXNlbnRlZCBhcyBTSUQgaW4gdGhlIFNSSCkgYW5kIHRoZQ0K
PiBzZWc2X3ZhbGlkYXRlX3NyaCgpIG5vdyBoYW5kbGVzIHRoaXMgY2FzZSBjb3JyZWN0bHkuDQo+
IA0KPiBJbiBjYXNlMiBhbmQgY2FzZTMsIHRoZSBTUkggc2hvdWxkbqJ0IGJlIGVuY29kZWQgaW4g
dGhlIFJlZHVjZWQgd2F5DQo+IG90aGVyd2lzZSB3ZSBsb3NlIHRoZSBmaXJzdCBzZWdtZW50IChp
LmUuLCB0aGUgZmlyc3QgaG9wKS4NCj4gDQo+IFRoZSBjdXJyZW50IGltcGxlbWVudGF0aW9uIG9m
IHRoZSBzZWc2X3ZhbGlkYXRlX3NyaCgpIGFsbG93IFNSSCBvZiBjYXNlMg0KPiBhbmQgY2FzZTMg
dG8gYmUgZW5jb2RlZCBpbiB0aGUgUmVkdWNlZCB3YXkuIFRoaXMgbGVhZHMgYSBzbGFiLW91dC1v
Zi1ib3VuZHMNCj4gcHJvYmxlbS4NCj4gDQo+IFRoaXMgcGF0Y2ggdmVyaWZpZXMgU1JIIG9mIGNh
c2UxLCBjYXNlMiBhbmQgY2FzZTMuIEFsbG93aW5nIGNhc2UxIHRvIGJlDQo+IHJlZHVjZWQgd2hp
bGUgcHJldmVudGluZyBTUkggb2YgY2FzZTIgYW5kIGNhc2UzIGZyb20gYmVpbmcgcmVkdWNlZCAu
DQo+IA0KPiBSZXBvcnRlZC1ieTogc3l6Ym90K2U4YzAyOGI2MjQzOWVhYzQyMDczQHN5emthbGxl
ci5hcHBzcG90bWFpbC5jb20NCj4gUmVwb3J0ZWQtYnk6IFl1ZUhhaWJpbmcgPHl1ZWhhaWJpbmdA
aHVhd2VpLmNvbT4NCj4gRml4ZXM6IDBjYjc0OThmMjM0ZSAoInNlZzY6IGZpeCBTUkggcHJvY2Vz
c2luZyB0byBjb21wbHkgd2l0aCBSRkM4NzU0IikNCj4gU2lnbmVkLW9mZi1ieTogQWhtZWQgQWJk
ZWxzYWxhbSA8YWhhYmRlbHNAZ21haWwuY29tPg0KDQpBcHBsaWVkLCB0aGFua3MuDQo=

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C413F96C9
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 11:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244579AbhH0JYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 05:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244690AbhH0JYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 05:24:14 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE95C061757
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 02:23:25 -0700 (PDT)
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1630056202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZjGDeknw/3ILzprtEq7lQ0hX/3XfvsLMjbmHv5R6MRY=;
        b=lI4ZtF2xssyy24zu5J16SFR2YTi1yJPxFnFAf1OJEQK1rMn0pwvFuMBES74kwoNR4WGHh/
        gHu09Zszpinxi/T30OvdeAUT08v4joq8XyZXlK1qgxeCL0/mmTcJ3F0zNHbJKaHNRsmDbo
        iwvqbcjS7/5lsSON3eloqTClmn/W5dY=
Date:   Fri, 27 Aug 2021 09:23:22 +0000
Content-Type: multipart/mixed;
 boundary="--=_RainLoop_589_241367367.1630056202"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   yajun.deng@linux.dev
Message-ID: <31823d969f554ffd04e5f9b3b459ecf4@linux.dev>
Subject: Re: [bug report] net: ipv4: Move ip_options_fragment() out of
 loop
To:     "Dan Carpenter" <dan.carpenter@oracle.com>
Cc:     netdev@vger.kernel.org
In-Reply-To: <20210827084915.GA8737@kili>
References: <20210827084915.GA8737@kili>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


----=_RainLoop_589_241367367.1630056202
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

August 27, 2021 4:49 PM, "Dan Carpenter" <dan.carpenter@oracle.com> wrote=
:=0A=0A> Hello Yajun Deng,=0A> =0A> This is a semi-automatic email about =
new static checker warnings.=0A=0ACan you test the attached?=0A=0AThanks.=
=0A> =0A> The patch faf482ca196a: "net: ipv4: Move ip_options_fragment() =
out of =0A> loop" from Aug 23, 2021, leads to the following Smatch compla=
int:=0A> =0A> net/ipv4/ip_output.c:833 ip_do_fragment()=0A> warn: variabl=
e dereferenced before check 'iter.frag' (see line 828)=0A> =0A> net/ipv4/=
ip_output.c=0A> 827 ip_fraglist_init(skb, iph, hlen, &iter);=0A> ^^^^^=0A=
> iter.frag is set here.=0A> =0A> 828 ip_options_fragment(iter.frag);=0A>=
 ^^^^^^^^^=0A> The patch introduces a new dereference here=0A> =0A> 829 =
=0A> 830 for (;;) {=0A> 831 /* Prepare header of the next frame,=0A> 832 =
* before previous one went down. */=0A> 833 if (iter.frag) {=0A> ^^^^^^^^=
^=0A> But the old code assumed that "iter.frag" could be NULL.=0A> =0A> 8=
34 IPCB(iter.frag)->flags =3D IPCB(skb)->flags;=0A> 835 ip_fraglist_prepa=
re(skb, &iter);=0A> =0A> regards,=0A> dan carpenter

----=_RainLoop_589_241367367.1630056202
Content-Type: application/octet-stream;
 name="0001-net-ipv4-Fix-the-warning-for-dereference.patch"
Content-Disposition: attachment;
 filename="0001-net-ipv4-Fix-the-warning-for-dereference.patch"
Content-Transfer-Encoding: base64

RnJvbSAxOWZkYTcxOTY2NDAzNjA4YzNiMmRjOTgxYjIzOGExYzI1ODY1YjgzIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBZYWp1biBEZW5nIDx5YWp1bi5kZW5nQGxpbnV4LmRl
dj4KRGF0ZTogRnJpLCAyNyBBdWcgMjAyMSAxNzoxNDo0MyArMDgwMApTdWJqZWN0OiBbUEFU
Q0ggbmV0LW5leHRdIG5ldDogaXB2NDogRml4IHRoZSB3YXJuaW5nIGZvciBkZXJlZmVyZW5j
ZQoKRGFuIENhcnBlbnRlciByZXBvcnQ6ClRoZSBwYXRjaCBmYWY0ODJjYTE5NmE6ICJuZXQ6
IGlwdjQ6IE1vdmUgaXBfb3B0aW9uc19mcmFnbWVudCgpIG91dCBvZgpsb29wIiBmcm9tIEF1
ZyAyMywgMjAyMSwgbGVhZHMgdG8gdGhlIGZvbGxvd2luZyBTbWF0Y2ggY29tcGxhaW50OgoK
ICAgIG5ldC9pcHY0L2lwX291dHB1dC5jOjgzMyBpcF9kb19mcmFnbWVudCgpCiAgICB3YXJu
OiB2YXJpYWJsZSBkZXJlZmVyZW5jZWQgYmVmb3JlIGNoZWNrICdpdGVyLmZyYWcnIChzZWUg
bGluZSA4MjgpCgpBZGQgYSBpZiBzdGF0ZW1lbnRzIHRvIGF2b2lkIHRoZSB3YXJuaW5nLgoK
Rml4ZXM6IGZhZjQ4MmNhMTk2YSAoIm5ldDogaXB2NDogTW92ZSBpcF9vcHRpb25zX2ZyYWdt
ZW50KCkgb3V0IG9mIGxvb3AiKQpTaWduZWQtb2ZmLWJ5OiBZYWp1biBEZW5nIDx5YWp1bi5k
ZW5nQGxpbnV4LmRldj4KLS0tCiBuZXQvaXB2NC9pcF9vdXRwdXQuYyB8IDQgKysrLQogMSBm
aWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdp
dCBhL25ldC9pcHY0L2lwX291dHB1dC5jIGIvbmV0L2lwdjQvaXBfb3V0cHV0LmMKaW5kZXgg
OWE4ZjA1ZDU0NzZlLi45YmNhNTdlZjhiODMgMTAwNjQ0Ci0tLSBhL25ldC9pcHY0L2lwX291
dHB1dC5jCisrKyBiL25ldC9pcHY0L2lwX291dHB1dC5jCkBAIC04MjUsNyArODI1LDkgQEAg
aW50IGlwX2RvX2ZyYWdtZW50KHN0cnVjdCBuZXQgKm5ldCwgc3RydWN0IHNvY2sgKnNrLCBz
dHJ1Y3Qgc2tfYnVmZiAqc2tiLAogCiAJCS8qIEV2ZXJ5dGhpbmcgaXMgT0suIEdlbmVyYXRl
ISAqLwogCQlpcF9mcmFnbGlzdF9pbml0KHNrYiwgaXBoLCBobGVuLCAmaXRlcik7Ci0JCWlw
X29wdGlvbnNfZnJhZ21lbnQoaXRlci5mcmFnKTsKKworCQlpZiAoaXRlci5mcmFnKQorCQkJ
aXBfb3B0aW9uc19mcmFnbWVudChpdGVyLmZyYWcpOwogCiAJCWZvciAoOzspIHsKIAkJCS8q
IFByZXBhcmUgaGVhZGVyIG9mIHRoZSBuZXh0IGZyYW1lLAotLSAKMi4zMi4wCgo=

----=_RainLoop_589_241367367.1630056202--

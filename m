Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1BF64445A4
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 17:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232778AbhKCQRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 12:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232695AbhKCQRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 12:17:19 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D1CCC061714;
        Wed,  3 Nov 2021 09:14:43 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id v138so7596931ybb.8;
        Wed, 03 Nov 2021 09:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=ynPsHBohLn3SKvumzOxUie+tEBQ3FCXFTsINY6Z8pNk=;
        b=L+WBioVtmF87xia8MJsGH8LHdDwCC4LqLcEx80sLxUl4myqM2DrOCP+cKIQOe65/S6
         6eDBvbZBkdM/fn2+VQocOTVAF+TXHBSQLGn1JoLAv5HZnnA6eQWCaE+CjjDdGB4F3MMz
         kzhPysn9Mr35+FgNOGKw9xf8jAitRZ9ZRxd/IFvaiXrJeGh5aSTJhe0raJnmI3VSeJLN
         A+ZzU2Q+dhn8UtjrHdw9GGvGs6ouWTdMGlGkQoNBALc4dGSRtBR/59Ib72egDaCjvJNF
         dR/WzRsDe1yeLDHTHQ4JhvLlAyZM74KFDDxPzpzKmCLG/k4GTFZjOnlFQO45ZbavWls1
         QeGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=ynPsHBohLn3SKvumzOxUie+tEBQ3FCXFTsINY6Z8pNk=;
        b=GNv4SIB0G9UgKn905Me1hps/Di1TGcSthbsxrUAFNQeav2XwielaSbO/5eP75PZq7O
         3EiVhab+FzQd7fR3J2jdEDgtkEzIj6cPJ9x+VzHMhHfPiER1PUCkoIu72EtaIkzRpYYU
         UyMA3R5/veFGFAtfe9eOhck6NOgj6zPWiPXsnqnX5xpZEqVghu8H/Adn6MwF1l3PksG0
         Y0b714efpIri0pf0oyofisiIwsFzYgBjKYoN2oB7+f8aT/yjdcI5a50N16PfR1IcHSnA
         C/oWTJcc4NYT9E45MhScN/bnhBPX5xzyum1fRPujUpeYG666yr4PmulDRvshRXbgkpt4
         mGUg==
X-Gm-Message-State: AOAM533oHOSy5Ji2B9DdrMmJIW0Ad2rZhmnSUXMuxyEF024ambKFbmIR
        V4SeuUpNjF84XDnzqSTu5xjNSEV7h8QFwRxVp5aMFWwUNg7gKw==
X-Google-Smtp-Source: ABdhPJzym2IXBcLof0GXZGMCUz1M9FgOASoar+5EWBFPRafbId/zCVhXcRContj8jzYQ9RYjYbYOsiUPcaLe82K+hPA=
X-Received: by 2002:a25:cecd:: with SMTP id x196mr3066287ybe.63.1635956082701;
 Wed, 03 Nov 2021 09:14:42 -0700 (PDT)
MIME-Version: 1.0
From:   butt3rflyh4ck <butterflyhuangxx@gmail.com>
Date:   Thu, 4 Nov 2021 00:14:31 +0800
Message-ID: <CAFcO6XMgwuz97EJN+8jh9PJ9seaUbousDBOh9sduM6MZ6MRHxA@mail.gmail.com>
Subject: A kernel-infoleak bug in pppoe_getname() in drivers/net/ppp/pppoe.c
To:     mostrows@earthlink.net, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Networking <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000002d8a3105cfe4b522"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000002d8a3105cfe4b522
Content-Type: text/plain; charset="UTF-8"

Hi, I report a kernel-infoleak bug in pppoe_getname()) in
drivers/net/ppp/pppoe.c.
And we can call getname ioctl to invoke pppoe_getname().

###anaylze
```
static int pppoe_getname(struct socket *sock, struct sockaddr *uaddr,
  int peer)
{
int len = sizeof(struct sockaddr_pppox);
struct sockaddr_pppox sp;    ///--->  define a 'sp' in stack but does
not clear it

sp.sa_family = AF_PPPOX;   ///---> sp.sa_family is a short type, just
2 byte sizes.
sp.sa_protocol = PX_PROTO_OE;
memcpy(&sp.sa_addr.pppoe, &pppox_sk(sock->sk)->pppoe_pa,
       sizeof(struct pppoe_addr));

memcpy(uaddr, &sp, len);

return len;
}
```
There is an anonymous 2-byte hole after sa_family, make sure to clear it.

###fix
use memset() to clear the struct sockaddr_pppox sp.
```
diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index 3619520340b7..fec328ad7202 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -723,6 +723,11 @@ static int pppoe_getname(struct socket *sock,
struct sockaddr *uaddr,
        int len = sizeof(struct sockaddr_pppox);
        struct sockaddr_pppox sp;

+       /* There is an anonymous 2-byte hole after sa_family,
+        * make sure to clear it.
+        */
+       memset(&sp, 0, len);
+
        sp.sa_family    = AF_PPPOX;
        sp.sa_protocol  = PX_PROTO_OE;
        memcpy(&sp.sa_addr.pppoe, &pppox_sk(sock->sk)->pppoe_pa,
```
The attachment is a patch.


Regards,
  butt3rflyh4ck.
-- 
Active Defense Lab of Venustech

--0000000000002d8a3105cfe4b522
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-net-ppp-pppoe-fix-a-kernel-infoleak-in-pppoe_getname.patch"
Content-Disposition: attachment; 
	filename="0001-net-ppp-pppoe-fix-a-kernel-infoleak-in-pppoe_getname.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kvjpz6zh0>
X-Attachment-Id: f_kvjpz6zh0

RnJvbSA1YTJkMDI4MjkzMTk2N2RjOWQ5MDI0ODIyMWIzMTIwZTFlMzM1NTFjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBYaWFvbG9uZyBIdWFuZyA8YnV0dGVyZmx5aHVhbmd4eEBnbWFp
bC5jb20+CkRhdGU6IFdlZCwgMyBOb3YgMjAyMSAyMzozMzo1NSArMDgwMApTdWJqZWN0OiBbUEFU
Q0hdIG5ldDogcHBwOiBwcHBvZTogZml4IGEga2VybmVsLWluZm9sZWFrIGluIHBwcG9lX2dldG5h
bWUoKQoKVGhlIHN0cnVjdCBzb2NrYWRkcl9wcHBveCBoYXMgYSAyLWJ5dGUgaG9sZSwgYW5kIHBw
cG9lX2dldG5hbWUoKSBjdXJyZW50bHkKZG9lcyBub3QgY2xlYXIgaXQgYmVmb3JlIGNvcHlpbmcg
a2VybmVsIGRhdGEgdG8gdXNlciBzcGFjZS4KClNpZ25lZC1vZmYtYnk6IFhpYW9sb25nIEh1YW5n
IDxidXR0ZXJmbHlodWFuZ3h4QGdtYWlsLmNvbT4KLS0tCiBkcml2ZXJzL25ldC9wcHAvcHBwb2Uu
YyB8IDUgKysrKysKIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC9wcHAvcHBwb2UuYyBiL2RyaXZlcnMvbmV0L3BwcC9wcHBvZS5jCmluZGV4
IDM2MTk1MjAzNDBiNy4uZmVjMzI4YWQ3MjAyIDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC9wcHAv
cHBwb2UuYworKysgYi9kcml2ZXJzL25ldC9wcHAvcHBwb2UuYwpAQCAtNzIzLDYgKzcyMywxMSBA
QCBzdGF0aWMgaW50IHBwcG9lX2dldG5hbWUoc3RydWN0IHNvY2tldCAqc29jaywgc3RydWN0IHNv
Y2thZGRyICp1YWRkciwKIAlpbnQgbGVuID0gc2l6ZW9mKHN0cnVjdCBzb2NrYWRkcl9wcHBveCk7
CiAJc3RydWN0IHNvY2thZGRyX3BwcG94IHNwOwogCisJLyogVGhlcmUgaXMgYW4gYW5vbnltb3Vz
IDItYnl0ZSBob2xlIGFmdGVyIHNhX2ZhbWlseSwKKwkgKiBtYWtlIHN1cmUgdG8gY2xlYXIgaXQu
CisJICovCisJbWVtc2V0KCZzcCwgMCwgbGVuKTsKKwogCXNwLnNhX2ZhbWlseQk9IEFGX1BQUE9Y
OwogCXNwLnNhX3Byb3RvY29sCT0gUFhfUFJPVE9fT0U7CiAJbWVtY3B5KCZzcC5zYV9hZGRyLnBw
cG9lLCAmcHBwb3hfc2soc29jay0+c2spLT5wcHBvZV9wYSwKLS0gCjIuMjUuMQoK
--0000000000002d8a3105cfe4b522--

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02A12160593
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 19:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbgBPSwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 13:52:51 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40382 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbgBPSwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 13:52:51 -0500
Received: by mail-pg1-f195.google.com with SMTP id z7so7854976pgk.7
        for <netdev@vger.kernel.org>; Sun, 16 Feb 2020 10:52:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=KICO1RhMTm06k6a24SQx8TThvrDXBShjX7fuul4LghU=;
        b=Hl45TPY8PztZJcIetcxVcC39DZT8+uWzLpacQCZmXMRW8scGrbptO1Iaw5eHBkjzV0
         ACJswd1vDSvxsHBjM3O7UKChSrWa88P28RmpUtmP9rW/Gm13YYkWbTK2v+xwyCQIBS0w
         H6jxG7zNBu6JBsf/P+P8RioEfF1hlsfs6YtMwOZlGn6ptvggBke+9NOtmf4Qgb1PWDeu
         YqfwtN1HmjNTOE8xAFS9uj0Cz49PUP/auCdeejoueEWyNG7Md2ESxRwXRz/IZJ4oKnjA
         BOkVFu5CT9B31inm3TIZw+IKi+tiDiyH0814rKGaB+/M6qqO6x8XfkJ2GxbvuBTyb8jn
         4Bsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=KICO1RhMTm06k6a24SQx8TThvrDXBShjX7fuul4LghU=;
        b=EfmudSELXXMOYusTmtvs5RR24dxZ8I0WEJq8sN9mkrZDrQDutCpKdsnG2fge/6Ft11
         +3kK7aiqN1QW7tWsBtKu+3HLkPeDH+9kGilAwwn/7QFNXdAO9X0LpAtX/JVn1YDAhpP9
         i2nq3jcRkd1meOYY6cyo6kkfXEKflYqZ5c+hLF+Zq+B3M3nGO9j0VyXCo66URTH+N+Mi
         kZ5TYq8L7qkLNDlnJZvhw+fvmcHopcBwj2CFFStccVtb4lypgss+4fepXAJHRJiCuhGB
         w04t4fRQkOc8hR3QdFwX3HkCjp7JPFYEq/mneBnllBeN/DXzvlBircDW5X4DTwhmy+AV
         bgRA==
X-Gm-Message-State: APjAAAWIPyZAv96ugvh5+XyGCtoRWnX57Tw7pwZ97++EOdcZ1fyx6EjM
        Cgml9yuDSzzL6P9NgV9vz29clecVDWi+FkC2LiwfTTexjPU=
X-Google-Smtp-Source: APXvYqxB7AihZZbYG4XvN6pmDs8CLz0sd5ploQquar7Jpt811sK7+lygj4dFbJRQ50Z/fBQyZ3jStefKj9hiJya91TY=
X-Received: by 2002:a62:14e:: with SMTP id 75mr13432934pfb.54.1581879168709;
 Sun, 16 Feb 2020 10:52:48 -0800 (PST)
MIME-Version: 1.0
From:   Pavel Roskin <plroskin@gmail.com>
Date:   Sun, 16 Feb 2020 10:52:37 -0800
Message-ID: <CAN_72e2m8ZYTu1wsqHabvHct8d0Ftf6VHrh-ZGJNR0-Bpa2cyw@mail.gmail.com>
Subject: [BISECTED] UDP socket bound to addr_any receives no data after disconnect
To:     netdev@vger.kernel.org, Peter Oskolkov <posk@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: multipart/mixed; boundary="000000000000ee5c92059eb5f137"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000ee5c92059eb5f137
Content-Type: text/plain; charset="UTF-8"

Hello,

I was debugging a program that uses UDP to serve one client at a time.
It stopped working on newer Linux versions. I was able to bisect the
issue to commit 4cdeeee9252af1ba50482f91d615f326365306bd, "net: udp:
prefer listeners bound to an address". The commit is present in Linux
5.0 but not in 4.20. Linux 5.5.4 is still affected.

From reading the commit description, it doesn't appear that the effect
is intended. However, I found that the issue goes away if I bind the
socket to the loopback address.

I wrote a demo program that shows the problem:

server binds to 0.0.0.0:1337
server connects to 127.0.0.1:80
server disconnects
client connects to 127.0.0.1:1337
client sends "hello"
server gets nothing

Load a 4.x kernel, and the server would get "hello". Likewise, change
"0.0.0.0" to "127.0.0.1" and the problem goes away.

IPv6 has the same issue. I'm attaching programs that demonstrate the
issue with IPv4 and IPv6. They print "hello" on success and hang
otherwise.

-- 
Regards,
Pavel Roskin

--000000000000ee5c92059eb5f137
Content-Type: text/x-csrc; charset="US-ASCII"; name="udp_demo6.c"
Content-Disposition: attachment; filename="udp_demo6.c"
Content-Transfer-Encoding: base64
Content-ID: <f_k6pdv58l1>
X-Attachment-Id: f_k6pdv58l1

I2luY2x1ZGUgPGFycGEvaW5ldC5oPgojaW5jbHVkZSA8bmV0aW5ldC9pbi5oPgojaW5jbHVkZSA8
c3RkaW8uaD4KI2luY2x1ZGUgPHN0cmluZy5oPgojaW5jbHVkZSA8c3lzL3NvY2tldC5oPgoKaW50
IG1haW4oKQp7CiAgLyogQ3JlYXRlIGEgVURQIHNlcnZlciBzb2NrZXQgb24gcG9ydCAxMzM3ICov
CiAgaW50IHNlcnZlcl9mZCA9IHNvY2tldChQRl9JTkVUNiwgU09DS19ER1JBTSwgMCk7CiAgc3Ry
dWN0IHNvY2thZGRyX2luNiBzZXJ2ZXJfYWRkcjsKICBzZXJ2ZXJfYWRkci5zaW42X2ZhbWlseSA9
IEFGX0lORVQ2OwogIC8vaW5ldF9wdG9uKEFGX0lORVQ2LCAiOjoxIiwgJnNlcnZlcl9hZGRyLnNp
bjZfYWRkcik7CiAgaW5ldF9wdG9uKEFGX0lORVQ2LCAiOjoiLCAmc2VydmVyX2FkZHIuc2luNl9h
ZGRyKTsKICBzZXJ2ZXJfYWRkci5zaW42X3BvcnQgPSBodG9ucygxMzM3KTsKICBiaW5kKHNlcnZl
cl9mZCwgKHN0cnVjdCBzb2NrYWRkciopJnNlcnZlcl9hZGRyLCBzaXplb2Yoc3RydWN0IHNvY2th
ZGRyX2luNikpOwoKICAvKiBDb25uZWN0IHRoZSBzZXJ2ZXIgc29ja2V0ICovCiAgc3RydWN0IHNv
Y2thZGRyX2luNiBjb25uZWN0X2FkZHI7CiAgY29ubmVjdF9hZGRyLnNpbjZfZmFtaWx5ID0gQUZf
SU5FVDY7CiAgaW5ldF9wdG9uKEFGX0lORVQ2LCAiOjoxIiwgJmNvbm5lY3RfYWRkci5zaW42X2Fk
ZHIpOwogIGNvbm5lY3RfYWRkci5zaW42X3BvcnQgPSBodG9ucyg4MCk7CiAgY29ubmVjdChzZXJ2
ZXJfZmQsIChzdHJ1Y3Qgc29ja2FkZHIqKSZjb25uZWN0X2FkZHIsIHNpemVvZihzdHJ1Y3Qgc29j
a2FkZHJfaW42KSk7CgogIC8qIERpc2Nvbm5lY3QgdGhlIHNlcnZlciBzb2NrZXQgKi8KICBzdHJ1
Y3Qgc29ja2FkZHIgZGlzY29ubmVjdF9hZGRyOwogIG1lbXNldCgmZGlzY29ubmVjdF9hZGRyLCAw
LCBzaXplb2Yoc3RydWN0IHNvY2thZGRyKSk7CiAgZGlzY29ubmVjdF9hZGRyLnNhX2ZhbWlseSA9
IEFGX1VOU1BFQzsKICBjb25uZWN0KHNlcnZlcl9mZCwgJmRpc2Nvbm5lY3RfYWRkciwgc2l6ZW9m
KHN0cnVjdCBzb2NrYWRkcikpOwoKICAvKiBDcmVhdGUgYSBVRFAgY2xpZW50IHNvY2tldCwgY29u
bmVjdCBpdCB0byB0aGUgc2VydmVyICovCiAgaW50IGNsaWVudF9mZCA9IHNvY2tldChQRl9JTkVU
NiwgU09DS19ER1JBTSwgMCk7CiAgc3RydWN0IHNvY2thZGRyX2luNiBjbGllbnRfYWRkcjsKICBj
bGllbnRfYWRkci5zaW42X2ZhbWlseSA9IEFGX0lORVQ2OwogIGluZXRfcHRvbihBRl9JTkVUNiwg
Ijo6MSIsICZjbGllbnRfYWRkci5zaW42X2FkZHIpOwogIGNsaWVudF9hZGRyLnNpbjZfcG9ydCA9
IGh0b25zKDEzMzcpOwogIGNvbm5lY3QoY2xpZW50X2ZkLCAoc3RydWN0IHNvY2thZGRyKikmY2xp
ZW50X2FkZHIsIHNpemVvZihzdHJ1Y3Qgc29ja2FkZHJfaW42KSk7CgogIC8qIFNlbmQgYSBtZXNz
YWdlIGZyb20gdGhlIGNsaWVudCB0byB0aGUgc2VydmVyICovCiAgY2hhciBidWZbOF07CiAgc2Vu
ZChjbGllbnRfZmQsICJoZWxsbyIsIHNpemVvZigiaGVsbG8iKSwgMCk7CiAgcmVjdihzZXJ2ZXJf
ZmQsIGJ1Ziwgc2l6ZW9mKGJ1ZiksIDApOwogIHByaW50ZigiJXNcbiIsIGJ1Zik7CgogIHJldHVy
biAwOwp9Cg==
--000000000000ee5c92059eb5f137
Content-Type: text/x-csrc; charset="US-ASCII"; name="udp_demo4.c"
Content-Disposition: attachment; filename="udp_demo4.c"
Content-Transfer-Encoding: base64
Content-ID: <f_k6pdv57u0>
X-Attachment-Id: f_k6pdv57u0

I2luY2x1ZGUgPGFycGEvaW5ldC5oPgojaW5jbHVkZSA8bmV0aW5ldC9pbi5oPgojaW5jbHVkZSA8
c3RkaW8uaD4KI2luY2x1ZGUgPHN0cmluZy5oPgojaW5jbHVkZSA8c3lzL3NvY2tldC5oPgoKaW50
IG1haW4oKQp7CiAgLyogQ3JlYXRlIGEgVURQIHNlcnZlciBzb2NrZXQgb24gcG9ydCAxMzM3ICov
CiAgaW50IHNlcnZlcl9mZCA9IHNvY2tldChQRl9JTkVULCBTT0NLX0RHUkFNLCAwKTsKICBzdHJ1
Y3Qgc29ja2FkZHJfaW4gc2VydmVyX2FkZHI7CiAgc2VydmVyX2FkZHIuc2luX2ZhbWlseSA9IEFG
X0lORVQ7CiAgLy9pbmV0X3B0b24oQUZfSU5FVCwgIjEyNy4wLjAuMSIsICZzZXJ2ZXJfYWRkci5z
aW5fYWRkcik7CiAgaW5ldF9wdG9uKEFGX0lORVQsICIwLjAuMC4wIiwgJnNlcnZlcl9hZGRyLnNp
bl9hZGRyKTsKICBzZXJ2ZXJfYWRkci5zaW5fcG9ydCA9IGh0b25zKDEzMzcpOwogIGJpbmQoc2Vy
dmVyX2ZkLCAoc3RydWN0IHNvY2thZGRyKikmc2VydmVyX2FkZHIsIHNpemVvZihzdHJ1Y3Qgc29j
a2FkZHJfaW4pKTsKCiAgLyogQ29ubmVjdCB0aGUgc2VydmVyIHNvY2tldCAqLwogIHN0cnVjdCBz
b2NrYWRkcl9pbiBjb25uZWN0X2FkZHI7CiAgY29ubmVjdF9hZGRyLnNpbl9mYW1pbHkgPSBBRl9J
TkVUOwogIGluZXRfcHRvbihBRl9JTkVULCAiMTI3LjAuMC4xIiwgJmNvbm5lY3RfYWRkci5zaW5f
YWRkcik7CiAgY29ubmVjdF9hZGRyLnNpbl9wb3J0ID0gaHRvbnMoODApOwogIGNvbm5lY3Qoc2Vy
dmVyX2ZkLCAoc3RydWN0IHNvY2thZGRyKikmY29ubmVjdF9hZGRyLCBzaXplb2Yoc3RydWN0IHNv
Y2thZGRyX2luKSk7CgogIC8qIERpc2Nvbm5lY3QgdGhlIHNlcnZlciBzb2NrZXQgKi8KICBzdHJ1
Y3Qgc29ja2FkZHIgZGlzY29ubmVjdF9hZGRyOwogIG1lbXNldCgmZGlzY29ubmVjdF9hZGRyLCAw
LCBzaXplb2Yoc3RydWN0IHNvY2thZGRyKSk7CiAgZGlzY29ubmVjdF9hZGRyLnNhX2ZhbWlseSA9
IEFGX1VOU1BFQzsKICBjb25uZWN0KHNlcnZlcl9mZCwgJmRpc2Nvbm5lY3RfYWRkciwgc2l6ZW9m
KHN0cnVjdCBzb2NrYWRkcikpOwoKICAvKiBDcmVhdGUgYSBVRFAgY2xpZW50IHNvY2tldCwgY29u
bmVjdCBpdCB0byB0aGUgc2VydmVyICovCiAgaW50IGNsaWVudF9mZCA9IHNvY2tldChQRl9JTkVU
LCBTT0NLX0RHUkFNLCAwKTsKICBzdHJ1Y3Qgc29ja2FkZHJfaW4gY2xpZW50X2FkZHI7CiAgY2xp
ZW50X2FkZHIuc2luX2ZhbWlseSA9IEFGX0lORVQ7CiAgaW5ldF9wdG9uKEFGX0lORVQsICIxMjcu
MC4wLjEiLCAmY2xpZW50X2FkZHIuc2luX2FkZHIpOwogIGNsaWVudF9hZGRyLnNpbl9wb3J0ID0g
aHRvbnMoMTMzNyk7CiAgY29ubmVjdChjbGllbnRfZmQsIChzdHJ1Y3Qgc29ja2FkZHIqKSZjbGll
bnRfYWRkciwgc2l6ZW9mKHN0cnVjdCBzb2NrYWRkcl9pbikpOwoKICAvKiBTZW5kIGEgbWVzc2Fn
ZSBmcm9tIHRoZSBjbGllbnQgdG8gdGhlIHNlcnZlciAqLwogIGNoYXIgYnVmWzhdOwogIHNlbmQo
Y2xpZW50X2ZkLCAiaGVsbG8iLCBzaXplb2YoImhlbGxvIiksIDApOwogIHJlY3Yoc2VydmVyX2Zk
LCBidWYsIHNpemVvZihidWYpLCAwKTsKICBwcmludGYoIiVzXG4iLCBidWYpOwoKICByZXR1cm4g
MDsKfQo=
--000000000000ee5c92059eb5f137--

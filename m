Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D776F10A68A
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 23:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbfKZW3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 17:29:43 -0500
Received: from mail-io1-f45.google.com ([209.85.166.45]:40194 "EHLO
        mail-io1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbfKZW3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 17:29:43 -0500
Received: by mail-io1-f45.google.com with SMTP id b26so20607140ion.7;
        Tue, 26 Nov 2019 14:29:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=r6koUu2f6R3GLr91V/KZf3S+E6pKCYI0nAYNGec6Ofc=;
        b=khF3Zqq6YpC5o9KnlpC7NHQg/ezwb9t/sKWGOH6z/QQT4p8ZpQ98F39Fp4ncetWT0W
         xW5USmPT1AsGkXufCF7I3PqP26r4Hs+F75Bf7x/QODbPtSTbcBYVlZEM46csGUPT2mGj
         50IaxRJSTlAxO//fLkHdVdiLnwP8K+/VILRQ1haPQwd2Nz9svG+rfQSvC//4v9qNxx6d
         z0Hr1BQcaarRNhcOyBlPEO4sdv2I3AXyfkkcMhtUKo4U32qSd/3QkpwqtY+vX43L6KZC
         k+KrKbImHv/ucdrzyVbgTxeOAYESzAHoZzTPTMvpySfaF6OG0D7oxfsl6oKywz480T6H
         BlKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=r6koUu2f6R3GLr91V/KZf3S+E6pKCYI0nAYNGec6Ofc=;
        b=BxWRl0vfx6DoJlOZChcVJ4C7QqslLqfXHKvGr/Ob/aBGSUWZneZ/nxQu2dPhTZgoH4
         buDNwFmXbNeFF/VkXUxMh9/Cd0/lJJUMR8IIUh/IrrQgcMs7tDC3cELZBEKuTx9hMLdm
         LVGs+kiA7+tNVzx6oOFgZdTpZKJnPyr0r5C5Lxfz0EBpd7UG142rUVsuYgGsnPLhMHRr
         2SMOWsw1tFP4xqaw/TRiGCaQLx5bk3DB7pGscv/swYD+dWWv1dYIpxbLMqwvkWhzIRAb
         uZ5oUnu77CbKYA1f/Ny65XOsVh28SMYRUjJAKyl6YGyXO+V8gsNVtaujLpHGi89sOLku
         +jVA==
X-Gm-Message-State: APjAAAVXEFjtLcFThg5eJ2/t0U5Uh7+RMUiy5GsSoax7elcGivu03siL
        2VJI4oE/dGs5c6VPontnfSxqcggWGeY4cqyrrf4=
X-Google-Smtp-Source: APXvYqy6OtqNBnFkzKoJTpNbi/qXLN89Olpl7HJKEzt91nWBOl+h2ci+4gQxgcOlGPIkSOu7QxJbtLnLnes3ilmP0nQ=
X-Received: by 2002:a6b:e701:: with SMTP id b1mr33000892ioh.119.1574807381829;
 Tue, 26 Nov 2019 14:29:41 -0800 (PST)
MIME-Version: 1.0
From:   Jeremy Rifkin <rifkin.jer@gmail.com>
Date:   Tue, 26 Nov 2019 15:29:30 -0700
Message-ID: <CABMFubf=Ht7xFaN+9jiddDj08D150jwHpio8i09KHCSD_9bK=Q@mail.gmail.com>
Subject: [patch] accept.2: Added information about what can cause EAGAIN and
 EWOULDBLOCK errors
To:     mtk.manpages@gmail.com
Cc:     linux-man@vger.kernel.org, netdev@vger.kernel.org
Content-Type: multipart/mixed; boundary="0000000000009593580598476a5f"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000009593580598476a5f
Content-Type: text/plain; charset="UTF-8"

Hello,
According to the accept.2 man page, EAGAIN and EWOULDBLOCK errors can occur when
"The socket is marked nonblocking and no connections are present to be
accepted". I have found that these errors can also occur when a receive timeout
has been set on the socket and the timeout expires before a connection can be
accepted. This appears to be the same behavior of the recv system call whose man
page states that EAGAIN and EWOULDBLOCK occur when "The socket is marked
nonblocking and the receive operation would block, or a receive timeout had been
set and the timeout expired before data was received."

I've included a test program to demonstrate that accept will fail with exit code
EAGAIN/EWOULDBLOCK when a receive timeout is set and the timeout expires.

This patch applies to the latest version man-pages, 5.04. I have amended
accept.2 to include this second reason why EAGAIN/EWOULDBLOCK can
occur. I have tried to use similar wording to that of the recv.2 man page.

======== Begin Diff ========

diff --git a/man2/accept.2 b/man2/accept.2
index a4bebd214..63e90a5e6 100644
--- a/man2/accept.2
+++ b/man2/accept.2
@@ -208,7 +208,9 @@ and
 .BR EAGAIN " or " EWOULDBLOCK
 .\" Actually EAGAIN on Linux
 The socket is marked nonblocking and no connections are
-present to be accepted.
+present to be accepted, or a receive timeout has been
+set and the timeout expired before a new connection
+was available to be accepted.
 POSIX.1-2001 and POSIX.1-2008
 allow either error to be returned for this case,
 and do not require these constants to have the same value,

========= End Diff =========

- Jeremy Rifkin

--0000000000009593580598476a5f
Content-Type: text/plain; charset="US-ASCII"; name="accept2test.c"
Content-Disposition: attachment; filename="accept2test.c"
Content-Transfer-Encoding: base64
Content-ID: <f_k3gee4t40>
X-Attachment-Id: f_k3gee4t40

Ly8gSmVyZW15IE0uIFJpZmtpbiAxMS4yNS4xOQovLyBEZW1vbnN0cmF0ZSB0aGF0IEVBR0FJTi9F
V09VTERCTE9DSyBjYW4gYmUgdHJpZ2dlcmVkIG9uIGFjY2VwdCgyKSBieSBhIHJlY3YgdGltZW91
dAojaW5jbHVkZSA8c3RkaW8uaD4KI2luY2x1ZGUgPHN0ZGxpYi5oPgojaW5jbHVkZSA8c3lzL3Nv
Y2tldC5oPgojaW5jbHVkZSA8bmV0aW5ldC9pbi5oPgojaW5jbHVkZSA8ZXJybm8uaD4KCnZvaWQg
ZmFpbChjaGFyKiBmb3JtYXQpIHsKCWZwcmludGYoc3RkZXJyLCBmb3JtYXQsIGVycm5vKTsKCWZm
bHVzaChzdGRlcnIpOwoJZXhpdCgxKTsKfQoKaW50IG1haW4gKGludCBhcmdjLCBjaGFyICphcmd2
W10pIHsKCWludCBlcnI7CglpbnQgc29ja2V0ZmQgPSBzb2NrZXQoQUZfSU5FVCwgU09DS19TVFJF
QU0sIDApOwoJaWYoc29ja2V0ZmQgPCAwKQoJCWZhaWwoIlx4MWJbMTszNW1FcnJvcjpceDFiWzBt
IGZhaWxlZCB0byBjcmVhdGUgc29ja2V0IChlcnJubzogJWQpLi4uIFRoaXMgc2hvdWxkbid0IGhh
dmUgIgoJCQkiaGFwcGVuZWQuXG4iKTsKCgkvLyBDb25maWd1cmUgc29ja2V0CglzdHJ1Y3Qgc29j
a2FkZHJfaW4gc2VydmVyOwoJc2VydmVyLnNpbl9mYW1pbHkgPSBBRl9JTkVUOwoJc2VydmVyLnNp
bl9wb3J0ID0gaHRvbnMoMCk7IC8vIHBvcnQgMCBmb3IgcmFuZG9tIHBvcnQKCXNlcnZlci5zaW5f
YWRkci5zX2FkZHIgPSBodG9ubChJTkFERFJfQU5ZKTsKCgkvLyBTZXQgcmV1c2VhZGRyCglpbnQg
b3B0ID0gMTsKCWVyciA9IHNldHNvY2tvcHQoc29ja2V0ZmQsIFNPTF9TT0NLRVQsIFNPX1JFVVNF
QUREUiwgJm9wdCwgc2l6ZW9mKG9wdCkpOwoJaWYoZXJyIDwgMCkKCQlmYWlsKCJceDFiWzE7MzVt
RXJyb3I6XHgxYlswbSBmYWlsZWQgdG8gc2V0IHNvY2tldCByZXVzZWFkZHIgKGVycm5vOiAlZCku
Li4gVGhpcyBzaG91bGRuJ3QgIgoJCQkiaGF2ZSBoYXBwZW5lZC5cbiIpOwoKCS8vIENvbmZpZ3Vy
ZSB0aW1lb3V0CglzdHJ1Y3QgdGltZXZhbCB0aW1lb3V0OwoJdGltZW91dC50dl9zZWMgPSA0OyAv
LyA0IHNlY29uZCB0aW1lb3V0Cgl0aW1lb3V0LnR2X3VzZWMgPSAwOwoJZXJyID0gc2V0c29ja29w
dChzb2NrZXRmZCwgU09MX1NPQ0tFVCwgU09fUkNWVElNRU8sIChjb25zdCBjaGFyKikmdGltZW91
dCwgc2l6ZW9mIHRpbWVvdXQpOwoJaWYoZXJyIDwgMCkKCQlmYWlsKCJceDFiWzE7MzVtRXJyb3I6
XHgxYlswbSBmYWlsZWQgdG8gc2V0IHNvY2tldCByZWN2IHRpbWVvdXQgKGVycm5vOiAlZCkuLi4g
VGhpcyAiCgkJCSJzaG91bGRuJ3QgaGF2ZSBoYXBwZW5lZC5cbiIpOwoKCS8vIEJpbmQgdGhlIHNv
Y2tldAoJZXJyID0gYmluZChzb2NrZXRmZCwgKHN0cnVjdCBzb2NrYWRkciopICZzZXJ2ZXIsIHNp
emVvZihzZXJ2ZXIpKTsKCWlmKGVyciA8IDApCgkJZmFpbCgiXHgxYlsxOzM1bUVycm9yOlx4MWJb
MG0gZmFpbGVkIHRvIGJpbmQgc29ja2V0IChlcnJubzogJWQpLi4uIFRoaXMgc2hvdWxkbid0IGhh
dmUgIgoJCQkiaGFwcGVuZWQuXG4iKTsKCgkvLyBNYXJrIHNvY2tldCBhcyBwYXNzaXZlLgoJZXJy
ID0gbGlzdGVuKHNvY2tldGZkLCAxMjgpOwoJaWYoZXJyIDwgMCkKCQlmYWlsKCJceDFiWzE7MzVt
RXJyb3I6XHgxYlswbSBmYWlsZWQgdG8gbGlzdGVuIG9uIHNvY2tldCAoZXJybm86ICVkKS4uLiBU
aGlzIHNob3VsZG4ndCAiCgkJCSJoYXZlIGhhcHBlbmVkLlxuIik7CgoJLy8gR2V0IHBvcnQKCS8v
IFNlcnZlcyBhcyBib3RoIGEgY2hlY2sgYW5kIGFsc28gYWNjb21tb2RhdGVzIGZvciAicmFuZG9t
IiBwb3J0cy4KCXN0cnVjdCBzb2NrYWRkcl9pbiBhZGRyOwoJc29ja2xlbl90IGFkZHJfbGVuID0g
c2l6ZW9mKGFkZHIpOwoJZXJyID0gZ2V0c29ja25hbWUoc29ja2V0ZmQsIChzdHJ1Y3Qgc29ja2Fk
ZHIqKSZhZGRyLCAmYWRkcl9sZW4pOwoJaWYoZXJyIDwgMCkKCQlmYWlsKCJceDFiWzE7MzVtRXJy
b3I6XHgxYlswbSBmYWlsZWQgdG8gZ2V0IHNvY2tldCBhZGRyZXNzIChlcnJubzogJWQpLi4uIFRo
aXMgc2hvdWxkbid0ICIKCQkJImhhdmUgaGFwcGVuZWQuXG4iKTsKCXByaW50ZigiU29ja2V0IGxp
c3RlbmluZyBvbiBwb3J0ICVkXG4iLCBudG9ocyhhZGRyLnNpbl9wb3J0KSk7CgkKCS8vIERlbW9u
c3RyYXRlIHJlY3YgdGltZW91dCBmYWlsdXJlCglwcmludGYoIlxuQSA0IHNlY29uZCByZWN2IHRp
bWVvdXQgaGFzIGJlZW4gc2V0IG9uIHRoZSBzb2NrZXQuXG4iKTsKCXByaW50ZigiVGhlIHByb2dy
YW0gd2lsbCBub3cgYXR0ZW1wdCB0byBhY2NlcHQgY29ubmVjdGlvbnMuXG4iKTsKCXByaW50Zigi
SXQgc2hvdWxkIGZhaWwgd2l0aCBlcnJvciBFQUdBSU4vRVdPVUxEQkxPQ0sgcm91Z2hseVxuIik7
CglwcmludGYoImV2ZXJ5IDQgc2Vjb25kcy5cblxuIik7Cgl3aGlsZSgxKSB7CgkJc3RydWN0IHNv
Y2thZGRyX2luIGNsaWVudDsKCQlzb2NrbGVuX3QgY2xpZW50X2xlbiA9IHNpemVvZihjbGllbnQp
OwoJCWludCBjbGllbnRmZCA9IGFjY2VwdChzb2NrZXRmZCwgKHN0cnVjdCBzb2NrYWRkciopJmNs
aWVudCwgJmNsaWVudF9sZW4pOwoKCQlpZihjbGllbnRmZCA8IDApIHsKCQkJaWYoZXJybm8gPT0g
RUFHQUlOKQoJCQkJZnByaW50ZihzdGRlcnIsICJceDFiWzE7MzVtRXJyb3I6XHgxYlswbSBTb2Nr
ZXQgZmFpbGVkIHRvIGFjY2VwdCB3aXRoIGVycm9yIEVBR0FJTi4iCgkJCQkJIlxuIik7CgkJCWVs
c2UgaWYoZXJybm8gPT0gRVdPVUxEQkxPQ0spCgkJCQlmcHJpbnRmKHN0ZGVyciwgIlx4MWJbMTsz
NW1FcnJvcjpceDFiWzBtIFNvY2tldCBmYWlsZWQgdG8gYWNjZXB0IHdpdGggZXJyb3IgIgoJCQkJ
CSJFV09VTERCTE9DSy5cbiIpOwoJCQllbHNlCgkJCQlmcHJpbnRmKHN0ZGVyciwgIlx4MWJbMTsz
NW1FcnJvcjpceDFiWzBtIGZhaWxlZCB0byBlc3RhYmxpc2ggbmV3IGNvbm5lY3Rpb24gIgoJCQkJ
CSIoZXJybm86ICVkKS4uLiBUaGlzIHNob3VsZG4ndCBoYXZlIGhhcHBlbmVkLlxuIiwKCQkJCQll
cnJubyk7CgkJCWZmbHVzaChzdGRlcnIpOwoJCX0KCX0KCglyZXR1cm4gMDsKfQoK
--0000000000009593580598476a5f--

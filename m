Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 380A128A724
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 13:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729954AbgJKLSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 07:18:07 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:24850 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729809AbgJKLSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 07:18:04 -0400
X-IronPort-AV: E=Sophos;i="5.77,362,1596492000"; 
   d="scan'208";a="471985689"
Received: from palace.rsr.lip6.fr (HELO palace.lip6.fr) ([132.227.105.202])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/AES256-SHA256; 11 Oct 2020 13:18:00 +0200
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     linux-security-module@vger.kernel.org
Cc:     =?UTF-8?q?Valdis=20Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>,
        Joe Perches <joe@perches.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-afs@lists.infradead.org
Subject: [PATCH 0/5] net: use semicolons rather than commas to separate statements
Date:   Sun, 11 Oct 2020 12:34:53 +0200
Message-Id: <1602412498-32025-1-git-send-email-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 1.9.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches replace commas by semicolons.  Commas introduce
unnecessary variability in the code structure and are hard to see.
This was done using the Coccinelle semantic patch
(http://coccinelle.lip6.fr/) shown below.

This semantic patch ensures that commas inside for loop headers will
not be transformed.  It also doesn't touch macro definitions.

Coccinelle ensures that braces are added as needed when a
single-statement branch turns into a multi-statement one.

This semantic patch has a few false positives, for variable
delcarations such as:

LIST_HEAD(x), *y;

The semantic patch could be improved to avoid these, but for the
moment they have been removed manually (2 occurrences).

// <smpl>
@initialize:ocaml@
@@

let infunction p =
  (* avoid macros *)
  (List.hd p).current_element <> "something_else"

let combined p1 p2 =
  (List.hd p1).line_end = (List.hd p2).line ||
  (((List.hd p1).line_end < (List.hd p2).line) &&
   ((List.hd p1).col < (List.hd p2).col))

@bad@
statement S;
declaration d;
position p;
@@

S@p
d

// special cases where newlines are needed (hope for no more than 5)
@@
expression e1,e2;
statement S;
position p != bad.p;
position p1;
position p2 :
    script:ocaml(p1) { infunction p1 && combined p1 p2 };
@@

- e1@p1,@S@p e2@p2;
+ e1; e2;

@@
expression e1,e2;
statement S;
position p != bad.p;
position p1;
position p2 :
    script:ocaml(p1) { infunction p1 && combined p1 p2 };
@@

- e1@p1,@S@p e2@p2;
+ e1; e2;

@@
expression e1,e2;
statement S;
position p != bad.p;
position p1;
position p2 :
    script:ocaml(p1) { infunction p1 && combined p1 p2 };
@@

- e1@p1,@S@p e2@p2;
+ e1; e2;

@@
expression e1,e2;
statement S;
position p != bad.p;
position p1;
position p2 :
    script:ocaml(p1) { infunction p1 && combined p1 p2 };
@@

- e1@p1,@S@p e2@p2;
+ e1; e2;

@@
expression e1,e2;
statement S;
position p != bad.p;
position p1;
position p2 :
    script:ocaml(p1) { infunction p1 && combined p1 p2 };
@@

- e1@p1,@S@p e2@p2;
+ e1; e2;

@r@
expression e1,e2;
statement S;
position p != bad.p;
@@

e1 ,@S@p e2;

@@
expression e1,e2;
position p1;
position p2 :
    script:ocaml(p1) { infunction p1 && not(combined p1 p2) };
statement S;
position r.p;
@@

e1@p1
-,@S@p
+;
e2@p2
... when any
// </smpl>

---

 net/ipv4/tcp_input.c       |    3 ++-
 net/ipv4/tcp_vegas.c       |    8 ++++----
 net/ipv6/calipso.c         |    2 +-
 net/mac80211/debugfs_sta.c |    2 +-
 net/rxrpc/recvmsg.c        |    2 +-
 net/tls/tls_main.c         |    2 +-
 6 files changed, 10 insertions(+), 9 deletions(-)

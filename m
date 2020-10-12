Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C827D28B1AD
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 11:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729468AbgJLJhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 05:37:06 -0400
Received: from mailout07.rmx.de ([94.199.90.95]:44842 "EHLO mailout07.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbgJLJhF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 05:37:05 -0400
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout07.rmx.de (Postfix) with ESMTPS id 4C8tqc4S9WzBwTl;
        Mon, 12 Oct 2020 11:37:00 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4C8tpx6QPkz2TTJR;
        Mon, 12 Oct 2020 11:36:25 +0200 (CEST)
Received: from N95HX1G2.wgnetz.xx (192.168.54.142) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Mon, 12 Oct
 2020 11:36:25 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Willem de Bruijn <willemb@google.com>
CC:     Christoph Hellwig <hch@lst.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Christian Eggers <ceggers@arri.de>
Subject: [PATCH net v2 2/2] socket: don't clear SOCK_TSTAMP_NEW when SO_TIMESTAMPNS is disabled
Date:   Mon, 12 Oct 2020 11:35:42 +0200
Message-ID: <20201012093542.15504-2-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012093542.15504-1-ceggers@arri.de>
References: <20201012093542.15504-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.142]
X-RMX-ID: 20201012-113625-4C8tpx6QPkz2TTJR-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SOCK_TSTAMP_NEW (timespec64 instead of timespec) is also used for
hardware time stamps (configured via SO_TIMESTAMPING_NEW).

User space (ptp4l) first configures hardware time stamping via
SO_TIMESTAMPING_NEW which sets SOCK_TSTAMP_NEW. In the next step, ptp4l
disables SO_TIMESTAMPNS(_NEW) (software time stamps), but this must not
switch hardware time stamps back to "32 bit mode".

This problem happens on 32 bit platforms were the libc has already
switched to struct timespec64 (from SO_TIMExxx_OLD to SO_TIMExxx_NEW
socket options). ptp4l complains with "missing timestamp on transmitted
peer delay request" because the wrong format is received (and
discarded).

Fixes: 887feae36aee ("socket: Add SO_TIMESTAMP[NS]_NEW")
Fixes: 783da70e8396 ("net: add sock_enable_timestamps")
Signed-off-by: Christian Eggers <ceggers@arri.de>
Acked-by: Willem de Bruijn <willemb@google.com>
Acked-by: Deepa Dinamani <deepa.kernel@gmail.com>
---
v2:
-----
- Added ACKs from Willem and Deepa


On Saturday, 10 October 2020, 05:38:56 CEST, Deepa Dinamani wrote:
> On Fri, Oct 9, 2020 at 5:35 PM Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:
> > As this commit message shows, with SO_TIMESTAMP(NS) and
> > SO_TIMESTAMPING that can be independently turned on and off, disabling
> > one can incorrectly switch modes while the other is still active.
> 
> This will not help the case when a child process that inherits the fd
> and then sets SO_TIMESTAMP*_OLD/NEW on it, while the parent uses the
> other version.
> One of the two processes might still be surprised. But, child and
> parent actively using the same socket fd might be expecting trouble
> already.

Usually the decision between SO_TIMESTAMP*_OLD/NEW  will be done at compile
time (trough the system C library headers). For a typical "distribution" it
should be quite unlikely that two programs will be compiled using different
settings.

 net/core/sock.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 669cf9b8bb44..f4236c7512b5 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -757,7 +757,6 @@ static void __sock_set_timestamps(struct sock *sk, bool val, bool new, bool ns)
 	} else {
 		sock_reset_flag(sk, SOCK_RCVTSTAMP);
 		sock_reset_flag(sk, SOCK_RCVTSTAMPNS);
-		sock_reset_flag(sk, SOCK_TSTAMP_NEW);
 	}
 }
 
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler


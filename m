Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17261114FDA
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 12:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbfLFLic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 06:38:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20522 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726102AbfLFLic (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 06:38:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575632310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=/tksp6QCjCNyD1KCxeEAGbmatWkLx/OlLD5Cry9rCGA=;
        b=A3jBd3t+ZKfF+jE6qB/rn2Oz01+cpMwf/y+3qd6/m4XTDps3zXsm+bm1lDmlOUo/qA1OAy
        hBab+hzU+SgQYD9ukqrNKFYawide81lYP98oFvvblqd5283TUs3s2T6ePWeuwfmZfd5ZhS
        8JIPJ5ZymJi+eSCZyx7bC8sapxQANuI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-A4j5m6WqPsCJ-H2vEVjvsA-1; Fri, 06 Dec 2019 06:38:29 -0500
Received: by mail-wr1-f72.google.com with SMTP id j13so3008785wrr.20
        for <netdev@vger.kernel.org>; Fri, 06 Dec 2019 03:38:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=SCs8owGIYo/MFXxmy35IpHzx7sOv7/0aTANM2xLBFE0=;
        b=kqOAsyJgGGB0RJ0wR+xPWj7CJYUjTAQPLVMvWRJurlUS/dWaoWLX164fzWJeDCgXFt
         XHzdujiWj5+ngDHbIvj0Kq0nFE9GnkUBKNhCUe2vcT1uze51HbGi67UYtmu7kfHso8ul
         MSW8ZXdtcMk77dDQUnZjI9XRyzWBXIqYtRKkcR1PyhJjD4mTRr04eDKH7I+fAWB0ygIV
         DJLRr/5kPWRzLA+AErvUlfDrnoLpcwhfXJtTbRFTK68eI6oUr9m5AlNvT5jQX/+4sOUb
         psnBuzbMHCyeKm+aNxduCWFbEzZye3NQJeg8z+EHWRQWq+IHjccBzUm0w51cEf6zFFPo
         tHGw==
X-Gm-Message-State: APjAAAUbYLe9uf8dvLEP4FjlVXYfNLFsW2OkmgnDn0yDZ1CBajFyEUqL
        zfS5IQbNOY4tLYR/MIRfn2shrU87GkTwhCBChLYiQWAEnWvhaTJnYB6iTNI4fPYkiGJMjSBZSmA
        /34bS/P0tdxHzNMBW
X-Received: by 2002:a1c:4b03:: with SMTP id y3mr10683080wma.91.1575632308857;
        Fri, 06 Dec 2019 03:38:28 -0800 (PST)
X-Google-Smtp-Source: APXvYqzbWmlHgYAhvGOyc/KdW4FcqzayGtr2BTSCcYNB0YzQi9t9/rTaa0yUmDG6KdvYP5QD2rvb1A==
X-Received: by 2002:a1c:4b03:: with SMTP id y3mr10683050wma.91.1575632308583;
        Fri, 06 Dec 2019 03:38:28 -0800 (PST)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id t13sm3227168wmt.23.2019.12.06.03.38.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Dec 2019 03:38:27 -0800 (PST)
Date:   Fri, 6 Dec 2019 12:38:26 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH net v4 0/3] tcp: fix handling of stale syncookies timestamps
Message-ID: <cover.1575631229.git.gnault@redhat.com>
MIME-Version: 1.0
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: A4j5m6WqPsCJ-H2vEVjvsA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The synflood timestamps (->ts_recent_stamp and ->synq_overflow_ts) are
only refreshed when the syncookie protection triggers. Therefore, their
value can become very far apart from jiffies if no synflood happens for
a long time.

If jiffies grows too much and wraps while the synflood timestamp isn't
refreshed, then time_after32() might consider the later to be in the
future. This can trick tcp_synq_no_recent_overflow() into returning
erroneous values and rejecting valid ACKs.

Patch 1 handles the case of ACKs using legitimate syncookies.
Patch 2 handles the case of stray ACKs.
Patch 3 annotates lockless timestamp operations with READ_ONCE() and
WRITE_ONCE().

Changes from v3:
  - Fix description of time_between32() (found by Eric Dumazet).
  - Use more accurate Fixes tag in patch 3 (suggested by Eric Dumazet).

Changes from v2:
  - Define and use time_between32() instead of a pair of
    time_before32/time_after32 (suggested by Eric Dumazet).
  - Use 'last_overflow - HZ' as lower bound in
    tcp_synq_no_recent_overflow(), to accommodate for concurrent
    timestamp updates (found by Eric Dumazet).
  - Add a third patch to annotate lockless accesses to .ts_recent_stamp.

Changes from v1:
  - Initialising timestamps at socket creation time is not enough
    because jiffies wraps in 24 days with HZ=3D1000 (Eric Dumazet).
    Handle stale timestamps in tcp_synq_overflow() and
    tcp_synq_no_recent_overflow() instead.
  - Rework commit description.
  - Add a second patch to handle the case of stray ACKs.

Guillaume Nault (3):
  tcp: fix rejected syncookies due to stale timestamps
  tcp: tighten acceptance of ACKs not matching a child socket
  tcp: Protect accesses to .ts_recent_stamp with {READ,WRITE}_ONCE()

 include/linux/time.h | 13 +++++++++++++
 include/net/tcp.h    | 27 +++++++++++++++++++--------
 2 files changed, 32 insertions(+), 8 deletions(-)

--=20
2.21.0


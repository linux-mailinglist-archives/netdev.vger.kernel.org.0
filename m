Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73279114A9C
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 02:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbfLFBtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 20:49:50 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21061 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725988AbfLFBtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 20:49:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575596989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZriYu19n4EBHBzvMu+eUu/GZODOeaUFZd9weTySDjnM=;
        b=Hd9sh9cPlPKFWBQuqa7qC7ezJC5VGs+YPtAiQib+uukcvpBOCJeKuNBJnhpvxeEc7iZldu
        cPefe589zZm95l7szo4wqE7/CcS7edXDUUifPEdZoNEwLkLuREf4dW/c07QIN6IRlhX8CX
        T6KSRwW0Iu5JxQ3JHLVbNBZ/kHfQcqo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-imDoi9snMbmhetUS7qO3Og-1; Thu, 05 Dec 2019 20:49:45 -0500
Received: by mail-wr1-f72.google.com with SMTP id t3so2391542wrm.23
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 17:49:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=aHhrOM6YqaYJbL1j4JwfCn7z55ACTZUEZlsKZcWLda0=;
        b=IKFezt60TjFDD3LD8OEs5TM+zCYclkGR5hIPC1A7bgiamuTAh9yp68SE3yFKNUhHNS
         4NaODZoRepPZVlvJMBcob4F6+wbv5GaFMyZe0U75AIhPt3WseqzJH6uiTSP0l1F0DFdZ
         w4x1ueEF/K0R4dQlfnflDvBxN7L+TO0KKvo9QYxtOr3FQLDjpm6CMbFzmvWcpZxB8b7t
         Cd8KqLcUo/IhRC7hxUFXWGtUnwoiMeqVdw+j3IDHZfawQHzP9vtcpSQcCGMXSMFTKy+o
         lb4zxgjaV+lxkk8tBEbceeINotfPUdKsPfDVd7/QmgWIg4cXj0GPlWbLdkuwZGX1sdKK
         ka1A==
X-Gm-Message-State: APjAAAVVBUkTJAwycC9xyshcoMkjxtP1AsUNYjgh6bZsHs6j5CcH85uz
        DN2HIItIW/fPZaiFSEjEoz83JZ6qJA6rnT8t2fwTikxN+15vKDuxELAjw1ECgn91w9k0cXbTYYa
        Z8dutnbmVW13O7CLJ
X-Received: by 2002:adf:93c5:: with SMTP id 63mr12884522wrp.236.1575596984182;
        Thu, 05 Dec 2019 17:49:44 -0800 (PST)
X-Google-Smtp-Source: APXvYqzJNMn3r7jSM7sfNABHDwrUh1hPRyL2bpwpM6ClhBYgTtH64ECxBFjDdgGEgwVGzWNRWnjpVg==
X-Received: by 2002:adf:93c5:: with SMTP id 63mr12884515wrp.236.1575596983942;
        Thu, 05 Dec 2019 17:49:43 -0800 (PST)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id e18sm14056217wrr.95.2019.12.05.17.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 17:49:43 -0800 (PST)
Date:   Fri, 6 Dec 2019 02:49:41 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH net v3 0/3] tcp: fix handling of stale syncookies timestamps
Message-ID: <cover.1575595670.git.gnault@redhat.com>
MIME-Version: 1.0
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: imDoi9snMbmhetUS7qO3Og-1
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


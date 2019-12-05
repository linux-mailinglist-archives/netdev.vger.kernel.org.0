Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0947511390C
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 01:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbfLEA7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 19:59:04 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40495 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728121AbfLEA7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 19:59:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575507542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=+4Y3sUKkhFgnv1/b6/EFWquzw2a8IbHcBTqjOTR9Jb0=;
        b=b4wCcb+vdj0nzS9lNAdC5ykttgLxZm5NzRwKdPLSrVoUi/wMFkDcbkvjq04H4ScOMictyo
        5ph4Cyt8rjbGEqfZOd8P/IBMuJmtBFo1ly+oMYIDEVpQfTsvk+2GfigU1bW8lD7Qvq6MYL
        Z7owCDmNdtzCFdd9iWbiE6oUuaLDD7w=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-zUJFBVn8MOq-zAWq5-7fhg-1; Wed, 04 Dec 2019 19:59:01 -0500
Received: by mail-wr1-f70.google.com with SMTP id f15so744059wrr.2
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 16:59:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=dAdr/cvaM5OksfzT+t8boHNSMzmA8Z61AAYlQW0o16M=;
        b=r70YYo5KCXBRx88IKWCxhDC6Tw76Bf3tNyNgW/miQXwZfgHpVAX9ojxvnf/3vUVQ5A
         wF2JGrw3pftYjsl2UW331xMTIovhXhfAaSNWDD28QpFFspzXqCh2aEV7lWCXLsYqNI1p
         EkvVfc8NDmQNQ/LDicn2Riuhjx5jfcN1eVbzNC7KB83cHt9lrlVw9GH0L4bzJWhxDKnk
         e52uYIdjL6pSXs3Gc2Xt2X1ja05FIG2xsNiL0qTo7MfDG9LdO0c2U5DnQgKEleFx6BEO
         yG+Sy3nY6nj/0QgZzD273AUTSo+I2nHagbEwwAuY6t5uPoljJz+d3idsjbQZ46mECaJW
         9W5g==
X-Gm-Message-State: APjAAAWkbtIN6yKN6ODF1TXRH4CzxEe64DYFvfK6jTvGG4vAVwp6oa+M
        sBMddM6edWHhGpHzoEHZVGqMI3TpKQQ2UeEcavSQUiXSPd7tOFI7poeEwPkMDT3bbEx/ItQNrY4
        WIRwrjb6+3xmwvcfI
X-Received: by 2002:adf:b645:: with SMTP id i5mr6869454wre.347.1575507540817;
        Wed, 04 Dec 2019 16:59:00 -0800 (PST)
X-Google-Smtp-Source: APXvYqw3TeOMp2/k9VDJMA/YV6znDCu0UpW7fdwI86OjhIO7xAX8hb2JcJGqONHUTyj4lgoxehMNzA==
X-Received: by 2002:adf:b645:: with SMTP id i5mr6869449wre.347.1575507540628;
        Wed, 04 Dec 2019 16:59:00 -0800 (PST)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id k13sm8717593wrx.59.2019.12.04.16.58.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 16:59:00 -0800 (PST)
Date:   Thu, 5 Dec 2019 01:58:58 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net v2 0/2] tcp: fix handling of stale syncookies timestamps
Message-ID: <cover.1575503545.git.gnault@redhat.com>
MIME-Version: 1.0
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: zUJFBVn8MOq-zAWq5-7fhg-1
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

Changes from v1:
  - Initialising timestamps at socket creation time is not enough
    because jiffies wraps in 24 days with HZ=3D1000 (Eric Dumazet).
    Handle stale timestamps in tcp_synq_overflow() and
    tcp_synq_no_recent_overflow() instead.
  - Rework commit description.
  - Add a second patch to handle the case of stray ACKs.

Guillaume Nault (2):
  tcp: fix rejected syncookies due to stale timestamps
  tcp: tighten acceptance of ACKs not matching a child socket

 include/net/tcp.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--=20
@DaveM, I'm sending both patches in one series as they logically fit
together, although patch 2 is arguably a performance optimisation. I
can drop it from the series and repost it when net-next reopens if
you prefer. Although that'd make the link between the two less obvious.


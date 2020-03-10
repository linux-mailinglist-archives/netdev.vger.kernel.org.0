Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 758E517F101
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 08:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbgCJH2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 03:28:01 -0400
Received: from mail-qv1-f66.google.com ([209.85.219.66]:33312 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbgCJH2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 03:28:01 -0400
Received: by mail-qv1-f66.google.com with SMTP id cz10so2214758qvb.0
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 00:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jY2V0vUYffwmpJBvBAUJXENUiC4SgnyNO2oGEThgrYo=;
        b=kJJgX3vXb95hg5fco6bAuKoI1bGfY4zUK2XkMY9AjCRhBEMpN38f1WV8CyBUPpchfQ
         kMKxjmjaXH9wK49KVPbfn96Cn7wvxQLJMHcEmB4wBFxFXOUSbPwgqdhEnOLF8Xdwlkhp
         C4Zai617mTpmZtXhxaIkBDro/Q3NZRGtrdw19CqkE2vHqhF3ZlAjk6Y0U4mNcH4fnju5
         u1xXy4IW8HG7WvQIoXpVA/eBvdefy5bLb/A92GaQDixJDBVHsxRDq+IVDDd3C9MoWNXx
         K4E+rK+nP6ur0w7JUoDeDCWFiGnAyJ449WlqHIznq/rG0EtC43oH5VXnglN36ZtSCEs0
         jkPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jY2V0vUYffwmpJBvBAUJXENUiC4SgnyNO2oGEThgrYo=;
        b=Dsd5R27nl7PgNf3MJybXh8mD7mrbRWF8FYyzyzik3xiwBRSfc3uRDyGu8QaTMgyJum
         9wqfvudbW49lO7WWbuB06BvFyKcazU05vMZ9w2W64YTZpHapOdW6jL5JOYb1bdLcI1fg
         Yoeb1q9xhAM2qHKr/3VKxwemB3bnJi+S7hsEbHOuFV2lvbinLcM0g2kqtoqPd8ksW0ZO
         nLT2VOHvlTBaZEB6rtGMOR8vAa3OCw1+mrRa54es2DETypYn23SY/GHBxCxvXfyLssHo
         yO47k9Kb2WTPLbyzMpZssf6p5ChgVAnfhpIdRMxsK6GSMTzRePysXbNILZ3MFEPZ+Fqh
         KAZw==
X-Gm-Message-State: ANhLgQ0xBFrNGDLk92IWR6OJrn7nq8yOOd3b3fdoBMqqYSuzDsH/luNm
        4t0wx6VIjFYwjRd2ST1mksyLOtEb9nY=
X-Google-Smtp-Source: ADFU+vup9BPqUJkoheq+qFPKayJLkqgD4iqD0IlvqNLbgAL3vCSPJZjX+xQclkm/v1PBIZNrHU0V2g==
X-Received: by 2002:a05:6214:a48:: with SMTP id ee8mr18149034qvb.90.1583825278810;
        Tue, 10 Mar 2020 00:27:58 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g22sm8698687qtp.8.2020.03.10.00.27.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 00:27:58 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        John Crispin <john@phrozen.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net] ipv6/addrconf: call ipv6_mc_up() for non-Ethernet interface
Date:   Tue, 10 Mar 2020 15:27:37 +0800
Message-Id: <20200310072737.28031-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200310072044.24313-1-liuhangbin@gmail.com>
References: <20200310072044.24313-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rafał found an issue that for non-Ethernet interface, if we down and up
frequently, the memory will be consumed slowly.

The reason is we add allnodes/allrouters addressed in multicast list in
ipv6_add_dev(). When link down, we call ipv6_mc_down(), store all multicast
addresses via mld_add_delrec(). But when link up, we don't call ipv6_mc_up()
for non-Ethernet interface to remove the addresses. This makes idev->mc_tomb
getting bigger and bigger. The call stack looks like:

addrconf_notify(NETDEV_REGISTER)
	ipv6_add_dev
		ipv6_dev_mc_inc(ff01::1)
		ipv6_dev_mc_inc(ff02::1)
		ipv6_dev_mc_inc(ff02::2)

addrconf_notify(NETDEV_UP)
	addrconf_dev_config
		/* Alas, we support only Ethernet autoconfiguration. */
		return;

addrconf_notify(NETDEV_DOWN)
	addrconf_ifdown
		ipv6_mc_down
			igmp6_group_dropped(ff02::2)
				mld_add_delrec(ff02::2)
			igmp6_group_dropped(ff02::1)
			igmp6_group_dropped(ff01::1)

After investigating, I can't found a rule to disable multicast on
non-Ethernet interface. In RFC2460, the link could be Ethernet, PPP, ATM,
tunnels, etc. In IPv4, it doesn't check the dev type when calls ip_mc_up()
in inetdev_event(). Even for IPv6, we don't check the dev type and call
ipv6_add_dev(), ipv6_dev_mc_inc() after register device.

So I think it's OK to fix this memory consumer by calling ipv6_mc_up() for
non-Ethernet interface.

v2: Also check IFF_MULTICAST flag to make sure the interface supports
    multicast

Reported-by: Rafał Miłecki <zajec5@gmail.com>
Fixes: 74235a25c673 ("[IPV6] addrconf: Fix IPv6 on tuntap tunnels")
Fixes: 1666d49e1d41 ("mld: do not remove mld souce list info when set link down")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/ipv6/addrconf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index e6e1290ea06f..46d614b611db 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3347,6 +3347,10 @@ static void addrconf_dev_config(struct net_device *dev)
 	    (dev->type != ARPHRD_NONE) &&
 	    (dev->type != ARPHRD_RAWIP)) {
 		/* Alas, we support only Ethernet autoconfiguration. */
+		idev = __in6_dev_get(dev);
+		if (!IS_ERR_OR_NULL(idev) && dev->flags & IFF_UP &&
+		    dev->flags & IFF_MULTICAST)
+			ipv6_mc_up(idev);
 		return;
 	}
 
-- 
2.19.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C77F17F0F8
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 08:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbgCJHVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 03:21:09 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:41461 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbgCJHVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 03:21:09 -0400
Received: by mail-qt1-f196.google.com with SMTP id l21so8927682qtr.8
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 00:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wQjl0kJnU3lo76Yukf2Ffa+rtE8inF/IXMwsHXjE8jc=;
        b=F5E4Y0CAbynxV9/zhhScsHEppWP0O5Pm+8SWUn6czSfPmzKGNuyqaQZ+j3qsemrU3K
         nwmiHKThwTG4DbUL1rNvfmDy8VTJfp0zHlm/uUT2O05HpqDhtshbO/PSpSlDNu+dnT3O
         xJNPlE9bKJt5RqibjSQpAkPLP8vou7a1huWO1sjK9mTakIhuLpnCVTRUchMzzw7Xo2yT
         Ptgvu8M9ggiIrQxIj0YN1Ib41f8ecSR1jVuwpKgxjeYQNYMlVh8sJdXchjg7FzJT7vJU
         JoGppDPKwnGof6z//2ZfQrqskmlWowJz8RF4g2qGFLh0sWQTayftCdFZpwhOsaJ5gJHz
         dabQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wQjl0kJnU3lo76Yukf2Ffa+rtE8inF/IXMwsHXjE8jc=;
        b=lqQNYRIx+xHTayAGjPxh6oVo+EdQigdFa/78C7JzFJudyHUCA8ETRyzgeBo8jfrydr
         2tJWXc9E3dathzkqGvo9s5YZn0aDJQTefs2jFbPtnAbdk7eMNgvbWoUvreSUdA0a9FmD
         S+jtYY7+qbrKNUU/JiHhu3AKIOS1IFObcHybp0LdTylRrnpCOG8A8FwpndwFpQkwLBqg
         gzpYPhL0Ex/tNxNRkYZ+zHHCOLzyQ0TkvilGBFt2b7Ifl299+CNBEPyUwd/BhUooh1+Q
         BTA7SnbEEUWMXekcOODKVhffQaUJ2mbX4tdtiEqycP8Fk5gYlds74/0XbOU/kHwtb7nZ
         DdAw==
X-Gm-Message-State: ANhLgQ1wjrFvcTamx54/AoULBYcqcHOj43XEAgnO2EQIkq1LLZj8d4IA
        sHKDSCNv/ObH+8x5DKwdgNZmwHo+YOY=
X-Google-Smtp-Source: ADFU+vvomDx9pcRGKhvd4eZpjwg9pC8gC73af2Mqsca5igI3r4hpMwtwk/3vtz7WY1mZ6Tw7VeGrkA==
X-Received: by 2002:ac8:acb:: with SMTP id g11mr17887643qti.132.1583824867588;
        Tue, 10 Mar 2020 00:21:07 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w132sm1228106qkb.96.2020.03.10.00.21.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 00:21:07 -0700 (PDT)
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
Subject: [PATCH net] ipv6/addrconf: call ipv6_mc_up() for non-Ethernet interface
Date:   Tue, 10 Mar 2020 15:20:44 +0800
Message-Id: <20200310072044.24313-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
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

Reported-by: Rafał Miłecki <zajec5@gmail.com>
Fixes: 74235a25c673 ("[IPV6] addrconf: Fix IPv6 on tuntap tunnels")
Fixes: 1666d49e1d41 ("mld: do not remove mld souce list info when set link down")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/ipv6/addrconf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index e6e1290ea06f..56cdd3fda366 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3347,6 +3347,9 @@ static void addrconf_dev_config(struct net_device *dev)
 	    (dev->type != ARPHRD_NONE) &&
 	    (dev->type != ARPHRD_RAWIP)) {
 		/* Alas, we support only Ethernet autoconfiguration. */
+		idev = __in6_dev_get(dev);
+		if (!IS_ERR_OR_NULL(idev) && dev->flags & IFF_UP)
+			ipv6_mc_up(idev);
 		return;
 	}
 
-- 
2.19.2


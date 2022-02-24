Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 320084C27DE
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 10:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232705AbiBXJPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 04:15:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232704AbiBXJPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 04:15:49 -0500
X-Greylist: delayed 508 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 24 Feb 2022 01:15:19 PST
Received: from mail.avm.de (mail.avm.de [IPv6:2001:bf0:244:244::94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDAC223BF17;
        Thu, 24 Feb 2022 01:15:19 -0800 (PST)
Received: from mail-notes.avm.de (mail-notes.avm.de [172.16.0.1])
        by mail.avm.de (Postfix) with ESMTP;
        Thu, 24 Feb 2022 10:06:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
        t=1645693610; bh=zOitn8r3Zy50HUJEKlb+OOGXVNbcWgsJdUJYtMJP3Rk=;
        h=In-Reply-To:References:Subject:From:To:Date:From;
        b=EFW8EQ1GmnTAGbouXKP9xookZUHWkDYvBo7hXqb93juxFsILPBjVqyRtCZ5WbKVbU
         rda5ZZLehsbJcvvk0KtQQ8cf30KhNYjAknPYIFY3zHhi0okdTGpy5onSyOgpFu6o/t
         4tSoqNAli5wE9cvIymW87mC5h48qObeQe87WZX/s=
MIME-Version: 1.0
X-Disclaimed: 1
Sensitivity: 
Importance: Normal
X-Priority: 3 (Normal)
In-Reply-To: 
References: 
Subject: [PATCH] net: ipv6: ensure we call ipv6_mc_down() at most once 
From:   j.nixdorf@avm.de
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 24 Feb 2022 10:06:49 +0100
Message-ID: <OF120FC6BB.53B5B31C-ONC12587F3.002A9E5A-C12587F3.0032105C@avm.de>
X-Mailer: Lotus Domino Web Server Release 12.0.1HF14   December 15, 2021
X-MIMETrack: Serialize by http on ANIS1/AVM(Release 12.0.1HF14 | December 15, 2021) at
 24.02.2022 10:06:49,
        Serialize complete at 24.02.2022 10:06:49,
        Serialize by Router on ANIS1/AVM(Release 12.0.1HF14 | December 15, 2021) at
 24.02.2022 10:06:49
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-purgate-ID: 149429::1645693610-00001F4B-77E04A23/0/0
X-purgate-type: clean
X-purgate-size: 3385
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate: clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two reasons for addrconf=5Fnotify() to be called with NETDEV=5FDO=
WN:
either the network device is actually going down, or IPv6 was disabled
on the interface.

If either of them stays down while the other is toggled, we repeatedly
call the code for NETDEV=5FDOWN, including ipv6=5Fmc=5Fdown(), while never
calling the corresponding ipv6=5Fmc=5Fup() in between. This will cause a
new entry in idev->mc=5Ftomb to be allocated for each multicast group
the interface is subscribed to, which in turn leaks one struct ifmcaddr6
per nontrivial multicast group the interface is subscribed to.

The following reproducer will leak at least $n objects:

ip addr add ff2e::4242/32 dev eth0 autojoin
sysctl -w net.ipv6.conf.eth0.disable=5Fipv6=3D1
for i in $(seq 1 $n); do
	ip link set up eth0; ip link set down eth0
done

Joining groups with IPV6=5FADD=5FMEMBERSHIP (unprivileged) or setting the
sysctl net.ipv6.conf.eth0.forwarding to 1 (=3D> subscribing to ff02::2)
can also be used to create a nontrivial idev->mc=5Flist, which will the
leak objects with the right up-down-sequence.

Based on both sources for NETDEV=5FDOWN events the interface IPv6 state
should be considered:

 - not ready if the network interface is not ready OR IPv6 is disabled
   for it
 - ready if the network interface is ready AND IPv6 is enabled for it

The functions ipv6=5Fmc=5Fup() and ipv6=5Fdown() should only be run when th=
is
state changes.

Implement this by remembering when the IPv6 state is ready, and only
run ipv6=5Fmc=5Fdown() if it actually changed from ready to not ready.

The other direction (not ready -> ready) already works correctly, as:

 - the interface notification triggered codepath for NETDEV=5FUP /
   NETDEV=5FCHANGE returns early if ipv6 is disabled, and
 - the disable=5Fipv6=3D0 triggered codepath skips fully initializing the
   interface as long as addrconf=5Flink=5Fready(dev) returns false
 - calling ipv6=5Fmc=5Fup() repeatedly does not leak anything

Fixes: 3ce62a84d53c ("ipv6: exit early in addrconf=5Fnotify() if IPv6 is di=
sabled")
Signed-off-by: Johannes Nixdorf <j.nixdorf@avm.de>
---
 net/ipv6/addrconf.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index f927c199a93c..c5e9ca244175 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3732,6 +3732,7 @@ static int addrconf=5Fifdown(struct net=5Fdevice *dev=
, bool unregister)
 	struct inet6=5Fdev *idev;
 	struct inet6=5Fifaddr *ifa, *tmp;
 	bool keep=5Faddr =3D false;
+	bool was=5Fready;
 	int state, i;
=20
 	ASSERT=5FRTNL();
@@ -3797,7 +3798,10 @@ static int addrconf=5Fifdown(struct net=5Fdevice *de=
v, bool unregister)
=20
 	addrconf=5Fdel=5Frs=5Ftimer(idev);
=20
-	/* Step 2: clear flags for stateless addrconf */
+	/* Step 2: clear flags for stateless addrconf, repeated down
+	 *         detection
+	 */
+	was=5Fready =3D idev->if=5Fflags & IF=5FREADY;
 	if (!unregister)
 		idev->if=5Fflags &=3D ~(IF=5FRS=5FSENT|IF=5FRA=5FRCVD|IF=5FREADY);
=20
@@ -3871,7 +3875,7 @@ static int addrconf=5Fifdown(struct net=5Fdevice *dev=
, bool unregister)
 	if (unregister) {
 		ipv6=5Fac=5Fdestroy=5Fdev(idev);
 		ipv6=5Fmc=5Fdestroy=5Fdev(idev);
-	} else {
+	} else if (was=5Fready) {
 		ipv6=5Fmc=5Fdown(idev);
 	}
=20
--=20
2.35.1

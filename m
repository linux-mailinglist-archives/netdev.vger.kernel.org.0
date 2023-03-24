Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27CB66C7C0F
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 10:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbjCXJ5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 05:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbjCXJ5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 05:57:39 -0400
Received: from a.mx.secunet.com (unknown [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A88AD38
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 02:57:38 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 28D8920581;
        Fri, 24 Mar 2023 10:57:36 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 4FpOZMfSz3ix; Fri, 24 Mar 2023 10:57:35 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8BD312055E;
        Fri, 24 Mar 2023 10:57:35 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id 85D6480004A;
        Fri, 24 Mar 2023 10:57:35 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 24 Mar 2023 10:57:35 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17; Fri, 24 Mar
 2023 10:57:35 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id BFA723182C77; Fri, 24 Mar 2023 10:57:34 +0100 (CET)
Date:   Fri, 24 Mar 2023 10:57:34 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Hyunwoo Kim <v4bel@theori.io>
CC:     Eric Dumazet <edumazet@google.com>,
        Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Dmitry Kozlov <xeb@mail.ru>,
        David Ahern <dsahern@kernel.org>, <tudordana@google.com>,
        <netdev@vger.kernel.org>, <imv4bel@gmail.com>
Subject: Re: [PATCH] net: Fix invalid ip_route_output_ports() call
Message-ID: <ZB10DlJoNmGhRINM@gauss3.secunet.de>
References: <20230321024946.GA21870@ubuntu>
 <CANn89i+=-BTZyhg9f=Vyz0rws1Z-1O-F5TkESBjkZnKmHeKz1g@mail.gmail.com>
 <20230321050803.GA22060@ubuntu>
 <ZBmMUjSXPzFBWeTv@gauss3.secunet.de>
 <20230321111430.GA22737@ubuntu>
 <CANn89iJVU1yfCfyyUpmMeZA7BEYLfVXYsK80H26WM=hB-1B27Q@mail.gmail.com>
 <20230321113509.GA23276@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230321113509.GA23276@ubuntu>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=0.4 required=5.0 tests=RDNS_DYNAMIC,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 04:35:09AM -0700, Hyunwoo Kim wrote:
> On Tue, Mar 21, 2023 at 04:19:25AM -0700, Eric Dumazet wrote:
> > On Tue, Mar 21, 2023 at 4:14 AM Hyunwoo Kim <v4bel@theori.io> wrote:
> > >
> > > I'm not sure what 'ip x p' means, as my understanding of XFRM is limited, sorry.
> > 
> > Since your repro does not set up a private netns.
> > 
> > Please install the iproute2 package (if not there already) and run the
> > following command
> > 
> > sudo ip x p
> > 
> > man ip
> > 
> > IP(8)                                      Linux
> >                IP(8)
> > 
> > NAME
> >        ip - show / manipulate routing, network devices, interfaces and tunnels
> > 
> > SYNOPSIS
> 
> This is the result of creating a new netns, running repro, and then running the ip x p command:
> ```
> src 255.1.0.0/0 dst 0.0.0.0/0
> 	dir out priority 0
> 	mark 0/0x6
> 	tmpl src 0.0.0.0 dst 0.0.0.0
> 		proto comp reqid 0 mode beet
> 		level 16
> 	tmpl src fc00:: dst e000:2::
> 		proto ah reqid 0 mode tunnel
> 		level 32
> 	tmpl src ac14:14bb:: dst ac14:14fa::
> 		proto route2 reqid 0 mode transport
> 		level 3
> 	tmpl src :: dst 2001::1
> 		proto ah reqid 0 mode in_trigger
> 	tmpl src ff01::1 dst 7f00:1::
> 		proto comp reqid 0 mode transport
> ```

I plan to fix this with the patch below. With this, the above policy
should be rejected. It still needs a bit of testing to make sure that
I prohibited no valid usecase with it.

---
Subject: [PATCH RFC ipsec] xfrm: Don't allow optional intermediate templates that
 changes the address family

When an optional intermediate template changes the address family,
it is unclear which family the next template should have. This can
lead to misinterpretations of IPv4/IPv6 addresses. So reject
optional intermediate templates on insertion time.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Hyunwoo Kim <v4bel@theori.io>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_user.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 103af2b3e986..df4e840b630e 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1770,6 +1770,7 @@ static void copy_templates(struct xfrm_policy *xp, struct xfrm_user_tmpl *ut,
 static int validate_tmpl(int nr, struct xfrm_user_tmpl *ut, u16 family,
 			 struct netlink_ext_ack *extack)
 {
+	bool opt_family_change;
 	u16 prev_family;
 	int i;
 
@@ -1778,6 +1779,7 @@ static int validate_tmpl(int nr, struct xfrm_user_tmpl *ut, u16 family,
 		return -EINVAL;
 	}
 
+	opt_family_change = false;
 	prev_family = family;
 
 	for (i = 0; i < nr; i++) {
@@ -1791,9 +1793,16 @@ static int validate_tmpl(int nr, struct xfrm_user_tmpl *ut, u16 family,
 		if (!ut[i].family)
 			ut[i].family = family;
 
+		if (opt_family_change) {
+			NL_SET_ERR_MSG(extack, "Optional intermediate templates don't support family changes");
+			return -EINVAL;
+		}
+
 		switch (ut[i].mode) {
 		case XFRM_MODE_TUNNEL:
 		case XFRM_MODE_BEET:
+			if (ut[i].optional && ut[i].family != prev_family)
+				opt_family_change = true;
 			break;
 		default:
 			if (ut[i].family != prev_family) {
-- 
2.34.1


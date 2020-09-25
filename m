Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13E61277E64
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 05:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbgIYDIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 23:08:24 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:52174 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726706AbgIYDIX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 23:08:23 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kLe5W-0002dj-Q6; Fri, 25 Sep 2020 13:07:59 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 25 Sep 2020 13:07:59 +1000
Date:   Fri, 25 Sep 2020 13:07:59 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     syzbot <syzbot+577fbac3145a6eb2e7a5@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, steffen.klassert@secunet.com,
        syzkaller-bugs@googlegroups.com, James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        linux-security-module@vger.kernel.org
Subject: Re: KASAN: stack-out-of-bounds Read in xfrm_selector_match (2)
Message-ID: <20200925030759.GA17939@gondor.apana.org.au>
References: <0000000000009fc91605afd40d89@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000009fc91605afd40d89@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 07:56:20AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    eb5f95f1 Merge tag 's390-5.9-6' of git://git.kernel.org/pu..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=13996ad5900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=ffe85b197a57c180
> dashboard link: https://syzkaller.appspot.com/bug?extid=577fbac3145a6eb2e7a5
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+577fbac3145a6eb2e7a5@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: stack-out-of-bounds in xfrm_flowi_dport include/net/xfrm.h:877 [inline]
> BUG: KASAN: stack-out-of-bounds in __xfrm6_selector_match net/xfrm/xfrm_policy.c:216 [inline]
> BUG: KASAN: stack-out-of-bounds in xfrm_selector_match+0xf36/0xf60 net/xfrm/xfrm_policy.c:229
> Read of size 2 at addr ffffc9001914f55c by task syz-executor.4/15633
> 
> CPU: 0 PID: 15633 Comm: syz-executor.4 Not tainted 5.9.0-rc5-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x198/0x1fd lib/dump_stack.c:118
>  print_address_description.constprop.0.cold+0x5/0x497 mm/kasan/report.c:383
>  __kasan_report mm/kasan/report.c:513 [inline]
>  kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
>  xfrm_flowi_dport include/net/xfrm.h:877 [inline]

This one goes back more than ten years.  This patch should fix
it.

---8<---
The struct flowi must never be interpreted by itself as its size
depends on the address family.  Therefore it must always be grouped
with its original family value.

In this particular instance, the original family value is lost in
the function xfrm_state_find.  Therefore we get a bogus read when
it's coupled with the wrong family which would occur with inter-
family xfrm states.

This patch fixes it by keeping the original family value.

Note that the same bug could potentially occur in LSM through
the xfrm_state_pol_flow_match hook.  I checked the current code
there and it seems to be safe for now as only secid is used which
is part of struct flowi_common.  But that API should be changed
so that so that we don't get new bugs in the future.  We could
do that by replacing fl with just secid or adding a family field.

Reported-by: syzbot+577fbac3145a6eb2e7a5@syzkaller.appspotmail.com
Fixes: 48b8d78315bf ("[XFRM]: State selection update to use inner...")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 69520ad3d83b..9b5f2c2b9770 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1019,7 +1019,8 @@ static void xfrm_state_look_at(struct xfrm_policy *pol, struct xfrm_state *x,
 	 */
 	if (x->km.state == XFRM_STATE_VALID) {
 		if ((x->sel.family &&
-		     !xfrm_selector_match(&x->sel, fl, x->sel.family)) ||
+		     (x->sel.family != family ||
+		      !xfrm_selector_match(&x->sel, fl, family))) ||
 		    !security_xfrm_state_pol_flow_match(x, pol, fl))
 			return;
 
@@ -1032,7 +1033,9 @@ static void xfrm_state_look_at(struct xfrm_policy *pol, struct xfrm_state *x,
 		*acq_in_progress = 1;
 	} else if (x->km.state == XFRM_STATE_ERROR ||
 		   x->km.state == XFRM_STATE_EXPIRED) {
-		if (xfrm_selector_match(&x->sel, fl, x->sel.family) &&
+		if ((!x->sel.family ||
+		     (x->sel.family == family &&
+		      xfrm_selector_match(&x->sel, fl, family))) &&
 		    security_xfrm_state_pol_flow_match(x, pol, fl))
 			*error = -ESRCH;
 	}
@@ -1072,7 +1075,7 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 		    tmpl->mode == x->props.mode &&
 		    tmpl->id.proto == x->id.proto &&
 		    (tmpl->id.spi == x->id.spi || !tmpl->id.spi))
-			xfrm_state_look_at(pol, x, fl, encap_family,
+			xfrm_state_look_at(pol, x, fl, family,
 					   &best, &acquire_in_progress, &error);
 	}
 	if (best || acquire_in_progress)
@@ -1089,7 +1092,7 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 		    tmpl->mode == x->props.mode &&
 		    tmpl->id.proto == x->id.proto &&
 		    (tmpl->id.spi == x->id.spi || !tmpl->id.spi))
-			xfrm_state_look_at(pol, x, fl, encap_family,
+			xfrm_state_look_at(pol, x, fl, family,
 					   &best, &acquire_in_progress, &error);
 	}
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

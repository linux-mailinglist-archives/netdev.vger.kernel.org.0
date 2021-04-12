Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4078A35BD5B
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 10:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238049AbhDLIvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 04:51:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238733AbhDLIuj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 04:50:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BE5761243;
        Mon, 12 Apr 2021 08:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217421;
        bh=ACtMWK41v8hxTWK8YferxvR+RzIdpU+E0ffPqlv1ssU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E+vJ6lxO2FENHlmOQ3kDbCzmD72UG7W35g4AngXBF+D2yqT5xb2eHAGezVg5rYQfX
         LCNe1G6FteYJS/OoErL+qLgxYMfeOTjSDSdD3grPlaz44ocvOxyLYcM8M8hubNCv96
         OQNVhrH2KhIN7Xm92owRpZqBHu3baERI5pVIe4uE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+834ffd1afc7212eb8147@syzkaller.appspotmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        netdev@vger.kernel.org, Dmitry Safonov <dima@arista.com>
Subject: [PATCH 5.10 001/188] xfrm/compat: Cleanup WARN()s that can be user-triggered
Date:   Mon, 12 Apr 2021 10:38:35 +0200
Message-Id: <20210412084013.693509554@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Safonov <dima@arista.com>

commit ef19e111337f6c3dca7019a8bad5fbc6fb18d635 upstream.

Replace WARN_ONCE() that can be triggered from userspace with
pr_warn_once(). Those still give user a hint what's the issue.

I've left WARN()s that are not possible to trigger with current
code-base and that would mean that the code has issues:
- relying on current compat_msg_min[type] <= xfrm_msg_min[type]
- expected 4-byte padding size difference between
  compat_msg_min[type] and xfrm_msg_min[type]
- compat_policy[type].len <= xfrma_policy[type].len
(for every type)

Reported-by: syzbot+834ffd1afc7212eb8147@syzkaller.appspotmail.com
Fixes: 5f3eea6b7e8f ("xfrm/compat: Attach xfrm dumps to 64=>32 bit translator")
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: netdev@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_compat.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/net/xfrm/xfrm_compat.c
+++ b/net/xfrm/xfrm_compat.c
@@ -216,7 +216,7 @@ static struct nlmsghdr *xfrm_nlmsg_put_c
 	case XFRM_MSG_GETSADINFO:
 	case XFRM_MSG_GETSPDINFO:
 	default:
-		WARN_ONCE(1, "unsupported nlmsg_type %d", nlh_src->nlmsg_type);
+		pr_warn_once("unsupported nlmsg_type %d\n", nlh_src->nlmsg_type);
 		return ERR_PTR(-EOPNOTSUPP);
 	}
 
@@ -277,7 +277,7 @@ static int xfrm_xlate64_attr(struct sk_b
 		return xfrm_nla_cpy(dst, src, nla_len(src));
 	default:
 		BUILD_BUG_ON(XFRMA_MAX != XFRMA_IF_ID);
-		WARN_ONCE(1, "unsupported nla_type %d", src->nla_type);
+		pr_warn_once("unsupported nla_type %d\n", src->nla_type);
 		return -EOPNOTSUPP;
 	}
 }
@@ -315,8 +315,10 @@ static int xfrm_alloc_compat(struct sk_b
 	struct sk_buff *new = NULL;
 	int err;
 
-	if (WARN_ON_ONCE(type >= ARRAY_SIZE(xfrm_msg_min)))
+	if (type >= ARRAY_SIZE(xfrm_msg_min)) {
+		pr_warn_once("unsupported nlmsg_type %d\n", nlh_src->nlmsg_type);
 		return -EOPNOTSUPP;
+	}
 
 	if (skb_shinfo(skb)->frag_list == NULL) {
 		new = alloc_skb(skb->len + skb_tailroom(skb), GFP_ATOMIC);
@@ -378,6 +380,10 @@ static int xfrm_attr_cpy32(void *dst, si
 	struct nlmsghdr *nlmsg = dst;
 	struct nlattr *nla;
 
+	/* xfrm_user_rcv_msg_compat() relies on fact that 32-bit messages
+	 * have the same len or shorted than 64-bit ones.
+	 * 32-bit translation that is bigger than 64-bit original is unexpected.
+	 */
 	if (WARN_ON_ONCE(copy_len > payload))
 		copy_len = payload;
 



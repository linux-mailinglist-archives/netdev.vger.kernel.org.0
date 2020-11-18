Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85832B8205
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 17:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgKRQhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 11:37:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32412 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726644AbgKRQhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 11:37:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605717450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ztnJJHYZImRgMl6CCHOU5sg0a/4NjPVLA/Is2Wx7Dq8=;
        b=N/Qv7gllLp/yQTS2gsVoOvaMPC0RB2onsvm3EShWz1i2XrXqsgtSsho+vdxt081xoKjn7A
        JHWi1/BNzNfXnak1m735vpshQ4fL3eumxupPZEtWD0xjuj/+dlj8PKJ3s+i1rSvU3bpH1B
        hvrueIHDRbiS/kot4gSBFxEbC7C2Tew=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-puSDo0WXPwi2LnBDdvPxww-1; Wed, 18 Nov 2020 11:37:26 -0500
X-MC-Unique: puSDo0WXPwi2LnBDdvPxww-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C00AF10509F6;
        Wed, 18 Nov 2020 16:37:19 +0000 (UTC)
Received: from new-host-6.redhat.com (unknown [10.40.195.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 10E7D1F0;
        Wed, 18 Nov 2020 16:37:17 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Cc:     gnault@redhat.com, marcelo.leitner@gmail.com
Subject: [PATCH net] net/sched: act_mpls: ensure LSE is pullable before reading it
Date:   Wed, 18 Nov 2020 17:36:52 +0100
Message-Id: <e14a44135817430fc69b3c624895f8584a560975.1605716949.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

when 'act_mpls' is used to mangle the LSE, the current value is read from
the packet with mpls_hdr(): ensure that the label is contained in the skb
"linear" area.

Found by code inspection.

Fixes: 2a2ea50870ba ("net: sched: add mpls manipulation actions to TC")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/sched/act_mpls.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index 5c7456e5b5cf..03138ad59e9b 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -105,6 +105,9 @@ static int tcf_mpls_act(struct sk_buff *skb, const struct tc_action *a,
 			goto drop;
 		break;
 	case TCA_MPLS_ACT_MODIFY:
+		if (!pskb_may_pull(skb,
+				   skb_network_offset(skb) + sizeof(new_lse)))
+			goto drop;
 		new_lse = tcf_mpls_get_lse(mpls_hdr(skb), p, false);
 		if (skb_mpls_update_lse(skb, new_lse))
 			goto drop;
-- 
2.28.0


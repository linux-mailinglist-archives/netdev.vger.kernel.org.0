Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 009F02CD2B7
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 10:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388625AbgLCJjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 04:39:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39681 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388476AbgLCJjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 04:39:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606988289;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/3jh12a+xSRpARJC/nS5WOWCLl4y1O6aSkghqwaUJ/Y=;
        b=INyf4K6r1YMyWDOIGY7xCC1EfcZyTIysxHCwwO4uTO6GSh6dmkVPZ47ASJE3eC9VQHZ932
        cw6fFS8OP3tD7z7eCu6tc2YpNOBQknAfGsEOhtmMmDbqIKXTTFE2vXfcDQE3bRgd60O7LX
        niuuipERelf5Bb2iHpV6yf0u/WwF2xU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489-GZ-d5bBQP-CBFbvbmIAD7w-1; Thu, 03 Dec 2020 04:38:05 -0500
X-MC-Unique: GZ-d5bBQP-CBFbvbmIAD7w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B77C1185E497;
        Thu,  3 Dec 2020 09:38:03 +0000 (UTC)
Received: from new-host-6.station (unknown [10.40.192.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5CDD960854;
        Thu,  3 Dec 2020 09:38:01 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     jhs@mojatatu.com, jiri@resnulli.us,
        Cong Wang <xiyou.wangcong@gmail.com>, kuba@kernel.org,
        netdev@vger.kernel.org
Cc:     gnault@redhat.com, marcelo.leitner@gmail.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net v2] net/sched: act_mpls: ensure LSE is pullable before reading it
Date:   Thu,  3 Dec 2020 10:37:52 +0100
Message-Id: <3243506cba43d14858f3bd21ee0994160e44d64a.1606987058.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

when 'act_mpls' is used to mangle the LSE, the current value is read from
the packet dereferencing 4 bytes at mpls_hdr(): ensure that the label is
contained in the skb "linear" area.

Found by code inspection.

v2:
 - use MPLS_HLEN instead of sizeof(new_lse), thanks to Jakub Kicinski

Fixes: 2a2ea50870ba ("net: sched: add mpls manipulation actions to TC")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/sched/act_mpls.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index 5c7456e5b5cf..d1486ea496a2 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -105,6 +105,9 @@ static int tcf_mpls_act(struct sk_buff *skb, const struct tc_action *a,
 			goto drop;
 		break;
 	case TCA_MPLS_ACT_MODIFY:
+		if (!pskb_may_pull(skb,
+				   skb_network_offset(skb) + MPLS_HLEN))
+			goto drop;
 		new_lse = tcf_mpls_get_lse(mpls_hdr(skb), p, false);
 		if (skb_mpls_update_lse(skb, new_lse))
 			goto drop;
-- 
2.28.0


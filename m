Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22E34DD9BB
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 18:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbfJSQxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 12:53:37 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26173 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725948AbfJSQxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 12:53:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571504015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=rfJHWuXblUX0c6WKxwMfFI5Y5eK7BA3obk5TbX8ggGI=;
        b=QeoTKv2SUGo6lpOGwkk5MqXB8GmVbicedmiiUEGGpxQ1WGWLrMI+XkHSUEe+grKXG7yFWo
        sGxMitj/mIkOKH+Ol65dsGvFhiPMv8P1HxQQclgXtd8wv4uzIipeedMuj2rpNSuLjQcTjt
        lmGUsz5gMoha039RBiI1lCoAZLBU7CM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-YpeAtT7yP9-LVf1JhkBK3A-1; Sat, 19 Oct 2019 12:53:31 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B0581800DD0;
        Sat, 19 Oct 2019 16:53:31 +0000 (UTC)
Received: from new-host.redhat.com (ovpn-204-59.brq.redhat.com [10.40.204.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D09765D9CC;
        Sat, 19 Oct 2019 16:53:29 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next] net/sched: act_police: re-use tcf_tm_dump()
Date:   Sat, 19 Oct 2019 18:49:32 +0200
Message-Id: <8f87292222c28f9b497bbd1f192045b57b38ce72.1571503698.git.dcaratti@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: YpeAtT7yP9-LVf1JhkBK3A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use tcf_tm_dump(), instead of an open coded variant (no functional change
in this patch).

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/sched/act_police.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 89c04c52af3d..981a9eca0c52 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -345,10 +345,7 @@ static int tcf_police_dump(struct sk_buff *skb, struct=
 tc_action *a,
 =09    nla_put_u32(skb, TCA_POLICE_AVRATE, p->tcfp_ewma_rate))
 =09=09goto nla_put_failure;
=20
-=09t.install =3D jiffies_to_clock_t(jiffies - police->tcf_tm.install);
-=09t.lastuse =3D jiffies_to_clock_t(jiffies - police->tcf_tm.lastuse);
-=09t.firstuse =3D jiffies_to_clock_t(jiffies - police->tcf_tm.firstuse);
-=09t.expires =3D jiffies_to_clock_t(police->tcf_tm.expires);
+=09tcf_tm_dump(&t, &police->tcf_tm);
 =09if (nla_put_64bit(skb, TCA_POLICE_TM, sizeof(t), &t, TCA_POLICE_PAD))
 =09=09goto nla_put_failure;
 =09spin_unlock_bh(&police->tcf_lock);
--=20
2.21.0


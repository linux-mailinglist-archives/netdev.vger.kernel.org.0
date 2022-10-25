Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8225660CA53
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 12:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232437AbiJYKuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 06:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232454AbiJYKu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 06:50:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2CA9255B7
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 03:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666695026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cRgh4VHZmDgEae/Ku6y8nsOB6SGNPgo//uwmO2M4VHY=;
        b=K/0T0RmY0dSLNqJaEItU+RCxnKhcAZ3CPmNgyJV4mCV60YbUFGcQm/3VqCP+lulxyqXQGS
        z7ng+ZnFKSAGuJ3BXvLcyFlnvtGccNJdBgSUulrOATzjQZAx6BfmRLaJ+fpPZkQh0KacIR
        mewuT46WxFwyhDixf656y9yf2S+tgwA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-575-6-2gyU3eN22IxDHXjM6UZw-1; Tue, 25 Oct 2022 06:50:21 -0400
X-MC-Unique: 6-2gyU3eN22IxDHXjM6UZw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C1649185A78B;
        Tue, 25 Oct 2022 10:50:20 +0000 (UTC)
Received: from RHTPC1VM0NT.redhat.com (unknown [10.22.8.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 404572028E98;
        Tue, 25 Oct 2022 10:50:20 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Pravin B Shelar <pshelar@ovn.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>,
        Kevin Sprague <ksprague0711@gmail.com>, dev@openvswitch.org,
        Eelco Chaudron <echaudro@redhat.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH v2 net 1/2] openvswitch: switch from WARN to pr_warn
Date:   Tue, 25 Oct 2022 06:50:17 -0400
Message-Id: <20221025105018.466157-2-aconole@redhat.com>
In-Reply-To: <20221025105018.466157-1-aconole@redhat.com>
References: <20221025105018.466157-1-aconole@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As noted by Paolo Abeni, pr_warn doesn't generate any splat and can still
preserve the warning to the user that feature downgrade occurred.  We
likely cannot introduce other kinds of checks / enforcement here because
syzbot can generate different genl versions to the datapath.

Reported-by: syzbot+31cde0bef4bbf8ba2d86@syzkaller.appspotmail.com
Fixes: 44da5ae5fbea ("openvswitch: Drop user features if old user space attempted to create datapath")
Cc: Thomas Graf <tgraf@suug.ch>
Signed-off-by: Aaron Conole <aconole@redhat.com>
---
 net/openvswitch/datapath.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index c8a9075ddd0a..155263e73512 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1616,7 +1616,8 @@ static void ovs_dp_reset_user_features(struct sk_buff *skb,
 	if (IS_ERR(dp))
 		return;
 
-	WARN(dp->user_features, "Dropping previously announced user features\n");
+	pr_warn("%s: Dropping previously announced user features\n",
+		ovs_dp_name(dp));
 	dp->user_features = 0;
 }
 
-- 
2.34.3


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB4E4B7367
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 17:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240543AbiBOPfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 10:35:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240637AbiBOPfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 10:35:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D06AC0876;
        Tue, 15 Feb 2022 07:30:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F421B81AF7;
        Tue, 15 Feb 2022 15:30:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89116C340F2;
        Tue, 15 Feb 2022 15:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644939046;
        bh=0x6i4OlwnfiUrwgKFWTgJ7ebyVDAj1Ju/6rNnIfShrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ucgiqVi8oo2o+ra/wz0brBenEiKiqpXKtyI/FZTN64W1BTc/y2YIu9KioNDIFC3P5
         AAKg8Ml06BO0T6AlV/iIfYrinn4DKIPtVWCCdcnr7CGqYDzNUuKZv/2t0e1I3H1Zwv
         PZNxFuZNEol0RKGJ57DMBx0HOwzw9UkJYZpV/VuFIMKZCL1IEK6d4SNB7KgAl1PxPz
         98wAmPZ03P6GzCI22FBBm2OFXkdqP7B/CLa6HyRLFI3vGOPCp4Gp7RgKfLJqSrgdGE
         MXKlOxxnF8i3I4kL5Ku239UJl3QYkIeWUAeSou2xvwawOTz8J5APGN7rqCeRkc3/BF
         Q7/8wmXqvJc7A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Vivek Thrivikraman <vivek.thrivikraman@est.tech>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>, kadlec@netfilter.org,
        davem@davemloft.net, kuba@kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 05/17] netfilter: conntrack: don't refresh sctp entries in closed state
Date:   Tue, 15 Feb 2022 10:30:25 -0500
Message-Id: <20220215153037.581579-5-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215153037.581579-1-sashal@kernel.org>
References: <20220215153037.581579-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 77b337196a9d87f3d6bb9b07c0436ecafbffda1e ]

Vivek Thrivikraman reported:
 An SCTP server application which is accessed continuously by client
 application.
 When the session disconnects the client retries to establish a connection.
 After restart of SCTP server application the session is not established
 because of stale conntrack entry with connection state CLOSED as below.

 (removing this entry manually established new connection):

 sctp 9 CLOSED src=10.141.189.233 [..]  [ASSURED]

Just skip timeout update of closed entries, we don't want them to
stay around forever.

Reported-and-tested-by: Vivek Thrivikraman <vivek.thrivikraman@est.tech>
Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1579
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_proto_sctp.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 810cca24b3990..7626f3e1c70a7 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -489,6 +489,15 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
 			pr_debug("Setting vtag %x for dir %d\n",
 				 ih->init_tag, !dir);
 			ct->proto.sctp.vtag[!dir] = ih->init_tag;
+
+			/* don't renew timeout on init retransmit so
+			 * port reuse by client or NAT middlebox cannot
+			 * keep entry alive indefinitely (incl. nat info).
+			 */
+			if (new_state == SCTP_CONNTRACK_CLOSED &&
+			    old_state == SCTP_CONNTRACK_CLOSED &&
+			    nf_ct_is_confirmed(ct))
+				ignore = true;
 		}
 
 		ct->proto.sctp.state = new_state;
-- 
2.34.1


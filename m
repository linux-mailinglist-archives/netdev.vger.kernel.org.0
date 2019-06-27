Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 772E0584D1
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 16:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbfF0Osq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 10:48:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47630 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726445AbfF0Osq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 10:48:46 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E12F43092657;
        Thu, 27 Jun 2019 14:48:45 +0000 (UTC)
Received: from renaissance-vector.mxp.redhat.com (unknown [10.32.181.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0A3FC1001B19;
        Thu, 27 Jun 2019 14:48:44 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org
Subject: [PATCH iproute2] tc: netem: fix r parameter in Bernoulli loss model
Date:   Thu, 27 Jun 2019 16:47:45 +0200
Message-Id: <4b95a8c3d9a210c712f4366ea2d2f056cb302005.1561646575.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Thu, 27 Jun 2019 14:48:45 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the man page for tc netem states:

    To use the Bernoulli model, the only needed parameter is p while the
    others will be set to the default values r=1-p, 1-h=1 and 1-k=0.

However r parameter is erroneusly set to 1, and not to 1-p.
Fix this using the same approach of the 4-state loss model.

Fixes: 3c7950af598be ("netem: add support for 4 state and GE loss model")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 tc/q_netem.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tc/q_netem.c b/tc/q_netem.c
index 6e0e8a8cbfde5..d1cd17f8a8a7e 100644
--- a/tc/q_netem.c
+++ b/tc/q_netem.c
@@ -284,14 +284,17 @@ static int netem_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 				}
 
 			} else if (!strcmp(*argv, "gemodel")) {
+				double p;
+
 				NEXT_ARG();
-				if (get_percent(&gemodel.p, *argv)) {
+				if (parse_percent(&p, *argv)) {
 					explain1("loss gemodel p");
 					return -1;
 				}
+				set_percent(&gemodel.p, p);
 
 				/* set defaults */
-				set_percent(&gemodel.r, 1.);
+				set_percent(&gemodel.r, 1. - p);
 				set_percent(&gemodel.h, 0);
 				set_percent(&gemodel.k1, 0);
 				loss_type = NETEM_LOSS_GE;
-- 
2.20.1


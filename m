Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F4147CD3CB
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 19:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbfJFRTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 13:19:15 -0400
Received: from smtprelay0194.hostedemail.com ([216.40.44.194]:56694 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726508AbfJFRTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 13:19:15 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 41882180A68B1;
        Sun,  6 Oct 2019 17:19:13 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:152:355:379:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2376:2393:2553:2559:2562:2903:3138:3139:3140:3141:3142:3352:3865:3867:3868:3871:3872:4321:5007:8603:10004:10400:10848:11026:11473:11657:11658:11914:12043:12262:12297:12438:12555:12679:12740:12895:12986:13069:13311:13357:13894:14096:14097:14181:14659:14721:21080:21365:21433:21451:21627:30054:30055:30064:30091,0,RBL:error,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:260,LUA_SUMMARY:none
X-HE-Tag: road46_333b5ec2ba205
X-Filterd-Recvd-Size: 2145
Received: from XPS-9350.home (unknown [47.151.152.152])
        (Authenticated sender: joe@perches.com)
        by omf20.hostedemail.com (Postfix) with ESMTPA;
        Sun,  6 Oct 2019 17:19:11 +0000 (UTC)
Message-ID: <edf91d8284a2a19d956eb8b7e8b6c4984ceaa1ab.camel@perches.com>
Subject: i40e_pto.c: Odd use of strlcpy converted from strncpy
From:   Joe Perches <joe@perches.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev <netdev@vger.kernel.org>
Cc:     Mitch Williams <mitch.a.williams@intel.com>,
        Patryk =?UTF-8?Q?Ma=C5=82ek?= <patryk.malek@intel.com>
Date:   Sun, 06 Oct 2019 10:19:10 -0700
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This got converted from strncpy to strlcpy but it's
now not necessary to use one character less than the
actual size.

Perhaps the sizeof() - 1 is now not correct and it
should use strscpy and a normal sizeof.

from:

commit 7eb74ff891b4e94b8bac48f648a21e4b94ddee64
Author: Mitch Williams <mitch.a.williams@intel.com>
Date:   Mon Aug 20 08:12:30 2018 -0700

    i40e: use correct length for strncpy

and

commit 4ff2d8540321324e04c1306f85d4fe68a0c2d0ae
Author: Patryk Małek <patryk.malek@intel.com>
Date:   Tue Oct 30 10:50:44 2018 -0700

    i40e: Replace strncpy with strlcpy to ensure null termination
---
 drivers/net/ethernet/intel/i40e/i40e_ptp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ptp.c b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
index 9bf1ad4319f5..627b1c02bb4b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ptp.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
@@ -700,8 +700,8 @@ static long i40e_ptp_create_clock(struct i40e_pf *pf)
 	if (!IS_ERR_OR_NULL(pf->ptp_clock))
 		return 0;
 
-	strlcpy(pf->ptp_caps.name, i40e_driver_name,
-		sizeof(pf->ptp_caps.name) - 1);
+	strscpy(pf->ptp_caps.name, i40e_driver_name, sizeof(pf->ptp_caps.name));
+
 	pf->ptp_caps.owner = THIS_MODULE;
 	pf->ptp_caps.max_adj = 999999999;
 	pf->ptp_caps.n_ext_ts = 0;



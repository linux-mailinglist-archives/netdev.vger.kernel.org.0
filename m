Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABCB248E65
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 21:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgHRTDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 15:03:09 -0400
Received: from smtprelay0203.hostedemail.com ([216.40.44.203]:52818 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726435AbgHRTDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 15:03:08 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 68C8C100E7B45;
        Tue, 18 Aug 2020 19:03:05 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:69:355:379:599:800:960:965:966:968:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3150:3354:3622:3865:3866:3867:3868:3870:3873:3874:4321:4385:4390:4395:5007:9592:10004:10400:10848:10967:11026:11232:11473:11657:11658:11914:12043:12296:12297:12438:12555:12740:12760:12895:12986:13095:13439:13972:14096:14097:14181:14659:14721:21080:21324:21433:21627:21939:21990:30045:30054:30070:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:26,LUA_SUMMARY:none
X-HE-Tag: ghost36_3e055b927021
X-Filterd-Recvd-Size: 3429
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf07.hostedemail.com (Postfix) with ESMTPA;
        Tue, 18 Aug 2020 19:03:03 +0000 (UTC)
Message-ID: <ac461ce3173457270815aba33b4be36dee760c54.camel@perches.com>
Subject: Re: [PATCH] qed_main: Remove unnecessary cast in kfree
From:   Joe Perches <joe@perches.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Xu Wang <vulab@iscas.ac.cn>
Cc:     aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 18 Aug 2020 12:03:02 -0700
In-Reply-To: <20200818114403.00001257@intel.com>
References: <20200818091056.12309-1-vulab@iscas.ac.cn>
         <20200818114403.00001257@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-08-18 at 11:44 -0700, Jesse Brandeburg wrote:
> On Tue, 18 Aug 2020 09:10:56 +0000
> Xu Wang <vulab@iscas.ac.cn> wrote:
> 
> > Remove unnecassary casts in the argument to kfree.
> > 
> > Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
> 
> You seem to have several of these patches, they should be sent in a
> series with the series patch subject (for example):
> [PATCH net-next 0/n] fix up casts on kfree
> 
> Did you use a coccinelle script to find these? 
> 
> They could all have Fixes tags. I'd resend the whole bunch as a series.
> 
> Since this has no functional change, you could mention that in the
> series commit message text.

Commits with no functional change generally should
not be marked with Fixes:

And some wrapper functions might as well be removed
and just kfree used in-place instead.

Something like:
---
 drivers/net/ethernet/qlogic/qed/qed_main.c | 29 ++++++-----------------------
 1 file changed, 6 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 2558cb680db3..961adb4d8910 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -482,24 +482,6 @@ int qed_fill_dev_info(struct qed_dev *cdev,
 	return 0;
 }
 
-static void qed_free_cdev(struct qed_dev *cdev)
-{
-	kfree((void *)cdev);
-}
-
-static struct qed_dev *qed_alloc_cdev(struct pci_dev *pdev)
-{
-	struct qed_dev *cdev;
-
-	cdev = kzalloc(sizeof(*cdev), GFP_KERNEL);
-	if (!cdev)
-		return cdev;
-
-	qed_init_struct(cdev);
-
-	return cdev;
-}
-
 /* Sets the requested power state */
 static int qed_set_power_state(struct qed_dev *cdev, pci_power_t state)
 {
@@ -618,9 +600,11 @@ static struct qed_dev *qed_probe(struct pci_dev *pdev,
 	struct qed_dev *cdev;
 	int rc;
 
-	cdev = qed_alloc_cdev(pdev);
+	cdev = kzalloc(sizeof(*cdev), GFP_KERNEL);
 	if (!cdev)
-		goto err0;
+		return NULL;
+
+	qed_init_struct(cdev);
 
 	cdev->drv_type = DRV_ID_DRV_TYPE_LINUX;
 	cdev->protocol = params->protocol;
@@ -658,8 +642,7 @@ static struct qed_dev *qed_probe(struct pci_dev *pdev,
 err2:
 	qed_free_pci(cdev);
 err1:
-	qed_free_cdev(cdev);
-err0:
+	kfree(cdev);
 	return NULL;
 }
 
@@ -676,7 +659,7 @@ static void qed_remove(struct qed_dev *cdev)
 
 	qed_devlink_unregister(cdev);
 
-	qed_free_cdev(cdev);
+	kfree(cdev);
 }
 
 static void qed_disable_msix(struct qed_dev *cdev)



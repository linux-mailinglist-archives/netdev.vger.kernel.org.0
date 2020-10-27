Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A52B829BE8B
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 17:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1813549AbgJ0Quy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 12:50:54 -0400
Received: from smtprelay0035.hostedemail.com ([216.40.44.35]:33548 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1813523AbgJ0Quu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 12:50:50 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 86139180A7FE0;
        Tue, 27 Oct 2020 16:50:43 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:69:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3870:3872:3874:4321:4605:5007:6742:6743:7576:7903:8603:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12297:12438:12555:12740:12760:12895:12986:13069:13311:13357:13439:14096:14097:14181:14659:14721:21080:21451:21627:21990:30012:30054:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:30,LUA_SUMMARY:none
X-HE-Tag: bag02_2a11e012727d
X-Filterd-Recvd-Size: 4083
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf19.hostedemail.com (Postfix) with ESMTPA;
        Tue, 27 Oct 2020 16:50:38 +0000 (UTC)
Message-ID: <685d850347a1191bba8ba7766fc409b140d18f03.camel@perches.com>
Subject: Re: [PATCH 3/8] vhost: vringh: use krealloc_array()
From:   Joe Perches <joe@perches.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        James Morse <james.morse@arm.com>,
        Robert Richter <rric@kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-gpio@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-mm@kvack.org, alsa-devel@alsa-project.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date:   Tue, 27 Oct 2020 09:50:36 -0700
In-Reply-To: <20201027112607-mutt-send-email-mst@kernel.org>
References: <20201027121725.24660-1-brgl@bgdev.pl>
         <20201027121725.24660-4-brgl@bgdev.pl>
         <20201027112607-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-10-27 at 11:28 -0400, Michael S. Tsirkin wrote:
> On Tue, Oct 27, 2020 at 01:17:20PM +0100, Bartosz Golaszewski wrote:
> > From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> > 
> > Use the helper that checks for overflows internally instead of manually
> > calculating the size of the new array.
> > 
> > Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> No problem with the patch, it does introduce some symmetry in the code.

Perhaps more symmetry by using kmemdup
---
 drivers/vhost/vringh.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 8bd8b403f087..99222a3651cd 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -191,26 +191,23 @@ static int move_to_indirect(const struct vringh *vrh,
 static int resize_iovec(struct vringh_kiov *iov, gfp_t gfp)
 {
 	struct kvec *new;
-	unsigned int flag, new_num = (iov->max_num & ~VRINGH_IOV_ALLOCATED) * 2;
+	size_t new_num = (iov->max_num & ~VRINGH_IOV_ALLOCATED) * 2;
+	size_t size;
 
 	if (new_num < 8)
 		new_num = 8;
 
-	flag = (iov->max_num & VRINGH_IOV_ALLOCATED);
-	if (flag)
-		new = krealloc(iov->iov, new_num * sizeof(struct iovec), gfp);
-	else {
-		new = kmalloc_array(new_num, sizeof(struct iovec), gfp);
-		if (new) {
-			memcpy(new, iov->iov,
-			       iov->max_num * sizeof(struct iovec));
-			flag = VRINGH_IOV_ALLOCATED;
-		}
-	}
+	if (unlikely(check_mul_overflow(new_num, sizeof(struct iovec), &size)))
+		return -ENOMEM;
+
+	if (iov->max_num & VRINGH_IOV_ALLOCATED)
+		new = krealloc(iov->iov, size, gfp);
+	else
+		new = kmemdup(iov->iov, size, gfp);
 	if (!new)
 		return -ENOMEM;
 	iov->iov = new;
-	iov->max_num = (new_num | flag);
+	iov->max_num = new_num | VRINGH_IOV_ALLOCATED;
 	return 0;
 }
 
 


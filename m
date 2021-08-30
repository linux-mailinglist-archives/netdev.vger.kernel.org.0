Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD4EF3FB3F3
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 12:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236350AbhH3KgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 06:36:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38504 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236288AbhH3Kf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 06:35:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630319705;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=GIkKLT9+2FHaydFlEbveuHna07dWpxXq1F41ZndkPZ0=;
        b=WDHnIpdCbTBVM9+0TaradOl7c3ZfsX8aunMAgUL0PANnydtntK6nQlNzUKSjStFmYT5n1q
        TabLc3S22oe5V+iN3f9hzX2HpUWjVufsYUdlCEfWwqmQWy+LY4c0HwP+rt3RazJnUPEJU0
        jYVt2aKrdYfmQT3ZaeLYPpv2DjTPYec=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-v2jjWfTLO7mTZDGxF1YkhA-1; Mon, 30 Aug 2021 06:35:01 -0400
X-MC-Unique: v2jjWfTLO7mTZDGxF1YkhA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8EA84871807;
        Mon, 30 Aug 2021 10:35:00 +0000 (UTC)
Received: from griffin.upir.cz (unknown [10.40.194.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B24D0188E4;
        Mon, 30 Aug 2021 10:34:59 +0000 (UTC)
From:   Jiri Benc <jbenc@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH net] i40e: fix endless loop under rtnl
Date:   Mon, 30 Aug 2021 12:34:46 +0200
Message-Id: <4d94f7fbd9dd6476c5adc8967f3db84bc9204f47.1630319620.git.jbenc@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The loop in i40e_get_capabilities can never end. The problem is that
although i40e_aq_discover_capabilities returns with an error if there's
a firmware problem, the returned error is not checked. There is a check for
pf->hw.aq.asq_last_status but that value is set to I40E_AQ_RC_OK on most
firmware problems.

When i40e_aq_discover_capabilities encounters a firmware problem, it will
enocunter the same problem on its next invocation. As the result, the loop
becomes endless. We hit this with I40E_ERR_ADMIN_QUEUE_TIMEOUT but looking
at the code, it can happen with a range of other firmware errors.

I don't know what the correct behavior should be: whether the firmware
should be retried a few times, or whether pf->hw.aq.asq_last_status should
be always set to the encountered firmware error (but then it would be
pointless and can be just replaced by the i40e_aq_discover_capabilities
return value). However, the current behavior with an endless loop under the
rtnl mutex(!) is unacceptable and Intel has not submitted a fix, although we
explained the bug to them 7 months ago.

This may not be the best possible fix but it's better than hanging the whole
system on a firmware bug.

Tested-by: Stefan Assmann <sassmann@redhat.com>
Signed-off-by: Jiri Benc <jbenc@redhat.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 1d1f52756a93..772dd05a0ae8 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -10110,7 +10110,7 @@ static int i40e_get_capabilities(struct i40e_pf *pf,
 		if (pf->hw.aq.asq_last_status == I40E_AQ_RC_ENOMEM) {
 			/* retry with a larger buffer */
 			buf_len = data_size;
-		} else if (pf->hw.aq.asq_last_status != I40E_AQ_RC_OK) {
+		} else if (pf->hw.aq.asq_last_status != I40E_AQ_RC_OK || err) {
 			dev_info(&pf->pdev->dev,
 				 "capability discovery failed, err %s aq_err %s\n",
 				 i40e_stat_str(&pf->hw, err),
-- 
2.18.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD683B3B2D
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 05:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233054AbhFYD1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 23:27:30 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:34292 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232973AbhFYD13 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 23:27:29 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1624591509; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=1OKKAMM0YbUVRu/d0x/9APRTo8SYNuVejwQx1EDQ0qY=; b=toTuJevzmcQlQsPtndVC+jDbB53yxaHI34cD2SzkAClci+FAIRkYWbXgVpGrwug4Ja1T4onQ
 vfMZENxrMyILLc1VMJ+s/+mml+ix9kKXXS9j7m/ciIzwe0M+nzRa9zRs74vuCm5OnqZUMZ5C
 2pGSP7i6NuPi9MzHhL+/2VJtEYM=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 60d54c944ca9face34423a03 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 25 Jun 2021 03:25:08
 GMT
Sender: neeraju=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C3469C43460; Fri, 25 Jun 2021 03:25:07 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from localhost (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: neeraju)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2E19FC433F1;
        Fri, 25 Jun 2021 03:25:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2E19FC433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=neeraju@codeaurora.org
From:   Neeraj Upadhyay <neeraju@codeaurora.org>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgarzare@redhat.com,
        Neeraj Upadhyay <neeraju@codeaurora.org>
Subject: [PATCH v2] vringh: Use wiov->used to check for read/write desc order
Date:   Fri, 25 Jun 2021 08:55:02 +0530
Message-Id: <1624591502-4827-1-git-send-email-neeraju@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As __vringh_iov() traverses a descriptor chain, it populates
each descriptor entry into either read or write vring iov
and increments that iov's ->used member. So, as we iterate
over a descriptor chain, at any point, (riov/wriov)->used
value gives the number of descriptor enteries available,
which are to be read or written by the device. As all read
iovs must precede the write iovs, wiov->used should be zero
when we are traversing a read descriptor. Current code checks
for wiov->i, to figure out whether any previous entry in the
current descriptor chain was a write descriptor. However,
iov->i is only incremented, when these vring iovs are consumed,
at a later point, and remain 0 in __vringh_iov(). So, correct
the check for read and write descriptor order, to use
wiov->used.

Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Neeraj Upadhyay <neeraju@codeaurora.org>
---
Changes in v2:
 Commit message updated to clarify why wiov->i cannot be used.

 drivers/vhost/vringh.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 4af8fa2..14e2043 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -359,7 +359,7 @@ __vringh_iov(struct vringh *vrh, u16 i,
 			iov = wiov;
 		else {
 			iov = riov;
-			if (unlikely(wiov && wiov->i)) {
+			if (unlikely(wiov && wiov->used)) {
 				vringh_bad("Readable desc %p after writable",
 					   &descs[i]);
 				err = -EINVAL;
-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, 
hosted by The Linux Foundation


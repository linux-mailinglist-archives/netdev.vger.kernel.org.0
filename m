Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BAAA1D2C4E
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 12:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgENKPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 06:15:46 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:20454 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725974AbgENKPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 06:15:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589451344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=+KIaE7ARBsCzF+D+Y+4GJpIzb5KDD/6yGLZ7ng/uwes=;
        b=iwzhMx4SYNWYx2JEVaN3PpbKNWq4EhhhYOiqUEjJHbt/yOXcbGpCornYp8oAHZZgroQwLf
        PFkyj1teycfNQO5/6SGaDL8mc2Eb/En1M1Wsfn6lfUP+62sUvzJCLqZKmqTfIYFrYYIgTv
        ggMWm3iYOGS3MpgWM4q+Gd88JahC498=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-96-o7Ax251cNlq2RA2no_dT1Q-1; Thu, 14 May 2020 06:15:42 -0400
X-MC-Unique: o7Ax251cNlq2RA2no_dT1Q-1
Received: by mail-wm1-f71.google.com with SMTP id k17so3924063wmi.4
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 03:15:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=+KIaE7ARBsCzF+D+Y+4GJpIzb5KDD/6yGLZ7ng/uwes=;
        b=Nt9ma5XtFBzrFpFz3Log63cUE6ru15faOpbSu8AV8s6YpazR+7iPqPBcrRxcfWBAhh
         cl8FT9Yi+DbAVBYH8j3QPgB7t4oCjy/vHwluY2UgKvXeQ9Yxnhj/Ooxy1/TGLwS+NBEv
         4Pq3DJzQ6/SqPqywCz2a3EIkUh8Jl23IUDlnuTZlV8YQRbz7JGe0TlPniP51KAhHcPVX
         xroaTyhDBTSRynYxFv8tCvRVw/j0nLxSCoQfun1ZLWwyQX/vgMMIPMq+Yao/EI4h5+5R
         FCoiFludrOmtVjjXRDobG7wg1BgJxVZfaQafbCg29gtNWPsDM1wbeUAgvUN7vbPr31TK
         lUBw==
X-Gm-Message-State: AOAM530PS9CTsXfvrBg/GmIl72QUZhtvVvJVcsM5mhpltrcRjR4KEq5X
        47BiNxJTkgTzy5NPM3yK6NeYLcUtwsmiqUMccjxWsjAef7oCLO1OnHFaSeEarwQDIvfQSWmn89A
        tLmMuJy+jfsD6BiIW
X-Received: by 2002:a5d:4102:: with SMTP id l2mr4486585wrp.51.1589451341496;
        Thu, 14 May 2020 03:15:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx8DRYFKPhMC7pOj2fNsvPjhYO/tsIxJqxtwRCnmmrdKtGKfo4uvUGZJyi/ARo9q267NGwFpg==
X-Received: by 2002:a5d:4102:: with SMTP id l2mr4486569wrp.51.1589451341318;
        Thu, 14 May 2020 03:15:41 -0700 (PDT)
Received: from pc-3.home (2a01cb0585138800b113760e11343d15.ipv6.abo.wanadoo.fr. [2a01:cb05:8513:8800:b113:760e:1134:3d15])
        by smtp.gmail.com with ESMTPSA id c17sm3301020wrn.59.2020.05.14.03.15.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 03:15:40 -0700 (PDT)
Date:   Thu, 14 May 2020 12:15:39 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        David =?utf-8?Q?Bala=C5=BEic?= <xerces9@gmail.com>
Subject: [PATCH net] pppoe: only process PADT targeted at local interfaces
Message-ID: <87314848e98d74e88b3c3b2504566a7691f5a8e9.1589451271.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't want to disconnect a session because of a stray PADT arriving
while the interface is in promiscuous mode.
Furthermore, multicast and broadcast packets make no sense here, so
only PACKET_HOST is accepted.

Reported-by: David Balažic <xerces9@gmail.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 drivers/net/ppp/pppoe.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index d760a36db28c..beedaad08255 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -490,6 +490,9 @@ static int pppoe_disc_rcv(struct sk_buff *skb, struct net_device *dev,
 	if (!skb)
 		goto out;
 
+	if (skb->pkt_type != PACKET_HOST)
+		goto abort;
+
 	if (!pskb_may_pull(skb, sizeof(struct pppoe_hdr)))
 		goto abort;
 
-- 
2.21.1


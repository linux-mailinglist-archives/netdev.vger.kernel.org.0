Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7EACD55FB
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 13:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729370AbfJMLm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 07:42:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34148 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729367AbfJMLm1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Oct 2019 07:42:27 -0400
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6E1D989AC4
        for <netdev@vger.kernel.org>; Sun, 13 Oct 2019 11:42:27 +0000 (UTC)
Received: by mail-qt1-f200.google.com with SMTP id r19so14845218qtk.15
        for <netdev@vger.kernel.org>; Sun, 13 Oct 2019 04:42:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LyPdJiu+Pv3Ms2s+9K7y5cFNFk6/oEkuyO+dRyVq8dg=;
        b=ceKpKOCNqAfgx0Wb6WxFU9aWA1DwYMSbZ9D7CVnYojDN9XlgOB0u0F7ZvqZakffDi7
         P8THGmtZV3hAJZliVQbStA/si/UuSOiqw5mMpt8LiE7W7Gz0QtghsDxAE0TP5FtTTHSu
         C8NNXzZpppbJvPGAhOSwgKbXWGRxvGpXa9ZqjfrjbP6tIQIyupDYtvHAyxfcSjFTMHHA
         p7dFmHWXwLQ4vyqcPatozkQ06uQMWteoO4j2u+QMaS7d1ya249GUBYl95fd5a2HzOnWI
         fHFVIvd/PXWviQiDvm6pDdugYNPLrvphUYMowM7LEoNRltzt8E0XtQgyU1xggR6Sni7n
         vjrA==
X-Gm-Message-State: APjAAAXyvTY/zJwTIJiGK8Lb3RIVveQfAyDuUhmtaanpbay9IBdjq6pW
        adM+hynrt/gz/5jfi7dNvqSH1B/gSjFcbeo+79Z+MoVFoe6AjZH0kBYn5c8S+WR1kHwO5sxDSmb
        Ou34/pAt+RPAsnt+o
X-Received: by 2002:a0c:c792:: with SMTP id k18mr25297613qvj.154.1570966946778;
        Sun, 13 Oct 2019 04:42:26 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyhx3XLFozvF0Fexkmjc2uJBOUXPVXIPjvAKX3RiiVhxNpPC56P8T4wN2MQG4g59b9OLo3Gdg==
X-Received: by 2002:a0c:c792:: with SMTP id k18mr25297597qvj.154.1570966946584;
        Sun, 13 Oct 2019 04:42:26 -0700 (PDT)
Received: from redhat.com (bzq-79-176-10-77.red.bezeqint.net. [79.176.10.77])
        by smtp.gmail.com with ESMTPSA id z5sm7213125qtb.49.2019.10.13.04.42.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2019 04:42:25 -0700 (PDT)
Date:   Sun, 13 Oct 2019 07:42:22 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>
Subject: [PATCH RFC v4 5/5] vhost: last descriptor must have NEXT clear
Message-ID: <20191013113940.2863-6-mst@redhat.com>
References: <20191013113940.2863-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191013113940.2863-1-mst@redhat.com>
X-Mailer: git-send-email 2.22.0.678.g13338e74b8
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fetch_buf already guarantees we exit on a descriptor without a NEXT
flag.  Add a BUG_ON statement to make sure we don't overflow the buffer
in case of a bug.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vhost.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index d46c28149f6f..09f594bb069a 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2656,6 +2656,8 @@ int vhost_get_vq_desc_batch(struct vhost_virtqueue *vq,
 			break;
 	}
 
+	BUG_ON(i >= vq->ndescs);
+
 	vq->first_desc = i + 1;
 
 	return ret;
-- 
MST


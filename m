Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0CB0AFFA5
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 17:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728543AbfIKPJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 11:09:36 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:42308 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728381AbfIKPJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 11:09:36 -0400
Received: by mail-io1-f65.google.com with SMTP id n197so46611408iod.9;
        Wed, 11 Sep 2019 08:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zpSTnZWLfU+mtdlAh42xs+GSxup7aA/377MpA3ZModA=;
        b=VuKDYc2rxs+4jUZdpQuHBjBqjoG+/X87aXFRR84EAstHq2b/sHIjhulnX8LfXX0Z5v
         J6TQg8wudBS4xNr73cEkMUG8ZFNK+vMMVQhkBlN6VMEkCPew+eviVICq9ijf6jxzHmHN
         Pf2EjKsicklY9we2tu1vWq+xXE9AltcEKK3POWlkJsOZUXLWPXMIWZ+mWKdlOX2f9mDX
         qSJi/OC1wFLCsVgyKETD+aILLb3YaR6u1HL9vfN6+yBm87CLyE0CiWI6MZItdXiGZaSg
         lV+1g29SOCWtBfrkRC3uwca2wdcti0rZUro55vCHYyW63y5DHNZuCpBc3UjdPtPJn7w+
         nLdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zpSTnZWLfU+mtdlAh42xs+GSxup7aA/377MpA3ZModA=;
        b=CPY2Qw2GleOc+tyeQcDB5JKddrf/cRvM8cuJ++rfAFYnl9N2hKM2YIhERJHLyBIbWw
         2rJ0aZhrWnpyvrsr9LJT9dVlYqUC/+GYDBMlZ9Uk+7P1hrz/QNnOQekXN3IX4/aMWl52
         +fc1NJrWqEx2HZNqLqfGrX3M8T+5ME26p43kqt0DOjDLzEwH4afm2SJkN4jsRqpdPEtV
         L1opu0Lj8DJnrAonntEO/AUyfjta4FeCzarP3o4z+XlbT5jx7eDjy0ZGIxkGGJT1YyuH
         atlipRAdOIbo7Hdpw6oWojiR46/M4wHZH/aMzRJILBUftvbYNqab0RSvgHhmROiu4EB7
         tMzg==
X-Gm-Message-State: APjAAAVDeNA++dBDtiE+R5xioSxbbbkfb5Wc2PQxl6DcEe7ZGS+epmdm
        ql+S/dGcpDXbqO0T9gBKWORZsuLkhyM=
X-Google-Smtp-Source: APXvYqweuexRIh7nhhjMSs2ZGpMcndP/A8OxHHeXjgoKEcTuRqDBStiAqy7TcKpsUYCqtH+xbhjnkQ==
X-Received: by 2002:a6b:c810:: with SMTP id y16mr43703681iof.75.1568214575179;
        Wed, 11 Sep 2019 08:09:35 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id c4sm16670135ioa.76.2019.09.11.08.09.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2019 08:09:34 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
To:     davem@davemloft.net
Cc:     emamd001@umn.edu, smccaman@umn.edu, kjlu@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: qrtr: fix memort leak in qrtr_tun_write_iter
Date:   Wed, 11 Sep 2019 10:09:02 -0500
Message-Id: <20190911150907.18251-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190911.101320.682967997452798874.davem@davemloft.net>
References: <20190911.101320.682967997452798874.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In qrtr_tun_write_iter the allocated kbuf should be release in case of
error or success return.

v2 Update: Thanks to David Miller for pointing out the release on success
path as well.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 net/qrtr/tun.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/qrtr/tun.c b/net/qrtr/tun.c
index ccff1e544c21..e35869e81766 100644
--- a/net/qrtr/tun.c
+++ b/net/qrtr/tun.c
@@ -84,11 +84,14 @@ static ssize_t qrtr_tun_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (!kbuf)
 		return -ENOMEM;
 
-	if (!copy_from_iter_full(kbuf, len, from))
+	if (!copy_from_iter_full(kbuf, len, from)) {
+		kfree(kbuf);
 		return -EFAULT;
+	}
 
 	ret = qrtr_endpoint_post(&tun->ep, kbuf, len);
 
+	kfree(kbuf);
 	return ret < 0 ? ret : len;
 }
 
-- 
2.17.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8AE719C3AE
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 16:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388371AbgDBONB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 10:13:01 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:47689 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388239AbgDBONA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 10:13:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585836779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=Lsas7jxJ1WMu8rRlGVbgJ8eIsxujsCQQeq8BgBAYBkI=;
        b=TWz9U+cRrADAROTxO/jIEurRypEO+HCiCxkVY4DLlFxx4Sqg8t5w+nNEcS+3GCoOJ1r9cm
        2SGneoW8OYJ3+ylNg8oHock4GKw86cAiseShJ4RA/0HVRiEUo/PEjcLJ3tOoYFwvNgQzgt
        iPC1PNTNWIxktqguNnNKgrMNkYJ6DQs=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-NwhnvBIbNwCcJwvdrBmiXw-1; Thu, 02 Apr 2020 10:12:55 -0400
X-MC-Unique: NwhnvBIbNwCcJwvdrBmiXw-1
Received: by mail-qk1-f198.google.com with SMTP id h186so3103266qkc.22
        for <netdev@vger.kernel.org>; Thu, 02 Apr 2020 07:12:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=Lsas7jxJ1WMu8rRlGVbgJ8eIsxujsCQQeq8BgBAYBkI=;
        b=YdqpEjKrdg4hFitS3LZeEA+7QQp1nSgq1OTdsZvHZheJweOHw2DRRm8/DmtnjaW7Ty
         ZYEfD6wA8+wSPKHtNrtYqZN5ePS33MKIVm1CbVXb1m+Uxvq572hHwCzAITMpBLKprGNE
         u4c6t/VpvANLrSTJ7tXYsAz1eOsiZdJRazJv13oAF0fwrzhuhAqMsl3NkVM31AOjJuJp
         Qm8zsvuVB/381j7q4XspEPb475Ujs28zW4ViiFPMYwTvvLigrw2EQ2fYvvyoKCvrHd+m
         WLu+6qw4dOlEDdtSyxyqwIhT+DO/W+LnLGygndrbhEEJdjhzTrzHFVFp9DgF9wEyQY2z
         jPTA==
X-Gm-Message-State: AGi0PuZlQ3xu+kZSzJkaZhmCY4Iucay9qJ0FKwsUKQHlIxZ5H17zA8bC
        0wpH+36I/c/A8y5Kyz9rqNUtCA+9S5jiNvgJ0Vc0Iy5Bvfby2e/L0Ns7g6hGZ6DWSLvL7BlDNKC
        5z2RXERZdwR5rJ2z2
X-Received: by 2002:a37:7c81:: with SMTP id x123mr3569405qkc.287.1585836775148;
        Thu, 02 Apr 2020 07:12:55 -0700 (PDT)
X-Google-Smtp-Source: APiQypLfJWfDXTGKKPJbCvXgetpUrdL/5Wc33Wc2j+KEgqsWojCWykGbIs6gJg6z/V4LYFVIdSjzNQ==
X-Received: by 2002:a37:7c81:: with SMTP id x123mr3569380qkc.287.1585836774834;
        Thu, 02 Apr 2020 07:12:54 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id b7sm3553494qkc.61.2020.04.02.07.12.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 07:12:53 -0700 (PDT)
Date:   Thu, 2 Apr 2020 10:12:50 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] vhost: drop vring dependency on iotlb
Message-ID: <20200402141207.32628-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.24.1.751.gd10ce2899c
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vringh can now be built without IOTLB.
Select IOTLB directly where it's used.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

This is on top of my previous patch (in vhost tree now).

 drivers/vdpa/Kconfig  | 1 +
 drivers/vhost/Kconfig | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vdpa/Kconfig b/drivers/vdpa/Kconfig
index 7db1460104b7..08b615f2da39 100644
--- a/drivers/vdpa/Kconfig
+++ b/drivers/vdpa/Kconfig
@@ -17,6 +17,7 @@ config VDPA_SIM
 	depends on RUNTIME_TESTING_MENU
 	select VDPA
 	select VHOST_RING
+	select VHOST_IOTLB
 	default n
 	help
 	  vDPA networking device simulator which loop TX traffic back
diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index 21feea0d69c9..bdd270fede26 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -6,7 +6,6 @@ config VHOST_IOTLB
 
 config VHOST_RING
 	tristate
-	select VHOST_IOTLB
 	help
 	  This option is selected by any driver which needs to access
 	  the host side of a virtio ring.
-- 
MST


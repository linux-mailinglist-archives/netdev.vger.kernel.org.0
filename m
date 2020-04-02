Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD8A819C4A3
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 16:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388713AbgDBOqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 10:46:42 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:34884 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388573AbgDBOqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 10:46:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585838801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=247fWnWaIxGLXiVh3d5vG20xrpndo7qpcBC/YB6ZW/8=;
        b=hNLZRZMoh/KlmXmn2eLYhAFPwdJQeUBxRGJkoJjt7RBW4GrkcQL2foIwL5Nyynufi2Fhec
        YYkkQBW/6+NXlIfKjX88YH+ql3/c7vFcV/pvUoU1jCyGp/cq8pR8lvTkbovw7b0l3PAUzs
        g26rDWpDJENlqcECLXaEUJzx6hQ51sM=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-JtHcet1GN_CbMhiopqnhVg-1; Thu, 02 Apr 2020 10:46:40 -0400
X-MC-Unique: JtHcet1GN_CbMhiopqnhVg-1
Received: by mail-qv1-f72.google.com with SMTP id a12so2871144qvv.8
        for <netdev@vger.kernel.org>; Thu, 02 Apr 2020 07:46:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=247fWnWaIxGLXiVh3d5vG20xrpndo7qpcBC/YB6ZW/8=;
        b=YrA7wV/LFveLhmnaHgBbLWBcJ7e90UyNfhOOaejeq4oeIhZZ+2KwJ5KctsQ04vD1+S
         /Z77j3j2us+g3I1hdisW1O9aMiat/hFn/XTsaYLzEQL6q4asTYGEyhiIg42dbfAhk3/X
         JFuRdFovAuYjZNX/kr0F8n0TSX07LiviV5Jh9xb9z9GgVEuaGvN2BE6RsqQD07XLIWGL
         /1y2FdeaSGq99MaACxwMOXJ9xmTB7UsD38E7HMHHD7sFGfuYuMVuSxIF1u2xZTnQ3NHr
         4s00wM9UonrviQoOpSM1DG6EPult+kL0VgVKVHwFJ1hOnB9T0/Spy1RkLtmZqpgHmr/P
         uiSA==
X-Gm-Message-State: AGi0PuaN07VwFl7tKgvhVKitswTaVVN7g1XmqrYbicN+RreYGVRB6Xxv
        RWaWiC+BogyPz//Oe1BXVAUKcSvKhVjSSA++RhhjPNEmeC1EpxrIGRA8H+Fm0COpMvxIQ2pAPom
        Cnvda3vfDK3/CM4YH
X-Received: by 2002:ae9:dd83:: with SMTP id r125mr3878506qkf.105.1585838799303;
        Thu, 02 Apr 2020 07:46:39 -0700 (PDT)
X-Google-Smtp-Source: APiQypJrCvrYOfccOPc0wjpUe4Jhvl0Nl/n0u9FB6DDdrO18srx7Gu82PDrBByu2qXM5kAyNldGtag==
X-Received: by 2002:ae9:dd83:: with SMTP id r125mr3878453qkf.105.1585838798775;
        Thu, 02 Apr 2020 07:46:38 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id p9sm3672571qtu.3.2020.04.02.07.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 07:46:37 -0700 (PDT)
Date:   Thu, 2 Apr 2020 10:46:33 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2] vhost: drop vring dependency on iotlb
Message-ID: <20200402144519.34194-1-mst@redhat.com>
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

Applies on top of my vhost tree.
Changes from v1:
	VDPA_SIM needs VHOST_IOTLB

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
index f0404ce255d1..cb6b17323eb2 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -8,7 +8,6 @@ config VHOST_IOTLB
 
 config VHOST_RING
 	tristate
-	select VHOST_IOTLB
 	help
 	  This option is selected by any driver which needs to access
 	  the host side of a virtio ring.
-- 
MST


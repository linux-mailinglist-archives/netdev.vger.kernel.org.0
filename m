Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2997519DAED
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 18:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404158AbgDCQKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 12:10:37 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44166 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404038AbgDCQKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 12:10:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585930235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LeoeQF7GvDwmPkvw2R/S0QmAmK/0A59bm6nJYVibxX4=;
        b=YaQS3HoCjO2iL1lU7Qq7OhPLDUUaBwoAwkNybr+IuwdEnH2wxZNEVb1/kw38svlLXP3CjD
        lh4pzbjGOQhMzZIO+CRTHgERlZ+BjDfax2n30Egkg5rjb4prKerS3q8Sd8jA/jj+pJreJe
        820xIVsp2x9aCs78l030SstRy9sb8jU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-JlMNveACNmeo4QYlTg13sQ-1; Fri, 03 Apr 2020 12:10:34 -0400
X-MC-Unique: JlMNveACNmeo4QYlTg13sQ-1
Received: by mail-wr1-f69.google.com with SMTP id u16so3324390wrp.14
        for <netdev@vger.kernel.org>; Fri, 03 Apr 2020 09:10:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LeoeQF7GvDwmPkvw2R/S0QmAmK/0A59bm6nJYVibxX4=;
        b=CfbCaEl5GLYIaWPxPSIqO4NwvTHw03l/PJNFw/M51yTF/AUsVdG4UeVij/Ydd94fze
         DHJO6MTKoWJGS3spL83k2ZZUUIP9PSV1LIE4iSHOLXgv9ohM8UIvcsZGUD0xucAhXfS2
         dOV3pXYF8vvK02ApAj59ssjmbWULwCCkKg7OMiNUPUVSR7CSAm6VL/+wSqzIDok7MjmT
         58peyAWKLyHLWg7ZpmtcEQNQhn/LY3Lwmolp0GrqqHVgojAIOjGbPiSuNYbSxbsrwJ72
         1OxBcQfexMvtAEpr58ntm2jW6T5zFDjI46D9BobEok6MjoBZIKHl4MS3eSS31fdXJXh5
         N6Sw==
X-Gm-Message-State: AGi0PuYw+KQz8//AAD51IFeVyTRFSUrbiNbz58TQlkO2O/1U4w6qNRN2
        WSd4BOBQeKtfHEt8DYBsJmiD3gnTta1N+FGyAgYYZxXRknGzQO9RTtNDZ/rEyEth6/UANK91FOw
        dQjisEDPgwK0W5xeH
X-Received: by 2002:a5d:4401:: with SMTP id z1mr9663502wrq.259.1585930232865;
        Fri, 03 Apr 2020 09:10:32 -0700 (PDT)
X-Google-Smtp-Source: APiQypJPQpWckOqFouWM2ty3+B/I0oJ8XkRO7qyavBWXix0tAnRF2g6JD6t97ZbwvnEPMH4gZoU5vw==
X-Received: by 2002:a5d:4401:: with SMTP id z1mr9663491wrq.259.1585930232684;
        Fri, 03 Apr 2020 09:10:32 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id b187sm13009825wmc.14.2020.04.03.09.10.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 09:10:32 -0700 (PDT)
Date:   Fri, 3 Apr 2020 12:10:30 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v3 2/2] vhost: drop vring dependency on iotlb
Message-ID: <20200403161011.13046-3-mst@redhat.com>
References: <20200403161011.13046-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200403161011.13046-1-mst@redhat.com>
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


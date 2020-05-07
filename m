Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64F641C8B30
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 14:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbgEGMlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 08:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726445AbgEGMle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 08:41:34 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292C8C05BD09
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 05:41:34 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id z22so4364620lfd.0
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 05:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+6lmmId7XYld8VnWV5cttTOMJJxlKWctzCN//LLTV9M=;
        b=dMYpiKQlD97r6xZsT7aALS8lRXNcJSzcta4ITPEF7uKWmiMSDGLHMnP9gWdPbCN0fg
         o6ytPilk0JpRUielij5nmKouXaFsO+/4j692Quy4cYBHrHqiqWOB1GfmTj02+gKzSJHa
         qElhiGNsrtXaYEI6s0x92HWRGWzPzFbYYHOX1oKnFfIot0Si9BU3xht2Sd9/1owpqoHj
         WiEpHAy4JQGJBLUJEJjr0+TwsJz+iIcCzbiR+MqQ+tuhmofwLFMT8/Cheo/EAEyTtto5
         uh2XXrmTffZO3f6fzsjTjuv1p16BGVaAmtr8/ffPXse3BdmHrXdaTEmzkxegAWKZIjlo
         IEkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+6lmmId7XYld8VnWV5cttTOMJJxlKWctzCN//LLTV9M=;
        b=pO+7acyaHsKEk4wnQNAf8oybFiSx7sBv4UuXHZ4HfcZKRg0toLNjM/iOrCrGSl8+V3
         osHxlpUgKtYc0gnfPQZCMN5BQHYcBulL2r908DjmAt+f7oyXKOmzxm1R5Y7c9a4hGld2
         3PKcYSlEL2knSXLL3PWU24IvekmMip4NtQDDM8ZmpOnoXiwp27kxhR9PsKWgjtlut/jK
         UUS9CuPf+O/sDr91+04bqB/QZXu3imKNbWwW64EAvgkhYtWZa49j80/8K+iXZN/xPZIA
         xVzkuSTB7Xm40beNbgNGT9SPDnWrdafVp4hs9a7fF1kpR/e4nN+Bbg7WM+FTejhcpuKR
         TTnA==
X-Gm-Message-State: AGi0PuY2a4evSABg9dPHkec+kEfx20omj7/jsWf4DFjyGCnopDGmrIU+
        233Z2FfDBeIfrcRMz8bHAlOYNo4DVrDYYw==
X-Google-Smtp-Source: APiQypLjLmhAC2ZTjPDElKJzPY3sqUfUsSUrkbGSE6fJVF23DdKH9Zb9piNrBsGskiUlLmKQVLOc2A==
X-Received: by 2002:a19:c394:: with SMTP id t142mr8935458lff.129.1588855292414;
        Thu, 07 May 2020 05:41:32 -0700 (PDT)
Received: from centos7-pv-guest.localdomain ([5.35.46.227])
        by smtp.gmail.com with ESMTPSA id i76sm3744231lfi.83.2020.05.07.05.41.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 May 2020 05:41:31 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
To:     netdev@vger.kernel.org
Cc:     brouer@redhat.com, jgross@suse.com, wei.liu@kernel.org,
        paul@xen.org, ilias.apalodimas@linaro.org
Subject: [PATCH net-next v8 3/3] net: xen: select PAGE_POOL for xen-netfront
Date:   Thu,  7 May 2020 15:40:41 +0300
Message-Id: <1588855241-29141-3-git-send-email-kda@linux-powerpc.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1588855241-29141-1-git-send-email-kda@linux-powerpc.org>
References: <1588855241-29141-1-git-send-email-kda@linux-powerpc.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xen-netfront uses page pool API so select it in Kconfig

Signed-off-by: Denis Kirjanov <denis.kirjanov@suse.com>
---
 drivers/net/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 25a8f93..45918ce 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -479,6 +479,7 @@ config XEN_NETDEV_FRONTEND
 	tristate "Xen network device frontend driver"
 	depends on XEN
 	select XEN_XENBUS_FRONTEND
+	select PAGE_POOL
 	default y
 	help
 	  This driver provides support for Xen paravirtual network
-- 
1.8.3.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49ED31D5B8E
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 23:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbgEOV3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 17:29:31 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44667 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727942AbgEOV3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 17:29:07 -0400
Received: by mail-pg1-f193.google.com with SMTP id b8so1587153pgi.11;
        Fri, 15 May 2020 14:29:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7iSHfXW9+fvDe3OMezoTpoZ6yc3BiswtzUTGtFdEoqM=;
        b=CWT3RSEsOAt3vxph1Drkp6lLCexue3b3KvLCldOnH8ALvAN+vG7ea8ubR3spND7fNJ
         jrosDF++LVePslD+xaXTT04Dr31BRgvteWo/uCtQqi4oif794PROe+fklD8OUKEqX4pA
         QG4wWoSauN0emeuSxha6yT8ugiYfMnV346cti0anyZR8Z/mDDmIpCO2Thvyp22N+lQeZ
         kTbgXNu6dlOitrhfpKl5z4QKE5wWxYyiNBtWDp59hDGh2rzVZMNfsCSsQxtPbismgFxD
         zuok7sbso5ktvEQvVHjRzuSbyvpON5p/VgfmCj5Zs6lbISK6e1gFECdajf/sQCQVnJek
         6KhQ==
X-Gm-Message-State: AOAM5320EiO4ESDUt3yjDQX383A+SPvM1GZR0amfD/fawwVeiraWdgom
        8naqhOEHuEOtYF2c0FbXQuk=
X-Google-Smtp-Source: ABdhPJy8UUPC9xXHxB4FjCVxUaLsmMMiDQI0BvVJYF+PqZUF0tKyMG2HswF59FK0uEUmrA4F0O6+Ng==
X-Received: by 2002:a62:7d91:: with SMTP id y139mr5770731pfc.172.1589578147283;
        Fri, 15 May 2020 14:29:07 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id 25sm2281115pjk.50.2020.05.15.14.28.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 14:29:04 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 6016742380; Fri, 15 May 2020 21:28:50 +0000 (UTC)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     jeyu@kernel.org
Cc:     akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com, tiwai@suse.de,
        schlad@suse.de, andriy.shevchenko@linux.intel.com,
        keescook@chromium.org, daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Subject: [PATCH v2 14/15] brcm80211: use new module_firmware_crashed()
Date:   Fri, 15 May 2020 21:28:45 +0000
Message-Id: <20200515212846.1347-15-mcgrof@kernel.org>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20200515212846.1347-1-mcgrof@kernel.org>
References: <20200515212846.1347-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This makes use of the new module_firmware_crashed() to help
annotate when firmware for device drivers crash. When firmware
crashes devices can sometimes become unresponsive, and recovery
sometimes requires a driver unload / reload and in the worst cases
a reboot.

Using a taint flag allows us to annotate when this happens clearly.

Cc: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list.pdl@broadcom.com
Cc: brcm80211-dev-list@cypress.com
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>
Cc: Hante Meuleman <hante.meuleman@broadcom.com>
Cc: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Cc: Wright Feng <wright.feng@cypress.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "Rafał Miłecki" <rafal@milecki.pl>
Cc: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index c88655acc78c..d623f83568b3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -1393,6 +1393,7 @@ void brcmf_fw_crashed(struct device *dev)
 	struct brcmf_pub *drvr = bus_if->drvr;
 
 	bphy_err(drvr, "Firmware has halted or crashed\n");
+	module_firmware_crashed();
 
 	brcmf_dev_coredump(dev);
 
-- 
2.26.2


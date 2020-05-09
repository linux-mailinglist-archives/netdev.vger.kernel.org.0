Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 304F41CBD80
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 06:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728955AbgEIEhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 00:37:03 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46055 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728697AbgEIEgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 00:36:11 -0400
Received: by mail-pl1-f193.google.com with SMTP id u22so1621274plq.12;
        Fri, 08 May 2020 21:36:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0bWWkdX4avF5y+Fhcxc52f0/U6sSEQKpeXYMzsUl/gM=;
        b=onXWjDsDQ19lnrgOgOm5DLJS6aoEtH60+/dhY2ApBekN6ZRgP0lrtC7tf1Vk2pb7IC
         vrAgN0B5SRejjc5+KS6i7E5J2Jm2MsykaLC3fYFhucReObh3rTlzaGXCwlWxmqXYALxU
         b276kqNUd8mOYW2I+nNl/Cqz5GC3VLreOID8DsnoC47sRA640xonaibDS1GwnvZlNmSt
         w89UOyA71lmgUA6Ht09ywj7BaBhIt9+JpV5qkhSueUjH4LRiXeuqrcnc62fagsOPMoRK
         ipXzVFoofKuwvePeUV+KUaO5XfFNUfSANHaFFBtnRinfwxvcp9pVQKcXD/C/KV2w02EQ
         sSuQ==
X-Gm-Message-State: AGi0PuY4Nndv18yAdAkH2bFHOSNuT4+6C/ZRhiqUrE/RrTCjCOjn8BY+
        RH0AuiuNEianTRjxin3Xi6M=
X-Google-Smtp-Source: APiQypLfcLbjKv3FFJ4oeocXRf/+RZKgJAG79optjMrdsbZJP3A/Peyt4yONdPGEF4hTmXY+eOThTA==
X-Received: by 2002:a17:902:7b86:: with SMTP id w6mr5516716pll.292.1588998970940;
        Fri, 08 May 2020 21:36:10 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id f76sm3229588pfa.167.2020.05.08.21.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 21:36:07 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 063AB41D95; Sat,  9 May 2020 04:36:01 +0000 (UTC)
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
        Rasesh Mody <rmody@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com
Subject: [PATCH 05/15] bna: use new module_firmware_crashed()
Date:   Sat,  9 May 2020 04:35:42 +0000
Message-Id: <20200509043552.8745-6-mcgrof@kernel.org>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20200509043552.8745-1-mcgrof@kernel.org>
References: <20200509043552.8745-1-mcgrof@kernel.org>
MIME-Version: 1.0
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

Cc: Rasesh Mody <rmody@marvell.com>
Cc: Sudarsana Kalluru <skalluru@marvell.com>
Cc: GR-Linux-NIC-Dev@marvell.com
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/net/ethernet/brocade/bna/bfa_ioc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/brocade/bna/bfa_ioc.c b/drivers/net/ethernet/brocade/bna/bfa_ioc.c
index e17bfc87da90..b3f44a912574 100644
--- a/drivers/net/ethernet/brocade/bna/bfa_ioc.c
+++ b/drivers/net/ethernet/brocade/bna/bfa_ioc.c
@@ -927,6 +927,7 @@ bfa_iocpf_sm_disabled(struct bfa_iocpf *iocpf, enum iocpf_event event)
 static void
 bfa_iocpf_sm_initfail_sync_entry(struct bfa_iocpf *iocpf)
 {
+	module_firmware_crashed();
 	bfa_nw_ioc_debug_save_ftrc(iocpf->ioc);
 	bfa_ioc_hw_sem_get(iocpf->ioc);
 }
-- 
2.25.1


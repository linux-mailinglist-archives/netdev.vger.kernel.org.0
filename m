Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECABB107DC0
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 09:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbfKWI0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 03:26:48 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:41048 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbfKWI0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 03:26:47 -0500
Received: by mail-pj1-f68.google.com with SMTP id gc1so4207140pjb.8
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 00:26:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nXjFmpo55xeV43Ih0pLTHAKh7PqBMhqMwCXB1inqVRI=;
        b=E4NuOda+xi6N8fsLNJpCAq+GlIyO4xJRpS5JGYWU/2/GMzsVlSATnrmD0ZKboWwNPY
         W5IPoiI8CWy+owHhnQi/7vQTMNGCRJcLdqIiaALSRL0RdepUlbC1xXZp7gwRFmBFyFKO
         gs31sNSSOpeCnZTtDm2irnCCPYYB1VmVZM56Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nXjFmpo55xeV43Ih0pLTHAKh7PqBMhqMwCXB1inqVRI=;
        b=bBwck3hjZdvIxWbSOlEtLJOrVJWiXU5XD85C9XVgxUBBVYtH1NNYj0nL0TjEKuqmwQ
         M5+FpQ59gHDQK3noTMW/vq5olLcR3ZPsomDrk0Ifcq6f/2xF2VbAOW6Bujm4RCOsZaoz
         KffC5Z4Uq3ww58yk7AUkK6MQqymblaGrkCEsJ0R1YmgBWo1i27onzH13APne4+zWem1C
         EPGDCEd5bT3KhcpaMkO1Sgjlx/WQjPa52UCv5U3obeP4ijGSU422NnBDf4VcoUnLiRj0
         UAYJnbHIkFu64C4EHD9/ePp0/IdayB/cwkKE98W/R0XzidzE5CCWwiq1UvbgE7kIjIJS
         FnYw==
X-Gm-Message-State: APjAAAWNzCWphEh1OU6SJw+bFWp+Hq0VPJmUJeBiv6/mXiJgFjl9RE0P
        cA0Kq/y/pdyw9lsjldULtID8NcFLkfI=
X-Google-Smtp-Source: APXvYqyzyDv+djRIYFSh1B8O17gv21Y1vgYA/Nvijj4ETa//F6vjxSKSJQfkKDbfXqvAM8JU7o5fCg==
X-Received: by 2002:a17:90a:9b84:: with SMTP id g4mr24689972pjp.76.1574497606595;
        Sat, 23 Nov 2019 00:26:46 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p16sm573236pfn.171.2019.11.23.00.26.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Nov 2019 00:26:46 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 11/15] bnxt_en: Add async. event logic for PHY configuration changes.
Date:   Sat, 23 Nov 2019 03:26:06 -0500
Message-Id: <1574497570-22102-12-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574497570-22102-1-git-send-email-michael.chan@broadcom.com>
References: <1574497570-22102-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the link settings have been changed by another function sharing the
port, firmware will send us an async. message.  In response, we will
call the new bnxt_init_ethtool_link_settings() function to update
the current settings.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 10 ++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  1 +
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 1b86ba8..4b0303a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -250,10 +250,12 @@ static const u16 bnxt_vf_req_snif[] = {
 
 static const u16 bnxt_async_events_arr[] = {
 	ASYNC_EVENT_CMPL_EVENT_ID_LINK_STATUS_CHANGE,
+	ASYNC_EVENT_CMPL_EVENT_ID_LINK_SPEED_CHANGE,
 	ASYNC_EVENT_CMPL_EVENT_ID_PF_DRVR_UNLOAD,
 	ASYNC_EVENT_CMPL_EVENT_ID_PORT_CONN_NOT_ALLOWED,
 	ASYNC_EVENT_CMPL_EVENT_ID_VF_CFG_CHANGE,
 	ASYNC_EVENT_CMPL_EVENT_ID_LINK_SPEED_CFG_CHANGE,
+	ASYNC_EVENT_CMPL_EVENT_ID_PORT_PHY_CFG_CHANGE,
 	ASYNC_EVENT_CMPL_EVENT_ID_RESET_NOTIFY,
 	ASYNC_EVENT_CMPL_EVENT_ID_ERROR_RECOVERY,
 };
@@ -1968,6 +1970,10 @@ static int bnxt_async_event_process(struct bnxt *bp,
 		set_bit(BNXT_LINK_SPEED_CHNG_SP_EVENT, &bp->sp_event);
 	}
 	/* fall through */
+	case ASYNC_EVENT_CMPL_EVENT_ID_LINK_SPEED_CHANGE:
+	case ASYNC_EVENT_CMPL_EVENT_ID_PORT_PHY_CFG_CHANGE:
+		set_bit(BNXT_LINK_CFG_CHANGE_SP_EVENT, &bp->sp_event);
+		/* fall through */
 	case ASYNC_EVENT_CMPL_EVENT_ID_LINK_STATUS_CHANGE:
 		set_bit(BNXT_LINK_CHNG_SP_EVENT, &bp->sp_event);
 		break;
@@ -10324,6 +10330,10 @@ static void bnxt_sp_task(struct work_struct *work)
 				       &bp->sp_event))
 			bnxt_hwrm_phy_qcaps(bp);
 
+		if (test_and_clear_bit(BNXT_LINK_CFG_CHANGE_SP_EVENT,
+				       &bp->sp_event))
+			bnxt_init_ethtool_link_settings(bp);
+
 		rc = bnxt_update_link(bp, true);
 		mutex_unlock(&bp->link_lock);
 		if (rc)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 94c8a92..cab1703 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1763,6 +1763,7 @@ struct bnxt {
 #define BNXT_RING_COAL_NOW_SP_EVENT	17
 #define BNXT_FW_RESET_NOTIFY_SP_EVENT	18
 #define BNXT_FW_EXCEPTION_SP_EVENT	19
+#define BNXT_LINK_CFG_CHANGE_SP_EVENT	21
 
 	struct delayed_work	fw_reset_task;
 	int			fw_reset_state;
-- 
2.5.1


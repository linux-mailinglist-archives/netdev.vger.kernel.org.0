Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8493F4FC12F
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 17:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348130AbiDKPoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 11:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348169AbiDKPog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 11:44:36 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004D93B004;
        Mon, 11 Apr 2022 08:42:19 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-df22f50e0cso17673359fac.3;
        Mon, 11 Apr 2022 08:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TxbUHNQvrMBIjTCW3//JKuYPMwW2kqiY97PwifExrW0=;
        b=XlnjY4oJEsmqZB55ghLmlOimOPY0RzYLb/AfQU6nI2vdlmK0pF0sOosXA5xjhY1xje
         DcbHccNQE+JUR1/SHK65Pr9104N6ZeutHWlCIR33lxl5VTRZhwsrR1Zv1MY4tnhZvM3z
         QQKkRGZMeaA20iFJVktLgkSTLRMZmlNG3HobVNASgycrkA0IgK17OZLDMRInivTj85T2
         IAs9JRRJet16/+4vjmQN9sb8H0BJSKCLU9c85YUhbi4KJcieBC7WrJNO+PDxolwiBrdM
         zrUpdvX7r7uUIhpfci5wFFbLklAsC7uUnxbvq82FIH0WsRajKe0xguA7OXJ59PlZy0F4
         RA2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=TxbUHNQvrMBIjTCW3//JKuYPMwW2kqiY97PwifExrW0=;
        b=ypa0TndwiDDhxyZa9Y10ByHStrM7p+ruD9wWU6otFaIiTy7vVwI90SKe4YCt84HyRP
         6CD8E0A/SP7YeEF1LmLqC1rY/8WLgr7PCLaXyltfncephDtwyyuOKWqPifKxL/NbKprO
         9bDsYYvkw15BoeLNypmuUpGrdu+JuH6/GszZegQYHrrV4HXLyp1Gnuphy+GD1kHsCoGv
         8bb8YPfyv4ZheoJ0BWhlb2rj+WrdPj69v0tC938iuq5SWIdIhkypIJUT3Tcle9MwM8+B
         9h6k+rS9e+hPyUEBEo9RlXWor6HpwjMy8fIsAzsFIpaxhlDx14nzBHuynYqrl077cKtV
         IhBw==
X-Gm-Message-State: AOAM5338adRH4VI9sVPU/fZMpfQHM92gWPXt0SgvX9vtQBKqIm6zTvaN
        ajHAvP+o1ja4hns7dd4pTva9sPaJf4g=
X-Google-Smtp-Source: ABdhPJzniQoI+xcfeMw2+smpP0QcrSIfAaa6a3E0tMqs8h5Apl4XV+TulHiqRKW4kTxjB+R0UVH00w==
X-Received: by 2002:a05:6871:79b:b0:d3:4039:7e7c with SMTP id o27-20020a056871079b00b000d340397e7cmr14657208oap.121.1649691738902;
        Mon, 11 Apr 2022 08:42:18 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c9-20020a4a8ec9000000b0032438ba79b0sm11513951ool.0.2022.04.11.08.42.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 08:42:17 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
To:     linux-wireless@vger.kernel.org
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Gregory Greenman <gregory.greenman@intel.com>
Subject: [PATCH] iwlwifi: iwl-dbg: Use del_timer_sync() before freeing
Date:   Mon, 11 Apr 2022 08:42:10 -0700
Message-Id: <20220411154210.1870008-1-linux@roeck-us.net>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In Chrome OS, a large number of crashes is observed due to corrupted timer
lists. Steven Rostedt pointed out that this usually happens when a timer
is freed while still active, and that the problem is often triggered
by code calling del_timer() instead of del_timer_sync() just before
freeing.

Steven also identified the iwlwifi driver as one of the possible culprits
since it does exactly that.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Gregory Greenman <gregory.greenman@intel.com>
Fixes: 60e8abd9d3e91 ("iwlwifi: dbg_ini: add periodic trigger new API support")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v1 (from RFC):
    Removed Shahar S Matityahu from Cc: and added Gregory Greenman.
    No functional change.

I thought about the need to add a mutex to protect the timer list, but
I convinced myself that it is not necessary because the code adding
the timer list and the code removing it should never be never executed
in parallel.

 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
index 866a33f49915..3237d4b528b5 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -371,7 +371,7 @@ void iwl_dbg_tlv_del_timers(struct iwl_trans *trans)
 	struct iwl_dbg_tlv_timer_node *node, *tmp;
 
 	list_for_each_entry_safe(node, tmp, timer_list, list) {
-		del_timer(&node->timer);
+		del_timer_sync(&node->timer);
 		list_del(&node->list);
 		kfree(node);
 	}
-- 
2.35.1


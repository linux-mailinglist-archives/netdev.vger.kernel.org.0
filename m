Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E645A4F6754
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238962AbiDFRbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239013AbiDFRaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:30:52 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA8B12261C3;
        Wed,  6 Apr 2022 08:34:13 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id o20-20020a9d7194000000b005cb20cf4f1bso1946987otj.7;
        Wed, 06 Apr 2022 08:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4hMtYW8ejyVNsXsDDmZKOxRpVqVOrU52f8U8RZOFYlY=;
        b=IqIyktVY311DFjbmDPP4ic4cdzBrnzgjKTZgWfIeLIZFg6FfPEkhHUkT5Zj6rfto7h
         BQRxkRHzAiSulFy2YFec8nAkZWvCllh1zbALLq64sz2/QVt7mTjhJ+JG/ej88C0b11+k
         BwVQEMleReAL3YpOXzHLM8cIRXNyanvfiJhN5lDYqXNshjOwuYDmc9cb2x61KnBTNZty
         ciqLgG4919hNuopRTj2O+QKphznuDKkTQ8QiQGRcSk3iN8XbWaMp6TaI7ChtJ2yA7MmK
         HRU6jCoMhBpU5jM1MZb1uzcuTT/OOwHYHXC1f8Z5nYrg2Te6o27nj9RK55JaRHUpDsvf
         sY4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=4hMtYW8ejyVNsXsDDmZKOxRpVqVOrU52f8U8RZOFYlY=;
        b=KRMO3t+mp52xypTZEIslQuNuHSqS9ESATMiiUSDwF6LlbAEe3JPNjLa3oHAmFW5ecV
         /p/A3V1ch5Nt6Q5E/RwvsdjKl9OD5V1kDIQtLJ+OgHJCxuHzclw9Puaj1TYzDa7dChou
         PN9ZeG66wWc240LTIpBikWacV+fJJVHv331OiG1j59xbCzvptCjHjSctElmJDAFd48PW
         rYzPQg1D6wLIXgoNtQwum5JHoxnrVuk1/Rngd9PqG6ljFtn7q1vtk20E9R1TeT+RXNXP
         5jqzpz7qVn9abymBqiqLPlGKbJ9XeAusUrneAP/+5xXHBymn7usXf8HBc2oy57atBsJ5
         ar3w==
X-Gm-Message-State: AOAM530ON6atLspMCdtGUuzacZnropv6/OdfpZ2GtAbyziPSZoeWtQQb
        NhfIrIeRfLPNPkFbsLMi1NOQ/8DgigU=
X-Google-Smtp-Source: ABdhPJyfztwSyLIrPzXkxEB6gqPnEQD03LiQ/Mk4qn6LhOXcbiGDkVhFV42ZY282/UbfnI+mGiMTig==
X-Received: by 2002:a05:6830:3c1:b0:5b0:339a:e770 with SMTP id p1-20020a05683003c100b005b0339ae770mr3289929otc.16.1649259253256;
        Wed, 06 Apr 2022 08:34:13 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 8-20020a056870130800b000dea2399c5esm6623543oab.45.2022.04.06.08.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 08:34:12 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
To:     Luca Coelho <luciano.coelho@intel.com>
Cc:     Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH] iwlwifi: iwl-dbg: Use del_timer_sync() before freeing
Date:   Wed,  6 Apr 2022 08:34:10 -0700
Message-Id: <20220406153410.1899768-1-linux@roeck-us.net>
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
Cc: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Cc: Johannes Berg <johannes.berg@intel.com>
Fixes: 60e8abd9d3e91 ("iwlwifi: dbg_ini: add periodic trigger new API support")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
RFC:
    Maybe there was a reason to use del_timer() instead of del_timer_sync().
    Also, I am not sure if the change is sufficient since I don't see any
    obvious locking that would prevent timers from being added and then
    modified in iwl_dbg_tlv_set_periodic_trigs() while being removed in
    iwl_dbg_tlv_del_timers().

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


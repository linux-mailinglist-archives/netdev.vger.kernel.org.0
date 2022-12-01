Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A91F463F597
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 17:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiLAQqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 11:46:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiLAQqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 11:46:24 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0FE9B0A27
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 08:46:18 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id ha10so5605378ejb.3
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 08:46:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bRJvfMpiqk4k74zxkVwEQYW37a3F4O4P/nsk4Id+Cx4=;
        b=TOEavR0uISx63fwSF4JGP7T+qYq4IOAF4X/ePgGEPkaMzH/BtX43oGoIa8iYZxCN6O
         jCPv4RHRnl2ytk8fM5OQjd5z+n8rixdEHCM4viKwu65bEaWmegmZONeM+qxlnTsQ3lzF
         WT6ran1K+8P2vJ3sD0tmfDWcCPj60sjiQZ9gyZEeI/siDHhDPAQPDm9ai+hCpfAPxUW5
         bzrU1FJ8QhRLR68N0wvq+yWmlpta7DX0/hxxvErNB3KmTgNedOKWYR2UFXJ+xjI2Q6t0
         Ngptn/Ji3JtXRUP3xx4syVSTOy3WV7dorzaGvgL9sSoyy0/ngmqGqX5DfqADE3KfVeDk
         GTng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bRJvfMpiqk4k74zxkVwEQYW37a3F4O4P/nsk4Id+Cx4=;
        b=A7KLP6+47jRtqju+2Sd7m7mF9YsbJupj8FlrTze05CnUBCAwU85Yai3Vr+Hl90ghOV
         oQ7/BNetZ+1JSm4m2b0RcmFP6XLnHsh6QsvatsLAogQFA2w1VouXEsaFGOBD35VVfAlq
         xHh2vgrup7FK0v28OuzNYC8Rx5efJbQwYmYOEJaMwyjQC0DdMRq7gfedUYjxoCWWpGmK
         DpTx1RlGkPMXkQjTaG/KFld1tNg5OuuNz2wl3DbzWdx0OW/v1e4on1eXQH1vEAbKw9h8
         WkntOUo/Ge3CEOUJcqbg5mutfJJQLAWn4lSJH2n0yeCjGjKFP7fsWQYtygxiV0GBWZ0i
         0Onw==
X-Gm-Message-State: ANoB5pk0qH2r7cT4uYRcb6RLah+65Tyq78euk/GvW/hkoP4Yoask/KjK
        TfDtKUAeV206yYUPoEbBWOQb2kuf6MmCKKwh
X-Google-Smtp-Source: AA0mqf7dkfvLJt8RJ9gycERdhEhF0hvl+SDLKlzTOjD4Th4zm8KHJYB5fKf/8CnRy8qcyrCv8TizHQ==
X-Received: by 2002:a17:906:fcc2:b0:78d:8b75:b161 with SMTP id qx2-20020a170906fcc200b0078d8b75b161mr59085490ejb.385.1669913177452;
        Thu, 01 Dec 2022 08:46:17 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id s3-20020a170906284300b007ba9c181202sm1977021ejc.56.2022.12.01.08.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 08:46:16 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, yangyingliang@huawei.com, leon@kernel.org
Subject: [patch net-next RFC 4/7] nfp: Reorder devl_port_register/unregister() calls to be done when devlink is registered
Date:   Thu,  1 Dec 2022 17:46:05 +0100
Message-Id: <20221201164608.209537-5-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221201164608.209537-1-jiri@resnulli.us>
References: <20221201164608.209537-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Move the code so devl_port_register/unregister() are called only
then devlink is registered.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 .../net/ethernet/netronome/nfp/nfp_net_main.c | 22 ++++++++++++++-----
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
index abfe788d558f..9b4c48defd5c 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
@@ -752,7 +752,7 @@ int nfp_net_pci_probe(struct nfp_pf *pf)
 
 	err = nfp_shared_buf_register(pf);
 	if (err)
-		goto err_devlink_unreg;
+		goto err_clean_app;
 
 	err = nfp_devlink_params_register(pf);
 	if (err)
@@ -769,23 +769,29 @@ int nfp_net_pci_probe(struct nfp_pf *pf)
 	err = nfp_net_pf_alloc_irqs(pf);
 	if (err)
 		goto err_free_vnics;
+	devl_unlock(devlink);
 
+	devlink_register(devlink);
+
+	devl_lock(devlink);
 	err = nfp_net_pf_app_start(pf);
 	if (err)
-		goto err_free_irqs;
+		goto err_devlink_unreg;
 
 	err = nfp_net_pf_init_vnics(pf);
 	if (err)
 		goto err_stop_app;
 
 	devl_unlock(devlink);
-	devlink_register(devlink);
 
 	return 0;
 
 err_stop_app:
 	nfp_net_pf_app_stop(pf);
-err_free_irqs:
+	devl_unlock(devlink);
+err_devlink_unreg:
+	devlink_unregister(devlink);
+	devl_lock(devlink);
 	nfp_net_pf_free_irqs(pf);
 err_free_vnics:
 	nfp_net_pf_free_vnics(pf);
@@ -795,7 +801,7 @@ int nfp_net_pci_probe(struct nfp_pf *pf)
 	nfp_devlink_params_unregister(pf);
 err_shared_buf_unreg:
 	nfp_shared_buf_unregister(pf);
-err_devlink_unreg:
+err_clean_app:
 	cancel_work_sync(&pf->port_refresh_work);
 	nfp_net_pf_app_clean(pf);
 err_unmap:
@@ -808,7 +814,6 @@ void nfp_net_pci_remove(struct nfp_pf *pf)
 	struct devlink *devlink = priv_to_devlink(pf);
 	struct nfp_net *nn, *next;
 
-	devlink_unregister(priv_to_devlink(pf));
 	devl_lock(devlink);
 	list_for_each_entry_safe(nn, next, &pf->vnics, vnic_list) {
 		if (!nfp_net_is_data_vnic(nn))
@@ -818,6 +823,11 @@ void nfp_net_pci_remove(struct nfp_pf *pf)
 	}
 
 	nfp_net_pf_app_stop(pf);
+	devl_unlock(devlink);
+
+	devlink_unregister(priv_to_devlink(pf));
+
+	devl_lock(devlink);
 	/* stop app first, to avoid double free of ctrl vNIC's ddir */
 	nfp_net_debugfs_dir_clean(&pf->ddir);
 
-- 
2.37.3


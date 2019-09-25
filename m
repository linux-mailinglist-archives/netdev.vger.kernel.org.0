Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECFAFBE553
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 21:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731467AbfIYTFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 15:05:21 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:37086 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726342AbfIYTFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 15:05:21 -0400
Received: by mail-io1-f65.google.com with SMTP id b19so1659768iob.4;
        Wed, 25 Sep 2019 12:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=c8phYUHxcOtVx2XhEuIfBvw3hS5nNt31X1dO2KdVn6k=;
        b=PVPl4ikfxV0de8SML/vN7EFkdtpWOBam2MV5p4kcHusV6wvgk1S/7K6mR5iY3zj4GN
         Rvuygu2VgocmTqwHqbgC1F/e504RBF/xl7v60dVGHSdPi7grPWe/YI2f+mNWjaKiacNa
         WZQHXfyGHuLddQrDosL82du1SS46Yxk6HAw2IyYaD6AtDqazS0vSq8GuHFx5cd7CV4n6
         gSIh/4rixeT8yLggZJr+gvjM57rBSOlGG5A3H13aoFRfVRyRGCKvL8LCq8e4gffH3xrK
         OcIyyFKc3nJjlCdFaY/xIssJjD5dMIP5BS/WizrgjUG5e7UFjTfZQnsT3AQt6BmzAMH1
         yoXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=c8phYUHxcOtVx2XhEuIfBvw3hS5nNt31X1dO2KdVn6k=;
        b=XcPy7cVTsmNkK+WG1xhLmWAVhVxmLLbMOnY/+R6BZl1AqM0f5vwDxfd5VCS5DpQnC+
         h9wd3uwfft7j7xXR+EZSGKVI8+3iXnRMJbkAc6XGdmZuSiHJCOYKuWMHT5fuC83XQo5F
         nv9sKWtrRsUH7uIOAYjhDwod2/+QCLpNzr5cfDxHPVwXxxU5TIxHHbSXj/wERuAxjV/u
         HjIfEO/RwhUW7Jw2sBZNVoNNmvFgbBAoFnZrdbdeejkcVU7iC119RaEij2QEkbP48E3E
         hMTRhNgqAAq82hfzX+nB/JwuISyKPY+uPmf6pbLdTObnetzzr8e+4+9w3qAL+QegoBWT
         Oscg==
X-Gm-Message-State: APjAAAV+WywutUglfiixTHP59jLiL6Ud++RtCPEgzqiJhxFKCmndqLGm
        bVHrqJJCzgBPwvBybl4lJbk=
X-Google-Smtp-Source: APXvYqxkjxyDLf/tBbiFGuH5uThQVcYKjEuHEJEovqyv1pX5SxpeCuPY5kO9lPWKiEay1zgPBbyiWQ==
X-Received: by 2002:a6b:f90a:: with SMTP id j10mr1005826iog.77.1569438320187;
        Wed, 25 Sep 2019 12:05:20 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id k66sm383814iof.25.2019.09.25.12.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 12:05:19 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, kjlu@umn.edu, smccaman@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Fred Lotter <frederik.lotter@netronome.com>,
        oss-drivers@netronome.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] nfp: flower: fix memory leak in nfp_flower_spawn_vnic_reprs
Date:   Wed, 25 Sep 2019 14:05:09 -0500
Message-Id: <20190925190512.3404-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In nfp_flower_spawn_vnic_reprs in the loop if initialization or the
allocations fail memory is leaked. Appropriate releases are added.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 drivers/net/ethernet/netronome/nfp/flower/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.c b/drivers/net/ethernet/netronome/nfp/flower/main.c
index 7a20447cca19..c20677059cb2 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.c
@@ -400,6 +400,7 @@ nfp_flower_spawn_vnic_reprs(struct nfp_app *app,
 		repr_priv = kzalloc(sizeof(*repr_priv), GFP_KERNEL);
 		if (!repr_priv) {
 			err = -ENOMEM;
+			nfp_repr_free(repr);
 			goto err_reprs_clean;
 		}
 
@@ -413,6 +414,7 @@ nfp_flower_spawn_vnic_reprs(struct nfp_app *app,
 		port = nfp_port_alloc(app, port_type, repr);
 		if (IS_ERR(port)) {
 			err = PTR_ERR(port);
+			kfree(repr_priv);
 			nfp_repr_free(repr);
 			goto err_reprs_clean;
 		}
@@ -433,6 +435,7 @@ nfp_flower_spawn_vnic_reprs(struct nfp_app *app,
 		err = nfp_repr_init(app, repr,
 				    port_id, port, priv->nn->dp.netdev);
 		if (err) {
+			kfree(repr_priv);
 			nfp_port_free(port);
 			nfp_repr_free(repr);
 			goto err_reprs_clean;
-- 
2.17.1


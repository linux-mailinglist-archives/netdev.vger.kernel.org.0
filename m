Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 683A51679FD
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 10:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbgBUJ4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 04:56:49 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33799 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727966AbgBUJ4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 04:56:49 -0500
Received: by mail-wm1-f65.google.com with SMTP id s144so4781711wme.1
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 01:56:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7rW8cgB1ARnZe8PbEAe5B9raJgjX858jugTHDM6EZ3g=;
        b=Iw8gjYoMUEtWTDjQPzHnboVM6TtrEq1L86mDchmSAVFj/5Hqs7sADHFBRGxMdEke7f
         ANUv7jMzia8wL+HQcor7QdUbw4F5fZ80XjvtR69q+Vza3qtCa9FtheKVKcY8NRhgVg4o
         oM1GSzL/WlaYrsAwLrFs69t/Mj9l7mlMG6TAR3wXr/AXRrpZO/LZcNLcBqNN4j/IEKDl
         iaMArIJP6z0YHNBRwLzeX34Z9JsFwJSXHfQ8Dlz8eiLCqpc8QbjMJW+ypZOC3/baa0aO
         DY5W/xxu0HHYPCirpQgh24umWbZQOr8p226K/Wi5MCF1MLtD89ZYc8osk8mGBhmTe9Z8
         a6wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7rW8cgB1ARnZe8PbEAe5B9raJgjX858jugTHDM6EZ3g=;
        b=Rx/ywz8iJF5vI6ujazE6T4DDf5b8kBKGL8rZpOK4Z4u+oMsclH0sKFiWHKtxAgJ2Qe
         FCVtAH1J38U0Fguv7iuadTsmKwdJM1CFdhcePTVoxgTdwJ8jUwdcJU4HOKTUyCpeot9u
         q4DBoF99r1Y/DiXr/Klu/GNwBVHO4WUO4XpZ/qZ7F3Cb66IrZQPieSa94X1of9yq6RkY
         8QVDgaSsOe3TArOxOXn8DD6a7Iqdubb3AHtxWs9NSlGxET0tXtZ3TnRyR0tsANYqAAh0
         SPaeVzhUci7IYMfWVVSmbcgLiha3jKCn8Y5ZUVdHNW1Z+EF7HQWLVNOwkkYCD4Mjj2wk
         C18Q==
X-Gm-Message-State: APjAAAUB89cIxmn6OcUMgkVPCBwlIwxlp1CLbXktywqJG25ao277+WmK
        SwcQU7LEgCufDu/Db9KizLAwcmXwgRo=
X-Google-Smtp-Source: APXvYqwTUkckdthPSSNiTrzBRPODi6BwLZ8s1HyrP6nOSK8J46L6e8jLg+jKDsga0R5O/hWUGeD4cw==
X-Received: by 2002:a7b:cb86:: with SMTP id m6mr2840868wmi.51.1582279006988;
        Fri, 21 Feb 2020 01:56:46 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id b16sm2934619wmj.39.2020.02.21.01.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 01:56:46 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org, mlxsw@mellanox.com
Subject: [patch net-next 02/10] iavf: use tc_cls_can_offload_basic() instead of chain check
Date:   Fri, 21 Feb 2020 10:56:35 +0100
Message-Id: <20200221095643.6642-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200221095643.6642-1-jiri@resnulli.us>
References: <20200221095643.6642-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Looks like the iavf code actually experienced a race condition, when a
developer took code before the check for chain 0 was put to helper.
So use tc_cls_can_offload_basic() helper instead of direct check and
move the check to _cb() so this is similar to i40e code.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 62fe56ddcb6e..8bc0d287d025 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3061,9 +3061,6 @@ static int iavf_delete_clsflower(struct iavf_adapter *adapter,
 static int iavf_setup_tc_cls_flower(struct iavf_adapter *adapter,
 				    struct flow_cls_offload *cls_flower)
 {
-	if (cls_flower->common.chain_index)
-		return -EOPNOTSUPP;
-
 	switch (cls_flower->command) {
 	case FLOW_CLS_REPLACE:
 		return iavf_configure_clsflower(adapter, cls_flower);
@@ -3087,6 +3084,11 @@ static int iavf_setup_tc_cls_flower(struct iavf_adapter *adapter,
 static int iavf_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 				  void *cb_priv)
 {
+	struct iavf_adapter *adapter = cb_priv;
+
+	if (!tc_cls_can_offload_basic(adapter->netdev, type_data))
+		return -EOPNOTSUPP;
+
 	switch (type) {
 	case TC_SETUP_CLSFLOWER:
 		return iavf_setup_tc_cls_flower(cb_priv, type_data);
-- 
2.21.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEEE6C970D
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 19:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbjCZRBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 13:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232428AbjCZRBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 13:01:01 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D3F5FF7
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 10:00:59 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id t10so26488572edd.12
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 10:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1679850058;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G9ZxDtIaWa6JS/i9pa4g+bZzhL99n85gnvJfpee8Jl8=;
        b=x53ZrdJ9DaTRVfmR9rAfOoLh6eAY6wPjpKcxw8+0btXTlch/Agw3cDQjeVdpzVYwMF
         FqQowgDd6PFzuH1/AhNqveBsTO7JDT8Tpm1+qDwFEndg09eHfjYyEb3Mg5Cb5AiEfQzd
         8hzdgm4zh0NC3GJpSHO43szexqhv1HiibAwlP8pLLcqJ6+emGnKha1aaPqmCQUxXg+0g
         XjAdTDNhJYOh8nS4wCo+EgDWZzB9532KoCPL+HEnaEkPOxhByYiSG3hizfgw6GyPEVZ/
         9eBOjTmq9bUVJ4gUOdtkpBqNZBOfPDYLGwFNso0hUF+AU8tpCcoPM+iczh0jIzi0m0h9
         3Pww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679850058;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G9ZxDtIaWa6JS/i9pa4g+bZzhL99n85gnvJfpee8Jl8=;
        b=KTLtmHbLBpjJCUvHnumtCABHO/G33kKYyYdkM0PrdbWGAO1aZ8Jbs1KLAbd3WcAj8x
         LDLWz+AfNvigGpWPY3bxDVm4AtCqb5/N//yr6Krll7P0b9rJBBFy0QhPHW1/C31khXxd
         7DPsIx1RJ7fBQUqmfW/g/up+fBKPdJOrD67ZmviiYzi4Wgq8O3KWouMvbI/FGLErNIlg
         rB/9tmd/OHQaEbpHaOWLrdLkqXZOKANohCl8Gq63BoIy7Cp1TsEGq4FQF0grzc1a/4kY
         Mt9JTZn5ydF+r6e7gSI5cgi+scI7fT9VuYdX3COZRgWju+yvT+htZDc462b3+9B9F/5L
         jJiQ==
X-Gm-Message-State: AAQBX9dRcPBYYCSIasIikyziLZvYjqTeewGbIlTN51Kc8XrC4F/uO1/r
        PGnCN4CtFzb+Em5qjlkYQA2vZoE4knNPfD8lEo4=
X-Google-Smtp-Source: AKy350Y5aQWqa9W2mRHP1x54fuPjQgpetEBmUNq81mEiwA2RuH5Nf8qb4iSMUWnV9kRNgeyh6Inzmg==
X-Received: by 2002:a17:907:77d2:b0:886:50d:be8d with SMTP id kz18-20020a17090777d200b00886050dbe8dmr10980768ejc.13.1679850058382;
        Sun, 26 Mar 2023 10:00:58 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id ha8-20020a170906a88800b0093a6c591743sm7745266ejb.69.2023.03.26.10.00.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Mar 2023 10:00:57 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org, arkadiusz.kubalewski@intel.com,
        vadim.fedorenko@linux.dev, vadfed@meta.com
Cc:     kuba@kernel.org, jonathan.lemon@gmail.com, pabeni@redhat.com,
        poros@redhat.com, mschmidt@redhat.com,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Subject: [patch dpll-rfc 3/7] dpll: introduce a helper to get first dpll ref and use it
Date:   Sun, 26 Mar 2023 19:00:48 +0200
Message-Id: <20230326170052.2065791-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230326170052.2065791-1-jiri@resnulli.us>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230326170052.2065791-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

No need to iterate xaarray in dpll_msg_add_pin_direction() and
dpll_msg_add_pin_freq(). Just introduce a helper to get the first dpll
reference and use that.

Add a check for ops not being null in pin_register() function, not only
for sake of this change, but also for the sake of existing code relying
on it.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/dpll/dpll_core.c    | 12 ++++++++++++
 drivers/dpll/dpll_core.h    |  1 +
 drivers/dpll/dpll_netlink.c | 34 ++++++++++++----------------------
 3 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
index 6e50216a636a..2f788d2349fe 100644
--- a/drivers/dpll/dpll_core.c
+++ b/drivers/dpll/dpll_core.c
@@ -267,6 +267,15 @@ dpll_xa_ref_dpll_find(struct xarray *xa_refs, const struct dpll_device *dpll)
 	return NULL;
 }
 
+struct dpll_pin_ref *dpll_xa_ref_dpll_first(struct xarray *xa_refs)
+{
+	struct dpll_pin_ref *ref;
+	unsigned long i = 0;
+
+	ref = xa_find(xa_refs, &i, ULONG_MAX, XA_PRESENT);
+	WARN_ON(!ref);
+	return ref;
+}
 
 /**
  * dpll_device_alloc - allocate the memory for dpll device
@@ -610,6 +619,9 @@ __dpll_pin_register(struct dpll_device *dpll, struct dpll_pin *pin,
 {
 	int ret;
 
+	if (WARN_ON(!ops))
+		return -EINVAL;
+
 	if (rclk_device_name && !pin->rclk_dev_name) {
 		pin->rclk_dev_name = kstrdup(rclk_device_name, GFP_KERNEL);
 		if (!pin->rclk_dev_name)
diff --git a/drivers/dpll/dpll_core.h b/drivers/dpll/dpll_core.h
index 21ba31621b44..636dd4c6710e 100644
--- a/drivers/dpll/dpll_core.h
+++ b/drivers/dpll/dpll_core.h
@@ -99,6 +99,7 @@ struct dpll_pin_ref *
 dpll_xa_ref_pin_find(struct xarray *xa_refs, const struct dpll_pin *pin);
 struct dpll_pin_ref *
 dpll_xa_ref_dpll_find(struct xarray *xa_refs, const struct dpll_device *dpll);
+struct dpll_pin_ref *dpll_xa_ref_dpll_first(struct xarray *xa_refs);
 extern struct xarray dpll_device_xa;
 extern struct xarray dpll_pin_xa;
 extern struct mutex dpll_device_xa_lock;
diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
index 430c009d0a71..41e2f8a90aeb 100644
--- a/drivers/dpll/dpll_netlink.c
+++ b/drivers/dpll/dpll_netlink.c
@@ -134,18 +134,11 @@ dpll_msg_add_pin_on_dpll_state(struct sk_buff *msg, const struct dpll_pin *pin,
 
 static int
 dpll_msg_add_pin_direction(struct sk_buff *msg, const struct dpll_pin *pin,
+			   struct dpll_pin_ref *ref,
 			   struct netlink_ext_ack *extack)
 {
 	enum dpll_pin_direction direction;
-	struct dpll_pin_ref *ref;
-	unsigned long i;
 
-	xa_for_each((struct xarray *)&pin->dpll_refs, i, ref) {
-		if (ref && ref->ops && ref->dpll)
-			break;
-	}
-	if (!ref || !ref->ops || !ref->dpll)
-		return -ENODEV;
 	if (!ref->ops->direction_get)
 		return -EOPNOTSUPP;
 	if (ref->ops->direction_get(pin, ref->dpll, &direction, extack))
@@ -158,19 +151,12 @@ dpll_msg_add_pin_direction(struct sk_buff *msg, const struct dpll_pin *pin,
 
 static int
 dpll_msg_add_pin_freq(struct sk_buff *msg, const struct dpll_pin *pin,
-		      struct netlink_ext_ack *extack, bool dump_any_freq)
+		      struct dpll_pin_ref *ref, struct netlink_ext_ack *extack,
+		      bool dump_any_freq)
 {
 	enum dpll_pin_freq_supp fs;
-	struct dpll_pin_ref *ref;
-	unsigned long i;
 	u32 freq;
 
-	xa_for_each((struct xarray *)&pin->dpll_refs, i, ref) {
-		if (ref && ref->ops && ref->dpll)
-			break;
-	}
-	if (!ref || !ref->ops || !ref->dpll)
-		return -ENODEV;
 	if (!ref->ops->frequency_get)
 		return -EOPNOTSUPP;
 	if (ref->ops->frequency_get(pin, ref->dpll, &freq, extack))
@@ -325,10 +311,11 @@ dpll_cmd_pin_on_dpll_get(struct sk_buff *msg, struct dpll_pin *pin,
 		return -EMSGSIZE;
 	if (nla_put_u32(msg, DPLL_A_PIN_DPLL_CAPS, pin->prop.capabilities))
 		return -EMSGSIZE;
-	ret = dpll_msg_add_pin_direction(msg, pin, extack);
+	ref = dpll_xa_ref_dpll_first(&pin->dpll_refs);
+	ret = dpll_msg_add_pin_direction(msg, pin, ref, extack);
 	if (ret)
 		return ret;
-	ret = dpll_msg_add_pin_freq(msg, pin, extack, true);
+	ret = dpll_msg_add_pin_freq(msg, pin, ref, extack, true);
 	if (ret && ret != -EOPNOTSUPP)
 		return ret;
 	ref = dpll_xa_ref_dpll_find(&pin->dpll_refs, dpll);
@@ -355,6 +342,7 @@ static int
 __dpll_cmd_pin_dump_one(struct sk_buff *msg, struct dpll_pin *pin,
 			struct netlink_ext_ack *extack, bool dump_dpll)
 {
+	struct dpll_pin_ref *ref;
 	int ret;
 
 	if (nla_put_u32(msg, DPLL_A_PIN_IDX, pin->dev_driver_id))
@@ -363,10 +351,11 @@ __dpll_cmd_pin_dump_one(struct sk_buff *msg, struct dpll_pin *pin,
 		return -EMSGSIZE;
 	if (nla_put_u8(msg, DPLL_A_PIN_TYPE, pin->prop.type))
 		return -EMSGSIZE;
-	ret = dpll_msg_add_pin_direction(msg, pin, extack);
+	ref = dpll_xa_ref_dpll_first(&pin->dpll_refs);
+	ret = dpll_msg_add_pin_direction(msg, pin, ref, extack);
 	if (ret)
 		return ret;
-	ret = dpll_msg_add_pin_freq(msg, pin, extack, true);
+	ret = dpll_msg_add_pin_freq(msg, pin, ref, extack, true);
 	if (ret && ret != -EOPNOTSUPP)
 		return ret;
 	ret = dpll_msg_add_pins_on_pin(msg, pin, extack);
@@ -920,7 +909,8 @@ dpll_event_device_change(struct sk_buff *msg, struct dpll_device *dpll,
 		ret = dpll_msg_add_temp(msg, dpll, NULL);
 		break;
 	case DPLL_A_PIN_FREQUENCY:
-		ret = dpll_msg_add_pin_freq(msg, pin, NULL, false);
+		ref = dpll_xa_ref_dpll_find(&pin->dpll_refs, dpll);
+		ret = dpll_msg_add_pin_freq(msg, pin, ref, NULL, false);
 		break;
 	case DPLL_A_PIN_PRIO:
 		ref = dpll_xa_ref_dpll_find(&pin->dpll_refs, dpll);
-- 
2.39.0


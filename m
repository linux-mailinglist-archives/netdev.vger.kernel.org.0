Return-Path: <netdev+bounces-1533-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 764926FE24D
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 18:23:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44F2F2814BB
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 16:23:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54482174C0;
	Wed, 10 May 2023 16:22:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B4C6AA8
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 16:22:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06787DAD
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 09:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683735771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bmFE/obqR+JSVry8KVLBdovb1+Ke/0GWPdt6GSde0jc=;
	b=gWls+ZNQbq+HVYLE7ZajGIsCVESXLx8WiCynsPJDkgK3w+bvDQIZAZ2+0pDYEFqtf+DJnK
	gzW8pHw4uKesNeCSgfk3qNQ7a6JjONn5jEn+0Ugm8aZrkf7L1zRC4hxcuiXNzAbYvLfs2r
	Ni1Rm8RPeDZ/LnN4G8fLgITzNgOZTxg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-6-gxXNVDeNM8qqHmY3rKli0w-1; Wed, 10 May 2023 12:22:48 -0400
X-MC-Unique: gxXNVDeNM8qqHmY3rKli0w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C2B05863E8F;
	Wed, 10 May 2023 16:22:46 +0000 (UTC)
Received: from shalem.redhat.com (unknown [10.39.195.159])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A82564078906;
	Wed, 10 May 2023 16:22:44 +0000 (UTC)
From: Hans de Goede <hdegoede@redhat.com>
To: Pavel Machek <pavel@ucw.cz>,
	Jacek Anaszewski <jacek.anaszewski@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sebastian Reichel <sre@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
	linux-leds@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linux-usb@vger.kernel.org,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	Yauhen Kharuzhy <jekhor@gmail.com>
Subject: [PATCH RESEND 4/4] leds: Clear LED_INIT_DEFAULT_TRIGGER when clearing current trigger
Date: Wed, 10 May 2023 18:22:34 +0200
Message-Id: <20230510162234.291439-5-hdegoede@redhat.com>
In-Reply-To: <20230510162234.291439-1-hdegoede@redhat.com>
References: <20230510162234.291439-1-hdegoede@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Not all triggers use LED_INIT_DEFAULT_TRIGGER, which means that it
will not get cleared when the default trigger is a trigger which
does not use it such as "default-on".

If the default trigger then later gets replaced by a trigger which
does check LED_INIT_DEFAULT_TRIGGER, such as "timer" then that trigger
will behave as if it is the default trigger which it should not do.

To fix this clear the LED_INIT_DEFAULT_TRIGGER flag when clearing
the current trigger, so that it will not be set for any subsequently
set (non default) triggers.

Reviewed-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Tested-by: Yauhen Kharuzhy <jekhor@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/leds/led-triggers.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index 8214d3f7bc5f..6a5e1f41f9a4 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -185,6 +185,7 @@ int led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trig)
 		led_cdev->trigger = NULL;
 		led_cdev->trigger_data = NULL;
 		led_cdev->activated = false;
+		led_cdev->flags &= ~LED_INIT_DEFAULT_TRIGGER;
 		led_set_brightness(led_cdev, LED_OFF);
 	}
 	if (trig) {
-- 
2.40.1



Return-Path: <netdev+bounces-1531-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E3316FE247
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 18:23:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 35F2C1C20D58
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 16:22:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4997171AC;
	Wed, 10 May 2023 16:22:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A8A171A8
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 16:22:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C657295
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 09:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683735763;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7LdhAJieegVHrXtma/ffaQ+dm+tSLZToc/pLp+pQaYE=;
	b=DRap2P0jwgZVnoAfEJwN9DN3rlX/wWAiyyuqn4S7Ht8LXRD38k6EBabomer4nziip6vDSr
	GaLn5MQPoZZ4eVpQm/ntP8PadHb4fRyH/kC9xLDGWFwCSRWjelo3nBJkigP4OOMP64RX3g
	dR0hwSftqLFg/Z3PVArpFtPzbrJy3GU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-318-Ay-rr86bMduvR9CcyruC3w-1; Wed, 10 May 2023 12:22:39 -0400
X-MC-Unique: Ay-rr86bMduvR9CcyruC3w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 55D54863E8A;
	Wed, 10 May 2023 16:22:37 +0000 (UTC)
Received: from shalem.redhat.com (unknown [10.39.195.159])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2B9004078906;
	Wed, 10 May 2023 16:22:34 +0000 (UTC)
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
	coreteam@netfilter.org
Subject: [PATCH RESEND 0/4] Fix oops about sleeping in led_trigger_blink()
Date: Wed, 10 May 2023 18:22:30 +0200
Message-Id: <20230510162234.291439-1-hdegoede@redhat.com>
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

Hi All,

This is a resend with al the subsys maintainers of files touched
by the small led_trigger_blink() / led_trigger_blink_oneshot()
API/prototype change in the first patch in this series.

ARCNet, power-supply, USB, MAC80211 and netfilter maintainers,
may we please have your ack for merging patch 1/4 through Lee's
LED tree: https://git.kernel.org/pub/scm/linux/kernel/git/lee/leds.git/
?

Orginal cover letter:

Here is a patch series to fix an oops about sleeping in led_trigger_blink()
+ one other small bugfix.

Fixes: 0b9536c95709 ("leds: Add ability to blink via simple trigger")

tag, but Fixes tags tend to lead to patches getting automatically added
to the stable series and I would prefer to see this series get some
significant testing time in mainline first, so I have chosen to omit
the tag.

Regards,

Hans


Hans de Goede (4):
  leds: Change led_trigger_blink[_oneshot]() delay parameters to
    pass-by-value
  leds: Fix set_brightness_delayed() race
  leds: Fix oops about sleeping in led_trigger_blink()
  leds: Clear LED_INIT_DEFAULT_TRIGGER when clearing current trigger

 drivers/leds/led-core.c                  | 81 ++++++++++++++++++++----
 drivers/leds/led-triggers.c              | 17 ++---
 drivers/leds/trigger/ledtrig-disk.c      |  9 +--
 drivers/leds/trigger/ledtrig-mtd.c       |  8 +--
 drivers/net/arcnet/arcnet.c              |  8 +--
 drivers/power/supply/power_supply_leds.c |  5 +-
 drivers/usb/common/led.c                 |  4 +-
 include/linux/leds.h                     | 43 ++++++++++---
 net/mac80211/led.c                       |  2 +-
 net/mac80211/led.h                       |  8 +--
 net/netfilter/xt_LED.c                   |  3 +-
 11 files changed, 125 insertions(+), 63 deletions(-)

-- 
2.40.1



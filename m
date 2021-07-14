Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 596C23C893C
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 19:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237208AbhGNRDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 13:03:22 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:38426 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236088AbhGNRDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 13:03:20 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 074CE22880;
        Wed, 14 Jul 2021 17:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626282028; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=S4vNGptK/WGYFTuFWxzLASruFqw+TKKAeEWLzHzM8l8=;
        b=qcoXBv+Bs0W6F/Es1JVAb+/gaGvcCpbs9FJoVWGfuTq9UrKsgKMPCzA7gTep8xmjNZnsey
        8e/n9+BAy3vHHSTgSLH2hghGJ7KYSbZqJ2aOtK3ak118/81b06gziRhyPxhABIVbeZT0wV
        6Cb54ayALxuWPjuFlAnsIFuhQXbC9sU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626282028;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=S4vNGptK/WGYFTuFWxzLASruFqw+TKKAeEWLzHzM8l8=;
        b=s/AvZLc3iZfrAcDW13NWGXnj6XoEn55a9IPTJ1lNB5jOTFqvvrSK1vrusklJoY6pYYx3Qs
        YSYywZzJMck/7uCg==
Received: from alsa1.nue.suse.com (alsa1.suse.de [10.160.4.42])
        by relay2.suse.de (Postfix) with ESMTP id 896ECA3B88;
        Wed, 14 Jul 2021 17:00:27 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH 0/2] r8152: Fix a couple of PM problems
Date:   Wed, 14 Jul 2021 19:00:20 +0200
Message-Id: <20210714170022.8162-1-tiwai@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

it seems that r8152 driver suffers from the deadlock at both runtime
and system PM.  Formerly, it was seen more often at hibernation
resume, but now it's triggered more frequently, as reported in SUSE
Bugzilla:
  https://bugzilla.suse.com/show_bug.cgi?id=1186194

While debugging the problem, I stumbled on a few obvious bugs and here
is the results with two patches for addressing the resume problem.

***

However, the story doesn't end here, unfortunately, and those patches
don't seem sufficing.  The rest major problem is that the driver calls
napi_disable() and napi_enable() in the PM suspend callbacks.  This
makes the system stalling at (runtime-)suspend.  If we drop
napi_disable() and napi_enable() calls in the PM suspend callbacks, it
starts working (that was the result in Bugzilla comment 13):
  https://bugzilla.suse.com/show_bug.cgi?id=1186194#c13

So, my patches aren't enough and we still need to investigate
further.  It'd be appreciated if anyone can give a fix or a hint for
more debugging.  The usage of napi_disable() at PM callbacks is unique
in this driver and looks rather suspicious to me; but I'm no expert in
this area so I might be wrong...


Thanks!

Takashi

===

Takashi Iwai (2):
  r8152: Fix potential PM refcount imbalance
  r8152: Fix a deadlock by doubly PM resume

 drivers/net/usb/r8152.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

-- 
2.26.2


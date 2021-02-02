Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81D0130C719
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 18:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237191AbhBBRKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 12:10:35 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:37722 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236972AbhBBRB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 12:01:59 -0500
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1612285268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=d1Kdvu9+dkssRJkLazmJQ0ySXWAFKBgRFIkPCvH7pzU=;
        b=r0zEDGt93tE5DdtcAaMMhyHZzdJJYurPigo37XbFdJo2JW75ItMm50JrnQ8NmcmStZHhYb
        S/KVIznYGEt5eLwql+g/ME3ELlMMMAbI6T8GVFAd9ZKxXHuDhqnr/UZCkWK1UWkp1jkTmO
        cvpFulf57JsiUdQfS5pg2Pm5YkG+oQsIKJq2BCPwVwGtcYjQL0URCJcW9mTcEKiPlBmeI/
        oa5MdkmVe8uxqep/cLHBwanGFJYiCbdZBBpEFZgGMBtiZds69X+8eC/j+YGpyayZWF5tZl
        DLOM+G99bCFtWetHvRu0jhIOjimWFrWmpKGi50ccqXWDN1g/XpF7KXOwsH5iIQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1612285268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=d1Kdvu9+dkssRJkLazmJQ0ySXWAFKBgRFIkPCvH7pzU=;
        b=xA+7F6JWRLtcXL369JJP8SH4lBPMyfHDu4uH1GfFYqjgNH9xzEVXjvUHKkFfZxYuWKaQTi
        6pjUjLOErsq5qEDQ==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>
Subject: [PATCH 0/2] chelsio: cxgb: Use threaded interrupts for deferred work
Date:   Tue,  2 Feb 2021 18:01:02 +0100
Message-Id: <20210202170104.1909200-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch #2 fixes an issue in which del_timer_sync() and tasklet_kill() is
invoked from the interrupt handler. This is probably a rare error case
since it disables interrupts / the card in that case.
Patch #1 converts a worker to use a threaded interrupt which is then
also used in patch #2 instead adding another worker for this task (and
flush_work() to synchronise vs rmmod).

This has been only compile tested.

Sebastian


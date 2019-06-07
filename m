Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1753956B
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 21:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729935AbfFGTUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 15:20:51 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:51128 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729379AbfFGTUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 15:20:51 -0400
Received: from localhost ([127.0.0.1] helo=flow.W.breakpoint.cc)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1hZKPw-0004YF-Ik; Fri, 07 Jun 2019 21:20:48 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     netdev@vger.kernel.org
Cc:     tglx@linutronix.de, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH v2 net-next 0/7] Avoid local_irq_save() and use napi_alloc_frag() where possible
Date:   Fri,  7 Jun 2019 21:20:33 +0200
Message-Id: <20190607192040.19367-1-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first two patches remove local_irq_save() around
`netdev_alloc_cache' which does not work on -RT. Besides helping -RT it
whould benefit the users of the function since they can avoid disabling
interrupts and save a few cycles.
The remaining patches are from a time when I tried to remove
`netdev_alloc_cache' but then noticed that we still have non-NAPI
drivers using netdev_alloc_skb() and I dropped that idea. Using
napi_alloc_frag() over netdev_alloc_frag() would skip the not required
local_bh_disable() around the allocation.

v1…v2:
  - 1/7 + 2/7 use now "(in_irq() || irqs_disabled())" instead just
    "irqs_disabled()" to align with __dev_kfree_skb_any(). Pointed out
    by Eric Dumazet.

  - 6/7 has a typo less. Pointed out by Sergei Shtylyov.

  - 3/7 + 4/7 added acks from Ioana Radulescu.

Sebastian



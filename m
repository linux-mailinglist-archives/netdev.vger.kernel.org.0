Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC14E2E7E8
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 00:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbfE2WPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 18:15:30 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:49920 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726604AbfE2WPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 18:15:30 -0400
Received: from localhost ([127.0.0.1] helo=flow.W.breakpoint.cc)
        by Chamillionaire.breakpoint.cc with esmtp (Exim 4.89)
        (envelope-from <sebastian@breakpoint.cc>)
        id 1hW6r1-0008F3-Og; Thu, 30 May 2019 00:15:27 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     netdev@vger.kernel.org
Cc:     tglx@linutronix.de, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next 0/7] Avoid local_irq_save() and use napi_alloc_frag() where possible
Date:   Thu, 30 May 2019 00:15:16 +0200
Message-Id: <20190529221523.22399-1-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Breakpoint-Spam-Score: -1.0
X-Breakpoint-Spam-Level: -
X-Breakpoint-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,HEADER_FROM_DIFFERENT_DOMAINS=0.001
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

Sebastian


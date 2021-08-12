Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388A93EACBC
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 23:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233815AbhHLVnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 17:43:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229601AbhHLVnK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 17:43:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E382F60C3F;
        Thu, 12 Aug 2021 21:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628804565;
        bh=++ximgZsFmq/gTDdoy48gwE8EhsH8hnlk+d0uc99EOo=;
        h=From:To:Cc:Subject:Date:From;
        b=rxHiUW5Q3R9bPirIzfAmMFXZjkA/WY8w6CX3+MK6u45yxuLtBPErICte+nM7R+7W7
         LrgOEVddvHwHdRVkjs7w7oNuukIkTTIOpt0ZC0dl4e2COWIKJ8TzK/rQ2f0GWfziJ2
         +mjpAqt8pBMwtv6SeDoi+XH/cu4ZAqcBZObR2N8CJ6lEbdPHjqoI5C/k+DW2KIDYwC
         yxrMKTwGNlGy/JXV2xXLYUpJs1Szf4M6rKrjkfDE0zLckOdDP6iUsImdQynPTt/1zO
         fEffN6OtyQHvAfPcaoyXcdyV++0HvfRb+vm8N6lcImDm6OAkcZWwTJMjnAw0HYvNGn
         W3o16dD07Cfug==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com,
        prashant@broadcom.com, eddie.wai@broadcom.com,
        huangjw@broadcom.com, gospo@broadcom.com, edwin.peer@broadcom.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v3 0/4] bnxt: Tx NAPI disabling resiliency improvements
Date:   Thu, 12 Aug 2021 14:42:38 -0700
Message-Id: <20210812214242.578039-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A lockdep warning was triggered by netpoll because napi poll
was taking the xmit lock. Fix that and a couple more issues
noticed while reading the code.

Jakub Kicinski (4):
  bnxt: don't lock the tx queue from napi poll
  bnxt: disable napi before canceling DIM
  bnxt: make sure xmit_more + errors does not miss doorbells
  bnxt: count Tx drops

 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 98 ++++++++++++++---------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  1 +
 2 files changed, 62 insertions(+), 37 deletions(-)

-- 
2.31.1


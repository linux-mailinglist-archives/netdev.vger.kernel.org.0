Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E592D8CF1
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 13:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406290AbgLML7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 06:59:37 -0500
Received: from saphodev.broadcom.com ([192.19.232.172]:48166 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406194AbgLML7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 06:59:37 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 067DEEB;
        Sun, 13 Dec 2020 03:51:46 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 067DEEB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1607860307;
        bh=2lZOPlTnG+RuKQ4AO453vNDehxIUETvFvOwyAy92LXQ=;
        h=From:To:Cc:Subject:Date:From;
        b=dfdWpKtgOgTa2EeYO31VLC0/9Z6r0iDMB8nOh/unEJ1KoNIdM4AQbPjZxb/+OeMRW
         xA6bs5D67v7LCpjIOdvFL+8C5vDu+4tAtkPNebTPeQMzDmUedDoIwIr5P/QNE9D1pi
         TM0kqqJ+BP7Drp0vSZlMYLfGKK2VOr/85rA+c3Qk=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 0/5] bnxt_en: Improve firmware flashing.
Date:   Sun, 13 Dec 2020 06:51:41 -0500
Message-Id: <1607860306-17244-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset improves firmware flashing in 2 ways:

- If firmware returns NO_SPACE error during flashing, the driver will
create the UPDATE directory with more staging area and retry.
- Instead of allocating a big DMA buffer for the entire contents of
the firmware package size, fallback to a smaller buffer to DMA the
contents in multiple DMA operations.

Michael Chan (2):
  bnxt_en: Rearrange the logic in bnxt_flash_package_from_fw_obj().
  bnxt_en: Enable batch mode when using HWRM_NVM_MODIFY to flash
    packages.

Pavan Chebbi (3):
  bnxt_en: Refactor bnxt_flash_nvram.
  bnxt_en: Restructure bnxt_flash_package_from_fw_obj() to execute in a
    loop.
  bnxt_en: Retry installing FW package under NO_SPACE error condition.

 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 214 ++++++++++++------
 1 file changed, 139 insertions(+), 75 deletions(-)

-- 
2.18.1


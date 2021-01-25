Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1783022D2
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 09:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbhAYI3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 03:29:48 -0500
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:33138 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727149AbhAYHQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 02:16:09 -0500
X-Greylist: delayed 384 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Jan 2021 02:16:09 EST
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 2141CBB;
        Sun, 24 Jan 2021 23:08:22 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 2141CBB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1611558502;
        bh=E5pvVK/Aof3uZI1TJwSWA01OJ8ulhna4LCg/I0ciJ5w=;
        h=From:To:Cc:Subject:Date:From;
        b=ez39ACR5JOmz7DsspHCepmL1ALyEmVFDqftR1AVIE8V0sOgQlnvux/yvqD6BTtrTf
         vHbtcaEpmaKNx8388ecS8BtpE1pKV+wdf5SqCrIKkVm0lSMtLHp7Yd8aHF/vaj5nJl
         QhFNru1oNX0T9EnX6/gtqA29kahlTLlIW3g0mgAA=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 00/15] bnxt_en: Error recovery improvements.
Date:   Mon, 25 Jan 2021 02:08:06 -0500
Message-Id: <1611558501-11022-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains a number of improvements in the area of error
recovery.  Most error recovery scenarios are tightly coordinated with
the firmware.  A number of patches add retry logic to establish
connection with the firmware if there are indications that the
firmware is still alive and will likely transition back to the
normal state.  Some patches speed up the recovery process and make
it more reliable.  There are some cleanup patches as well.

Edwin Peer (3):
  bnxt_en: handle CRASH_NO_MASTER during bnxt_open()
  bnxt_en: log firmware debug notifications
  bnxt_en: attempt to reinitialize after aborted reset

Michael Chan (9):
  bnxt_en: Update firmware interface to 1.10.2.11.
  bnxt_en: Define macros for the various health register states.
  bnxt_en: Retry sending the first message to firmware if it is under
    reset.
  bnxt_en: Add bnxt_fw_reset_timeout() helper.
  bnxt_en: Add a new BNXT_STATE_NAPI_DISABLED flag to keep track of NAPI
    state.
  bnxt_en: Modify bnxt_disable_int_sync() to be called more than once.
  bnxt_en: Improve firmware fatal error shutdown sequence.
  bnxt_en: Consolidate firmware reset event logging.
  bnxt_en: Do not process completion entries after fatal condition
    detected.

Vasundhara Volam (3):
  bnxt_en: Move reading VPD info after successful handshake with fw.
  bnxt_en: Add an upper bound for all firmware command timeouts.
  bnxt_en: Retry open if firmware is in reset.

 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 228 ++++++++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  22 ++
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |   7 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h | 249 ++++++++++++++----
 4 files changed, 393 insertions(+), 113 deletions(-)

-- 
2.18.1


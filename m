Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB4E17D6D9
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 23:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgCHWqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 18:46:09 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36902 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgCHWqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 18:46:09 -0400
Received: by mail-pf1-f195.google.com with SMTP id p14so3949809pfn.4
        for <netdev@vger.kernel.org>; Sun, 08 Mar 2020 15:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=budf2fACl5Pc46AIKgjqHlrtZVxKj+/SJcXysbi4pp8=;
        b=VoKvvfLD54kKVl0iJwAPx+jE+bQ6qkwLnvC6iDwmbkRR0qXHBNEJGK5bYfsaya9uvh
         9swL/vmue/OGPMQEwwv8VWjf/906d/El/pDZdaakKYvka3l3v+gCPzUJu94I2mLAM24l
         uRkNsDfU8pnlkl2t/JyeqcKgxY6ntI3SShVJ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=budf2fACl5Pc46AIKgjqHlrtZVxKj+/SJcXysbi4pp8=;
        b=JLs47L8XMk9ZaxHn1FDYZpsxxXncDbeXMu/xqGccND4BRQQ8G6MeQ5mK+UCo7TNCeq
         1QYGEfH4WXpAgLsrimy2hxWB+8JIto+bi1YwArZvBNpQT0Y0f3C6ttOMjtMBI3kD6IqL
         nzZ5WyAB0OSxsVLrVyhKgM62kuvCOpf+XunDsRzWGahVdmNA8iU7dGb4Gg7Ej+zsShB/
         H1nWEdfNwvm/xufGG51Jg1G5veljjL13YzGRd43DpHm8HwvEad9hJtOq4yC6VqPccliM
         oz5op5s9Wf2GDV38eT1t4MObQDvkZgPh6v+TWnGWgvrbty5VKC1BUmAdahALBUl6D6Cr
         Qf0g==
X-Gm-Message-State: ANhLgQ3X/xKKBGBJZ3Nd24iP24iIeo7+MQbHTd/3eFR8yQJq8zunXJ3w
        evYZmzf6GemnZ4CgDjQYVPbLxeZqXrY=
X-Google-Smtp-Source: ADFU+vtXK/zvLGlAFJQhwHIO7yoYxF3MeCx6vLYMNCryGpO1u/VIyAu2DRbR2k/UxXnR8oqbVovApQ==
X-Received: by 2002:aa7:96c7:: with SMTP id h7mr13591856pfq.211.1583707568220;
        Sun, 08 Mar 2020 15:46:08 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x66sm31241397pgb.9.2020.03.08.15.46.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Mar 2020 15:46:07 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 0/8] bnxt_en: Updates.
Date:   Sun,  8 Mar 2020 18:45:46 -0400
Message-Id: <1583707554-1163-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes simplification and improvement of NAPI polling
logic in bnxt_poll_p5().  The improvements will prevent starving the
async events from firmware if we are in continuous NAPI polling.
The rest of the patches include cleanups, a better return code for
firmware busy, and to clear devlink port type more properly.

Michael Chan (4):
  bnxt_en: Handle all NQ notifications in bnxt_poll_p5().
  bnxt_en: Simplify __bnxt_poll_cqs_done().
  bnxt_en: Process the NQ under NAPI continuous polling.
  bnxt_en: Clear DCB settings after firmware reset.

Vasundhara Volam (4):
  bnxt_en: Remove unnecessary assignment of return code
  bnxt_en: Modify some bnxt_hwrm_*_free() functions to void.
  bnxt_en: Return -EAGAIN if fw command returns BUSY
  bnxt_en: Call devlink_port_type_clear() in remove()

 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 101 +++++++++-------------
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c     |  19 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |   5 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c   |   4 +-
 4 files changed, 49 insertions(+), 80 deletions(-)

-- 
2.5.1


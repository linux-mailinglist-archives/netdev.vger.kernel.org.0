Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F131E4C08BF
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 03:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237189AbiBWCcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 21:32:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237056AbiBWCcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 21:32:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E999659A53;
        Tue, 22 Feb 2022 18:30:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1164614FF;
        Wed, 23 Feb 2022 02:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D40C340EB;
        Wed, 23 Feb 2022 02:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583422;
        bh=h5iW1xnxYLihq1VYREsa+idqlKZAATRY4MQrqNiQGKE=;
        h=Date:From:To:Cc:Subject:From;
        b=VptbQJ50VYO1ckFXPf8UodRCgCOzAMPRTDKvgvQIJjjzb+v/B2kF1GqwlAPWtZGYc
         dvNJDnM3NdMT/GIuYs6FunvztufU4tigXz+lfis3BUsMza8vP9YZgKD10NfEZWJ1Co
         wTAKq5xm/pSdUELV2jMJy0hjLMc22YsyEHT1pkvPSJ6hc/BI/FnoHZWuyhIOl00C6z
         ULBARob9XDxoGzMj+sS0YwujjTRwBL/v+thrOq8TH3bXvG2owLvFXM1DS/z5xzX4MX
         v3sWaAyBFRCMlHEj2jVFVzBccD7rtFiX1TD6MObPsgiA3OUEtzjez+HTIPZGZa71mn
         w7Ez5L1Scaw4w==
Date:   Tue, 22 Feb 2022 20:38:16 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 0/6][next] ath6kl: wmi: Replace one-element arrays with
 flexible-array members
Message-ID: <cover.1645583264.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series aims to replace one-element arrays with flexible-array
members in multiple structures in drivers/net/wireless/ath/ath6kl/wmi.h

There is a regular need in the kernel to provide a way to declare having
a dynamically sized set of trailing elements in a structure. Kernel code
should always use “flexible array members”[1] for these cases. The older
style of one-element or zero-length arrays should no longer be used[2].

This helps with the ongoing efforts to globally enable -Warray-bounds
and get us closer to being able to tighten the FORTIFY_SOURCE routines
on memcpy().

These issues were found with the help of Coccinelle and audited and fixed,
manually.

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays

Link: https://github.com/KSPP/linux/issues/79

Gustavo A. R. Silva (6):
  ath6kl: wmi: Replace one-element array with flexible-array member in
    struct wmi_begin_scan_cmd
  ath6kl: wmi: Replace one-element array with flexible-array member in
    struct wmi_start_scan_cmd
  ath6kl: wmi: Replace one-element array with flexible-array  member in
    struct wmi_channel_list_reply
  ath6kl: wmi: Replace one-element array with flexible-array  member in
    struct wmi_connect_event
  ath6kl: wmi: Replace one-element array with flexible-array  member in
    struct wmi_disconnect_event
  ath6kl: wmi: Replace one-element array with flexible-array  member in
    struct wmi_aplist_event

 drivers/net/wireless/ath/ath6kl/wmi.c | 30 +++++++--------------------
 drivers/net/wireless/ath/ath6kl/wmi.h | 12 +++++------
 2 files changed, 14 insertions(+), 28 deletions(-)

-- 
2.27.0


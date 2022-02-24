Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A86E44C3770
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 22:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234524AbiBXVIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 16:08:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiBXVIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 16:08:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B09816A593;
        Thu, 24 Feb 2022 13:07:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E97926196B;
        Thu, 24 Feb 2022 21:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79CFCC340E9;
        Thu, 24 Feb 2022 21:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645736853;
        bh=uYXf9/DJ39VQh6FgBg7fGGJcFRbwfo7L2EqOdk0O4Qs=;
        h=Date:From:To:Cc:Subject:From;
        b=QWDnDGKsG11aZVRYwfScOuwOwZPRkWArnNKJQdR3/aOnIy34rAeAs1HKxx161wPl+
         Rm3OezleKwCckU9OTwa3KJfHim7hSZ6/VLKRmn6Hw3bc8fKRh50zHYpEAWM84JACUG
         uEb14VbGFLb/RDwGq3/8ee7iOZ149Ddg7oNIvsmG/q935Md0pSjJeVMV3qBm1nggJR
         4frVuf55GZOzX2CFbUKo8FLqCF3Kajaj6Wd285dsnA4LEo5RZc+7izGXCNC+fFUOfl
         I6LtHxEgAFZtQGm9zXbb8e0ZpPTmojr1m1G3P5mAQpI5SDfMqBnIW+kAK9gQWTp2JQ
         GXGBrexLCCEJQ==
Date:   Thu, 24 Feb 2022 15:15:31 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Johnson <quic_jjohnson@quicinc.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH v2 0/6][next] ath6kl: wmi: Replace one-element arrays with
 flexible-array members
Message-ID: <cover.1645736204.git.gustavoars@kernel.org>
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

Changes in v2:
 - Revert changes in if-statement logic for all the affected patches:
	if (len < sizeof(struct foo))
   Link: https://lore.kernel.org/linux-hardening/3abb0846-a26f-3d76-8936-cd23cf4387f1@quicinc.com/ 
 - Update changelog texts.
 - Add Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com> tag.

Gustavo A. R. Silva (6):
  ath6kl: wmi: Replace one-element array with flexible-array member in
    struct wmi_begin_scan_cmd
  ath6kl: wmi: Replace one-element array with flexible-array member in
    struct wmi_start_scan_cmd
  ath6kl: wmi: Replace one-element array with flexible-array member in
    struct wmi_channel_list_reply
  ath6kl: wmi: Replace one-element array with flexible-array member in
    struct wmi_connect_event
  ath6kl: wmi: Replace one-element array with flexible-array member in
    struct wmi_disconnect_event
  ath6kl: wmi: Replace one-element array with flexible-array member in
    struct wmi_aplist_event

 drivers/net/wireless/ath/ath6kl/wmi.c | 22 ++++------------------
 drivers/net/wireless/ath/ath6kl/wmi.h | 12 ++++++------
 2 files changed, 10 insertions(+), 24 deletions(-)

-- 
2.27.0


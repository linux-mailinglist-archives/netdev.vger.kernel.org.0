Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B22F50A126
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 15:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387434AbiDUNvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 09:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387428AbiDUNvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 09:51:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D52C381BE
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 06:48:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B190CB824BA
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 13:48:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0341AC385A1;
        Thu, 21 Apr 2022 13:48:20 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Jfl1boT7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1650548899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=wsQn3FCgwGEOIdAOB8Zy2pB9zP2WVgdAz95d1q7MMBo=;
        b=Jfl1boT7iirjbh8ftXn11miv4wEUqFWS6Ww9x23AOX2/tfRGljwfj63VBzwJdJpPy86Cwg
        DDtGEcKvIwj7rdiUP5r/t+mPZUyjSFw+GixqK8CDjcpdAaVekMuK84QUwVuOtcBropIe8C
        N58dmE2t0TE/XC13zf7brF5YioGD6v8=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a3195342 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 21 Apr 2022 13:48:18 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 0/2] wireguard patches for 5.18-rc4
Date:   Thu, 21 Apr 2022 15:48:03 +0200
Message-Id: <20220421134805.279118-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Davekub,

Here are two small wireguard fixes for 5.18-rc4:

1) We enable ACPI in the QEMU test harness, so that multiple CPUs are
   actually used on x86 for testing for races.

2) Sending skbs with metadata dsts attached resulted in a null pointer
   dereference, triggerable from executing eBPF programs. The fix is a
   oneliner, changing a skb_dst() null check into a skb_valid_dst()
   boolean check.

Thanks,
Jason


Jason A. Donenfeld (1):
  wireguard: selftests: enable ACPI for SMP

Nikolay Aleksandrov (1):
  wireguard: device: check for metadata_dst with skb_valid_dst()

 drivers/net/wireguard/device.c                            | 3 ++-
 tools/testing/selftests/wireguard/qemu/arch/i686.config   | 1 +
 tools/testing/selftests/wireguard/qemu/arch/x86_64.config | 1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

-- 
2.35.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6758A66C427
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 16:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbjAPPlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 10:41:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbjAPPlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 10:41:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1693F16AFB;
        Mon, 16 Jan 2023 07:41:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A788C61025;
        Mon, 16 Jan 2023 15:41:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A60DDC433F0;
        Mon, 16 Jan 2023 15:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673883706;
        bh=ZAViVdWgWJF2xmiwYZ5ME7mFHym9Ugm2BLe34iIjMPk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=dMH7mLuDJED385miiPcmZui2MMipffpOYZLVMFlgYt+J0LHn4x7BzYXP0IJp0U+Mi
         3+pKG3Xsy7QGTiGDR8PRnbQtFNx7TgjO7fGywaiQn6NjspzxIgB+NTgcSJaZRo0NHv
         AfgY2todl2oUgYybgRXTpRStH8kEUTGAdeN41W+cgDgIq22exEafl1n2IEmGgRZiVh
         7z4ZHQG93HkzDjMa7GXOiVe7UWlUdyqG9jr1+QD4hMo+yQ2E5XjgjcpuV1zl5yJzJr
         gIOX4OVbd6BjkxhqtNIZjr3NZN4RDtDG91Be6RjDAXRysW3IbqHXslLWJrmQ7myoUI
         08VguV/vAOl+w==
From:   Kalle Valo <kvalo@kernel.org>
To:     Aaron Ma <aaron.ma@canonical.com>
Cc:     nbd@nbd.name, lorenzo@kernel.org, ryder.lee@mediatek.com,
        shayne.chen@mediatek.com, sean.wang@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: mt76: mt7921: fix error code of return in mt7921_acpi_read
References: <20230116152235.1433484-1-aaron.ma@canonical.com>
Date:   Mon, 16 Jan 2023 17:41:39 +0200
In-Reply-To: <20230116152235.1433484-1-aaron.ma@canonical.com> (Aaron Ma's
        message of "Mon, 16 Jan 2023 23:22:35 +0800")
Message-ID: <87tu0qxz9o.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Aaron Ma <aaron.ma@canonical.com> writes:

> Kernel NULL pointer dereference when ACPI SAR table isn't implemented well.
> Fix the error code of return to mark the ACPI SAR table as invalid.
>
> [    5.077128] mt7921e 0000:06:00.0: sar cnt = 0
> [    5.077381] BUG: kernel NULL pointer dereference, address:
> 0000000000000004
> [    5.077630] #PF: supervisor read access in kernel mode
> [    5.077883] #PF: error_code(0x0000) - not-present page
> [    5.078138] PGD 0 P4D 0
> [    5.078398] Oops: 0000 [#1] PREEMPT SMP NOPTI
> [    5.079202] RIP: 0010:mt7921_init_acpi_sar+0x106/0x220
> [mt7921_common]
> ...
> [    5.080786] Call Trace:
> [    5.080786]  <TASK>
> [    5.080786]  mt7921_register_device+0x37d/0x490 [mt7921_common]
> [    5.080786]  mt7921_pci_probe.part.0+0x2ee/0x310 [mt7921e]
> [    5.080786]  mt7921_pci_probe+0x52/0x70 [mt7921e]
> [    5.080786]  local_pci_probe+0x47/0x90
> [    5.080786]  pci_call_probe+0x55/0x190
> [    5.080786]  pci_device_probe+0x84/0x120
>
> Fixes: f965333e491e ("mt76: mt7921: introduce ACPI SAR support")
> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>

Felix, if this is ok should this go to v6.2?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

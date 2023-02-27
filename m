Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE1D6A41C7
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 13:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjB0Mg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 07:36:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjB0Mg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 07:36:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8D61DB9D;
        Mon, 27 Feb 2023 04:36:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C4B060D54;
        Mon, 27 Feb 2023 12:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94BEC433D2;
        Mon, 27 Feb 2023 12:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677501413;
        bh=Jh8U22bdoYCQvBhJpj8kzG5Zg184640gUPfEPyJpG5Y=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=RVjc8k9xbwCbHoP8l76/xrwC55yQNIpxnHS2n/t0SgrkUkwr3q5EnNeMVXzqH8hpm
         ErOWQW96752JON4XtLE4qeumALHN6qB+ilR7j3VIps1pspoam5pXdJkBUXSjaoMh9q
         N3rYKQm4kDkzc5xP3c3CWMLBoAcmIo/OaCrJZyPkHSRnc9kpgBFvcdptNkHnDHbfVB
         jtVOuQ5aUBMaPaqetZEXWFij8gqm5z5eYY2rmC4RIi1wqYnHbuPSUKqBPQvfBlPjdN
         Wo1FfDDFThiKu8cFtwId/1PaAtl8kVSdcFYNKXKN12km9nunOQoyOrzryXkI+RfxGV
         Uuh6BJSJ1FCMA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <ath11k@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wifi: ath11k: Add a warning for wcn6855 spurious wakeup events
References: <20230220213807.28523-1-mario.limonciello@amd.com>
Date:   Mon, 27 Feb 2023 14:36:46 +0200
In-Reply-To: <20230220213807.28523-1-mario.limonciello@amd.com> (Mario
        Limonciello's message of "Mon, 20 Feb 2023 15:38:07 -0600")
Message-ID: <87r0ubqo81.fsf@kernel.org>
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

Mario Limonciello <mario.limonciello@amd.com> writes:

> When WCN6855 firmware versions less than 0x110B196E are used with
> an AMD APU and the user puts the system into s2idle spurious wakeup
> events can occur. These are difficult to attribute to the WLAN F/W
> so add a warning to the kernel driver to give users a hint where
> to look.
>
> This was tested on WCN6855 and a Lenovo Z13 with the following
> firmware versions:
> WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.9
> WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.23
>
> Link: http://lists.infradead.org/pipermail/ath11k/2023-February/004024.html
> Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2377
> Link: https://bugs.launchpad.net/ubuntu/+source/linux-firmware/+bug/2006458
> Link: https://lore.kernel.org/linux-gpio/20221012221028.4817-1-mario.limonciello@amd.com/
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>

[...]

> +static void ath11k_check_s2idle_bug(struct ath11k_base *ab)
> +{
> +	struct pci_dev *rdev;
> +
> +	if (pm_suspend_target_state != PM_SUSPEND_TO_IDLE)
> +		return;
> +
> +	if (ab->id.device != WCN6855_DEVICE_ID)
> +		return;
> +
> +	if (ab->qmi.target.fw_version >= WCN6855_S2IDLE_VER)
> +		return;
> +
> +	rdev = pci_get_domain_bus_and_slot(0, 0, PCI_DEVFN(0, 0));
> +	if (rdev->vendor == PCI_VENDOR_ID_AMD)
> +		ath11k_warn(ab, "fw_version 0x%x may cause spurious wakeups. Upgrade to 0x%x or later.",
> +			    ab->qmi.target.fw_version, WCN6855_S2IDLE_VER);

I understand the reasons for this warning but I don't really trust the
check 'ab->qmi.target.fw_version >= WCN6855_S2IDLE_VER'. I don't know
how the firmware team populates the fw_version so I'm worried that if we
ever switch to a different firmware branch (or similar) this warning
might all of sudden start triggering for the users.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

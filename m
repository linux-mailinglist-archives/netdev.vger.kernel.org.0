Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A065B0365
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 20:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729818AbfIKSKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 14:10:18 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:42450 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729603AbfIKSKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 14:10:18 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7AEC26083E; Wed, 11 Sep 2019 18:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568225417;
        bh=cth2OToflJTkN3D/O4iZhjJihL/01YTrfPtE4GsgCgo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Y9CJw4+v9XT5TXnfyFAawO9Mpw3Qtkezxm7jhZfPKZc/37GSSbc+cHV0k5gzYrohF
         erKa33beW9l5sVO7lIANR4cQ0HMSBchNv0WeRbl4w4y/+1c2WVsCHmfPxA0kwHrukL
         mpOJgP1ynurI/3tRDjPEnq5UDTGtD77dPxQ+B5E8=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2562660790;
        Wed, 11 Sep 2019 18:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568225416;
        bh=cth2OToflJTkN3D/O4iZhjJihL/01YTrfPtE4GsgCgo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=hMuxXxp35tcUz+Y20r9+iJeSGY4gCb3KvvG3mouExKnNPiuJewGZizo1agn4D68EW
         xoFmIYgzdTgXMttGUXjHfUOaWope0ATvEuZ/iCEtWuY8oDwk7DBe9zGxI0JaG0K5jG
         p7MysMxZzVH2ThqosFRpGC5xMCXYpd12jWhd9sRc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2562660790
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        ath10k@lists.infradead.org
Subject: Re: WARNING at net/mac80211/sta_info.c:1057 (__sta_info_destroy_part2())
References: <CAHk-=wgBuu8PiYpD7uWgxTSY8aUOJj6NJ=ivNQPYjAKO=cRinA@mail.gmail.com>
Date:   Wed, 11 Sep 2019 21:10:12 +0300
In-Reply-To: <CAHk-=wgBuu8PiYpD7uWgxTSY8aUOJj6NJ=ivNQPYjAKO=cRinA@mail.gmail.com>
        (Linus Torvalds's message of "Wed, 11 Sep 2019 11:05:46 +0100")
Message-ID: <87lfuuln5n.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ ath10k list

Linus Torvalds <torvalds@linux-foundation.org> writes:

> So I'm at LCA, reading email, using my laptop more than I normally do,
> and with different networking than I normally do.
>
> And I just had a 802.11 WARN_ON() trigger, followed by essentially a
> dead machine due to some lock held (maybe rtnl_lock).
>
> It's possible that the lock held thing happened before, and is the
> _reason_ for the delay, I don't know. I had to reboot the machine, but
> I gathered as much information as made sense and was obvious before I
> did so. That's appended.

Some notes while investigating this:

> But wait!
>
> ... then 10+ minutes later:
>
>    ath10k_pci 0000:02:00.0: wmi command 16387 timeout, restarting hardware
>    ath10k_pci 0000:02:00.0: failed to set 5g txpower 23: -11
>    ath10k_pci 0000:02:00.0: failed to setup tx power 23: -11
>    ath10k_pci 0000:02:00.0: failed to recalc tx power: -11
>    ath10k_pci 0000:02:00.0: failed to set inactivity time for vdev 0: -108
>    ath10k_pci 0000:02:00.0: failed to setup powersave: -108
>
> That certainly looks like something did try to set a power limit, but
> eventually failed.

I suspect the failing WMI command is called from:

ath10k_bss_info_changed()
ath10k_mac_txpower_recalc()
ath10k_mac_txpower_setup()
ath10k_wmi_pdev_set_param()
ath10k_wmi_cmd_send()
ath10k_wmi_cmd_send_nowait()
ath10k_htc_send()

-11 is -EAGAIN which would mean that the HTC credits have run out some
 reason for the WMI command:

if (ep->tx_credits < credits) {
        ath10k_dbg(ar, ATH10K_DBG_HTC,
                "htc insufficient credits ep %d required %d available %d\n",
                eid, credits, ep->tx_credits);
        spin_unlock_bh(&htc->tx_lock);
        ret = -EAGAIN;
        goto err_pull;
}

Credits can run out, for example, if there's a lot of WMI command/event
activity and are not returned during the 3s wait, firmware crashed or
problems with the PCI bus. But when the WMI command timeout happens
ath10k is supposed to restart the firmware and everything should be
usable again.
                                             
> Immediately after that:
>
>    wlp2s0: deauthenticating from 54:ec:2f:05:70:2c by local choice
> (Reason: 3=DEAUTH_LEAVING)
>    ath10k_pci 0000:02:00.0: failed to read hi_board_data address: -16
>    ath10k_pci 0000:02:00.0: failed to receive initialized event from
> target: 00000000
>    ath10k_pci 0000:02:00.0: failed to receive initialized event from
> target: 00000000
>    ath10k_pci 0000:02:00.0: failed to wait for target init: -110

I suspect here ath10k tries to reset the target during stop operation,
"failed to receive initialized event from target" comes from:

ath10k_pci_hif_stop()
ath10k_pci_safe_chip_reset()
ath10k_pci_warm_reset()
ath10k_pci_wait_for_target_init()

It shouldn't fail like that, which makes me suspect either a low level
problem or a bug in qca6174 firmware restart code. To check the latter,
could you please try to force a firmware crash and see if firmware
restart is working for you?

To crash the firmware you need to write either "hard" or "assert" (I
forgot which one QCA6174 firmware supports) to
/sys/kernel/debug/ieee80211/phy*/ath10k/simulate_fw_crash. And what
should happen is that the firmware crashes, ath10k prints a big pile of
warnings, restarts it and in few seconds everything resumes to normal
without user space even noticing it.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 600C12ADEC9
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 19:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731582AbgKJSvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 13:51:46 -0500
Received: from z5.mailgun.us ([104.130.96.5]:26043 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbgKJSvo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 13:51:44 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1605034303; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=9pEJCdwtcEllk2yAbVAHzCK/zJlkchAv5TV4KVeq0/4=;
 b=wx9JmSSUXWyXdnrKbCwBvynE4XiIHAlBoVdNaSgGcwlzcfzVOnxRhpFqZaO6K5WWNxVFxZAs
 /q/6PlQY1E8ezmpVpwYesQYH37Wu97kxDJMq5HWptcaNYqmch0J65AaFA146KKmy8xBdUaWe
 o/K7komqUUstnudxRsLBW07rqqc=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 5faae13c1b0f990483bb4f6a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 10 Nov 2020 18:51:40
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D143DC433C6; Tue, 10 Nov 2020 18:51:39 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0FCCEC433C6;
        Tue, 10 Nov 2020 18:51:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0FCCEC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mwifiex: pcie: skip cancel_work_sync() on reset failure
 path
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201028142346.18355-1-kitakar@gmail.com>
References: <20201028142346.18355-1-kitakar@gmail.com>
To:     Tsuchiya Yuto <kitakar@gmail.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>, verdre@v0yd.nl,
        Tsuchiya Yuto <kitakar@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201110185139.D143DC433C6@smtp.codeaurora.org>
Date:   Tue, 10 Nov 2020 18:51:39 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tsuchiya Yuto <kitakar@gmail.com> wrote:

> If a reset is performed, but even the reset fails for some reasons (e.g.,
> on Surface devices, the fw reset requires another quirks),
> cancel_work_sync() hangs in mwifiex_cleanup_pcie().
> 
>     # firmware went into a bad state
>     [...]
>     [ 1608.281690] mwifiex_pcie 0000:03:00.0: info: shutdown mwifiex...
>     [ 1608.282724] mwifiex_pcie 0000:03:00.0: rx_pending=0, tx_pending=1,	cmd_pending=0
>     [ 1608.292400] mwifiex_pcie 0000:03:00.0: PREP_CMD: card is removed
>     [ 1608.292405] mwifiex_pcie 0000:03:00.0: PREP_CMD: card is removed
>     # reset performed after firmware went into a bad state
>     [ 1609.394320] mwifiex_pcie 0000:03:00.0: WLAN FW already running! Skip FW dnld
>     [ 1609.394335] mwifiex_pcie 0000:03:00.0: WLAN FW is active
>     # but even the reset failed
>     [ 1619.499049] mwifiex_pcie 0000:03:00.0: mwifiex_cmd_timeout_func: Timeout cmd id = 0xfa, act = 0xe000
>     [ 1619.499094] mwifiex_pcie 0000:03:00.0: num_data_h2c_failure = 0
>     [ 1619.499103] mwifiex_pcie 0000:03:00.0: num_cmd_h2c_failure = 0
>     [ 1619.499110] mwifiex_pcie 0000:03:00.0: is_cmd_timedout = 1
>     [ 1619.499117] mwifiex_pcie 0000:03:00.0: num_tx_timeout = 0
>     [ 1619.499124] mwifiex_pcie 0000:03:00.0: last_cmd_index = 0
>     [ 1619.499133] mwifiex_pcie 0000:03:00.0: last_cmd_id: fa 00 07 01 07 01 07 01 07 01
>     [ 1619.499140] mwifiex_pcie 0000:03:00.0: last_cmd_act: 00 e0 00 00 00 00 00 00 00 00
>     [ 1619.499147] mwifiex_pcie 0000:03:00.0: last_cmd_resp_index = 3
>     [ 1619.499155] mwifiex_pcie 0000:03:00.0: last_cmd_resp_id: 07 81 07 81 07 81 07 81 07 81
>     [ 1619.499162] mwifiex_pcie 0000:03:00.0: last_event_index = 2
>     [ 1619.499169] mwifiex_pcie 0000:03:00.0: last_event: 58 00 58 00 58 00 58 00 58 00
>     [ 1619.499177] mwifiex_pcie 0000:03:00.0: data_sent=0 cmd_sent=1
>     [ 1619.499185] mwifiex_pcie 0000:03:00.0: ps_mode=0 ps_state=0
>     [ 1619.499215] mwifiex_pcie 0000:03:00.0: info: _mwifiex_fw_dpc: unregister device
>     # mwifiex_pcie_work hang happening
>     [ 1823.233923] INFO: task kworker/3:1:44 blocked for more than 122 seconds.
>     [ 1823.233932]       Tainted: G        WC OE     5.10.0-rc1-1-mainline #1
>     [ 1823.233935] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>     [ 1823.233940] task:kworker/3:1     state:D stack:    0 pid:   44 ppid:     2 flags:0x00004000
>     [ 1823.233960] Workqueue: events mwifiex_pcie_work [mwifiex_pcie]
>     [ 1823.233965] Call Trace:
>     [ 1823.233981]  __schedule+0x292/0x820
>     [ 1823.233990]  schedule+0x45/0xe0
>     [ 1823.233995]  schedule_timeout+0x11c/0x160
>     [ 1823.234003]  wait_for_completion+0x9e/0x100
>     [ 1823.234012]  __flush_work.isra.0+0x156/0x210
>     [ 1823.234018]  ? flush_workqueue_prep_pwqs+0x130/0x130
>     [ 1823.234026]  __cancel_work_timer+0x11e/0x1a0
>     [ 1823.234035]  mwifiex_cleanup_pcie+0x28/0xd0 [mwifiex_pcie]
>     [ 1823.234049]  mwifiex_free_adapter+0x24/0xe0 [mwifiex]
>     [ 1823.234060]  _mwifiex_fw_dpc+0x294/0x560 [mwifiex]
>     [ 1823.234074]  mwifiex_reinit_sw+0x15d/0x300 [mwifiex]
>     [ 1823.234080]  mwifiex_pcie_reset_done+0x50/0x80 [mwifiex_pcie]
>     [ 1823.234087]  pci_try_reset_function+0x5c/0x90
>     [ 1823.234094]  process_one_work+0x1d6/0x3a0
>     [ 1823.234100]  worker_thread+0x4d/0x3d0
>     [ 1823.234107]  ? rescuer_thread+0x410/0x410
>     [ 1823.234112]  kthread+0x142/0x160
>     [ 1823.234117]  ? __kthread_bind_mask+0x60/0x60
>     [ 1823.234124]  ret_from_fork+0x22/0x30
>     [...]
> 
> This is a deadlock caused by calling cancel_work_sync() in
> mwifiex_cleanup_pcie():
> 
> - Device resets are done via mwifiex_pcie_card_reset()
> - which schedules card->work to call mwifiex_pcie_card_reset_work()
> - which calls pci_try_reset_function().
> - This leads to mwifiex_pcie_reset_done() be called on the same workqueue,
>   which in turn calls
> - mwifiex_reinit_sw() and that calls
> - _mwifiex_fw_dpc().
> 
> The problem is now that _mwifiex_fw_dpc() calls mwifiex_free_adapter()
> in case firmware initialization fails. That ends up calling
> mwifiex_cleanup_pcie().
> 
> Note that all those calls are still running on the workqueue. So when
> mwifiex_cleanup_pcie() now calls cancel_work_sync(), it's really waiting
> on itself to complete, causing a deadlock.
> 
> This commit fixes the deadlock by skipping cancel_work_sync() on a reset
> failure path.
> 
> After this commit, when reset fails, the following output is
> expected to be shown:
> 
>     kernel: mwifiex_pcie 0000:03:00.0: info: _mwifiex_fw_dpc: unregister device
>     kernel: mwifiex: Failed to bring up adapter: -5
>     kernel: mwifiex_pcie 0000:03:00.0: reinit failed: -5
> 
> To reproduce this issue, for example, try putting the root port of wifi
> into D3 (replace "00:1d.3" with your setup).
> 
>     # put into D3 (root port)
>     sudo setpci -v -s 00:1d.3 CAP_PM+4.b=0b
> 
> Cc: Maximilian Luz <luzmaximilian@gmail.com>
> Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

4add4d988f95 mwifiex: pcie: skip cancel_work_sync() on reset failure path

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201028142346.18355-1-kitakar@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


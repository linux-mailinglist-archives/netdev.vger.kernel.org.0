Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5482AEC9C
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 10:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgKKJGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 04:06:52 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:23667 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgKKJGs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 04:06:48 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1605085606; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=aPPJFGoN2SnlxqopD4gZN8rje+MIoQNisIJDTUGH1Oc=; b=YY+WCc3B3S/TEYxNatjPylgOAymZ1ZAZRnLjERi04VspfCs4xpu0gNh7LJKPhn/KEN2iJdig
 mA6ckuWcv8r97EULEoCeRPAGnbMiw6kp7dcFTnu+WVJdxcGAsTNKPqBcgJmMiDd5b2rK8NOB
 qa8yiPJX8hfllbNT/X695lhtz6E=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 5faba991e9dd187f53a6e79f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 11 Nov 2020 09:06:25
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6CA7CC433F0; Wed, 11 Nov 2020 09:06:25 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A9E53C433C6;
        Wed, 11 Nov 2020 09:06:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A9E53C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Tsuchiya Yuto <kitakar@gmail.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>, verdre@v0yd.nl
Subject: Re: [PATCH] mwifiex: pcie: skip cancel_work_sync() on reset failure path
References: <20201028142346.18355-1-kitakar@gmail.com>
        <20201110185139.A1541C433C9@smtp.codeaurora.org>
        <bb398a320ba538e92bbe550d877b6f9d1b666cdd.camel@gmail.com>
Date:   Wed, 11 Nov 2020 11:06:19 +0200
In-Reply-To: <bb398a320ba538e92bbe550d877b6f9d1b666cdd.camel@gmail.com>
        (Tsuchiya Yuto's message of "Wed, 11 Nov 2020 17:53:37 +0900")
Message-ID: <87zh3o9sac.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tsuchiya Yuto <kitakar@gmail.com> writes:

> On Tue, 2020-11-10 at 18:51 +0000, Kalle Valo wrote:
>> Tsuchiya Yuto <kitakar@gmail.com> wrote:
>> 
>> > If a reset is performed, but even the reset fails for some reasons (e.g.,
>> > on Surface devices, the fw reset requires another quirks),
>> > cancel_work_sync() hangs in mwifiex_cleanup_pcie().
>> > 
>> >     # firmware went into a bad state
>> >     [...]
>> >     [ 1608.281690] mwifiex_pcie 0000:03:00.0: info: shutdown mwifiex...
>> >     [ 1608.282724] mwifiex_pcie 0000:03:00.0: rx_pending=0, tx_pending=1,	cmd_pending=0
>> >     [ 1608.292400] mwifiex_pcie 0000:03:00.0: PREP_CMD: card is removed
>> >     [ 1608.292405] mwifiex_pcie 0000:03:00.0: PREP_CMD: card is removed
>> >     # reset performed after firmware went into a bad state
>> >     [ 1609.394320] mwifiex_pcie 0000:03:00.0: WLAN FW already running! Skip FW dnld
>> >     [ 1609.394335] mwifiex_pcie 0000:03:00.0: WLAN FW is active
>> >     # but even the reset failed
>> >     [ 1619.499049] mwifiex_pcie 0000:03:00.0: mwifiex_cmd_timeout_func: Timeout cmd id = 0xfa, act = 0xe000
>> >     [ 1619.499094] mwifiex_pcie 0000:03:00.0: num_data_h2c_failure = 0
>> >     [ 1619.499103] mwifiex_pcie 0000:03:00.0: num_cmd_h2c_failure = 0
>> >     [ 1619.499110] mwifiex_pcie 0000:03:00.0: is_cmd_timedout = 1
>> >     [ 1619.499117] mwifiex_pcie 0000:03:00.0: num_tx_timeout = 0
>> >     [ 1619.499124] mwifiex_pcie 0000:03:00.0: last_cmd_index = 0
>> >     [ 1619.499133] mwifiex_pcie 0000:03:00.0: last_cmd_id: fa 00 07 01 07 01 07 01 07 01
>> >     [ 1619.499140] mwifiex_pcie 0000:03:00.0: last_cmd_act: 00 e0 00 00 00 00 00 00 00 00
>> >     [ 1619.499147] mwifiex_pcie 0000:03:00.0: last_cmd_resp_index = 3
>> >     [ 1619.499155] mwifiex_pcie 0000:03:00.0: last_cmd_resp_id: 07 81 07 81 07 81 07 81 07 81
>> >     [ 1619.499162] mwifiex_pcie 0000:03:00.0: last_event_index = 2
>> >     [ 1619.499169] mwifiex_pcie 0000:03:00.0: last_event: 58 00 58 00 58 00 58 00 58 00
>> >     [ 1619.499177] mwifiex_pcie 0000:03:00.0: data_sent=0 cmd_sent=1
>> >     [ 1619.499185] mwifiex_pcie 0000:03:00.0: ps_mode=0 ps_state=0
>> >     [ 1619.499215] mwifiex_pcie 0000:03:00.0: info: _mwifiex_fw_dpc: unregister device
>> >     # mwifiex_pcie_work hang happening
>> >     [ 1823.233923] INFO: task kworker/3:1:44 blocked for more than 122 seconds.
>> >     [ 1823.233932]       Tainted: G        WC OE     5.10.0-rc1-1-mainline #1
>> >     [ 1823.233935] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> >     [ 1823.233940] task:kworker/3:1     state:D stack:    0 pid:   44 ppid:     2 flags:0x00004000
>> >     [ 1823.233960] Workqueue: events mwifiex_pcie_work [mwifiex_pcie]
>> >     [ 1823.233965] Call Trace:
>> >     [ 1823.233981]  __schedule+0x292/0x820
>> >     [ 1823.233990]  schedule+0x45/0xe0
>> >     [ 1823.233995]  schedule_timeout+0x11c/0x160
>> >     [ 1823.234003]  wait_for_completion+0x9e/0x100
>> >     [ 1823.234012]  __flush_work.isra.0+0x156/0x210
>> >     [ 1823.234018]  ? flush_workqueue_prep_pwqs+0x130/0x130
>> >     [ 1823.234026]  __cancel_work_timer+0x11e/0x1a0
>> >     [ 1823.234035]  mwifiex_cleanup_pcie+0x28/0xd0 [mwifiex_pcie]
>> >     [ 1823.234049]  mwifiex_free_adapter+0x24/0xe0 [mwifiex]
>> >     [ 1823.234060]  _mwifiex_fw_dpc+0x294/0x560 [mwifiex]
>> >     [ 1823.234074]  mwifiex_reinit_sw+0x15d/0x300 [mwifiex]
>> >     [ 1823.234080]  mwifiex_pcie_reset_done+0x50/0x80 [mwifiex_pcie]
>> >     [ 1823.234087]  pci_try_reset_function+0x5c/0x90
>> >     [ 1823.234094]  process_one_work+0x1d6/0x3a0
>> >     [ 1823.234100]  worker_thread+0x4d/0x3d0
>> >     [ 1823.234107]  ? rescuer_thread+0x410/0x410
>> >     [ 1823.234112]  kthread+0x142/0x160
>> >     [ 1823.234117]  ? __kthread_bind_mask+0x60/0x60
>> >     [ 1823.234124]  ret_from_fork+0x22/0x30
>> >     [...]
>> > 
>> > This is a deadlock caused by calling cancel_work_sync() in
>> > mwifiex_cleanup_pcie():
>> > 
>> > - Device resets are done via mwifiex_pcie_card_reset()
>> > - which schedules card->work to call mwifiex_pcie_card_reset_work()
>> > - which calls pci_try_reset_function().
>> > - This leads to mwifiex_pcie_reset_done() be called on the same workqueue,
>> >   which in turn calls
>> > - mwifiex_reinit_sw() and that calls
>> > - _mwifiex_fw_dpc().
>> > 
>> > The problem is now that _mwifiex_fw_dpc() calls mwifiex_free_adapter()
>> > in case firmware initialization fails. That ends up calling
>> > mwifiex_cleanup_pcie().
>> > 
>> > Note that all those calls are still running on the workqueue. So when
>> > mwifiex_cleanup_pcie() now calls cancel_work_sync(), it's really waiting
>> > on itself to complete, causing a deadlock.
>> > 
>> > This commit fixes the deadlock by skipping cancel_work_sync() on a reset
>> > failure path.
>> > 
>> > After this commit, when reset fails, the following output is
>> > expected to be shown:
>> > 
>> >     kernel: mwifiex_pcie 0000:03:00.0: info: _mwifiex_fw_dpc: unregister device
>> >     kernel: mwifiex: Failed to bring up adapter: -5
>> >     kernel: mwifiex_pcie 0000:03:00.0: reinit failed: -5
>> > 
>> > To reproduce this issue, for example, try putting the root port of wifi
>> > into D3 (replace "00:1d.3" with your setup).
>> > 
>> >     # put into D3 (root port)
>> >     sudo setpci -v -s 00:1d.3 CAP_PM+4.b=0b
>> > 
>> > Cc: Maximilian Luz <luzmaximilian@gmail.com>
>> > Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>
>> 
>> Patch applied to wireless-drivers-next.git, thanks.
>> 
>> 4add4d988f95 mwifiex: pcie: skip cancel_work_sync() on reset failure path
>> 
>
> Sorry, but is it too late to ask you to change my commit message? I'd
> really appreciate it if it's still possible. If it's difficult, please
> ignore this.

Yeah, it's too late. I rebase my trees only in very exceptional cases.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

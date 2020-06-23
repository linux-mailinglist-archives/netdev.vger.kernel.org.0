Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31CE1204C53
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 10:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731861AbgFWI1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 04:27:01 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:41629 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731764AbgFWI1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 04:27:00 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1592900819; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=KibLpiIJZ8OoU7QBd/y8BObyo7ExEw9uGFHlSuJvhVM=;
 b=UsrS0srN+vGT6qLlPPb5q5fsGzD/dHUkD/C4/e+k+brXT9Nn25qfRizTGgiG+Ip56aBCBJzs
 t7cYWSN52AuN/FGhBO6QPudKZz7ZHeLqJD2DqXzPCICra7Jqx/Amkg+fylECQ+wVRVJ8P1Q1
 em5u8lfpSiwakByd2nhmsIkXh+A=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-east-1.postgun.com with SMTP id
 5ef1bccd86de6ccd446543fe (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 23 Jun 2020 08:26:53
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 01CF5C433C6; Tue, 23 Jun 2020 08:26:52 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 03841C433C6;
        Tue, 23 Jun 2020 08:26:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 03841C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] iwlwifi: fix crash in iwl_dbg_tlv_alloc_trigger
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200612073800.27742-1-jslaby@suse.cz>
References: <20200612073800.27742-1-jslaby@suse.cz>
To:     Jiri Slaby <jslaby@suse.cz>
Cc:     johannes.berg@intel.com, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        =?utf-8?q?Die?= =?utf-8?q?ter_N=C3=BCtzel?= 
        <Dieter@nuetzel-hh.de>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200623082653.01CF5C433C6@smtp.codeaurora.org>
Date:   Tue, 23 Jun 2020 08:26:52 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri Slaby <jslaby@suse.cz> wrote:

> The tlv passed to iwl_dbg_tlv_alloc_trigger comes from a loaded firmware
> file. The memory can be marked as read-only as firmware could be
> shared. In anyway, writing to this memory is not expected. So,
> iwl_dbg_tlv_alloc_trigger can crash now:
> 
>   BUG: unable to handle page fault for address: ffffae2c01bfa794
>   PF: supervisor write access in kernel mode
>   PF: error_code(0x0003) - permissions violation
>   PGD 107d51067 P4D 107d51067 PUD 107d52067 PMD 659ad2067 PTE 8000000662298161
>   CPU: 2 PID: 161 Comm: kworker/2:1 Not tainted 5.7.0-3.gad96a07-default #1 openSUSE Tumbleweed (unreleased)
>   RIP: 0010:iwl_dbg_tlv_alloc_trigger+0x25/0x60 [iwlwifi]
>   Code: eb f2 0f 1f 00 66 66 66 66 90 83 7e 04 33 48 89 f8 44 8b 46 10 48 89 f7 76 40 41 8d 50 ff 83 fa 19 77 23 8b 56 20 85 d2 75 07 <c7> 46 20 ff ff ff ff 4b 8d 14 40 48 c1 e2 04 48 8d b4 10 00 05 00
>   RSP: 0018:ffffae2c00417ce8 EFLAGS: 00010246
>   RAX: ffff8f0522334018 RBX: ffff8f0522334018 RCX: ffffffffc0fc26c0
>   RDX: 0000000000000000 RSI: ffffae2c01bfa774 RDI: ffffae2c01bfa774
>   RBP: 0000000000000000 R08: 0000000000000004 R09: 0000000000000001
>   R10: 0000000000000034 R11: ffffae2c01bfa77c R12: ffff8f0522334230
>   R13: 0000000001000009 R14: ffff8f0523fdbc00 R15: ffff8f051f395800
>   FS:  0000000000000000(0000) GS:ffff8f0527c80000(0000) knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: ffffae2c01bfa794 CR3: 0000000389eba000 CR4: 00000000000006e0
>   Call Trace:
>    iwl_dbg_tlv_alloc+0x79/0x120 [iwlwifi]
>    iwl_parse_tlv_firmware.isra.0+0x57d/0x1550 [iwlwifi]
>    iwl_req_fw_callback+0x3f8/0x6a0 [iwlwifi]
>    request_firmware_work_func+0x47/0x90
>    process_one_work+0x1e3/0x3b0
>    worker_thread+0x46/0x340
>    kthread+0x115/0x140
>    ret_from_fork+0x1f/0x40
> 
> As can be seen, write bit is not set in the PTE. Read of
> trig->occurrences succeeds in iwl_dbg_tlv_alloc_trigger, but
> trig->occurrences = cpu_to_le32(-1); fails there, obviously.
> 
> This is likely because we (at SUSE) use compressed firmware and that is
> marked as RO after decompression (see fw_map_paged_buf).
> 
> Fix it by creating a temporary buffer in case we need to change the
> memory.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Reported-by: Dieter Nützel <Dieter@nuetzel-hh.de>
> Tested-by: Dieter Nützel <Dieter@nuetzel-hh.de>
> Cc: Johannes Berg <johannes.berg@intel.com>
> Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Cc: Luca Coelho <luciano.coelho@intel.com>
> Cc: Intel Linux Wireless <linuxwifi@intel.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org

Patch applied to wireless-drivers.git, thanks.

ea0cca61d628 iwlwifi: fix crash in iwl_dbg_tlv_alloc_trigger

-- 
https://patchwork.kernel.org/patch/11601365/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


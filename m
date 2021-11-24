Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E84B45B68B
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 09:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbhKXIca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 03:32:30 -0500
Received: from m43-7.mailgun.net ([69.72.43.7]:43382 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234479AbhKXIc2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 03:32:28 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1637742557; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=OmSbuwl7iL1WdSEQMMnIIrutT3ecoeD7PxVBtYSrxeU=; b=VuEyHbizu9Cck9J7/9txdYkjSuop6ZCSk3hekvpmFRLa7rr7GKq9ohLndsqDVvAYL0uu5qxF
 0wxww8DpY4jQDXn+/pU9YM5gPcYKnrrD25n4GLDkoCQC58DpwDIcYQnuz4H7xdXN19yDAyil
 kzy+IBheJXP3CU1y5Bs+sPnNx4s=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 619df7dc4fca5da46d91f435 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 24 Nov 2021 08:29:16
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A426FC4360D; Wed, 24 Nov 2021 08:29:16 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C9359C4338F;
        Wed, 24 Nov 2021 08:29:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org C9359C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Jiri Kosina <jikos@kernel.org>
Cc:     "Coelho\, Luciano" <luciano.coelho@intel.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Berg\, Johannes" <johannes.berg@intel.com>,
        "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iwlwifi: mvm: protect regulatory_set_wiphy_regd_sync() with wiphy lock
References: <nycvar.YFH.7.76.2111232204150.16505@cbobk.fhfr.pm>
        <871r366kjy.fsf@codeaurora.org>
        <74c53e65a8f3db89d60718dc1dfb807cd80857ca.camel@intel.com>
        <nycvar.YFH.7.76.2111240921230.16505@cbobk.fhfr.pm>
Date:   Wed, 24 Nov 2021 10:29:10 +0200
In-Reply-To: <nycvar.YFH.7.76.2111240921230.16505@cbobk.fhfr.pm> (Jiri
        Kosina's message of "Wed, 24 Nov 2021 09:21:41 +0100 (CET)")
Message-ID: <87o86a5549.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri Kosina <jikos@kernel.org> writes:

> On Wed, 24 Nov 2021, Coelho, Luciano wrote:
>
>> > > Since the switch away from rtnl to wiphy lock, 
>> > > regulatory_set_wiphy_regd_sync() has to be called with wiphy lock held; 
>> > > this is currently not the case on the module load codepath.
>> > > 
>> > > Fix that by properly acquiring it in iwl_mvm_start_get_nvm() to maintain 
>> > > also lock ordering against mvm->mutex and RTNL.
>> > > 
>> > > This fixes the splat below.
>> > > 
>> > >  =============================
>> > >  WARNING: suspicious RCU usage
>> > >  5.16.0-rc2 #1 Not tainted
>> > >  -----------------------------
>> > >  drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c:264 suspicious rcu_dereference_protected() usage!
>> > > 
>> > >  other info that might help us debug this:
>> > > 
>> > >  rcu_scheduler_active = 2, debug_locks = 1
>> > >  3 locks held by modprobe/578:
>> > >   #0: ffffffffc0b6f0e8 (iwlwifi_opmode_table_mtx){+.+.}-{3:3}, at: iwl_opmode_register+0x2e/0xe0 [iwlwifi]
>> > >   #1: ffffffff9a856b08 (rtnl_mutex){+.+.}-{3:3}, at: iwl_op_mode_mvm_start+0xa0b/0xcb0 [iwlmvm]
>> > >   #2: ffff8e5242f53380 (&mvm->mutex){+.+.}-{3:3}, at: iwl_op_mode_mvm_start+0xa16/0xcb0 [iwlmvm]
>> > > 
>> > >  stack backtrace:
>> > >  CPU: 1 PID: 578 Comm: modprobe Not tainted 5.16.0-rc2 #1
>> > >  Hardware name: LENOVO 20K5S22R00/20K5S22R00, BIOS R0IET38W (1.16 ) 05/31/2017
>> > >  Call Trace:
>> > >   <TASK>
>> > >   dump_stack_lvl+0x58/0x71
>> > >   iwl_mvm_init_fw_regd+0x13d/0x180 [iwlmvm]
>> > >   iwl_mvm_init_mcc+0x66/0x1d0 [iwlmvm]
>> > >   iwl_op_mode_mvm_start+0xc6d/0xcb0 [iwlmvm]
>> > >   _iwl_op_mode_start.isra.4+0x42/0x80 [iwlwifi]
>> > >   iwl_opmode_register+0x71/0xe0 [iwlwifi]
>> > >   ? 0xffffffffc1062000
>> > >   iwl_mvm_init+0x34/0x1000 [iwlmvm]
>> > >   do_one_initcall+0x5b/0x300
>> > >   do_init_module+0x5b/0x21c
>> > >   load_module+0x1b2f/0x2320
>> > >   ? __do_sys_finit_module+0xaa/0x110
>> > >   __do_sys_finit_module+0xaa/0x110
>> > >   do_syscall_64+0x3a/0xb0
>> > >   entry_SYSCALL_64_after_hwframe+0x44/0xae
>> > >  RIP: 0033:0x7f7cdd7c8ded
>> > >  Code: 5b 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d fb ef 0e 00 f7 d8 64 89 01 48
>> > >  RSP: 002b:00007fffb90bf458 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
>> > >  RAX: ffffffffffffffda RBX: 0000559c501caf00 RCX: 00007f7cdd7c8ded
>> > >  RDX: 0000000000000000 RSI: 0000559c4eb366ee RDI: 0000000000000002
>> > >  RBP: 0000000000040000 R08: 0000000000000000 R09: 0000559c501ca9f8
>> > >  R10: 0000000000000002 R11: 0000000000000246 R12: 0000559c4eb366ee
>> > >  R13: 0000559c501cadb0 R14: 0000000000000000 R15: 0000559c501cbad0
>> > >   </TASK>
>> > >  ------------[ cut here ]------------
>> > >  WARNING: CPU: 1 PID: 578 at net/wireless/reg.c:3107 reg_process_self_managed_hint+0x183/0x1d0 [cfg80211]
>> > >  Modules linked in:
>> > >  CPU: 1 PID: 578 Comm: modprobe Not tainted 5.16.0-rc2 #1
>> > >  Hardware name: LENOVO 20K5S22R00/20K5S22R00, BIOS R0IET38W (1.16 ) 05/31/2017
>> > >  RIP: 0010:reg_process_self_managed_hint+0x183/0x1d0 [cfg80211]
>> > >  Code: 83 c4 60 5b 41 5a 41 5c 41 5d 41 5e 41 5f 5d 49 8d 62 f8 c3 48 8d 7b 68 be ff ff ff ff e8 75 4a 13 d9 85 c0 0f 85 e6 fe ff ff <0f> 0b e9 df fe ff ff 0f 0b 80 3d bc 2c 0b 00 00 0f 85 c2 fe ff ff
>> > >  RSP: 0018:ffff9994809cfaf0 EFLAGS: 00010246
>> > >  RAX: 0000000000000000 RBX: ffff8e5242f505c0 RCX: 0000000000000000
>> > >  RDX: 0000000000000000 RSI: ffff8e5242f50628 RDI: ffff8e524a2b5cd0
>> > >  RBP: ffff9994809cfb80 R08: 0000000000000001 R09: ffffffff9b2e2f50
>> > >  R10: ffff9994809cfb98 R11: ffffffffffffffff R12: 0000000000000000
>> > >  R13: ffff8e5242f532e8 R14: ffff8e5248914010 R15: ffff8e5242f532e0
>> > >  FS:  00007f7cdd6af740(0000) GS:ffff8e5367480000(0000) knlGS:0000000000000000
>> > >  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> > >  CR2: 00007f19430687ac CR3: 00000001088fa003 CR4: 00000000003706e0
>> > >  Call Trace:
>> > >   <TASK>
>> > >   ? lock_is_held_type+0xb4/0x120
>> > >   ? regulatory_set_wiphy_regd_sync+0x2f/0x80 [cfg80211]
>> > >   regulatory_set_wiphy_regd_sync+0x2f/0x80 [cfg80211]
>> > >   iwl_mvm_init_mcc+0xcd/0x1d0 [iwlmvm]
>> > >   iwl_op_mode_mvm_start+0xc6d/0xcb0 [iwlmvm]
>> > >   _iwl_op_mode_start.isra.4+0x42/0x80 [iwlwifi]
>> > >   iwl_opmode_register+0x71/0xe0 [iwlwifi]
>> > >   ? 0xffffffffc1062000
>> > >   iwl_mvm_init+0x34/0x1000 [iwlmvm]
>> > >   do_one_initcall+0x5b/0x300
>> > >   do_init_module+0x5b/0x21c
>> > >   load_module+0x1b2f/0x2320
>> > >   ? __do_sys_finit_module+0xaa/0x110
>> > >   __do_sys_finit_module+0xaa/0x110
>> > >   do_syscall_64+0x3a/0xb0
>> > >   entry_SYSCALL_64_after_hwframe+0x44/0xae
>> > >  RIP: 0033:0x7f7cdd7c8ded
>> > >  Code: 5b 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d fb ef 0e 00 f7 d8 64 89 01 48
>> > >  RSP: 002b:00007fffb90bf458 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
>> > >  RAX: ffffffffffffffda RBX: 0000559c501caf00 RCX: 00007f7cdd7c8ded
>> > >  RDX: 0000000000000000 RSI: 0000559c4eb366ee RDI: 0000000000000002
>> > >  RBP: 0000000000040000 R08: 0000000000000000 R09: 0000559c501ca9f8
>> > >  R10: 0000000000000002 R11: 0000000000000246 R12: 0000559c4eb366ee
>> > >  R13: 0000559c501cadb0 R14: 0000000000000000 R15: 0000559c501cbad0
>> > > 
>> > > Fixes: a05829a7222e9d1 ("cfg80211: avoid holding the RTNL when calling the driver")
>> > > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
>> > 
>> > I think this should go to wireless-drivers so I assigned this to me.
>> > Luca, ack?
>> 
>> Hmmm, I thought we already had a fix for this as well?

Indeed, and it looks to be identical even:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git/commit/?id=f5cecf1d4c5ff76172928bc32e99ca56a5ca2f56

Marking the bug as superseded.

> FWIW I don't see this fixed in latest linux-next.

This was applied on Monday, maybe there was no linux-next build on
Tuesday?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

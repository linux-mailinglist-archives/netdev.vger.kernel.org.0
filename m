Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A24FC1F7534
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 10:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbgFLISM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 04:18:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:15825 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726324AbgFLISM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jun 2020 04:18:12 -0400
IronPort-SDR: wCSePci76Oale64BGi0QviYSzV8lo4Eg2Qfrh47kfVuqydBBmkGjr1vNCutJqGD0goREEDy6LD
 s9FGXHPL1ZLw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2020 01:18:11 -0700
IronPort-SDR: uJDN/hRZ26RQ33AZ6c0vXiUKRVPPJEZYwh5Z3gqGn2MxeOei2Mxy+K2Uls+Yn/WkhhXNT97HCC
 XEfQ6+FFNKVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,502,1583222400"; 
   d="scan'208";a="296880859"
Received: from janlundk-mobl1.ger.corp.intel.com ([10.249.254.139])
  by fmsmga004.fm.intel.com with ESMTP; 12 Jun 2020 01:18:08 -0700
Message-ID: <11fc5db81237fb3383b1df327d2cd2e308c0e525.camel@intel.com>
Subject: Re: [PATCH] iwl: fix crash in iwl_dbg_tlv_alloc_trigger
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     Kalle Valo <kvalo@codeaurora.org>, Jiri Slaby <jslaby@suse.cz>
Cc:     johannes.berg@intel.com, linux-kernel@vger.kernel.org,
        Dieter =?ISO-8859-1?Q?N=FCtzel?= <Dieter@nuetzel-hh.de>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date:   Fri, 12 Jun 2020 11:18:08 +0300
In-Reply-To: <87d064k9a9.fsf@codeaurora.org>
References: <20200612073800.27742-1-jslaby@suse.cz>
         <87d064k9a9.fsf@codeaurora.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-06-12 at 10:55 +0300, Kalle Valo wrote:
> Jiri Slaby <jslaby@suse.cz> writes:
> 
> > The tlv passed to iwl_dbg_tlv_alloc_trigger comes from a loaded firmware
> > file. The memory can be marked as read-only as firmware could be
> > shared. In anyway, writing to this memory is not expected. So,
> > iwl_dbg_tlv_alloc_trigger can crash now:
> > 
> >   BUG: unable to handle page fault for address: ffffae2c01bfa794
> >   PF: supervisor write access in kernel mode
> >   PF: error_code(0x0003) - permissions violation
> >   PGD 107d51067 P4D 107d51067 PUD 107d52067 PMD 659ad2067 PTE 8000000662298161
> >   CPU: 2 PID: 161 Comm: kworker/2:1 Not tainted 5.7.0-3.gad96a07-default #1 openSUSE Tumbleweed (unreleased)
> >   RIP: 0010:iwl_dbg_tlv_alloc_trigger+0x25/0x60 [iwlwifi]
> >   Code: eb f2 0f 1f 00 66 66 66 66 90 83 7e 04 33 48 89 f8 44 8b 46 10 48 89 f7 76 40 41 8d 50 ff 83 fa 19 77 23 8b 56 20 85 d2 75 07 <c7> 46 20 ff ff ff ff 4b 8d 14 40 48 c1 e2 04 48 8d b4 10 00 05 00
> >   RSP: 0018:ffffae2c00417ce8 EFLAGS: 00010246
> >   RAX: ffff8f0522334018 RBX: ffff8f0522334018 RCX: ffffffffc0fc26c0
> >   RDX: 0000000000000000 RSI: ffffae2c01bfa774 RDI: ffffae2c01bfa774
> >   RBP: 0000000000000000 R08: 0000000000000004 R09: 0000000000000001
> >   R10: 0000000000000034 R11: ffffae2c01bfa77c R12: ffff8f0522334230
> >   R13: 0000000001000009 R14: ffff8f0523fdbc00 R15: ffff8f051f395800
> >   FS:  0000000000000000(0000) GS:ffff8f0527c80000(0000) knlGS:0000000000000000
> >   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >   CR2: ffffae2c01bfa794 CR3: 0000000389eba000 CR4: 00000000000006e0
> >   Call Trace:
> >    iwl_dbg_tlv_alloc+0x79/0x120 [iwlwifi]
> >    iwl_parse_tlv_firmware.isra.0+0x57d/0x1550 [iwlwifi]
> >    iwl_req_fw_callback+0x3f8/0x6a0 [iwlwifi]
> >    request_firmware_work_func+0x47/0x90
> >    process_one_work+0x1e3/0x3b0
> >    worker_thread+0x46/0x340
> >    kthread+0x115/0x140
> >    ret_from_fork+0x1f/0x40
> > 
> > As can be seen, write bit is not set in the PTE. Read of
> > trig->occurrences succeeds in iwl_dbg_tlv_alloc_trigger, but
> > trig->occurrences = cpu_to_le32(-1); fails there, obviously.
> > 
> > This is likely because we (at SUSE) use compressed firmware and that is
> > marked as RO after decompression (see fw_map_paged_buf).
> > 
> > Fix it by creating a temporary buffer in case we need to change the
> > memory.
> > 
> > Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> > Reported-by: Dieter Nützel <Dieter@nuetzel-hh.de>
> > Tested-by: Dieter Nützel <Dieter@nuetzel-hh.de>
> > Cc: Johannes Berg <johannes.berg@intel.com>
> > Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> > Cc: Luca Coelho <luciano.coelho@intel.com>
> > Cc: Intel Linux Wireless <linuxwifi@intel.com>
> > Cc: Kalle Valo <kvalo@codeaurora.org>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: linux-wireless@vger.kernel.org
> > Cc: netdev@vger.kernel.org
> > ---
> >  drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c | 16 ++++++++++++++--
> 
> The prefix should be "iwlwifi: ", I can fix that.
> 
> Luca, should I take this to wireless-drivers?

Yeah, this looks good.  Thanks, Jiri!

And yes, Kalle, please apply it directly to w-d.  Thank you!

--
Cheers,
Luca.


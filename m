Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9767D41898
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 01:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437031AbfFKXHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 19:07:06 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54688 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390115AbfFKXHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 19:07:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=aWwNDG9l+fRofOJ4dvlOUGxsf7dmx2az/Ef1K3Z/EoY=; b=SBr/CRmlczoybi8R+VWdBVH5K
        MRuWlf8ggyJanc8B6NFuoRtDCxLL9hPPBgSUWSmJTUiXeBmJ78a+Yf+JFvXjsE0fEXHLsXL90AfeM
        cPMEYgVdybx2YCGOtGDXR3T21UtRhpEm7Y9jxYxkQ+54bTyRctrL9jx1NfSHkMuyyNx/AT1ew2Vlg
        6TRFdTKcs6czohEyEpX+5n/nfV4D6O88+o6IzUXsdj/E3M2D+U3WW3UNH7QgMNpal6kv5U73IRCN6
        YrpTXe56o2+lm2tjxdXbXQvlbU9VLic4C6jZjk9TxhiTLCe7o4oc10QP1ch+Q6HR7NC1NDL76Io4j
        TfKEWo1og==;
Received: from static-50-53-52-16.bvtn.or.frontiernet.net ([50.53.52.16] helo=dragon.dunlab)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hapr6-0000I0-UP; Tue, 11 Jun 2019 23:07:05 +0000
Subject: Re: [PATCH net] mpls: fix af_mpls dependencies
To:     David Miller <davem@davemloft.net>, mcroce@redhat.com
Cc:     netdev@vger.kernel.org, linux-next@vger.kernel.org,
        akpm@linux-foundation.org, dsahern@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20190608125019.417-1-mcroce@redhat.com>
 <20190609.195742.739339469351067643.davem@davemloft.net>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <d19abcd4-799c-ac2f-ffcb-fa749d17950c@infradead.org>
Date:   Tue, 11 Jun 2019 16:06:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190609.195742.739339469351067643.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/9/19 7:57 PM, David Miller wrote:
> From: Matteo Croce <mcroce@redhat.com>
> Date: Sat,  8 Jun 2019 14:50:19 +0200
> 
>> MPLS routing code relies on sysctl to work, so let it select PROC_SYSCTL.
>>
>> Reported-by: Randy Dunlap <rdunlap@infradead.org>
>> Suggested-by: David Ahern <dsahern@gmail.com>
>> Signed-off-by: Matteo Croce <mcroce@redhat.com>
> 
> Applied, thanks.
> 

This patch causes build errors when
# CONFIG_PROC_FS is not set
because PROC_SYSCTL depends on PROC_FS.  The build errors are not
in fs/proc/ but in other places in the kernel that never expect to see
PROC_FS not set but PROC_SYSCTL=y.

I see the following 2 build errors:

../kernel/sysctl_binary.c: In function 'binary_sysctl':
../kernel/sysctl_binary.c:1305:37: error: 'struct pid_namespace' has no member named 'proc_mnt'; did you mean 'proc_work'?
  mnt = task_active_pid_ns(current)->proc_mnt;
                                     ^~~~~~~~

../fs/xfs/xfs_sysctl.c:80:19: error: 'xfs_panic_mask_proc_handler' undeclared here (not in a function); did you mean 'xfs_panic_mask'?
   .proc_handler = xfs_panic_mask_proc_handler,
                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~



The patch's line:
+	select PROC_SYSCTL

should not be done unless PROC_FS is enabled, e.g.:
	select PROC_SYSCTL if PROC_FS
but that still doesn't help the mpls driver operate as it should.

The patch should have been
	depends on PROC_SYSCTL

As it stands now (in linux-next), this patch should be reverted IMO.


-- 
~Randy

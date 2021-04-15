Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEAC36144F
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 23:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236204AbhDOVpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 17:45:54 -0400
Received: from gateway34.websitewelcome.com ([192.185.149.105]:23125 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236050AbhDOVpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 17:45:53 -0400
X-Greylist: delayed 1497 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Apr 2021 17:45:53 EDT
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id B70401966DF
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 15:59:15 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id X950lwXSN1cHeX950l8sEf; Thu, 15 Apr 2021 15:59:15 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6CXe/2uAP5B+hqjqAASCS8AQwi2PHuTbchjocdJsdP0=; b=ItKyX5bJH8JY4+5LIm5IpYJxZ3
        PzR2aydI9fD6ZFcI4Fq6I+hTfaSyTp0pr8645FgH+VZanml7xLgG4qhustGn/tU6YTuJMVA3G4EUw
        F1qWje/TdCqzUI8P8eT9vb0m0VxEQ+iX1zjl0NEnoW2UzThym4zyWt6Dl/NC5huypaYXSatXuY+Az
        3vKcENLI+u7uKYyOLoYV/LxuVdesfHi7ZjT3IiQbBBmI7G6vAQTuDWcydo+dn4naKKCK+bYn7AJcg
        77HtRfUXWdO7p9Vm2UsKy9VK4T8owqxdf8vWwVqXT9nsJL39aZ7HnU0BwRlRxSsEpLFzj9Rxm+1Pb
        ZjCZPoGw==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:47400 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lX94x-003HwF-Fa; Thu, 15 Apr 2021 15:59:11 -0500
Subject: Re: [PATCH v3 2/2] wl3501_cs: Fix out-of-bounds warnings in
 wl3501_mgmt_join
To:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <cover.1618442265.git.gustavoars@kernel.org>
 <1fbaf516da763b50edac47d792a9145aa4482e29.1618442265.git.gustavoars@kernel.org>
 <202104151257.DC4DA20@keescook>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <6a3434e0-5b8e-39d2-c69b-5e0545318192@embeddedor.com>
Date:   Thu, 15 Apr 2021 15:59:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <202104151257.DC4DA20@keescook>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1lX94x-003HwF-Fa
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:47400
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 8
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/15/21 14:58, Kees Cook wrote:
> On Wed, Apr 14, 2021 at 06:45:15PM -0500, Gustavo A. R. Silva wrote:
>> Fix the following out-of-bounds warnings by adding a new structure
>> wl3501_req instead of duplicating the same members in structure
>> wl3501_join_req and wl3501_scan_confirm:
>>
>> arch/x86/include/asm/string_32.h:182:25: warning: '__builtin_memcpy' offset [39, 108] from the object at 'sig' is out of the bounds of referenced subobject 'beacon_period' with type 'short unsigned int' at offset 36 [-Warray-bounds]
>> arch/x86/include/asm/string_32.h:182:25: warning: '__builtin_memcpy' offset [25, 95] from the object at 'sig' is out of the bounds of referenced subobject 'beacon_period' with type 'short unsigned int' at offset 22 [-Warray-bounds]
>>
>> Refactor the code, accordingly:
>>
>> $ pahole -C wl3501_req drivers/net/wireless/wl3501_cs.o
>> struct wl3501_req {
>>         u16                        beacon_period;        /*     0     2 */
>>         u16                        dtim_period;          /*     2     2 */
>>         u16                        cap_info;             /*     4     2 */
>>         u8                         bss_type;             /*     6     1 */
>>         u8                         bssid[6];             /*     7     6 */
>>         struct iw_mgmt_essid_pset  ssid;                 /*    13    34 */
>>         struct iw_mgmt_ds_pset     ds_pset;              /*    47     3 */
>>         struct iw_mgmt_cf_pset     cf_pset;              /*    50     8 */
>>         struct iw_mgmt_ibss_pset   ibss_pset;            /*    58     4 */
>>         struct iw_mgmt_data_rset   bss_basic_rset;       /*    62    10 */
>>
>>         /* size: 72, cachelines: 2, members: 10 */
>>         /* last cacheline: 8 bytes */
>> };
>>
>> $ pahole -C wl3501_join_req drivers/net/wireless/wl3501_cs.o
>> struct wl3501_join_req {
>>         u16                        next_blk;             /*     0     2 */
>>         u8                         sig_id;               /*     2     1 */
>>         u8                         reserved;             /*     3     1 */
>>         struct iw_mgmt_data_rset   operational_rset;     /*     4    10 */
>>         u16                        reserved2;            /*    14     2 */
>>         u16                        timeout;              /*    16     2 */
>>         u16                        probe_delay;          /*    18     2 */
>>         u8                         timestamp[8];         /*    20     8 */
>>         u8                         local_time[8];        /*    28     8 */
>>         struct wl3501_req          req;                  /*    36    72 */
>>
>>         /* size: 108, cachelines: 2, members: 10 */
>>         /* last cacheline: 44 bytes */
>> };
>>
>> $ pahole -C wl3501_scan_confirm drivers/net/wireless/wl3501_cs.o
>> struct wl3501_scan_confirm {
>>         u16                        next_blk;             /*     0     2 */
>>         u8                         sig_id;               /*     2     1 */
>>         u8                         reserved;             /*     3     1 */
>>         u16                        status;               /*     4     2 */
>>         char                       timestamp[8];         /*     6     8 */
>>         char                       localtime[8];         /*    14     8 */
>>         struct wl3501_req          req;                  /*    22    72 */
>>         /* --- cacheline 1 boundary (64 bytes) was 30 bytes ago --- */
>>         u8                         rssi;                 /*    94     1 */
>>
>>         /* size: 96, cachelines: 2, members: 8 */
>>         /* padding: 1 */
>>         /* last cacheline: 32 bytes */
>> };
>>
>> The problem is that the original code is trying to copy data into a
>> bunch of struct members adjacent to each other in a single call to
>> memcpy(). Now that a new struct wl3501_req enclosing all those adjacent
>> members is introduced, memcpy() doesn't overrun the length of
>> &sig.beacon_period and &this->bss_set[i].beacon_period, because the
>> address of the new struct object _req_ is used as the destination,
>> instead.
>>
>> This helps with the ongoing efforts to globally enable -Warray-bounds
>> and get us closer to being able to tighten the FORTIFY_SOURCE routines
>> on memcpy().
>>
>> Link: https://github.com/KSPP/linux/issues/109
>> Reported-by: kernel test robot <lkp@intel.com>
>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> 
> Awesome! Thank you for this solution.
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>


Thanks, Kees!

--
Gustavo

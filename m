Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C73368287
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 16:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236439AbhDVOj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 10:39:58 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:48208 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236341AbhDVOj5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 10:39:57 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1619102363; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=RMf3EFzLqxN1uAcl/snGb/NnTMeGSO6NhHpgmnX57QQ=;
 b=aXlitrkdDQBmUDEhQc2ri0n62F6L0XiPwYv4Jm96F/A8jCjjaVbqqaly173bFQlGE0Ncf7qu
 XzgOni4llkpmUJKYACYtXXjL65V5nOf/NFy5Dw6lVMruBU5orLv3bFvYlrNGGEosfNhDmZ/X
 SD6egHeGc22i7CshOxPHMBqjKxs=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 60818a8f2cbba8898039bc19 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 22 Apr 2021 14:39:11
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id DCAC0C433F1; Thu, 22 Apr 2021 14:39:10 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DDE4FC433F1;
        Thu, 22 Apr 2021 14:39:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DDE4FC433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 1/2] wl3501_cs: Fix out-of-bounds warnings in
 wl3501_send_pkt
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <d260fe56aed7112bff2be5b4d152d03ad7b78e78.1618442265.git.gustavoars@kernel.org>
References: <d260fe56aed7112bff2be5b4d152d03ad7b78e78.1618442265.git.gustavoars@kernel.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kees Cook <keescook@chromium.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210422143910.DCAC0C433F1@smtp.codeaurora.org>
Date:   Thu, 22 Apr 2021 14:39:10 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavoars@kernel.org> wrote:

> Fix the following out-of-bounds warnings by enclosing structure members
> daddr and saddr into new struct addr, in structures wl3501_md_req and
> wl3501_md_ind:
> 
> arch/x86/include/asm/string_32.h:182:25: warning: '__builtin_memcpy' offset [18, 23] from the object at 'sig' is out of the bounds of referenced subobject 'daddr' with type 'u8[6]' {aka 'unsigned char[6]'} at offset 11 [-Warray-bounds]
> arch/x86/include/asm/string_32.h:182:25: warning: '__builtin_memcpy' offset [18, 23] from the object at 'sig' is out of the bounds of referenced subobject 'daddr' with type 'u8[6]' {aka 'unsigned char[6]'} at offset 11 [-Warray-bounds]
> 
> Refactor the code, accordingly:
> 
> $ pahole -C wl3501_md_req drivers/net/wireless/wl3501_cs.o
> struct wl3501_md_req {
> 	u16                        next_blk;             /*     0     2 */
> 	u8                         sig_id;               /*     2     1 */
> 	u8                         routing;              /*     3     1 */
> 	u16                        data;                 /*     4     2 */
> 	u16                        size;                 /*     6     2 */
> 	u8                         pri;                  /*     8     1 */
> 	u8                         service_class;        /*     9     1 */
> 	struct {
> 		u8                 daddr[6];             /*    10     6 */
> 		u8                 saddr[6];             /*    16     6 */
> 	} addr;                                          /*    10    12 */
> 
> 	/* size: 22, cachelines: 1, members: 8 */
> 	/* last cacheline: 22 bytes */
> };
> 
> $ pahole -C wl3501_md_ind drivers/net/wireless/wl3501_cs.o
> struct wl3501_md_ind {
> 	u16                        next_blk;             /*     0     2 */
> 	u8                         sig_id;               /*     2     1 */
> 	u8                         routing;              /*     3     1 */
> 	u16                        data;                 /*     4     2 */
> 	u16                        size;                 /*     6     2 */
> 	u8                         reception;            /*     8     1 */
> 	u8                         pri;                  /*     9     1 */
> 	u8                         service_class;        /*    10     1 */
> 	struct {
> 		u8                 daddr[6];             /*    11     6 */
> 		u8                 saddr[6];             /*    17     6 */
> 	} addr;                                          /*    11    12 */
> 
> 	/* size: 24, cachelines: 1, members: 9 */
> 	/* padding: 1 */
> 	/* last cacheline: 24 bytes */
> };
> 
> The problem is that the original code is trying to copy data into a
> couple of arrays adjacent to each other in a single call to memcpy().
> Now that a new struct _addr_ enclosing those two adjacent arrays
> is introduced, memcpy() doesn't overrun the length of &sig.daddr[0]
> and &sig.daddr, because the address of the new struct object _addr_
> is used, instead.
> 
> This helps with the ongoing efforts to globally enable -Warray-bounds
> and get us closer to being able to tighten the FORTIFY_SOURCE routines
> on memcpy().
> 
> Link: https://github.com/KSPP/linux/issues/109
> Reported-by: kernel test robot <lkp@intel.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

2 patches applied to wireless-drivers-next.git, thanks.

820aa37638a2 wl3501_cs: Fix out-of-bounds warnings in wl3501_send_pkt
bb43e5718d8f wl3501_cs: Fix out-of-bounds warnings in wl3501_mgmt_join

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/d260fe56aed7112bff2be5b4d152d03ad7b78e78.1618442265.git.gustavoars@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


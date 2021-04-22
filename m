Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 254AB368696
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 20:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236832AbhDVScy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 14:32:54 -0400
Received: from gateway34.websitewelcome.com ([192.185.148.212]:45807 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236058AbhDVScx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 14:32:53 -0400
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id 0ABB3575340
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 13:32:14 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id Ze5dlON3e1cHeZe5dlUVcf; Thu, 22 Apr 2021 13:30:13 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Gj4ZzlY1opy7V2GETXx3MyvWl67CzzjHj9tWMTMO6zc=; b=MEpJteWQLmz2N2caWwYhuetppY
        8mI9RWs7QeTbds9avFafYF5jaaoNj1g2xEPqyBWIn7ik7FxdR5/ah6neRNInuoUEB8qjvaoH69VDT
        1bsOKe7fv/hV7x0aSxvL4Il6FQ4FKMlykaGgeaPcBeM5++zkC4z5jO13leZKf0fYFFlhaWqhKASeh
        m7PnmDco9IvjDq6UXXxn0mQ4v3zgo0T7JhBzEsqplAcWS1rA6g6c9HPuATRn0AvIbrnaN9b5t6lRc
        9XZSgK+xdZSZqAeLlfLVxjazVmHFQeUhr8znCTPPlTIS+4ba8EuxALHZ1Io7/fkhb4MXNNx56Ru9V
        D9GybQaw==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:57122 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lZe5Z-001KxQ-Rm; Thu, 22 Apr 2021 13:30:09 -0500
Subject: Re: [PATCH v3 1/2] wl3501_cs: Fix out-of-bounds warnings in
 wl3501_send_pkt
To:     Kalle Valo <kvalo@codeaurora.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org, Kees Cook <keescook@chromium.org>
References: <d260fe56aed7112bff2be5b4d152d03ad7b78e78.1618442265.git.gustavoars@kernel.org>
 <20210422143910.C8B5CC4338A@smtp.codeaurora.org>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <83e2efc6-2bdf-ddfb-8322-3b9536fc1644@embeddedor.com>
Date:   Thu, 22 Apr 2021 13:30:28 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210422143910.C8B5CC4338A@smtp.codeaurora.org>
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
X-Exim-ID: 1lZe5Z-001KxQ-Rm
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:57122
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 7
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/22/21 09:39, Kalle Valo wrote:
> 2 patches applied to wireless-drivers-next.git, thanks.
> 
> 820aa37638a2 wl3501_cs: Fix out-of-bounds warnings in wl3501_send_pkt
> bb43e5718d8f wl3501_cs: Fix out-of-bounds warnings in wl3501_mgmt_join

Thanks, Kalle.

--
Gustavo

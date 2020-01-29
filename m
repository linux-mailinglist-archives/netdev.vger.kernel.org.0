Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 768DA14C503
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 04:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgA2Ddi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 22:33:38 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:58356 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgA2Ddi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jan 2020 22:33:38 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00T3Tx3e146994;
        Wed, 29 Jan 2020 03:33:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=42Bo2wE+18rQA1Qrpy2TSg/n/Z0kbYx5tfLbkLnb3ew=;
 b=TkPs2fvUXMYb/IBbpXtrsXzPdH60YL7sgbYFkXC1pT9i7OxXkDyYDH9ar4Fw6GjnBRbP
 XALYlcELWpe9iRrhzi9f2Jm4Tuc5y2+Gv5LT8vPJ9zZhOT6HCrBMjBSWgbyDTuMQ5PLb
 ODUNZtwRgBvBWiWJ53wc3P/HvkVqNtBmOqWHR3vdZCEHH+DvxdJ6F+FHvJx/Loo0x9Hc
 RdLRWHrHBkIzXliC9Ybn853Q5shLLM3f4fx+UhLS43ox6hs2FUobaqSWrr+sSDgvRqQ4
 JlTW652Kxkh4lga+rYzkqBVD3G52PbwnvI7QXuUNl+WM4AZ+1GGYkYLDRJKbRFVo78BG MA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xreara7ae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Jan 2020 03:33:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00T3TskG135413;
        Wed, 29 Jan 2020 03:33:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2xth5j62cx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Jan 2020 03:33:10 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00T3X91n017814;
        Wed, 29 Jan 2020 03:33:09 GMT
Received: from kadam (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Jan 2020 19:33:08 -0800
Date:   Wed, 29 Jan 2020 06:32:57 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>,
        Brian Norris <briannorris@chromium.org>,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH] brcmfmac: abort and release host after error
Message-ID: <20200129033257.GC1754@kadam>
References: <20200128221457.12467-1-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200128221457.12467-1-linux@roeck-us.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9514 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001290027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9514 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001290027
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 28, 2020 at 02:14:57PM -0800, Guenter Roeck wrote:
> With commit 216b44000ada ("brcmfmac: Fix use after free in
> brcmf_sdio_readframes()") applied, we see locking timeouts in
> brcmf_sdio_watchdog_thread().
> 
> brcmfmac: brcmf_escan_timeout: timer expired
> INFO: task brcmf_wdog/mmc1:621 blocked for more than 120 seconds.
> Not tainted 4.19.94-07984-g24ff99a0f713 #1
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> brcmf_wdog/mmc1 D    0   621      2 0x00000000 last_sleep: 2440793077.  last_runnable: 2440766827
> [<c0aa1e60>] (__schedule) from [<c0aa2100>] (schedule+0x98/0xc4)
> [<c0aa2100>] (schedule) from [<c0853830>] (__mmc_claim_host+0x154/0x274)
> [<c0853830>] (__mmc_claim_host) from [<bf10c5b8>] (brcmf_sdio_watchdog_thread+0x1b0/0x1f8 [brcmfmac])
> [<bf10c5b8>] (brcmf_sdio_watchdog_thread [brcmfmac]) from [<c02570b8>] (kthread+0x178/0x180)
> 
> In addition to restarting or exiting the loop, it is also necessary to
> abort the command and to release the host.
> 
> Fixes: 216b44000ada ("brcmfmac: Fix use after free in brcmf_sdio_readframes()")

Huh...  Thanks for fixing the bug.  That seems to indicate that we were
triggering the use after free but no one noticed at runtime.  With
kfree(), a use after free can be harmless if you don't have poisoning
enabled and no other thread has re-used the memory.  I'm not sure about
kfree_skb() but presumably it's the same.

Acked-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter


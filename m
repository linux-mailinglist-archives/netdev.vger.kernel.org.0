Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF4314C526
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 05:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgA2ERn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 23:17:43 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:45706 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbgA2ERn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jan 2020 23:17:43 -0500
Received: by mail-yb1-f193.google.com with SMTP id x191so8079673ybg.12;
        Tue, 28 Jan 2020 20:17:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YgN2vJdNk1lL2IID1Scb4JgUP1haIp4B4zNHK5VBexM=;
        b=HZohCZp8ZN9vFhOZgrf/KLupunbdQWYsFXlPefiGgT0P9W9sYk4bfS1qGWcet0bVRe
         xkaAvFHA/i9ENPRV7O+Eb9qs65WDFIqLGt4712EM2CdtxN95Ymv9drvaTybsQ7pQ7kEV
         eO62COFCNiXiBgskB2F2avqc6rDDBVBK1Gp/SPf7y00FDbXeCpKmkG1keD1gq02nBA1d
         dMjbNKjZ+Shz9qWayoYUhxt1FDt9XC0y+npfxFTC63+G/DgLwzWsQ80KAkFCpHers6bm
         nZjDxTeP+lfUUR9I6WZBhmNF+d+jN9KWX4mn+UxDHp/Lm6Sr+DnW4euNch20ZvaivXiO
         ikVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YgN2vJdNk1lL2IID1Scb4JgUP1haIp4B4zNHK5VBexM=;
        b=uAURAZYOjsGcfgxzio7FWv69iFCdKuwNpgoCi+sYjP2UALnjcsJdZ+0CpTPPvtK00n
         aKvx2P5IZYmtIkpMmdPY0zmUsstx+xBGqIuy0IsdS3xeFb0ufm1jNmP4XaIQ50qB5MUH
         ikHWjSnaJ4jkZS3p73Tkg2bcUl3RHIIqjLQidK5r9VE3L/3ngj2cH9yvlLBkWHS2rTVv
         NqsU4l0m9HrNyPnN/5MHnmO3Rf8PEpOMSt8gr4jMs11DHF5RbWueo9CJhmVrH6pdpFhd
         W3gHtNkQRvWFPwzkB7+cbOZ6Gew0Vs2CMhyfZAEhSsmbwxvmfTEVEqeGhanUkLX4fNni
         htew==
X-Gm-Message-State: APjAAAUE920N+7MPFd+Vxo0McidaMIDph4NBG37EW7Kqay0rq1hMH6S5
        LucSaEtOTGjboXD0+076mJ4vINmw
X-Google-Smtp-Source: APXvYqzBrkPShoR+ShGfyr94vYImAiHD+5VC/An9AX/npCHND/fCueWVOdnbCq+cKoNY7bXtO18Lbw==
X-Received: by 2002:a25:d156:: with SMTP id i83mr18620000ybg.254.1580271462331;
        Tue, 28 Jan 2020 20:17:42 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e186sm450145ywb.73.2020.01.28.20.17.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2020 20:17:41 -0800 (PST)
Subject: Re: [PATCH] brcmfmac: abort and release host after error
To:     Dan Carpenter <dan.carpenter@oracle.com>
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
References: <20200128221457.12467-1-linux@roeck-us.net>
 <20200129033257.GC1754@kadam>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <f9f1dfab-2c48-f37b-836b-6dc7fa5bc801@roeck-us.net>
Date:   Tue, 28 Jan 2020 20:17:39 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200129033257.GC1754@kadam>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/28/20 7:32 PM, Dan Carpenter wrote:
> On Tue, Jan 28, 2020 at 02:14:57PM -0800, Guenter Roeck wrote:
>> With commit 216b44000ada ("brcmfmac: Fix use after free in
>> brcmf_sdio_readframes()") applied, we see locking timeouts in
>> brcmf_sdio_watchdog_thread().
>>
>> brcmfmac: brcmf_escan_timeout: timer expired
>> INFO: task brcmf_wdog/mmc1:621 blocked for more than 120 seconds.
>> Not tainted 4.19.94-07984-g24ff99a0f713 #1
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> brcmf_wdog/mmc1 D    0   621      2 0x00000000 last_sleep: 2440793077.  last_runnable: 2440766827
>> [<c0aa1e60>] (__schedule) from [<c0aa2100>] (schedule+0x98/0xc4)
>> [<c0aa2100>] (schedule) from [<c0853830>] (__mmc_claim_host+0x154/0x274)
>> [<c0853830>] (__mmc_claim_host) from [<bf10c5b8>] (brcmf_sdio_watchdog_thread+0x1b0/0x1f8 [brcmfmac])
>> [<bf10c5b8>] (brcmf_sdio_watchdog_thread [brcmfmac]) from [<c02570b8>] (kthread+0x178/0x180)
>>
>> In addition to restarting or exiting the loop, it is also necessary to
>> abort the command and to release the host.
>>
>> Fixes: 216b44000ada ("brcmfmac: Fix use after free in brcmf_sdio_readframes()")
> 
> Huh...  Thanks for fixing the bug.  That seems to indicate that we were
> triggering the use after free but no one noticed at runtime.  With

Actually, we did see the problem. We just didn't realize it.

> kfree(), a use after free can be harmless if you don't have poisoning
> enabled and no other thread has re-used the memory.  I'm not sure about
> kfree_skb() but presumably it's the same.
> 

Not really; it ultimately does result in a crash. We see that in ChromeOS
R80 (and probably in all earlier releases, but I didn't check), which does
not (yet) include 216b44000ada. The upcoming R81, which does include
216b44000ada, doesn't crash but there are lots of stalls like the one
above. The combination of both (ie the difference in behavior) helped
tracking down the problem.

Guenter

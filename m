Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCBB24A581B
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 08:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235247AbiBAHvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 02:51:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234355AbiBAHvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 02:51:38 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3B4DC061714;
        Mon, 31 Jan 2022 23:51:38 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id o64so16366675pjo.2;
        Mon, 31 Jan 2022 23:51:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=EgFo9ghDi1FqlXmS0tqqUfR+YTv3A1qP6YjpJ5SdGs4=;
        b=MzCFBVr9tw3Mbk9jsA9GWZSlDw7uVe2T+SDT1T2Yb/1woqWGpTgpz9n1nTj/1MEjLA
         xJS3uA+zVLriZi1Emc8tBO/+WalEJTJ3OraYh2aa5ryThSPaE4QP/CfyHgHJFheQIVZj
         xVxoK11XToKt4TlfvFFBPzBNkukPDTxEy9qZL/mcBkdlhTkMOvrPF1BxVXqluP04qzTg
         LOtybm2gzIf984S+dkpEMiZVAHK17M139Af2ekd8kC95uvx/1MFeWjKY701HGT5zj1qF
         ZOoXa8eRQspeeakcyC8h0UtkqrScNiVXrLDYWAjvupqzxn6/XDrlYu9H/k4sgVRTATSH
         ay3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=EgFo9ghDi1FqlXmS0tqqUfR+YTv3A1qP6YjpJ5SdGs4=;
        b=bUrJR4KhOEEEdUR+2LNbQXFz9MQyGur1RxapH3gaDiEL6SebJ8SWnJ5Tp8b9Mwo4/L
         pxgISWCzc1Nh+niyKx3DNzD9LlVH792OXsyXGAImC8p6enhnBJSTMoiiYrciXC8Cv/QG
         VqFOitQ3BXFNidFNgmQtb1qeGw3gaNyt0DxtAk+E2o0ihn5X7/zkxseSUrvt8RIapQ0Q
         c4t3JXSVxZ1qZGiWMfMbe+lRD3yFAiiDkLBRP8XZtExafFQrJu2J1+AMhK1bX8nXEuCr
         uHIOn8h+97S5yoyBE5VD3QrGbfhGGVqvtlOtLOrTR3K5llGk8bk7Zj+obDgr0dDYFCQR
         UjEA==
X-Gm-Message-State: AOAM531CImhjP20Ku+z0w7CIFc5n5kQihvNUEPEnC7bcROoSlL7pc/mn
        G/glNUKEuDZci7KteZjnahlSLd2aZXk=
X-Google-Smtp-Source: ABdhPJy6oExljg421lAf8gS7yetpxTbKsezH3mkNHDxnn0qRFskEBAkjT4QeiItL3SeNuiVHFONmlQ==
X-Received: by 2002:a17:90a:7a8a:: with SMTP id q10mr908260pjf.55.1643701898019;
        Mon, 31 Jan 2022 23:51:38 -0800 (PST)
Received: from [10.59.0.6] ([85.203.23.80])
        by smtp.gmail.com with ESMTPSA id 9sm1634502pjl.55.2022.01.31.23.51.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 23:51:37 -0800 (PST)
To:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [BUG] net: smc: possible deadlock in smc_lgr_free() and
 smc_link_down_work()
Message-ID: <11fe65b8-eda4-121e-ec32-378b918d0909@gmail.com>
Date:   Tue, 1 Feb 2022 15:51:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

My static analysis tool reports a possible deadlock in the smc module in 
Linux 5.16:

smc_lgr_free()
   mutex_lock(&lgr->llc_conf_mutex); --> Line 1289 (Lock A)
   smcr_link_clear()
     smc_wr_free_link()
       wait_event(lnk->wr_tx_wait, ...); --> Line 648 (Wait X)

smc_link_down_work()
   mutex_lock(&lgr->llc_conf_mutex); --> Line 1683 (Lock A)
   smcr_link_down()
     smcr_link_clear()
       smc_wr_free_link()
         smc_wr_wakeup_tx_wait()
           wake_up_all(&lnk->wr_tx_wait); --> Line 78 (Wake X)

When smc_lgr_free() is executed, "Wait X" is performed by holding "Lock 
A". If smc_link_down_work() is executed at this time, "Wake X" cannot be 
performed to wake up "Wait X" in smc_lgr_free(), because "Lock A" has 
been already hold by smc_lgr_free(), causing a possible deadlock.

I am not quite sure whether this possible problem is real and how to fix 
it if it is real.
Any feedback would be appreciated, thanks :)


Best wishes,
Jia-Ju Bai

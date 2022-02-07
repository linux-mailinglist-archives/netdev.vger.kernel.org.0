Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A465E4AC26A
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 16:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbiBGPFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 10:05:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357897AbiBGOnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 09:43:22 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD99C0401C1;
        Mon,  7 Feb 2022 06:43:21 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id k6-20020a05600c1c8600b003524656034cso8770347wms.2;
        Mon, 07 Feb 2022 06:43:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:from
         :subject:to:cc:content-transfer-encoding;
        bh=famgy1A8L+ToRkAyENV+McfNirl7jFVzrN+RraW04kE=;
        b=qSgTfodziXuXLofePjexnonr+M4sEOJVYPL5m1iO6Bm3MZvPhTZCR8MPZXCFHHC36f
         9N6823Wbkx8qHp22rMT3XXsCcjsrP0+VraSRiId8Pg2cakCW/iH2rysds60TX1u0uiSP
         XKevAO4utvzu1q69KoVan4F9xyn63Bh+sJFzA9QHlzJj5GXZ8Ds1JTAP5V8q7jQcsWC9
         /GJipRlOk2ri7qbqaS31+ZPdevTLlYS+am6pIG0DW+GFwS/8ayKnVLkZpq9dIf3e6jk3
         j/YdeeF0HZpwA7C+GerDkKwqNOBQPiA+HER1BBs+q7eMYtBNzTFwQAVNWgGHxiK70+oX
         1rkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:from:subject:to:cc:content-transfer-encoding;
        bh=famgy1A8L+ToRkAyENV+McfNirl7jFVzrN+RraW04kE=;
        b=0MSD7ljoUT1mOkYRA3//mSUu9+KCo4zaR+6d/54RwPFBjNLpbXG5LfqicvnxpjPVcQ
         3CrCAfhaO2WAoNOsWySU0CnDVFrTAk0APgs0mpwFHZHOmHldPOgocs8s32DhHUC5BHFG
         Wv0guI5A4cN+L9qzjXG1CvOcvClRmoVaAsaa4yZrQy5ZQkf/VEjkokyug2438CS/7VZw
         k3L5nlAgal2IXIXeXBigMHx8X/smnEoQ6ZugVOhIAftwsSTRP9bRar6CFEz15XnkyKBY
         lAQIuzxfEfFYKW303A894npFV63lNgMqC3RCoZhsnrzZHz0tNZ3t1DCl7DWbqBGZRFCf
         PKSw==
X-Gm-Message-State: AOAM532GAt9d0GEIBcU+58gMecSRhTFj4A5jitXNMXKrKfKoJ5oZY+lP
        ICscJgT9yBfasH9aUE0RDAs=
X-Google-Smtp-Source: ABdhPJzYKUJah/gYGIdplwDUDb/rtC99YtEpETNGrhz9Gc0qdI2aZAGIWENFkc/yTQ6EEFUC4D6FtA==
X-Received: by 2002:a05:600c:4e05:: with SMTP id b5mr15116815wmq.191.1644244999889;
        Mon, 07 Feb 2022 06:43:19 -0800 (PST)
Received: from [10.143.0.6] ([64.64.123.91])
        by smtp.gmail.com with ESMTPSA id ay29sm9405853wmb.38.2022.02.07.06.43.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 06:43:19 -0800 (PST)
Message-ID: <1f27fa76-49b9-6b53-de71-d72d076bb745@gmail.com>
Date:   Mon, 7 Feb 2022 22:43:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Content-Language: en-US
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [BUG] net: ti: possible deadlock in cpts_ptp_gettimeex() and
 cpts_overflow_check()
To:     davem@davemloft.net, kuba@kernel.org, grygorii.strashko@ti.com,
        vladimir.oltean@nxp.com, vigneshr@ti.com, yangyingliang@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

My static analysis tool reports a possible deadlock in the ti driver in 
Linux 5.16:

cpts_ptp_gettimeex()
   mutex_lock(&cpts->ptp_clk_mutex); --> Line 260 (Lock A)
   cpts_update_cur_time()
     wait_for_completion_timeout(&cpts->ts_push_complete, HZ); --> Line 
210 (Wait X)

cpts_overflow_check()
   mutex_lock(&cpts->ptp_clk_mutex); --> Line 411 (Lock A)
   cpts_update_cur_time()
     cpts_fifo_read()
       complete(&cpts->ts_push_complete); --> Line 142 (Wake X)

When cpts_ptp_gettimeex() is executed, "Wait X" is performed by holding 
"Lock A". If cpts_overflow_check() is executed at this time, "Wake X" 
cannot be performed to wake up "Wait X" in cpts_ptp_gettimeex(), because 
"Lock A" has been already hold by cpts_ptp_gettimeex(), causing a 
possible deadlock.
I find that "Wait X" is performed with a timeout, to relieve the 
possible deadlock; but I think this timeout can cause inefficient execution.

I am not quite sure whether this possible problem is real and how to fix 
it if it is real.
Any feedback would be appreciated, thanks :)


Best wishes,
Jia-Ju Bai


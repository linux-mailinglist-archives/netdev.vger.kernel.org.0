Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F94516AC8
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 08:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349750AbiEBGPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 02:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234943AbiEBGPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 02:15:16 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B43186E1;
        Sun,  1 May 2022 23:11:47 -0700 (PDT)
Received: from fsav120.sakura.ne.jp (fsav120.sakura.ne.jp [27.133.134.247])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 2426AuKX097578;
        Mon, 2 May 2022 15:10:56 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav120.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav120.sakura.ne.jp);
 Mon, 02 May 2022 15:10:56 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav120.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 2426At4s097573
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 2 May 2022 15:10:55 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <5fd22dda-01d6-cfae-3458-cb3fa23eb84d@I-love.SAKURA.ne.jp>
Date:   Mon, 2 May 2022 15:10:50 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v3 1/2] ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
Content-Language: en-US
To:     Pavel Skripkin <paskripkin@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        ath9k-devel@qca.qualcomm.com, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, linville@tuxdriver.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+03110230a11411024147@syzkaller.appspotmail.com,
        syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
References: <80962aae265995d1cdb724f5362c556d494c7566.1644265120.git.paskripkin@gmail.com>
 <87h799a007.fsf@toke.dk> <6f0615da-aa0b-df8e-589c-f5caf09d3449@gmail.com>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <6f0615da-aa0b-df8e-589c-f5caf09d3449@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/02/09 0:48, Pavel Skripkin wrote:
>> ath9k_htc_suspend()
>> ath9k_htc_resume()
>> ath9k_hif_usb_disconnect()
>>
>> What guarantees that none of these will be called midway through
>> ath9k_htc_probe_device() (which would lead to a NULL deref after this
>> change)?
>>
> 
> IIUC, situation you are talking about may happen even without my change.
> I was thinking, that ath9k_htc_probe_device() is the real ->probe() function, but things look a bit more tricky.
> 
> 
> So, the ->probe() function may be completed before ath9k_htc_probe_device()
> is called, because it's called from fw loader callback function.

Yes, ath9k_hif_usb_probe() may return before complete_all(&hif_dev->fw_done)
is called by ath9k_hif_usb_firmware_cb() or ath9k_hif_usb_firmware_fail().

> If ->probe() is completed, than we can call ->suspend(), ->resume() and
> others usb callbacks, right?

Yes, but ath9k_hif_usb_disconnect() and ath9k_hif_usb_suspend() are calling
wait_for_completion(&hif_dev->fw_done) before checking HIF_USB_READY flag.
hif_dev->fw_done serves for serialization.

> And we can meet NULL defer even if we leave drv_priv = priv initialization
> on it's place.

I didn't catch the location. As long as "htc_handle->drv_priv = priv;" is done
before complete_all(&hif_dev->fw_done) is done, is something wrong?

> 
> Please, correct me if I am wrong somewhere :)

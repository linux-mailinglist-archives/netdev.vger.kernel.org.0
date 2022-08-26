Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7F3D5A1E37
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 03:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244546AbiHZBgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 21:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239559AbiHZBgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 21:36:09 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61798F67;
        Thu, 25 Aug 2022 18:36:08 -0700 (PDT)
Received: from fsav312.sakura.ne.jp (fsav312.sakura.ne.jp [153.120.85.143])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 27Q1ZkMG097748;
        Fri, 26 Aug 2022 10:35:46 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav312.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav312.sakura.ne.jp);
 Fri, 26 Aug 2022 10:35:46 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav312.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 27Q1ZiBd097736
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 26 Aug 2022 10:35:46 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <46fee955-a5fa-fbd6-bcc4-d9344e6801d9@I-love.SAKURA.ne.jp>
Date:   Fri, 26 Aug 2022 10:35:43 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: KMSAN: uninit-value in ath9k_htc_rx_msg
Content-Language: en-US
To:     Alexander Potapenko <glider@google.com>,
        ath9k-devel@qca.qualcomm.com
Cc:     phil@philpotter.co.uk, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
References: <000000000000c98a7f05ac744f53@google.com>
 <000000000000734fe705acb9f3a2@google.com>
 <a142d63c-7810-40ff-9c24-7160c63bafebn@googlegroups.com>
 <CAG_fn=U=Vfv3ymNM6W++sbivieQoUuXfAxsC9SsmdtQiTjSi8g@mail.gmail.com>
 <1a0b4d24-6903-464f-7af0-65c9788545af@I-love.SAKURA.ne.jp>
 <CAG_fn=Wq51FMbty4c_RwjBSFWS1oceL1rOAUzCyRnGEzajQRAg@mail.gmail.com>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <CAG_fn=Wq51FMbty4c_RwjBSFWS1oceL1rOAUzCyRnGEzajQRAg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/08/26 0:09, Alexander Potapenko wrote:
> On Thu, Aug 25, 2022 at 4:34 PM Tetsuo Handa
> <penguin-kernel@i-love.sakura.ne.jp> wrote:
>>
>> Hello.
> Hi Tetsuo,
> 
>> I found that your patch was applied. But since the reproducer tested only 0 byte
>> case, I think that rejecting only less than sizeof(struct htc_frame_hdr) bytes
>> is not sufficient.
>>
>> More complete patch with Ack from Toke is waiting at
>> https://lkml.kernel.org/r/7acfa1be-4b5c-b2ce-de43-95b0593fb3e5@I-love.SAKURA.ne.jp .
> 
> Thanks for letting me know! I just checked that your patch indeed
> fixes the issue I am facing.
> If it is more complete, I think we'd indeed better use yours.

I recognized that "ath9k: fix an uninit value use in ath9k_htc_rx_msg()" is
local to KMSAN tree.
https://github.com/google/kmsan/commit/d891e35583bf2e81ccc7a2ea548bf7cf47329f40

That patch needs to be dropped, for I confirmed that passing pad_len == 8 below
still triggers uninit value at ath9k_htc_fw_panic_report(). (My patch does not
trigger at ath9k_htc_fw_panic_report().)

        fd = syz_usb_connect_ath9k(3, 0x5a, 0x20000800, 0);
        *(uint16_t*)0x20000880 = 0 + pad_len;
        *(uint16_t*)0x20000882 = 0x4e00;
        memmove((uint8_t*)0x20000884, "\x99\x11\x22\x33\x00\x00\x00\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF", 16);
        syz_usb_ep_write(fd, 0x82, 4 + pad_len, 0x20000880);



Also, that patch has a skb leak bug; according to comment for ath9k_htc_rx_msg()

 * Service messages (Data, WMI) passed to the corresponding
 * endpoint RX handlers, which have to free the SKB.

, I think that this function is supposed to free skb if skb != NULL.

If dev_kfree_skb_any(skb) needs to be used when epid is invalid and pipe_id != USB_REG_IN_PIPE,
why it is OK to use kfree_skb(skb) if epid == 0x99 and pipe_id != USB_REG_IN_PIPE ?

We don't call kfree_skb(skb) if 0 < epid < ENDPOINT_MAX and endpoint->ep_callbacks.rx == NULL.
Why it is OK not to call kfree_skb(skb) in that case?

Callers can't pass such combinations? I leave these questions to ath9k developers...


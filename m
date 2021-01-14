Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95BD2F5D3F
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 10:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbhANJZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 04:25:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727174AbhANJZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 04:25:16 -0500
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB5DC061786;
        Thu, 14 Jan 2021 01:24:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2uqg5pSRojZBo6w/FGO6uS669NIaxCuaEwl+DtcVLgI=; b=MZMILskZu+w7kBlmRGoaNKncmM
        y1maASYjvLIo6Bp3jZNfXsd7014BWXk649R8jFm5IYA99cb6JJ2OoVsOhPWvEQir5k2uB7MTZMEoj
        v1DLlNQo2/Bmqe2+jmlHhsK92jcO6zJEukKJ0OrqGZdP4kc9kStxqAAUVfCLjpjV3jtQ=;
Received: from p54ae91f2.dip0.t-ipconnect.de ([84.174.145.242] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1kzyrn-0004T9-UU; Thu, 14 Jan 2021 10:24:31 +0100
Subject: Re: [PATCH] mt76: Fix queue ID variable types after mcu queue split
To:     Kalle Valo <kvalo@codeaurora.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
References: <20201229211548.1348077-1-natechancellor@gmail.com>
 <20201231100918.GA1819773@computer-5.station> <87k0sjlwyb.fsf@codeaurora.org>
From:   Felix Fietkau <nbd@nbd.name>
Message-ID: <9af48c35-c987-7eb4-e3a1-5e54555f988b@nbd.name>
Date:   Thu, 14 Jan 2021 10:24:30 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <87k0sjlwyb.fsf@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-11 09:06, Kalle Valo wrote:
> Lorenzo Bianconi <lorenzo@kernel.org> writes:
> 
>>> Clang warns in both mt7615 and mt7915:
>>> 
>>> drivers/net/wireless/mediatek/mt76/mt7915/mcu.c:271:9: warning: implicit
>>> conversion from enumeration type 'enum mt76_mcuq_id' to different
>>> enumeration type 'enum mt76_txq_id' [-Wenum-conversion]
>>>                 txq = MT_MCUQ_FWDL;
>>>                     ~ ^~~~~~~~~~~~
>>> drivers/net/wireless/mediatek/mt76/mt7915/mcu.c:278:9: warning: implicit
>>> conversion from enumeration type 'enum mt76_mcuq_id' to different
>>> enumeration type 'enum mt76_txq_id' [-Wenum-conversion]
>>>                 txq = MT_MCUQ_WA;
>>>                     ~ ^~~~~~~~~~
>>> drivers/net/wireless/mediatek/mt76/mt7915/mcu.c:282:9: warning: implicit
>>> conversion from enumeration type 'enum mt76_mcuq_id' to different
>>> enumeration type 'enum mt76_txq_id' [-Wenum-conversion]
>>>                 txq = MT_MCUQ_WM;
>>>                     ~ ^~~~~~~~~~
>>> 3 warnings generated.
>>> 
>>> drivers/net/wireless/mediatek/mt76/mt7615/mcu.c:238:9: warning: implicit
>>> conversion from enumeration type 'enum mt76_mcuq_id' to different
>>> enumeration type 'enum mt76_txq_id' [-Wenum-conversion]
>>>                 qid = MT_MCUQ_WM;
>>>                     ~ ^~~~~~~~~~
>>> drivers/net/wireless/mediatek/mt76/mt7615/mcu.c:240:9: warning: implicit
>>> conversion from enumeration type 'enum mt76_mcuq_id' to different
>>> enumeration type 'enum mt76_txq_id' [-Wenum-conversion]
>>>                 qid = MT_MCUQ_FWDL;
>>>                     ~ ^~~~~~~~~~~~
>>> 2 warnings generated.
>>> 
>>> Use the proper type for the queue ID variables to fix these warnings.
>>> Additionally, rename the txq variable in mt7915_mcu_send_message to be
>>> more neutral like mt7615_mcu_send_message.
>>> 
>>> Fixes: e637763b606b ("mt76: move mcu queues to mt76_dev q_mcu array")
>>> Link: https://github.com/ClangBuiltLinux/linux/issues/1229
>>> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
>>
>> Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
> 
> I see that Felix already applied this, but as this is a regression
> starting from v5.11-rc1 I think it should be applied to
> wireless-drivers. Felix, can you drop this from your tree so that I
> could apply it to wireless-drivers?
Sure, will do.

- Felix


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC9E566E617
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 19:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232867AbjAQSdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 13:33:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbjAQSbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 13:31:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8F83A59C;
        Tue, 17 Jan 2023 10:01:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BDD2FB81911;
        Tue, 17 Jan 2023 18:01:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DED2C433F0;
        Tue, 17 Jan 2023 18:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673978500;
        bh=NmorhoADLZS3D1P4awZtp7xFvuzuOiaNOtn8kn5FuWo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=MaqLSI/cv6QgRbpcNh/Qv9EY7/8ZkBubcSg0j2BYaWLunhA49yWIEpqu97pJ8xAqs
         /kAhZju8LUM3o3ldWi6QLRXntwiF/RgFWkwEHwqCLMG7m3q2GZKBTZsDCVxedERI5M
         41HkddQvB6w4UmNN5RCZBwVY52kn8crfhuXeOR2AwhSaJ9rdLIf5wC20Lqj2wJU15E
         jtNgwDN89eHs61rR8kf6xrj3GdWtAaIhWElhvBmhxqzmBVz4zJPY88Db8yPBaszANU
         pTA52HqF+juhvsGCVhAhR72qMzZ7CAQkG2dtSufbUkZw48y27rQsjIKw4oYyyrSf8p
         hXDToHoBxp1Gg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, Chris Morgan <macroalpha82@gmail.com>,
        Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>, Pkshih <pkshih@realtek.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: Re: [RFC PATCH v1 00/19] rtw88: Add SDIO support
References: <20221227233020.284266-1-martin.blumenstingl@googlemail.com>
        <87y1q28o5a.fsf@kernel.org> <20230117092114.62ba2f66@kernel.org>
Date:   Tue, 17 Jan 2023 20:01:32 +0200
In-Reply-To: <20230117092114.62ba2f66@kernel.org> (Jakub Kicinski's message of
        "Tue, 17 Jan 2023 09:21:14 -0800")
Message-ID: <87k01lxcoz.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Mon, 16 Jan 2023 18:01:05 +0200 Kalle Valo wrote:
>> > - My understanding is that there's a discussion about the rtw88 Kconfig
>> >   symbols. We're adding four new ones within this series. It's not
>> >   clear to me what the conclusion is on this topic though.  
>> 
>> Yeah, there were no conclusions about that. Jakub, do you have any
>> opinions? For example, do we keep per device Kconfig options (eg.
>> CONFIG_RTW88_8822BS, RTW88_8822CS and so on) or should we have only one
>> more bus level option (eg. CONFIG_RTW88_SDIO)? rtw88 now uses the former
>> and IIRC so does mt76. ath10k/ath11k/ath12k again use the latter :)
>
> No strong feelings. Larry (IIRC) provided a fair justification for 
> the RTW symbols. If the module binary grows noticeably then having 
> the kconfig does indeed make sense.

Thanks, makes sense. So the plan is that rtw88 continues to use per
device Kconfig symbols with SDIO.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

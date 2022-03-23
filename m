Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECF74E4D5C
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 08:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242117AbiCWHdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 03:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232562AbiCWHdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 03:33:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DCF072E36;
        Wed, 23 Mar 2022 00:31:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 103FAB81DC9;
        Wed, 23 Mar 2022 07:31:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD96C340E8;
        Wed, 23 Mar 2022 07:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648020699;
        bh=xmpfDtMMsZeVIRw9r9g+fWtSN/SN5MNsLW7UTEV9McM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=IBCyqHOLXNrlbiOTOo8IH2EftaGeTKVcQ/ZTBEM2LBP+7wIATYSO+t32nlNxUsEUT
         WqPOxuJHQb6BtHqGEaBBf3rgFHB4V4PnK87T2PYd5BmB/9SkTLf1Jijx4kYXMLUkvg
         wa33664W3GEZGeZaIev6rwm/GxoTK2/++PTXCEmzqticobTTM5HRg8ZZiwPPrpXMqH
         ayRApnKFzE2ZbEahrHuk+9llMSlntJxRE5Ij+3T1VaolGU2MQs4qbjGlzEdexe/zFf
         TGpaPDDvAOczg67f/uvTxfUfJPmeXicB6E9uR5wXoUSqxCjLZdihV7Bjdo/UrCDP41
         BfrJOXhwdgxVw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        linux-wireless@vger.kernel.org,
        Andrejs Cainikovs <andrejs.cainikovs@toradex.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Jonas =?utf-8?Q?Dre=C3=9Fler?= <verdre@v0yd.nl>
Subject: Re: [RFC PATCH] mwifiex: Select firmware based on strapping
References: <20220321161003.39214-1-francesco.dolcini@toradex.com>
        <Yjjgi4YJVYBnJTqK@google.com>
Date:   Wed, 23 Mar 2022 09:31:32 +0200
In-Reply-To: <Yjjgi4YJVYBnJTqK@google.com> (Brian Norris's message of "Mon, 21
        Mar 2022 13:31:07 -0700")
Message-ID: <87zglhktuz.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Brian Norris <briannorris@chromium.org> writes:

>> --- a/drivers/net/wireless/marvell/mwifiex/sdio.h
>> +++ b/drivers/net/wireless/marvell/mwifiex/sdio.h
>> @@ -39,6 +39,7 @@
>>  #define SD8977_DEFAULT_FW_NAME "mrvl/sdsd8977_combo_v2.bin"
>>  #define SD8987_DEFAULT_FW_NAME "mrvl/sd8987_uapsta.bin"
>>  #define SD8997_DEFAULT_FW_NAME "mrvl/sdsd8997_combo_v4.bin"
>> +#define SD8997_SDIOUART_FW_NAME "nxp/sdiouart8997_combo_v4.bin"
>
> This isn't your main issue, but just because companies buy and sell IP
> doesn't mean we'll change the firmware paths. Qualcomm drivers still use
> "ath" prefixes, for one ;)
>
> Personally, I'd still keep the mrvl/ path. But that might be up to Kalle
> and/or linux-firmware.git maintainers.

I also prefer to have all the firmware files in the mrvl directory.

Actually I would prefer that each driver has it's own firmware
directory, but that's another topic.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

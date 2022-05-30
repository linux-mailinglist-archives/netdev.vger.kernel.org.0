Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D732537908
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 12:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235031AbiE3KHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 06:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiE3KHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 06:07:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFFC77A47D;
        Mon, 30 May 2022 03:07:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51AD761007;
        Mon, 30 May 2022 10:07:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D55AC34119;
        Mon, 30 May 2022 10:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653905254;
        bh=PM3fGM/2KDpEdmCfS2EzZkHoMTRHurmfq1JVpIRhyl4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=gcjaWJIxyQ0Shw9VjDMl2x+xgL93iVYQcPMyIqC21JOU6t0UohtXEWj7emx0TXM7F
         +cWJEoWHccJnCBXunuxdB5Brk/m01ESTi9PUPY5vTUz4pPfN0wqgEtsHNm/OP1ZCmX
         DizS8MIt7SYgp2uv97xnyfBnHlo6jpKp2YbfPiCMecazgBo5WTgbWFICDidPkqmdod
         7LA9T0O/HexhctDYfAOPq0XEAx4TufOpMrjCkKJ4QngJR3RpiQA205AW/sapDfN51J
         P7HnYjdPTkFaoDctgl+FY2wrZZEE54svv2UGBMBriA+eITw5o9MRh2huk/DYW2He1q
         jBXlnPPfcIVgA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     linux-wireless@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Hans Ulli Kroll <linux@ulli-kroll.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel@pengutronix.de, Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 00/10] RTW88: Add support for USB variants
References: <20220518082318.3898514-1-s.hauer@pengutronix.de>
        <87fskrv0cm.fsf@kernel.org> <20220530095232.GI1615@pengutronix.de>
Date:   Mon, 30 May 2022 13:07:25 +0300
In-Reply-To: <20220530095232.GI1615@pengutronix.de> (Sascha Hauer's message of
        "Mon, 30 May 2022 11:52:32 +0200")
Message-ID: <87a6azpc4i.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sascha Hauer <s.hauer@pengutronix.de> writes:

> On Mon, May 30, 2022 at 12:25:13PM +0300, Kalle Valo wrote:
>> Sascha Hauer <s.hauer@pengutronix.de> writes:
>> 
>> > Another problem to address is that the driver uses
>> > ieee80211_iterate_stations_atomic() and
>> > ieee80211_iterate_active_interfaces_atomic() and does register accesses
>> > in the iterator. This doesn't work with USB, so iteration is done in two
>> > steps now: The ieee80211_iterate_*_atomic() functions are only used to
>> > collect the stations/interfaces on a list which is then iterated over
>> > non-atomically in the second step. The implementation for this is
>> > basically the one suggested by Ping-Ke here:
>> >
>> > https://lore.kernel.org/lkml/423f474e15c948eda4db5bc9a50fd391@realtek.com/
>> 
>> Isn't this racy? What guarantees that vifs are not deleted after
>> ieee80211_iterate_active_interfaces_atomic() call?
>
> The driver mutex &rtwdev->mutex is acquired during the whole
> collection/iteration process. For deleting an interface
> ieee80211_ops::remove_interface would have to be called, right?
> That would acquire &rtwdev->mutex as well, so I think this should be
> safe.

Can you add a comment to the code explaining this? And
lockdep_assert_held() is a good way to guarantee that the mutex is
really held.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

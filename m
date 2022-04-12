Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5744FDEBF
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 13:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239352AbiDLL7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 07:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349365AbiDLL5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 07:57:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A6D60DB5;
        Tue, 12 Apr 2022 03:47:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CD02B81CBB;
        Tue, 12 Apr 2022 10:47:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C90C5C385A1;
        Tue, 12 Apr 2022 10:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649760424;
        bh=8nrqqM3IkuVaMYtRsABBZlIcS5QBrVTQAj/P3+5fYYI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=IFJ0f4ZD3Llfeaj09qoCE9fqavR0fqRwZhrOfd+ghn84ggQnDQE8GFnbmO08hqc8c
         JU2zcJpWxRU9xlS2+iOAJVmdlpFlYPlfjMaZ+TgCK19Tk0XJ4Xehrzzr0XlQGF9/Mm
         d/U1TWLuYMyucl59ci/bEKB6t+9Zu5cmuypNYgNrNXp/8dTfQd1FYIUgiJ/j5MoDyR
         D0llTsWIxesJzjKOrQy6NdDLgGXJE8RK2eUESE9sWSpQVCZ9xXaQDO/hyUmOQ8YWjo
         T/KN8c4LpQexG+qvay1ZBzDW2gRysRhGBVsJjK6plN+gbY/I5FgCgpoxQIt9r01whD
         mtGRjmuH7zPXg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Abhishek Kumar <kuabhs@chromium.org>
Cc:     Doug Anderson <dianders@chromium.org>,
        Rakesh Pillai <pillair@codeaurora.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        ath10k <ath10k@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: search for default BDF name provided in DT
References: <20220107200417.1.Ie4dcc45b0bf365077303c596891d460d716bb4c5@changeid>
        <CAD=FV=W5fHP8K-PcoYWxYHiDWnPUVQQzOzw=REbuJSSqGeVVfg@mail.gmail.com>
        <87sfrqqfzy.fsf@kernel.org>
        <CAD=FV=U0Qw-OnKJg8SWk9=e=B0qgqnaTHpuR0cRA0WCmSHSJYQ@mail.gmail.com>
        <CACTWRwtpYBokTehRE0_zSdSjio6Ga1yqdCfj1TNck7SqOT8o_Q@mail.gmail.com>
Date:   Tue, 12 Apr 2022 13:46:55 +0300
In-Reply-To: <CACTWRwtpYBokTehRE0_zSdSjio6Ga1yqdCfj1TNck7SqOT8o_Q@mail.gmail.com>
        (Abhishek Kumar's message of "Mon, 11 Apr 2022 16:25:10 -0700")
Message-ID: <87fsmio9y8.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Abhishek Kumar <kuabhs@chromium.org> writes:

> Hi All,
>
> Apologies for the late reply, too many things at the same time.

Trust me, I know the feeling :)

> Just a quick note, Qcomm provided a new BDF file with support for
> 'bus=snoc,qmi-board-id=ff' as well, so even without this patch, the
> non-programmed devices(with board-id=0xff) would work. However, for
> optimization of the BDF search strategy, the above mentioned strategy
> would still not work: - The stripping of full Board name would not
> work if board-id itself is not programmed i.e. =0xff e.g. for
> 'bus=snoc,qmi-board-id=ff,qmi-chip-id=320,variant=GO_LAZOR' => no
> match 'bus=snoc,qmi-board-id=ff,qmi-chip-id=320' => no match
> 'bus=snoc,qmi-board-id=ff' => no match 'bus=snoc' => no match because
> all the BDFs contains board-id=67

Sorry, not fully following your here. Are you saying that the problem is
that WCN3990/hw1.0/board-2.bin is missing board file for 'bus=snoc'?
That's easy to add, each board file within board-2.bin has multiple
names so we can easily select one board file for which we add
'bus=snoc'.

> So with this DT patch specifically for case 'bus=snoc,qmi-board-id=ff'
> => no match, we fallback to default case ( the one provided in DT)
> i.e. 'bus=snoc,qmi-board-id=67' => match . I do not see how exactly
> the driver can know that it should check for a board-id of 67.

Sorry, not following you here either. Why would the driver need to use
board-id 67?

> However, to still remove dependency on the DT, we can make the
> board-id as no-op if it is not programmed i.e. if the board-id=ff then
> we would pick any BDF that match 'bus=snoc,qmi-board-id=<XX>' where XX
> can be any arbitrary number. Thoughts ?

To me using just 'bus=snoc' is more logical than picking up an arbitrary
number. But I might be missing something here.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09F1F6F0265
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 10:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243009AbjD0IO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 04:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242966AbjD0IO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 04:14:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F7A540E7;
        Thu, 27 Apr 2023 01:14:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDFAD63AED;
        Thu, 27 Apr 2023 08:14:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11CB0C433EF;
        Thu, 27 Apr 2023 08:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682583266;
        bh=+LHYB0sYWaFSs3sPC1o7x7SZX0M3xmiNs6aa7zLUrE4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=RobXXTHtw4mF1N1taXMj3fApFuJruM49jiGKtK/M841vMC4hKq81KCjJFtmKo91nu
         Jr2ED18m/xtO8Tz1+U3gEA5tZ18HpYAcZBjImpet/ohjgbKDU5+CWD/FcwUzHmyvDW
         dJXcmn/QaH/zIS5HivkiFzckZaiI19IFHtkmTO7GQOoCHuEkQ+wpYTvoGo0ffyY/b3
         j1p+ZI2fHtcmCesWeYtCIcB/cGYkprKdQb49jw8OGpDk1T1A0WoUrkTOZrOqfHJEPg
         WI15VqXP0SjmuVjf/C/QaKCcpaVWQ1UJFFjckWL6W3IQCubeP890zKGJV4fJcE+3xw
         FaO87TRNSB5LA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] wifi: ath11k: Use list_count_nodes()
References: <941484caae24b89d20524b1a5661dd1fd7025492.1682542084.git.christophe.jaillet@wanadoo.fr>
        <87v8hiosci.fsf@kernel.org>
        <e05d4d4d33a2c50973d139752b4fcfad5dbdf056.camel@redhat.com>
Date:   Thu, 27 Apr 2023 11:14:19 +0300
In-Reply-To: <e05d4d4d33a2c50973d139752b4fcfad5dbdf056.camel@redhat.com>
        (Paolo Abeni's message of "Thu, 27 Apr 2023 09:07:34 +0200")
Message-ID: <87y1mdspwk.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paolo Abeni <pabeni@redhat.com> writes:

> On Thu, 2023-04-27 at 07:35 +0300, Kalle Valo wrote:
>
>> Christophe JAILLET <christophe.jaillet@wanadoo.fr> writes:
>> 
>> > ath11k_wmi_fw_stats_num_vdevs() and ath11k_wmi_fw_stats_num_bcn() really
>> > look the same as list_count_nodes(), so use the latter instead of hand
>> > writing it.
>> > 
>> > The first ones use list_for_each_entry() and the other list_for_each(), but
>> > they both count the number of nodes in the list.
>> > 
>> > While at it, also remove to prototypes of non-existent functions.
>> > Based on the names and prototypes, it is likely that they should be
>> > equivalent to list_count_nodes().
>> > 
>> > Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>> > ---
>> > Un-tested
>> 
>> I'll run sanity tests on ath11k patches. I'll also add "Compile tested
>> only" to the commit log.
>> 
>> Oh, and ath11k patches go to ath tree, not net-next.
>
> Just for awareness, there are 2 additional patches apparently targeting
> net-next but being instead for the WiFi tree:
>
> https://lore.kernel.org/all/e77ed7f719787cb8836a93b6a6972f4147e40bc6.1682537509.git.christophe.jaillet@wanadoo.fr/
> https://lore.kernel.org/all/e6ec525c0c5057e97e33a63f8a4aa482e5c2da7f.1682541872.git.christophe.jaillet@wanadoo.fr/

Thanks, these are on our wireless patchwork so you can drop them on your
end:

https://patchwork.kernel.org/project/linux-wireless/patch/e6ec525c0c5057e97e33a63f8a4aa482e5c2da7f.1682541872.git.christophe.jaillet@wanadoo.fr/

https://patchwork.kernel.org/project/linux-wireless/patch/e77ed7f719787cb8836a93b6a6972f4147e40bc6.1682537509.git.christophe.jaillet@wanadoo.fr/

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

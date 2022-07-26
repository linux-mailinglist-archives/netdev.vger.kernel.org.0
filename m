Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E33BD581071
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 11:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbiGZJ5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 05:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238216AbiGZJzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 05:55:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C772CCB0;
        Tue, 26 Jul 2022 02:55:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD395B811C6;
        Tue, 26 Jul 2022 09:55:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83237C341C0;
        Tue, 26 Jul 2022 09:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658829315;
        bh=Cl1l+U2SKW3B5tix69GFq95FJ/iJ6Bont4e7CRkL1v8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=lC1xEo0gfzzUVwatQxvbSQu4ZGe6NqindV1IGvEglwjzOSmohPBCB+soJ/fBLcSaJ
         PjNUVjMbTgBOusciWMHMkigbnm52nMtBhrC1OEnwIMEB1fq7g3AL1Vki3oiBygD9uz
         AkjOXi8413PMyxk715mnKl945jgdrDpK4ZhqPiQoooeEyP66KusC6kLQZn+p1nRQ93
         5yAY5j14gaVS5iQmGpK08kplSeCcfdTeAnczK5/aZOBWNUuARpz6VQZvT38nJ9/fCd
         66F9OH05vk4CBuvu4GMmKzgxLicZotDiDrL+CNJUYuhJv1n5tnWwkd+DDm6dDmKHRv
         69UUs1C9hfYmg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Siddh Raman Pant <code@siddh.me>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees 
        <linux-kernel-mentees@lists.linuxfoundation.org>
Subject: Re: [PATCH] net: Fix UAF in ieee80211_scan_rx()
References: <20220701145423.53208-1-code@siddh.me>
Date:   Tue, 26 Jul 2022 12:55:06 +0300
In-Reply-To: <20220701145423.53208-1-code@siddh.me> (Siddh Raman Pant's
        message of "Fri, 1 Jul 2022 20:24:23 +0530")
Message-ID: <8735eomc5h.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Siddh Raman Pant <code@siddh.me> writes:

> ieee80211_scan_rx() tries to access scan_req->flags after a null check
> (see line 303 of mac80211/scan.c), but ___cfg80211_scan_done() uses
> kfree() on the scan_req (see line 991 of wireless/scan.c).
>
> This results in a UAF.
>
> ieee80211_scan_rx() is called inside a RCU read-critical section
> initiated by ieee80211_rx_napi() (see line 5043 of mac80211/rx.c).
>
> Thus, add an rcu_head to the scan_req struct so as to use kfree_rcu()
> instead of kfree() so that we don't free during the critical section.
>
> Bug report (3): https://syzkaller.appspot.com/bug?extid=f9acff9bf08a845f225d
> Reported-by: syzbot+f9acff9bf08a845f225d@syzkaller.appspotmail.com
> Reported-by: syzbot+6cb476b7c69916a0caca@syzkaller.appspotmail.com
> Reported-by: syzbot+9250865a55539d384347@syzkaller.appspotmail.com
>
> Signed-off-by: Siddh Raman Pant <code@siddh.me>
> ---
>  include/net/cfg80211.h | 2 ++
>  net/wireless/scan.c    | 2 +-
>  2 files changed, 3 insertions(+), 1 deletion(-)

The title should be:

wifi: cfg80211: Fix UAF in ieee80211_scan_rx()

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

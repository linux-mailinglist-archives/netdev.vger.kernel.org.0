Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64CB06A0487
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 10:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233837AbjBWJLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 04:11:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232644AbjBWJLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 04:11:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD0F54ECEE;
        Thu, 23 Feb 2023 01:11:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 068A861633;
        Thu, 23 Feb 2023 09:11:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21305C4339B;
        Thu, 23 Feb 2023 09:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677143512;
        bh=FLuwj3WwRqTNxwF4ZE4nzwojL2qEu+/Jiah69XSHx10=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QCVLmQJEhrn21VIbUWi7BowrFreR2G9DLG4EaBGKnFyeVy8e8FSYXjatNe0p3+ich
         VuXiGb4vG3evb30BOFnGFow1RIhyM6z7QFwGkG3ezBfuSA/lqumW2lSMv1yadHcZqs
         XskTpn0JmvRivoJ/DGIHOll7aQqed+hmuFQHBLqE=
Date:   Thu, 23 Feb 2023 10:11:39 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     stable@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
        Pavel Skripkin <paskripkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bob Copeland <me@bobcopeland.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org,
        syzbot+860268315ba86ea6b96b@syzkaller.appspotmail.com,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 5.4/5.10 1/1] mac80211: mesh: embedd mesh_paths and
 mpp_paths into ieee80211_if_mesh
Message-ID: <Y/ctyzCtbPwyrrDI@kroah.com>
References: <20230222200301.254791-1-pchelkin@ispras.ru>
 <20230222200301.254791-2-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230222200301.254791-2-pchelkin@ispras.ru>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 22, 2023 at 11:03:01PM +0300, Fedor Pchelkin wrote:
> From: Pavel Skripkin <paskripkin@gmail.com>
> 
> commit 8b5cb7e41d9d77ffca036b0239177de123394a55 upstream.
> 
> Syzbot hit NULL deref in rhashtable_free_and_destroy(). The problem was
> in mesh_paths and mpp_paths being NULL.
> 
> mesh_pathtbl_init() could fail in case of memory allocation failure, but
> nobody cared, since ieee80211_mesh_init_sdata() returns void. It led to
> leaving 2 pointers as NULL. Syzbot has found null deref on exit path,
> but it could happen anywhere else, because code assumes these pointers are
> valid.
> 
> Since all ieee80211_*_setup_sdata functions are void and do not fail,
> let's embedd mesh_paths and mpp_paths into parent struct to avoid
> adding error handling on higher levels and follow the pattern of others
> setup_sdata functions
> 
> Fixes: 60854fd94573 ("mac80211: mesh: convert path table to rhashtable")
> Reported-and-tested-by: syzbot+860268315ba86ea6b96b@syzkaller.appspotmail.com
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> Link: https://lore.kernel.org/r/20211230195547.23977-1-paskripkin@gmail.com
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> [pchelkin@ispras.ru: adapt a comment spell fixing issue]
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> ---

This also worked for 4.19.y, but not 4.14.y, care to also fix it there?

thanks,

greg k-h

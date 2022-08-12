Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1A5590E78
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 11:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237054AbiHLJwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 05:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbiHLJwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 05:52:36 -0400
Received: from sender-of-o50.zoho.in (sender-of-o50.zoho.in [103.117.158.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE172AA4F2;
        Fri, 12 Aug 2022 02:52:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1660297921; cv=none; 
        d=zohomail.in; s=zohoarc; 
        b=Cd/xypIKHG364pNv0fHs7deIiXlvrE1YCUkE2ad1GSEJQwy7BIy+umQ0jeKVf2aZ3rnlf0a81212o1uXfr4QaaSA2hhP24UMycriS8DbAU0LRrxggeiJIJKANll+9M68mfwPHM30N9UjlhPEF4sPGeq5WkiOkBmD6Y+doMqTjAg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
        t=1660297921; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=JDFuru950tXWa6BmvXRLViFwR94Hwhfx/5+AvH3uJNM=; 
        b=Lu4/xacnp4XRTCFanncfZVgKqCLxlYOQzU1xhEO0jFQ9UgXDdgLDLiyoW0hmp15vii531u6G0YnGWKtpfUxuP/39dmhqWAyzg4DZ2dXIuvgesGREyBzB7zqkk15EjobKovjdnPQHa7UB9HR6OWqpi6m+atocr0z0Zo10wpL7gnk=
ARC-Authentication-Results: i=1; mx.zohomail.in;
        dkim=pass  header.i=siddh.me;
        spf=pass  smtp.mailfrom=code@siddh.me;
        dmarc=pass header.from=<code@siddh.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1660297921;
        s=zmail; d=siddh.me; i=code@siddh.me;
        h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=JDFuru950tXWa6BmvXRLViFwR94Hwhfx/5+AvH3uJNM=;
        b=eXa6Z+JTKAI7iMG3tj4n29sU4xYUuhooMASeJl2mNzDtJN9EDEIgVR7LU7vlhKux
        C6s6TRZAn3r6K7S5Qt0ocmHjDGz3ruRao/OD4bpHyqjvhxMiV9sl7JjYx0SEMvKQu8i
        ArvaKRUW3WQdyoThY+GkbMyUeAP0QBd9hvQnVPxs=
Received: from mail.zoho.in by mx.zoho.in
        with SMTP id 1660297910208203.65727225521607; Fri, 12 Aug 2022 15:21:50 +0530 (IST)
Date:   Fri, 12 Aug 2022 15:21:50 +0530
From:   Siddh Raman Pant <code@siddh.me>
To:     "Johannes Berg" <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>
Cc:     "linux-wireless" <linux-wireless@vger.kernel.org>,
        "netdev" <netdev@vger.kernel.org>,
        "linux-kernel-mentees" 
        <linux-kernel-mentees@lists.linuxfoundation.org>,
        "syzbot+f9acff9bf08a845f225d" 
        <syzbot+f9acff9bf08a845f225d@syzkaller.appspotmail.com>,
        "syzbot+6cb476b7c69916a0caca" 
        <syzbot+6cb476b7c69916a0caca@syzkaller.appspotmail.com>,
        "syzbot+9250865a55539d384347" 
        <syzbot+9250865a55539d384347@syzkaller.appspotmail.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Message-ID: <18291779771.584fa6ab156295.3990923778713440655@siddh.me>
In-Reply-To: <20220726123921.29664-1-code@siddh.me>
References: <20220726123921.29664-1-code@siddh.me>
Subject: Re: [PATCH v2] wifi: cfg80211: Fix UAF in ieee80211_scan_rx()
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_RED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Jul 2022 18:09:21 +0530  Siddh Raman Pant  wrote:
> ieee80211_scan_rx() tries to access scan_req->flags after a null check
> (see line 303 of mac80211/scan.c), but ___cfg80211_scan_done() uses
> kfree() on the scan_req (see line 991 of wireless/scan.c).
> 
> This results in a UAF.
> 
> ieee80211_scan_rx() is called inside a RCU read-critical section
> initiated by ieee80211_rx_napi() (see line 5044 of mac80211/rx.c).
> 
> Thus, add an rcu_head to the scan_req struct, so that we can use
> kfree_rcu() instead of kfree() and thus not free during the critical
> section.
> 
> We can clear the pointer before freeing here, since scan_req is
> accessed using rcu_dereference().
> 
> Bug report (3): https://syzkaller.appspot.com/bug?extid=f9acff9bf08a845f225d
> Reported-by: syzbot+f9acff9bf08a845f225d@syzkaller.appspotmail.com
> Reported-by: syzbot+6cb476b7c69916a0caca@syzkaller.appspotmail.com
> Reported-by: syzbot+9250865a55539d384347@syzkaller.appspotmail.com
> 
> Signed-off-by: Siddh Raman Pant code@siddh.me>
> ---
> Changes since v1 as requested:
> - Fixed commit heading and better commit message.
> - Clear pointer before freeing.
> 
>  include/net/cfg80211.h | 2 ++
>  net/wireless/scan.c    | 2 +-
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 80f41446b1f0..7e0b448c4cdb 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -2368,6 +2368,7 @@ struct cfg80211_scan_6ghz_params {
>   * @n_6ghz_params: number of 6 GHz params
>   * @scan_6ghz_params: 6 GHz params
>   * @bssid: BSSID to scan for (most commonly, the wildcard BSSID)
> + * @rcu_head: (internal) RCU head to use for freeing
>   */
>  struct cfg80211_scan_request {
>  	struct cfg80211_ssid *ssids;
> @@ -2397,6 +2398,7 @@ struct cfg80211_scan_request {
>  	bool scan_6ghz;
>  	u32 n_6ghz_params;
>  	struct cfg80211_scan_6ghz_params *scan_6ghz_params;
> +	struct rcu_head rcu_head;
>  
>  	/* keep last */
>  	struct ieee80211_channel *channels[];
> diff --git a/net/wireless/scan.c b/net/wireless/scan.c
> index 6d82bd9eaf8c..6cf58fe6dea0 100644
> --- a/net/wireless/scan.c
> +++ b/net/wireless/scan.c
> @@ -988,8 +988,8 @@ void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev,
>  	kfree(rdev->int_scan_req);
>  	rdev->int_scan_req = NULL;
>  
> -	kfree(rdev->scan_req);
>  	rdev->scan_req = NULL;
> +	kfree_rcu(rdev_req, rcu_head);
>  
>  	if (!send_message)
>  		rdev->scan_msg = msg;
> -- 
> 2.35.1
> 

Hello,

Probably the above quoted patch was missed, which can be found on
https://lore.kernel.org/linux-wireless/20220726123921.29664-1-code@siddh.me/

This patch was posted more than 2 weeks ago, with changes as requested.

With the merge window almost ending, may I request for another look at
this patch?

Thanks,
Siddh

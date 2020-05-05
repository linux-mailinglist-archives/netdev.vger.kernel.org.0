Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69EF41C5AE8
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 17:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729858AbgEEPUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 11:20:13 -0400
Received: from rere.qmqm.pl ([91.227.64.183]:7069 "EHLO rere.qmqm.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729261AbgEEPUN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 11:20:13 -0400
Received: from remote.user (localhost [127.0.0.1])
        by rere.qmqm.pl (Postfix) with ESMTPSA id 49Gk1Q0mlJz8r;
        Tue,  5 May 2020 17:20:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rere.qmqm.pl; s=1;
        t=1588692011; bh=lKiBtlC2rF4WszJJ1J86rqn0pACHMTtp0FdEI1MvRMI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ry80H3sPtv1CAGFJdpNJGsCWtrEZWnVjzZdlshBPbJO0L/G7MhL3lunZRtSRQ+v+3
         luXpLU9UIaOj9kcrpbFE2y3PeExxaMP/qCigN2FR1OK9nt6pl7RAQlJfzL6uBfdL1w
         wDEP6CFs8dSWTnbplUCNCWWfubJP9/csGSsknYzgA0FojmokKbrhgr7LO94gn2/J1T
         6S+wF31BXoKyM7yZMOkvcvHtB7kSQVoxBVpk8qQiGJttFKtVjnXlPdBtL8nEBifidN
         S5McqqciBCncRy3Ms3xvVQwcqYywilt/uV7rGhxpSvIDKxNQGvSLPwfoGvNpnB63l3
         r3BOfS4aUhyjw==
X-Virus-Status: Clean
X-Virus-Scanned: clamav-milter 0.102.2 at mail
Date:   Tue, 5 May 2020 17:20:08 +0200
From:   =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 03/15] staging: wfx: fix double free
Message-ID: <20200505152008.GA8277@qmqm.qmqm.pl>
References: <20200505123757.39506-1-Jerome.Pouiller@silabs.com>
 <20200505123757.39506-4-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200505123757.39506-4-Jerome.Pouiller@silabs.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 02:37:45PM +0200, Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> In case of error in wfx_probe(), wdev->hw is freed. Since an error
> occurred, wfx_free_common() is called, then wdev->hw is freed again.
> 
> Cc: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>
> Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> ---
>  drivers/staging/wfx/main.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/staging/wfx/main.c b/drivers/staging/wfx/main.c
> index ba2e3a6b3549..5d0754b55429 100644
> --- a/drivers/staging/wfx/main.c
> +++ b/drivers/staging/wfx/main.c
> @@ -469,7 +469,6 @@ int wfx_probe(struct wfx_dev *wdev)
>  
>  err2:
>  	ieee80211_unregister_hw(wdev->hw);
> -	ieee80211_free_hw(wdev->hw);
>  err1:
>  	wfx_bh_unregister(wdev);
>  	return err;

Reviewed-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>
Fixes: 4033714d6cbe ("staging: wfx: fix init/remove vs IRQ race")

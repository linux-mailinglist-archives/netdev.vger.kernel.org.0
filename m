Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D02EB9762
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 20:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405734AbfITSwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 14:52:16 -0400
Received: from mx4.wp.pl ([212.77.101.12]:11818 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405644AbfITSwP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 14:52:15 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Sep 2019 14:52:14 EDT
Received: (wp-smtpd smtp.wp.pl 15208 invoked from network); 20 Sep 2019 20:45:33 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1569005134; bh=cizgm+wM/wjxUasVlGK7XAg12mZAPfOsYXg1d/8EQ90=;
          h=From:To:Cc:Subject;
          b=s5ny6L1GowL9XNrTar3fPEsX/ROiUgvN4PSEig0HQBPfKd+NPMYlml8HBaYwosXsM
           pIw+74PyBFdJfjgsNhteK+dKxq+FIgc9WlEwAa20eriPCWeZTbvRLK3SVfH3j1JGYO
           CeW+uDB4WLNOAsMJK7SYNkPTmOsnU36ogpr/QAxY=
Received: from 014.152-60-66-biz-static.surewest.net (HELO cakuba.netronome.com) (kubakici@wp.pl@[66.60.152.14])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <lorenzo.bianconi@redhat.com>; 20 Sep 2019 20:45:33 +0200
Date:   Fri, 20 Sep 2019 11:45:15 -0700
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Colin King <colin.king@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mt7601u: phy: simplify zero check on val
Message-ID: <20190920114515.36e1ed90@cakuba.netronome.com>
In-Reply-To: <20190920135817.GC6456@localhost.localdomain>
References: <20190920125414.15507-1-colin.king@canonical.com>
        <20190920135817.GC6456@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: 624ef302b2416e660574dde2845ab35d
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000A [AVOU]                               
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Sep 2019 15:58:17 +0200, Lorenzo Bianconi wrote:
> I think this is not correct since (not considering the cast) we should break
> from the loop if val != 0 and val != 0xff, so the right approach I guess is:
> 
> diff --git a/drivers/net/wireless/mediatek/mt7601u/phy.c b/drivers/net/wireless/mediatek/mt7601u/phy.c
> index 06f5702ab4bd..d863ab4a66c9 100644
> --- a/drivers/net/wireless/mediatek/mt7601u/phy.c
> +++ b/drivers/net/wireless/mediatek/mt7601u/phy.c
> @@ -213,7 +213,7 @@ int mt7601u_wait_bbp_ready(struct mt7601u_dev *dev)
>  
>  	do {
>  		val = mt7601u_bbp_rr(dev, MT_BBP_REG_VERSION);
> -		if (val && ~val)
> +		if (val && val != 0xff)
>  			break;
>  	} while (--i);

Yup, feel free to add my ack if you post this, Lorenzo.

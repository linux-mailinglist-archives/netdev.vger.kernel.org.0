Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA1C4607D7
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 18:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235243AbhK1RLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 12:11:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358617AbhK1RJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 12:09:13 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2979FC06174A
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 09:05:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=kQxB4LtueUM5/YDDNjUA+LxY30OxshLIqXizOxXLazk=;
        t=1638119113; x=1639328713; b=h9bm8hK05Z2D6XqxeJQp36Ys9mF+KvrSmFF/mD35687KYV0
        QnGdZYCbOcaXrT5xFl536yvGIBcfHhT1C6aUFN2npwmoj5W0dmYo9/h8s2vtnizh7acNpDbLxNv5k
        AO8O/SycvViDQhTuXc+jb2IEM7pYem24WZpioXVWMGceG2BeVMS+hZeRHZEH6AcKaOObAdMkUSH1P
        jzkLcsHJLBb/ooC5f8gZCyrWVc45cgF32svZY8nBae1wGIqfPyGK1lSwIuyx9Qr6PMC2OMr/9xJkK
        ivisjL+wkCcqr7oX2e6+XLSWTDSN2cSIHlsfrXP7RSesBZDLZ1ggZJQVaSG5SqZQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mrNbv-0044n2-UN;
        Sun, 28 Nov 2021 18:05:08 +0100
Message-ID: <dff6b112e225993b113ec04f3205d837352b8961.camel@sipsolutions.net>
Subject: Re: [PATCH RESEND net-next 5/5] net: wwan: core: make debugfs
 optional
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>
Date:   Sun, 28 Nov 2021 18:05:06 +0100
In-Reply-To: <20211128125522.23357-6-ryazanov.s.a@gmail.com>
References: <20211128125522.23357-1-ryazanov.s.a@gmail.com>
         <20211128125522.23357-6-ryazanov.s.a@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2021-11-28 at 15:55 +0300, Sergey Ryazanov wrote:
> 
> +#ifdef CONFIG_WWAN_DEBUGFS
>  struct dentry *wwan_get_debugfs_dir(struct device *parent);
> +#else
> +static inline struct dentry *wwan_get_debugfs_dir(struct device *parent)
> +{
> +	return NULL;
> +}
> +#endif

Now I have to send another email anyway ... but this one probably should
be ERR_PTR(-ENODEV) or something, a la debugfs_create_dir() if debugfs
is disabled, because then a trivial user of wwan's debugfs doesn't even
have to care about whether it's enabled or not, it can just
debugfs_create_dir() for its own and the debugfs core code will check
and return immediately. Yes that's a bit more code space, but if you
just have a debugfs file or two, having an extra Kconfig option is
possibly overkill too. Especially if we get into this path because
DEBUG_FS is disabled *entirely*, and thus all the functions will be
empty inlines (but it might not be, so it should be consistent with
debugfs always returning non-NULL).

johannes

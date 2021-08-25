Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5A1C3F794B
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 17:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241008AbhHYPnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 11:43:03 -0400
Received: from codesynthesis.com ([188.40.148.39]:44846 "EHLO
        codesynthesis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240878AbhHYPnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 11:43:02 -0400
X-Greylist: delayed 453 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Aug 2021 11:43:01 EDT
Received: from brak.codesynthesis.com (197-255-152-207.static.adept.co.za [197.255.152.207])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by codesynthesis.com (Postfix) with ESMTPSA id EC3275F7CB;
        Wed, 25 Aug 2021 15:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codesynthesis.com;
        s=mail1; t=1629905681;
        bh=njRimGOIAbqbKx/5ZrZSGnm8dBTrS6TRY3ucp7C/bzU=;
        h=Date:From:To:Subject:Message-ID:MIME-Version:From;
        b=M4Zeq9iy/BsSsC3ucqhrc8i/ZaAxdzH10P5jgmpgL4PwLblF/Fp947GMfSBXeNsjq
         NuVIW50/nTWLqphqH0bmluRAxc0xwe2C4oPm8c3f82SB7NkwrgSfclPFXG73pD0L0h
         BXOpQO6Icl3wl7OePxAFtZ7q+2CMRU9b3Qt4+Lm1L2wJkxTOQ3DpJExmWuUMQyAheR
         kyHK+EDh37gLQ1jZZ8I0aj6iXvXQ9trqsiJeiZDTSWqktv5++p/YTyknMZMmxFNd7P
         pNCo5LQJUmP3rmiNyTGDZjJtNKJ5AnGpM3Qc/HQWkVB6YyRtxYHeF5BjZsSZXaAbiu
         PCHHvOofYHbwQ==
Received: by brak.codesynthesis.com (Postfix, from userid 1000)
        id 1A3B11A800C4; Wed, 25 Aug 2021 17:34:37 +0200 (SAST)
Date:   Wed, 25 Aug 2021 17:34:37 +0200
From:   Boris Kolpackov <boris@codesynthesis.com>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     linux-kbuild@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Kalle Valo <kvalo@codeaurora.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] kconfig: forbid symbols that end with '_MODULE'
Message-ID: <boris.20210825172545@codesynthesis.com>
References: <20210825041637.365171-1-masahiroy@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825041637.365171-1-masahiroy@kernel.org>
Organization: Code Synthesis
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Masahiro Yamada <masahiroy@kernel.org> writes:

> Kconfig (syncconfig) generates include/generated/autoconf.h to make
> CONFIG options available to the pre-processor.
> 
> The macros are suffixed with '_MODULE' for symbols with the value 'm'.
> 
> Here is a conflict; CONFIG_FOO=m results in '#define CONFIG_FOO_MODULE 1',
> but CONFIG_FOO_MODULE=y also results in the same define.
> 
> fixdep always assumes CONFIG_FOO_MODULE comes from CONFIG_FOO=m, so the
> dependency is not properly tracked for symbols that end with '_MODULE'.

It seem to me the problem is in autoconf.h/fixdep, not in the Kconfig
language.


> This commit makes Kconfig error out if it finds a symbol suffixed with
> '_MODULE'.

I know you don't care, but I will voice my objection, for the record:
Kconfig is used by projects other than the Linux kernel and some of
them do not use the autoconf.h functionality. For such projects this
restriction seems arbitrary and potentially backwards-incompatible.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A5A314978
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 08:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbhBIHZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 02:25:57 -0500
Received: from mail29.static.mailgun.info ([104.130.122.29]:19661 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230301AbhBIHZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 02:25:38 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612855520; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=qA7gLOs+c3RyRz/nEUpO8aS+X2snIkrbfEwG0oacl2A=;
 b=YqPIIRdPo15srcilFAb2MWgEYyjMtrU4KAH3MkrjjBq845/U4ut7Ljcrqi1oQpZKxVDh5ds+
 lgB5PtNDm0p8FwMkC03BINONhJfrmOIfEWARN5sQLD587YCcyi4XGqw/krQM69ib3xPriCXW
 RCgr657JLDPaSagatf9F6P0Arkk=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 602238b434db06ef79172c60 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 09 Feb 2021 07:24:36
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2409CC43461; Tue,  9 Feb 2021 07:24:36 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 40AD8C433CA;
        Tue,  9 Feb 2021 07:24:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 40AD8C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] carl9170: fix struct alignment conflict
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210204162926.3262598-1-arnd@kernel.org>
References: <20210204162926.3262598-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Christian Lamparter <chunkeey@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210209072436.2409CC43461@smtp.codeaurora.org>
Date:   Tue,  9 Feb 2021 07:24:36 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@kernel.org> wrote:

> Multiple structures in the carl9170 driver have alignment
> impossible alignment constraints that gcc warns about when
> building with 'make W=1':
> 
> drivers/net/wireless/ath/carl9170/fwcmd.h:243:2: warning: alignment 1 of 'union <anonymous>' is less than 4 [-Wpacked-not-aligned]
> drivers/net/wireless/ath/carl9170/wlan.h:373:1: warning: alignment 1 of 'struct ar9170_rx_frame_single' is less than 2 [-Wpacked-not-aligned]
> 
> In the carl9170_cmd structure, multiple members that have an explicit
> alignment requirement of four bytes are added into a union with explicit
> byte alignment, but this in turn is part of a structure that also has
> four-byte alignment.
> 
> In the wlan.h header, multiple structures contain a ieee80211_hdr member
> that is required to be two-byte aligned to avoid alignmnet faults when
> processing network headers, but all members are forced to be byte-aligned
> using the __packed tag at the end of the struct definition.
> 
> In both cases, leaving out the packing does not change the internal
> layout of the structure but changes the alignment constraint of the
> structure itself.
> 
> Change all affected structures to only apply packing where it does
> not violate the alignment requirement of the contained structure.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Christian Lamparter <chunkeey@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

ca9ad549e404 carl9170: fix struct alignment conflict

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210204162926.3262598-1-arnd@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


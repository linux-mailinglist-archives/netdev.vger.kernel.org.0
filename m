Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8260422AF5
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 16:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235592AbhJEO0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 10:26:49 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:44845 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235336AbhJEO0p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 10:26:45 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633443895; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=Ww0Ve07mMasz5L9jVhgn12WcbFLxKZLtDHJlPaIMDwA=; b=CtcJzFkkxz5m2vXSJJqP+Hrwp4Gny3lG3T3Mhx72q6iZSBUrquQR8Cn3h4m89XOo7EWSzXps
 QcoP++gwhnywO4KTXOrYxCK3dt+t98FxnZpJXWkP9k//pNdFX2cy4FGrDbejZp6RCZtIa0/e
 L8moXZ/xKar8be+/vmgd8y5C61Q=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 615c6022b8ab9916b3b451c4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 05 Oct 2021 14:24:34
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 43FC6C4361A; Tue,  5 Oct 2021 14:24:34 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 82DBDC4338F;
        Tue,  5 Oct 2021 14:24:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 82DBDC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
Cc:     Felix Fietkau <nbd@nbd.name>, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "John W . Linville" <linville@tuxdriver.com>,
        Felix Fietkau <nbd@openwrt.org>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sven Eckelmann <sven@narfation.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] ath9k: interrupt fixes on queue reset
References: <20210914192515.9273-1-linus.luessing@c0d3.blue>
        <YVxdRHvpiHVpdu4H@sellars>
Date:   Tue, 05 Oct 2021 17:24:26 +0300
In-Reply-To: <YVxdRHvpiHVpdu4H@sellars> ("Linus \=\?utf-8\?Q\?L\=C3\=BCssing\=22'\?\=
 \=\?utf-8\?Q\?s\?\= message of "Tue, 5
        Oct 2021 16:12:20 +0200")
Message-ID: <87wnmreehx.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linus L=C3=BCssing <linus.luessing@c0d3.blue> writes:

> On Tue, Sep 14, 2021 at 09:25:12PM +0200, Linus L=C3=BCssing wrote:
>> Hi,
>>=20
>> The following are two patches for ath9k to fix a potential interrupt
>> storm (PATCH 2/3) and to fix potentially resetting the wifi chip while
>> its interrupts were accidentally reenabled (PATCH 3/3).
>>=20
>> PATCH 1/3 adds the possibility to trigger the ath9k queue reset through
>> the ath9k reset file in debugfs. Which was helpful to reproduce and debug
>> this issue and might help for future debugging.
>>=20
>> PATCH 2/3 and PATCH 3/3 should be applicable for stable.
>>=20
>> Regards, Linus
>>=20
>
> I've marked PATCH 3/3 as "rejected" in Patchwork now due to
> Felix's legitimate remarks.

BTW I prefer to mark patches as rejected myself in patchwork so that I
know what's happening (patchwork is lacking in this respect as it
doesn't notify me if there are any changes in patches). But good that
you mentioned this via email so I didn't need to wonder what happened.

> For patches 1/3 and and 2/3 I'd still like to see them merged upstream
> if there is no objection to those.

Thanks, I was about to ask what I should do with this patchset.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes

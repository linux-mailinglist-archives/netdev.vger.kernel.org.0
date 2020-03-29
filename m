Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4776196FC5
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 21:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbgC2TwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 15:52:24 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:61840 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727101AbgC2TwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 15:52:24 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1585511544; h=In-Reply-To: Content-Type: MIME-Version:
 References: Message-ID: Subject: Cc: To: From: Date: Sender;
 bh=EgCHKm1rHnE1lp9FtI/N1vG6KGyN/3ifytBlcKVEm10=; b=HbYshzJOu55AFpXqqZCFSS9pkkr86u5sFTlvGH1VE4kBIfXQRVjCbYBwsJrs8LFsk4qdrnS/
 BhZYh92ZDeNrb9Of2zcozZAlgffAfcGZXv8b/CW0ZoMCpin9vrk0Rp8NJKW28+1eW66bZUjm
 mBsMjTkhqqZlSy4gL96y5s9hnC8=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e80fc67.7f87b4b4c5e0-smtp-out-n03;
 Sun, 29 Mar 2020 19:52:07 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A88FFC43637; Sun, 29 Mar 2020 19:52:07 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from jouni.codeaurora.org (37-130-184-238.bb.dnainternet.fi [37.130.184.238])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: jouni)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CDE58C433F2;
        Sun, 29 Mar 2020 19:52:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CDE58C433F2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=jouni@codeaurora.org
Received: by jouni.codeaurora.org (sSMTP sendmail emulation); Sun, 29 Mar 2020 22:51:09 +0300
Date:   Sun, 29 Mar 2020 22:51:09 +0300
From:   Jouni Malinen <jouni@codeaurora.org>
To:     Chris Clayton <chris2553@googlemail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, johannes.berg@intel.com
Subject: Re: 5.6.0-rc7+ fails to connect to wifi network
Message-ID: <20200329195109.GA10156@jouni.qca.qualcomm.com>
References: <870207cc-2b47-be26-33b6-ec3971122ab8@googlemail.com>
 <58a4d4b4-a372-9f38-2ceb-8386f8444d61@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58a4d4b4-a372-9f38-2ceb-8386f8444d61@googlemail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 29, 2020 at 11:54:26AM +0100, Chris Clayton wrote:
> > Let me know if I can provide any additional diagnostics and/or test any patches.

Important was the dmesg output that also identified which driver was
used..

> I've bisected this and landed at:
> 
> ce2e1ca703071723ca2dd94d492a5ab6d15050da is the first bad commit
> commit ce2e1ca703071723ca2dd94d492a5ab6d15050da
> Author: Jouni Malinen <jouni@codeaurora.org>
> Date:   Thu Mar 26 15:51:34 2020 +0100
> 
>     mac80211: Check port authorization in the ieee80211_tx_dequeue() case
> 
>     mac80211 used to check port authorization in the Data frame enqueue case
>     when going through start_xmit(). However, that authorization status may
>     change while the frame is waiting in a queue. Add a similar check in the
>     dequeue case to avoid sending previously accepted frames after
>     authorization change. This provides additional protection against
>     potential leaking of frames after a station has been disconnected and
>     the keys for it are being removed.

Thanks for finding and reporting this. The changes here were indeed
supposed to apply only to Data frames and that's what they did with the
driver I tested this with which is why this did not come up earlier.
However, this path can get Management frames (and it was indeed the
Authentication frames that were getting dropped in your case with
iwlwifi) and that needs to addressed in the conditions here.

Johannes fixed this with the following change:
https://patchwork.kernel.org/patch/11464207/

-- 
Jouni Malinen                                            PGP id EFC895FA

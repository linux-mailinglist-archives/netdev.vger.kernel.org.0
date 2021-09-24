Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB18C416ECA
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 11:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244936AbhIXJWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 05:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244555AbhIXJWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 05:22:30 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC362C061574;
        Fri, 24 Sep 2021 02:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=9GxW7f1PM4tlFV8GS6ENNCIsOWiZB1CGSgf0VxPfSxU=;
        t=1632475257; x=1633684857; b=e078anP+jhgULPe4U63PVvoM+GFz5UJ/yXuNrvCEeTgl1ga
        Ja6lV/8V6UseMEQw4SAG37s+gs3yiLDHjT6bDnliqT1SFEahJww/geeUmymE4OIDExNJ2HZx4Sihr
        RYrWmN6vbsHJ5WtDd76kEgRXdiS2dudvqnpWDhxq08JkLXd3ogLZU1dgsR5UB69jm3wWuyqP/0nx5
        iZz4/mP8crhWpX3T1Zr9f+ODm3Sm4p4yXgvlIrNSdz2qlmMcPBTccYQsSB0BRqpCsQRt9Kt2V9HT5
        p152Wj+qHTckYXwQizwPX3JE59KKGfJ1xV5JCFHNF5hVOxTo/NsGuCUPetNQTAUw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95-RC2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mThNz-00B89x-JN;
        Fri, 24 Sep 2021 11:20:51 +0200
Message-ID: <90d3c3c8cedcf5f8baa77b3b6e94b18656fcd0be.camel@sipsolutions.net>
Subject: Re: [PATCH 2/3] mac80211: Add support to trigger sta disconnect on
 hardware restart
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Youghandhar Chintala <youghand@codeaurora.org>
Cc:     Abhishek Kumar <kuabhs@chromium.org>, Felix Fietkau <nbd@nbd.name>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Brian Norris <briannorris@chromium.org>,
        Rakesh Pillai <pillair@codeaurora.org>,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>
Date:   Fri, 24 Sep 2021 11:20:50 +0200
In-Reply-To: <30fa98673ad816ec849f34853c9e1257@codeaurora.org>
References: <20201215172352.5311-1-youghand@codeaurora.org>
         <f2089f3c-db96-87bc-d678-199b440c05be@nbd.name>
         <ba0e6a3b783722c22715ae21953b1036@codeaurora.org>
         <CACTWRwt0F24rkueS9Ydq6gY3M-oouKGpaL3rhWngQ7cTP0xHMA@mail.gmail.com>
         (sfid-20210205_225202_513086_43C9BBC9) <d5cfad1543f31b3e0d8e7a911d3741f3d5446c57.camel@sipsolutions.net>
         <66ba0f836dba111b8c7692f78da3f079@codeaurora.org>
         <5826123db4731bde01594212101ed5dbbea4d54f.camel@sipsolutions.net>
         <30fa98673ad816ec849f34853c9e1257@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,


> We thought sending the delba would solve the problem as earlier thought 
> but the actual problem is with TX PN in a secure mode.
> It is not because of delba that the Seq number and TX PN are reset to 
> zero.
> It’s because of the HW restart, these parameters are reset to zero.
> Since FW/HW is the one which decides the TX PN, when it goes through 
> SSR, all these parameters are reset.

Right, we solved this problem too - in a sense the driver reads the
database (not just TX PN btw, also RX replay counters) when the firmware
crashes, and sending it back after the restart. mac80211 has some hooks
for that.

johannes



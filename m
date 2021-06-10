Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE7E13A34B8
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 22:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhFJUUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 16:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbhFJUUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 16:20:46 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E38B5C061574;
        Thu, 10 Jun 2021 13:18:49 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lrR8V-0050Za-8D; Thu, 10 Jun 2021 22:18:43 +0200
Message-ID: <5bb08a2db092c590119ff706ac3654de14c984fc.camel@sipsolutions.net>
Subject: Re: [PATCH v2 1/2] rtl8xxxu: unset the hw capability
 HAS_RATE_CONTROL
From:   Johannes Berg <johannes@sipsolutions.net>
To:     chris.chiu@canonical.com, Jes.Sorensen@gmail.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 10 Jun 2021 22:18:42 +0200
In-Reply-To: <20210603120609.58932-2-chris.chiu@canonical.com> (sfid-20210603_140802_983573_B146892B)
References: <20210603120609.58932-1-chris.chiu@canonical.com>
         <20210603120609.58932-2-chris.chiu@canonical.com>
         (sfid-20210603_140802_983573_B146892B)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Chris,

> Since AMPDU_AGGREGATION is set so packets will be handed to the
> driver with a flag indicating A-MPDU aggregation and device should
> be responsible for setting up and starting the TX aggregation with
> the AMPDU_TX_START action. The TX aggregation is usually started by
> the rate control algorithm so the HAS_RATE_CONTROL has to be unset
> for the mac80211 to start BA session by ieee80211_start_tx_ba_session.
> 
> The realtek chips tx rate will still be handled by the rate adaptive
> mechanism in the underlying firmware which is controlled by the
> rate mask H2C command in the driver. Unset HAS_RATE_CONTROL cause
> no change for the tx rate control and the TX BA session can be started
> by the mac80211 default rate control mechanism.

This seems ... strange, to say the least? You want to run the full
minstrel algorithm just to have it start aggregation sessions at the
beginning?

I really don't think this makes sense, and it's super confusing. It may
also result in things like reporting a TX rate to userspace/other
components that *minstrel* thinks is the best rate, rather than your
driver's implementation, etc.

I suggest you instead just call ieee80211_start_tx_ba_session() at some
appropriate time, maybe copying parts of the logic of
minstrel_aggr_check().

johannes



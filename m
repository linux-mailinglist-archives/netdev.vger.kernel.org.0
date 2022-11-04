Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96416619C6B
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 17:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbiKDQBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 12:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbiKDQBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 12:01:46 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4466F326DE;
        Fri,  4 Nov 2022 09:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=phB0ONzIEmhvjMaH01rqcRiaEOp/Z+phqx/hVI3Dfmg=;
        t=1667577705; x=1668787305; b=iclFWdd6NekfVQBSWXH2zZMcxo5kn4BKMkZZaCPaMwskEoj
        bKGBn9tm7dZJ8SEllbjMBphfMmquG7XDSIjOzTHtGTpcWFDOPnjznA/0OxDftQ1eTbqqEqBnHV5s/
        XnayQTjUYYh3/wSksVD6BPqTb9gmc0+PxsnGfab3KLE0NiH0E1/LKzJoiiDinjvDKDeC/qqU4RLdU
        cLYftjVPWojLjTrkYXOlNnadwcqBP/PbcewuhfJ037c4NazvMO4jO8p07IyyB6zmxLqC7ZV/Ew0p0
        qQL6BElb0QxEzGNZxnA+8MfuG8tKbfYN5QF+B2rwI/bqtEFkbehTKqjq8+4mXikA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oqz8Q-008uK8-09;
        Fri, 04 Nov 2022 17:01:34 +0100
Message-ID: <cf7da8e9a135fee1a9ac0e8f768a2a13bbba058d.camel@sipsolutions.net>
Subject: Re: [PATCH v3] wifi: rsi: Fix handling of 802.3 EAPOL frames sent
 via control port
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Marek Vasut <marex@denx.de>, linux-wireless@vger.kernel.org
Cc:     Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Angus Ainslie <angus@akkea.ca>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Martin Kepplinger <martink@posteo.de>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>, netdev@vger.kernel.org
Date:   Fri, 04 Nov 2022 17:01:32 +0100
In-Reply-To: <20221104155841.213387-1-marex@denx.de>
References: <20221104155841.213387-1-marex@denx.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-11-04 at 16:58 +0100, Marek Vasut wrote:
>=20
> Therefore, to fix this problem, inspect the ETH_P_802_3 frames in
> the rsi_91x driver, check the ethertype of the encapsulated frame,
> and in case it is ETH_P_PAE, transmit the frame via high-priority
> queue just like other ETH_P_PAE frames.

This part seems wrong now.

> +bool rsi_is_tx_eapol(struct sk_buff *skb)
> +{
> +	return !!(IEEE80211_SKB_CB(skb)->control.flags &
> +		  IEEE80211_TX_CTRL_PORT_CTRL_PROTO);
> +}

For how trivial this is now, maybe make it an inline? Feels fairly
pointless to have it as an out-of-line function to call in another file
when it's a simple bit check.

You can also drop the !! since the return value is bool.

johannes

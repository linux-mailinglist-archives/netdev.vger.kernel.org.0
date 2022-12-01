Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D51CF63F0E9
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 13:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbiLAMxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 07:53:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbiLAMxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 07:53:06 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E7F578D1;
        Thu,  1 Dec 2022 04:53:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=pbCLMzEHWZTpGflCYl6tcEvF7/wglUpPD4jDXwU27IE=;
        t=1669899185; x=1671108785; b=HeEQEEOF9sjDY9v+v9EcAMsIZI1YI1EcLGkxH+nQxrcL+Mf
        wN/ZVBLSI7xknrBmAHn7/3cqt00b3DgD8d9yfMAsLgoSyGpPRUfXn59zuiuenC2ljOkjH6xCqBTv0
        b7t2858OzdIgFkSBas6zBibbSUDW3aeSiw5LxGWZvA+AdMztUctND6y7TxX22Wa0QIc/SQEH2XY9l
        n1d29z5o8w2UYrRHcWwbcWpsQD6QSBUCoZA/ZX0XoYco1FAXyInZVrzgdhsWlcYyqnX4/UNRujZz7
        4ZkuCpKamzIMAetr6F9pSR/zVnbiJt1EQUbCk9qOOiQisXykeC2ELqTlJmVZoMcA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1p0j3i-00E4OH-35;
        Thu, 01 Dec 2022 13:52:59 +0100
Message-ID: <4f37f422a0bcd8d1d2dd1bb992be30a16d335a3f.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: mac80211: fix memory leak in
 ieee80211_register_hw()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Zhengchao Shao <shaozhengchao@huawei.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     sara.sharon@intel.com, luciano.coelho@intel.com,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
Date:   Thu, 01 Dec 2022 13:52:57 +0100
In-Reply-To: <20221122091142.261354-1-shaozhengchao@huawei.com>
References: <20221122091142.261354-1-shaozhengchao@huawei.com>
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

On Tue, 2022-11-22 at 17:11 +0800, Zhengchao Shao wrote:
>=20
> +++ b/net/mac80211/iface.c
> @@ -2326,8 +2326,6 @@ void ieee80211_remove_interfaces(struct ieee80211_l=
ocal *local)
>  	WARN(local->open_count, "%s: open count remains %d\n",
>  	     wiphy_name(local->hw.wiphy), local->open_count);
> =20
> -	ieee80211_txq_teardown_flows(local);


This is after shutting down interfaces.

> @@ -1469,6 +1470,7 @@ void ieee80211_unregister_hw(struct ieee80211_hw *h=
w)
>  	 * because the driver cannot be handing us frames any
>  	 * more and the tasklet is killed.
>  	 */
> +	ieee80211_txq_teardown_flows(local);
>  	ieee80211_remove_interfaces(local);
>=20

But now it's before. Why is that safe?

johannes

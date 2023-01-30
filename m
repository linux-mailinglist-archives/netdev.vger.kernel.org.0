Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36EE5681677
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 17:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236648AbjA3Qcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 11:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237278AbjA3Qcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 11:32:32 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD4E39CC6;
        Mon, 30 Jan 2023 08:32:29 -0800 (PST)
Received: from [192.168.2.51] (p4fc2fe3a.dip0.t-ipconnect.de [79.194.254.58])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 409CCC0072;
        Mon, 30 Jan 2023 17:32:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1675096345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sOkv+PIqJ2IbV0QjFFTw1jbSQtCSFXVODQir2FyS2MQ=;
        b=Xy9x4Poa/IcjAKijj+yE7r7cIvDZXu5yVyNgh02DujCRxUInZxGU4Bj4Fo3dbhS+Xv9hFj
        aj6PQf0rcmtTmo/CZNmZCRa4EO2VGscvssV8v3tBOkWzIG5Usg7yVUS+FNi6BTNGHqev9o
        uBVsT0z5s0g5YCkfDLaDN0mHbYfRMRSWbhfgwdOmUCYw7dcPs3MGVjY875OcI0h4PsofIn
        LI1shFQvbYOa+v8al82s8fXJDVGFyOhjr/FtQenc0qyBX+EbeUwFPoZMhZdv5Jf5Cx8rYp
        KazJ19aMTRTkdJ7nUlDFl1IJnDGurBYJlhb6ebcmnIv+pvg/ZCkwsoQxOvKlsA==
Message-ID: <f604d39b-d801-8373-9d8f-e93e429b7cdd@datenfreihafen.org>
Date:   Mon, 30 Jan 2023 17:32:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH wpan-next] mac802154: Avoid superfluous endianness
 handling
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <alex.aring@gmail.com>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel test robot <lkp@intel.com>
References: <20230130154306.114265-1-miquel.raynal@bootlin.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20230130154306.114265-1-miquel.raynal@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 30.01.23 16:43, Miquel Raynal wrote:
> When compiling scan.c with C=1, Sparse complains with:
> 
>     sparse:     expected unsigned short [usertype] val
>     sparse:     got restricted __le16 [usertype] pan_id
>     sparse: sparse: cast from restricted __le16
> 
>     sparse:     expected unsigned long long [usertype] val
>     sparse:     got restricted __le64 [usertype] extended_addr
>     sparse: sparse: cast from restricted __le64
> 
> The tool is right, both pan_id and extended_addr already are rightfully
> defined as being __le16 and __le64 on both sides of the operations and
> do not require extra endianness handling.
> 
> Fixes: 3accf4762734 ("mac802154: Handle basic beaconing")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>   net/mac802154/scan.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mac802154/scan.c b/net/mac802154/scan.c
> index cfbe20b1ec5e..8f98efec7753 100644
> --- a/net/mac802154/scan.c
> +++ b/net/mac802154/scan.c
> @@ -419,8 +419,8 @@ int mac802154_send_beacons_locked(struct ieee802154_sub_if_data *sdata,
>   	local->beacon.mhr.fc.source_addr_mode = IEEE802154_EXTENDED_ADDRESSING;
>   	atomic_set(&request->wpan_dev->bsn, -1);
>   	local->beacon.mhr.source.mode = IEEE802154_ADDR_LONG;
> -	local->beacon.mhr.source.pan_id = cpu_to_le16(request->wpan_dev->pan_id);
> -	local->beacon.mhr.source.extended_addr = cpu_to_le64(request->wpan_dev->extended_addr);
> +	local->beacon.mhr.source.pan_id = request->wpan_dev->pan_id;
> +	local->beacon.mhr.source.extended_addr = request->wpan_dev->extended_addr;
>   	local->beacon.mac_pl.beacon_order = request->interval;
>   	local->beacon.mac_pl.superframe_order = request->interval;
>   	local->beacon.mac_pl.final_cap_slot = 0xf;

This patch has been applied to the wpan-next tree and will be
part of the next pull request to net-next. Thanks!

regards
Stefan Schmidt

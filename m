Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38D6C5B4CA4
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 10:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbiIKIgE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 11 Sep 2022 04:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiIKIft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 04:35:49 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90DAE3123A
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 01:35:43 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-269-TZ8FUoXYOmOqVVZ__SK0Fw-1; Sun, 11 Sep 2022 04:35:28 -0400
X-MC-Unique: TZ8FUoXYOmOqVVZ__SK0Fw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC2BF85A589;
        Sun, 11 Sep 2022 08:35:27 +0000 (UTC)
Received: from hog (unknown [10.39.192.71])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A02D4011A37;
        Sun, 11 Sep 2022 08:35:26 +0000 (UTC)
Date:   Sun, 11 Sep 2022 10:35:17 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Emeel Hakim <ehakim@nvidia.com>
Cc:     dsahern@kernel.org, netdev@vger.kernel.org, raeds@nvidia.com,
        tariqt@nvidia.com
Subject: Re: [PATCH main v4 1/2] macsec: add Extended Packet Number support
Message-ID: <Yx2dxUxOt1Dlpy7f@hog>
References: <20220908105338.30589-1-ehakim@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <20220908105338.30589-1-ehakim@nvidia.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022-09-08, 13:53:37 +0300, Emeel Hakim wrote:
> This patch adds support for extended packet number (XPN).
> XPN can be configured by passing 'xpn on' as part of the ip

"cipher ..."

> link add command using macsec type.
> In addition, using 'xpn' keyword instead of the 'pn', passing a 12
> bytes salt using the 'salt' keyword and passing short secure channel
> id (ssci) using the 'ssci' keyword as part of the ip macsec command
> is required (see example).
> 
> e.g:
> 
> create a MACsec device on link eth0 with enabled xpn
>   # ip link add link eth0 macsec0 type macsec port 11
> 	encrypt on xpn on

                   cipher ...

[...]
> @@ -392,9 +439,21 @@ static int do_modify_nl(enum cmd c, enum macsec_nl_commands cmd, int ifindex,
>  	addattr8(&req.n, MACSEC_BUFLEN, MACSEC_SA_ATTR_AN, sa->an);
>  
>  	if (c != CMD_DEL) {
> -		if (sa->pn)
> -			addattr32(&req.n, MACSEC_BUFLEN, MACSEC_SA_ATTR_PN,
> -				  sa->pn);
> +		if (sa->xpn) {
> +			if (sa->pn.pn64)
> +				addattr64(&req.n, MACSEC_BUFLEN, MACSEC_SA_ATTR_PN,
> +					  sa->pn.pn64);
> +			if (sa->salt[0] != '\0')

                        if (sa->salt_set)

> +				addattr_l(&req.n, MACSEC_BUFLEN, MACSEC_SA_ATTR_SALT,
> +					  sa->salt, MACSEC_SALT_LEN);
> +			if (sa->ssci != 0)

                        if (sa->ssci_set)

> +				addattr32(&req.n, MACSEC_BUFLEN, MACSEC_SA_ATTR_SSCI,
> +					  sa->ssci);
> +		} else {
> +			if (sa->pn.pn32)
> +				addattr32(&req.n, MACSEC_BUFLEN, MACSEC_SA_ATTR_PN,
> +					  sa->pn.pn32);
> +		}

[...]
> @@ -1251,6 +1339,7 @@ static void usage(FILE *f)
>  		"                  [ send_sci { on | off } ]\n"
>  		"                  [ end_station { on | off } ]\n"
>  		"                  [ scb { on | off } ]\n"
> +		"                  [ xpn { on | off } ]\n"

That should be the new "cipher" options instead of "xpn on/off".

>  		"                  [ protect { on | off } ]\n"
>  		"                  [ replay { on | off} window { 0..2^32-1 } ]\n"
>  		"                  [ validate { strict | check | disabled } ]\n"

-- 
Sabrina


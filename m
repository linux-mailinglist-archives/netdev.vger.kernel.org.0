Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1107663D7A
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 11:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbjAJKDg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 10 Jan 2023 05:03:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjAJKDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 05:03:34 -0500
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A4B213EBE
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 02:03:32 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-300-g0e5gVBzOh2XIatw6JC35g-1; Tue, 10 Jan 2023 05:03:28 -0500
X-MC-Unique: g0e5gVBzOh2XIatw6JC35g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 074361C05B0F;
        Tue, 10 Jan 2023 10:03:28 +0000 (UTC)
Received: from hog (unknown [10.39.192.162])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C553492C18;
        Tue, 10 Jan 2023 10:03:27 +0000 (UTC)
Date:   Tue, 10 Jan 2023 11:02:03 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     ehakim@nvidia.com
Cc:     dsahern@kernel.org, netdev@vger.kernel.org,
        Raed Salem <raeds@nvidia.com>
Subject: Re: [PATCH main 1/1] macsec: Fix Macsec replay protection
Message-ID: <Y703mx5EEjQyH8Fu@hog>
References: <20230110080218.18799-1-ehakim@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <20230110080218.18799-1-ehakim@nvidia.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2023-01-10, 10:02:19 +0200, ehakim@nvidia.com wrote:
> @@ -1516,7 +1515,7 @@ static int macsec_parse_opt(struct link_util *lu, int argc, char **argv,
>  		addattr_l(n, MACSEC_BUFLEN, IFLA_MACSEC_ICV_LEN,
>  			  &cipher.icv_len, sizeof(cipher.icv_len));
>  
> -	if (replay_protect != -1) {
> +	if (replay_protect) {

This will silently break disabling replay protection on an existing
device. This:

    ip link set macsec0 type macsec replay off

would now appear to succeed but will not do anything. That's why I
used an int with -1 in iproute, and a U8 netlink attribute rather a
flag.

I think this would be a better fix:

 	if (replay_protect != -1) {
-		addattr32(n, MACSEC_BUFLEN, IFLA_MACSEC_WINDOW, window);
+		if (replay_protect)
+			addattr32(n, MACSEC_BUFLEN, IFLA_MACSEC_WINDOW, window);
 		addattr8(n, MACSEC_BUFLEN, IFLA_MACSEC_REPLAY_PROTECT,
 			 replay_protect);
 	}

Does that work for all your test cases?


>  		addattr32(n, MACSEC_BUFLEN, IFLA_MACSEC_WINDOW, window);
>  		addattr8(n, MACSEC_BUFLEN, IFLA_MACSEC_REPLAY_PROTECT,
>  			 replay_protect);

-- 
Sabrina


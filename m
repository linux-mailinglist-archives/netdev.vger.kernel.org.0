Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3448567A5C5
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 23:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234090AbjAXWbq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 24 Jan 2023 17:31:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234279AbjAXWbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 17:31:38 -0500
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2135146705
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 14:31:14 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-344-h69YeciuPSm_sN0j0A52WQ-1; Tue, 24 Jan 2023 17:31:10 -0500
X-MC-Unique: h69YeciuPSm_sN0j0A52WQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 00FDB2932488;
        Tue, 24 Jan 2023 22:31:10 +0000 (UTC)
Received: from hog (unknown [10.39.192.162])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BF9CE39D92;
        Tue, 24 Jan 2023 22:31:08 +0000 (UTC)
Date:   Tue, 24 Jan 2023 23:29:35 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Ilya Lesokhin <ilyal@mellanox.com>,
        Dave Watson <davejwatson@fb.com>, netdev@vger.kernel.org
Subject: Re: Setting TLS_RX and TLS_TX crypto info more than once?
Message-ID: <Y9Bbz60sAwkmrsrt@hog>
References: <A07B819E-A406-457A-B7DB-8926DCEBADCD@holtmann.org>
MIME-Version: 1.0
In-Reply-To: <A07B819E-A406-457A-B7DB-8926DCEBADCD@holtmann.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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

Hi Marcel,

2023-01-24, 18:48:56 +0100, Marcel Holtmann wrote:
> Hi Ilya,
> 
> in commit 196c31b4b5447 you limited setsockopt for TLS_RX and TLS_TX
> crypto info to just one time.

Looking at commit 196c31b4b5447, that check was already there, it only
got moved.

> 
> +       crypto_info = &ctx->crypto_send;
> +       /* Currently we don't support set crypto info more than one time */
> +       if (TLS_CRYPTO_INFO_READY(crypto_info))
> +               goto out;
> 
> This is a bit unfortunate for TLS 1.3 where the majority of the TLS
> handshake is actually encrypted with handshake traffic secrets and
> only after a successful handshake, the application traffic secrets
> are applied.
> 
> I am hitting this issue since I am just sending ClientHello and only
> reading ServerHello and then switching on TLS_RX right away to receive
> the rest of the handshake via TLS_GET_RECORD_TYPE. This works pretty
> nicely in my code.
> 
> Since this limitation wasn’t there in the first place, can we get it
> removed again and allow setting the crypto info more than once? At
> least updating the key material (the cipher obviously has to match).
> 
> I think this is also needed when having to do any re-keying since I
> have seen patches for that, but it seems they never got applied.

The patches are still under discussion (I only posted them a week ago
so "never got applied" seems a bit harsh):
https://lore.kernel.org/all/cover.1673952268.git.sd@queasysnail.net/T/#u

-- 
Sabrina


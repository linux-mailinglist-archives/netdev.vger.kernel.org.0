Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB7374EC5E9
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 15:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346299AbiC3NsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 09:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241785AbiC3NsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 09:48:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8846EA27E0
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 06:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648647988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eLaIWlVraYrzqJO20OFbs4aqtDs0LbbZo1X56L7veGw=;
        b=VN7BmB8UpzzktEljPsAxZVUjXLJocd+CuyPskIKsqYE1+/b25wIN1MMxmQL2HJ2erPhEX5
        pEGMOTognU+ttcbcZNw9B5PXyFXnqYeaxKhE0nwZ/lbRFQJTmL4RLJnexOaeRvAdCimmNG
        3Tg6I7zwfOcK5AIxtdnte0AhiSKida4=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-197-bgyvHyauOnKezI5QJN2dTw-1; Wed, 30 Mar 2022 09:46:27 -0400
X-MC-Unique: bgyvHyauOnKezI5QJN2dTw-1
Received: by mail-ej1-f70.google.com with SMTP id do20-20020a170906c11400b006e0de97a0e9so4801354ejc.19
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 06:46:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=eLaIWlVraYrzqJO20OFbs4aqtDs0LbbZo1X56L7veGw=;
        b=M4RFvDjCSnVtnxg+oiMCRrAN0QPupNKyGJlPnhcUhdfl1mIjl6GkvtxWk32/jo0SC4
         VwMUyv3Wa0yt0zzyIdbKYHvedqtqsqeQ5QuZcPh/dU+dF+0qOzMW7s8vaxOgt734/DGZ
         Sz6GLkQEUIliM3YisulyNg66CHWTIdNrYDFh3Zr76hkIflJwbwD7V1Vf6pGq8cgliXEu
         wfYAJ3/JxjMSV1Iry5PHCvXU71UJ21tBJ6Ijq9QTLHK1wPSW8Hnjg6ONGTY4E2qWNnHD
         fayLsFf+tH6yp2mJ7YvBk6CsPWMAxlNrQeUSk6APjrD7WN1hVzT75+eVja1xEm3luYwt
         KgfA==
X-Gm-Message-State: AOAM532tVQhwESN/6gUE2Cs66Y6EK7SQXfIzTirL2k7NicN62ORCthYR
        HQDShj4UGylH8J3eDgINFXnonXygO3Q3Zceu7At6CJ5sc/iJGN4JHRjLFYa0Kd2JhmQO05ScS8g
        ct3tcBkil/mMkgwZ/
X-Received: by 2002:a17:907:3e94:b0:6d1:d64e:3141 with SMTP id hs20-20020a1709073e9400b006d1d64e3141mr38837472ejc.213.1648647983280;
        Wed, 30 Mar 2022 06:46:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzwZ63UhP/cjX55N9lQpIVsi+7QnOIup8W+4kphWmkl+wmSx/opVSXEvOLQomDj9Q5DThyhIw==
X-Received: by 2002:a17:907:3e94:b0:6d1:d64e:3141 with SMTP id hs20-20020a1709073e9400b006d1d64e3141mr38837371ejc.213.1648647982108;
        Wed, 30 Mar 2022 06:46:22 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id jg22-20020a170907971600b006df9ff416ccsm8073801ejc.137.2022.03.30.06.46.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 06:46:21 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E1D9A240E87; Wed, 30 Mar 2022 15:46:20 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        'Linux Kernel' <linux-kernel@vger.kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Kurt Cancemi <kurt@x64architecture.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: UBSAN: invalid-load in net/mac80211/status.c:1164:21
In-Reply-To: <892635fbacdc171baba2cba1b501f30b6a4faeca.camel@sipsolutions.net>
References: <395d9e22-8b28-087a-5c5d-61a43db527ac@gmail.com>
 <892635fbacdc171baba2cba1b501f30b6a4faeca.camel@sipsolutions.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 30 Mar 2022 15:46:20 +0200
Message-ID: <87bkxn4kpf.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2022-03-30 at 18:49 +0700, Bagas Sanjaya wrote:
>> 
>> [ 1152.928312] UBSAN: invalid-load in net/mac80211/status.c:1164:21
>> [ 1152.928318] load of value 255 is not a valid value for type '_Bool'
>
>
> That's loading status->is_valid_ack_signal, it seems.
>
> Note how that's in a union, shadowed by the 0x00ff0000'00000000 byte of
> the control.vif pointer (if I'm counting bytes correctly). That's kind
> of expected to be 0xff.
>
>> [ 1152.928323] CPU: 1 PID: 857 Comm: rs:main Q:Reg Not tainted 5.17.1-kernelorg-stable-generic #1
>> [ 1152.928329] Hardware name: Acer Aspire E5-571/EA50_HB   , BIOS V1.04 05/06/2014
>> [ 1152.928331] Call Trace:
>> [ 1152.928334]  <TASK>
>> [ 1152.928338]  dump_stack_lvl+0x4c/0x63
>> [ 1152.928350]  dump_stack+0x10/0x12
>> [ 1152.928354]  ubsan_epilogue+0x9/0x45
>> [ 1152.928359]  __ubsan_handle_load_invalid_value.cold+0x44/0x49
>> [ 1152.928365]  ieee80211_tx_status_ext.cold+0xa3/0xb8 [mac80211]
>> [ 1152.928467]  ieee80211_tx_status+0x7d/0xa0 [mac80211]
>> [ 1152.928535]  ath_txq_unlock_complete+0x15c/0x170 [ath9k]
>> [ 1152.928553]  ath_tx_edma_tasklet+0xe5/0x4c0 [ath9k]
>> [ 1152.928567]  ath9k_tasklet+0x14e/0x280 [ath9k]
>
> Which sort of means that ath9k isn't setting up the status area
> correctly?

Yeah, it seems to be only setting fields individually, so AFAICT it's
skipping 'antenna' and 'flags' in info->status.

>> The bisection process, starting from v5.17 (the first tag with the warning),
>> found first 'oops' commit at 837d9e49402eaf (net: phy: marvell: Fix invalid
>> comparison in the resume and suspend functions, 2022-03-12). However, since
>> the commit didn't touch net/mac80211/status.c, it wasn't the root cause
>> commit.
>
> Well you'd look for something in ath9k, I guess. But you didn't limit
> the bisect, so not sure why it went off into the weeds. Maybe you got
> one of them wrong.
>
>> The latest commit that touch the file in question is commit
>> ea5907db2a9ccf (mac80211: fix struct ieee80211_tx_info size, 2022-02-02).
>
> That's after 5.17 though, and it replaced the bool by just a flag.
>
>
> Seems to me ath9k should use something like
> ieee80211_tx_info_clear_status() or do the memset by itself? This bug
> would now not be reported, but it might report the flag erroneously.

So something like the below, maybe?

-Toke

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index d0caf1de2bde..425fe0df7d62 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2553,6 +2553,8 @@ static void ath_tx_rc_status(struct ath_softc *sc, struct ath_buf *bf,
        struct ath_hw *ah = sc->sc_ah;
        u8 i, tx_rateindex;
 
+       ieee80211_tx_info_clear_status(tx_info);
+
        if (txok)
                tx_info->status.ack_signal = ts->ts_rssi;
 


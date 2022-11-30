Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD58F63E307
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 23:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiK3WBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 17:01:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiK3WBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 17:01:17 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C45F7E415;
        Wed, 30 Nov 2022 14:01:16 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id n20so44671542ejh.0;
        Wed, 30 Nov 2022 14:01:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/XIHXbor+I8fmm71WeYjxkJYsXNm6XYVch/G1n4efNY=;
        b=HH3NlTjvoNOzY4km/62k+VS5yrNSlv1vda53o+xXrQiE11bpyynQH99WhlXY0TOW2d
         59okSZB2FCLaVoNJ6ZuQ1xxVgGpf3tt8zSgb6K0+j+HXfVzN3G77P/Jh1R3FwKZ7EepO
         2wX+RCaRObp2j6K0Lpwf2+Al7yXcOs5rKViIKU4KhDNc8zdytz33c2CFT0Z90kEoCY8u
         GNxuL+ftiUsRm9yOPRitRhi15WSA69k/An+RcVt6owdpzZA82lL/X+T0pqg1/MlAwKQ5
         jU+mZf7VDM5BggThrz6egZgx140mEPzYS3IB29nNRofk0v4jM9KY79OGisZqIGpx5D1y
         2xOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/XIHXbor+I8fmm71WeYjxkJYsXNm6XYVch/G1n4efNY=;
        b=fvC7vnO26odFgQtw7cYzm1jsP5/WmLZvwXakDp4TotcdLAjxy+x1ms1ChscOWcGIsY
         r71JlmXgFHtsY4AjeCBJmC+pIHixEnK7UDeqeDI5D/36wOYPkWkw6kBB7LRtL6EuTZqX
         i4pPbIwbKsZQJ/KFtdf4m8O04YUMoyPAJOTOx9v8p16ylweAfinxwAUDAuTuIVldL5iG
         Ieoxm9NaZjPD/02dMES5mbcZq7iTdFV+67zViBqyE0B4xV+VErlTmBCxA4JvmPkFFvzj
         5Z8j45lYoUsp/zujzj6r52f81+9zbR+uoCTluOBdgaM14ucwpAovlt2ax5BKsMZ+Awed
         txfA==
X-Gm-Message-State: ANoB5pnv7dQE4BhNd3cw+L1NcktT4GUaN/AThO0ZGDgKc10dXGsCS04M
        /kvrmkoGiwOZ+8EEUI9wo8g=
X-Google-Smtp-Source: AA0mqf4y0DCvaVUbC1mhybCjAO03BlY2qqw3Y+DNQzkkkcYsf7OLMeNLSTAJ9eqOj/cPsc9fbE/HbA==
X-Received: by 2002:a17:906:9618:b0:7ae:38a:fd with SMTP id s24-20020a170906961800b007ae038a00fdmr53995359ejx.501.1669845674597;
        Wed, 30 Nov 2022 14:01:14 -0800 (PST)
Received: from skbuf ([188.26.184.222])
        by smtp.gmail.com with ESMTPSA id ay17-20020a056402203100b00461e4498666sm1041466edb.11.2022.11.30.14.01.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 14:01:14 -0800 (PST)
Date:   Thu, 1 Dec 2022 00:01:11 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Yuri Karpov <YKarpov@ispras.ru>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH] net: dsa: fix NULL pointer dereference in seq_match()
Message-ID: <20221130220111.zfrzckiyayaoka3z@skbuf>
References: <20221130084431.3299054-1-YKarpov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130084431.3299054-1-YKarpov@ispras.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 11:44:31AM +0300, Yuri Karpov wrote:
> ptp_parse_header() result is not checked in seq_match() that can lead
> to NULL pointer dereferense.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Fixes: c6fe0ad2c349 ("net: dsa: mv88e6xxx: add rx/tx timestamping support")
> Signed-off-by: Yuri Karpov <YKarpov@ispras.ru>
> ---
>  drivers/net/dsa/mv88e6xxx/hwtstamp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/hwtstamp.c b/drivers/net/dsa/mv88e6xxx/hwtstamp.c
> index 331b4ca089ff..97f30795a2bb 100644
> --- a/drivers/net/dsa/mv88e6xxx/hwtstamp.c
> +++ b/drivers/net/dsa/mv88e6xxx/hwtstamp.c
> @@ -246,7 +246,7 @@ static int seq_match(struct sk_buff *skb, u16 ts_seqid)
>  
>  	hdr = ptp_parse_header(skb, type);
>  
> -	return ts_seqid == ntohs(hdr->sequence_id);
> +	return hdr ? ts_seqid == ntohs(hdr->sequence_id) : 0;

NACK.

ptp_parse_header() will never return NULL when called from seq_match().
The skb comes from mv88e6xxx_get_rxts(), which takes it from ps->rx_queue.
It was put there by mv88e6xxx_port_rxtstamp(), which prior to that, had
a check for ptp_parse_header() returning NULL in mv88e6xxx_should_tstamp().

Please don't just blindly trust your tools.

>  }
>  
>  static void mv88e6xxx_get_rxts(struct mv88e6xxx_chip *chip,
> -- 
> 2.34.1
> 

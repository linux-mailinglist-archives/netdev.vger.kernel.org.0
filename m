Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95FCE57884F
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 19:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234873AbiGRR1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 13:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235216AbiGRR1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 13:27:18 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D282C65F;
        Mon, 18 Jul 2022 10:27:17 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id y8so16291567eda.3;
        Mon, 18 Jul 2022 10:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EoTOnF8+BQ4jX+Je4snS7CaqxRcOM/nvOCrGWCBRShE=;
        b=jvggYwu2iLLZd+UoIPVHdWJ1hjWn8JQ7koCTdROfPgZJQcac0wjLX8ATrx/PYF9JZK
         /ttQPEk7sHT0lFEhpZEQVCHfSwRJVaHDBLXq/L5TgiMY+e+Exag9uvzJV2fZFd/mC5Gw
         42s/F4uK05RUBk5enyCH/+CAB1pFegC5JjUqTYg7YlK3fABVAcqtpYlEwRomsJSW+xj3
         GpNu7+InlPosbHQ3Rz6/JW04kkRfzCyqDGpHSfS/ZL2yKENJmD6g8jw9ofkQ1jYYqfcH
         8CPsdcPNkD7rLlS5gcGs5xmLmKo2ARgryM2o3EXtf5cBU03ulvTrgSm/onYRZzKYaux4
         Swgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EoTOnF8+BQ4jX+Je4snS7CaqxRcOM/nvOCrGWCBRShE=;
        b=lRMZUptFR6dmplemiCX4tXRACNME5yBQWxb23MG2ZyPBFn9UXcn27k7yTHpOd+KACH
         O9BEwLGPLLKzkczbqITtNqhoXPUflaqNJdNogITL7oLq5VyGOCiHUBGP9nQa6acCR1On
         vGRv27kpoYK1f84bJpCTVEsE6rb7IrIxQG5XTdYhxjRSHSKRQ/f6+p3LY7CGdRgvQQli
         sSnBHzm0swzDOOvoWsixVNBh1XlS+2dZ4yAkNQoTxZeGlinLtsWYLNHVmhNaTVUcC+k2
         qp2wxL19DLUklyYhj1HI2yHxEg8DT8q5Tk8XSbyGeDVJm6PGA3psBShPH98R4MCE+FTd
         C4ww==
X-Gm-Message-State: AJIora/I+Vz3DSeCvLmI5j+heBQCipcfrBnwlF1uBUewAkbURL/BX169
        i2PAgMhxPZpqqONmW6gKO7c=
X-Google-Smtp-Source: AGRyM1uY+ZTpE45Ky67ovCgqNkR34m/gxiK51Faq3FqDH4fAl7U+CWO0hN6T4xd0dK+q+JTmHPKaBA==
X-Received: by 2002:a05:6402:26d5:b0:43a:bf2a:c27b with SMTP id x21-20020a05640226d500b0043abf2ac27bmr38901180edd.61.1658165235540;
        Mon, 18 Jul 2022 10:27:15 -0700 (PDT)
Received: from skbuf ([188.25.231.190])
        by smtp.gmail.com with ESMTPSA id b3-20020a17090630c300b00726abf9cd8esm3778475ejb.125.2022.07.18.10.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 10:27:14 -0700 (PDT)
Date:   Mon, 18 Jul 2022 20:27:12 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 3/4] net: dsa: qca8k: rework mib autocast
 handling
Message-ID: <20220718172712.xlrcnel6njflmhli@skbuf>
References: <20220716174958.22542-1-ansuelsmth@gmail.com>
 <20220716174958.22542-1-ansuelsmth@gmail.com>
 <20220716174958.22542-4-ansuelsmth@gmail.com>
 <20220716174958.22542-4-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220716174958.22542-4-ansuelsmth@gmail.com>
 <20220716174958.22542-4-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 16, 2022 at 07:49:57PM +0200, Christian Marangi wrote:
> In preparation for code split, move the autocast mib function used to
> receive mib data from eth packet in priv struct and use that in
> get_ethtool_stats instead of referencing the function directly. This is
> needed as the get_ethtool_stats function will be moved to a common file.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---

Can this change be deferred until there actually appears a second
implementation of (*autocast_mib)?

> diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
> index 22ece14e06dc..a306638a7100 100644
> --- a/drivers/net/dsa/qca/qca8k.h
> +++ b/drivers/net/dsa/qca/qca8k.h
> @@ -403,6 +403,7 @@ struct qca8k_priv {
>  	struct qca8k_mdio_cache mdio_cache;
>  	struct qca8k_pcs pcs_port_0;
>  	struct qca8k_pcs pcs_port_6;
> +	int (*autocast_mib)(struct dsa_switch *ds, int port, u64 *data);

Typically we hold function pointers in separate read-only structures rather
than in the stateful private structure of the driver, see struct sja1105_info,
struct felix_info, struct mv88e6xxx_info and mv88e6xxx_ops, struct b53_io_ops,
etc etc.

>  };
>  
>  struct qca8k_mib_desc {
> -- 
> 2.36.1
> 


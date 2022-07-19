Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADD357A0BE
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238067AbiGSOJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237690AbiGSOIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:08:34 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5E445996;
        Tue, 19 Jul 2022 06:25:16 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id w12so19530573edd.13;
        Tue, 19 Jul 2022 06:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wZSYPDwNek2d+Y0tE6luu21kFrDHA1gQjppwBT1lk7Q=;
        b=ZPd2kyLxVV14ieSljEYIqQB//P3qzRTg6QGFL0B8ySm0XmhGlchfN9evuqMH6MuaJp
         ijTrhyEfBeWz21n42DUJdSAA43/1iQ6BhfyhPJvlyHa4wTZHUqAyqwZP3VKXxyW4MoMr
         0ugKF1f0OC9ndUeEkVLjav2BHbVZzwwCVkfH+O1glNSVIPSyNhVw4XBIh1xh1bIv762S
         Eqiu7JOgAHv3bwtajT9YJJm9mqA1zNq4tGRFfh2ebuzZXyy4XonTDe2tFXXxb0AtTUJY
         wcXQlUptvcZPvOJM3+4/Q7KF5cEdqw1k9VUxM4JMSz8yeHCzu8H4fo5v3ei8H6NLxm4N
         gM7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wZSYPDwNek2d+Y0tE6luu21kFrDHA1gQjppwBT1lk7Q=;
        b=Y7xk678GjhI7al8rFbK2iRbLuTJGcDjIhYdJJ2bf3gqqErfT5VuuYTUrNAUw46NwN0
         /3s6BusS5f9gbySJ5RkzjOtPGG8/NYshPPJHPsLccLgOcOvA5FVytMhcmlIRdaRbi6ev
         leO0tbClRiA+cIoFUFXKw9WysNaaKW+cZgGGzn9e3RhNpgb384dSBycrmKyGaL0OvXS/
         +dy3btNxNnOVaeVJ0jRwCyh+PLF1T3cvL7jDdJG/n3Ii+ZeXquW0rYJQDMSVuXfAnICo
         Ng5+wnCGJmitrcWkq++z20VqlSoAqKxxfUyZ9299KcPXESV/dGU+D0/vjnIzWJ0Q8zlh
         Kgiw==
X-Gm-Message-State: AJIora8Wknd/RNOKBM7ZmEQ5jWwwIsqJTkh2+VHY6+W8VzeiJG3AB+qy
        nobpgGRnsLQihjC5gjh/HDgIls1Kps21qA==
X-Google-Smtp-Source: AGRyM1v2m2/iMKzP+dNmusw/9BEWnzI8DvOkWmKJwURuZ9hB1j6gDKuoImbmLznOiLLSscAc2p8ctA==
X-Received: by 2002:a50:fe89:0:b0:43b:22af:4c8b with SMTP id d9-20020a50fe89000000b0043b22af4c8bmr36404028edt.296.1658237115162;
        Tue, 19 Jul 2022 06:25:15 -0700 (PDT)
Received: from skbuf ([188.27.185.104])
        by smtp.gmail.com with ESMTPSA id q18-20020a056402033200b0043ab866b9e1sm10444272edw.65.2022.07.19.06.25.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 06:25:14 -0700 (PDT)
Date:   Tue, 19 Jul 2022 16:25:12 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next PATCH v2 12/15] net: dsa: qca8k: move port VLAN
 functions to common code
Message-ID: <20220719132512.vbzugx5sjnjilmfd@skbuf>
References: <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-14-ansuelsmth@gmail.com>
 <20220719005726.8739-14-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719005726.8739-14-ansuelsmth@gmail.com>
 <20220719005726.8739-14-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 02:57:23AM +0200, Christian Marangi wrote:
> The same port VLAN functions are used by drivers based on qca8k family
> switch. Move them to common code to make them accessible also by other
> drivers.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

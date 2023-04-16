Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6B9D6E3A5F
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 18:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjDPQ7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 12:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDPQ7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 12:59:10 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374D89C;
        Sun, 16 Apr 2023 09:59:09 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-5058181d58dso3468361a12.1;
        Sun, 16 Apr 2023 09:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681664347; x=1684256347;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TIb2D7rkDuhVLUrXFOEDDaK8FmVcbl4NoqztV2OGIZc=;
        b=gWokLH6gyE17z0PxP29Pf8sUePU/6QPbYQLUFuz2fWGjdQWParpPoT0LHjfWp7sU3+
         5yCXMWI4PXjosQohNeTY3lHXFEBNAESIfN9PmnJHXlnnvHhv5DuD1zHWz6V8HqdtC63U
         AWSssn1IL5EH0hH2l7F1dNc5lN0yb7b0NtoYcs8rdDp9nSy9OTH/fWLqGTEF7ChjEUIa
         xEwT57dhEJron80zoyDiSyDNRllTwmTrmkEJKF3psf/xedoCkjfe0fcU06S6kif6Ec9K
         +FsOS6PphAXnf0AsED6upty6rrMMV1vBjbwNkvqP32ZJgmXv/4c2BJibPaVJVKVdPRdK
         3wEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681664348; x=1684256348;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TIb2D7rkDuhVLUrXFOEDDaK8FmVcbl4NoqztV2OGIZc=;
        b=bwmDtdZNnbpMPi+kmpipNeDpCjaQl1DshSvyF+OjY9Ac93tGpDYWQO9HxtgoqQrUGv
         Zccs3qyzODyP+CghJsbjxuEhcETl5Ybr/GhisRYrXKt4DcyyGU/KA0O/Y8z/+QT1FjRe
         EMRhnS3El0S++NcXYRV+I8yYvCQVNylQFTVnY/b3vcVTfCFITFmsxpFVj88cs0qzU2Un
         62hqqID58NRvOslDMKASGcuGpJmAdyfFFgzERGgIEWrWQ6JZcrlY/A4DeEebe78EstWI
         qDe0UoJkbj/hWyk4Q2hZxEZqosZLY3HzPoq+00czbAgTtEd4nFFtZGj5TmAXIIDsBzLO
         ngzQ==
X-Gm-Message-State: AAQBX9fXBPtKSn2323TbMUdY3v5MykU2sLAC9vyAAYFeLXl/1RHvtXxJ
        4is/dHlFu7tPEKjMieiAt/U=
X-Google-Smtp-Source: AKy350b2/xS/9E1LcasLyAMeaL9y0hl61phjzAGwURZgjG4mZS1i7UZieXTZUICOsQTAHMHvgqZgmg==
X-Received: by 2002:aa7:d74f:0:b0:504:adc2:80da with SMTP id a15-20020aa7d74f000000b00504adc280damr11421732eds.18.1681664347426;
        Sun, 16 Apr 2023 09:59:07 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id g3-20020aa7c843000000b005029c47f814sm4663732edt.49.2023.04.16.09.59.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Apr 2023 09:59:06 -0700 (PDT)
Date:   Sun, 16 Apr 2023 19:59:04 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v1 2/2] net: dsa: microchip: Add partial ACL
 support for ksz9477 switches
Message-ID: <20230416165904.2y7zwgyxwltjzj7m@skbuf>
References: <20230411172456.3003003-1-o.rempel@pengutronix.de>
 <20230411172456.3003003-3-o.rempel@pengutronix.de>
 <20230413042936.GA12562@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230413042936.GA12562@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 06:29:36AM +0200, Oleksij Rempel wrote:
> According to KSZ9477S 5.2.8.2 Port Priority Control Register
> "To achieve the desired functionality, do not set more than one bit at a
> time in this register.
> ...
> Bit 6 - OR’ed Priority
> ...
> Bit 2 - 802.1p Priority Classification
> Bit 1 - Diffserv Priority Classification
> Bit 0 - ACL Priority Classification
> "
> @Arun  what will happen if multiple engines are used for packet
> prioritization? For example ACL || Diffserv || 802.1p... ?
> If I see it correctly, it is possible but not recommended. Should I
> prevent usage of multiple prio sources? 

You could try and find out which one takes priority... we support VLAN
PCP and DSCP prioritization through the dcbnl application priority table.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0215751DD
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 17:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239376AbiGNPfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 11:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbiGNPfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 11:35:08 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BBB9474C9
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 08:35:07 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id l23so4106305ejr.5
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 08:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/AQRuSAnohAK753u3pXAMITpPrUHDOravLzbWrRgYfI=;
        b=bpJXIKZgHvN0u0JC2Au2IiX+3DR6pmvyf1Avj2tku5jwdb492841+hoPzWYx+YpCO+
         zQSJup0oVowAV6YnSD1g/gzaicfKu3TowK57bstdjNRCYsl4/QBCENInIO8Q2lPyoWUs
         Ch99165b8C6neQh6bhLy2OGDBTr14TaQD8er+Gq6Td6B4MeF5kZsY/StCLNAdxL8RPcm
         BCR/yAmolt0/2RdMdv2cwsR79TnLUW6ugxRfrTQPine05/YlnlNel8ZEy5MHMUO4r4cc
         DuLHk85Tk29Gs3PQD+TeHU9QabL9vXRg7d0gwQD+AWrZ5oI6pW+Bp31dFeMgqePK8+6l
         Aepw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/AQRuSAnohAK753u3pXAMITpPrUHDOravLzbWrRgYfI=;
        b=ltinbJYz6XjCnVYDJmCvZSdiuS2QfgC7YYI2rFFGNWo2khhGHpRIHZuvQWt+IiMsUh
         qOh92rimmgl+w+hQpkUPuaYpUaDwNrKvUANb9ibXJk1263AHqm67SVNuOQvKt8kmD6Xb
         S9MFLTC84YWRjPWoDet1kQNtlTrTdx0R2BR7O7IRnHQj8uwXtmnJKTfLbxHdDUfUB4/B
         w355QitE3OOUFJv58c4rRRdat1bQar0ZX0EBN4CQsDbTqZe5qNd7LlfFHz61iV2aKWo0
         9NzxL3verHQezP0jRuykmFnPpEDQSuQcQXh1izDvPQTcmBRDMgo9aOhHFas332ZTAes+
         tN6g==
X-Gm-Message-State: AJIora/fEuwJyk1Zs9Zq6tJegf08QUIggy9zzGDQ1e1S8lStJh5KXDFe
        yRhXipKlIczV9szXoZ4QWQk=
X-Google-Smtp-Source: AGRyM1ticUgO49zYFzqdxH65+Ehp9XYUAgeU6HueP/+mnyrjDvgM0IddHokBGp8ApuBLfsC1UmPexw==
X-Received: by 2002:a17:906:974c:b0:72b:8cea:95c2 with SMTP id o12-20020a170906974c00b0072b8cea95c2mr9322190ejy.65.1657812906075;
        Thu, 14 Jul 2022 08:35:06 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id gr19-20020a170906e2d300b0070abf371274sm819757ejb.136.2022.07.14.08.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 08:35:05 -0700 (PDT)
Date:   Thu, 14 Jul 2022 18:35:03 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Liang He <windhl@126.com>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: dsa: microchip: ksz_common: Fix refcount leak bug
Message-ID: <20220714153503.qxopsztagc6yb72o@skbuf>
References: <20220714153138.375919-1-windhl@126.com>
 <20220714153138.375919-1-windhl@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220714153138.375919-1-windhl@126.com>
 <20220714153138.375919-1-windhl@126.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 14, 2022 at 11:31:38PM +0800, Liang He wrote:
> In ksz_switch_register(), we should call of_node_put() for the
> reference returned by of_get_child_by_name() which has increased
> the refcount.
> 
> Fixes: 912aae27c6af ("net: dsa: microchip: really look for phy-mode in port nodes")
> Signed-off-by: Liang He <windhl@126.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

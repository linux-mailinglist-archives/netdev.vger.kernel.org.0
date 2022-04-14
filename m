Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C35605010D9
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 16:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343747AbiDNNu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 09:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345200AbiDNNpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 09:45:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 38E6C5FE4
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 06:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649943779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cEwU1k8RkWbHuBpGrcJSmZWxIQf9wx4CSSVAzVNcIcQ=;
        b=ZLcgSWeM8QtZkU9ae04DMJ2myjV4G3DNBxL5Lhd0cQjwBAmwozJq0ZlXRqlCFxX1gf/Lt6
        0ghdps+DuqWQNsLL+cAJL5I2LMn99cpcB3IhC0e/Dsn71A2jT2GVjb79HxnOxaoDtm7Vl6
        9kwGcoAyKlA16hDjNrQQtU7mXAag/ko=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-567-YY5GCbFyOiawbxP5Cm5IGA-1; Thu, 14 Apr 2022 09:42:58 -0400
X-MC-Unique: YY5GCbFyOiawbxP5Cm5IGA-1
Received: by mail-wm1-f70.google.com with SMTP id g13-20020a1c4e0d000000b0038eba16aa46so2253603wmh.7
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 06:42:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=cEwU1k8RkWbHuBpGrcJSmZWxIQf9wx4CSSVAzVNcIcQ=;
        b=Hc5lZZ6drf0EDkZ7DpEGgAwYAByVLWH0D9EwPQocuL3Q8rNHWuBek+aVekGPl2/PwX
         8WgKxfBXAagCZEFz9/dMbek09t4xEasRuqZAqhudKFPI1zRinhKkTuZDZxy9GsCga3gh
         F/ji71QOfZpKRHFVEDlkd4YLE4TxRIg6r1co91ysRNn9X+fEORm38sVyMeY7rRqeqBSq
         ZAkgmldRWb0sjyAYQIwfZmXYubRQq5RmbDL+CTgXE3QEzg8l7HyJseDu5R6l2/Pbg2rJ
         bcvPJ+C8oRBiDIvjvs8Y8DsLlmwa2Tl4TrPXC3TddC4jkbEWdeJAPFYF02wJMdnwlm8R
         Oeeg==
X-Gm-Message-State: AOAM5329dplSHqTjfs6m3XiJj+QptZMzSOZIjDD3u5+aBu1inXyT4KaG
        sLThZ3EjR9ReqM/KG1KJfeU7zVwUaVzfx161yQ9m+MFNGNte5KCwoC6gzlihbVSaTXsYM2cwkl2
        LtES3ZdeKABfp95Xk
X-Received: by 2002:adf:f783:0:b0:207:a8ce:c155 with SMTP id q3-20020adff783000000b00207a8cec155mr2222987wrp.258.1649943776973;
        Thu, 14 Apr 2022 06:42:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwPeHlNz+XH8pGgX+QQTKvuDAR0AtbdicT3vCkba0paOH9TIMgYj+vx/KybA6X1K9UK6B5gJA==
X-Received: by 2002:adf:f783:0:b0:207:a8ce:c155 with SMTP id q3-20020adff783000000b00207a8cec155mr2222971wrp.258.1649943776771;
        Thu, 14 Apr 2022 06:42:56 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-96-237.dyn.eolo.it. [146.241.96.237])
        by smtp.gmail.com with ESMTPSA id e14-20020a5d6d0e000000b002078ea4f6bdsm2166780wrq.75.2022.04.14.06.42.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 06:42:56 -0700 (PDT)
Message-ID: <7f9ae4f7c484d16e8f9a923f2facee95a720a62b.camel@redhat.com>
Subject: Re: [net-next PATCH v2 1/4] drivers: net: dsa: qca8k: drop MTU
 tracking from qca8k_priv
From:   Paolo Abeni <pabeni@redhat.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 14 Apr 2022 15:42:55 +0200
In-Reply-To: <20220412173019.4189-2-ansuelsmth@gmail.com>
References: <20220412173019.4189-1-ansuelsmth@gmail.com>
         <20220412173019.4189-2-ansuelsmth@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-04-12 at 19:30 +0200, Ansuel Smith wrote:
> DSA set the CPU port based on the largest MTU of all the slave ports.
> Based on this we can drop the MTU array from qca8k_priv and set the
> port_change_mtu logic on DSA changing MTU of the CPU port as the switch
> have a global MTU settingfor each port.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

@Vladimir: it looks like this addresses your concern on the previous
iteration, could you please have a look?

Thanks!

Paolo


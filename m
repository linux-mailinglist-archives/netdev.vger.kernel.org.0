Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA79E6DF30C
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 13:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbjDLLTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 07:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbjDLLTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 07:19:14 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE8A7AB3;
        Wed, 12 Apr 2023 04:18:51 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id dm2so27961687ejc.8;
        Wed, 12 Apr 2023 04:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681298276; x=1683890276;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=j1rD/EKlAM2QobKZRdWuKD2WYCE7Wayo1AHNpbxop9Q=;
        b=dMf/tdeLCWYDPxppNVuuvxlsNmLdxbynLHseAz+jPQ9hRu88zbH0VHMT4G2Y9L5f4k
         r49IUdwpKbmbArnFI+pygbpECgPVl2cGxKqM8xyz9o/irOScR22HLmKtVzVHVNAXJ/Op
         kQiOo6/ZJKT0mk+6TUaNNxQ9lEy71nQz9ZjefheFOxunFpl+yckNHDFVMLgSmfy/FhZZ
         33nvruMK4NjUs9V6D2Cy3UMxoVAk2yakBlITCDXCRFGE7jbebHTrNXwgyJA3G2w3RM84
         DK7mt1yD0998x4d8ITlLmMaq3PzyZf0NRRx3vam3V70Q+ePz8qSWDMrn/btSqa+96AJ+
         yULA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681298276; x=1683890276;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j1rD/EKlAM2QobKZRdWuKD2WYCE7Wayo1AHNpbxop9Q=;
        b=oGLuExw+qf5fFMnZQlt7tYhcJr2U1CAlLZCuIDrbfCACHmJc6n6HE5sZht16FoouOG
         x0cWE+ppi79leb+pUBHueRb3fpSN4qhuB/57ayjW5t2V8xu8unNP8CIOcSC7LMPh+WLf
         rbMuwQHIZODXz0CnyWuR78IuWmtSc2kJlv+d0DNMWBsNkdzCChYia7vQbyfMS13ry3+Y
         g2tVMf3KUbvDZWuzp1/NEJHAQIffGb7KEevNbCurXmC1OThFiy/UFQIFDOvz9mipVJ4a
         ajtkAtpc6UZGWNTXEQ9PcoxGv4dHLYMVq3n8+GjKdUd7+r/DHsBBIWCW6N4/4zebwo5y
         KlQQ==
X-Gm-Message-State: AAQBX9fEguni/m6x5HXtY0Xu/T8OYAQ2K7vhX2rV1vZQoZSTqDRdFp9K
        G5bVE+DHxnXdq1/U67b54dI=
X-Google-Smtp-Source: AKy350akEW91z/suHsYQnndS0oJ6188mIM2+Z3A9u5zo+96wZsMsdFHW7LKgsB8rrSM375M9B73lLg==
X-Received: by 2002:a17:906:7309:b0:94d:a68a:139c with SMTP id di9-20020a170906730900b0094da68a139cmr7493624ejc.51.1681298275560;
        Wed, 12 Apr 2023 04:17:55 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id n19-20020a1709067b5300b008f89953b761sm7094185ejo.3.2023.04.12.04.17.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 04:17:55 -0700 (PDT)
Date:   Wed, 12 Apr 2023 14:17:52 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v2 1/7] dt-bindings: net: dsa: mediatek,mt7530: correct
 brand name
Message-ID: <20230412111752.bl2ekd7pirbyvnue@skbuf>
References: <20230407125008.42474-1-arinc.unal@arinc9.com>
 <20230411235749.xbghzt7w77swvhnz@skbuf>
 <80d4a841-db7c-fa2b-e50d-84317ee54a40@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <80d4a841-db7c-fa2b-e50d-84317ee54a40@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 09:36:32AM +0300, Arınç ÜNAL wrote:
> On 12.04.2023 02:57, Vladimir Oltean wrote:
> > Hi Arınç,
> > 
> > On Fri, Apr 07, 2023 at 03:50:03PM +0300, arinc9.unal@gmail.com wrote:
> > > From: Arınç ÜNAL <arinc.unal@arinc9.com>
> > > 
> > > The brand name is MediaTek, change it to that.
> > > 
> > > Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> > > Acked-by: Daniel Golle <daniel@makrotopia.org>
> > > Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> > > ---
> > 
> > It is good practice for series larger than 2 patches to create a cover
> > letter, which gives the overview for the changes. Its contents gets used
> > as the merge commit description when the series is accepted.
> 
> Ok, will do on the next version. I'll also split the schema while at it.

Ok. I wasn't sure if you and Krzysztof were in agreement about that, so
this is why I didn't mention it. FWIW, it's also pretty unreviewable to
me too.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38C286D7B4E
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 13:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237781AbjDEL3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 07:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237413AbjDEL3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 07:29:07 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8AA61FFE;
        Wed,  5 Apr 2023 04:28:57 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id er13so99216612edb.9;
        Wed, 05 Apr 2023 04:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680694136;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=T5eAJVoqmmI7lTCLbPh2e296K+euo10TqUqJzhersgI=;
        b=fXyLG972/NY4uXU909bYoiJAUtMYNzJ9moIn5qqM/xeZk6E6LyWg2Rr6f2N0B9cI2p
         8SlD03RZyRt+G+e1ue+DpuJ9NgKBWCAOVbltb6jAvz8NFKCKepcDFGDKEQ/FCC9Sl7MN
         ZsbvyeDro1lDU987pPOU+Pm8nuCbF9V52LGK74p4MmjbCF+tP6wvHoy4ad9RVa/ZdeOB
         CrSiq75+8W7Tc0wMr2fKvY4l49/zqhmdgoeZrokk4g3VAqgrKt3T4fQFhQKldmkNDibN
         kG2yEuEQruFWTI6+j1FYwF/EXc+w1LxYQuW/qqpLz0n/7QCVg7MYYS4OqoafEVJSTe22
         8ooA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680694136;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T5eAJVoqmmI7lTCLbPh2e296K+euo10TqUqJzhersgI=;
        b=uZO1Joot6pv/S5a1DAYnLCXunVknaSHMzEbm42mhXWDmJPbwjyRdrncyLPfdgD7OGj
         XWxhAwwGuiEqAwfkD1wi+mTxK0e69UoRMpY7tfU3nqt8gIAjzmyPdwQD6RQEshpW0WYh
         mQbfl+e5N7cBh+cBhgMKgvEP7gvh0bsvDIKcZmsgNf/jE9uLA//eunNxRHV7qIaNPi6N
         lJP7DJrW06HJ992OnxqZhYGIUNqltLD5MkPIUWV0vl5bnccnYskWmjWhbNHQFA4wzCH1
         Uwn9ZeO27PW5U8iTH4zLmiEfPqgDQK1KAWSKpsrHB4jg7Hc2QNIzbeYSDVwZWKFk6FQR
         8rCA==
X-Gm-Message-State: AAQBX9cTST06JPssgwUjwz9oODf5UApwX3XN/KPab39dkFXxqoSmKkKU
        mkigXa9nHIPEtCK32ehuYJRbvbQOK8RETA==
X-Google-Smtp-Source: AKy350aso3okZsidvo7XA1g1M3bGESXKSPp6WNIsrHhdE4t98PuILhLEPrlBukKNoAZwg6HuHqomcQ==
X-Received: by 2002:a17:906:52c3:b0:944:6d88:206 with SMTP id w3-20020a17090652c300b009446d880206mr2720247ejn.71.1680694136003;
        Wed, 05 Apr 2023 04:28:56 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id ss5-20020a170907038500b00933c52c2a0esm7357914ejb.173.2023.04.05.04.28.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 04:28:55 -0700 (PDT)
Date:   Wed, 5 Apr 2023 14:28:53 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: ethernet-switch: Make
 "#address-cells/#size-cells" required
Message-ID: <20230405112853.v7eqmiganvxtn5ge@skbuf>
References: <20230404204213.635773-1-robh@kernel.org>
 <20230404204213.635773-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404204213.635773-1-robh@kernel.org>
 <20230404204213.635773-1-robh@kernel.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 03:42:13PM -0500, Rob Herring wrote:
> The schema doesn't allow for a single (unaddressed) ethernet port node
> nor does a single port switch make much sense. So if there's always
> multiple child nodes, "#address-cells" and "#size-cells" should be
> required.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

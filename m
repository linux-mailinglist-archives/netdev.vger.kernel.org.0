Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4E25805C5
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 22:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236746AbiGYUgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 16:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbiGYUgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 16:36:37 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1871FCC0
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 13:36:36 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id m8so15437027edd.9
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 13:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5ZXQlPzbh+bKDtdawhPEBkuPEMfrkEc8RscneuGCQYI=;
        b=KaFz4hsnXHdfhXgA2W27UqLg4DGvlW0hl7yxIymeomCp6B+0yls1HjNCYnOAQX9tVO
         FqHZhX9+uZwNP2HfU3+/8P3uJTJ/Ufh3d2Q68XHneP9ENqfr7eeiZwGztpgZZNad/lMX
         ak4rWd88rMqhcA86UR8gi4G2xWHI356eXFqtjQuaC/2rNoVh3NOI+k836EQTsUKHS6ZO
         Qp8wgkekjsOI0orF8vbFXgipzxu55x0gY3L49Wcoga92+D5Pa8oxppfnXtLEFHbRWfKz
         SrTq2fSTsqIISboEHyZ/BLRADvORZw1IIq6lp/uu3YE1zMT+aPTzpiHZE6YcaQAf5ilN
         UwNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5ZXQlPzbh+bKDtdawhPEBkuPEMfrkEc8RscneuGCQYI=;
        b=YmCzLBVvrEdKtM22/RRBYRLm9iCEAXEXD0IdCszXLex9v9qjIZbyglFtkQDUz8gNaA
         eTrnJsN8lHiTRanaSc/hNTlRxmbVSkv5v3J2r3YD6fqykWwXUslUZZqXeQSQEQu9GIYM
         cmpJC6+mYC2BtnD44qMoKrGeJrr15WthUhsWj3LWpEi7dz/rcAI3U81d4yqj+9VcGciX
         RDs2YiIFT/BWWRoJfnnytPPQ4Yapke7AJSdqAIhOzjH2678Scomj3nZuzsuYqcvrPmT/
         swJqI3gDi5Iuc/JQN0/Bzr08IlHFPw1xLn6aV/YWgfW4rBiyGseH5ps6CF8ObJ00oLtB
         Dymg==
X-Gm-Message-State: AJIora+FKLU4NNmsR46xy7DPkECjQv7drB7KvoIM93TY2/n6afQgyDLS
        osSlI6K9JVXraiRRrClM4RezYLvJGuE9TA==
X-Google-Smtp-Source: AGRyM1sKHa5wZEaOCTgLU5P50W4px5ZH4qxDzeyLBgkYFtotpSegp0UkdeqEdLVLCADoKCrV5RzZ1w==
X-Received: by 2002:a05:6402:1c01:b0:43a:f714:bcbe with SMTP id ck1-20020a0564021c0100b0043af714bcbemr15045487edb.14.1658781394783;
        Mon, 25 Jul 2022 13:36:34 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id n18-20020a05640205d200b0043b7917b1a4sm7641311edx.43.2022.07.25.13.36.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 13:36:33 -0700 (PDT)
Date:   Mon, 25 Jul 2022 23:36:30 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next] ip6mr: remove stray rcu_read_unlock() from
 ip6_mr_forward()
Message-ID: <20220725203630.6dtoemizkcsri355@skbuf>
References: <20220725200554.2563581-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220725200554.2563581-1-eric.dumazet@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 25, 2022 at 01:05:54PM -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> One rcu_read_unlock() should have been removed in blamed commit.
> 
> Fixes: 9b1c21d898fd ("ip6mr: do not acquire mrt_lock while calling ip6_mr_forward()")
> Reported-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6378A60ECAD
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 01:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbiJZXfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 19:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233420AbiJZXfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 19:35:13 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4325A17C
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 16:35:11 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id c2so7579997plz.11
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 16:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gLcPzEXf4odUPvUGgvaRHpAOwG1S59SIsqqBWy9JOQQ=;
        b=l0JvrG88RBplo657qf5m5r4NJ9zrW0Yi4+Kkwf5VM2P8eccDh276cLzeyyIUGeQhHP
         62EqjPn32JoITQiCsUw4Q5JVRqrfH8zc1wVAXBrdRFRbEJo3boq3xarWHrfv25d5D7bW
         oFCvJNrgJQLAlN+YoPPGKMlFJAHcBxwO3nscs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gLcPzEXf4odUPvUGgvaRHpAOwG1S59SIsqqBWy9JOQQ=;
        b=UkIGG9dHVDcnb0CE2fz2cRbIVZKNGfmm/YuOvhl/n1n9rS4qOPn6jw0qtoPMvdePSW
         NpQOZptn4K1bl44kXuYZw/y2e6lFdcf/JFFty37h1H1XmDxRfy0TZXelTwuaIrXHvyXY
         0uXdCxrx6pkJDoGAtExGkTAxfnBK1tbOteue1yqp1oXEjNIc3KI2CrmQ1cKeR3Rb8num
         MCkgqGzSc4hP8yICy//nPPSU57YbqoK3x/G9Y0Zame6Q2WCTuU866CuR7BeUfE9huGLV
         Qv9/cfJ3bvp4cgQo4xOFIacI1Kjf9ffBwtwEDiLPCCu7zbZESiKEoFdQmxYfgeg59f4F
         dagg==
X-Gm-Message-State: ACrzQf3oMEqahYji5nIMJHlyGAsrkHA4QZvkid/PQQC5VmisqBtuZQHH
        qtDIAdrDyKMl3L7LLtTND7s8Hg==
X-Google-Smtp-Source: AMsMyM7AQC4Ij0/MLXLbrXBKi3SgAN3An4Q5U0AhyTIJeRSSLRopC/hRi1JhSCZHAX60HhFIhMNARA==
X-Received: by 2002:a17:902:b945:b0:181:c6b6:abc with SMTP id h5-20020a170902b94500b00181c6b60abcmr46674601pls.75.1666827311343;
        Wed, 26 Oct 2022 16:35:11 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id s15-20020a170902ea0f00b00182a9c27acfsm3423185plg.227.2022.10.26.16.35.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 16:35:10 -0700 (PDT)
Date:   Wed, 26 Oct 2022 16:35:09 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net-next] netlink: split up copies in the ack construction
Message-ID: <202210261634.9DA43B2F@keescook>
References: <20221026210430.2036464-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221026210430.2036464-1-kuba@kernel.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 26, 2022 at 02:04:30PM -0700, Jakub Kicinski wrote:
> Clean up the use of unsafe_memcpy() by adding a flexible array
> at the end of netlink message header and splitting up the header
> and data copies.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Looks good to me. Thanks for this refactoring. :)

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook

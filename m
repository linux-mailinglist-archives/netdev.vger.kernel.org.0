Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 703D06BC026
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 23:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbjCOWwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 18:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232481AbjCOWwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 18:52:40 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3278123642
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 15:52:06 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id iw3so4892046plb.6
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 15:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112; t=1678920724;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Djv5OHuSBMMmlx35xiXRNBf7Q5cAUobzFYrXajasQoA=;
        b=Y+Q+4MxAsQJB5ql+QZZVern/F5atMi3XzZTyQUCf0c0tcp5od0Go8PwXLL7nSvXuV5
         0c47I0Xcj/0i4Q40GPQT5Xp+SzhjwQer7hydVojgaWTjoiBfLywphKU8/kzGC//cTaVw
         eH5eG2nXE7tXdlHQIFF24jLlmqzDP0LPcjtN8CYVNpAaQayCyzZKlysOqZB+ZUdk2Y5F
         hnYcR5Zc5WHF84jlGS0ZX0jMhqo+TwCsBfp+sig60fFbMCPDW2+lEwySgAbF0iCymtml
         sPuHHIRD/yZxVi++GsXnnO+k6yoURWETbe5Jiq5de1cD+AYRpLmAGEfnG2pXEZR+2bTk
         MA9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678920724;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Djv5OHuSBMMmlx35xiXRNBf7Q5cAUobzFYrXajasQoA=;
        b=zm+3aasx03ZEJHzI0Rc9Z6IeQEleE5PaoeMDFRxOLS4J+sljVFxjGxAPNhudRCQ4Px
         lWwbSh8KRpWsEFsysYP0imDa7OmkSA6vOzXPEepK/8uasAI5MylgHZ67zWknUWolRKp+
         wGh2jp4zlPbo6akSvgn/Qesc0Jl7uP/1ZBL+mbwakBb0STGwqOtxLVxijnROxLYOqLWl
         Rb9yaCmU0dPguFzENbfT1HwsGaqsvJbadIzXFxwLoEHcNg3Yl5i8v+XgL7BQtlC45Hw/
         LW5VwVKp5p3gFvFunoWh373HZt19RTPUwswCnzGBlnEZChtqMREIwbNJv0aMYGsgtlo5
         8G5Q==
X-Gm-Message-State: AO0yUKXvn6PQg7tawxyGjCN0HDj7nVVh4ZpkZ0rIq/ekAX34cZ9LdqDU
        7Mz09g66+U9lAD8ABJzzecq2UA==
X-Google-Smtp-Source: AK7set+tRFJoMGo5vh0984+ntTqPEuWYTBLjQJ7xSgE7XqAplge1i3vTpKThP/ki4T00wQbLYn+yBQ==
X-Received: by 2002:a17:90a:1c6:b0:231:24c1:8028 with SMTP id 6-20020a17090a01c600b0023124c18028mr1473644pjd.29.1678920723984;
        Wed, 15 Mar 2023 15:52:03 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id ml17-20020a17090b361100b002311dbb2bc5sm1891377pjb.45.2023.03.15.15.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 15:52:03 -0700 (PDT)
Date:   Wed, 15 Mar 2023 15:52:02 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, corbet@lwn.net,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] docs: networking: document NAPI
Message-ID: <20230315155202.2bba7e20@hermes.local>
In-Reply-To: <20230315223044.471002-1-kuba@kernel.org>
References: <20230315223044.471002-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Mar 2023 15:30:44 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> Add basic documentation about NAPI. We can stop linking to the ancient
> doc on the LF wiki.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: jesse.brandeburg@intel.com
> CC: anthony.l.nguyen@intel.com
> CC: corbet@lwn.net
> CC: linux-doc@vger.kernel.org

The one thing missing, is how to handle level vs edge triggered interrupts.
For level triggered interrupts, the re-enable is inherently not racy.
I.e re-enabling interrupt when packet is present will cause an interrupt.
But for devices with edge triggered interrupts, it is often necessary to
poll and manually schedule again. Older documentation referred to this
as the "rotten packet" problem.

Maybe this is no longer a problem for drivers?
Or maybe all new hardware uses PCI MSI and is level triggered?

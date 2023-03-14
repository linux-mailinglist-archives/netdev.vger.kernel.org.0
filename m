Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4484C6B8E9B
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 10:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbjCNJX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 05:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCNJXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 05:23:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0DA96F06
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 02:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678785766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cFRNy5N9S2sgSusBxuEVHEyQgmwhV9DuaTWAUcQupT8=;
        b=OV7nWDVxWwIIgTZ3zHPfr8LlfFhNxDNoc9Uxv/9+DBWQtpy2KimD7GtmelDLEZRxFg65m+
        LaQSkikol809IBS/xMcf1zDFoBkiFcIts/rBwf2SfJYuPm2NqkCpcw2expJZ2UnUN0Q7Kc
        A3CPSPzniD9Yzjik3WkcYcDcCgn6Mx4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-7-vxTPLX6mP4ynnhcyQ1a3xA-1; Tue, 14 Mar 2023 05:22:44 -0400
X-MC-Unique: vxTPLX6mP4ynnhcyQ1a3xA-1
Received: by mail-wr1-f69.google.com with SMTP id 7-20020a5d47a7000000b002be0eb97f4fso2507987wrb.8
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 02:22:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678785758;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cFRNy5N9S2sgSusBxuEVHEyQgmwhV9DuaTWAUcQupT8=;
        b=wDttD3KM+yJ4bOia2Z/4+JzcAgdXYMuBi6Xw9wizRmxPnu2pBg6sTxDG+NIsb0gF4P
         oNS8p/Xv4ePg+zt4qPwFMpzjnOG825EpAptOE2t0/Kih8zY+RqHa3GXSReoQOV5Rgpyj
         FmjUrcql0Tw/8ZeBBkBX/sEcKzAFJfvyJcyTYDPQkhI2rtBYBTsEo6HPR1U9TwTiLzxU
         yGN9lmSUF6EOWVDeEvydDDVVArLA7U2+abPwaPEkJf4CAIJ0styjOY8k04bpPJ2CN1CN
         pL+kKKK1WqdTvNxK51jY/n7eH8uYJSf/SHcO3YPnPDkanSFSe7zTVTSVn1e2Ioz4AcZD
         amSQ==
X-Gm-Message-State: AO0yUKXBrIwEtPJhX58LnSc0bMJUpFkvuCZD1JwfNf1kmAkZ2MIWV2Ia
        eIO9ZW8Tz0jm1EojuvwBiYbYMBrsxzV8o2LY1HFUrrR4MUZ2ZBIaD+Xf66r+fi9ljxkxI8hHSvB
        JFDcutySgRswyjgcq
X-Received: by 2002:a05:600c:a49:b0:3ed:2dc4:c6cb with SMTP id c9-20020a05600c0a4900b003ed2dc4c6cbmr990393wmq.6.1678785758736;
        Tue, 14 Mar 2023 02:22:38 -0700 (PDT)
X-Google-Smtp-Source: AK7set8K3OdSzJqdzJIsPizTljJbOz800NEorRCL3ZWkVbOsBJgbfTds8oevrrzUexZ3rTi8H50SZw==
X-Received: by 2002:a05:600c:a49:b0:3ed:2dc4:c6cb with SMTP id c9-20020a05600c0a4900b003ed2dc4c6cbmr990378wmq.6.1678785758477;
        Tue, 14 Mar 2023 02:22:38 -0700 (PDT)
Received: from localhost (net-37-119-203-146.cust.vodafonedsl.it. [37.119.203.146])
        by smtp.gmail.com with ESMTPSA id f1-20020adfe901000000b002ceaa0e6aa5sm1544793wrm.73.2023.03.14.02.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 02:22:37 -0700 (PDT)
Date:   Tue, 14 Mar 2023 10:22:37 +0100
From:   Davide Caratti <dcaratti@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Marcelo Leitner <mleitner@redhat.com>,
        Phil Sutter <psutter@redhat.com>
Subject: Re: [PATCH iproute2 2/2] tc: m_action: fix parsing of
 TCA_EXT_WARN_MSG by using different enum
Message-ID: <ZBA83TPixc6nqNvD@dcaratti.users.ipa.redhat.com>
References: <20230314065802.1532741-1-liuhangbin@gmail.com>
 <20230314070841.1533755-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314070841.1533755-1-liuhangbin@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 03:08:41PM +0800, Hangbin Liu wrote:
> We can't use TCA_EXT_WARN_MSG directly in tc action as it's using different
> enum with filter. Let's use a new TCA_ACT_EXT_WARN_MSG for tc action
> specifically.
> 
> Fixes: 6035995665b7 ("tc: add new attr TCA_EXT_WARN_MSG")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Reported-and-tested-by: Davide Caratti <dcaratti@redhat.com>

thanks!
-- 
davide



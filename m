Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34B936B8E80
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 10:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbjCNJV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 05:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbjCNJVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 05:21:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4E098EA2
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 02:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678785628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=23fJto2gkft8/oNMFUcPB2L7MDsvHrA3Pm91t/UPgJE=;
        b=LZp0v8+rEglvcUrp7S7vF3By0nRFkEcr5YYsNEM0VWp5XWYqJSKKMs0ZKdyd46Fy7/tdmw
        Kf6a1EpiH6G0+gXfPWtltXx+xwJi+jJ/ZB61HC0vi+0Q/ASeaesZCpnpJD0Vlqg3fdwl+U
        SOe6CEQ9QE1AMKtt1VgCVIH2NqnFQAU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-284-VuK9eLZxOBOLWFQ1TxnH8w-1; Tue, 14 Mar 2023 05:20:26 -0400
X-MC-Unique: VuK9eLZxOBOLWFQ1TxnH8w-1
Received: by mail-wr1-f72.google.com with SMTP id r14-20020a0560001b8e00b002cdb76f7e80so2527868wru.19
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 02:20:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678785626;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=23fJto2gkft8/oNMFUcPB2L7MDsvHrA3Pm91t/UPgJE=;
        b=uWiiLDGN6btX62jtMggKl+eCD6q6jwX5Vv0BylQrvEy90qmP5i5A2+/vOYTwOgXfK3
         Hf/VLGkWCOY7AF7IZOtHviAj2/Ih6MciImX7demrBRFy3t3z848GOnGGUNzX0OKrPZE5
         DG40rsfmZHb80wjYP575V6IqzWhuv3x/JiKgM3jMeK3DD8lSeCJpyLJG0R68IOxuqIPn
         4rx/T6tceA/v/RMgt1hEgDEpuoESWpUfYhZPSGnrgJpfUXabPHIOOC16MeQikkZXXeDm
         YC/J4uYV1tO6bzOtGznNG0zOAH6yPVLIn5WLwQM5IUYPP92IIFbGOnF1Gw2oN5AbTjay
         eJbw==
X-Gm-Message-State: AO0yUKW5wj4K7k/agZvOh41+BuAtaFzFUz6UcsCoNao93g5p8DotonTB
        a/oeKzkzT6H2zkAlBA2vy8AcwWtG+BNZ3QR7k6hZveZHjJtM2bUTl99b08kCnxwP+4rPOdLoyIZ
        EHwUaGWgx3lWinlnV
X-Received: by 2002:a05:600c:384b:b0:3ea:f6c4:5f3c with SMTP id s11-20020a05600c384b00b003eaf6c45f3cmr13765062wmr.7.1678785625820;
        Tue, 14 Mar 2023 02:20:25 -0700 (PDT)
X-Google-Smtp-Source: AK7set9PeSJjynA+AFzm+ZruFJB1gfXSsOsQ8yXgi9JPVkIYSav5khG9PuLgXKl0vpn5/UvGfC7n8A==
X-Received: by 2002:a05:600c:384b:b0:3ea:f6c4:5f3c with SMTP id s11-20020a05600c384b00b003eaf6c45f3cmr13765029wmr.7.1678785625474;
        Tue, 14 Mar 2023 02:20:25 -0700 (PDT)
Received: from localhost (net-37-119-203-146.cust.vodafonedsl.it. [37.119.203.146])
        by smtp.gmail.com with ESMTPSA id q17-20020a05600c46d100b003dc1d668866sm2368816wmo.10.2023.03.14.02.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 02:20:24 -0700 (PDT)
Date:   Tue, 14 Mar 2023 10:20:24 +0100
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
Subject: Re: [PATCH net 0/2] net/sched: fix parsing of TCA_EXT_WARN_MSG for
 tc action
Message-ID: <ZBA8WD1FBtT3mpRn@dcaratti.users.ipa.redhat.com>
References: <20230314065802.1532741-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314065802.1532741-1-liuhangbin@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 02:58:00PM +0800, Hangbin Liu wrote:
> In my previous commit 0349b8779cc9 ("sched: add new attr TCA_EXT_WARN_MSG
> to report tc extact message") I didn't notice the tc action use different
> enum with filter. So we can't use TCA_EXT_WARN_MSG directly for tc action.

Reported-and-tested-by: Davide Caratti <dcaratti@redhat.com>

thanks!
-- 
davide


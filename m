Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0A236B92C0
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 13:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbjCNMLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 08:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjCNMLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 08:11:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7260017175
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 05:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678795811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BxlJ7GCEg0ghtVLbj4VBv4sR1WWZ5PwOOswb9PumA4Q=;
        b=OPRe7lhRpAjzGSECYizQyxaU3b0X0/u3yEnZ0ESrBOrWTyCEeoOXePZUriOWwccjdwr3Vc
        /W32SGq64NTiTHqTpXZUMydugwkMHJdx8xzJWyheRiFJUVd6nUPpiM32xGdFjNG+cKVf4G
        tlCwLBXdYDEaiqIA6w5kgLrHxLgyu6w=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-33-_wryEtJBMmuKPFkps4LHTg-1; Tue, 14 Mar 2023 08:10:10 -0400
X-MC-Unique: _wryEtJBMmuKPFkps4LHTg-1
Received: by mail-wm1-f69.google.com with SMTP id l23-20020a7bc457000000b003e206cbce8dso5412462wmi.7
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 05:10:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678795808;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BxlJ7GCEg0ghtVLbj4VBv4sR1WWZ5PwOOswb9PumA4Q=;
        b=H3uj2uo+FcT7skrJS1uhbimuEbKH1n6Kt5WXXmuVVfbnY8NXAMiX35HbCx6NE7Nrbz
         yhrMYcCoIPSup5047QNCcGDtXMIXQDJyG+yuJdkBxZqHWTwEnNtgLxtRCYNGG7hAj0KW
         KJUR+eohpiel/aOUAN4D04mw2kjkJStmXNXH1hB+m9uEeF1tQK7VP+0fuyRsiR/V1qha
         LFJebMYd/Jvb4U+I2Fz9x2eNr9sEfE4DQwvY5CIkQmDpUC84W8+4UXeySJfx9snP0Kca
         BEx8rpg1k8eV+NH5/6WLvXBCOqgA/ndTkBXmImlbRIlJ4w/Lpz5Dubcoe/KVoD/QwitM
         Vdfg==
X-Gm-Message-State: AO0yUKUq56oVOoyzeZBHVPDnFxJrKYlubeymYdPXVN34qM609cbOS8CT
        PnypVKenMkxJalv8QN0F84K5d1l63HDSBBLsu7ZkOctWmZHwbTINpBbk+RdG/LqHrKF/w9ty5cR
        di2G8LpQnNBujGzKG
X-Received: by 2002:adf:ef4d:0:b0:2ce:aa62:ff79 with SMTP id c13-20020adfef4d000000b002ceaa62ff79mr5710431wrp.40.1678795808800;
        Tue, 14 Mar 2023 05:10:08 -0700 (PDT)
X-Google-Smtp-Source: AK7set8xIuXXILC/o+3dMHDva2HCOrQN9AP6G6CO5xc/yb4t7OJvSwJMOpxAzpNHkDMnu19nzvxm6w==
X-Received: by 2002:adf:ef4d:0:b0:2ce:aa62:ff79 with SMTP id c13-20020adfef4d000000b002ceaa62ff79mr5710411wrp.40.1678795808525;
        Tue, 14 Mar 2023 05:10:08 -0700 (PDT)
Received: from localhost ([37.161.1.180])
        by smtp.gmail.com with ESMTPSA id e10-20020adffc4a000000b002cfed482e9asm1206649wrs.61.2023.03.14.05.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 05:10:08 -0700 (PDT)
Date:   Tue, 14 Mar 2023 13:10:03 +0100
From:   Andrea Claudi <aclaudi@redhat.com>
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
        Davide Caratti <dcaratti@redhat.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Marcelo Leitner <mleitner@redhat.com>,
        Phil Sutter <psutter@redhat.com>
Subject: Re: [PATCH iproute2 1/2] Revert "tc: m_action: fix parsing of
 TCA_EXT_WARN_MSG"
Message-ID: <ZBBkG3v5K7IEz/zo@renaissance-vector>
References: <20230314065802.1532741-1-liuhangbin@gmail.com>
 <20230314070449.1533298-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314070449.1533298-1-liuhangbin@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 03:04:49PM +0800, Hangbin Liu wrote:
> This reverts commit 70b9ebae63ce7e6f9911bdfbcf47a6d18f24159a.
> 
> The TCA_EXT_WARN_MSG is not sit within the TCA_ACT_TAB hierarchy. It's
> belong to the TCA_MAX namespace. I will fix the issue in another patch.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  tc/m_action.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tc/m_action.c b/tc/m_action.c
> index 6c91af2c..0400132c 100644
> --- a/tc/m_action.c
> +++ b/tc/m_action.c
> @@ -586,7 +586,7 @@ int print_action(struct nlmsghdr *n, void *arg)
>  
>  	open_json_object(NULL);
>  	tc_dump_action(fp, tb[TCA_ACT_TAB], tot_acts ? *tot_acts:0, false);
> -	print_ext_msg(&tb[TCA_ACT_TAB]);
> +	print_ext_msg(tb);
>  	close_json_object();
>  
>  	return 0;
> -- 
> 2.38.1
>

As this patchset misses the cover letter, this covers patch 2/2 as
well.

Reviewed-by: Andrea Claudi <aclaudi@redhat.com>


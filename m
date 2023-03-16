Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7703F6BD338
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 16:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbjCPPTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 11:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjCPPTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 11:19:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3190C2E829
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678979893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1BFYnXLehnqlu0G65IY9tSEjxdhokdjJcAplPbaiqvg=;
        b=EZ0IMkPAN3TchXB44WH90r4t2mU50gitXImP8XhUrpAbpj0mGkydmW1/IyQ85mInZloHLt
        FnhrbVV6GSHj4nNgKSyRxogt9QQha2Do3z6Ln+A1qyKVd6WCIHyTmZW9/sJiiJUiRLv+UU
        puMp2do9MdBmmVWDJm9+/RojiuqocKI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-280-A3MYp7oMOcKfXeSGxKFovQ-1; Thu, 16 Mar 2023 11:18:12 -0400
X-MC-Unique: A3MYp7oMOcKfXeSGxKFovQ-1
Received: by mail-wm1-f72.google.com with SMTP id o42-20020a05600c512a00b003ed26fa6ebdso792301wms.7
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:18:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678979890;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1BFYnXLehnqlu0G65IY9tSEjxdhokdjJcAplPbaiqvg=;
        b=5OUPQWXEg+O1fAuxs740ErFtuyYzjo/dU//KLOeV8ytyxWS2mLox1SzmTWw2E6tLFw
         bX69oMocsqBN6kGU6iWe8ViW3ejDhRp2CHlHhOkrHFXB3kyep/TaN24fhl2VDpWvoGPS
         ndcfNvBON7+xudVVFVT0+eHTba88P7qrxmRDW6Fcpd8PZZOZaypw9dvBWWwiV9YpqCE2
         K46acePiJ/zc5oCWq3+tHIje2NgJSWBAhCs8OZpyCuI9CuelD2CQC/Gh+D+gNTt9cqae
         RyQzdftbj+6Gr9naqdU7Xn8OZBaemYY/VXRTZ/sHY2tVN8plrNzkysGCKd7KUUQeFVdw
         lm4Q==
X-Gm-Message-State: AO0yUKUb3DNlh4MpLV19laCxUmocypzF2rdVZ8dM/fYoDL/mCNbl56bC
        jDbKuhKNfsgfGKDvFLL1/4VDboKsPjWfDJk5hXuLyePcW3CrRmWaD+mK7TU02yZMjFUZzBivtpq
        ARuvmER3bozAwoWbDfUxuEPSgESk=
X-Received: by 2002:a05:600c:25d1:b0:3ed:316d:668d with SMTP id 17-20020a05600c25d100b003ed316d668dmr6752613wml.5.1678979890762;
        Thu, 16 Mar 2023 08:18:10 -0700 (PDT)
X-Google-Smtp-Source: AK7set/+pkHL3AJlNQWDSwUDwQB6GEn8lLhs0TrIsHEtxDOZOGdvPs92A/AHBfE/7WfkgJanGg+PJg==
X-Received: by 2002:a05:600c:25d1:b0:3ed:316d:668d with SMTP id 17-20020a05600c25d100b003ed316d668dmr6752589wml.5.1678979890462;
        Thu, 16 Mar 2023 08:18:10 -0700 (PDT)
Received: from localhost ([37.162.3.177])
        by smtp.gmail.com with ESMTPSA id iz11-20020a05600c554b00b003ed201ddef2sm5455728wmb.2.2023.03.16.08.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 08:18:10 -0700 (PDT)
Date:   Thu, 16 Mar 2023 16:18:06 +0100
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
Subject: Re: [PATCHv2 iproute2 0/2] tc: fix parsing of TCA_EXT_WARN_MSG
Message-ID: <ZBMzLhSouukontVm@renaissance-vector>
References: <20230316035242.2321915-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316035242.2321915-1-liuhangbin@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 11:52:40AM +0800, Hangbin Liu wrote:
> The TCA_EXT_WARN_MSG enum belongs to __TCA_MAX namespace. We can't use it
> in tc action as it use TCA_ROOT_MAX enum. Fix it by adding a new
> TCA_ROOT_EXT_WARN_MSG enum.
> 
> Hangbin Liu (2):
>   Revert "tc: m_action: fix parsing of TCA_EXT_WARN_MSG"
>   tc: m_action: fix parsing of TCA_EXT_WARN_MSG by using different enum
> 
>  include/uapi/linux/rtnetlink.h | 1 +
>  tc/m_action.c                  | 8 +++++++-
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> -- 
> 2.38.1
> 

Reviewed-by: Andrea Claudi <aclaudi@redhat.com>


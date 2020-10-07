Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E4F2862AC
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 17:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728852AbgJGPyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 11:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728847AbgJGPyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 11:54:52 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D531DC061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 08:54:51 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id e17so2772862wru.12
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 08:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dOfUK6IoAGMg0iieddyBbEqhSl/CFIyAsNjh/BaRxSY=;
        b=mssH3YxQJzBzZXaFAf26/H6S0wq97Kcu8+Kpct1hm9ZK5TfSwB3j/dfoh1toOEu5mi
         TaqraQcrt5NV9yblbfIHBF/voS8VC1+fE4Sq36Sy1rip7YAO/l/6pH+cgKbJccfSYsSs
         hC8CAYCeBmOLi6dTlThJc/TVkxjUVIo0C5CtFw4l24/H/H86SJj1rXyH3he/qi/iGp+H
         Urna4vbgBt5sq4IpdToZ3txMVdYf7DNAfhxgKUBU2gCKhrAr1m4Om7VwZ6eSRpU6egPt
         S9bxUqm54A2tbeCdmhmO/nWHS5M2xbxEpcGA4iyoIB7nL8K49XsUodR8U6OwJDqLO8Mz
         LHCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dOfUK6IoAGMg0iieddyBbEqhSl/CFIyAsNjh/BaRxSY=;
        b=HWl9Zs9hiC7OZS+fo7F+v3DOj6vnZfLzLcB9lAraZx4N7/9C3LFnFFwSRpojz9WZdt
         ZETIDkX2JJmAyINkPigBVN1qyInasmWRzyKy/eVg+EcoAxMF+yGJLbnZwbTj/4URWErj
         KqxmNzb4oO3DCV5iVIoANmvpkuhLmvT8nqluaJ/Pn/+d7XIyaudR/SPaGQ6USdAfojwk
         gOMZmBekuBymemP1BRoUQGNXkp4GJJQLtAMrHYPGGgHyBLeJckK/LTiETz81tUHTvAge
         os4O9GSDNiMdXWNonJBdz6ZksIEyFn9Md6Ouisj5p/qBPfH3QqLXJkmTmq/bBWArEm/3
         Qmjw==
X-Gm-Message-State: AOAM530LtlvczRJ9g1ik2yWDeszOA4jeMbT6XBRk9M+GXvO8EGTSxERN
        WTxXvR8ZvhTidLFTGLI0vd7aTW2o5HQ=
X-Google-Smtp-Source: ABdhPJw4T0wSpl4nfzF3QsCgehpvlsHdbm6V2D7c3u3ab5Ds5zuU7Pym5B+kPrrjbC9/+P3FiB3W2g==
X-Received: by 2002:a5d:6547:: with SMTP id z7mr4294251wrv.322.1602086090306;
        Wed, 07 Oct 2020 08:54:50 -0700 (PDT)
Received: from [192.168.8.147] ([37.172.158.5])
        by smtp.gmail.com with ESMTPSA id w11sm3283007wrs.26.2020.10.07.08.54.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2020 08:54:49 -0700 (PDT)
Subject: Re: [PATCH net] macsec: avoid use-after-free in macsec_handle_frame()
To:     Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
References: <20201007084246.4068317-1-eric.dumazet@gmail.com>
 <4544483dd904540cdda04db3d2e2e70bad84efda.camel@redhat.com>
 <CANn89iLcZit_0Og9MbW0x0bQ=-6pz18UpRN6RYOY12Czui1eMQ@mail.gmail.com>
 <e9c835401b45da48559f4f0c9347b60c2b9c0911.camel@redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <942deacf-f850-591f-4273-c3d072912aaf@gmail.com>
Date:   Wed, 7 Oct 2020 17:54:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <e9c835401b45da48559f4f0c9347b60c2b9c0911.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/7/20 4:45 PM, Paolo Abeni wrote:

> Ah! I completely missed that code path in gro_cells_receive()!
> Thank you for pointing that out!
> 
> Acked-by: Paolo Abeni <pabeni@redhat.com>
> 

No problems, thanks for reviewing !
